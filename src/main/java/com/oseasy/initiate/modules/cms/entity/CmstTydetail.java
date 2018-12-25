package com.oseasy.initiate.modules.cms.entity;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 模板类型明细Entity.
 * @author chenh
 * @version 2018-12-25
 */
public class CmstTydetail extends DataExtEntity<CmstTydetail> {

	private static final long serialVersionUID = 1L;
	private CmstType type;		// 父级编号
	private String name;		// 名称

	public CmstTydetail() {
		super();
	}

	public CmstTydetail(String id){
		super(id);
	}

	public CmstType getType() {
        return type;
    }

    public void setType(CmstType type) {
        this.type = type;
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