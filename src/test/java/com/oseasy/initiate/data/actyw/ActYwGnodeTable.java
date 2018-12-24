/**
 * .
 */

package com.oseasy.initiate.data.actyw;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

import com.google.common.collect.Lists;
import com.oseasy.initiate.common.config.SysJkey;
import com.oseasy.initiate.data.BaseDataRecords;
import com.oseasy.pact.modules.actyw.entity.ActYwForm;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.pact.modules.actyw.entity.ActYwGroup;
import com.oseasy.pact.modules.actyw.entity.ActYwNode;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.putil.common.utils.json.JsonAliUtils;
import com.oseasy.putil.common.utils.json.JsonNetUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class ActYwGnodeTable implements BaseDataRecords<ActYwGnodeTable, ActYwGnode> {
    private String id;
    private String parent_id;
    private String parent_ids;
    private String group_id;
    private String name;
    private String type;
    private String node_id;
    private String pre_id;
    private String pre_fun_id;
    private Boolean is_show;
    private Boolean is_form;
    private String icon_url;
    private String form_id;
    private String task_type;
    private String outgoing;
    private Date update_date;
    private String update_by;
    private Date create_date;
    private String create_by;
    private String remarks;
    private String del_flag;

    @Override
    public List<ActYwGnodeTable> getRecords(Class<ActYwGnodeTable> mainClass, String datafile) {
        JSONObject json = JSONObject.fromObject(JsonAliUtils.readFile(datafile));
        if(json == null){
            return null;
        }
        JSONArray jrecords = json.getJSONArray(StringUtil.upperCase(SysJkey.JK_RECORDS));

        if(jrecords == null){
            return null;
        }
        return JsonNetUtils.toList(jrecords, mainClass);
    }

    @Override
    public List<ActYwGnode> convert(List<ActYwGnodeTable> tables) {
        List<ActYwGnode> retys = Lists.newArrayList();
        for (ActYwGnodeTable table : tables) {
            ActYwGnode rety = new ActYwGnode();
            rety.setId(table.getId());
            rety.setParent(new ActYwGnode(table.getParent_id()));
            rety.getParent().setParentIds(table.getParent_ids());
            rety.setGroup(new ActYwGroup(table.getGroup_id()));
            rety.setName(table.getName());
            rety.setType(table.getType());
            rety.setTaskType(table.getTask_type());
            rety.setOutgoing(table.getOutgoing());
            rety.setNode(new ActYwNode(table.getNode_id()));
            if(StringUtil.isNotEmpty(table.getPre_id())){
                rety.setPreId(table.getPre_id());
            }

//            if(StringUtil.isNotEmpty(table.getPre_id())){
//                rety.setPreFunId(table.getPre_fun_id());
//                rety.setPreFunGnode(ActYwGnode.convert(table.getGroup_id(), Arrays.asList(StringUtil.split(table.getPre_fun_id(), StringUtil.DOTH))));
//            }

//            if(StringUtil.isNotEmpty(table.getForm_id())){
//                rety.setForm(new ActYwForm(table.getForm_id()));
//            }

            rety.setIsShow(table.getIs_show());
            rety.setIsForm(table.getIs_form());
            rety.setIconUrl(table.getIcon_url());
            rety.setCreateBy(new User(table.getCreate_by()));
            rety.setUpdateBy(new User(table.getUpdate_by()));
            rety.setCreateDate(table.getCreate_date());
            rety.setUpdateDate(table.getUpdate_date());
            rety.setRemarks(table.getRemarks());
            rety.setDelFlag(table.getDel_flag());
            retys.add(rety);
        }
        return retys;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setParent_id(String parent_id) {
        this.parent_id = parent_id;
    }

    public String getParent_id() {
        return parent_id;
    }

    public void setParent_ids(String parent_ids) {
        this.parent_ids = parent_ids;
    }

    public String getParent_ids() {
        return parent_ids;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getType() {
        return type;
    }

    public void setNode_id(String node_id) {
        this.node_id = node_id;
    }

    public String getNode_id() {
        return node_id;
    }

    public void setPre_id(String pre_id) {
        this.pre_id = pre_id;
    }

    public String getPre_id() {
        return pre_id;
    }

    public void setPre_fun_id(String pre_fun_id) {
        this.pre_fun_id = pre_fun_id;
    }

    public String getPre_fun_id() {
        return pre_fun_id;
    }

    public void setIs_show(Boolean is_show) {
        this.is_show = is_show;
    }

    public Boolean getIs_show() {
        return is_show;
    }

    public void setIs_form(Boolean is_form) {
        this.is_form = is_form;
    }

    public Boolean getIs_form() {
        return is_form;
    }

    public void setIcon_url(String icon_url) {
        this.icon_url = icon_url;
    }

    public String getIcon_url() {
        return icon_url;
    }

    public void setForm_id(String form_id) {
        this.form_id = form_id;
    }

    public String getForm_id() {
        return form_id;
    }

    public void setTask_type(String task_type) {
        this.task_type = task_type;
    }

    public String getTask_type() {
        return task_type;
    }

    public void setUpdate_date(Date update_date) {
        this.update_date = update_date;
    }

    public Date getUpdate_date() {
        return update_date;
    }

    public void setUpdate_by(String update_by) {
        this.update_by = update_by;
    }

    public String getUpdate_by() {
        return update_by;
    }

    public void setCreate_date(Date create_date) {
        this.create_date = create_date;
    }

    public Date getCreate_date() {
        return create_date;
    }

    public void setCreate_by(String create_by) {
        this.create_by = create_by;
    }

    public String getCreate_by() {
        return create_by;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setDel_flag(String del_flag) {
        this.del_flag = del_flag;
    }

    public String getDel_flag() {
        return del_flag;
    }

    public String getOutgoing() {
        return outgoing;
    }

    public void setOutgoing(String outgoing) {
        this.outgoing = outgoing;
    }
}