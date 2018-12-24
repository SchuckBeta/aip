package com.oseasy.initiate.modules.attachment.vo;

import com.oseasy.initiate.modules.attachment.enums.FileStepEnum;
import com.oseasy.initiate.modules.attachment.enums.FileTypeEnum;
import com.oseasy.pcore.common.persistence.DataEntity;
import com.oseasy.pcore.common.utils.FtpUtil;
import com.oseasy.putil.common.utils.FileUtil;
import com.oseasy.putil.common.utils.StringUtil;

import org.hibernate.validator.constraints.Length;

import java.util.List;

/**
 * 附件信息表Entity
 * @author zy
 * @version 2017-03-23
 */
public class SysAttachmentVo extends DataEntity<SysAttachmentVo> {

	private static final long serialVersionUID = 1L;
	private String id;		// id
	private String url;		// url
	private String title;		// 名称
	private String suffix;		// 后缀
	private String name;		// 后缀
	private String type;		// 后缀
	private String ftpUrl;		// 后缀

	@Override
	public String getId() {
		return id;
	}

	@Override
	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getFtpUrl() {
		return ftpUrl;
	}

	public void setFtpUrl(String ftpUrl) {
		this.ftpUrl = ftpUrl;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getSuffix() {
		return suffix;
	}

	public void setSuffix(String suffix) {
		this.suffix = suffix;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
}