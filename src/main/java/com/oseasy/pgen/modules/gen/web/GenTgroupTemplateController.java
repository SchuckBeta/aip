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
import com.oseasy.pgen.modules.gen.entity.GenTgroupTemplate;
import com.oseasy.pgen.modules.gen.service.GenTgroupTemplateService;

/**
 * 模板组关联Controller.
 * @author chenh
 * @version 2018-12-29
 */
@Controller
@RequestMapping(value = "${adminPath}/gen/genTgroupTemplate")
public class GenTgroupTemplateController extends BaseController {

	@Autowired
	private GenTgroupTemplateService entityService;

	@ModelAttribute
	public GenTgroupTemplate get(@RequestParam(required=false) String id) {
		GenTgroupTemplate entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new GenTgroupTemplate();
		}
		return entity;
	}

	@RequiresPermissions("gen:genTgroupTemplate:view")
	@RequestMapping(value = {"list", ""})
	public String list(GenTgroupTemplate entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<GenTgroupTemplate> page = entityService.findPage(new Page<GenTgroupTemplate>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/gen/genTgroupTemplateList";
	}

	@RequiresPermissions("gen:genTgroupTemplate:view")
	@RequestMapping(value = "form")
	public String form(GenTgroupTemplate entity, Model model) {
		model.addAttribute("genTgroupTemplate", entity);
		return "modules/gen/genTgroupTemplateForm";
	}

	@RequiresPermissions("gen:genTgroupTemplate:edit")
	@RequestMapping(value = "save")
	public String save(GenTgroupTemplate entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存模板组关联成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/gen/genTgroupTemplate/?repage";
	}

	@RequiresPermissions("gen:genTgroupTemplate:edit")
	@RequestMapping(value = "delete")
	public String delete(GenTgroupTemplate entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除模板组关联成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/gen/genTgroupTemplate/?repage";
	}

}