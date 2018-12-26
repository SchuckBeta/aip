package com.oseasy.pcms.modules.cms.entity;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import org.hibernate.validator.constraints.Length;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 主题Entity.
 * @author chenhao
 * @version 2018-12-25
 */
public class CmsTheme extends DataExtEntity<CmsTheme> {

	private static final long serialVersionUID = 1L;
	private String name;		// 名称
	private CmsThemeDetail tdetail;		// 名称

	public CmsTheme() {
		super();
	}

	public CmsTheme(String id){
		super(id);
	}

	@Length(min=1, max=100, message="名称长度必须介于 1 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public CmsThemeDetail getTdetail() {
        return tdetail;
    }

    public void setTdetail(CmsThemeDetail tdetail) {
        this.tdetail = tdetail;
    }

    @Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}