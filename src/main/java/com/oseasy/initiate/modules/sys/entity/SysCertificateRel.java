package com.oseasy.initiate.modules.sys.entity;

import org.hibernate.validator.constraints.Length;

import com.oseasy.pcore.common.persistence.DataEntity;

/**
 * 系统证书资源关联Entity.
 * @author chenh
 * @version 2017-11-06
 */
public class SysCertificateRel extends DataEntity<SysCertificateRel> {

	private static final long serialVersionUID = 1L;
	private SysCertificate sysCert;		// 证书ID
	private SysCertificateRes sysCertRes;		// 证书资源ID
	private String type;		// 类型:1、正面;2、反面;
	private String resType;		// 资源类型:1、主图;2、公章水印;3、背景水印图标;4、背景水印文本;5、内容参数
	private String resClazz;		// 资源类（res_type=5是使用）
	private String resClazzProp;		// 资源类属性（res_type=5是使用）

	public SysCertificateRel() {
		super();
	}

	public SysCertificateRel(SysCertificateRes sysCertRes) {
    super();
    this.sysCertRes = sysCertRes;
  }

  public SysCertificateRel(SysCertificate sysCert) {
    super();
    this.sysCert = sysCert;
  }

  public SysCertificateRel(SysCertificate sysCert, SysCertificateRes sysCertRes) {
    super();
    this.sysCert = sysCert;
    this.sysCertRes = sysCertRes;
  }

  public SysCertificateRel(String id) {
		super(id);
	}

	public SysCertificate getSysCert() {
    return sysCert;
  }

  public void setSysCert(SysCertificate sysCert) {
    this.sysCert = sysCert;
  }

  public SysCertificateRes getSysCertRes() {
    return sysCertRes;
  }

  public void setSysCertRes(SysCertificateRes sysCertRes) {
    this.sysCertRes = sysCertRes;
  }

  @Length(min=1, max=255, message="类型:1、正面;2、反面;长度必须介于 1 和 255 之间")
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	@Length(min=0, max=255, message="资源类型:1、主图;2、公章水印;3、背景水印图标;4、背景水印文本;5、内容参数长度必须介于 0 和 255 之间")
	public String getResType() {
		return resType;
	}

	public void setResType(String resType) {
		this.resType = resType;
	}

	@Length(min=0, max=255, message="资源类（res_type=5是使用）长度必须介于 0 和 255 之间")
	public String getResClazz() {
		return resClazz;
	}

	public void setResClazz(String resClazz) {
		this.resClazz = resClazz;
	}

	@Length(min=0, max=255, message="资源类属性（res_type=5是使用）长度必须介于 0 和 255 之间")
	public String getResClazzProp() {
		return resClazzProp;
	}

	public void setResClazzProp(String resClazzProp) {
		this.resClazzProp = resClazzProp;
	}

}