package com.oseasy.initiate.modules.promodel.web;

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

import com.oseasy.initiate.modules.promodel.entity.ProModelMdGcHistory;
import com.oseasy.initiate.modules.promodel.service.ProModelMdGcHistoryService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 民大大赛记录表Controller.
 * @author zy
 * @version 2018-06-05
 */
@Controller
@RequestMapping(value = "${adminPath}/promodel/proModelMdGcHistory")
public class ProModelMdGcHistoryController extends BaseController {

	@Autowired
	private ProModelMdGcHistoryService proModelMdGcHistoryService;

	@ModelAttribute
	public ProModelMdGcHistory get(@RequestParam(required=false) String id) {
		ProModelMdGcHistory entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = proModelMdGcHistoryService.get(id);
		}
		if (entity == null){
			entity = new ProModelMdGcHistory();
		}
		return entity;
	}

	@RequiresPermissions("promodel:proModelMdGcHistory:view")
	@RequestMapping(value = {"list", ""})
	public String list(ProModelMdGcHistory proModelMdGcHistory, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ProModelMdGcHistory> page = proModelMdGcHistoryService.findPage(new Page<ProModelMdGcHistory>(request, response), proModelMdGcHistory);
		model.addAttribute("page", page);
		return "modules/promodel/proModelMdGcHistoryList";
	}

	@RequiresPermissions("promodel:proModelMdGcHistory:view")
	@RequestMapping(value = "form")
	public String form(ProModelMdGcHistory proModelMdGcHistory, Model model) {
		model.addAttribute("proModelMdGcHistory", proModelMdGcHistory);
		return "modules/promodel/proModelMdGcHistoryForm";
	}

	@RequiresPermissions("promodel:proModelMdGcHistory:edit")
	@RequestMapping(value = "save")
	public String save(ProModelMdGcHistory proModelMdGcHistory, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, proModelMdGcHistory)){
			return form(proModelMdGcHistory, model);
		}
		proModelMdGcHistoryService.save(proModelMdGcHistory);
		addMessage(redirectAttributes, "保存民大大赛记录表成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/promodel/proModelMdGcHistory/?repage";
	}

	@RequiresPermissions("promodel:proModelMdGcHistory:edit")
	@RequestMapping(value = "delete")
	public String delete(ProModelMdGcHistory proModelMdGcHistory, RedirectAttributes redirectAttributes) {
		proModelMdGcHistoryService.delete(proModelMdGcHistory);
		addMessage(redirectAttributes, "删除民大大赛记录表成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/promodel/proModelMdGcHistory/?repage";
	}

}