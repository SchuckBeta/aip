package com.oseasy.pcms.modules.cms.entity;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
import org.hibernate.validator.constraints.Length;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 模板Entity.
 * @author chenh
 * @version 2018-12-25
 */
public class CmsTpl extends DataExtEntity<CmsTpl> {

	private static final long serialVersionUID = 1L;
	private CmstType top;		// 模板类型(顶级)
	private CmstType type;		// 模板类型
	private String name;		// 名称

	public CmsTpl() {
		super();
	}

	public CmsTpl(String id){
		super(id);
	}

	public CmstType getTop() {
        return top;
    }

    public void setTop(CmstType top) {
        this.top = top;
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