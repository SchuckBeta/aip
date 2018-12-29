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
import com.oseasy.pgen.modules.gen.entity.GenTgroup;
import com.oseasy.pgen.modules.gen.service.GenTgroupService;

/**
 * 模板组Controller.
 * @author chenh
 * @version 2018-12-29
 */
@Controller
@RequestMapping(value = "${adminPath}/gen/genTgroup")
public class GenTgroupController extends BaseController {

	@Autowired
	private GenTgroupService entityService;

	@ModelAttribute
	public GenTgroup get(@RequestParam(required=false) String id) {
		GenTgroup entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new GenTgroup();
		}
		return entity;
	}

	@RequiresPermissions("gen:genTgroup:view")
	@RequestMapping(value = {"list", ""})
	public String list(GenTgroup entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<GenTgroup> page = entityService.findPage(new Page<GenTgroup>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/gen/genTgroupList";
	}

	@RequiresPermissions("gen:genTgroup:view")
	@RequestMapping(value = "form")
	public String form(GenTgroup entity, Model model) {
		model.addAttribute("genTgroup", entity);
		return "modules/gen/genTgroupForm";
	}

	@RequiresPermissions("gen:genTgroup:edit")
	@RequestMapping(value = "save")
	public String save(GenTgroup entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存模板组成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/gen/genTgroup/?repage";
	}

	@RequiresPermissions("gen:genTgroup:edit")
	@RequestMapping(value = "delete")
	public String delete(GenTgroup entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除模板组成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/gen/genTgroup/?repage";
	}

}