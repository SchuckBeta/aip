package com.oseasy.initiate.modules.cms.web;

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
import com.oseasy.initiate.modules.cms.entity.CmstPage;
import com.oseasy.initiate.modules.cms.service.CmstPageService;

/**
 * 模板页面Controller.
 * @author chenh
 * @version 2018-12-26
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmstPage")
public class CmstPageController extends BaseController {

	@Autowired
	private CmstPageService entityService;

	@ModelAttribute
	public CmstPage get(@RequestParam(required=false) String id) {
		CmstPage entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmstPage();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmstPage:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmstPage entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CmstPage> page = entityService.findPage(new Page<CmstPage>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/cms/cmstPageList";
	}

	@RequiresPermissions("cms:cmstPage:view")
	@RequestMapping(value = "form")
	public String form(CmstPage entity, Model model) {
		model.addAttribute("cmstPage", entity);
		return "modules/cms/cmstPageForm";
	}

	@RequiresPermissions("cms:cmstPage:edit")
	@RequestMapping(value = "save")
	public String save(CmstPage entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存模板页面成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmstPage/?repage";
	}

	@RequiresPermissions("cms:cmstPage:edit")
	@RequestMapping(value = "delete")
	public String delete(CmstPage entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除模板页面成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmstPage/?repage";
	}

}