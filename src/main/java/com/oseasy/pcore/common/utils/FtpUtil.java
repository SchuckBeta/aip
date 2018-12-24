package com.oseasy.pcore.common.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.slf4j.LoggerFactory;

import com.oseasy.pcore.common.config.Global;
import com.oseasy.putil.common.utils.Encodes;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.putil.common.utils.exception.ExceptionUtil;

/**
 * Created by Administrator on 2017/3/21 0021.
 */
public class FtpUtil {
	private static org.slf4j.Logger logger = LoggerFactory.getLogger(FtpUtil.class);
    public static final String FTP_USERNAME = Global.getConfig("ftp.username");
    public static final String FTP_PASSWD = Global.getConfig("ftp.passwd");
    public static final String FTP_URL = Global.getConfig("ftp.url");
    public static final String FTP_HTTPURL = Global.getConfig("ftp.httpUrl");
    public static final Integer FTP_PORT = Integer.valueOf(Global.getConfig("ftp.port"));
    public static final String FTP_MARKER ="@5c319144e8474f329d29ac90a85a44c6";//html代码中ftp路径占位符
    public static final String FTP_DOWNURL="/ftp/ueditorUpload/downFile";//FTP下载链接
    public static String getFtpPath(String url) {
    	if (StringUtil.isNotEmpty(url)&&StringUtil.contains(url,FTP_HTTPURL)) {
    		url=url.replace(FTP_HTTPURL, "");
    		url="/tool"+url;
    	}
    	return url;
    }
	 /**
     * ftp连接
     * @throws IOException
     */
    public static FTPClient getftpClient() {
        FTPClient ftpClient = new FTPClient();
        long startTime = System.currentTimeMillis();
        try {
            ftpClient.connect(FTP_URL, FTP_PORT);
            ftpClient.login(FTP_USERNAME, FTP_PASSWD);
            ftpClient.setFileType(FTPClient.BINARY_FILE_TYPE);
            ftpClient.enterLocalPassiveMode();
            logger.debug("ftpClient获得连接");
        } catch (NumberFormatException e) {
        	logger.error("FTP端口配置错误:不是数字");
        }catch (IOException ioe) {
            ioe.printStackTrace();
        }
        System.out.println("打开ftp连接时间："+(System.currentTimeMillis()-startTime)+"ms");
        return ftpClient;
    }


    /**
     * closeServer
     * 断开与ftp服务器的链接
     * @throws java.io.IOException
     */
    public static void closeServer(FTPClient ftpClient) throws IOException {
    	try {
    		if (ftpClient != null) {
    			ftpClient.disconnect();
    			logger.debug("ftpClient断开连接");
    		}
    	} catch (IOException e) {

    		e.printStackTrace();
    	}
    }
    /**
     * ftp上传单个文件
     * @throws IOException
     */
    public static boolean uploadInputSteam(FTPClient ftpClient,InputStream fis,String directory, String destName) throws IOException {

       // InputStream fis = null;
        boolean result = false;
        try {
            //ftpClient.enterLocalPassiveMode();
            // 设置上传目录
        	boolean isExist = existDirectory(ftpClient,directory);
        	logger.debug("file upload  path is：=============="+destName);
        	//destName = new String(destName.getBytes("gbk2312"), "UTF-8");
            //destName = new String(destName.getBytes("utf-8"), "iso-8859-1");
        	if (!isExist) {
        		mkDirectory(ftpClient,directory);
        	}
        	ftpClient.changeWorkingDirectory(directory);
			ftpClient.setBufferSize(1024);
			ftpClient.setControlEncoding("utf-8");
			  // 设置文件类型（二进制）
			result = ftpClient.storeFile(destName, fis);
            return result;
        } catch (NumberFormatException e) {
            logger.error(ExceptionUtil.getStackTrace(e));
        } catch (FileNotFoundException e) {
            logger.error(ExceptionUtil.getStackTrace(e));
        } catch (IOException e) {
            logger.error(ExceptionUtil.getStackTrace(e));
        } finally {
            IOUtils.closeQuietly(fis);
            try {
                ftpClient.disconnect();
            } catch (IOException e) {
                logger.error(ExceptionUtil.getStackTrace(e));
            }
        }
        return result;
    }


