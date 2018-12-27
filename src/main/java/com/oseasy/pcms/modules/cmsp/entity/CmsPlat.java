package com.oseasy.pcms.modules.cmsp.entity;

import org.apache.commons.lang3.builder.ReflectionToStringBuilder;

import com.oseasy.pcms.modules.cms.entity.CmsLat;
import com.oseasy.pcore.common.persistence.DataExtEntity;

/**
 * 页面布局Entity.
 * @author chenh
 * @version 2018-12-25
 */
public class CmsPlat extends DataExtEntity<CmsPlat> {

	private static final long serialVersionUID = 1L;
	private CmsPage cpage;		// 页面ID
	private CmsLat lat;		// 布局ID

	public CmsPlat() {
		super();
	}

	public CmsPlat(String id){
		super(id);
	}

	public CmsPage getCpage() {
        return cpage;
    }

    public void setCpage(CmsPage cpage) {
        this.cpage = cpage;
    }

    public CmsLat getLat() {
		return lat;
	}

	public void setLat(CmsLat lat) {
		this.lat = lat;
	}


	@Override
	public String toString() {
		return ReflectionToStringBuilder.toString(this);
	}
}