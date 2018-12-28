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
import com.oseasy.pgen.modules.gen.entity.GenTablefk;
import com.oseasy.pgen.modules.gen.service.GenTablefkService;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * GenTableFkController.
 * @author chenh
 * @version 2018-12-28
 */
@Controller
@RequestMapping(value = "${adminPath}/gen/genTablefk")
public class GenTablefkController extends BaseController {

	@Autowired
	private GenTablefkService entityService;

	@ModelAttribute
	public GenTablefk get(@RequestParam(required=false) String id) {
		GenTablefk entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new GenTablefk();
		}
		return entity;
	}

	@RequiresPermissions("gen:genTablefk:view")
	@RequestMapping(value = {"list", ""})
	public String list(GenTablefk entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<GenTablefk> page = entityService.findPage(new Page<GenTablefk>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/gen/genTablefkList";
	}

	@RequiresPermissions("gen:genTablefk:view")
	@RequestMapping(value = "form")
	public String form(GenTablefk entity, Model model) {
		model.addAttribute("genTablefk", entity);
		return "modules/gen/genTablefkForm";
	}

	@RequiresPermissions("gen:genTablefk:edit")
	@RequestMapping(value = "save")
	public String save(GenTablefk entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存GenTableFk成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/gen/genTablefk/?repage";
	}

	@RequiresPermissions("gen:genTablefk:edit")
	@RequestMapping(value = "delete")
	public String delete(GenTablefk entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除GenTableFk成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/gen/genTablefk/?repage";
	}

}