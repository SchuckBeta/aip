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

import com.oseasy.pact.modules.actyw.entity.ActYwGuser;
import com.oseasy.pact.modules.actyw.service.ActYwGuserService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 节点用户Controller.
 * @author chenh
 * @version 2018-01-15
 */
@Controller
@RequestMapping(value = "${adminPath}/actyw/actYwGuser")
public class ActYwGuserController extends BaseController {

	@Autowired
	private ActYwGuserService actYwGuserService;

	@ModelAttribute
	public ActYwGuser get(@RequestParam(required=false) String id) {
		ActYwGuser entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = actYwGuserService.get(id);
		}
		if (entity == null){
			entity = new ActYwGuser();
		}
		return entity;
	}

	@RequiresPermissions("actyw:actYwGuser:view")
	@RequestMapping(value = {"list", ""})
	public String list(ActYwGuser actYwGuser, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ActYwGuser> page = actYwGuserService.findPage(new Page<ActYwGuser>(request, response), actYwGuser);
		model.addAttribute("page", page);
		return "modules/actyw/actYwGuserList";
	}

	@RequiresPermissions("actyw:actYwGuser:view")
	@RequestMapping(value = "form")
	public String form(ActYwGuser actYwGuser, Model model) {
		model.addAttribute("actYwGuser", actYwGuser);
		return "modules/actyw/actYwGuserForm";
	}

	@RequiresPermissions("actyw:actYwGuser:edit")
	@RequestMapping(value = "save")
	public String save(ActYwGuser actYwGuser, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, actYwGuser)){
			return form(actYwGuser, model);
		}
		actYwGuserService.save(actYwGuser);
		addMessage(redirectAttributes, "保存节点用户成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGuser/?repage";
	}

	@RequiresPermissions("actyw:actYwGuser:edit")
	@RequestMapping(value = "delete")
	public String delete(ActYwGuser actYwGuser, RedirectAttributes redirectAttributes) {
		actYwGuserService.delete(actYwGuser);
		addMessage(redirectAttributes, "删除节点用户成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGuser/?repage";
	}

}