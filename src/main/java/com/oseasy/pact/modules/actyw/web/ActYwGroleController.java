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

import com.oseasy.pact.modules.actyw.entity.ActYwGrole;
import com.oseasy.pact.modules.actyw.service.ActYwGroleService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 节点角色Controller.
 * @author chenh
 * @version 2018-01-15
 */
@Controller
@RequestMapping(value = "${adminPath}/actyw/actYwGrole")
public class ActYwGroleController extends BaseController {

	@Autowired
	private ActYwGroleService actYwGroleService;

	@ModelAttribute
	public ActYwGrole get(@RequestParam(required=false) String id) {
		ActYwGrole entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = actYwGroleService.get(id);
		}
		if (entity == null){
			entity = new ActYwGrole();
		}
		return entity;
	}

	@RequiresPermissions("actyw:actYwGrole:view")
	@RequestMapping(value = {"list", ""})
	public String list(ActYwGrole actYwGrole, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ActYwGrole> page = actYwGroleService.findPage(new Page<ActYwGrole>(request, response), actYwGrole);
		model.addAttribute("page", page);
		return "modules/actyw/actYwGroleList";
	}

	@RequiresPermissions("actyw:actYwGrole:view")
	@RequestMapping(value = "form")
	public String form(ActYwGrole actYwGrole, Model model) {
		model.addAttribute("actYwGrole", actYwGrole);
		return "modules/actyw/actYwGroleForm";
	}

	@RequiresPermissions("actyw:actYwGrole:edit")
	@RequestMapping(value = "save")
	public String save(ActYwGrole actYwGrole, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, actYwGrole)){
			return form(actYwGrole, model);
		}
		actYwGroleService.save(actYwGrole);
		addMessage(redirectAttributes, "保存节点角色成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGrole/?repage";
	}

	@RequiresPermissions("actyw:actYwGrole:edit")
	@RequestMapping(value = "delete")
	public String delete(ActYwGrole actYwGrole, RedirectAttributes redirectAttributes) {
		actYwGroleService.delete(actYwGrole);
		addMessage(redirectAttributes, "删除节点角色成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGrole/?repage";
	}

}