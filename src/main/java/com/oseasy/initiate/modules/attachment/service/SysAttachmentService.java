package com.oseasy.initiate.modules.attachment.service;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLDecoder;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.google.common.collect.Lists;
import com.oseasy.initiate.modules.attachment.dao.SysAttachmentDao;
import com.oseasy.initiate.modules.attachment.entity.SysAttachment;
import com.oseasy.initiate.modules.attachment.enums.FileStepEnum;
import com.oseasy.initiate.modules.attachment.enums.FileTypeEnum;
import com.oseasy.initiate.modules.attachment.exception.FileDealException;
import com.oseasy.initiate.modules.promodel.entity.ProModel;
import com.oseasy.initiate.modules.promodel.entity.ProReport;
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pcore.common.config.ApiTstatus;
import com.oseasy.pcore.common.config.CoreJkey;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.AttachMentEntity;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.pcore.common.utils.FtpUtil;
import com.oseasy.pcore.common.utils.IdGen;
import com.oseasy.pcore.common.utils.VsftpUtils;
import com.oseasy.pcore.common.web.Servlets;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.putil.common.ftp.exceptions.FtpException;
import com.oseasy.putil.common.ftp.vo.FileVo;
import com.oseasy.putil.common.ftp.vo.VsFile;
import com.oseasy.putil.common.utils.DateUtil;
import com.oseasy.putil.common.utils.FileUtil;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.putil.common.utils.exception.ExceptionUtil;

import net.sf.json.JSONObject;

/**
 * 附件信息表Service
 *
 * @author zy
 * @version 2017-03-23
 */
