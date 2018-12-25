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
import com.oseasy.initiate.modules.cms.entity.CmsTheme;
import com.oseasy.initiate.modules.cms.service.CmsThemeService;

/**
 * 主题Controller.
 * @author chenhao
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmsTheme")
public class CmsThemeController extends BaseController {

	@Autowired
	private CmsThemeService entityService;

	@ModelAttribute
	public CmsTheme get(@RequestParam(required=false) String id) {
		CmsTheme entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmsTheme();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmsTheme:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmsTheme entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CmsTheme> page = entityService.findPage(new Page<CmsTheme>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/cms/cmsThemeList";
	}

	@RequiresPermissions("cms:cmsTheme:view")
	@RequestMapping(value = "form")
	public String form(CmsTheme entity, Model model) {
		model.addAttribute("cmsTheme", entity);
		return "modules/cms/cmsThemeForm";
	}

	@RequiresPermissions("cms:cmsTheme:edit")
	@RequestMapping(value = "save")
	public String save(CmsTheme entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存主题成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsTheme/?repage";
	}

	@RequiresPermissions("cms:cmsTheme:edit")
	@RequestMapping(value = "delete")
	public String delete(CmsTheme entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除主题成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsTheme/?repage";
	}

}