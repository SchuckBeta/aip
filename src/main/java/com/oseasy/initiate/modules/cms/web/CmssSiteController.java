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
import com.oseasy.initiate.modules.cms.entity.CmssSite;
import com.oseasy.initiate.modules.cms.service.CmssSiteService;

/**
 * 站点明细Controller.
 * @author chenhao
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmssSite")
public class CmssSiteController extends BaseController {

	@Autowired
	private CmssSiteService entityService;

	@ModelAttribute
	public CmssSite get(@RequestParam(required=false) String id) {
		CmssSite entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmssSite();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmssSite:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmssSite entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CmssSite> page = entityService.findPage(new Page<CmssSite>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/cms/cmssSiteList";
	}

	@RequiresPermissions("cms:cmssSite:view")
	@RequestMapping(value = "form")
	public String form(CmssSite entity, Model model) {
		model.addAttribute("cmssSite", entity);
		return "modules/cms/cmssSiteForm";
	}

	@RequiresPermissions("cms:cmssSite:edit")
	@RequestMapping(value = "save")
	public String save(CmssSite entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存站点明细成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmssSite/?repage";
	}

	@RequiresPermissions("cms:cmssSite:edit")
	@RequestMapping(value = "delete")
	public String delete(CmssSite entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除站点明细成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmssSite/?repage";
	}

}