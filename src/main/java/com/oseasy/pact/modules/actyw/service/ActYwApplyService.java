package com.oseasy.pact.modules.actyw.service;


import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.activiti.engine.IdentityService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.runtime.ProcessInstance;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.initiate.common.config.SysIds;
import com.oseasy.initiate.modules.attachment.entity.SysAttachment;
import com.oseasy.initiate.modules.attachment.service.SysAttachmentService;
import com.oseasy.initiate.modules.promodel.entity.ActYwAuditInfo;
import com.oseasy.initiate.modules.promodel.service.ActYwAuditInfoService;
import com.oseasy.initiate.modules.proproject.entity.ProProject;
import com.oseasy.initiate.modules.sys.service.SystemService;
import com.oseasy.pcore.modules.sys.service.UserService;
import com.oseasy.initiate.modules.sys.tool.SysNoType;
import com.oseasy.initiate.modules.sys.tool.SysNodeTool;
import com.oseasy.initiate.modules.sys.utils.UserUtils;
import com.oseasy.initiate.modules.task.entity.TaskScheduleJob;
import com.oseasy.initiate.modules.task.service.TaskScheduleJobService;
import com.oseasy.pact.modules.act.dao.ActDao;
import com.oseasy.pact.modules.act.entity.Act;
import com.oseasy.pact.modules.act.service.ActTaskService;
import com.oseasy.pact.modules.actyw.dao.ActYwApplyDao;
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pact.modules.actyw.entity.ActYwApply;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.pact.modules.actyw.exception.ApplyException;
import com.oseasy.pact.modules.actyw.exception.ProTimeException;
import com.oseasy.pact.modules.actyw.tool.process.ActYwTool;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowType;
import com.oseasy.pact.modules.actyw.vo.ActYwApplyVo;
import com.oseasy.pcore.common.config.ApiTstatus;
import com.oseasy.pcore.common.persistence.AttachMentEntity;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.pcore.modules.sys.entity.Role;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 流程申请Service.
 *
 * @author zy
 * @version 2017-12-05
 */
@Service
@Transactional(readOnly = true)
public class ActYwApplyService extends CrudService<ActYwApplyDao, ActYwApply> {
	@Autowired
	ActTaskService actTaskService;
	@Autowired
	ActYwService actYwService;
	@Autowired
	SystemService systemService;
	@Autowired
	UserService userService;
	@Autowired
	TaskService taskService;
	@Autowired
	ActYwAuditInfoService actYwAuditInfoService;
	@Autowired
	private RuntimeService runtimeService;
	@Autowired
	IdentityService identityService;
	@Autowired
	ActDao actDao;
	@Autowired
	private SysAttachmentService sysAttachmentService;
	@Autowired
	TaskScheduleJobService taskScheduleJobService;

	public ActYwApply get(String id) {
		return super.get(id);
	}

	public List<ActYwApply> findList(ActYwApply actYwApply) {
		return super.findList(actYwApply);
	}

	public Page<ActYwApply> findPage(Page<ActYwApply> page, ActYwApply actYwApply) {
		return super.findPage(page, actYwApply);
	}

	@Transactional(readOnly = false)
	public void save(ActYwApply actYwApply) {
		super.save(actYwApply);
	}


	@Transactional(readOnly = false)
	public void updateProcInsId(ActYwApplyVo actYwApply) {
		dao.updateProcInsId(actYwApply);
	}


	@Transactional(readOnly = false)
	public void saveApply(ActYwApply actYwApply) {
		if (actYwApply.getIsNewRecord()) {
			if ((actYwApply.getActYw() == null) || StringUtil.isEmpty(actYwApply.getActYw().getId())) {
				throw new RuntimeException("申报信息不完整");
			}
			if (StringUtil.isEmpty(actYwApply.getType())) {
				throw new RuntimeException("申报业务类型未指定");
			}
			if (StringUtil.isEmpty(actYwApply.getRelId())) {
				throw new RuntimeException("申报业务编号未指定");
			}
			if ((actYwApply.getApplyUser() == null) || StringUtil.isEmpty(actYwApply.getApplyUser().getId())) {
				actYwApply.setApplyUser(UserUtils.getUser());
			}
			if (StringUtil.isEmpty(actYwApply.getNo())) {
				actYwApply.setNo(SysNodeTool.genByKeyss(SysNoType.NO_YW_APPLY));
			}
			actYwApply.setProcInsId(null);
		}
		save(actYwApply);
	}


