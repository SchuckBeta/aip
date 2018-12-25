package com.oseasy.initiate.modules.cms.entity;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
import org.hibernate.validator.constraints.Length;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 主题明细Entity.
 * @author chenhao
 * @version 2018-12-25
 */
public class CmsThemeDetail extends DataExtEntity<CmsThemeDetail> {

	private static final long serialVersionUID = 1L;
	private CmsTheme theme;		// 主题编号
	private String name;		// 名称
	private String color;		// 颜色

	public CmsThemeDetail() {
		super();
	}

	public CmsThemeDetail(String id){
		super(id);
	}

	public CmsTheme getTheme() {
		return theme;
	}

	public void setTheme(CmsTheme theme) {
		this.theme = theme;
	}

	@Length(min=1, max=100, message="名称长度必须介于 1 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Length(min=1, max=100, message="颜色长度必须介于 1 和 100 之间")
	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}


	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}