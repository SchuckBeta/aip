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

import com.oseasy.pact.modules.actyw.entity.ActYwConfig;
import com.oseasy.pact.modules.actyw.service.ActYwConfigService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 业务配置项Controller.
 * @author chenh
 * @version 2017-11-09
 */
@Controller
@RequestMapping(value = "${adminPath}/actyw/actYwConfig")
public class ActYwConfigController extends BaseController {

	@Autowired
	private ActYwConfigService actYwConfigService;

	@ModelAttribute
	public ActYwConfig get(@RequestParam(required=false) String id) {
		ActYwConfig entity = null;
		if (StringUtil.isNotBlank(id)) {
			entity = actYwConfigService.get(id);
		}
		if (entity == null) {
			entity = new ActYwConfig();
		}
		return entity;
	}

	@RequiresPermissions("actyw:actYwConfig:view")
	@RequestMapping(value = {"list", ""})
	public String list(ActYwConfig actYwConfig, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ActYwConfig> page = actYwConfigService.findPage(new Page<ActYwConfig>(request, response), actYwConfig);
		model.addAttribute("page", page);
		return "modules/actyw/actYwConfigList";
	}

	@RequiresPermissions("actyw:actYwConfig:view")
	@RequestMapping(value = "form")
	public String form(ActYwConfig actYwConfig, Model model) {
		model.addAttribute("actYwConfig", actYwConfig);
		return "modules/actyw/actYwConfigForm";
	}

	@RequiresPermissions("actyw:actYwConfig:edit")
	@RequestMapping(value = "save")
	public String save(ActYwConfig actYwConfig, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, actYwConfig)) {
			return form(actYwConfig, model);
		}
		actYwConfigService.save(actYwConfig);
		addMessage(redirectAttributes, "保存业务配置项成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwConfig/?repage";
	}

	@RequiresPermissions("actyw:actYwConfig:edit")
	@RequestMapping(value = "delete")
	public String delete(ActYwConfig actYwConfig, RedirectAttributes redirectAttributes) {
		actYwConfigService.delete(actYwConfig);
		addMessage(redirectAttributes, "删除业务配置项成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwConfig/?repage";
	}

}