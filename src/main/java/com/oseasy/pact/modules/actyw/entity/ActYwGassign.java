package com.oseasy.pact.modules.actyw.entity;

import org.hibernate.validator.constraints.Length;

import com.oseasy.pcore.common.persistence.DataEntity;

/**
 * 业务指派表Entity.
 * @author zy
 * @version 2018-04-03
 */
public class ActYwGassign extends DataEntity<ActYwGassign> {

	private static final long serialVersionUID = 1L;
	private String ywId;		// 项目流程编号
	private String gnodeId;		// 流程节点编号
	private String promodelId;		// 项目id
	private String assignUserId;		// 指派人
	private String revUserId;		// 被指派人

	public ActYwGassign() {
		super();
	}

	public ActYwGassign(String id){
		super(id);
	}

	@Length(min=1, max=64, message="项目流程编号长度必须介于 1 和 64 之间")
	public String getYwId() {
		return ywId;
	}

	public void setYwId(String ywId) {
		this.ywId = ywId;
	}

	@Length(min=0, max=64, message="流程节点编号长度必须介于 0 和 64 之间")
	public String getGnodeId() {
		return gnodeId;
	}

	public void setGnodeId(String gnodeId) {
		this.gnodeId = gnodeId;
	}

	public String getPromodelId() {
		return promodelId;
	}

	public void setPromodelId(String promodelId) {
		this.promodelId = promodelId;
	}

	@Length(min=0, max=64, message="指派人长度必须介于 0 和 64 之间")
	public String getAssignUserId() {
		return assignUserId;
	}

	public void setAssignUserId(String assignUserId) {
		this.assignUserId = assignUserId;
	}

	@Length(min=0, max=64, message="被指派人长度必须介于 0 和 64 之间")
	public String getRevUserId() {
		return revUserId;
	}

	public void setRevUserId(String revUserId) {
		this.revUserId = revUserId;
	}

}