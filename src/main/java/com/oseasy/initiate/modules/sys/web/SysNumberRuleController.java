package com.oseasy.initiate.modules.sys.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oseasy.initiate.modules.sys.entity.SysNumberRuleDetail;
import com.oseasy.initiate.modules.sys.utils.EnumUtils;
import com.oseasy.initiate.modules.sys.utils.NumRuleUtils;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.pact.modules.actyw.service.ActYwGnodeService;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.Msg;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.putil.common.utils.Tree;

import net.sf.json.JSONObject;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oseasy.initiate.modules.sys.entity.SysNumberRule;
import com.oseasy.initiate.modules.sys.service.SysNumberRuleService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 编号规则管理Controller.
 * @author 李志超
 * @version 2018-05-17
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysNumberRule")
public class SysNumberRuleController extends BaseController {

	@Autowired
	private SysNumberRuleService sysNumberRuleService;

	@Autowired
	private ActYwGnodeService actYwGnodeService;

	@ModelAttribute
	public SysNumberRule get(@RequestParam(required=false) String id) {
		SysNumberRule entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = sysNumberRuleService.get(id);
		}
		if (entity == null){
			entity = new SysNumberRule();
		}
		return entity;
	}


	@RequiresPermissions("sys:sysNumberRule:view")
	@RequestMapping(value = {"list", ""})
	public String list(SysNumberRule sysNumberRule, HttpServletRequest request, HttpServletResponse response, Model model) {
		//Page<SysNumberRule> page = sysNumberRuleService.findPage(new Page<SysNumberRule>(request, response), sysNumberRule);
		List<SysNumberRule> rules = sysNumberRuleService.findList(sysNumberRule);
				//page.getList();
		for(int i=0;i<rules.size();i++){
			List<SysNumberRuleDetail> sysNumberRuleDetaillist=rules.get(i).getSysNumberRuleDetailList();
			for(int j=0;j<sysNumberRuleDetaillist.size();j++){
				SysNumberRuleDetail sysNumberRuleDetail=sysNumberRuleDetaillist.get(j);
				if(EnumUtils.PRO_TYPE.equals(sysNumberRuleDetail.getRuleType())){
					String typeValue=sysNumberRuleDetail.getTypeValue();
					if(StringUtil.isNotEmpty(typeValue)){
						JSONObject jsMap=JSONObject.fromObject(typeValue);
						sysNumberRuleDetail.setJsMap(jsMap);
						sysNumberRuleDetail.setTypeValue("");
					}
				}
			}
		}
		rules.forEach(rule -> {
			rule.setRule(NumRuleUtils.getNumberText(rule.getAppType(), "", "", true));
		});
		//page.setList(rules);
		model.addAttribute("list", rules);
		return "modules/sys/sysNumberRuleList";
	}

	@RequiresPermissions("sys:sysNumberRule:view")
	@RequestMapping(value = "form")
	public String form(SysNumberRule sysNumberRule, Model model) {
		model.addAttribute("sysNumberRule", sysNumberRule);
		return "modules/sys/sysNumberRuleForm";
	}

	/**
	 * 删除方法
	 * @param sysNumberRule
	 * @param redirectAttributes
	 * @return
	 */
//	@RequiresPermissions("sys:sysNumberRule:edit")
	@RequestMapping(value = "delete")
	@ResponseBody
	public Msg delete(@RequestBody SysNumberRule sysNumberRule, RedirectAttributes redirectAttributes) {
		sysNumberRuleService.delete(sysNumberRule);
		return Msg.ok().put("msg", "删除编号规则成功");
	}

	/**
	 * 查询获取应用类型
	 * @return
	 */
	@RequestMapping("/getAppTypeTree")
	@ResponseBody
	public Msg getAppTypeTree() {
		List<Tree> treeList = sysNumberRuleService.getAppTypeTreeList();
		return Msg.ok().put("data", treeList);
	}

	/**
	 * 获取编号类型
	 * @return
	 */
	@RequestMapping("/getRuleTypes")
	@ResponseBody
	public Msg getRuleTypes() {
		List<Map<String, String>> ruleTypes = new ArrayList<>();
		for (EnumUtils.RuleType ruleType : EnumUtils.RuleType.values()) {
			Map<String, String> rule = new HashMap<>();
			rule.put("id", ruleType.getKey());
			rule.put("value", ruleType.getValue());
			ruleTypes.add(rule);
		}
		return Msg.ok().put("data", ruleTypes);
	}

	/**
	 * 保存方法
	 * @param sysNumberRule
	 * @return
	 */
//	@RequiresPermissions("sys:sysNumberRule:edit")
	@RequestMapping(value = "save")
	@ResponseBody
	public Msg save(@RequestBody SysNumberRule sysNumberRule) {
		try {
			sysNumberRuleService.save(sysNumberRule);
			sysNumberRule.setRule(NumRuleUtils.getNumberText(sysNumberRule.getAppType(), "", "", true));
		} catch (Exception e) {
			return Msg.error(e.getMessage());
		}
		return Msg.ok("保存编号规则成功").put("data", sysNumberRule);
	}

	@RequestMapping(value = "getNumberText")
	@ResponseBody
	public Msg getNumberText(String appType) {
		String num = NumRuleUtils.getNumberText(appType);
		return Msg.ok().put("data", num).put("msg", "获取编码成功");
	}

	@RequestMapping(value = "getFinalNumberText")
	@ResponseBody
	public Msg getFinalNumberText(String numberText, String appType, String level) {
		String num = NumRuleUtils.getFinalNumberText(numberText, appType, level);
		return Msg.ok().put("data", num).put("msg", "获取最终编码成功");
	}

	@RequestMapping(value = "checkAppTypeUnique")
	@ResponseBody
	public Msg checkAppTypeUnique(String appType, String id) {
		SysNumberRule sysNumberRule = sysNumberRuleService.getRuleByAppType(appType, id);
		if (!StringUtils.isEmpty(sysNumberRule)) {
			return Msg.error("当前应用已存在，不可添加");
		}
		return Msg.ok().put("msg", "当前应用可添加");
	}

	@RequestMapping(value = "getGnodeIdByActYw")
	@ResponseBody
	public Msg getGnodeIdByActYw(String actywId) {
		List<ActYwGnode> list= actYwGnodeService.getAuditNodes(actywId);
		if(StringUtil.checkNotEmpty(list)){
			return Msg.ok().put("data", list).put("msg", "当前应用可添加");
		}else{
			return Msg.error("当前编号规则项目级别");
		}
	}


}