package com.oseasy.pcore.common.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.net.ftp.FTPFile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.oseasy.putil.common.ftp.VsFtpPool;
import com.oseasy.putil.common.ftp.Vsftp;
import com.oseasy.putil.common.ftp.exceptions.FtpException;
import com.oseasy.putil.common.ftp.vo.FileVo;
import com.oseasy.putil.common.ftp.vo.VsFile;
import com.oseasy.putil.common.utils.FileUtil;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.putil.common.utils.exception.ExceptionUtil;

public class VsftpUtils {
	private static VsFtpPool vsFtpPool = SpringContextHolder.getBean(VsFtpPool.class);
	private static Logger logger = LoggerFactory.getLogger(VsFtpPool.class);
	public static FTPFile[]  getFiles(String filepath) throws Exception {
		Vsftp vs = vsFtpPool.getResource();
		try {
			return vs.getFiles(filepath);
		} finally {
			vsFtpPool.returnResource(vs);
		}
	}
	public static int  getFileCount(String filepath) throws Exception {
		Vsftp vs = vsFtpPool.getResource();
		try {
			return vs.getFileCount(filepath);
		} finally {
			vsFtpPool.returnResource(vs);
		}
	}
	public static boolean  isFileExist(String filepath) throws Exception {
		Vsftp vs = vsFtpPool.getResource();
		try {
			return vs.isFileExist(filepath);
		} finally {
			vsFtpPool.returnResource(vs);
		}
	}
	public static void uploadFile(String remotePath, String filename, File file) throws Exception {
		Vsftp vs = vsFtpPool.getResource();
		InputStream input=null;
		try {
			input=new FileInputStream(file);
			vs.uploadFile(remotePath, filename, input);
		} finally {
			if (input!=null) {
				input.close();
			}
			vsFtpPool.returnResource(vs);
		}
	}
	public static void uploadFile(String remotePath, String filename, InputStream input) throws Exception{
		Vsftp vs = vsFtpPool.getResource();
		try {
			vs.uploadFile(remotePath, filename, input);
		} finally {
			vsFtpPool.returnResource(vs);
		}
	}
	public static void downFile(String filepath,String localPath) throws Exception {
		Vsftp vs = vsFtpPool.getResource();
		try {
			vs.downFile(filepath, localPath);
		} finally {
			vsFtpPool.returnResource(vs);
		}
	}
	public static void downFile(String remotePath, String fileName, String localPath) throws Exception {
		Vsftp vs = vsFtpPool.getResource();
		try {
			vs.downFile(remotePath, fileName, localPath);
		} finally {
			vsFtpPool.returnResource(vs);
		}
	}
	public static int getNumIdle() {
		return vsFtpPool.getNumIdle();
	}
	public static Vsftp getResource() {
		return vsFtpPool.getResource();
	}
	public static void returnResource(Vsftp vs) {
		vsFtpPool.returnResource(vs);
	}
	public static void downFilesPlus(Vsftp vs,List<VsFile> vsFiles, String expInfoId,String key) {
		try {
			OutputStream is = null;
			int suc = 0;
			if(vsFiles!=null&&vsFiles.size()>0){
				for (VsFile vsFile : vsFiles) {
					try {
						vs.ftpclient.changeWorkingDirectory(vsFile.getRemotePath());// 转移到FTP服务器目录
						FTPFile[] fs = vs.ftpclient.listFiles();
						for (FTPFile ff : fs) {
							String remotFileName = new String(ff.getName().getBytes("iso-8859-1"), "utf-8");
							if (remotFileName.equals(vsFile.getRfileName())) {
								FileUtil.createDirectory(vsFile.getLocalPath());
								File localFile = new File(vsFile.getLocalPath() + "/" + vsFile.getLfileName());
								is = new FileOutputStream(localFile);
								if (vs.ftpclient.retrieveFile(ff.getName(), is)) {
									suc++;
									CacheUtils.put(CacheUtils.EXP_NUM_CACHE+expInfoId, key, suc);
								}
							}
						}
					} catch (Exception e) {
						logger.error(ExceptionUtil.getStackTrace(e));
					} finally {
						if (is != null) {
							try {
								is.close();
							} catch (Exception e) {
								logger.error(ExceptionUtil.getStackTrace(e));
							}
						}
					}
				}
			}
		} catch (Exception e) {
			logger.error(ExceptionUtil.getStackTrace(e));
		} finally {
			CacheUtils.put(CacheUtils.EXP_STATUS_CACHE+expInfoId, key, "1");//该线程执行完毕
			vsFtpPool.returnResource(vs);
		}
	}

