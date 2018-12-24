package com.oseasy.initiate.modules.proproject.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oseasy.initiate.common.service.CommonService;
import com.oseasy.initiate.modules.attachment.service.SysAttachmentService;
import com.oseasy.initiate.modules.promodel.service.ProModelService;
import com.oseasy.initiate.modules.proproject.entity.ProProject;
import com.oseasy.initiate.modules.proproject.service.ProProjectService;
import com.oseasy.pact.modules.actyw.service.ActYwService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 创建项目Controller.
 *
 * @author zhangyao
 * @version 2017-06-15
 */
@Controller
@RequestMapping(value = "${adminPath}/proproject/proProject")
public class ProProjectController extends BaseController {

    @Autowired
    private ProProjectService proProjectService;
    @Autowired
    private ProModelService proModelService;
    @Autowired
    private ActYwService actYwService;
    @Autowired
    private CommonService commonService;
    @Autowired
    private SysAttachmentService sysAttachmentService;


    @ModelAttribute
    public ProProject get(@RequestParam(required = false) String id) {
        ProProject entity = null;
        if (StringUtil.isNotBlank(id)) {
            entity = proProjectService.get(id);
        }
        if (entity == null) {
            entity = new ProProject();
        }
        return entity;
    }

    @RequiresPermissions("proproject:proProject:view")
    @RequestMapping(value = {"list", ""})
    public String list(ProProject proProject, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<ProProject> page = proProjectService.findPage(new Page<ProProject>(request, response), proProject);
        model.addAttribute("page", page);
        return "modules/proproject/proProjectList";
    }

    @RequestMapping(value = "validateName")
    @ResponseBody
    public String validateName(String name) {
        //	String name = request.getParameter("name");
        if (proProjectService.getProProjectByName(name) != null) {
            return "1";
        }
        return "0";

    }

    @RequiresPermissions("proproject:proProject:view")
    @RequestMapping(value = "form")
    public String form(ProProject proProject, Model model) {
        model.addAttribute("proProject", proProject);
        /*if (proProject.getProjectMark().equals("gcontest")) {
            return "modules/proproject/proProjectForm";
		}else{

		}*/

        return "modules/proproject/proProjectForm";
    }

    @RequiresPermissions("proproject:proProject:edit")
    @RequestMapping(value = "save")
    public String save(ProProject proProject, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, proProject)) {
            return form(proProject, model);
        }
        if (proProject.getState().equals("1")) {
            proProjectService.saveProProject(proProject);
        } else {
            proProjectService.save(proProject);
        }
        addMessage(redirectAttributes, "保存创建项目成功");
        return CoreSval.REDIRECT + Global.getAdminPath() + "/proproject/proProject/?repage";
    }

    @RequiresPermissions("proproject:proProject:edit")
    @RequestMapping(value = "delete")
    public String delete(ProProject proProject, RedirectAttributes redirectAttributes) {
        proProjectService.delete(proProject);
        addMessage(redirectAttributes, "删除创建项目成功");
        return CoreSval.REDIRECT + Global.getAdminPath() + "/proproject/proProject/?repage";
    }


}