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

import com.oseasy.pact.modules.actyw.entity.ActYwGclazz;
import com.oseasy.pact.modules.actyw.service.ActYwGclazzService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 监听类Controller.
 * @author chenh
 * @version 2018-03-01
 */
@Controller
@RequestMapping(value = "${adminPath}/actyw/actYwGclazz")
public class ActYwGclazzController extends BaseController {

	@Autowired
	private ActYwGclazzService actYwGclazzService;

	@ModelAttribute
	public ActYwGclazz get(@RequestParam(required=false) String id) {
		ActYwGclazz entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = actYwGclazzService.get(id);
		}
		if (entity == null){
			entity = new ActYwGclazz();
		}
		return entity;
	}

	@RequiresPermissions("actyw:actYwGclazz:view")
	@RequestMapping(value = {"list", ""})
	public String list(ActYwGclazz actYwGclazz, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ActYwGclazz> page = actYwGclazzService.findPage(new Page<ActYwGclazz>(request, response), actYwGclazz);
		model.addAttribute("page", page);
		return "modules/actyw/actYwGclazzList";
	}

	@RequiresPermissions("actyw:actYwGclazz:view")
	@RequestMapping(value = "form")
	public String form(ActYwGclazz actYwGclazz, Model model) {
		model.addAttribute("actYwGclazz", actYwGclazz);
		return "modules/actyw/actYwGclazzForm";
	}

	@RequiresPermissions("actyw:actYwGclazz:edit")
	@RequestMapping(value = "save")
	public String save(ActYwGclazz actYwGclazz, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, actYwGclazz)){
			return form(actYwGclazz, model);
		}
		actYwGclazzService.save(actYwGclazz);
		addMessage(redirectAttributes, "保存监听成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGclazz/?repage";
	}

	@RequiresPermissions("actyw:actYwGclazz:edit")
	@RequestMapping(value = "delete")
	public String delete(ActYwGclazz actYwGclazz, RedirectAttributes redirectAttributes) {
		actYwGclazzService.delete(actYwGclazz);
		addMessage(redirectAttributes, "删除监听成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGclazz/?repage";
	}

}