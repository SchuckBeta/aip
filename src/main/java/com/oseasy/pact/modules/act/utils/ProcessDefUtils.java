package com.oseasy.pact.modules.act.utils;

import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.activiti.engine.ProcessEngine;
import org.activiti.engine.TaskService;
import org.activiti.engine.delegate.Expression;
import org.activiti.engine.impl.RepositoryServiceImpl;
import org.activiti.engine.impl.bpmn.behavior.UserTaskActivityBehavior;
import org.activiti.engine.impl.cfg.ProcessEngineConfigurationImpl;
import org.activiti.engine.impl.el.FixedValue;
import org.activiti.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.impl.task.TaskDefinition;
import org.activiti.engine.task.Task;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.reflect.FieldUtils;
import org.apache.log4j.Logger;

import com.oseasy.initiate.modules.promodel.entity.ProModel;
import com.oseasy.initiate.modules.promodel.service.ActYwAuditInfoService;
import com.oseasy.initiate.modules.promodel.service.ProModelService;
import com.oseasy.initiate.modules.sys.utils.UserUtils;
import com.oseasy.pact.modules.act.service.ActTaskService;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.pact.modules.actyw.entity.ActYwGroup;
import com.oseasy.pact.modules.actyw.service.ActYwGnodeService;
import com.oseasy.pact.modules.actyw.tool.process.ActYwTool;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.utils.SpringContextHolder;

/**
 * 流程定义相关操作的封装
 * @author bluejoe2008@gmail.com
 */
public abstract class ProcessDefUtils {

	public static ActivityImpl getActivity(ProcessEngine processEngine, String processDefId, String activityId) {
		ProcessDefinitionEntity pde = getProcessDefinition(processEngine, processDefId);
		return (ActivityImpl) pde.findActivity(activityId);
	}

	public static ProcessDefinitionEntity getProcessDefinition(ProcessEngine processEngine, String processDefId) {
		return (ProcessDefinitionEntity) ((RepositoryServiceImpl) processEngine.getRepositoryService()).getDeployedProcessDefinition(processDefId);
	}

	public static void grantPermission(ActivityImpl activity, String assigneeExpression, String candidateGroupIdExpressions,
			String candidateUserIdExpressions) throws Exception {
		TaskDefinition taskDefinition = ((UserTaskActivityBehavior) activity.getActivityBehavior()).getTaskDefinition();
		taskDefinition.setAssigneeExpression(assigneeExpression == null ? null : new FixedValue(assigneeExpression));
		FieldUtils.writeField(taskDefinition, "candidateUserIdExpressions", ExpressionUtils.stringToExpressionSet(candidateUserIdExpressions), true);
		FieldUtils
				.writeField(taskDefinition, "candidateGroupIdExpressions", ExpressionUtils.stringToExpressionSet(candidateGroupIdExpressions), true);

		Logger.getLogger(ProcessDefUtils.class).info(
				String.format("granting previledges for [%s, %s, %s] on [%s, %s]", assigneeExpression, candidateGroupIdExpressions,
						candidateUserIdExpressions, activity.getProcessDefinition().getKey(), activity.getProperty("name")));
	}

	/**
	 * 实现常见类型的expression的包装和转换
	 *
	 * @author bluejoe2008@gmail.com
	 *
	 */
	public static class ExpressionUtils {
		public static Expression stringToExpression(ProcessEngineConfigurationImpl conf, String expr) {
			return conf.getExpressionManager().createExpression(expr);
		}

		public static Expression stringToExpression(String expr) {
			return new FixedValue(expr);
		}

		public static Set<Expression> stringToExpressionSet(String exprs) {
			Set<Expression> set = new LinkedHashSet<Expression>();
			for (String expr : exprs.split(";")) {
				set.add(stringToExpression(expr));
			}

			return set;
		}
	}

	private static TaskService taskService = SpringContextHolder.getBean(TaskService.class);
	private static ActTaskService actTaskService = SpringContextHolder.getBean(ActTaskService.class);
	private static ActYwGnodeService actYwGnodeService = SpringContextHolder.getBean(ActYwGnodeService.class);
	private static ProModelService proModelService = SpringContextHolder.getBean(ProModelService.class);
	private static ActYwAuditInfoService actYwAuditInfoService = SpringContextHolder.getBean(ActYwAuditInfoService.class);

	public static Map<String, String> getActByPromodelId(String proModelId){
		Map<String, String> map = new HashMap<>();
		ProModel proModel = proModelService.get(proModelId);
		if(proModel == null || Global.YES.equals(proModel.getState())){
			String endGnodeId = proModel.getEndGnodeId();
			if(StringUtils.isNotBlank(endGnodeId)){
				ActYwGnode endNode = actYwGnodeService.get(endGnodeId);
				if(endNode!=null){
					map.put("taskName", endNode.getName());
				}
			}
			return map;
		}
		List<Task> todoList = //taskService.createTaskQuery().taskCandidateOrAssigned(userId).
			actTaskService.getTaskQueryByAssigneeOrCandidateUser().
					processVariableValueEquals("id", proModelId).active().list();
		if (!todoList.isEmpty()) {
			Task task = todoList.get(0);
			map.put("status", "todo");
			map.put("taskId", task.getId());
			map.put("taskName", task.getName());
			map.put(ActYwGroup.JK_GNODE_ID, task.getTaskDefinitionKey().replace(ActYwTool.FLOW_ID_PREFIX, ""));
		}else{
			todoList = taskService.createTaskQuery().processVariableValueEquals("id", proModelId).active().list();
			if (!todoList.isEmpty()) {
				Task task = todoList.get(0);
				map.put("taskName", task.getName());
				map.put(ActYwGroup.JK_GNODE_ID, task.getTaskDefinitionKey().replace(ActYwTool.FLOW_ID_PREFIX, ""));
			}
		}
		map.put("proModelId",proModelId);
		return map;
	}


	public static ActYwGnode getActYwGnode(String gnodeId){
		return actYwGnodeService.get(gnodeId);
	}


}