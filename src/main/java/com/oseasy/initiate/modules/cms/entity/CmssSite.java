package com.oseasy.initiate.modules.cms.entity;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import org.hibernate.validator.constraints.Length;

import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 站点明细Entity.
 * @author chenhao
 * @version 2018-12-25
 */
public class CmssSite extends DataExtEntity<CmssSite> {

	private static final long serialVersionUID = 1L;
	private CmsSite site;		// 父级编号
	private String title;		// 站点标题
	private String logo;		// 站点租户Logo
	private String logoSite;		// 站点Logo
	private String index;		// 站点首页栏目（必须为根栏目）
	private String domain;		// 站点域名
	private String description;		// 描述
	private String keywords;		// 关键字
	private String theme;		// 主题
	private String copyright;		// 版权信息

	public CmssSite() {
		super();
	}

	public CmssSite(String id){
		super(id);
	}

	public CmsSite getSite() {
        return site;
    }

    public void setSite(CmsSite site) {
        this.site = site;
    }

    @Length(min=1, max=100, message="站点标题长度必须介于 1 和 100 之间")
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@Length(min=0, max=255, message="站点租户Logo长度必须介于 0 和 255 之间")
	public String getLogo() {
		return logo;
	}

	public void setLogo(String logo) {
		this.logo = logo;
	}

	@Length(min=0, max=255, message="站点Logo长度必须介于 0 和 255 之间")
	public String getLogoSite() {
		return logoSite;
	}

	public void setLogoSite(String logoSite) {
		this.logoSite = logoSite;
	}

	@Length(min=0, max=64, message="站点首页栏目（必须为根栏目）长度必须介于 0 和 64 之间")
	public String getIndex() {
		return index;
	}

	public void setIndex(String index) {
		this.index = index;
	}

	@Length(min=0, max=255, message="站点域名长度必须介于 0 和 255 之间")
	public String getDomain() {
		return domain;
	}

	public void setDomain(String domain) {
		this.domain = domain;
	}

	@Length(min=0, max=255, message="描述长度必须介于 0 和 255 之间")
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@Length(min=0, max=255, message="关键字长度必须介于 0 和 255 之间")
	public String getKeywords() {
		return keywords;
	}

	public void setKeywords(String keywords) {
		this.keywords = keywords;
	}

	@Length(min=0, max=255, message="主题长度必须介于 0 和 255 之间")
	public String getTheme() {
		return theme;
	}

	public void setTheme(String theme) {
		this.theme = theme;
	}

	public String getCopyright() {
		return copyright;
	}

	public void setCopyright(String copyright) {
		this.copyright = copyright;
	}


	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}