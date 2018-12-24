package com.oseasy.pact.modules.actyw.entity;

import org.hibernate.validator.constraints.Length;

import com.oseasy.pcore.common.persistence.DataEntity;
import com.oseasy.pcore.modules.sys.entity.Dict;

/**
 * 节点状态表Entity.
 * @author zy
 * @version 2018-01-15
 */
public class ActYwStatus extends DataEntity<ActYwStatus> {
    public static final String ACT_STATUS_TYPE = "act_gnode_status";
    private static final long serialVersionUID = 1L;
	private String status;		// 保存值eg:1,2,3,4
	private String state;		//业务状态说明
	private String alias;		// 范围等
	private String gtype;		// 状态类型 id 来至于状态表
	private String regType;   // 业务状态类型：审核 评分 act_status_type
	private String name;   // 名称

	public ActYwStatus() {
		super();
	}

	public ActYwStatus(String id){
		super(id);
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getRegType() {
		return regType;
	}

	public void setRegType(String regType) {
		this.regType = regType;
	}


	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Length(min=0, max=200, message="状态说明 ：A 1 , B 2 ,C 3 ,D 4长度必须介于 0 和 200 之间")
	public String getAlias() {
		return alias;
	}

	public void setAlias(String alias) {
		this.alias = alias;
	}

	public String getGtype() {
		return gtype;
	}

	public void setGtype(String gtype) {
		this.gtype = gtype;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}