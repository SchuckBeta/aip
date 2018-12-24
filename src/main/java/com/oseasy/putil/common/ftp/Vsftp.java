package com.oseasy.putil.common.ftp;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.log4j.Logger;

import com.google.common.collect.Lists;
import com.oseasy.putil.common.ftp.exceptions.FtpException;
import com.oseasy.putil.common.ftp.vo.FileVo;
import com.oseasy.putil.common.ftp.vo.VsFile;
import com.oseasy.putil.common.utils.FileUtil;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.putil.common.utils.exception.ExceptionUtil;

/**
 * Created by zhangchuansheng on 2017/7/20. 提供连接 ，上传，下载的方法
 */
public class Vsftp {
	public final static Logger logger = Logger.getLogger(Vsftp.class);
	public FTPClient ftpclient = null;
	protected String name;

	public Vsftp(String host, int port, String username, String passwd) {
		this.connect(host, port, username, passwd);
		this.setName(new java.util.Random().nextInt(900) + 100 + "");
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	protected FTPClient getFtpclient() {
		return ftpclient;
	}
	public  FTPFile[]  getFiles(String remotePath) throws Exception {
		boolean isExist = existDirectory(remotePath);
		if (!isExist) {
			return null;
		}
		ftpclient.changeWorkingDirectory(remotePath);
		FTPFile[] fs = ftpclient.listFiles();
		if(fs==null||fs.length==0){
			return null;
		}else{
			return fs;
		}
	}
	public  int  getFileCount(String remotePath) throws Exception {
		boolean isExist = existDirectory(remotePath);
		if (!isExist) {
			return 0;
		}
		ftpclient.changeWorkingDirectory(remotePath);
		FTPFile[] fs = ftpclient.listFiles();
		if(fs==null||fs.length==0){
			return 0;
		}else{
			int c=0;
			for(FTPFile f:fs){
				if(f.isFile()){
					c++;
				}
			}
			return c;
		}
	}
	public boolean isFileExist(String filepath) throws FtpException{
		FTPFile[] fs=null;
		try {
			fs = ftpclient.listFiles(filepath);
		} catch (IOException e) {
			throw new FtpException(e);
		}
		if (fs!=null&&fs.length>0) {
			return true;
		}else{
			return false;
		}
	}
	protected void connect(String host, int port, String username, String passwd) {
		this.ftpclient = new FTPClient();
		try {
			int reply;
			ftpclient.connect(host, port);// 连接FTP服务器
			ftpclient.setAutodetectUTF8(true);
			ftpclient.setControlEncoding("iso-8859-1");
			ftpclient.login(username, passwd);// 登录
			ftpclient.setFileType(FTPClient.BINARY_FILE_TYPE);
			reply = ftpclient.getReplyCode();
			if (!FTPReply.isPositiveCompletion(reply)) {
				ftpclient.disconnect();
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	public void uploadFile(String remotePath, String filename, InputStream input) throws Exception {
		try {
			boolean isExist = existDirectory(remotePath);
			if (!isExist) {
				mkDirectory(remotePath);
			}
			ftpclient.changeWorkingDirectory(remotePath);
			// 设置文件名上传的编码格式为 utf-8
			ftpclient.setBufferSize(1024);
			ftpclient.storeFile(filename, input);
		}finally {
			input.close();
		}

	}
	public void downFile(String filePath, String localPath) throws Exception {
		OutputStream is=null;
		try {
			if(StringUtil.isNotEmpty(filePath)&&StringUtil.isNotEmpty(localPath)){
				String realName = filePath.substring(filePath.lastIndexOf("/") + 1);
				String path = filePath.substring(0, filePath.lastIndexOf("/") + 1);
				ftpclient.changeWorkingDirectory(path);// 转移到FTP服务器目录
				FileUtil.createDirectory(localPath);
				File localFile = new File(localPath + "/" + realName);
				is = new FileOutputStream(localFile);
				ftpclient.retrieveFile(realName, is);
			}
		} finally {
			if(is!=null){
				try {
					is.close();
				} catch (Exception e) {
					logger.error(ExceptionUtil.getStackTrace(e));
				}
			}
		}
	}
	public void downFile(String remotePath, String fileName, String localPath) throws Exception {
		OutputStream is=null;
		try {
			if(StringUtil.isNotEmpty(remotePath)&&StringUtil.isNotEmpty(fileName)&&StringUtil.isNotEmpty(localPath)){
				ftpclient.changeWorkingDirectory(remotePath);// 转移到FTP服务器目录
				FileUtil.createDirectory(localPath);
				File localFile = new File(localPath + "/" + fileName);
				is = new FileOutputStream(localFile);
				ftpclient.retrieveFile(fileName, is);
			}
		} finally {
			if(is!=null){
				try {
					is.close();
				} catch (Exception e) {
					logger.error(ExceptionUtil.getStackTrace(e));
				}
			}
		}
	}

	/**
	 * FTP批量下载文件.
	 *
	 * @param vsFiles
	 *            文件路径列表.
	 * @throws FtpException
	 */
	public FileVo downFiles(List<VsFile> vsFiles) throws FtpException {
		FileVo fileVo = null;
		OutputStream is = null;
		try {
			List<File> suFiles = Lists.newArrayList();
			List<File> falFiles = Lists.newArrayList();
			for (VsFile vsFile : vsFiles) {
				ftpclient.changeWorkingDirectory(vsFile.getRemotePath());// 转移到FTP服务器目录
				FTPFile[] fs = ftpclient.listFiles();
				for (FTPFile ff : fs) {
					String remotFileName = new String(ff.getName().getBytes("iso-8859-1"), "utf-8");
					if (remotFileName.equals(vsFile.getRfileName())) {
						FileUtil.createDirectory(vsFile.getLocalPath());
						File localFile = new File(vsFile.getLocalPath() + "/" + vsFile.getLfileName());
						is = new FileOutputStream(localFile);
						if (ftpclient.retrieveFile(ff.getName(), is)) {
							suFiles.add(localFile);
						} else {
							falFiles.add(localFile);
						}
						if (is != null) {
							is.close();
						}
					}
				}
			}
			if ((falFiles == null) || (falFiles.size() <= 0)) {
				fileVo = new FileVo(FileVo.SUCCESS, suFiles);
			} else if ((suFiles == null) || (suFiles.size() <= 0)) {
				fileVo = new FileVo(FileVo.FAIL, falFiles);
			} else {
				fileVo = new FileVo(suFiles, falFiles);
			}
		} catch (IOException e) {
			fileVo = new FileVo(FileVo.FAIL);
			throw new FtpException(e);
		}
		return fileVo;
	}

	public boolean downFileWithName(HttpServletRequest request, HttpServletResponse response, String name,
			String realName, String path) throws FtpException{
		OutputStream os = null;
		try {
			ftpclient.changeWorkingDirectory(path);
			name = FileUtil.dealBrowserChina(request, name);
			response = FileUtil.dealFileHeader(response, null, null, name);
			os = response.getOutputStream();
			ftpclient.retrieveFile(realName, os);
			os.flush();
		} catch (Exception e) {
			throw new FtpException(e);
		} finally {
			if (os != null) {
				try {
					os.close();
				} catch (IOException e) {
					throw new FtpException(e);
				}
			}
		}
		return true;
	}
	public void removeFile(String filePath) throws FtpException {
		try {
			ftpclient.deleteFile(filePath);
		} catch (IOException e) {
			throw new FtpException(e);
		}
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
	public boolean removeFile(String remotePath, String fileName) throws FtpException {
		// TODO 中文名的文件 无法删除
		boolean result = false;
		if (!ftpclient.isConnected()) {
			return result;
		}
		try {
			// ftpclient.enterLocalPassiveMode();//设置ftp为被动模式
			ftpclient.changeWorkingDirectory(remotePath);
			result = ftpclient.deleteFile(fileName);// 删除远程文件
		} catch (IOException e) {
			result = false;
			throw new FtpException("连接ftp服务器失败！", e);
		}

		return result;
	}

	/*
	 * private boolean cd(String dir) throws IOException { if
	 * (ftpclient.changeWorkingDirectory(dir)) { return true; } else { return
	 * false; } }
	 */

	private boolean existDirectory(String path) {
		try {
			return ftpclient.changeWorkingDirectory(path);
		} catch (IOException e) {
			return false;
		}
	}

	public boolean rename(String from, String to) {
		boolean renameResult = false;
		try {
			renameResult = ftpclient.rename(from, to);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return renameResult;
	}

	private void mkDirectory(String path) {
		String[] ss = path.split("/");
		try {
			ftpclient.changeWorkingDirectory("/");
			for (String s : ss) {
				ftpclient.mkd(s);
				ftpclient.changeWorkingDirectory(s);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	// 移动文件从临时目录到正式目录
	public String moveFile(String tmpPath) throws IOException {
		String realPath = tmpPath.replace("/temp", "");
		// 得到文件名后缀，用id到名称保存。
		String realDirectory = realPath.substring(0, realPath.lastIndexOf("/"));

		// 如果没有最终的文件夹目录则创建最终的文件夹目录
		boolean isExist = existDirectory(realDirectory);
		if (!isExist) {
			mkDirectory(realDirectory);
		}
		// 移出该文件
		ftpclient.rename(tmpPath, realPath);
		return realPath;
	}
	public String moveFile(String tmpPath,String newPath) throws IOException {
		// 得到文件名后缀，用id到名称保存。
		String realDirectory = newPath.substring(0, newPath.lastIndexOf("/"));

		// 如果没有最终的文件夹目录则创建最终的文件夹目录
		boolean isExist = existDirectory(realDirectory);
		if (!isExist) {
			mkDirectory(realDirectory);
		}
		// 移出该文件
		ftpclient.rename(tmpPath, newPath);
		return newPath;
	}

	/**
	 * 复制文件.
	 * @param sourceFileName 来源文件名称
	 * @param sourceDir 来源文件夹
	 * @param targetDir 存放文件夹
	 * @throws IOException
	 */
	public boolean copyFile(String sourceFileName, String sourceDir, String targetFileName, String targetDir) throws IOException {
		ByteArrayInputStream in = null;
		ByteArrayOutputStream fos = new ByteArrayOutputStream();
		boolean renameResult = false;
		try {
			if (!existDirectory(targetDir)) {
				FileUtil.createDirectory(targetDir);
			}
			ftpclient.setBufferSize(1024);
			ftpclient.changeWorkingDirectory(sourceDir);
//			// 设置以二进制流的方式传输
			ftpclient.setFileType(FTP.BINARY_FILE_TYPE);
			// 将文件读到内存中
			String inName=new String(sourceFileName.getBytes("utf-8"), "iso-8859-1");
			ftpclient.retrieveFile(inName, fos);

			in = new ByteArrayInputStream(fos.toByteArray());
			if (in != null) {
				ftpclient.changeWorkingDirectory(targetDir);
				renameResult=ftpclient.storeFile(new String(targetFileName.getBytes("utf-8"), "iso-8859-1"), in);
			}
		} finally {
			// 关闭流
			if (in != null) {
				in.close();
			}
			if (fos != null) {
				fos.close();
			}
		}
		return renameResult;
	}
}
