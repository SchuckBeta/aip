package com.oseasy.pcms.modules.cms.entity;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 站点模板Entity.
 * @author chenh
 * @version 2018-12-25
 */
public class CmssSiteTpl extends DataExtEntity<CmssSiteTpl> {

	private static final long serialVersionUID = 1L;
	private CmsSite site;		// 站点ID（cmss_site）
	private CmsTpl tpl;		// 模板ID
	private String isOpen;		// 是否开放：0、否；1、是

	public CmssSiteTpl() {
		super();
	}

	public CmssSiteTpl(String id){
		super(id);
	}

	public CmsSite getSite() {
        return site;
    }

    public void setSite(CmsSite site) {
        this.site = site;
    }

    public CmsTpl getTpl() {
        return tpl;
    }

    public void setTpl(CmsTpl tpl) {
        this.tpl = tpl;
    }

    @Length(min=1, max=1, message="是否开放：0、否；1、是长度必须介于 1 和 1 之间")
	public String getIsOpen() {
		return isOpen;
	}

	public void setIsOpen(String isOpen) {
		this.isOpen = isOpen;
	}


	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}