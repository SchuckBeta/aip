package com.oseasy.pact.modules.actyw.entity;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import com.google.common.collect.Lists;
import com.oseasy.pcore.common.persistence.DataEntity;
import com.oseasy.pcore.common.utils.IdGen;

/**
 * 监听类Entity.
 * @author chenh
 * @version 2018-03-01
 */
public class ActYwGclazz extends DataEntity<ActYwGclazz> {

	private static final long serialVersionUID = 1L;
	private ActYwGroup group;		// 流程
	private ActYwGnode gnode;		// 节点
	private ActYwClazz listener;		// 监听

	public ActYwGclazz() {
		super();
	}

	public ActYwGclazz(String id){
		super(id);
	}

	public ActYwGclazz(ActYwGnode gnode){
	    this.gnode = gnode;
	}

	public ActYwGclazz(ActYwClazz listener){
	    this.listener = listener;
	}

	public ActYwGclazz(ActYwGnode gnode, ActYwClazz listener){
	    this.gnode = gnode;
	    this.listener = listener;
	}

	/**
     * .
     * @param uuid
     * @param group2
     * @param gnodeId
     * @param pid
     */
    public ActYwGclazz(String uuid, ActYwGroup group, String gnodeId, ActYwClazz clazz) {
        super();
        this.id = uuid;
        this.group = group;
        this.gnode = new ActYwGnode(gnodeId);
        this.listener = clazz;
    }

    /**
     * @param uuid
     * @param groupId
     * @param gnodeId
     * @param id
     */
    public ActYwGclazz(String uuid, String groupId, String gnodeId, String id) {
        super();
        this.id = uuid;
        this.group = new ActYwGroup(groupId);
        this.gnode = new ActYwGnode(gnodeId);
        this.listener = new ActYwClazz(id);
    }

    @Length(min=0, max=64, message="流程长度必须介于 0 和 64 之间")
	public ActYwGroup getGroup() {
		return group;
	}

	public void setGroup(ActYwGroup group) {
		this.group = group;
	}

	@Length(min=0, max=64, message="节点长度必须介于 0 和 64 之间")
	public ActYwGnode getGnode() {
		return gnode;
	}

	public void setGnode(ActYwGnode gnode) {
		this.gnode = gnode;
	}

	@Length(min=0, max=64, message="监听长度必须介于 0 和 64 之间")
	public ActYwClazz getListener() {
		return listener;
	}

	public void setListener(ActYwClazz listener) {
		this.listener = listener;
	}

    /**
     * IDS转换为监听对象.
     * @param groupId 流程ID
     * @param gnodeId 节点ID
     * @param pids 监听
     * @return List
     */
    public static List<ActYwGclazz> converts(ActYwGroup group, String gnodeId, List<ActYwClazz> clazzIds) {
        List<ActYwGclazz> ActYwGclazzs = Lists.newArrayList();
        for (ActYwClazz pid : clazzIds) {
            ActYwGclazzs.add(new ActYwGclazz(IdGen.uuid(), group, gnodeId, pid));
        }
        return ActYwGclazzs;
    }

    /**
     * IDS转换为监听对象.
     * @param groupId 流程ID
     * @param gnodeId 节点ID
     * @param ids ID串
     * @return List
     */
    public static List<ActYwGclazz> convert(String groupId, String gnodeId, List<String> ids) {
        List<ActYwGclazz> ActYwGclazzs = Lists.newArrayList();
        for (String id : ids) {
            ActYwGclazzs.add(new ActYwGclazz(IdGen.uuid(), groupId, gnodeId, id));
        }
        return ActYwGclazzs;
    }

}