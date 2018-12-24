/**
 *
 */
package com.oseasy.initiate.common.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import org.activiti.engine.impl.util.json.JSONObject;
import org.apache.commons.net.ftp.FTPClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.utils.FtpUtil;
import com.oseasy.pcore.common.utils.IdGen;
import com.oseasy.pcore.modules.sys.dao.UserDao;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.putil.common.utils.Encodes;

/**
 * Service上传
 *
 * @version 2014-05-16
 */

@Transactional(readOnly = true)
public  class UoloadFtpService {

	@Autowired
	private UserDao userDao;
	/**
	 * 日志对象
	 */
	protected Logger logger = LoggerFactory.getLogger(getClass());

	 //上传ftp
	@Transactional(readOnly = false)
    public void ftpUplod(String fileName, JSONObject obj,InputStream inputStream,String userId) {
    	try {
    		FtpUtil ftpUtil = new FtpUtil();
    		FTPClient ftpClient=ftpUtil.getftpClient();
    		String ftpId=IdGen.uuid();
    		//得到文件名后缀，用id到名称保存。.
    		String filename=fileName.substring(0,fileName.lastIndexOf("."));
    		String suffix=fileName.substring(fileName.lastIndexOf(".")+1);
    		//String ftpPath=suffix+"/"+DateUtils.getDate("yyyy-MM-dd")+"/"+ftpId;
    		String ftpPath=userId+"/";//+DateUtils.getDate("yyyy-MM-dd");
    		filename=Encodes.urlEncode(filename);
    		//编码后名称
    		String saveFileName=filename+"."+suffix;
    		//判断是否有同名文件
    		boolean isSame=ftpUtil.checkName(ftpClient, "/tool/oseasy/sys/"+ftpPath, saveFileName);
    		if (isSame) {
    			//流形式保存
    			boolean res=ftpUtil.uploadInputSteam(ftpClient,inputStream,"/tool/oseasy/sys/"+ftpPath,saveFileName);
    			this.syncDb("/tool/oseasy/sys/"+ftpPath+"/"+saveFileName, userId);
    			if (res) {
    				obj.put("state",1);//上传成功
    				obj.put("fileName", fileName);
    				obj.put("arrUrl", "/tool/oseasy/temp/"+ftpPath+"/"+saveFileName);
    				obj.put("ftpId", ftpId);
    			}else{
    				obj.put("state", 2);
    				obj.put("fileName", fileName);
    				obj.put("msg", "上传失败");
    			}
    		}else{
    			obj.put("state",3);//文件同名
    			obj.put("msg", "不能上传相同文件名");
    		}
		} catch (Exception e) {
			e.printStackTrace();
		}
    }

    //同步数据库
	@Transactional(readOnly = false)
    public void syncDb(String imgurl,String userId) {
    	User user=new User();
    	user.setId(userId);
    	user.setPhoto(imgurl);
    	//user.setIsNewRecord(false);
    	userDao.updateUserInfo(user);
    }

	/**
	 * @param ftpUrl
	 *
	 * @return 返回  <Img src="?" />
	 */
	@Transactional(readOnly = false)
	public String downFtpByBase64(String ftpUrl) {
		try {
			FtpUtil ftpUtil = new FtpUtil();
			FTPClient ftpClient=ftpUtil.getftpClient();
			InputStream in = null;
			in=ftpClient.retrieveFileStream(ftpUrl);
			byte[] bytes = null;
			bytes = input2byte(in);
			String img64= Encodes.encodeBase64(bytes);
			in.close();
			ftpUrl=ftpUrl.substring(ftpUrl.lastIndexOf(".")+1);
	        img64="data:image/"+ftpUrl+";base64,"+img64;
	       // System.err.println("11aa="+img64);

			return img64;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}

	//删除指定文件
	@Transactional(readOnly = false)
	public  boolean delFtpImg(String urlImg,String userId) {
		try {
			FtpUtil ftpUtil = new FtpUtil();
			this.syncDb("", userId);
			FTPClient ftpClient=ftpUtil.getftpClient();
			return ftpClient.deleteFile(urlImg);
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
	}

	public static byte[] input2byte(InputStream inStream)throws IOException{
	        ByteArrayOutputStream swapStream = new ByteArrayOutputStream();
	        byte[] buff = new byte[100];
	        int rc = 0;
	        while ((rc = inStream.read(buff, 0, 100)) > 0)
	        {
	            swapStream.write(buff, 0, rc);
	        }
	        byte[] in2b = swapStream.toByteArray();

	        swapStream.close();

	        return in2b;
	    }
}