@Service
@Transactional(readOnly = true)
public class SysAttachmentService extends CrudService<SysAttachmentDao, SysAttachment> {
	public final static Logger logger = Logger.getLogger(SysAttachmentService.class);
	/**返回的文件链接由FTP服务器提供
	 * @param request
	 * @return
	 * @throws IOException
	 */
	public JSONObject uploadTempFtp(HttpServletRequest request) {
		InputStream in = null;
		JSONObject obj = new JSONObject();
		try {
			MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
			MultipartFile imgFile1 = multipartRequest.getFile("upfile"); // 文件
			String urlFileName = imgFile1.getOriginalFilename();
			// 得到文件名后缀，用id到名称保存。.
			String filename = urlFileName.substring(0, urlFileName.lastIndexOf(".")); // 文件名
			String suffix = urlFileName.substring(urlFileName.lastIndexOf(".") + 1);
			String ftpId = IdGen.uuid();
			String saveFileName = ftpId + "." + suffix;
			String folder = request.getParameter("folder");
			if (StringUtil.isBlank(folder)) {
				folder = "ueditor";
			}
			String ftpPath = folder + StringUtil.LINE + DateUtil.getDate("yyyy-MM-dd");
			long size = imgFile1.getSize();
			String remotePath = "/tool/oseasy/temp/" + ftpPath;
			in = imgFile1.getInputStream();
			VsftpUtils.uploadFile(remotePath, saveFileName, in);
			obj.put("state", "SUCCESS");// 上传成功
			obj.put("original", filename);
			obj.put("size", size);
			obj.put("title", urlFileName);
			obj.put("type", suffix);
			String param = "?fileSize=" + size + "&fielTitle=" + urlFileName + "&fielType=" + suffix;
			obj.put("url", FtpUtil.ftpImgUrl("/tool/oseasy/temp/" + ftpPath + StringUtil.LINE + saveFileName) + param);
			obj.put("ftpUrl", "/tool/oseasy/temp/" + ftpPath + StringUtil.LINE + saveFileName);
			return obj;
		} catch (Exception e) {
			logger.error(e.getMessage());
			obj.put("state", "FAIL");
			return obj;
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					logger.error(e.getMessage());
				}
			}
		}
	}

	/**返回的文件链接由应用服务器提供 /ftp/ueditorUpload/downFile
	 * @param request
	 * @return
	 * @throws IOException
	 */
	public JSONObject uploadTempIndex(HttpServletRequest request) {
		InputStream in = null;
		JSONObject obj = new JSONObject();
		try {
			MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
			MultipartFile imgFile1 = multipartRequest.getFile("upfile"); // 文件
			String urlFileName = imgFile1.getOriginalFilename();
			// 得到文件名后缀，用id到名称保存。.
			String filename = urlFileName.substring(0, urlFileName.lastIndexOf(".")); // 文件名
			String suffix = urlFileName.substring(urlFileName.lastIndexOf(".") + 1).toLowerCase();
			String ftpId = IdGen.uuid();
			String saveFileName = ftpId + "." + suffix;
			String folder = request.getParameter("folder");
			if (StringUtil.isBlank(folder)) {
				folder = "ueditor";
			}
			String ftpPath = folder + StringUtil.LINE + DateUtil.getDate("yyyy-MM-dd");
			long size = imgFile1.getSize();
			String remotePath = "/tool/oseasy/ueEdit/" + ftpPath;
			in = imgFile1.getInputStream();
			VsftpUtils.uploadFile(remotePath, saveFileName, in);
			obj.put("state", "SUCCESS");// 上传成功
			obj.put("original", filename);
			obj.put("size", size);
			obj.put("title", urlFileName);
			obj.put("type", suffix);
			String param = "&fileSize=" + size + "&fielTitle=" + urlFileName + "&fielType=" + suffix+"&"+FileUtil.FILE_NAME+"="+urlFileName;
			obj.put("url", getFtpDownurl(request)+"?url=/tool/oseasy/ueEdit/" + ftpPath + StringUtil.LINE + saveFileName+ param);
			obj.put("ftpUrl", "/tool/oseasy/ueEdit/" + ftpPath + StringUtil.LINE + saveFileName);
			return obj;
		} catch (Exception e) {
			logger.error(e.getMessage());
			obj.put("state", "FAIL");
			return obj;
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					logger.error(e.getMessage());
				}
			}
		}
	}


	/**返回的文件链接由应用服务器提供 /ftp/ueditorUpload/downFile
	 * @param request
	 * @return
	 * @throws IOException
	 */
	public JSONObject uploadTempBiz(HttpServletRequest request) {
		InputStream in = null;
		JSONObject obj = new JSONObject();
		try {
			MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
			MultipartFile imgFile1 = multipartRequest.getFile("upfile"); // 文件
			String urlFileName = imgFile1.getOriginalFilename();
			// 得到文件名后缀，用id到名称保存。.
			String filename = urlFileName.substring(0, urlFileName.lastIndexOf(".")); // 文件名
			String suffix = urlFileName.substring(urlFileName.lastIndexOf(".") + 1).toLowerCase();
			String ftpId = IdGen.uuid();
			String saveFileName = ftpId + "." + suffix;
			String folder = request.getParameter("folder");
			if (StringUtil.isBlank(folder)) {
				folder = "ueditor";
			}
			String ftpPath = folder + StringUtil.LINE + DateUtil.getDate("yyyy-MM-dd");
			long size = imgFile1.getSize();
			String remotePath = "/tool/oseasy/temp/" + ftpPath;
			in = imgFile1.getInputStream();
			VsftpUtils.uploadFile(remotePath, saveFileName, in);
			obj.put("state", "SUCCESS");// 上传成功
			obj.put("original", filename);
			obj.put("size", size);
			obj.put("title", urlFileName);
			obj.put("type", suffix);
			String param = "&fileSize=" + size + "&fielTitle=" + urlFileName + "&fielType=" + suffix+"&"+FileUtil.FILE_NAME+"="+urlFileName;
			obj.put("url", getFtpDownurl(request)+"?url=/tool/oseasy/temp/" + ftpPath + StringUtil.LINE + saveFileName+ param);
			obj.put("ftpUrl", "/tool/oseasy/temp/" + ftpPath + StringUtil.LINE + saveFileName);
			return obj;
		} catch (Exception e) {
			logger.error(e.getMessage());
			obj.put("state", "FAIL");
			return obj;
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					logger.error(e.getMessage());
				}
			}
		}
	}
	/**
	 * 删除所有根据查询条件得到的
	 *
	 * @param s
	 */
	@Transactional(readOnly = false)
	public void deleteByCdnNotInSet(SysAttachment s, Set<String> set) {
		List<SysAttachment> list = dao.getFilesNotInSet(s, set);
		dao.deleteByCdnNotInSet(s, set);
		if (list != null && list.size() > 0) {
			for (SysAttachment sa : list) {
				if (StringUtil.isNotEmpty(sa.getUrl())) {
					try {
						VsftpUtils.removeFile(sa.getRemotePath(), sa.getFileName());
					} catch (FtpException e) {
						logger.error(ExceptionUtil.getStackTrace(e));
					}
				}
			}
		}
	}

	/**
	 * 删除所有根据查询条件得到的
	 *
	 * @param s
	 */
	@Transactional(readOnly = false)
	public void deleteByCdn(SysAttachment s) {
		List<SysAttachment> list = dao.getFiles(s);
		dao.deleteByCdn(s);
		if (list != null && list.size() > 0) {
			for (SysAttachment sa : list) {
				if (StringUtil.isNotEmpty(sa.getUrl())) {
					try {
						VsftpUtils.removeFile(sa.getRemotePath(), sa.getFileName());
					} catch (FtpException e) {
						logger.error(ExceptionUtil.getStackTrace(e));
					}
				}
			}
		}
	}

	public List<SysAttachment> getFiles(SysAttachment s) {
		List<SysAttachment> list = dao.getFiles(s);
		if(list!=null){
			for(SysAttachment sa:list){
				String extname=sa.getSuffix().toLowerCase();
				if("txt".equals(extname)||"jpg".equals(extname)||"jpeg".equals(extname)
						||"gif".equals(extname)||"png".equals(extname)||"bmp".equals(extname)
						||"pdf".equals(extname)){
					sa.setViewUrl(FtpUtil.ftpImgUrl(sa.getUrl()));
				}else if("doc".equals(extname)||"docx".equals(extname)){
					String url=sa.getUrl();
					String pdffilepath = url.substring(0, url.lastIndexOf("."))+"."+FileUtil.SUFFIX_PDF;
					try {
						if(VsftpUtils.isFileExist(pdffilepath)){
							sa.setViewUrl(FtpUtil.ftpImgUrl(pdffilepath));
						}
					} catch (Exception e) {
						logger.error(ExceptionUtil.getStackTrace(e));
					}
				}
			}
		}

//		if(!list.isEmpty()){
//			List<String> picSuffixs = new ArrayList<>();
//			picSuffixs.add("jpg");
//			picSuffixs.add("jpeg");
//			picSuffixs.add("png");
//			picSuffixs.add("pdf");
//			picSuffixs.add("gif");
//			picSuffixs.add("bmp");
//			for (SysAttachment sysAttachment : list) {
//				if (picSuffixs.contains(sysAttachment.getSuffix())) {
//					sysAttachment.setViewUrl(FtpUtil.ftpHttpUrl().concat(sysAttachment.getUrl().replace("/tool", "")));
//				}
//			}
//		}

		return list;
	}

	public List<Map<String, String>> getFileInfo(Map<String, String> map) {
		List<Map<String, String>> list = dao.getFileInfo(map);
		for (Map<String, String> m : list) {
			String extname = m.get("suffix").toLowerCase();
			switch (extname) {
			case "xls":
			case "xlsx":
				extname = "excel";
				break;
			case "doc":
			case "docx":
				extname = "word";
				break;
			case "ppt":
			case "pptx":
				extname = "ppt";
				break;
			case "jpg":
			case "jpeg":
			case "gif":
			case "png":
			case "bmp":
				extname = "image";
				break;
			case "rar":
			case "zip":
			case "txt":
			case "project":
				break;
			default:
				extname = "unknow";
			}
			m.put("imgType", extname);
		}
		return list;
	}

	public SysAttachment get(String id) {
		return super.get(id);
	}

	public List<SysAttachment> findList(SysAttachment sysAttachment) {
		return super.findList(sysAttachment);
	}

	public Page<SysAttachment> findPage(Page<SysAttachment> page, SysAttachment sysAttachment) {
		return super.findPage(page, sysAttachment);
	}

	@Transactional(readOnly = false)
	public void save(SysAttachment sysAttachment) {
	    if(StringUtil.isNotEmpty(sysAttachment.getName())){
	        super.save(sysAttachment);
	    }else{
	        logger.error("附件名称不能为空！");
	    }

	}

	/**
	 * @param content
	 *            需要处理的内容,注意需要未转义的内容,注意处理ftp的http占位字符串(存进数据库的ftp链接头要用FtpUtil.
	 *            FTP_MARKER替换)
	 * @param attachMentUid
	 * @param attachMentType
	 * @param attachMentFileStep
	 * @return map key:ret,content ret=0代表无url需要处理，1代表有url被处理，content为处理后的内容
	 */
	@Transactional(readOnly = false)
	public Map<String, String> moveAndSaveTempFile(String content, String attachMentUid, FileTypeEnum attachMentType,
			FileStepEnum attachMentFileStep) {
		try {
			Map<String, String> map = new HashMap<String, String>();
			int tag = 0;// 判断是否存在需要处理的新增ftp链接 （含有/temp/的）
			Set<String> set = getFtpFileUrl(content);// 获取所有ftp链接
			SysAttachment sa = new SysAttachment();
			sa.setUid(attachMentUid);
			sa.setType(attachMentType);
			sa.setFileStep(attachMentFileStep);
			deleteByCdnNotInSet(sa, getOldFileUrl(set));// 删除所有不在content内容里的文件（ftp和数据库）
			if (set != null && set.size() > 0) {

				for (String tempstr : set) {
					if (tempstr.contains("/temp/")) {// 只需要处理新增的temp链接
						tag++;
						String tempurl = getParmFromUrl("url", tempstr);
						String url = VsftpUtils.moveFile(tempurl);
						SysAttachment temsa = new SysAttachment();
						temsa.setUid(attachMentUid);
						temsa.setType(attachMentType);
						temsa.setFileStep(attachMentFileStep);
						temsa.setSize(getParmFromUrl("fileSize", tempstr));
						temsa.setName(getParmFromUrl("fielTitle", tempstr));
						temsa.setSuffix(getParmFromUrl("fielType", tempstr));
						temsa.setUrl(url);
						save(temsa);
						content = content.replaceAll(escapeExprSpecialWord(tempurl),url);
					}
				}
			}
			if (tag == 0) {
				map.put(CoreJkey.JK_RET, "0");
			} else {
				map.put(CoreJkey.JK_RET, "1");
			}
			map.put("content", content);
			return map;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
//	//处理证书模板
//	public  Map<String,String> moveAndSaveTempFile(List<CertElement> els,String attachMentUid,FileTypeEnum attachMentType,FileStepEnum attachMentFileStep) throws Exception{
//		Map<String,String> map=new HashMap<String,String>();//存放key-temp url和移动之后的value-url
//		Set<String> set=getFtpFileUrl(els);//获取所有ftp链接
//		SysAttachment sa=new SysAttachment();
//		sa.setUid(attachMentUid);
//		sa.setType(attachMentType);
//		sa.setFileStep(attachMentFileStep);
//		deleteByCdnNotInSet(sa,getOldFileUrl(set));//删除所有不在content内容里的文件（ftp和数据库）
//		if(set!=null&&set.size()>0){
//			for(String tempstr:set){
//				if(tempstr.contains("/temp/")){//只需要处理新增的temp链接
//					String tempurl=tempstr.split("\\?")[0];
//					String tempparam=tempstr.split("\\?")[1];
//					String url=VsftpUtils.moveFile("/tool"+tempurl.replace(FtpUtil.FTP_HTTPURL, ""));
//					SysAttachment temsa=new SysAttachment();
//					temsa.setUid(attachMentUid);
//					temsa.setType(attachMentType);
//					temsa.setFileStep(attachMentFileStep);
//					temsa.setSize(tempparam.split("&")[0].split("=")[1]);
//					temsa.setName(tempparam.split("&")[1].split("=")[1]);
//					temsa.setSuffix(tempparam.split("&")[2].split("=")[1]);
//					temsa.setUrl(url);
//					save(temsa);
//					map.put(tempstr, url);
//				}
//			}
//		}
//		return map;
//	}
//	private Set<String> getFtpFileUrl(List<CertElement> list) {
//		Set<String> set = new HashSet<String>();
//		if(list!=null&&list.size()>0){
//			for(CertElement c:list){
//				if(StringUtil.isNotEmpty(c.getUrl())){
//					set.add(c.getUrl());
//				}
//			}
//		}
//		return set;
//	}
	private Set<String> getOldFileUrl(Set<String> set) {
		Set<String> oldset = new HashSet<String>();
		for (String tempstr : set) {
			if (!tempstr.contains("/temp/")) {
				oldset.add(getParmFromUrl("url", tempstr));
			}
		}
		return oldset;
	}
	private String getUrlFromUrl(String url) {
		if (StringUtil.isEmpty(url)) {
			return null;
		}
		String[] temss=url.split("\\?");
		if (temss.length==0) {
			return null;
		}
		String purl=temss[0];
		if (StringUtil.isEmpty(purl)) {
			return null;
		}
		return purl;
	}
	private String getParmFromUrl(String pname,String url) {
		if (StringUtil.isEmpty(pname)||StringUtil.isEmpty(url)) {
			return null;
		}
		String[] temss=url.split("\\?");
		if (temss.length==1) {
			return null;
		}
		String pramstr=temss[1];
		if (StringUtil.isEmpty(pramstr)) {
			return null;
		}
		String[] temss2=pramstr.split("&");
		if (temss2==null||temss2.length==0) {
			return null;
		}
		for(String s:temss2) {
			String[] temss3=s.split("=");
			if (temss3!=null&&temss3.length==2&&pname.equals(temss3[0])) {
				return temss3[1];
			}
		}
		return null;
	}

	private Set<String> getFtpFileUrl(String content) {
		HttpServletRequest request = Servlets.getRequest();
		Set<String> set = new HashSet<String>();
		String regxpForTag = "(['\"])(" + getFtpDownurl(request) + "(.(?!\\1))*.)\\1";
		Pattern patternForTag = Pattern.compile(regxpForTag, Pattern.CASE_INSENSITIVE);
		Matcher matcherForTag = patternForTag.matcher(content);
		while (matcherForTag.find()) {
			set.add(matcherForTag.group(2));
		}
		return set;
	}
	private String getFtpDownurl(HttpServletRequest request){
	    if(request != null){
    		String url = request.getRequestURI();
    		if(url!=null&&(url.endsWith("/a")||url.indexOf("/a/") > -1)){
    			return Global.getAdminPath()+FtpUtil.FTP_DOWNURL;
    		}
    		if(url!=null&&(url.endsWith("/f")||url.indexOf("/f/") > -1||StringUtil.LINE.equals(url))){
    			return Global.getFrontPath()+FtpUtil.FTP_DOWNURL;
    		}
        }
		return FtpUtil.FTP_DOWNURL;
	}

	@Transactional(readOnly = false)
	public Map<String, SysAttachment> saveByVo(AttachMentEntity vo, String attachMentUid) {
		Map<String, SysAttachment> map = new HashMap<String, SysAttachment>();
		try {
			if (vo != null && vo.getFielFtpUrl() != null && vo.getFielFtpUrl().size() > 0) {

				for (int i = 0; i < vo.getFielFtpUrl().size(); i++) {
					SysAttachment sa = new SysAttachment();
					sa.setUid(attachMentUid);
					sa.setName(URLDecoder.decode(URLDecoder.decode(vo.getFielTitle().get(i), FileUtil.UTF_8),FileUtil.UTF_8));
					sa.setGnodeId(vo.getGnodeId());
					sa.setSuffix(vo.getFielType().get(i));
					sa.setSize(vo.getFielSize().get(i));
					sa.setType(FileTypeEnum.getByValue(vo.getFileTypeEnum().get(i)));
					sa.setFileStep(FileStepEnum.getByValue(vo.getFileStepEnum().get(i)));
					sa.setUrl(VsftpUtils.moveFile(vo.getFielFtpUrl().get(i)));
					save(sa);
					VsftpUtils.word2PDF(sa.getUrl());
					map.put(vo.getFielFtpUrl().get(i), sa);
				}
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		return map;
	}

	/**
	 * @return Map key-临时目录url，value-正式目录url
	 */
	@Transactional(readOnly = false)
	public Map<String, SysAttachment> saveByVo(AttachMentEntity vo, String attachMentUid, FileTypeEnum attachMentType,
			FileStepEnum attachMentFileStep) {
		if (vo != null && vo.getFielFtpUrl() != null && vo.getFielFtpUrl().size() > 0) {
			List<String> titleList = vo.getFielTitle();
			if (StringUtil.checkNotEmpty(titleList)) {
				for (String titleName : titleList) {
					int i = 0;
					for (String titleNameIn : titleList) {
						if (titleNameIn.equals(titleName)) {
							i++;
						}
					}
					if (i > 1) {
						throw new RuntimeException("上传附件中含有相同附件");
					}
				}
			}
		}
		Map<String, SysAttachment> map = new HashMap<String, SysAttachment>();
		try {
			if (vo != null && vo.getFielFtpUrl() != null && vo.getFielFtpUrl().size() > 0) {
				String[] gnodeIds=new String[]{};
				if(StringUtil.isNotEmpty(vo.getGnodeId())){
					gnodeIds=vo.getGnodeId().split(",");
				}
				for (int i = 0; i < vo.getFielFtpUrl().size(); i++) {
					SysAttachment sa = new SysAttachment();
					sa.setUid(attachMentUid);
					sa.setName(URLDecoder.decode(URLDecoder.decode(vo.getFielTitle().get(i), FileUtil.UTF_8),FileUtil.UTF_8));
					if(gnodeIds.length>0 && (gnodeIds.length==vo.getFielFtpUrl().size())){
						sa.setGnodeId(gnodeIds[i]);
					}else{
						sa.setGnodeId(vo.getGnodeId());
					}
					sa.setSuffix(vo.getFielType().get(i));
					sa.setSize(vo.getFielSize().get(i));
					sa.setType(attachMentType);
					if(attachMentFileStep!=null){
						sa.setFileStep(attachMentFileStep);
					}
					sa.setUrl(VsftpUtils.moveFile(vo.getFielFtpUrl().get(i)));
					save(sa);
					VsftpUtils.word2PDF(sa.getUrl());
					map.put(vo.getFielFtpUrl().get(i), sa);
				}
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		return map;
	}


	/**
	 * @param  vo 临时目录url，转换正式目录url
	 */
	@Transactional(readOnly = false)
	public void saveBySysAttachmentVo(List<SysAttachment> vo, String attachMentUid, FileTypeEnum attachMentType,
				FileStepEnum attachMentFileStep) {
		try {
			if (vo != null  && vo.size() > 0) {
				for (int i = 0; i < vo.size(); i++) {
					SysAttachment sa = vo.get(i);
					sa.setUid(attachMentUid);
					sa.setType(attachMentType);
					if(attachMentFileStep!=null){
						sa.setFileStep(attachMentFileStep);
					}
					sa.setFtpUrl(VsftpUtils.moveFile(sa.getFtpUrl()));
					save(sa);
					VsftpUtils.word2PDF(sa.getUrl());
				}
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}


	@Transactional(readOnly = false)
	public void saveFileForImp(ProModel pd, ActYw ay,FileTypeEnum attachMentType, FileStepEnum attachMentFileStep) {
//		try {
//			ProProject pp=ay.getProProject();
//			if((pd == null) || StringUtil.isEmpty(pd.getPName())){
//	            throw new RuntimeException("名称为空,导致空指针异常，请检查文件标题是否为第(" + ImpDataController.descHeadRow + 1 +")行开始！");
//			}
//			String pnamemd5=MD5Util.string2MD5(pd.getPName());
//			String path=ImpDataService.tempProModelFilePath+pp.getProType()+pp.getType()+StringUtil.LINE+pnamemd5;
//			FTPFile[] ffs=VsftpUtils.getFiles(path);
//			if(ffs==null){
//			    logger.warn("没有找到对应的附件信息！路径：" + path);
//				return;
//			}
//
//			for (FTPFile ff:ffs) {
//				if(ff.isFile()){
//					String sname = ff.getName().substring(0,ff.getName().lastIndexOf("."));
//					String suffix = ff.getName().substring(ff.getName().lastIndexOf(".") + 1).toLowerCase();
//					String fname=(String)CacheUtils.get(CacheUtils.GcontestImpFile_CACHE+pnamemd5+sname);
//					SysAttachment sa = new SysAttachment();
//					sa.setUid(pd.getId());
//					sa.setName(fname);
//					sa.setSuffix(suffix);
//					sa.setSize(ff.getSize()+"");
//					sa.setType(attachMentType);
//					sa.setFileStep(attachMentFileStep);
//					String newPath=ImpDataService.proModelFilePath+DateUtil.getDate("yyyy-MM-dd")+StringUtil.LINE+IdGen.uuid()+"."+suffix;
//					sa.setUrl(VsftpUtils.moveFile(path+StringUtil.LINE+ff.getName(),newPath));
//					save(sa);
//					CacheUtils.remove(CacheUtils.GcontestImpFile_CACHE+pnamemd5+sname);
//					VsftpUtils.word2PDF(sa.getUrl());
//				}
//			}
//		} catch (Exception e) {
//			throw new RuntimeException(e);
//		}
	}
	@Transactional(readOnly = false)
	public Map<String, SysAttachment> saveByVo(ProReport proReport, FileTypeEnum attachMentType) {
		Map<String, SysAttachment> map = new HashMap<>();
		AttachMentEntity attachment = proReport.getAttachMentEntity();
		try {
			if (attachment != null && attachment.getFielFtpUrl() != null && attachment.getFielFtpUrl().size() > 0) {

				for (int i = 0; i < attachment.getFielFtpUrl().size(); i++) {
					SysAttachment sa = new SysAttachment();
					sa.setUid(proReport.getProModelId());
					sa.setName(URLDecoder.decode(URLDecoder.decode(attachment.getFielTitle().get(i), FileUtil.UTF_8),
							FileUtil.UTF_8));
					sa.setGnodeId(proReport.getGnodeId());
					sa.setSuffix(attachment.getFielType().get(i));
					sa.setSize(attachment.getFielSize().get(i));
					sa.setType(attachMentType);
					sa.setUrl(VsftpUtils.moveFile(attachment.getFielFtpUrl().get(i)));
					save(sa);
					VsftpUtils.word2PDF(sa.getUrl());
					map.put(attachment.getFielFtpUrl().get(i), sa);
				}
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		return map;
	}

	@Transactional(readOnly = false)
	public void delete(SysAttachment sysAttachment) {
		super.delete(sysAttachment);
	}
	@Transactional(readOnly = false)
	public boolean delFile(String id,String url) {
		if (StringUtil.isNotEmpty(id)) {
			SysAttachment sysAttachment = new SysAttachment();
			sysAttachment.setId(id);
			delete(sysAttachment);
		}
		return delFile(url);
	}
	public boolean delFile(String url) {
		String remotePath = url.substring(0, url.lastIndexOf(StringUtil.LINE) + 1);
		String fileName = url.substring(url.lastIndexOf(StringUtil.LINE) + 1);
		try {
			return VsftpUtils.removeFile(remotePath, fileName);
		} catch (FtpException e) {
			return false;
		}
	}
	@Transactional(readOnly = false)
	public void saveList(List<Map<String, String>> maps, FileTypeEnum type, FileStepEnum fileStep, String uid) {
		try {
			if (maps != null) {

				for (Map<String, String> map : maps) {
					SysAttachment sa = new SysAttachment();
					sa.setUid(uid);
					sa.setName(map.get("arrName"));
					String[] ss = map.get("arrName").split("\\.");
					sa.setSuffix(ss[ss.length - 1]);
					sa.setType(type);
					sa.setFileStep(fileStep);
					sa.setUrl(VsftpUtils.moveFile(map.get("arrUrl")));
					super.save(sa);
				}
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	public List<VsFile> getVsFiles(FileTypeEnum proType, List<String> uids, List<String> fileSteps,String distDir) {
		List<VsFile> vsFiles = Lists.newArrayList();
		SysAttachment psysAtt = new SysAttachment();
		if ((uids == null) || (proType == null)) {
			return vsFiles;
		}
		psysAtt.setType(proType);
		psysAtt.setUids(uids);
		if (fileSteps != null) {
			psysAtt.setFileSteps(fileSteps);
		}
		List<SysAttachment> sysAtts = dao.findListInIds(psysAtt);
		for (SysAttachment sysAtt : sysAtts) {
			User cuser = sysAtt.getCreateBy();
			if ((cuser != null) && (cuser.getOffice() != null)) {
				VsFile vsFile = new VsFile();
				vsFile.setRemotePath(sysAtt.getRemotePath());
				vsFile.setRfileName(sysAtt.getFileName());
				vsFile.setLocalPath(distDir + FileUtil.LINE + sysAtt.getFileStep().getName() + FileUtil.LINE
						+ cuser.getOffice().getName());
				vsFile.setLfileName(sysAtt.getName(cuser.getName() + cuser.getNo()));
				vsFiles.add(vsFile);
			}
		}
		return vsFiles;
	}

	/**
	 * 根据项目负责人所属的机构生成导出附件的目录.
	 * @param proType
	 * @param uids
	 * @param gnodeName
	 * @param distDir
	 * @return
	 */
	public List<VsFile> getVsGnodeFiles(FileTypeEnum proType, List<String> uids, String gnodeName,String distDir) {
	    return getVsGnodeFilesByImpProModel(proType, uids, Lists.newArrayList(), gnodeName, distDir);
	}
    public List<VsFile> getVsGnodeFilesByImpProModel(FileTypeEnum proType, List<String> uids, List<ProModel> pds, String gnodeName,String distDir) {
		List<VsFile> vsFiles = Lists.newArrayList();
		SysAttachment psysAtt = new SysAttachment();
		if ((uids == null) || (proType == null)) {
			return vsFiles;
		}
		psysAtt.setType(proType);
		psysAtt.setUids(uids);
		List<SysAttachment> sysAtts = dao.findListInIdsByPpg(psysAtt);
		for (SysAttachment sysAtt : sysAtts) {
		    ProModel curPd = null;
            if(StringUtil.isEmpty(sysAtt.getUid())){
                logger.warn("导出附件存在垃圾数据,没有uid,数据ID = "+sysAtt.getId());
                continue;
            }

//            for (ProModel pd : pds) {
//                if((sysAtt.getUid()).equals(pd.getId())){
//                    curPd = pd;
//                    break;
//                }
//            }

            User cuser = sysAtt.getCreateBy();
			if ((cuser != null) && (cuser.getOffice() != null)) {
				VsFile vsFile = new VsFile();
				vsFile.setRemotePath(sysAtt.getRemotePath());
				vsFile.setRfileName(sysAtt.getFileName());
				vsFile.setLocalPath(distDir + FileUtil.LINE + gnodeName + FileUtil.LINE + cuser.getOffice().getName());
	            String prefix = null;
	            if(curPd == null){
	                prefix = cuser.getName() + cuser.getNo();
	                vsFile.setLfileName(sysAtt.getName(prefix));
	            }else{
	                prefix = cuser.getName() + FileUtil.LINE_D + curPd.getPName() + FileUtil.LINE_D;
	                vsFile.setLfileName(prefix + sysAtt.getName());
	            }
				vsFiles.add(vsFile);
			}
		}
		return vsFiles;
	}

	/**
	 * 根据导入规则生成导出附件的目录.
	 * @param proType
	 * @param uids
	 * @param gnodeName
	 * @param distDir
	 * @return
	 */
//	public List<VsFile> getVsGnodeFilesByImpProjectDeclare(FileTypeEnum proType, List<String> uids, List<ProjectDeclare> pds, String gnodeName,String distDir) {
//	    List<VsFile> vsFiles = Lists.newArrayList();
//	    SysAttachment psysAtt = new SysAttachment();
//	    if ((uids == null) || (proType == null)) {
//	        return vsFiles;
//	    }
//	    psysAtt.setType(proType);
//	    psysAtt.setUids(uids);
//	    List<SysAttachment> sysAtts = dao.findListInIdsByPpg(psysAtt);
//	    for (SysAttachment sysAtt : sysAtts) {
//	        ProjectDeclare curPd = null;
//	        if(StringUtil.isEmpty(sysAtt.getUid())){
//	            logger.warn("导出附件存在垃圾数据,没有uid,数据ID = "+sysAtt.getId());
//                continue;
//	        }
//
//	        for (ProjectDeclare pd : pds) {
//	            if((sysAtt.getUid()).equals(pd.getId())){
//	                curPd = pd;
//	                break;
//	            }
//	        }
//
//	        if(curPd == null){
//	            continue;
//	        }
//
//	        User cuser = sysAtt.getCreateBy();
//	        if ((cuser != null) && (cuser.getOffice() != null)) {
//	            VsFile vsFile = new VsFile();
//	            vsFile.setRemotePath(sysAtt.getRemotePath());
//	            vsFile.setRfileName(sysAtt.getFileName());
//                vsFile.setLfileName(curPd.getLeaderString() + FileUtil.LINE_D + curPd.getName() + FileUtil.LINE_D + sysAtt.getName());
//	            vsFile.setLocalPath(distDir + FileUtil.LINE + gnodeName);
//	            vsFiles.add(vsFile);
//	        }
//	    }
//	    return vsFiles;
//	}

	/**
	 * 下载附件到指定目录.
	 *
	 * @param uids
	 *            项目ID
	 * @param fileSteps
	 *            步骤
	 * @param distDir
	 *            存放目录
	 * @return FileVo
	 * @throws FtpException
	 */
	public FileVo downloads(FileTypeEnum proType, List<String> uids, List<String> fileSteps, String distDir) throws FtpException {
		List<VsFile> vsFiles = Lists.newArrayList();
		SysAttachment psysAtt = new SysAttachment();
		if ((uids == null) || (proType == null)) {
			return new FileVo(FileVo.FAIL);
		}
		psysAtt.setType(proType);
		psysAtt.setUids(uids);
		if (fileSteps != null) {
			psysAtt.setFileSteps(fileSteps);
		}
		List<SysAttachment> sysAtts = dao.findListInIds(psysAtt);
		for (SysAttachment sysAtt : sysAtts) {
			User cuser = sysAtt.getCreateBy();
			if ((cuser != null) && (cuser.getOffice() != null)) {
				VsFile vsFile = new VsFile();
				vsFile.setRemotePath(sysAtt.getRemotePath());
				vsFile.setRfileName(sysAtt.getFileName());
				vsFile.setLocalPath(distDir + FileUtil.LINE + sysAtt.getFileStep().getName() + FileUtil.LINE
						+ cuser.getOffice().getName());
				vsFile.setLfileName(sysAtt.getName(cuser.getName() + cuser.getNo()));
				vsFiles.add(vsFile);
			}
		}
		return VsftpUtils.downFiles(vsFiles);
	}

	/**
		 * 下载附件到指定目录.
		 *
		 * @param uids
		 *            项目ID
		 *            步骤
		 * @param distDir
		 *            存放目录
		 * @return FileVo
		 * @throws FtpException
		 */
	public FileVo downGnodeloads(FileTypeEnum proType, List<String> uids, String gnodeName, String distDir) throws FtpException {
		List<VsFile> vsFiles = Lists.newArrayList();
		SysAttachment psysAtt = new SysAttachment();
		if ((uids == null) || (proType == null)) {
			return new FileVo(FileVo.FAIL);
		}
		psysAtt.setType(proType);
		psysAtt.setUids(uids);
		List<SysAttachment> sysAtts = dao.findListInIds(psysAtt);
		for (SysAttachment sysAtt : sysAtts) {
			User cuser = sysAtt.getCreateBy();
			if ((cuser != null) && (cuser.getOffice() != null)) {
				VsFile vsFile = new VsFile();
				vsFile.setRemotePath(sysAtt.getRemotePath());
				vsFile.setRfileName(sysAtt.getFileName());
				vsFile.setLocalPath(distDir + FileUtil.LINE + gnodeName + FileUtil.LINE
						+ cuser.getOffice().getName());
				vsFile.setLfileName(sysAtt.getName(cuser.getName() + cuser.getNo()));
				vsFiles.add(vsFile);
			}
		}
		return VsftpUtils.downFiles(vsFiles);
	}


	public SysAttachment getByUrl(String url) {
		return dao.getByUrl(url);
	}

	public void updateAtt(String gId, String oldGidId) {
		dao.updateAtt(gId, oldGidId);
	}

	public static String escapeExprSpecialWord(String keyword) {
		if (StringUtils.isNotEmpty(keyword)) {
			String[] fbsArr = { "\\", "$", "(", ")", "*", "+", ".", "[", "]", "?", "^", "{", "}", "|" };
			for (String key : fbsArr) {
				if (keyword.contains(key)) {
					keyword = keyword.replace(key, "\\" + key);
				}
			}
		}
		return keyword;
	}

	/**
	 * 查询流程节点附件附件.
	 *
	 * @param sysAttachment
	 *            查询条件
	 * @param fstep
	 *            附件子类别
	 * @param request
	 * @param response

	 * @return List
	 */
	@Transactional(readOnly = false)
	public List<SysAttachment> ajaxIcons(SysAttachment sysAttachment, String fstep, HttpServletRequest request,
			HttpServletResponse response) {
		/**
		 * 查询条件.
		 */
		sysAttachment.setType(FileTypeEnum.S_FLOW_ICON);
		List<String> fsteps = Lists.newArrayList();
		if (StringUtil.isNotEmpty(fstep)) {
			fsteps.add(fstep);
		} else {
			fsteps.add(FileStepEnum.S_FLOW_NODELV1.getValue());
			fsteps.add(FileStepEnum.S_FLOW_NODELV2.getValue());
		}

		return findList(sysAttachment);
	}

	/**
	 * 获取根据UID附件.
	 *
	 * @param uid
	 *            业务ID
	 * @param type
	 *            附件类型
	 * @param fstep
	 *            附件子类别
	 * @param fsteps
	 *            子类别集合，逗号分隔
	 * @param gnodeId
	 *            节点ID
	 * @return ActYwApiStatus
	 */
	@Transactional(readOnly = false)
	public ApiTstatus<List<SysAttachment>> ajaxFiles(String uid, String type, String fstep, String fsteps,
			String gnodeId) {
		if (StringUtil.isEmpty(type)) {
			return new ApiTstatus<List<SysAttachment>>(false, "获取失败, type不能为空！");
		}

		FileTypeEnum fileTypeEnum = FileTypeEnum.getByValue(type);
		if (fileTypeEnum == null) {
			return new ApiTstatus<List<SysAttachment>>(false, "获取失败, type未定义！");
		}

		SysAttachment sysAttachment = new SysAttachment(uid, fileTypeEnum);
		if (StringUtil.isNotEmpty(fstep)) {
			FileStepEnum fileStepEnum = FileStepEnum.getByValue(fstep);
			if (fileStepEnum != null) {
				sysAttachment.setFileStep(fileStepEnum);
			}
		}

		if (StringUtil.isNotEmpty(fsteps)) {
			List<String> fstepsList = Arrays.asList(StringUtil.split(fsteps, StringUtil.DOTH));
			if (fstepsList.size() > 0) {
				sysAttachment.setFileSteps(fstepsList);
			}
		}

		if (StringUtil.isNotEmpty(gnodeId)) {
			sysAttachment.setGnodeId(gnodeId);
		}
		List<SysAttachment> sysAttachments = findList(sysAttachment);
		if ((sysAttachments == null) || (sysAttachments.size() <= 0)) {
			return new ApiTstatus<List<SysAttachment>>(true, "查询结果为空！");
		}
		return new ApiTstatus<List<SysAttachment>>(true, "查询成功！", sysAttachments);
	}

	/**
	 * 异步上传附件. 默认移动,传false表示不移动，需要手动移动
	 *
	 * @param ftype
	 *            类型
	 * @param fileStep
	 *            类别
	 * @param uid
	 *            业务ID
	 * @param isMove
	 *            是否移动
	 * @param fileName
	 *            文件名
	 * @param request
	 *            请求
	 *            模型
	 * @return ApiStatus
	 * @throws IOException
	 */
	@Transactional(readOnly = false)
	public ApiTstatus<JSONObject> ajaxUpload(String ftype, String fileStep, String uid, Boolean isMove,
			String fileName, HttpServletRequest request) throws IOException {
		if (StringUtil.isEmpty(ftype) || StringUtil.isEmpty(fileStep)) {
			return new ApiTstatus<JSONObject>(false, "上传失败, type和fileStep不能为空！");
		}

		FileTypeEnum fileTypeEnum = FileTypeEnum.getByValue(ftype);
		FileStepEnum fileStepEnum = FileStepEnum.getByValue(fileStep);
		if ((fileTypeEnum == null)) {
			return new ApiTstatus<JSONObject>(false, "上传失败, type类型未定义！");
		}
		if ((fileStepEnum == null)) {
			return new ApiTstatus<JSONObject>(false, "上传失败, fileStep类型未定义！");
		}
		JSONObject obj = uploadTempBiz(request);
		SysAttachment newsysAttachment =new SysAttachment();
		newsysAttachment.setUrl(obj.getString("url"));    //图片地址
		newsysAttachment.setFtpUrl(obj.getString("ftpUrl"));    //图片地址

		newsysAttachment.setSuffix(obj.getString("type"));  //后缀
		newsysAttachment.setName(obj.getString("original"));//文件名
				//ueditorUploadService.upload(request);
//		if (newsysAttachment == null) {
//			return new ActYwApiStatus<SysAttachment>(false, "上传失败！");
//		}
//
//		if (StringUtil.isNotEmpty(uid)) {
//			newsysAttachment.setUid(uid);
//		} else {
//			newsysAttachment.setUid(IdGen.uuid());
//		}
//
//		if (StringUtil.isNotEmpty(fileName)) {
//			newsysAttachment.setName(fileName);
//		}
//
//		/**
//		 * 移动附件到目录. 默认移动,传false表示不移动，需要手动移动
//		 */
//		if ((isMove == null) || isMove) {
//			String url = VsftpUtils.moveFile(newsysAttachment.getUrl());
//			if (StringUtil.isEmpty(url)) {
//				throw new FileDealException();
//			}
//			newsysAttachment.setUrl(url);
//		}
//
//		newsysAttachment.setType(fileTypeEnum);
//		newsysAttachment.setFileStep(fileStepEnum);
//		save(newsysAttachment);

		return new ApiTstatus<JSONObject>(true, "上传成功！", obj);
	}

	/**
	 * 异步删除附件.
	 *
	 * @param fileUrl
	 *            附件地址
	 * @param id
	 *            类型
	 * @return ActYwApiStatus
	 */
	@Transactional(readOnly = false)
	public ApiTstatus<SysAttachment> ajaxDelete(String fileUrl, String id,
			HttpServletRequest request, HttpServletResponse response) {
		if (StringUtil.isNotEmpty(id)) {
			SysAttachment sysAttachment = get(id);
			if ((sysAttachment == null)) {
				return new ApiTstatus<SysAttachment>(false, "删除失败, 附件记录不存在！");
			} else {
				delete(sysAttachment);
			}

			if (StringUtil.isEmpty(fileUrl)) {
				fileUrl = sysAttachment.getUrl();
			}
		}

		boolean isDel = false;
		if (StringUtil.isNotEmpty(fileUrl)) {
			isDel = delFile(fileUrl);
		}
		if (isDel) {
			return new ApiTstatus<SysAttachment>(true, "删除成功！", new SysAttachment(id));
		} else {
			throw new FileDealException();
		}
	}

	/**
	 * 异步移动附件.
	 *
	 * @param id
	 *            类型
	 * @return ActYwApiStatus
	 * @throws IOException
	 * @throws FtpException
	 */
	@Transactional(readOnly = false)
	public ApiTstatus<SysAttachment> ajaxMoveFtpFile(String id, HttpServletRequest request,
			HttpServletResponse response) throws FtpException, IOException {
		if (StringUtil.isEmpty(id)) {
			return new ApiTstatus<SysAttachment>(false, "删除失败, 附件记录ID不能为空！");
		}

		SysAttachment sysAttachment = get(id);
		if ((sysAttachment == null)) {
			return new ApiTstatus<SysAttachment>(false, "删除失败, 附件记录不存在！");
		}

		String url = VsftpUtils.moveFile(sysAttachment.getUrl());
		if (StringUtil.isEmpty(url)) {
			throw new FileDealException();
		}
		sysAttachment.setUrl(url);
		save(sysAttachment);
		return new ApiTstatus<SysAttachment>(true, "移动成功！", sysAttachment);

	}

	@Transactional(readOnly = false)
	public void deleteByStep(SysAttachment s) {
		{
			dao.deleteByCdn(s);
		}
	}

	public String moveTempFile(String purl,String attachMentUid, FileTypeEnum attachMentType,FileStepEnum attachMentFileStep) throws Exception{
		String url=getUrlFromUrl(purl);
		if(url!=null){
			String nurl=VsftpUtils.moveFile(url);
			SysAttachment sa = new SysAttachment();
			sa.setUid(attachMentUid);
			sa.setName(getParmFromUrl(FileUtil.FILE_NAME, purl));
			if(sa.getName()==null){
				sa.setName("logoUrl");
			}
			sa.setSuffix(getParmFromUrl("fielType", purl));
			if(sa.getSuffix()==null){
				sa.setSuffix("fielType");
			}
			sa.setSize(getParmFromUrl("fileSize", purl));
			if(sa.getSize()==null){
				sa.setSize("fileSize");
			}
			sa.setType(attachMentType);
			sa.setFileStep(attachMentFileStep);
			sa.setUrl(nurl);
			save(sa);
			return sa.getId();
		}
		return null;
	}
}