	/**
	 * FTP批量下载文件.
	 *
	 * @param vsFiles
	 *            文件路径列表.
	 * @throws FtpException
	 */
	public static FileVo downFiles(List<VsFile> vsFiles) throws FtpException {
		Vsftp vs = vsFtpPool.getResource();
		FileVo ret;
		try {
			ret = vs.downFiles(vsFiles);
		} finally {
			vsFtpPool.returnResource(vs);
		}
		return ret;
	}

	public static boolean downFileWithName(HttpServletRequest request, HttpServletResponse response, String name,
			String realName, String path) throws FtpException {
		Vsftp vs = vsFtpPool.getResource();
		boolean ret;
		try {
			ret = vs.downFileWithName(request, response, name, realName, path);
		} finally {
			vsFtpPool.returnResource(vs);
		}
		return ret;
	}

	/**
	 * @param remotePath
	 *            要删除的文件所在ftp的路径名不包含ftp地址
	 * @param fileName
	 *            要删除的文件名
	 * @return
	 * @throws FtpException
	 * @throws IOException
	 */
	public static boolean removeFile(String remotePath, String fileName) throws FtpException {
		Vsftp vs = vsFtpPool.getResource();
		boolean ret;
		try {
			ret = vs.removeFile(remotePath, fileName);
			String suffix = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
			if(FileUtil.SUFFIX_DOC.equals(suffix)||FileUtil.SUFFIX_DOCX.equals(suffix)){
				String pdffilename = fileName.substring(0, fileName.lastIndexOf("."))+"."+FileUtil.SUFFIX_PDF; // 文件名
				String pdfpath=remotePath+pdffilename;
				if(vs.isFileExist(pdfpath)){
					vs.removeFile(pdfpath);
				}
			}
		} finally {
			vsFtpPool.returnResource(vs);
		}
		return ret;
	}

	public static boolean rename(String from, String to) {
		Vsftp vs = vsFtpPool.getResource();
		boolean ret;
		try {
			ret = vs.rename(from, to);
		} finally {
			vsFtpPool.returnResource(vs);
		}
		return ret;
	}

	// 移动文件从临时目录到正式目录
	public static String moveFile(String tmpPath) throws IOException {
		Vsftp vs = vsFtpPool.getResource();
		String ret;
		try {
			ret = vs.moveFile(tmpPath);
		} finally {
			vsFtpPool.returnResource(vs);
		}
		return ret;
	}
	// 移动文件
	public static String moveFile(String tmpPath,String newPath) throws IOException {
		Vsftp vs = vsFtpPool.getResource();
		String ret;
		try {
			ret = vs.moveFile(tmpPath,newPath);
		} finally {
			vsFtpPool.returnResource(vs);
		}
		return ret;
	}

	// 复制文件从来源目录到其他目录
	public static boolean copyFile(String sourceFileName, String sourceDir, String targetFileName,String targetDir) throws IOException {
		Vsftp vs = vsFtpPool.getResource();
		boolean ret;
		try {
			ret = vs.copyFile(sourceFileName,sourceDir,targetFileName,targetDir);
		} finally {
			vsFtpPool.returnResource(vs);
		}
		return ret;
	}

	/**
     * 异步
     * 出错不抛出
     * @param filepath
     */
    public static void word2PDF(final String filepath){
        try {
            if(StringUtil.isEmpty(filepath)){
                return;
            }
            String suffix = filepath.substring(filepath.lastIndexOf(".") + 1).toLowerCase();
            if(!FileUtil.SUFFIX_DOC.equals(suffix)&&!FileUtil.SUFFIX_DOCX.equals(suffix)){
                return;
            }
        } catch (Exception e) {
            logger.error(ExceptionUtil.getStackTrace(e));
        }
        new Thread(){
            @Override
            public void run() {
                try {
                    String tempPath = File.separator + FileUtil.TempFileDir + File.separator + IdGen.uuid();// 生成的文件所在目录
                    File tempPathDir = new File(tempPath + File.separator);
                    if (!tempPathDir.exists()) {
                        tempPathDir.mkdirs();
                    }
                    String realName = filepath.substring(filepath.lastIndexOf("/") + 1);
                    String path = filepath.substring(0, filepath.lastIndexOf("/") + 1);
                    VsftpUtils.downFile(path, realName, tempPath);
                    FileUtil.word2PDF(tempPathDir.getCanonicalPath(),realName);
                    String pdffilename = realName.substring(0, realName.lastIndexOf("."))+"."+FileUtil.SUFFIX_PDF; // 文件名
                    String pdfpath=tempPath+File.separator+pdffilename;
                    File pdf=new File(pdfpath);
                    if(pdf.exists()){
                        VsftpUtils.uploadFile(path,pdffilename, pdf);
                    }
                    FileUtil.deleteFileOrDir(new File(tempPath));
                } catch (Exception e) {
                    logger.error(ExceptionUtil.getStackTrace(e));
                }
            }

        }.start();
    }
}
