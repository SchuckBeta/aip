package com.oseasy.pcms.modules.cmss.entity;

import java.util.List;

import javax.validation.constraints.NotNull;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;
import org.hibernate.validator.constraints.Length;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.oseasy.pcore.common.persistence.TreeEntity;

/**
 * 站点Entity.
 * @author chenh
 * @version 2018-12-25
 */
public class CmsSite extends TreeEntity<CmsSite> {

	private static final long serialVersionUID = 1L;
	private CmsSite parent;		// 父级编号
	private String parentIds;		// 所有父级编号
	private String config;		// 配置编号
	private String name;		// 站点名称
	private String type;		// 站点类型 CmsSiteType
	private String isCurr;		// 是否当前站点
	private String isZzd;		// 是否子站点:0、否；1、是
	private CmssSite ssite;     // 站点明细
	public CmsSite() {
		super();
	}

	public CmsSite(String id){
		super(id);
	}

	public CmsSite(CmsSite parent) {
        super();
        this.parent = parent;
    }

    @JsonBackReference
	@NotNull(message="父级编号不能为空")
	public CmsSite getParent() {
		return parent;
	}

	public void setParent(CmsSite parent) {
		this.parent = parent;
	}

	@Length(min=1, max=2000, message="所有父级编号长度必须介于 1 和 2000 之间")
	public String getParentIds() {
		return parentIds;
	}

	public void setParentIds(String parentIds) {
		this.parentIds = parentIds;
	}

	public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Length(min=1, max=64, message="配置编号长度必须介于 1 和 64 之间")
	public String getConfig() {
		return config;
	}

	public void setConfig(String config) {
		this.config = config;
	}

	@Length(min=1, max=100, message="站点名称长度必须介于 1 和 100 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Length(min=1, max=1, message="是否当前站点长度必须介于 1 和 1 之间")
	public String getIsCurr() {
		return isCurr;
	}

	public void setIsCurr(String isCurr) {
		this.isCurr = isCurr;
	}

	@Length(min=1, max=1, message="是否子站点:0、否；1、是长度必须介于 1 和 1 之间")
	public String getIsZzd() {
		return isZzd;
	}

	public void setIsZzd(String isZzd) {
		this.isZzd = isZzd;
	}

	public String getParentId() {
		return parent != null && parent.getId() != null ? parent.getId() : "0";
	}

	public CmssSite getSsite() {
        return ssite;
    }

    public void setSsite(CmssSite ssite) {
        this.ssite = ssite;
    }

    @Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}

    /**
     * .
     * @return
     */
    public static String getCurrentSiteId() {
        // TODO Auto-generated method stub
        return null;
    }
}