package com.oseasy.pcms.modules.cms.entity;

import javax.validation.constraints.NotNull;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
import org.hibernate.validator.constraints.Length;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.oseasy.pcore.common.persistence.TreeEntity;

/**
 * 模板类型Entity.
 * @author chenh
 * @version 2018-12-25
 */
public class CmstType extends TreeEntity<CmstType> {

	private static final long serialVersionUID = 1L;
	private CmstType parent;		// 父级编号
	private String parentIds;		// 所有父级编号
	private String name;		// 名称

	public CmstType() {
		super();
	}

	public CmstType(String id){
		super(id);
	}

	@JsonBackReference
	@NotNull(message="父级编号不能为空")
	public CmstType getParent() {
		return parent;
	}

	public void setParent(CmstType parent) {
		this.parent = parent;
	}

	@Length(min=1, max=2000, message="所有父级编号长度必须介于 1 和 2000 之间")
	public String getParentIds() {
		return parentIds;
	}

	public void setParentIds(String parentIds) {
		this.parentIds = parentIds;
	}

	@Length(min=1, max=100, message="名称长度必须介于 1 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getParentId() {
		return parent != null && parent.getId() != null ? parent.getId() : "0";
	}

	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}