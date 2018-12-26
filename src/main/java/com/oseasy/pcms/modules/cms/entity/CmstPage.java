package com.oseasy.pcms.modules.cms.entity;

import javax.validation.constraints.NotNull;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 模板页面Entity.
 * @author chenh
 * @version 2018-12-26
 */
public class CmstPage extends DataExtEntity<CmstPage> {

	private static final long serialVersionUID = 1L;
	private CmsTpl tpl;		// 模板ID
	private CmstPage cpage;		// 页面ID

	public CmstPage() {
		super();
	}

	public CmstPage(String id){
		super(id);
	}

	public CmsTpl getTpl() {
        return tpl;
    }

    public void setTpl(CmsTpl tpl) {
        this.tpl = tpl;
    }

    public CmstPage getCpage() {
        return cpage;
    }

    public void setCpage(CmstPage cpage) {
        this.cpage = cpage;
    }

    @Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}