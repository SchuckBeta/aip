package com.oseasy.pact.modules.actyw.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.oseasy.pact.common.config.ActKey;
import com.oseasy.pact.modules.act.service.ActTaskService;
import com.oseasy.pact.modules.actyw.entity.ActYwGform;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.pact.modules.actyw.entity.ActYwGrole;
import com.oseasy.pact.modules.actyw.entity.ActYwGroup;
import com.oseasy.pact.modules.actyw.entity.ActYwGstatus;
import com.oseasy.pact.modules.actyw.service.ActYwGformService;
import com.oseasy.pact.modules.actyw.service.ActYwGnodeService;
import com.oseasy.pact.modules.actyw.service.ActYwGroleService;
import com.oseasy.pact.modules.actyw.service.ActYwGroupService;
import com.oseasy.pact.modules.actyw.service.ActYwGstatusService;
import com.oseasy.pact.modules.actyw.tool.process.ActYwTool;
import com.oseasy.pact.modules.actyw.tool.process.vo.GnodeType;
import com.oseasy.pact.modules.actyw.tool.process.vo.GnodeView;
import com.oseasy.pcore.common.config.ApiTstatus;
import com.oseasy.pcore.common.config.CoreIds;
import com.oseasy.pcore.common.config.CoreJkey;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

import net.sf.json.JSONObject;

/**
 * 项目流程Controller
 *
 * @author chenhao
 * @version 2017-05-23
 */
@Controller
@RequestMapping(value = "${adminPath}/actyw/actYwGnode")
public class ActYwGnodeController extends BaseController {
    @Autowired
    private ActTaskService actTaskService;
    @Autowired
    private ActYwGroupService actYwGroupService;
    @Autowired
    private ActYwGnodeService actYwGnodeService;
    @Autowired
    RepositoryService repositoryService;
    @Autowired
    RuntimeService runtimeService;

    @Autowired
    private ActYwGroleService actYwGroleService;

    @Autowired
    private ActYwGformService actYwGformService;

    @Autowired
    private ActYwGstatusService actYwGstatusService;

    @ModelAttribute
    public ActYwGnode get(@RequestParam(required = false) String id) {
        ActYwGnode entity = null;
        if (StringUtil.isNotBlank(id)) {
            entity = actYwGnodeService.get(id);
        }
        if (entity == null) {
            entity = new ActYwGnode();
        }
        return entity;
    }

    /**
     * 流程预览页面-已经去掉了页面.
     */
    @RequestMapping(value = { "/{groupId}/view" })
    public String view(@PathVariable String groupId, ActYwGnode actYwGnode, HttpServletRequest request,
            HttpServletResponse response, Model model) {
        if (StringUtil.isEmpty(groupId)) {
            return CoreSval.REDIRECT + Global.getAdminPath() + "/actyw/actYwGnode/?repage";
        }
//        List<ActYwGnode> sourcelist = Lists.newArrayList();
//        List<ActYwGnode> list = Lists.newArrayList();
//
//        actYwGnode.setGroup(actYwGroupService.get(new ActYwGroup(groupId)));
//        sourcelist = actYwGnodeService.findListByYw(actYwGnode);
//        ActYwGnode.sortList(list, sourcelist, ActYwGnode.getRootId(), true);
//        model.addAttribute("list", list);

        ActYwGroup actYwGroup = actYwGroupService.get(groupId);
        System.out.println(actYwGroup);
        model.addAttribute(ActYwGroup.JK_GROUP, actYwGroupService.get(groupId));

        return "modules/actyw/actYwGnodeView";
    }

    /**
     * 获取已发布流程节点JSON数据（项目、大赛首页）.
     *
     * @param extId
     *            排除的ID
     * @param level
     *            是否显示
     * @param isYw
     *            是否业务节点,默认为true
     *
     * @param response
     * @return
     */
    @RequiresPermissions("user")
    @ResponseBody
    @RequestMapping(value = "treeDataByYwId")
    public List<Map<String, Object>> treeDataByYwId(@RequestParam(required = false) String extId,
            @RequestParam(required = true) String ywId, @RequestParam(required = false) String level,
            @RequestParam(required = false) String parentId, @RequestParam(required = false) Boolean isAll, HttpServletResponse response) {
        return actYwGnodeService.treeDataByYwId(extId, ywId, parentId, isAll);
    }

