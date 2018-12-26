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
import com.oseasy.pcms.modules.cms.entity.CmssSiteTpl;
import com.oseasy.pcms.modules.cms.service.CmssSiteTplService;

/**
 * 站点模板Controller.
 * @author chenh
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmssSiteTpl")
public class CmssSiteTplController extends BaseController {

	@Autowired
	private CmssSiteTplService entityService;

	@ModelAttribute
	public CmssSiteTpl get(@RequestParam(required=false) String id) {
		CmssSiteTpl entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmssSiteTpl();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmssSiteTpl:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmssSiteTpl entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CmssSiteTpl> page = entityService.findPage(new Page<CmssSiteTpl>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/cms/cmssSiteTplList";
	}

	@RequiresPermissions("cms:cmssSiteTpl:view")
	@RequestMapping(value = "form")
	public String form(CmssSiteTpl entity, Model model) {
		model.addAttribute("cmssSiteTpl", entity);
		return "modules/cms/cmssSiteTplForm";
	}

	@RequiresPermissions("cms:cmssSiteTpl:edit")
	@RequestMapping(value = "save")
	public String save(CmssSiteTpl entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存站点模板成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmssSiteTpl/?repage";
	}

	@RequiresPermissions("cms:cmssSiteTpl:edit")
	@RequestMapping(value = "delete")
	public String delete(CmssSiteTpl entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除站点模板成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmssSiteTpl/?repage";
	}

}