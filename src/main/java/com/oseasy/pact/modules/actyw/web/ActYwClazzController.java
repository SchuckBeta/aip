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

import com.oseasy.pact.modules.actyw.entity.ActYwClazz;
import com.oseasy.pact.modules.actyw.service.ActYwClazzService;
import com.oseasy.pact.modules.actyw.tool.process.vo.ClazzThemeListener;
import com.oseasy.pact.modules.actyw.tool.process.vo.FormTheme;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 监听Controller.
 * @author chenh
 * @version 2018-03-01
 */
@Controller
@RequestMapping(value = "${adminPath}/actyw/actYwClazz")
public class ActYwClazzController extends BaseController {

	@Autowired
	private ActYwClazzService actYwClazzService;

	@ModelAttribute
	public ActYwClazz get(@RequestParam(required=false) String id) {
		ActYwClazz entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = actYwClazzService.get(id);
		}
		if (entity == null){
			entity = new ActYwClazz();
		}
		return entity;
	}

	@RequiresPermissions("actyw:actYwClazz:view")
	@RequestMapping(value = {"list", ""})
	public String list(ActYwClazz actYwClazz, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ActYwClazz> page = actYwClazzService.findPage(new Page<ActYwClazz>(request, response), actYwClazz);
		model.addAttribute("page", page);
        model.addAttribute(FormTheme.FLOW_THEMES, FormTheme.getAll());
		return "modules/actyw/actYwClazzList";
	}

	@RequiresPermissions("actyw:actYwClazz:view")
	@RequestMapping(value = "form")
	public String form(ActYwClazz actYwClazz, Model model) {
		model.addAttribute("actYwClazz", actYwClazz);
        model.addAttribute(FormTheme.FLOW_THEMES, FormTheme.getAll());
        model.addAttribute("ctlisteners", ClazzThemeListener.getAll());
		return "modules/actyw/actYwClazzForm";
	}

	@RequiresPermissions("actyw:actYwClazz:edit")
	@RequestMapping(value = "save")
	public String save(ActYwClazz actYwClazz, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, actYwClazz)){
			return form(actYwClazz, model);
		}
		actYwClazzService.save(actYwClazz);
		addMessage(redirectAttributes, "保存监听成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwClazz/?repage";
	}

	@RequiresPermissions("actyw:actYwClazz:edit")
	@RequestMapping(value = "delete")
	public String delete(ActYwClazz actYwClazz, RedirectAttributes redirectAttributes) {
		actYwClazzService.delete(actYwClazz);
		addMessage(redirectAttributes, "删除监听成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwClazz/?repage";
	}

}