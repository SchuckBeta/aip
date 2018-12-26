package com.oseasy.pcms.modules.cms.entity;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import org.hibernate.validator.constraints.Length;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 布局Entity.
 * @author chenh
 * @version 2018-12-25
 */
public class CmsLat extends DataExtEntity<CmsLat> {

	private static final long serialVersionUID = 1L;
	private String name;		// 名称

	public CmsLat() {
		super();
	}

	public CmsLat(String id){
		super(id);
	}

	@Length(min=1, max=100, message="名称长度必须介于 1 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}


	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}