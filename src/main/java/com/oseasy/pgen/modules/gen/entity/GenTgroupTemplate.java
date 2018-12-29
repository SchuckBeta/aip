package com.oseasy.pgen.modules.gen.entity;

import javax.validation.constraints.NotNull;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 模板组关联Entity.
 * @author chenh
 * @version 2018-12-29
 */
public class GenTgroupTemplate extends DataExtEntity<GenTgroupTemplate> {

	private static final long serialVersionUID = 1L;
	private GenTemplate tpl;		// 编号
	private GenTgroup group;		// 编号

	public GenTgroupTemplate() {
		super();
	}

	public GenTgroupTemplate(String id){
		super(id);
	}

	@NotNull(message="编号不能为空")
	public GenTemplate getTpl() {
		return tpl;
	}

	public void setTpl(GenTemplate tpl) {
		this.tpl = tpl;
	}

	@NotNull(message="编号不能为空")
	public GenTgroup getGroup() {
		return group;
	}

	public void setGroup(GenTgroup group) {
		this.group = group;
	}


	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}