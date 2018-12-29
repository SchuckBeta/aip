package com.oseasy.pgen.modules.gen.entity;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import org.hibernate.validator.constraints.Length;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 模板组Entity.
 * @author chenh
 * @version 2018-12-29
 */
public class GenTgroup extends DataExtEntity<GenTgroup> {

	private static final long serialVersionUID = 1L;
	private String name;		// 名称
	private String path;		// 根路径

	public GenTgroup() {
		super();
	}

	public GenTgroup(String id){
		super(id);
	}

	@Length(min=0, max=200, message="名称长度必须介于 0 和 200 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Length(min=0, max=500, message="根路径长度必须介于 0 和 500 之间")
	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}


	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}