package com.oseasy.initiate.modules.sys.entity;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import com.oseasy.pcore.common.persistence.AttachMentEntity;
import com.oseasy.pcore.common.persistence.DataEntity;
import com.oseasy.pcore.modules.sys.entity.Office;

/**
 * 系统证书表Entity.
 * @author chenh
 * @version 2017-10-23
 */
public class SysCertificate extends DataEntity<SysCertificate> {

	private static final long serialVersionUID = 1L;
	private String no;		// 证书编号
	private String name;		// 证书名称
	private String type;		// 证书类型
	private Office office;		// 所属机构
	private Boolean hasUse;		// 使用中
	private List<SysCertificateRel> sysCertRels;		//证书资源

	public SysCertificate() {
		super();
	}

	public SysCertificate(String type, Boolean hasUse) {
    super();
    this.type = type;
    this.hasUse = hasUse;
  }

  public SysCertificate(String id) {
		super(id);
	}

	@Length(min=1, max=64, message="证书编号长度必须介于 1 和 64 之间")
	public String getNo() {
		return no;
	}

  public List<SysCertificateRel> getSysCertRels() {
    return sysCertRels;
  }

  public void setSysCertRels(List<SysCertificateRel> sysCertRels) {
    this.sysCertRels = sysCertRels;
  }

  public void setNo(String no) {
		this.no = no;
	}

	@Length(min=0, max=255, message="证书名称长度必须介于 0 和 255 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Boolean getHasUse() {
    return hasUse;
  }

  public void setHasUse(Boolean hasUse) {
    this.hasUse = hasUse;
  }

  @Length(min=0, max=255, message="证书类型长度必须介于 0 和 255 之间")
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}

}