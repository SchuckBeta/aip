package com.oseasy.pgen.modules.gen.entity;

import javax.validation.constraints.NotNull;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * GenTableFkEntity.
 * @author chenh
 * @version 2018-12-28
 */
public class GenTablefk extends DataExtEntity<GenTablefk> {

	private static final long serialVersionUID = 1L;
	private GenTable table;		// 表编号
	private GenTableColumn tabcol;		// 表列编号
	private GenTable tabfk;		// 表编号

	public GenTablefk() {
		super();
	}

	public GenTablefk(String id){
		super(id);
	}

	@NotNull(message="表编号不能为空")
	public GenTable getTable() {
		return table;
	}

	public void setTable(GenTable table) {
		this.table = table;
	}

	@NotNull(message="表列编号不能为空")
	public GenTableColumn getTabcol() {
		return tabcol;
	}

	public void setTabcol(GenTableColumn tabcol) {
		this.tabcol = tabcol;
	}

	@NotNull(message="表编号不能为空")
	public GenTable getTabfk() {
		return tabfk;
	}

	public void setTabfk(GenTable tabfk) {
		this.tabfk = tabfk;
	}


	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}