    /**
     * ftp上传单个文件
     *
     * @param ftpUrl      ftp地址
     * @param userName    ftp的用户名
     * @param password    ftp的密码
     * @param directory   上传至ftp的路径名不包括ftp地址
     * @param srcFileName 要上传的文件全路径名
     * @param destName    上传至ftp后存储的文件名
     * @throws IOException
     */
    public static boolean upload(String ftpUrl, String userName, int port,
                                 String password, String directory, String srcFileName, String destName) throws IOException {
        FTPClient ftpClient = new FTPClient();
        FileInputStream fis = null;
        boolean result = false;
        try {
            ftpClient.connect(ftpUrl, port);
            ftpClient.login(userName, password);
            ftpClient.enterLocalPassiveMode();
            File srcFile = new File(srcFileName);
            fis = new FileInputStream(srcFile);
            // 设置上传目录
            logger.info("[upload]设置上传目录::::"+directory);
            ftpClient.changeWorkingDirectory(directory);
            ftpClient.setBufferSize(1024);
            ftpClient.setControlEncoding("utf-8");

            // 设置文件类型（二进制）
            logger.info("[ftpClient.storeFile  destName]:"+destName);
            logger.info("[ftpClient.storeFile  destName]:"+System.getProperty("file.encoding"));
            destName = new String(destName.getBytes( System.getProperty("file.encoding")), "iso-8859-1");
            ftpClient.setFileType(FTPClient.BINARY_FILE_TYPE);
            logger.info("[ftpClient.storeFile  destName]::::"+destName);
            result = ftpClient.storeFile(destName, fis);
            return result;
        } catch (NumberFormatException e) {
            throw e;
        } catch (FileNotFoundException e) {
            throw new FileNotFoundException();
        } catch (IOException e) {
            throw new IOException(e);
        } finally {
            IOUtils.closeQuietly(fis);
            try {
                ftpClient.disconnect();
            } catch (IOException e) {
                throw new RuntimeException("关闭FTP连接发生异常！", e);
            }
        }
    }


