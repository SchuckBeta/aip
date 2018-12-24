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

import com.oseasy.pact.modules.actyw.entity.ActYwYear;
import com.oseasy.pact.modules.actyw.service.ActYwYearService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 流程年份表Controller.
 * @author zy
 * @version 2018-03-21
 */
@Controller
@RequestMapping(value = "${adminPath}/actyw/actYwYear")
public class ActYwYearController extends BaseController {

	@Autowired
	private ActYwYearService actYwYearService;

	@ModelAttribute
	public ActYwYear get(@RequestParam(required=false) String id) {
		ActYwYear entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = actYwYearService.get(id);
		}
		if (entity == null){
			entity = new ActYwYear();
		}
		return entity;
	}

	@RequiresPermissions("actyw:actYwYear:view")
	@RequestMapping(value = {"list", ""})
	public String list(ActYwYear actYwYear, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ActYwYear> page = actYwYearService.findPage(new Page<ActYwYear>(request, response), actYwYear);
		model.addAttribute("page", page);
		return "modules/actyw/actYwYearList";
	}

	@RequiresPermissions("actyw:actYwYear:view")
	@RequestMapping(value = "form")
	public String form(ActYwYear actYwYear, Model model) {
		model.addAttribute("actYwYear", actYwYear);
		return "modules/actyw/actYwYearForm";
	}

	@RequiresPermissions("actyw:actYwYear:edit")
	@RequestMapping(value = "save")
	public String save(ActYwYear actYwYear, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, actYwYear)){
			return form(actYwYear, model);
		}
		actYwYearService.save(actYwYear);
		addMessage(redirectAttributes, "保存流程年份表成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwYear/?repage";
	}

	@RequiresPermissions("actyw:actYwYear:edit")
	@RequestMapping(value = "delete")
	public String delete(ActYwYear actYwYear, RedirectAttributes redirectAttributes) {
		actYwYearService.delete(actYwYear);
		addMessage(redirectAttributes, "删除流程年份表成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwYear/?repage";
	}

}