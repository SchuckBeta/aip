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
import com.oseasy.initiate.modules.cms.entity.CmsPage;
import com.oseasy.initiate.modules.cms.service.CmsPageService;

/**
 * 页面Controller.
 * @author chenh
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmsPage")
public class CmsPageController extends BaseController {

	@Autowired
	private CmsPageService entityService;

	@ModelAttribute
	public CmsPage get(@RequestParam(required=false) String id) {
		CmsPage entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmsPage();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmsPage:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmsPage entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CmsPage> page = entityService.findPage(new Page<CmsPage>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/cms/cmsPageList";
	}

	@RequiresPermissions("cms:cmsPage:view")
	@RequestMapping(value = "form")
	public String form(CmsPage entity, Model model) {
		model.addAttribute("cmsPage", entity);
		return "modules/cms/cmsPageForm";
	}

	@RequiresPermissions("cms:cmsPage:edit")
	@RequestMapping(value = "save")
	public String save(CmsPage entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存页面成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsPage/?repage";
	}

	@RequiresPermissions("cms:cmsPage:edit")
	@RequestMapping(value = "delete")
	public String delete(CmsPage entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除页面成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsPage/?repage";
	}

}