	@Transactional(readOnly = false)
	public void saveApplyAndSubmit(ActYwApply actYwApply) {
		if (actYwApply.getIsNewRecord()) {
	    this.saveApply(actYwApply);
			ApiTstatus<?> ApiStatus = submit(new ActYwApplyVo(actYwApply.getId(), actYwApply.getActYw(), actYwApply.getApplyUser()));
			if (!ApiStatus.getStatus()) {
				throw new ApplyException(ApiStatus.getMsg(), null);
			}
		}else{
	    this.saveApply(actYwApply);
		}
	}

	@Transactional(readOnly = false)
	public void delete(ActYwApply actYwApply) {
		super.delete(actYwApply);
	}

	@Transactional(readOnly = false)
	public ApiTstatus<?> submit(ActYwApplyVo actYwApply) throws ProTimeException{
    /**********************************************************************
	   * 处理申报参数是否合法.
     * 1、申报ID不能为空.
     * 2、申报人ID不能为空.
     * 3、申报流程ID不能为空.
	   */
	  if ((actYwApply == null) || StringUtil.isEmpty(actYwApply.getId())) {
      return new ApiTstatus(false, "申报ID不能为空");
    }

    if ((actYwApply.getApplyUser() == null) || StringUtil.isEmpty(actYwApply.getApplyUser().getId())) {
      return new ApiTstatus(false, "申报人ID不能为空");
    }

    if ((actYwApply.getActYw() == null) || StringUtil.isEmpty(actYwApply.getActYw().getId())) {
      return new ApiTstatus(false, "流程ID不能为空");
    }

		ActYw actYw = actYwService.get(actYwApply.getActYw().getId());

		/**********************************************************************
     * 处理申报流程配置是否合法.
     * 1、流程周期.
     * 2、申报有效期.
     * 3、节点有效期.
     */
	  if (actYw != null && actYw.getProProject() != null) {
      /**
       * 判断周期.
       */
	    if (checkValidDate(actYw.getProProject().getStartDate(), actYw.getProProject().getEndDate())) {
	      return new ApiTstatus(false, "提交失败，不在有效时间内");
	    }

	    /**
	     * 判断申报时间.
	     */
	    //TODO 申报时间
	    /*if (actYw.getProProject().getNodeState()) {
	      if (checkValidDate(actYw.getProProject().getNodeStartDate(), actYw.getProProject().getNodeEndDate())) {
  	      return new ActYwApiStatus(false, "提交失败，不在申报有效时间内");
  	    }
	    }*/
		}else{
		  return new ApiTstatus(false, "项目流程配置信息不能为空");
		}

    /**********************************************************************
     * 处理申报流程角色和业务.
     */
		List<String> roles = new ArrayList<String>();
		//启动工作流
		if (actYw != null) {
			ProProject proProject = actYw.getProProject();
			String nodeRoleId = actTaskService.getProcessStartRoleName(ActYw.getPkey(actYw.getGroup(), actYw.getProProject()));  //从工作流中查询 下一步的角色集合
			String roleId = nodeRoleId.substring(ActYwTool.FLOW_ROLE_ID_PREFIX.length());
			Role role = systemService.getNamebyId(roleId);
			if (role != null) {
				//启动节点
				String roleName = role.getName();
//				if (roleName.contains(SysIds.ISCOLLEGE.getRemark()) || roleName.contains(SysIds.ISMS.getRemark())) {
//					roles = userService.getRolesByName(role.getEnname(), actYwApply.getApplyUser().getId());
//				} else {
//					roles = userService.getRolesByName(role.getEnname());
//				}
				if (roles.size() > 0) {
					Map<String, Object> vars = new HashMap<String, Object>();
					vars.put("id", actYwApply.getId());
					vars.put(nodeRoleId + "s", roles);
					String key = ActYw.getPkey(actYw.getGroup(), actYw.getProProject());
					String userId = UserUtils.getUser().getId();
					identityService.setAuthenticatedUserId(userId);
					ProcessInstance procIns = runtimeService.startProcessInstanceByKey(key, "act_yw_apply:" + actYwApply.getId(), vars);
					//流程id返写业务表
					if (procIns != null) {
						Act act = new Act();
						act.setBusinessTable("pro_model");// 业务表名
						act.setBusinessId(actYwApply.getId());    // 业务表ID
						act.setProcInsId(procIns.getId());
						actDao.updateProcInsIdByBusinessId(act);
						actYwApply.setProcInsId(act.getProcInsId());
						updateProcInsId(actYwApply);
						return new ApiTstatus(true, "恭喜您，申报成功！");
					} else {
						return new ApiTstatus(false, "流程配置故障（审核流程未启动），请联系管理员");
					}
				}
			}
			return new ApiTstatus(false, "流程配置故障（流程角色未配置），请联系管理员");
		}
		return new ApiTstatus(false, "流程配置故障（审核流程不存在），请联系管理员");
	}


