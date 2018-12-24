package com.oseasy.pact.modules.act.web;

import java.io.InputStream;

import javax.servlet.http.HttpServletResponse;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.repository.ProcessDefinition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.oseasy.pact.modules.act.service.ActTaskService;
import com.oseasy.pact.modules.act.utils.ProcessMapUtil;
import com.oseasy.pact.modules.act.vo.ProcessMapVo;
import com.oseasy.pcore.common.web.BaseController;

/**
 * Created by zhangzheng on 2017/3/23.
 */
@Controller
@RequestMapping(value = "${frontPath}/act/task")
public class FrontActTaskContoller extends BaseController {
    @Autowired
    ActTaskService actTaskService;
    @Autowired
    RepositoryService repositoryService;
    @Autowired
    RuntimeService runtimeService;

    //获取跟踪信息
    @RequestMapping(value = "processMapByType")
    public String processMap(String proInsId, String type, String status, Model model) {
      ProcessMapVo vo = ProcessMapUtil.processMap(repositoryService, actTaskService, runtimeService, proInsId, type, status);
      model.addAttribute(ProcessMapVo.PM_PROC_DEF_ID, vo.getProcDefId());
      model.addAttribute(ProcessMapVo.PM_PRO_INST_ID, vo.getProInstId());
      model.addAttribute(ProcessMapVo.PM_ACT_IMPLS, vo.getActImpls());
      return "modules/act/frontActTaskMap";
    }

    //获取跟踪信息
    @RequestMapping(value = "processMap")
    public String processMap(String proInsId, Model model) {
      ProcessMapVo vo = ProcessMapUtil.processMap(repositoryService, actTaskService, runtimeService, proInsId, null, null);
      model.addAttribute(ProcessMapVo.PM_PROC_DEF_ID, vo.getProcDefId());
      model.addAttribute(ProcessMapVo.PM_PRO_INST_ID, vo.getProInstId());
      model.addAttribute(ProcessMapVo.PM_ACT_IMPLS, vo.getActImpls());
        return "modules/act/frontActTaskMap";
    }

    @RequestMapping(value = "processPic")
    public void processPic(String procDefId, HttpServletResponse response) throws Exception {
        ProcessDefinition procDef = repositoryService.createProcessDefinitionQuery().processDefinitionId(procDefId).singleResult();
        String diagramResourceName = procDef.getDiagramResourceName();
        InputStream imageStream = repositoryService.getResourceAsStream(procDef.getDeploymentId(), diagramResourceName);
        byte[] b = new byte[1024];
        int len = -1;
        while ((len = imageStream.read(b, 0, 1024)) != -1) {
            response.getOutputStream().write(b, 0, len);
        }
    }

}