    /**
     * FTP单个文件下载
     *
     * @param directory    要下载的文件所在ftp的路径名不包含ftp地址
     * @param destFileName 要下载的文件名
     * @param downloadName 下载后锁存储的文件名全路径
     */
    public static boolean download(FTPClient ftpClient,String directory, String destFileName, String downloadName) throws IOException {
        boolean result = false;
        try {
            ftpClient.enterLocalPassiveMode();
            ftpClient.setBufferSize(1024);
            // 设置文件类型（二进制）
            ftpClient.changeWorkingDirectory(directory);
            //ftpClient.retrieveFileStream(destFileName);
           // InputStream in=ftpClient.retrieveFileStream(destFileName);
        	logger.debug("download file  path："+"destFileName:" + destFileName + ",downloadName:" + downloadName);
            result = ftpClient.retrieveFile(destFileName, new FileOutputStream(downloadName));
            return result;
        } catch (NumberFormatException e) {
            throw e;
        } catch (FileNotFoundException e) {
            throw new FileNotFoundException();
        } catch (IOException e) {
            throw new IOException(e);
        } finally {
            try {
                ftpClient.disconnect();
            } catch (IOException e) {
                throw new RuntimeException("关闭FTP连接发生异常！", e);
            }
        }
    }
    /**
    * FTP单个文件下载
    * fileName 文件名
    * path 文件ftp上地址
    */
    public static boolean downloadFile(FTPClient ftpClient,HttpServletResponse response, String fileName, String path) {
        try {
        	ftpClient.changeWorkingDirectory(path);
            FTPFile[] fs = ftpClient.listFiles();
            logger.debug("下载文件路径："+"destFileName:" + path + ",downloadName:" + fileName);

            for(FTPFile ff: fs) {
                if (ff.getName().equals(fileName)) {
                    response.setHeader("Content-Disposition", "attachment;fileName="+
                    		new String( filenameUrlDecode(ff.getName()).getBytes("utf-8"), "ISO8859-1" )
                    		);
                    OutputStream os = response.getOutputStream();
                    ftpClient.retrieveFile(ff.getName(), os);
                    os.flush();
                    os.close();
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                ftpClient.disconnect();
            } catch (IOException e) {
                throw new RuntimeException("关闭FTP连接发生异常！", e);
            }
        }
        return true;
    }

    /**
     * FTP单个文件下载
     * name 下载的文件名
     * fileName 文件名
     * path 文件ftp上地址
     */
     public static boolean downloadUrlFile(HttpServletResponse response, String name,String realName, String path) {
         FTPClient ftpClient= FtpUtil.getftpClient();
         long startTime = System.currentTimeMillis();
         try {
         	ftpClient.changeWorkingDirectory(path);
             logger.debug("下载文件路径："+"destFileName:" + path + ",downloadName:" + realName+"。文件名："+name);
             response.setHeader("Content-Disposition", "attachment;fileName=\""+//name
                     new String(name.getBytes("utf-8"), "ISO8859-1")+"\""
             );
             OutputStream os = response.getOutputStream();
             ftpClient.retrieveFile(realName, os);
             os.flush();
             os.close();
         } catch (Exception e) {
             e.printStackTrace();
         } finally {
             try {
                 ftpClient.disconnect();
             } catch (IOException e) {
                e.printStackTrace();
             }
         }
         System.out.println("下载时间："+(System.currentTimeMillis()-startTime)+"ms");
         return true;
     }


    /**
     * @param ftpUrl      ftp地址
     * @param userName    ftp的用户名
     * @param password    ftp的密码
     * @param directory   要重命名的文件所在ftp的路径名不包含ftp地址
     * @param oldFileName 要重命名的文件名
     * @param newFileName 重命名后的文件名
     * @throws IOException
     */
    public static boolean rename(String ftpUrl, String userName, int port,
                                 String password, String directory, String oldFileName, String newFileName) throws IOException {
        /**
         * 判断远程文件是否重命名成功，如果成功返回true，否则返回false
         */
        boolean result = false;
        FTPClient ftpClient = new FTPClient();
        try {
            ftpClient.connect(ftpUrl, port);
            ftpClient.login(userName, password);
            ftpClient.enterLocalPassiveMode();
            ftpClient.changeWorkingDirectory(directory);
            result = ftpClient.rename(oldFileName, newFileName);//重命名远程文件
            return result;
        } catch (NumberFormatException e) {
            throw e;
        } catch (IOException e) {
            throw new IOException("连接ftp服务器失败！", e);
        } finally {
            try {
                ftpClient.disconnect();
            } catch (IOException e) {
                throw new RuntimeException("关闭FTP连接发生异常！", e);
            }
        }
    }

    /**
     * @param directory 要删除的文件所在ftp的路径名不包含ftp地址
     * @param fileName  要删除的文件名
     * @return
     * @throws IOException
     */
    public static boolean remove(FTPClient ftpClient, String directory, String fileName) throws IOException {
        /**
         * 判断远程文件是否移除成功，如果成功返回true，否则返回false
         */
        boolean result = false;
        try {

            ftpClient.enterLocalPassiveMode();
            ftpClient.changeWorkingDirectory(directory);
            result = ftpClient.deleteFile(fileName);//删除远程文件
            return result;
        } catch (NumberFormatException e) {
            throw e;
        } catch (IOException e) {
            throw new IOException("连接ftp服务器失败！", e);
        } finally {
            try {
                ftpClient.disconnect();
            } catch (IOException e) {
                throw new RuntimeException("关闭FTP连接发生异常！", e);
            }
        }
    }

    /**
     * @param ftpUrl       ftp地址
     * @param userName     ftp的用户名
     * @param password     ftp的密码
     * @param directory    要创建的目录所在ftp的路径名不包含ftp地址
     * @param newDirectory 要创建的新目录名
     * @return
     * @throws IOException
     */
    public static boolean makeDirecotory(String ftpUrl, String userName, int port,
                                         String password, String directory, String newDirectory) throws IOException {
        /**
         * 判断远程文件是否移除成功，如果成功返回true，否则返回false
         */
        boolean result = false;
        FTPClient ftpClient = new FTPClient();
        try {
            ftpClient.connect(ftpUrl, port);
            ftpClient.login(userName, password);
            ftpClient.enterLocalPassiveMode();
            ftpClient.changeWorkingDirectory(directory);
            result = ftpClient.makeDirectory(newDirectory);//创建新目录
            return result;
        } catch (NumberFormatException e) {
            throw e;
        } catch (IOException e) {
            throw new IOException("连接ftp服务器失败！", e);
        } finally {
            try {
                ftpClient.disconnect();
            } catch (IOException e) {
                throw new RuntimeException("关闭FTP连接发生异常！", e);
            }
        }
    }

    /**
     * @param ftpUrl       ftp地址
     * @param userName     ftp的用户名
     * @param password     ftp的密码
     * @param directory    要重命名的目录所在ftp的路径名不包含ftp地址
     * @param oldDirectory 要重命名的旧目录名
     * @param newDirectory 重命名后的新目录
     * @return
     * @throws IOException
     */
    public static boolean renameDirecotory(String ftpUrl, String userName, int port,
                                           String password, String directory, String oldDirectory, String newDirectory) throws IOException {
        /**
         * 判断远程文件是否移除成功，如果成功返回true，否则返回false
         */
        boolean result = false;
        FTPClient ftpClient = new FTPClient();
        try {
            ftpClient.connect(ftpUrl, port);
            ftpClient.login(userName, password);
            ftpClient.enterLocalPassiveMode();
            ftpClient.changeWorkingDirectory(directory);
            result = ftpClient.rename(oldDirectory, newDirectory);//重命名目录
            return result;
        } catch (NumberFormatException e) {
            throw e;
        } catch (IOException e) {
            throw new IOException("连接ftp服务器失败！", e);
        } finally {
            try {
                ftpClient.disconnect();
            } catch (IOException e) {
                throw new RuntimeException("关闭FTP连接发生异常！", e);
            }
        }
    }

    /**
     * @param ftpUrl       ftp地址
     * @param userName     ftp的用户名
     * @param password     ftp的密码
     * @param directory    要重命名的目录所在ftp的路径名不包含ftp地址
     * @param deldirectory 要删除的目录名
     * @return
     * @throws IOException
     */
    public static boolean removeDirecotory(String ftpUrl, String userName, int port,
                                           String password, String directory, String deldirectory) throws IOException {
        /**
         * 判断远程文件是否移除成功，如果成功返回true，否则返回false
         */
        boolean result = false;
        FTPClient ftpClient = new FTPClient();
        try {
            ftpClient.connect(ftpUrl, port);
            ftpClient.login(userName, password);
            ftpClient.enterLocalPassiveMode();
            ftpClient.changeWorkingDirectory(directory);
            result = ftpClient.removeDirectory(deldirectory);//删除目录
            return result;
        } catch (NumberFormatException e) {
            throw e;
        } catch (IOException e) {
            throw new IOException("连接ftp服务器失败！", e);
        } finally {
            try {
                ftpClient.disconnect();
            } catch (IOException e) {
                throw new RuntimeException("关闭FTP连接发生异常！", e);
            }
        }
    }

    /**
     * @param ftpUrl
     * @param userName
     * @param password
     * @param directory
     * @return
     * @throws IOException
     */
    public static String[] list(String ftpUrl, String userName, int port,
                                String password, String directory) throws IOException {
        FTPClient ftpClient = new FTPClient();
        try {
            ftpClient.connect(ftpUrl, port);
            ftpClient.login(userName, password);
            ftpClient.enterLocalPassiveMode();
            ftpClient.setControlEncoding("gbk");
            ftpClient.changeWorkingDirectory(directory);
            ftpClient.enterLocalPassiveMode();
            String[] list = ftpClient.listNames();//删除目录
            return list;
        } catch (NumberFormatException e) {
            throw e;
        } catch (IOException e) {
            throw new IOException("连接ftp服务器失败！", e);
        } finally {
            try {
                ftpClient.disconnect();
            } catch (IOException e) {
                throw new RuntimeException("关闭FTP连接发生异常！", e);
            }
        }
    }

    private static boolean existDirectory(FTPClient ftpClient,String path) {
        boolean flag = false;
        FTPFile[] listFiles;
        try {
            String Localpath = ftpClient.printWorkingDirectory();
            listFiles = listFiles(ftpClient,null);
        } catch (Exception e) {

            return false;
        }
        if (listFiles == null) return false;
        for (FTPFile ffile : listFiles) {
            boolean isFile = ffile.isFile();
            if (!isFile) {
                if (ffile.getName().equalsIgnoreCase(path)) {
                    flag = true;
                    break;
                }
            }
        }
        return flag;
    }

    public static boolean rename(FTPClient ftpClient,String from, String to) {
        boolean renameResult = false;
        try {
            renameResult = ftpClient.rename(from, to);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return renameResult;
    }

  /*  private void moveFile(FTPClient ftpClient,String sogouFtpPath,String to) throws IOException {
        FTPFile[] files1 = ftpClient.listFiles(sogouFtpPath);
        mkDirectory(ftpClient,to);//新建目录
        for (FTPFile file : files1) {
            String remote = addSeparatorEnd(sogouFtpPath) + file.getName();
            String toFile = to + file.getName();
         //   System.out.println("remote:" + remote);
           // System.out.println("toFile:" + toFile);
            rename(ftpClient,remote, toFile);//下载完成后 移出该文件
        }
    }*/

    public static String moveFile(FTPClient ftpClient,String sogouFtpPath) throws IOException {

     	String to=sogouFtpPath.replace("/temp", "");
     	//得到文件名后缀，用id到名称保存。
        mkDirectory(ftpClient,to.substring(0,to.lastIndexOf("/")));//新建目录
    	logger.debug("ftp更改路径："+sogouFtpPath+"更改为："+to);
        rename(ftpClient,sogouFtpPath, to);//下载完成后 移出该文件
        return to;
    }

    public static String moveFileToFile(FTPClient ftpClient,String sogouFtpPath,String to) throws IOException {

     	//String to=sogouFtpPath.replace("/temp", "");
     	//得到文件名后缀，用id到名称保存。
        mkDirectory(ftpClient,to.substring(0,to.lastIndexOf("/")));//新建目录
    	logger.debug("ftp更改路径："+sogouFtpPath+"更改为："+to);
        rename(ftpClient,sogouFtpPath, to);//下载完成后 移出该文件
        return to;
    }


 /*   private void moveFile(FTPClient ftpClient,String from,String to) throws IOException {
        FTPFile[] files1 = ftpClient.listFiles(from);
       // String to = "/scraping/backup/newrankcrawler/" + getFilePathByDate(null);
        mkDirectory(ftpClient,to);//新建目录
        for (FTPFile file : files1) {
            String remote = addSeparatorEnd(from) + file.getName();
            String toFile = to + file.getName();
         //   System.out.println("remote:" + remote);
           // System.out.println("toFile:" + toFile);
            rename(remote, toFile);//下载完成后 移出该文件
        }
    }
    */
    private String addSeparatorEnd(String str) {
        return StringUtil.endsWith(str, "/") ? str : str + "/";
    }

    private String filenameUrlEncode(String str) {
    	String[] index=str.split("\\.");
		String filename=index[0];
		String suffix=index[1];
		filename=Encodes.urlEncode(filename);
		//编码后名称
		String saveFileName=filename+"."+suffix;
        return saveFileName;
    }
    private static String filenameUrlDecode(String str) {
    	String filename=str.substring(0,str.lastIndexOf("."));
		String suffix=str.substring(str.lastIndexOf(".")+1);
		filename=Encodes.urlDecode(filename);
		//编码后名称
		String saveFileName=filename+"."+suffix;
        return saveFileName;
    }
    /**
     */
    private static FTPFile[] listFiles(FTPClient ftpClient,String fileName) throws IOException {
        FTPFile[] files = null;
        if (StringUtil.isNotEmpty(fileName)) {
            files = ftpClient.listFiles(fileName);
            if (files != null && files.length != 1) {
                // 如果没有不能下载文件，再用被动模式试一次（lidahu）
                ftpClient.enterLocalPassiveMode();
                files = ftpClient.listFiles(fileName);
            }
        } else {
            files = ftpClient.listFiles();
            if (files == null || files.length == 0) {        // 以被动模式再试一次
                ftpClient.enterLocalPassiveMode();
                files = ftpClient.listFiles();
            }
        }
        return files;
    }

    private static void mkDirectory(FTPClient ftpClient,String path) {
        String[] ss = path.split("/");
        try {
            ftpClient.changeWorkingDirectory("/");

            for (String s : ss) {

                int res = ftpClient.mkd(s);
//                    System.out.println(s+"   mkd:"+res);
                ftpClient.changeWorkingDirectory(s);

            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //判断文件是否重名
    public static boolean checkName(FTPClient ftpClient,String ftpUrl, String newName) throws Exception {
        FTPFile[] files = listFiles(ftpClient,ftpUrl+"/"+newName);
        if (files.length > 0) {
            return false;
        } else {
            return true;
        }
    }

    public static String ftpHttpUrl() {
        return FTP_HTTPURL;
    }

    public static String ftpImgUrl(String part) {
    	String fileUrl = null;
    	if (StringUtil.isNotEmpty(part)&&StringUtil.contains(part,"/tool")) {
    		fileUrl=part;
        	//System.out.println(fileName.substring(fileName.lastIndexOf("/")+1));
        	//String fileName=fileUrl.substring(0,fileUrl.lastIndexOf("/")+1);
//        	fileUrl=filenameUrlDecode(fileUrl);
        	fileUrl=fileUrl.replace("/tool", "");
        	fileUrl=FTP_HTTPURL+fileUrl;
    	}
      return fileUrl;
    }

    public static String getFileUrl(String url) {
        String fileUrl="";
        if (StringUtil.isNotEmpty(url)) {
            fileUrl=url.replace("/tool", "");
            fileUrl=FTP_HTTPURL+fileUrl;
        }
        return fileUrl;
    }

   /* * @param ftpUrl      ftp地址
         * @param userName    ftp的用户名
         * @param password    ftp的密码
         * @param directory   上传至ftp的路径名不包括ftp地址
         * @param srcFileName 要上传的文件全路径名
         * @param destName    上传至ftp后存储的文件名*/
    public static void main(String[] args) throws IOException {
       // FtpUtil t = new FtpUtil();
        //移动文件
        //初始位置
       /* String fromString="/tool/oseasy/temp/menuImg/2017-04-09/f778a0e8b9fb4c348f6d02a6df6b61c5/4521.png";
        //移动位置
        moveFileToFile(t.getftpClient(),fromString,toString);*/
       // t.upload("192.168.0.105","ftponly",2121,"os-easy","/tool/oseasy/gcontest","C:\\Users\\Administrator\\Desktop\\jiaose.txt","jiaose.txt");
        //t.moveFile(t.getftpClient(), "/tool/oseasy/gcontest/2017-03-25/1.txt", "/tool/oseasy/gcontest/2017-03-26");
        //t.moveFile(t.getftpClient(),"/tool/oseasy/temp/gcontest/2017-03-27/1264551.txt");
       // t.download(t.getftpClient(), "/tool/oseasy/temp/gcontest/2017-03-24/", "1264551.txt", "C:\\Users\\Administrator\\Desktop\\11111.txt");
 /*   	String fileName="/tool/oseasy/menuImg/2017-04-09/8ef4c47abd05448cba1889f5c8de9f33/4521.png";
    	System.out.println(fileName.substring(0,fileName.lastIndexOf("/")+1));
    	System.out.println(fileName.substring(fileName.lastIndexOf("/")+1));
    	System.out.println(fileName.substring(fileName.lastIndexOf(".")+1));
    	System.out.println(fileName.substring(0,fileName.lastIndexOf(".")));
    	fileName=fileName.replace("/tool", "");
    	fileName="http://192.168.0.105"+fileName;
    	System.out.println(fileName);*/
        String fileName="C:\\Users\\Administrator\\Desktop\\大赛审核步骤参数.txt";
        System.out.println(fileName.substring(0,fileName.lastIndexOf("\\")));
        System.out.println(fileName.substring(fileName.lastIndexOf("\\")+1));
        String url="/a/fdsaff";
        System.out.println(url.indexOf("/a/"));
    /*	String encode="/tool/oseasy/menuImg/2017-03-31-12-11/managePlatFormLeverOne+%2810%29.png";
    	encode=filenameUrlDecode(encode);
    	System.out.println(encode);
    	System.out.println(encode.replace("/temp", ""));*/

    }

}
