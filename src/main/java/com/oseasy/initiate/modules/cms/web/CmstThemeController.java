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
import com.oseasy.initiate.modules.cms.entity.CmstTheme;
import com.oseasy.initiate.modules.cms.service.CmstThemeService;

/**
 * 站点模板主题Controller.
 * @author chenh
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmstTheme")
public class CmstThemeController extends BaseController {

	@Autowired
	private CmstThemeService entityService;

	@ModelAttribute
	public CmstTheme get(@RequestParam(required=false) String id) {
		CmstTheme entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmstTheme();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmstTheme:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmstTheme entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CmstTheme> page = entityService.findPage(new Page<CmstTheme>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/cms/cmstThemeList";
	}

	@RequiresPermissions("cms:cmstTheme:view")
	@RequestMapping(value = "form")
	public String form(CmstTheme entity, Model model) {
		model.addAttribute("cmstTheme", entity);
		return "modules/cms/cmstThemeForm";
	}

	@RequiresPermissions("cms:cmstTheme:edit")
	@RequestMapping(value = "save")
	public String save(CmstTheme entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存站点模板主题成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmstTheme/?repage";
	}

	@RequiresPermissions("cms:cmstTheme:edit")
	@RequestMapping(value = "delete")
	public String delete(CmstTheme entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除站点模板主题成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmstTheme/?repage";
	}

}