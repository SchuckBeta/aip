package com.oseasy.pact.modules.actyw.util;

import java.util.List;

import com.oseasy.initiate.modules.sys.entity.SysNumberRule;
import com.oseasy.initiate.modules.sys.service.SysNumberRuleService;
import com.oseasy.initiate.modules.sys.utils.NumRuleUtils;
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.pact.modules.actyw.entity.ActYwGroup;
import com.oseasy.pact.modules.actyw.service.ActYwGnodeService;
import com.oseasy.pact.modules.actyw.service.ActYwService;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowType;
import com.oseasy.pcore.common.utils.SpringContextHolder;
import com.oseasy.putil.common.utils.StringUtil;

public class ActYwUtils {
	private static ActYwService actYwService = SpringContextHolder.getBean(ActYwService.class);
	private static ActYwGnodeService actYwGnodeService = SpringContextHolder.getBean(ActYwGnodeService.class);
	private static SysNumberRuleService sysNumberRuleService = SpringContextHolder.getBean(SysNumberRuleService.class);

	public static List<ActYw> getActListData(String ftype) {
	    return actYwService.findListByDeploy(ftype);
	}
	public static String getNumberRule(String key) {
		SysNumberRule sysNumberRule=sysNumberRuleService.getRuleByAppType(key,"");
		String rule="";
		if(sysNumberRule!=null){
			rule=NumRuleUtils.getNumberText(key, "","", true);
			//rule=StringUtil.abbr(rule,8);
		}
		return rule;
	}
	public static String isNumberRule(String key) {
		SysNumberRule sysNumberRule=sysNumberRuleService.getRuleByAppType(key,"");
		//请设置编号规则
		String rule="请设置编号规则";
		if(sysNumberRule!=null){
			//规则名称
			rule=sysNumberRule.getName();
		}
		return rule;
	}
	public static boolean isFirstMenu(String actywid,String gnodeid){
		if(StringUtil.isEmpty(gnodeid)){
			return false;
		}
		ActYw actYw =actYwService.get(actywid);
		if(actYw==null){
			return false;
		}
		if (actYw.getGroupId() == null) {
			return false;
		}
		ActYwGnode actYwGnode = new ActYwGnode(new ActYwGroup(actYw.getGroupId()));
		List<ActYwGnode> sourcelist = actYwGnodeService.findListBygMenu(actYwGnode);
		if(sourcelist==null||sourcelist.size()==0){
			return false;
		}
		if(gnodeid.equals(sourcelist.get(0).getId())){
			return true;
		}
		return false;
	}
    public static List<ActYwGnode> getAssignNodes(String ywId) {
    	return actYwGnodeService.getAssignNodes(ywId);
    }
	public static String getFlowName(String key) {
	  FlowType flowType = FlowType.getByKey(key);
	  if (flowType == null) {
	    return "";
	  }
	  return flowType.getName();
	}

	public static String getFlowSname(String key) {
	  FlowType flowType = FlowType.getByKey(key);
	  if (flowType == null) {
	    return "";
	  }
	  return flowType.getSname();
	}
}