    /****************************************************************************************************************
     * 新修改的接口.
     ***************************************************************************************************************/
    /**
     * 根据流程标识查询带状态业务节点(流程设计图运行状态查看).
     * 1、根据Activity的History接口查询流程进度，获取正在执行的节点
     * 2、得到ActYwGnode对应的节点 3、根据findListByYwGroupAndPreIdss方法找到对应的已执行的节点列表（一级节点）
     * 4、根据findListByYwGroupAndPreIdss方法找到对应的全部的节点列表（一级节点）
     *
     * @param groupId
     *            流程标识
     * @return ActYwApiStatus
     */
    @ResponseBody
    @RequestMapping(value = "/queryStatusTree/{groupId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    public ApiTstatus<List<GnodeView>> queryStatusTree(@PathVariable String groupId,
            @RequestParam(required = false) String proInsId, @RequestParam(required = false) String grade) {
        return actYwGnodeService.queryStatusTree(groupId, proInsId, grade, actTaskService);
    }

    @ResponseBody
    @RequestMapping(value = "/queryGnodeUser/{groupId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    public JSONObject queryGnodeUser(@PathVariable String groupId, @RequestParam(required = false) String proInsId, @RequestParam(required = false) String grade) {
       return actYwGnodeService.queryGnodeUser(groupId, proInsId, grade, actTaskService);
    }


    /**
     * 根据流程标识查询带状态业务节点(旧的项目、大赛使用).
     * 1、得到ActYwGnode对应的节点
     * 2、根据findListByYwGroupAndPreIdss方法找到对应的已执行的节点列表（一级节点）
     * 3、根据findListByYwGroupAndPreIdss方法找到对应的全部的节点列表（一级节点）
     *
     * @param groupId
     *            流程标识
     * @param gnodeId
     *            流程节点标识
     * @return ActYwApiStatus
     */
    @ResponseBody
    @RequestMapping(value = "/queryStatusTreeByGnode/{groupId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    public ApiTstatus<List<GnodeView>> queryStatusTreeByGnode(@PathVariable String groupId, @RequestParam(required = true) String gnodeId, @RequestParam(required = false) String grade) {
        return actYwGnodeService.queryStatusTreeByGnode(groupId, gnodeId, grade);
    }

    @RequestMapping(value = "delete")
    public String delete(ActYwGnode actYwGnode, RedirectAttributes redirectAttributes) {
        actYwGnodeService.delete(actYwGnode);
        addMessage(redirectAttributes, "删除自定义流程成功");
        return CoreSval.REDIRECT + Global.getAdminPath() + "/actyw/actYwGnode/?repage";
    }

    /**
     * 获取流程节点JSON数据。
     *
     * @param extId
     *            排除的ID
     * @param isShowHide
     *            是否显示
     * @param response
     * @return
     */
    @RequiresPermissions("user")
    @ResponseBody
    @RequestMapping(value = "treeData")
    public List<Map<String, Object>> treeData(@RequestParam(required = false) String extId,
            @RequestParam(required = false) String isShowHide, @RequestParam(required = false) Boolean isAll,
            HttpServletResponse response) {
        List<Map<String, Object>> mapList = Lists.newArrayList();
        List<ActYwGnode> list = actYwGnodeService.findAllList();
        for (int i = 0; i < list.size(); i++) {
            ActYwGnode e = list.get(i);
            Boolean isExt = StringUtil.isBlank(extId)
                    || (extId != null && !extId.equals(e.getId()) && e.getParentIds().indexOf("," + extId + ",") == -1);
            if (isExt) {
                if ((isShowHide != null) && isShowHide.equals(Global.HIDE) && e.getIsShow()) {
                    continue;
                }
                Map<String, Object> map = Maps.newHashMap();
                map.put("id", e.getId());
                map.put("pId", e.getParentId());
                map.put("name", e.getName());
                mapList.add(map);
            }
        }
        return mapList;
    }

