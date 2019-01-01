package com.oseasy.pcms.modules.cms.web.a;

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
import com.oseasy.pcms.modules.cms.entity.CmsThemeDetail;
import com.oseasy.pcms.modules.cms.service.CmsThemeDetailService;

/**
 * 主题明细Controller.
 * @author chenhao
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmsThemeDetail")
public class CmsThemeDetailController extends BaseController {

	@Autowired
	private CmsThemeDetailService entityService;

	@ModelAttribute
	public CmsThemeDetail get(@RequestParam(required=false) String id) {
		CmsThemeDetail entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmsThemeDetail();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmsThemeDetail:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmsThemeDetail entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CmsThemeDetail> page = entityService.findPage(new Page<CmsThemeDetail>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/cms/cmsThemeDetailList";
	}

	@RequiresPermissions("cms:cmsThemeDetail:view")
	@RequestMapping(value = "form")
	public String form(CmsThemeDetail entity, Model model) {
		model.addAttribute("cmsThemeDetail", entity);
		return "modules/cms/cmsThemeDetailForm";
	}

	@RequiresPermissions("cms:cmsThemeDetail:edit")
	@RequestMapping(value = "save")
	public String save(CmsThemeDetail entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存主题明细成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsThemeDetail/?repage";
	}

	@RequiresPermissions("cms:cmsThemeDetail:edit")
	@RequestMapping(value = "delete")
	public String delete(CmsThemeDetail entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除主题明细成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsThemeDetail/?repage";
	}

}