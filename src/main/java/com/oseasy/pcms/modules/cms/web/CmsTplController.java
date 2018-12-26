package com.oseasy.pcms.modules.cms.web;

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
import com.oseasy.pcms.modules.cms.entity.CmsTpl;
import com.oseasy.pcms.modules.cms.service.CmsTplService;

/**
 * 模板Controller.
 * @author chenh
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmsTpl")
public class CmsTplController extends BaseController {

	@Autowired
	private CmsTplService entityService;

	@ModelAttribute
	public CmsTpl get(@RequestParam(required=false) String id) {
		CmsTpl entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmsTpl();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmsTpl:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmsTpl entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CmsTpl> page = entityService.findPage(new Page<CmsTpl>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/cms/cmsTplList";
	}

	@RequiresPermissions("cms:cmsTpl:view")
	@RequestMapping(value = "form")
	public String form(CmsTpl entity, Model model) {
		model.addAttribute("cmsTpl", entity);
		return "modules/cms/cmsTplForm";
	}

	@RequiresPermissions("cms:cmsTpl:edit")
	@RequestMapping(value = "save")
	public String save(CmsTpl entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存模板成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsTpl/?repage";
	}

	@RequiresPermissions("cms:cmsTpl:edit")
	@RequestMapping(value = "delete")
	public String delete(CmsTpl entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除模板成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsTpl/?repage";
	}

}