package com.oseasy.pact.modules.actyw.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oseasy.pact.modules.actyw.entity.ActYwApply;
import com.oseasy.pact.modules.actyw.service.ActYwApplyService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 流程申请Controller.
 * @author zy
 * @version 2017-12-05
 */
@Controller
@RequestMapping(value = "${adminPath}/actyw/actYwApply")
public class ActYwApplyController extends BaseController {

	@Autowired
	private ActYwApplyService actYwApplyService;

	@ModelAttribute
	public ActYwApply get(@RequestParam(required=false) String id) {
		ActYwApply entity = null;
		if (StringUtil.isNotBlank(id)) {
			entity = actYwApplyService.get(id);
		}
		if (entity == null) {
			entity = new ActYwApply();
		}
		return entity;
	}

	@RequiresPermissions("actyw:actYwApply:view")
	@RequestMapping(value = {"list", ""})
	public String list(ActYwApply actYwApply, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ActYwApply> page = actYwApplyService.findPage(new Page<ActYwApply>(request, response), actYwApply);
		model.addAttribute("page", page);
		return "modules/actyw/actYwApplyList";
	}

	@RequiresPermissions("actyw:actYwApply:view")
	@RequestMapping(value = "form")
	public String form(ActYwApply actYwApply, Model model) {
		model.addAttribute("actYwApply", actYwApply);
		return "modules/actyw/actYwApplyForm";
	}

	@RequiresPermissions("actyw:actYwApply:edit")
	@RequestMapping(value = "save")
	public String save(ActYwApply actYwApply, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, actYwApply)) {
			return form(actYwApply, model);
		}
		actYwApplyService.save(actYwApply);
		addMessage(redirectAttributes, "保存流程申请成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwApply/?repage";
	}

	@RequiresPermissions("actyw:actYwApply:edit")
	@RequestMapping(value = "delete")
	public String delete(ActYwApply actYwApply, RedirectAttributes redirectAttributes) {
		actYwApplyService.delete(actYwApply);
		addMessage(redirectAttributes, "删除流程申请成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwApply/?repage";
	}

}