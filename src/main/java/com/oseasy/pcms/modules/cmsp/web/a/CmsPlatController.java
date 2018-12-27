package com.oseasy.pcms.modules.cmsp.web.a;

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
import com.oseasy.pcms.modules.cmsp.entity.CmsPlat;
import com.oseasy.pcms.modules.cmsp.service.CmsPlatService;

/**
 * 页面布局Controller.
 * @author chenh
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmsPlat")
public class CmsPlatController extends BaseController {

	@Autowired
	private CmsPlatService entityService;

	@ModelAttribute
	public CmsPlat get(@RequestParam(required=false) String id) {
		CmsPlat entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmsPlat();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmsPlat:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmsPlat entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CmsPlat> page = entityService.findPage(new Page<CmsPlat>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/cms/cmsPlatList";
	}

	@RequiresPermissions("cms:cmsPlat:view")
	@RequestMapping(value = "form")
	public String form(CmsPlat entity, Model model) {
		model.addAttribute("cmsPlat", entity);
		return "modules/cms/cmsPlatForm";
	}

	@RequiresPermissions("cms:cmsPlat:edit")
	@RequestMapping(value = "save")
	public String save(CmsPlat entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存页面布局成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsPlat/?repage";
	}

	@RequiresPermissions("cms:cmsPlat:edit")
	@RequestMapping(value = "delete")
	public String delete(CmsPlat entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除页面布局成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsPlat/?repage";
	}

}