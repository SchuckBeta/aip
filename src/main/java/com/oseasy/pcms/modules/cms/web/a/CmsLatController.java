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
import com.oseasy.pcms.modules.cms.entity.CmsLat;
import com.oseasy.pcms.modules.cms.service.CmsLatService;

/**
 * 布局Controller.
 * @author chenh
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmsLat")
public class CmsLatController extends BaseController {

	@Autowired
	private CmsLatService entityService;

	@ModelAttribute
	public CmsLat get(@RequestParam(required=false) String id) {
		CmsLat entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmsLat();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmsLat:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmsLat entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CmsLat> page = entityService.findPage(new Page<CmsLat>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/cms/cmsLatList";
	}

	@RequiresPermissions("cms:cmsLat:view")
	@RequestMapping(value = "form")
	public String form(CmsLat entity, Model model) {
		model.addAttribute("cmsLat", entity);
		return "modules/cms/cmsLatForm";
	}

	@RequiresPermissions("cms:cmsLat:edit")
	@RequestMapping(value = "save")
	public String save(CmsLat entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存布局成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsLat/?repage";
	}

	@RequiresPermissions("cms:cmsLat:edit")
	@RequestMapping(value = "delete")
	public String delete(CmsLat entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除布局成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsLat/?repage";
	}

}