package com.oseasy.pcms.modules.cmst.web;

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
import com.oseasy.pcms.modules.cmst.entity.CmstRel;
import com.oseasy.pcms.modules.cmst.service.CmstRelService;

/**
 * 站点模板关联Controller.
 * @author chenh
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmstRel")
public class CmstRelController extends BaseController {

	@Autowired
	private CmstRelService entityService;

	@ModelAttribute
	public CmstRel get(@RequestParam(required=false) String id) {
		CmstRel entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmstRel();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmstRel:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmstRel entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CmstRel> page = entityService.findPage(new Page<CmstRel>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/cms/cmstRelList";
	}

	@RequiresPermissions("cms:cmstRel:view")
	@RequestMapping(value = "form")
	public String form(CmstRel entity, Model model) {
		model.addAttribute("cmstRel", entity);
		return "modules/cms/cmstRelForm";
	}

	@RequiresPermissions("cms:cmstRel:edit")
	@RequestMapping(value = "save")
	public String save(CmstRel entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存站点模板关联成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmstRel/?repage";
	}

	@RequiresPermissions("cms:cmstRel:edit")
	@RequestMapping(value = "delete")
	public String delete(CmstRel entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除站点模板关联成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmstRel/?repage";
	}

}