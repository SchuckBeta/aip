package com.oseasy.initiate.modules.sys.entity;

import java.util.Date;

import org.hibernate.validator.constraints.Length;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.oseasy.initiate.modules.promodel.entity.ProModel;
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pcore.common.persistence.DataEntity;
import com.oseasy.pcore.modules.sys.entity.User;

/**
 * 系统证书执行记录Entity.
 * @author chenh
 * @version 2017-11-07
 */
public class SysCertificateIssued extends DataEntity<SysCertificateIssued> {

	private static final long serialVersionUID = 1L;
	private SysCertificateRel sysCertRel;		// 证书
	private SysCertificate sysCert;		// 证书
  private String type;		// 授予状态
	private String reason;		// 执行原因
	private Date issuedDate;		// 执行时间
	private User issuedBy;		// 执行人
	private User acceptBy;		// 被执行人
	private String isYw;   // 是否因业务授予（0：否, 1：是）
  private ActYw actYw;    // 业务
  private ProModel proModel;    //申报

	public SysCertificateIssued() {
		super();
	}

	public SysCertificateIssued(SysCertificateRel sysCertRel) {
    super();
    this.sysCertRel = sysCertRel;
  }

  public SysCertificateIssued(String id) {
		super(id);
	}

	public SysCertificateRel getSysCertRel() {
    return sysCertRel;
  }

  public void setSysCertRel(SysCertificateRel sysCertRel) {
    this.sysCertRel = sysCertRel;
  }

	public String getIsYw() {
    return isYw;
  }

  public void setIsYw(String isYw) {
    this.isYw = isYw;
  }

  public ProModel getProModel() {
    return proModel;
  }

  public void setProModel(ProModel proModel) {
    this.proModel = proModel;
  }

  public ActYw getActYw() {
    return actYw;
  }

  public SysCertificate getSysCert() {
    return sysCert;
  }

  public void setSysCert(SysCertificate sysCert) {
    this.sysCert = sysCert;
  }

  public void setActYw(ActYw actYw) {
    this.actYw = actYw;
  }

  @Length(min=0, max=255, message="授予状态长度必须介于 0 和 255 之间")
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	@Length(min=1, max=200, message="执行原因长度必须介于 1 和 200 之间")
	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getIssuedDate() {
		return issuedDate;
	}

	public void setIssuedDate(Date issuedDate) {
		this.issuedDate = issuedDate;
	}

	public User getIssuedBy() {
		return issuedBy;
	}

	public void setIssuedBy(User issuedBy) {
		this.issuedBy = issuedBy;
	}

	public User getAcceptBy() {
		return acceptBy;
	}

	public void setAcceptBy(User acceptBy) {
		this.acceptBy = acceptBy;
	}

}