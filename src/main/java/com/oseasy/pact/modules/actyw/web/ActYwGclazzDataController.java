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

import com.oseasy.pact.modules.actyw.entity.ActYwGclazzData;
import com.oseasy.pact.modules.actyw.service.ActYwGclazzDataService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 监听数据Controller.
 * @author chenh
 * @version 2018-03-08
 */
@Controller
@RequestMapping(value = "${adminPath}/actyw/actYwGclazzData")
public class ActYwGclazzDataController extends BaseController {

	@Autowired
	private ActYwGclazzDataService actYwGclazzDataService;

	@ModelAttribute
	public ActYwGclazzData get(@RequestParam(required=false) String id) {
		ActYwGclazzData entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = actYwGclazzDataService.get(id);
		}
		if (entity == null){
			entity = new ActYwGclazzData();
		}
		return entity;
	}

	@RequiresPermissions("actyw:actYwGclazzData:view")
	@RequestMapping(value = {"list", ""})
	public String list(ActYwGclazzData actYwGclazzData, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ActYwGclazzData> page = actYwGclazzDataService.findPage(new Page<ActYwGclazzData>(request, response), actYwGclazzData);
		model.addAttribute("page", page);
		return "modules/actyw/actYwGclazzDataList";
	}

	@RequiresPermissions("actyw:actYwGclazzData:view")
	@RequestMapping(value = "form")
	public String form(ActYwGclazzData actYwGclazzData, Model model) {
		model.addAttribute("actYwGclazzData", actYwGclazzData);
		return "modules/actyw/actYwGclazzDataForm";
	}

	@RequiresPermissions("actyw:actYwGclazzData:edit")
	@RequestMapping(value = "save")
	public String save(ActYwGclazzData actYwGclazzData, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, actYwGclazzData)){
			return form(actYwGclazzData, model);
		}
		actYwGclazzDataService.save(actYwGclazzData);
		addMessage(redirectAttributes, "保存监听数据成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGclazzData/?repage";
	}

	@RequiresPermissions("actyw:actYwGclazzData:edit")
	@RequestMapping(value = "delete")
	public String delete(ActYwGclazzData actYwGclazzData, RedirectAttributes redirectAttributes) {
		actYwGclazzDataService.delete(actYwGclazzData);
		addMessage(redirectAttributes, "删除监听数据成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGclazzData/?repage";
	}

}