    /**
     * 跳转到设计页面 .
     *
     * @param actYwGnode
     * @param model
     *            模型
     * @param redirectAttributes
     *            重定向
     * @return String 字符
     */
    @RequestMapping(value = "designNew")
    public String designNew(ActYwGnode actYwGnode, Model model, RedirectAttributes redirectAttributes) {
        if ((actYwGnode.getGroup() == null) || StringUtil.isEmpty(actYwGnode.getGroup().getId())) {
            addMessage(redirectAttributes, "自定义流程为空，操作失败！");
            return CoreSval.REDIRECT + Global.getAdminPath() + "/actyw/actYwGnode/?repage";
        }
        model.addAttribute(ActYwGroup.JK_GROUP, actYwGroupService.get(actYwGnode.getGroup().getId()));
        model.addAttribute(CoreJkey.JK_ROOT, CoreIds.SYS_TREE_ROOT.getId());
//        model.addAttribute("frontUid", SysIds.SYS_ROLE_USER.getId());
        model.addAttribute(ActKey.JK_ROOT_START, actYwGnodeService.getStart(actYwGnode.getGroup().getId()));
        return "modules/actyw/actYwGnodeDesignNew";
    }

    /**
     * 跳转到流程跟踪页面 . 根据流程实例ID定位流程跟踪(自定义的项目、大赛使用).
     *
     * @param groupId
     *            流程ID
     * @param proInsId
     *            流程实例ID
     * @param model
     *            模型
     * @param request
     *            请求
     * @return
     */
    @RequestMapping(value = "designView")
    public String designView(String groupId, String proInsId, String grade, Model model, HttpServletRequest request) {
        if (StringUtil.isNotEmpty(grade)) {
            model.addAttribute(ActYwTool.FLOW_PROP_GATEWAY_STATE, grade);
        }

        if (StringUtil.isNotEmpty(groupId)) {
            model.addAttribute(ActYwGroup.JK_GROUP, actYwGroupService.get(groupId));
            model.addAttribute(ActYwGroup.JK_GROUP_ID, groupId);
        }

        if (StringUtil.isNotEmpty(proInsId)) {
            model.addAttribute("proInsId", proInsId);
        }

        model.addAttribute("faUrl", "a");
        return "modules/actyw/actYwGnodeDesignAdminView";
    }

    /**
     * 根据状态和流程ID 定位流程跟踪(旧的项目、大赛使用).
     *
     * @param idx
     *            状态
     * @param groupId
     *            流程ID
     * @param model
     *            模型
     * @return String
     */
    @RequestMapping(value = "designView/{idx}")
    public String designView(@PathVariable String idx, @RequestParam(required = true) String groupId, String grade,
            Model model) {
        if (StringUtil.isNotEmpty(grade)) {
            model.addAttribute(ActYwTool.FLOW_PROP_GATEWAY_STATE, grade);
        }

        model.addAttribute(ActYwGroup.JK_GROUP_ID, groupId);
        model.addAttribute(ActYwGroup.JK_GROUP, actYwGroupService.get(groupId));
        model.addAttribute(ActYwGroup.JK_GNODE, actYwGnodeService.getGnodeByStatus(idx, groupId, model));
        model.addAttribute("faUrl", "a");
        return "modules/actyw/actYwGnodeDesignAdminViewPro";
    }