	@Transactional(readOnly = false)
	public ApiTstatus audit(ActYwApplyVo actYwApply) {
		Map<String, Object> vars = new HashMap<String, Object>();
		if ((actYwApply.getActYw() == null) || StringUtil.isEmpty(actYwApply.getActYw().getId())) {
		  	return new ApiTstatus(false, "流程ID不能为空");
		}

		if ((actYwApply.getApplyUser() == null) || StringUtil.isEmpty(actYwApply.getApplyUser().getId())) {
		  	return new ApiTstatus(false, "申报人ID不能为空");
		}

		if (StringUtil.isEmpty(actYwApply.getProcInsId())) {
		  	return new ApiTstatus(false, "流程实例ID不能为空");
		}
		if (StringUtil.isEmpty(actYwApply.getGrade())) {
			return new ApiTstatus(false, "审核结果不能为空");
		}
		ActYw actYw = actYwService.get(actYwApply.getActYw().getId());

		if (actYw != null) {
	  	String taskId = actTaskService.getTaskidByProcInsId(actYwApply.getProcInsId());
	  	if (StringUtil.isEmpty(taskId)) {
		  	return new ApiTstatus(false, "审核节点不能为空");
			}
			String key = ActYw.getPkey(actYw.getGroup(), actYw.getProProject());
			String taskDef = actTaskService.getTask(taskId).getTaskDefinitionKey();
			String nextGnodeRoleId = actTaskService.getProcessNextRoleName(taskDef, key);

			if (StringUtil.isNotEmpty(nextGnodeRoleId)) {
				String nextRoleId = nextGnodeRoleId.substring(ActYwTool.FLOW_ROLE_ID_PREFIX.length());
				Role role = systemService.getNamebyId(nextRoleId);
				//启动节点
				String roleName = role.getName();
				List<String> roles = new ArrayList<String>();
				//判断角色是否含有学院级别信息
//				if (roleName.contains(SysIds.ISCOLLEGE.getRemark()) || roleName.contains(SysIds.ISMS.getRemark())) {
//					roles = userService.getRolesByName(role.getEnname(), actYwApply.getApplyUser().getId());
//				} else {
//					roles = userService.getRolesByName(role.getEnname());
//				}
//				if (StringUtil.checkEmpty(roles)) {
//					return new ApiTstatus(false, "流程配置故障（流程角色未配置），请联系管理员");
//				}
//				//后台学生角色id
//				if (nextRoleId.equals(SysIds.SYS_ROLE_USER.getId())) {
//					roles.clear();
//					roles.add(userService.findUserById(actYwApply.getApplyUser().getId()).getName());
//				}
				vars.put(nextGnodeRoleId + "s", roles);
			} else {
				//流程结束

			}

			//判断审核结果
			ActYwAuditInfo actYwAuditInfo = new ActYwAuditInfo();
			ActYwGnode actYwGnode = actTaskService.getNodeByProInsId(actYwApply.getProcInsId());
			actYwAuditInfo.setPromodelId(actYwApply.getId());
			actYwAuditInfo.setGnodeId(actYwGnode.getId());
			if (actYwApply.getGrade() != null) {
				actYwAuditInfo.setGrade(actYwApply.getGrade());
			}
			actYwAuditInfo.setAuditName(actYwGnode.getName());
			actYwAuditInfoService.save(actYwAuditInfo);

			if ((ActYwApplyVo.GRADE_PASS).equals(actYwApply.getGrade())) {
				taskService.complete(taskId, vars);
			}
		}else{
			return new ApiTstatus(false, "流程配置故障");
		}
		return new ApiTstatus(true, "流程审核成功");
	}

	//检查当前时间是否在时间范围内 true 不在有效期内
	private boolean checkValidDate(Date s, Date e) {
		if (s == null || e == null) {
		  throw new ProTimeException();
		}
		if (s.after(new Date())) {
			return true;
		}
		if (e.before(new Date())) {
			return true;
		}
		return false;
	}

	//判断是否需要重新保存附件,true 需要保存
	private boolean checkFile(String pid, AttachMentEntity a) {
		SysAttachment s = new SysAttachment();
		s.setUid(pid);
		List<SysAttachment> list = sysAttachmentService.getFiles(s);
		if (list == null || list.size() == 0 || list.size() > 1) {
			return true;
		} else {
			if (a != null && a.getFielFtpUrl() != null && a.getFielFtpUrl().size() == 1 && a.getFielFtpUrl().get(0).equals(list.get(0).getUrl())) {
				return false;
			} else {
				return true;
			}
		}

	}
}