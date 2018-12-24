package com.oseasy.initiate.modules.sys.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.junit.runner.Request;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oseasy.initiate.modules.sys.entity.SysNumRule;
import com.oseasy.initiate.modules.sys.service.SysNumRuleService;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 编号规则Controller
 * @author zdk
 * @version 2017-04-01
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysNumRule")
public class SysNumRuleController extends BaseController {

	@Autowired
	private SysNumRuleService sysNumRuleService;

	@ModelAttribute
	public SysNumRule get(@RequestParam(required=false) String id) {
		SysNumRule entity = null;
		if (StringUtil.isNotBlank(id)) {
			entity = sysNumRuleService.get(id);
		}
		if (entity == null) {
			entity = new SysNumRule();
		}
		return entity;
	}

	@RequiresPermissions("sys:sysNumRule:view")
	@RequestMapping(value = {"list", ""})
	public String list(SysNumRule sysNumRule, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysNumRule> page = sysNumRuleService.findPage(new Page<SysNumRule>(request, response), sysNumRule);
		model.addAttribute("page", page);
		return "modules/sys/sysNumRuleList";
	}

	@RequiresPermissions("sys:sysNumRule:view")
	@RequestMapping(value = "form")
	public String form(SysNumRule sysNumRule, Model model,HttpServletRequest request) {
		if (sysNumRule.getDateFormat()!=null && sysNumRule.getTimieFormat()!=null) {
			String year = "";
			if (sysNumRule.getDateFormat().indexOf("yyyy")>-1) {
				year="on";
			}
			//String month = sysNumRule.getDateFormat().substring(4, 6);
			String month = "";
			if (sysNumRule.getDateFormat().indexOf("MM")>-1) {
				month="on";
			}
			//String day = sysNumRule.getDateFormat().substring(6);
			String day = "";
			if (sysNumRule.getDateFormat().indexOf("dd")>-1) {
				day="on";
			}
			//String hour = sysNumRule.getTimieFormat().substring(0, 2);
			String hour = "";
			if (sysNumRule.getTimieFormat().indexOf("HH")>-1) {
				hour="on";
			}
			//String minute = sysNumRule.getTimieFormat().substring(2, 4);
			String minute = "";
			if (sysNumRule.getTimieFormat().indexOf("mm")>-1) {
				minute="on";
			}
			String second = "";
			if (sysNumRule.getTimieFormat().indexOf("ss")>-1) {
				second="on";
			}
			sysNumRule.setYear(year);
			sysNumRule.setMonth(month);
			sysNumRule.setDay(day);
			sysNumRule.setHour(hour);
			sysNumRule.setMinute(minute);
			sysNumRule.setSecond(second);
		}
		String type1 = request.getParameter("type1");
		model.addAttribute("sysNumRule", sysNumRule);
		model.addAttribute("type1",type1);
		return "modules/sys/sysNumRuleForm";
	}

	@RequiresPermissions("sys:sysNumRule:edit")
	@RequestMapping(value = "save")
	public String save(SysNumRule sysNumRule, Model model,HttpServletRequest request, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysNumRule)) {
			return form(sysNumRule, model, request);
		}
		String type1 = request.getParameter("type1");
		//由type1判断是否为添加，一个编号类型只能有一个规则
    	if (StringUtil.isNotEmpty(type1)) {
			if (sysNumRuleService.getByType(sysNumRule.getType())!=null) {
				addMessage(redirectAttributes, "编号类别规则已存在");
				return CoreSval.REDIRECT+Global.getAdminPath()+"/sys/sysNumRule/form?type1='1'";
			}
		}

		sysNumRuleService.save(sysNumRule);
	//	addMessage(redirectAttributes, "保存编号规则成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/sys/sysNumRule/?repage";
	}

	@RequiresPermissions("sys:sysNumRule:edit")
	@RequestMapping(value = "delete")
	public String delete(SysNumRule sysNumRule, RedirectAttributes redirectAttributes) {
		sysNumRuleService.delete(sysNumRule);
	//	addMessage(redirectAttributes, "删除编号规则成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/sys/sysNumRule/?repage";
	}

}