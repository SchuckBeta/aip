package com.oseasy.pact.modules.actyw.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.oseasy.initiate.modules.promodel.entity.ActYwAuditInfo;
import com.oseasy.initiate.modules.promodel.entity.ProModel;
import com.oseasy.initiate.modules.promodel.service.ActYwAuditInfoService;
import com.oseasy.initiate.modules.promodel.service.ProModelService;
import com.oseasy.initiate.modules.sys.utils.UserUtils;
import com.oseasy.pact.modules.act.service.ActTaskService;
import com.oseasy.pact.modules.actyw.dao.ActYwGassignDao;
import com.oseasy.pact.modules.actyw.entity.ActYwGassign;
import com.oseasy.pact.modules.actyw.tool.process.ActYwTool;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.pcore.common.utils.IdGen;
import com.oseasy.pcore.modules.oa.entity.OaNotify;
import com.oseasy.pcore.modules.oa.service.OaNotifyService;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.putil.common.utils.StringUtil;
import org.activiti.engine.TaskService;
import org.activiti.engine.impl.persistence.entity.TaskEntity;
import org.activiti.engine.task.Task;
import org.activiti.engine.task.TaskQuery;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 业务指派表Service.
 * @author zy
 * @version 2018-04-03
 */
@Service
@Transactional(readOnly = true)
public class ActYwGassignService extends CrudService<ActYwGassignDao, ActYwGassign> {
	@Autowired
	ActTaskService actTaskService;
	@Autowired
	TaskService taskService;
	@Autowired
	ProModelService proModelService;
	@Autowired
	ActYwAuditInfoService actYwAuditInfoService;
	@Autowired
	OaNotifyService oaNotifyService;

	public ActYwGassign get(String id) {
		return super.get(id);
	}

	public List<ActYwGassign> findList(ActYwGassign actYwGassign) {
		return super.findList(actYwGassign);
	}

	public Page<ActYwGassign> findPage(Page<ActYwGassign> page, ActYwGassign actYwGassign) {
		return super.findPage(page, actYwGassign);
	}

	@Transactional(readOnly = false)
	public void save(ActYwGassign actYwGassign) {
		super.save(actYwGassign);
	}

	@Transactional(readOnly = false)
	public void delete(ActYwGassign actYwGassign) {
		super.delete(actYwGassign);
	}

  	@Transactional(readOnly = false)
  	public void deleteWL(ActYwGassign actYwGassign) {
  	  dao.deleteWL(actYwGassign);
  	}

	public Boolean isHasAssign(ActYwGassign actYwGassign) {
		Boolean ishas=false;
		List<ActYwGassign> assignList=dao.getListByActYwGassign(actYwGassign);
		if(StringUtil.checkNotEmpty(assignList)){
			ishas=true;
		}
		return ishas;
	}

	@Transactional(readOnly = false)
	public void deleteByAssign(ActYwGassign actYwGassign){
		dao.deleteByAssign(actYwGassign);
	};

