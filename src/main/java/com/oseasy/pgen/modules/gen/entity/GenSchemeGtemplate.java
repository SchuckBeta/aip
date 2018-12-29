package com.oseasy.pgen.modules.gen.entity;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 模板方案组关联Entity.
 * @author chenh
 * @version 2018-12-29
 */
public class GenSchemeGtemplate extends DataExtEntity<GenSchemeGtemplate> {

	private static final long serialVersionUID = 1L;
	private GenTgroup group;		// 编号
	private GenScheme scheme;		// 编号

	public GenSchemeGtemplate() {
		super();
	}

	public GenSchemeGtemplate(String id){
		super(id);
	}

	public GenTgroup getGroup() {
		return group;
	}

	public void setGroup(GenTgroup group) {
		this.group = group;
	}

	public GenScheme getScheme() {
		return scheme;
	}

	public void setScheme(GenScheme scheme) {
		this.scheme = scheme;
	}


	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}