    @RequestMapping(value = { "list", "" })
    public String list(ActYwGnode actYwGnode, String groupId, Boolean isYw, HttpServletRequest request,
                       HttpServletResponse response, Model model) {
        List<ActYwGnode> list = Lists.newArrayList();
        List<ActYwGroup> actYwGroups = actYwGroupService.findList(new ActYwGroup());
        if (actYwGnode.getGroup() == null || StringUtils.isBlank(actYwGnode.getGroup().getId())) {
            actYwGnode.setGroup(actYwGroups.get(0));
        }
        ActYwGnode pactYwGnode = new ActYwGnode();
        pactYwGnode.setGroup(actYwGnode.getGroup());
        pactYwGnode.setIsShow(actYwGnode.getIsShow());

        isYw = ((isYw == null) ? true : isYw);
        if (isYw) {
            List<String> types = new ArrayList<>(3);
            types.add(GnodeType.GT_ROOT_TASK.getId());
            types.add(GnodeType.GT_PROCESS.getId());
            types.add(GnodeType.GT_PROCESS_TASK.getId());
            pactYwGnode.setTypes(types);
        }
        List<ActYwGnode> sourcelist = actYwGnodeService.findList(pactYwGnode);
        ActYwGnode.sortList(list, sourcelist, ActYwGnode.getRootId(), true);


        if (!list.isEmpty()) {
            ActYwGroup actYwGroup = new ActYwGroup(actYwGnode.getGroup().getId());
            ActYwGrole actYwGrole = new ActYwGrole();
            actYwGrole.setGroup(actYwGroup);

            ActYwGform actYwGform = new ActYwGform();
            actYwGform.setGroup(actYwGroup);
            for (ActYwGnode ywGnode : list) {
                //角色
                actYwGrole.setGnode(new ActYwGnode(ywGnode.getId()));
                List<ActYwGrole> roles = actYwGroleService.findList(actYwGrole);
                ywGnode.setGroles(roles);

                //表单
                actYwGform.setGnode(new ActYwGnode(ywGnode.getId()));
                List<ActYwGform> forms = actYwGformService.findList(actYwGform);
                ywGnode.setGforms(forms);
            }
        }

        model.addAttribute("list", list);
        model.addAttribute("isYw", isYw);
        model.addAttribute("actYwGroups", actYwGroups);
        return "modules/actyw/actYwGnodeList";
    }


    @RequestMapping(value = { "/view" })
    public String view(ActYwGnode actYwGnode, Model model) {
        String preId = actYwGnode.getPreId();
        if(StringUtils.isNotBlank(preId)){
            String[] split = preId.split(",");
            String[] preNodeNames = new String[split.length];
            for (int i = 0; i < split.length; i++) {
                ActYwGnode preNode = actYwGnodeService.get(split[0]);
                if (preNode != null) {
                    preNodeNames[i] = preNode.getName();
                }
            }
            model.addAttribute("preNodeNames", StringUtils.join(preNodeNames, ","));
        }
        List<ActYwGnode> nextNodes = actYwGnodeService.getNextNode(actYwGnode);
        String[] nextNodeNames = new String[nextNodes.size()];
        if(!nextNodes.isEmpty()){
            for (int i = 0; i < nextNodes.size(); i++) {
                nextNodeNames[i] = nextNodes.get(0).getName();
            }
            model.addAttribute("nextNodeNames", StringUtils.join(nextNodeNames, ","));
        }

        //角色
        ActYwGrole actYwGrole = new ActYwGrole();
        actYwGrole.setGroup(actYwGnode.getGroup());
        actYwGrole.setGnode(new ActYwGnode(actYwGnode.getId()));
        List<ActYwGrole> roles = actYwGroleService.findList(actYwGrole);
        actYwGnode.setGroles(roles);

        //表单
        ActYwGform actYwGform = new ActYwGform();
        actYwGform.setGroup(actYwGnode.getGroup());
        actYwGform.setGnode(new ActYwGnode(actYwGnode.getId()));
        List<ActYwGform> forms = actYwGformService.findList(actYwGform);
        actYwGnode.setGforms(forms);

        //状态
        ActYwGstatus actYwGstatus = new ActYwGstatus();
        actYwGstatus.setGroup(actYwGnode.getGroup());
        actYwGstatus.setGnode(new ActYwGnode(actYwGnode.getId()));
        List<ActYwGstatus> status = actYwGstatusService.findList(actYwGstatus);
        actYwGnode.setGstatuss(status);

        return "modules/actyw/actYwGnodeFormProp";
    }


}