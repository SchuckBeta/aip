/**
 *
 */
package com.oseasy.pcore.common.persistence;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlTransient;

import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * 数据Entity类

 * @version 2014-05-16
 */
public abstract class DataExtEntity<T> extends DataEntity<T> implements Serializable{

	private static final long serialVersionUID = 1L;
	private String queryStr;       // 查询字符串
    private List<String> ids;       // 查询Ids

    public DataExtEntity() {
        super();
    }

    public DataExtEntity(String id) {
        super(id);
    }

    @JsonIgnore
    @XmlTransient
    public String getQueryStr() {
        return queryStr;
    }

    public void setQueryStr(String queryStr) {
        this.queryStr = queryStr;
    }

    @JsonIgnore
    @XmlTransient
    public List<String> getIds() {
        return ids;
    }

    public void setIds(List<String> ids) {
        this.ids = ids;
    }
}
