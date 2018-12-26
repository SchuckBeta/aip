package com.oseasy.pcms.modules.cms.entity;

import javax.validation.constraints.NotNull;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 站点模板主题Entity.
 * @author chenh
 * @version 2018-12-25
 */
public class CmstTheme extends DataExtEntity<CmstTheme> {

	private static final long serialVersionUID = 1L;
	private CmsTpl tpl;		// 模板ID
	private CmsTheme theme;		// 模板类型

	public CmstTheme() {
		super();
	}

	public CmstTheme(String id){
		super(id);
	}

	public CmsTpl getTpl() {
        return tpl;
    }

    public void setTpl(CmsTpl tpl) {
        this.tpl = tpl;
    }

    public CmsTheme getTheme() {
        return theme;
    }

    public void setTheme(CmsTheme theme) {
        this.theme = theme;
    }

    @Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}