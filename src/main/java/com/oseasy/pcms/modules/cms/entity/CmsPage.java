package com.oseasy.pcms.modules.cms.entity;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import javax.validation.constraints.NotNull;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 页面Entity.
 * @author chenh
 * @version 2018-12-25
 */
public class CmsPage extends DataExtEntity<CmsPage> {

	private static final long serialVersionUID = 1L;

	public CmsPage() {
		super();
	}

	public CmsPage(String id){
		super(id);
	}

	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}