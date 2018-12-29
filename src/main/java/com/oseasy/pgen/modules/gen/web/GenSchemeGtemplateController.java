package com.oseasy.pgen.modules.gen.web;

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

import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.pgen.modules.gen.entity.GenSchemeGtemplate;
import com.oseasy.pgen.modules.gen.service.GenSchemeGtemplateService;

/**
 * 模板方案组关联Controller.
 * @author chenh
 * @version 2018-12-29
 */
@Controller
@RequestMapping(value = "${adminPath}/gen/genSchemeGtemplate")
public class GenSchemeGtemplateController extends BaseController {

	@Autowired
	private GenSchemeGtemplateService entityService;

	@ModelAttribute
	public GenSchemeGtemplate get(@RequestParam(required=false) String id) {
		GenSchemeGtemplate entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new GenSchemeGtemplate();
		}
		return entity;
	}

	@RequiresPermissions("gen:genSchemeGtemplate:view")
	@RequestMapping(value = {"list", ""})
	public String list(GenSchemeGtemplate entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<GenSchemeGtemplate> page = entityService.findPage(new Page<GenSchemeGtemplate>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/gen/genSchemeGtemplateList";
	}

	@RequiresPermissions("gen:genSchemeGtemplate:view")
	@RequestMapping(value = "form")
	public String form(GenSchemeGtemplate entity, Model model) {
		model.addAttribute("genSchemeGtemplate", entity);
		return "modules/gen/genSchemeGtemplateForm";
	}

	@RequiresPermissions("gen:genSchemeGtemplate:edit")
	@RequestMapping(value = "save")
	public String save(GenSchemeGtemplate entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存模板方案组关联成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/gen/genSchemeGtemplate/?repage";
	}

	@RequiresPermissions("gen:genSchemeGtemplate:edit")
	@RequestMapping(value = "delete")
	public String delete(GenSchemeGtemplate entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除模板方案组关联成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/gen/genSchemeGtemplate/?repage";
	}

}