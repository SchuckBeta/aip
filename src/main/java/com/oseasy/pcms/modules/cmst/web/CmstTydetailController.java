package com.oseasy.pcms.modules.cmst.web;

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
import com.oseasy.pcms.modules.cmst.entity.CmstTydetail;
import com.oseasy.pcms.modules.cmst.service.CmstTydetailService;

/**
 * 模板类型明细Controller.
 * @author chenh
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmstTydetail")
public class CmstTydetailController extends BaseController {

	@Autowired
	private CmstTydetailService entityService;

	@ModelAttribute
	public CmstTydetail get(@RequestParam(required=false) String id) {
		CmstTydetail entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmstTydetail();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmstTydetail:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmstTydetail entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<CmstTydetail> page = entityService.findPage(new Page<CmstTydetail>(request, response), entity);
		model.addAttribute(Page.PAGE, page);
		return "modules/cms/cmstTydetailList";
	}

	@RequiresPermissions("cms:cmstTydetail:view")
	@RequestMapping(value = "form")
	public String form(CmstTydetail entity, Model model) {
		model.addAttribute("cmstTydetail", entity);
		return "modules/cms/cmstTydetailForm";
	}

	@RequiresPermissions("cms:cmstTydetail:edit")
	@RequestMapping(value = "save")
	public String save(CmstTydetail entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存模板类型明细成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmstTydetail/?repage";
	}

	@RequiresPermissions("cms:cmstTydetail:edit")
	@RequestMapping(value = "delete")
	public String delete(CmstTydetail entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除模板类型明细成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmstTydetail/?repage";
	}

}