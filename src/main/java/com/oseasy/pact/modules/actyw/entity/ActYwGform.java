package com.oseasy.pact.modules.actyw.entity;

import java.util.List;

import com.google.common.collect.Lists;
import com.oseasy.pcore.common.persistence.DataEntity;
import com.oseasy.pcore.common.utils.IdGen;

/**
 * 节点表单Entity.
 * @author chenh
 * @version 2018-01-15
 */
public class ActYwGform extends DataEntity<ActYwGform> {

    private static final long serialVersionUID = 1L;
    private ActYwGroup group;       // 流程编号
    private ActYwGnode gnode;       // 流程节点编号
    private ActYwForm form;      // 表单编号

    public ActYwGform() {
        super();
    }

    public ActYwGform(ActYwGnode gnode) {
        super();
        this.gnode = gnode;
    }
    public ActYwGform(ActYwGroup group, ActYwGnode gnode) {
        super();
        this.group = group;
        this.gnode = gnode;
    }

    public ActYwGform(String groupId, String gnodeId, String formId) {
        super();
        this.group = new ActYwGroup(groupId);
        this.gnode = new ActYwGnode(gnodeId);
        this.form = new ActYwForm(formId);
    }

    public ActYwGform(String id, String groupId, String gnodeId, String formId) {
        super();
        this.id = id;
        this.group = new ActYwGroup(groupId);
        this.gnode = new ActYwGnode(gnodeId);
        this.form = new ActYwForm(formId);
    }

    public ActYwGform(String id, ActYwGroup group, String gnodeId, String formId) {
        super();
        this.id = id;
        this.group = group;
        this.gnode = new ActYwGnode(gnodeId);
        this.form = new ActYwForm(formId);
    }

    public ActYwGform(String groupId, String gnodeId, ActYwForm form) {
        super();
        this.group = new ActYwGroup(groupId);
        this.gnode = new ActYwGnode(gnodeId);
        this.form = form;
    }

    public ActYwGform(String id, String groupId, String gnodeId, ActYwForm form) {
        super();
        this.id = id;
        this.group = new ActYwGroup(groupId);
        this.gnode = new ActYwGnode(gnodeId);
        this.form = form;
    }

    public ActYwGform(String id, ActYwGroup group, String gnodeId, ActYwForm form) {
        super();
        this.id = id;
        this.group = group;
        this.gnode = new ActYwGnode(gnodeId);
        this.form = form;
    }

    public ActYwGform(ActYwGroup group, ActYwGnode gnode, ActYwForm form) {
        super();
        this.group = group;
        this.gnode = gnode;
        this.form = form;
    }

    public ActYwGroup getGroup() {
        return group;
    }

    public void setGroup(ActYwGroup group) {
        this.group = group;
    }

    public ActYwGnode getGnode() {
        return gnode;
    }

    public void setGnode(ActYwGnode gnode) {
        this.gnode = gnode;
    }

    public ActYwForm getForm() {
        return form;
    }

    public void setForm(ActYwForm form) {
        this.form = form;
    }

    /**
     * IDS转换为节点表单对象.
     * @param groupId 流程ID
     * @param gnodeId 节点ID
     * @param ids ID串
     * @return List
     */
    public static List<ActYwGform> converts(ActYwGroup group, String gnodeId, List<ActYwForm> pids) {
        List<ActYwGform> statuss = Lists.newArrayList();
        for (ActYwForm pid : pids) {
            statuss.add(new ActYwGform(IdGen.uuid(), group, gnodeId, pid));
        }
        return statuss;
    }

    /**
     * IDS转换为节点表单对象.
     * @param groupId 流程ID
     * @param gnodeId 节点ID
     * @param ids ID串
     * @return List
     */
    public static List<ActYwGform> convert(String groupId, String gnodeId, List<String> ids) {
        List<ActYwGform> statuss = Lists.newArrayList();
        for (String id : ids) {
            statuss.add(new ActYwGform(IdGen.uuid(), groupId, gnodeId, id));
        }
        return statuss;
    }
}