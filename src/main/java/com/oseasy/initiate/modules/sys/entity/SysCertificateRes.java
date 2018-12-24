package com.oseasy.initiate.modules.sys.entity;

import org.hibernate.validator.constraints.Length;

import com.oseasy.initiate.modules.attachment.entity.SysAttachment;
import com.oseasy.pcore.common.persistence.AttachMentEntity;
import com.oseasy.pcore.common.persistence.DataEntity;

/**
 * 系统证书资源Entity.
 * @author chenh
 * @version 2017-11-06
 */
public class SysCertificateRes extends DataEntity<SysCertificateRes> {

	private static final long serialVersionUID = 1L;
	private String type;		// 资源类型
	private String name;		// 资源名称
	private Double width;		// 宽度
	private Double height;		// 高度
	private Double xlt;		// X坐标
	private Double ylt;		// Y坐标
	private Double opacity;		// 透明度
	private Double rate;		// 角度
	private String hasLoop;		// 是否平铺
	private String isShow;		// 是否显示
  private SysAttachment file;    //证书附件

	public SysCertificateRes() {
		super();
	}

	public SysCertificateRes(String id) {
		super(id);
	}

	@Length(min=0, max=255, message="资源类型长度必须介于 0 和 255 之间")
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	@Length(min=0, max=255, message="资源名称长度必须介于 0 和 255 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Double getWidth() {
		return width;
	}

	public void setWidth(Double width) {
		this.width = width;
	}

	public Double getHeight() {
		return height;
	}

	public void setHeight(Double height) {
		this.height = height;
	}

	public Double getXlt() {
		return xlt;
	}

	public void setXlt(Double xlt) {
		this.xlt = xlt;
	}

	public Double getYlt() {
		return ylt;
	}

	public void setYlt(Double ylt) {
		this.ylt = ylt;
	}

	public Double getOpacity() {
		return opacity;
	}

	public void setOpacity(Double opacity) {
		this.opacity = opacity;
	}

	public Double getRate() {
		return rate;
	}

	public void setRate(Double rate) {
		this.rate = rate;
	}

	@Length(min=0, max=1, message="是否平铺长度必须介于 0 和 1 之间")
	public String getHasLoop() {
		return hasLoop;
	}

	public void setHasLoop(String hasLoop) {
		this.hasLoop = hasLoop;
	}

	@Length(min=0, max=1, message="是否显示长度必须介于 0 和 1 之间")
	public String getIsShow() {
		return isShow;
	}

	public void setIsShow(String isShow) {
		this.isShow = isShow;
	}

  public SysAttachment getFile() {
    return file;
  }

  public void setFile(SysAttachment file) {
    this.file = file;
  }
}