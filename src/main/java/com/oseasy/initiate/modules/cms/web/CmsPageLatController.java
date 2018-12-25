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
import com.oseasy.initiate.modules.cms.entity.CmsPageLat;
import com.oseasy.initiate.modules.cms.service.CmsPageLatService;

/**
 * 页面布局Controller.
 * @author chenh
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmsPageLat")
public class CmsPageLatController extends BaseController {

	@Autowired
	private CmsPageLatService entityService;

	@ModelAttribute
	public CmsPageLat get(@RequestParam(required=false) String id) {
		CmsPageLat entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmsPageLat();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmsPageLat:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmsPageLat entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CmsPageLat> page = entityService.findPage(new Page<CmsPageLat>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/cms/cmsPageLatList";
	}

	@RequiresPermissions("cms:cmsPageLat:view")
	@RequestMapping(value = "form")
	public String form(CmsPageLat entity, Model model) {
		model.addAttribute("cmsPageLat", entity);
		return "modules/cms/cmsPageLatForm";
	}

	@RequiresPermissions("cms:cmsPageLat:edit")
	@RequestMapping(value = "save")
	public String save(CmsPageLat entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存页面布局成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsPageLat/?repage";
	}

	@RequiresPermissions("cms:cmsPageLat:edit")
	@RequestMapping(value = "delete")
	public String delete(CmsPageLat entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除页面布局成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsPageLat/?repage";
	}

}