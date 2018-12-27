package com.oseasy.pcms.modules.cmst.entity;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 站点模板关联Entity.
 * @author chenh
 * @version 2018-12-25
 */
public class CmstRel extends DataExtEntity<CmstRel> {

	private static final long serialVersionUID = 1L;
	private CmsTpl tpl;		// 模板ID

	public CmstRel() {
		super();
	}

	public CmstRel(String id){
		super(id);
	}

	public CmsTpl getTpl() {
        return tpl;
    }

    public void setTpl(CmsTpl tpl) {
        this.tpl = tpl;
    }

    @Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}