	@Transactional(readOnly = false)
	public boolean saveProModelAssign(String promodelId,ActYwGassign actYwGassign,String userIds) {
		ProModel proModel= proModelService.get(promodelId);
		List<String> userIdList= Arrays.asList(userIds.split(","));
		//判断是否已经被指派过
		actYwGassign.setPromodelId(promodelId);
		Boolean isHasAssign=isHasAssign(actYwGassign);
		//已经被指派过
		if(isHasAssign){
			actYwGassign.setPromodelId(promodelId);
			List<ActYwGassign> assignList=dao.getListByActYwGassign(actYwGassign);
			//查询之前指派的人
			List<String> oldAssignUserList=new ArrayList<String>();
			List<String> newAssignUserList=new ArrayList<String>();
			//旧的指派记录人
			for(ActYwGassign actYwGassignIndex:assignList){
				oldAssignUserList.add(actYwGassignIndex.getRevUserId());
			}
			//新的指派记录人
			for(String userId:userIdList){
				newAssignUserList.add(userId);
			}

			//需要发消息的人
			List<String> otherSendList=new ArrayList<String>();

			for(int j=0;j<oldAssignUserList.size();j++){
				String oldUserId=oldAssignUserList.get(j);
				boolean isHas =false;
				for(String userId:userIdList){
					if(userId.equals(oldUserId)){
						isHas=true;
					}
				}
				//如果旧记录在新记录中不存在 发送指派改变的信息
				if(!isHas){
					otherSendList.add(oldUserId);
				}else{
				//如果旧记录在新记录中存在 不在发送指派信息
					newAssignUserList.remove(oldUserId);
				}
			}
//			if(oldAssignUserList.size()>0){
//				oaNotifyService.sendOaNotifyByTypeAndUser(CoreUtils.getUser(), otherSendList,"指派任务",
//											"管理员将指派给你"+proModel.getpName()+"项目审核任务指派给了其他人", OaNotify.Type_Enum.TYPE20.getValue(), proModel.getId());
//			}
//			if(newAssignUserList.size()>0) {
//				oaNotifyService.sendOaNotifyByTypeAndUser(CoreUtils.getUser(), newAssignUserList, "指派任务",
//						"管理员指派给你" + proModel.getpName() + "项目审核任务", OaNotify.Type_Enum.TYPE20.getValue(), proModel.getId());
//			}
			//删除旧的指派记录
			dao.deleteByAssign(actYwGassign);
		}else{
//			oaNotifyService.sendOaNotifyByTypeAndUser(UserUtils.getUser(), userIdList,"指派任务",
//				"管理员指派给你"+proModel.getpName()+"项目审核任务", OaNotify.Type_Enum.TYPE20.getValue(), proModel.getId());
		}
		List<Task> currentTaskEntityList2 = taskService.createTaskQuery().taskDefinitionKey(ActYwTool.FLOW_ID_PREFIX+actYwGassign.getGnodeId())
				.processInstanceId(proModel.getProcInsId()).list();
		TaskEntity currentTaskEntity2 = (TaskEntity) currentTaskEntityList2.get(0);
		 //流程走下下一个节点
		String toGnodeId="";

		ActYwAuditInfo actYwAuditInfo =new ActYwAuditInfo();
		actYwAuditInfo.setPromodelId(promodelId);
		//判断流程节点最后审核信息
		ActYwAuditInfo lastActYwAuditInfo =actYwAuditInfoService.getLastAuditByPromodel(actYwAuditInfo);
		//判断流程节点是否变化
		String isChangeNode=(String)taskService.getVariable(currentTaskEntity2.getId(),"isChangeNode");
		if(StringUtil.isNotEmpty(isChangeNode) && "1".equals(isChangeNode)){
			List<ActYwAuditInfo> lastActYwAuditInfoList =actYwAuditInfoService.getLastAuditListByPromodel(actYwAuditInfo);
			for(int i=0;i<lastActYwAuditInfoList.size();i++){
				ActYwAuditInfo actYwAuditInfoIn= lastActYwAuditInfoList.get(i);
				//流程节点变化 有没有审核中的数据 如果有 取流程中节点
				if(actYwAuditInfoIn!=null&&actYwAuditInfoIn.getGnodeId().equals(actYwGassign.getGnodeId())){
					if(i+1<lastActYwAuditInfoList.size()){
						 toGnodeId=lastActYwAuditInfoList.get(i+1).getGnodeId();
					}
				}
			}
		}
		//判断流程节点为空 则取最后一次审核的节点
		if(StringUtil.isEmpty(toGnodeId)&&lastActYwAuditInfo!=null){
			toGnodeId= lastActYwAuditInfo.getGnodeId();
		}
		Boolean res=false;
		if(lastActYwAuditInfo !=null){
			//回退上一步节点
			res=actTaskService.rollBackWorkFlow(proModel,currentTaskEntity2.getId(),actYwGassign.getGnodeId(),toGnodeId,userIds);
		}else{
			//开始第一个节点为起始节点
			res=actTaskService.rollBackWorkFlowStart(proModel,currentTaskEntity2.getId(),userIds);
			proModelService.save(proModel);
		}
		return res;
	}

	@Transactional(readOnly = false)
	public void saveAssign(ActYwGassign actYwGassign,String promodelIds,String userIds) {
		String[] promodelList=promodelIds.split(",");
		List<String> promodeIdList= Arrays.asList(promodelList);
		List<String> userIdList= Arrays.asList(userIds.split(","));
		List<String> succPromodeIdList= new ArrayList<String>();
		List<String> failPromodeIdList= new ArrayList<String>();
		if(promodelList.length>0){
			for(int i=0;i<promodeIdList.size();i++){
				String promodelId=promodeIdList.get(i);
				boolean res=saveProModelAssign(promodelId,actYwGassign,userIds);
				if(res){
					logger.info("指派成功项目id："+promodelId);
					succPromodeIdList.add(promodelId);
				}else{
					logger.info("指派失败项目id："+promodelId);
					failPromodeIdList.add(promodelId);
				}
			}
		}
		if(StringUtil.checkNotEmpty(succPromodeIdList)){
			List<ActYwGassign> insertActYwGassignList=new ArrayList<ActYwGassign>();
			for(int i=0;i<succPromodeIdList.size();i++){
				String promodelId=succPromodeIdList.get(i);
				for(int j=0;j<userIdList.size();j++){
					String userId=userIdList.get(j);
					ActYwGassign actYwGassignIndex =new ActYwGassign();
					actYwGassignIndex.setId(IdGen.uuid());
					actYwGassignIndex.setYwId(actYwGassign.getYwId());
					actYwGassignIndex.setPromodelId(promodelId);
					actYwGassignIndex.setRevUserId(userId);
					actYwGassignIndex.setGnodeId(actYwGassign.getGnodeId());
					actYwGassignIndex.setYwId(actYwGassign.getYwId());
					insertActYwGassignList.add(actYwGassignIndex);
				}
			}
			dao.insertPl(insertActYwGassignList);
		}
	}

	public String getToDoNumByUserId(String userId,String gnodeId) {
		TaskQuery todoTaskQuery = taskService.createTaskQuery().active().taskCandidateOrAssigned(userId)
				.taskDefinitionKey(ActYwTool.FLOW_ID_PREFIX+gnodeId).includeProcessVariables().orderByTaskCreateTime().desc();
		String num=String.valueOf(todoTaskQuery.count());
		return num;
	}
}