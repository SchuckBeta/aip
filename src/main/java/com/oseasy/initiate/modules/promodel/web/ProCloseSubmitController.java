package com.oseasy.initiate.modules.promodel.web;

import com.oseasy.initiate.modules.promodel.entity.ProCloseSubmit;
import com.oseasy.initiate.modules.promodel.service.ProCloseSubmitService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 结项提交信息表Controller.
 * @author zy
 * @version 2017-12-01
 */
@Controller
@RequestMapping(value = "${adminPath}/promodel/proCloseSubmit")
public class ProCloseSubmitController extends BaseController {

	@Autowired
	private ProCloseSubmitService proCloseSubmitService;

	@ModelAttribute
	public ProCloseSubmit get(@RequestParam(required=false) String id) {
		ProCloseSubmit entity = null;
		if (StringUtil.isNotBlank(id)) {
			entity = proCloseSubmitService.get(id);
		}
		if (entity == null) {
			entity = new ProCloseSubmit();
		}
		return entity;
	}

	@RequiresPermissions("promodel:proCloseSubmit:view")
	@RequestMapping(value = {"list", ""})
	public String list(ProCloseSubmit proCloseSubmit, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ProCloseSubmit> page = proCloseSubmitService.findPage(new Page<ProCloseSubmit>(request, response), proCloseSubmit);
		model.addAttribute("page", page);
		return "modules/promodel/proCloseSubmitList";
	}

	@RequiresPermissions("promodel:proCloseSubmit:view")
	@RequestMapping(value = "form")
	public String form(ProCloseSubmit proCloseSubmit, Model model) {
		model.addAttribute("proCloseSubmit", proCloseSubmit);
		return "modules/promodel/proCloseSubmitForm";
	}

	@RequiresPermissions("promodel:proCloseSubmit:edit")
	@RequestMapping(value = "save")
	public String save(ProCloseSubmit proCloseSubmit, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, proCloseSubmit)) {
			return form(proCloseSubmit, model);
		}
		proCloseSubmitService.save(proCloseSubmit);
		addMessage(redirectAttributes, "保存结项提交信息表成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/promodel/proCloseSubmit/?repage";
	}

	@RequiresPermissions("promodel:proCloseSubmit:edit")
	@RequestMapping(value = "delete")
	public String delete(ProCloseSubmit proCloseSubmit, RedirectAttributes redirectAttributes) {
		proCloseSubmitService.delete(proCloseSubmit);
		addMessage(redirectAttributes, "删除结项提交信息表成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/promodel/proCloseSubmit/?repage";
	}

}