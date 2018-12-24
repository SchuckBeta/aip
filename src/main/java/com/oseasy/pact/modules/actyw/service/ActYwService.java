package com.oseasy.pact.modules.actyw.service;

import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.repository.Model;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.oseasy.initiate.modules.promodel.entity.ProModel;
import com.oseasy.initiate.modules.promodel.service.ProModelService;
import com.oseasy.initiate.modules.proproject.entity.ProProject;
import com.oseasy.initiate.modules.proproject.service.ProProjectService;
import com.oseasy.initiate.modules.sys.entity.SysNumberRule;
import com.oseasy.initiate.modules.sys.service.SysNumberRuleService;
import com.oseasy.pact.modules.act.service.ActModelService;
import com.oseasy.pact.modules.act.vo.ActApiStatus;
import com.oseasy.pact.modules.actyw.dao.ActYwDao;
import com.oseasy.pact.modules.actyw.dao.ActYwGroupDao;
import com.oseasy.pact.modules.actyw.dao.ActYwGtimeDao;
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.pact.modules.actyw.entity.ActYwGroup;
import com.oseasy.pact.modules.actyw.entity.ActYwGtime;
import com.oseasy.pact.modules.actyw.entity.ActYwYear;
import com.oseasy.pact.modules.actyw.tool.process.ActYwResult;
import com.oseasy.pact.modules.actyw.tool.process.ActYwTool;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowType;
import com.oseasy.pact.modules.actyw.tool.process.vo.FormTheme;
import com.oseasy.pact.modules.actyw.tool.process.vo.RtModel;
import com.oseasy.pact.modules.actyw.tool.process.vo.RtSvl;
import com.oseasy.pact.modules.actyw.tool.project.ActProParamVo;
import com.oseasy.pact.modules.actyw.tool.project.ActProRunner;
import com.oseasy.pact.modules.actyw.tool.project.ActProStatus;
import com.oseasy.pact.modules.actyw.tool.project.IActProDeal;
import com.oseasy.pact.modules.actyw.tool.project.impl.ActProAppointment;
import com.oseasy.pact.modules.actyw.tool.project.impl.ActProEnter;
import com.oseasy.pact.modules.actyw.tool.project.impl.ActProModel;
import com.oseasy.pact.modules.actyw.tool.project.impl.ActProModelGcontest;
import com.oseasy.pact.modules.actyw.tool.project.impl.ActProScore;
import com.oseasy.pcore.common.config.ApiStatus;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.pcore.common.utils.IdGen;
import com.oseasy.pcore.modules.sys.entity.Menu;
import com.oseasy.pcore.modules.sys.service.CoreService;
import com.oseasy.putil.common.utils.DateUtil;
import com.oseasy.putil.common.utils.StringUtil;

import net.sf.json.JSONObject;

/**
 * 项目流程关联Service.
 *
 * @author chenhao
 * @version 2017-05-23
 */
@Service
@Transactional(readOnly = true)
public class ActYwService extends CrudService<ActYwDao, ActYw> {

	protected static final Logger LOGGER = Logger.getLogger(ActYwService.class);
	@Autowired
	ActYwGroupDao actYwGroupDao;

	@Autowired
	ActYwGtimeDao actYwGtimeDao;
	@Autowired
	private SysNumberRuleService sysNumberRuleService;
	@Autowired
	private ActYwGtimeService actYwGtimeService;
	@Autowired
	private ProProjectService proProjectService;
    @Autowired
    ActYwGnodeService actYwGnodeService;

	@Autowired
    ActYwYearService actYwYearService;

    @Autowired
	private ProModelService proModelService;

	@Autowired
	private CoreService coreService;
//	@Autowired
//	private CategoryService categoryService;

//    /**
//     * 需要处理节点等级和类型.
//     * 根据流程生成json .
//     * @param actYwGroup  流程对象
//     * @param actYwGnodes 流程节点对象
//     * @param rtModel     模型
//     * @return String
//     * @author chenhao
//     */
//    @Transactional(readOnly = false)
//    private String genJsonBySubProcessActYwGnodes(ActYwGroup actYwGroup, List<ActYwGnode> actYwGnodes, RtModel rtModel) {
//        return ActYwResult.dealJsonException(JsonMapper.toJsonString(ActYwResult.init(rtModel, actYwGroup, actYwGnodes)));
//    }



	public ActYw get(String id) {
		return super.get(id);
	}

	public List<ActYw> getByKeyss(String keyss) {
		return dao.getByKeyss(keyss);
	}

	@Transactional(readOnly = false)
	public void updateIsShowAxisPL(List<ActYw> actYws, Boolean isShowAxis) {
		dao.updateIsShowAxisPL(actYws, isShowAxis);
	}

	/**
	 * 验证项目流程标识是否存在.
	 *
	 * @param keyss Key
	 * @param isNew 是否新增
	 * @return Boolean
	 */
	public Boolean validKeyss(String keyss, Boolean isNew) {
		List<ActYw> actYws = getByKeyss(keyss);
		if ((actYws == null) || (actYws.size() <= 0)) {
			return true;
		}

		int size = actYws.size();
		if (!isNew && (size == 1)) {
			return true;
		}
		return false;
	}

	public List<ActYw> findList(ActYw actYw) {
		return super.findList(actYw);
	}

	/**
	 * 根据条件查询已部署的流程.
	 *
	 * @param actYw 项目流程
	 * @return List
	 */
	public List<ActYw> findListByDeploy(ActYw actYw) {
		actYw.setIsDeploy(true);
		return dao.findListByDeploy(actYw);
	}

	/**
	 * 根据流程类型条件查询已部署的流程.
	 *
	 * @return List
	 */
	public List<ActYw> findListByDeploy(FlowType flowType) {
		if (flowType == null) {
			return null;
		}
		ActYw pactYw = new ActYw();
		ActYwGroup pactYwGroup = new ActYwGroup();
		pactYwGroup.setStatus(ActYwGroup.GROUP_DEPLOY_1);
		pactYwGroup.setDelFlag(Global.NO);
		pactYwGroup.setFlowType(flowType.getKey());
		pactYw.setGroup(pactYwGroup);
		pactYw.setDelFlag(Global.NO);
		return findListByDeploy(pactYw);
	}

	/**
	 * 根据流程类型条件查询已部署的流程. 如果类型为空，返回所有已部署流程.
	 *
	 * @param ftype 排除的ID
	 * @return
	 */
	public List<ActYw> findListByDeploy(String ftype) {
		List<ActYw> actYws = Lists.newArrayList();
		if (StringUtil.isNotEmpty(ftype)) {
			FlowType flowType = FlowType.getByKey(ftype);
			if (flowType != null) {
				actYws = findListByDeploy(flowType);
			} else {
				logger.warn("类型参数未定义!");
			}
		} else {
			actYws = findListByDeploy(new ActYw());
		}
		return actYws;
	}

	public Page<ActYw> fistPageByYear(Page<ActYw> page, ActYw actYw) {
		actYw.setPage(page);
		page.setList(dao.findListByYear(actYw));
		return page;
	}

	public Page<ActYw> findPage(Page<ActYw> page, ActYw actYw) {
		return super.findPage(page, actYw);
	}

	@Transactional(readOnly = false)
	public void save(ActYw actYw) {
		if ((actYw.getIsNewRecord())) {
			if (actYw.getIsDeploy() == null) {
				actYw.setIsDeploy(false);
			}
			if (actYw.getIsPreRelease() == null) {
			    actYw.setIsPreRelease(true);
			}

			if (actYw.getIsShowAxis() == null) {
				actYw.setIsShowAxis(false);
			}

			if ((actYw.getKeyType() == null)) {
			    actYw.setKeyType(FormTheme.F_MR.getKey());
			}
		}

		if((actYw.getGroup() != null) && (actYw.getGroup().getTheme() != null)){
            actYw.setKeyType(FormTheme.getById(actYw.getGroup().getTheme()).getKey());
		}
		super.save(actYw);
	}

	/**
	 * 流程部署方法的重写,需要继续维护.
	 *
	 * @param actYw
	 * @return
	 */
	@Transactional(readOnly = false)
	public ActProStatus saveDeployTime2(ActYw actYw) {
		FlowType flowType = null;
		if (actYw.getGroup() != null) {
			if (StringUtil.isNotEmpty(actYw.getGroupId())) {
				actYw.setGroup(actYwGroupDao.get(actYw.getGroupId()));
			}
		}
		if (actYw.getGroup() == null) {
			return null;
		}
		if ((actYw.getGroup() != null) && (actYw.getGroup().getFlowType() != null)) {
			flowType = FlowType.getByKey(actYw.getGroup().getFlowType());
		}
		if (flowType == null) {
			return null;
		}

		ActProRunner<IActProDeal> proRunner = new ActProRunner<IActProDeal>();
		ActProParamVo actProParamVo = new ActProParamVo();
//		if ((flowType).equals(FlowType.FWT_QINGJIA)) {
//			ActProQingJia actProQingJia = new ActProQingJia();
//			proRunner.setActProDeal(actProQingJia);
//			proRunner.setFlowType(flowType);
//			actProParamVo.setActYw(actYw);
//			actProParamVo.setProProject(actYw.getProProject());
//		} else
		if ((flowType).equals(FlowType.FWT_SCORE)) {
			ActProScore actProScore = new ActProScore();
			proRunner.setActProDeal(actProScore);
			proRunner.setFlowType(flowType);
			actProParamVo.setActYw(actYw);
			actProParamVo.setProProject(actYw.getProProject());
		} else if ((flowType).equals(FlowType.FWT_XM)) {
			ActProModel actProModel = new ActProModel();
			proRunner.setActProDeal(actProModel);
			proRunner.setFlowType(flowType);
			actProParamVo.setActYw(actYw);
			actProParamVo.setProProject(actYw.getProProject());
		} else if ((flowType).equals(FlowType.FWT_DASAI)) {
			// ActProProject actProProject=new ActProProject();
			ActProModelGcontest actProModelGcontest = new ActProModelGcontest();
			proRunner.setActProDeal(actProModelGcontest);
			proRunner.setFlowType(flowType);
			actProParamVo.setActYw(actYw);
			actProParamVo.setProProject(actYw.getProProject());
		} else if ((flowType).equals(FlowType.FWT_ENTER)) {
			// ActProProject actProProject=new ActProProject();
			ActProEnter actProEnter = new ActProEnter();
			proRunner.setActProDeal(actProEnter);
			proRunner.setFlowType(flowType);
			actProParamVo.setActYw(actYw);
			actProParamVo.setProProject(actYw.getProProject());
		} else if ((flowType).equals(FlowType.FWT_APPOINTMENT)) {
			ActProAppointment actProAppointment = new ActProAppointment();
			proRunner.setActProDeal(actProAppointment);
			proRunner.setFlowType(flowType);
			actProParamVo.setActYw(actYw);
			actProParamVo.setProProject(actYw.getProProject());
		} else {
			logger.warn("流程类型未定义!!!");
		}
		return proRunner.execute(actProParamVo);
	}

	/**
	 * 流程发布.
	 *
	 * @param actYw
	 * @param repositoryService
	 * @param request
	 * @return
	 */
	@Transactional(readOnly = false)
	public Boolean saveDeployTime(ActYw actYw, RepositoryService repositoryService,HttpServletRequest request) {
		return saveDeployTime(actYw, repositoryService, null, null, request);
	}

	/**
	 * 流程发布和部署.
	 *
	 * @param actYw
	 * @param repositoryService 流程服务
	 * @param actModelService   流程模型服务
	 * @param isUpdateYw        标识是否更新到业务表
	 * @param request
	 * @return
	 */
	@Transactional(readOnly = false)
	public Boolean saveDeployTime(ActYw actYw, RepositoryService repositoryService,ActModelService actModelService, Boolean isUpdateYw, HttpServletRequest request) {
		// 新建
		if (actYw.getIsNewRecord()) {
			if ((actYw.getProProject() == null)
					|| StringUtil.isEmpty(actYw.getProProject().getImgUrl())) {
				return false;
			}
			if (actYw.getIsDeploy() == null) {
				actYw.setIsDeploy(false);
			}
			actYw.setId(IdGen.uuid());
			actYw.setIsNewRecord(true);
			// 新建发布
			proProjectService.save(actYw.getProProject());
			actYw.setRelId(actYw.getProProject().getId());
			save(actYw);
		} else {
			// 修改
			ActYw actOld = get(actYw.getId());
			// 修改发布
			if (actYw.getIsDeploy()) {
				if (actYw.getGroupId() != null) {
					// 修改发布状态永远都要发布流程
					// Menu menu =systemService.getMenuById(actYw.getProProject().getMenuRid());
					// Category category= categoryService.get(actYw.getProProject().getCategoryRid());
					deleteModel(actOld);
					saveDeployTime2(actYw);
					// proProjectService.changeProProjectModel(actYw, request);
					proProjectService.save(actYw.getProProject());
					// deploy(actYw, repositoryService);//只执行发布流程模型，未执行部署
					deploy(actYw, repositoryService, actModelService, isUpdateYw);// 执行流程模型发布并部署
				}
			} else {
				deleteModel(actOld);
				//删除数据
				proModelService.clearPreReleaseData(actYw.getId());
				//hideModelCategory(actOld);
				// 项目无法修改
				proProjectService.save(actYw.getProProject());
				save(actYw);
			}
		}
		if (StringUtil.isNotEmpty(actYw.getShowTime()) && ((actYw.getShowTime()).equals(Global.SHOW))) {
			addGtimeNewYear(actYw.getProProject().getYear(),actYw, request);
			//addGtime2(actYw, request);
		}
		return true;
	}

	@Transactional(readOnly = false)
	public ApiStatus addGtime(ActYw actYw, HttpServletRequest request) {
		if (!(actYw.getShowTime()).equals("1")) {
			return new com.oseasy.pcore.common.config.ApiStatus(true, "不显示时间！");
		}

		if (StringUtil.isEmpty(actYw.getGroupId())) {
			return new ApiStatus(false, "流程ID不能为空！");
		}

		String[] gNodeId = request.getParameterValues("nodeId");
		String[] beginDate = request.getParameterValues("beginDate");
		String[] endDate = request.getParameterValues("endDate");
		if ((beginDate == null) || (beginDate.length <= 0)) {
			return new ApiStatus(false, "开始时间不能为空！");
		}

		if ((endDate == null) || (endDate.length <= 0)) {
			return new ApiStatus(false, "结束时间不能为空！");
		}

		if ((gNodeId == null) || (gNodeId.length <= 0)) {
			return new ApiStatus(false, "节点ID不能为空！");
		}

		ActYwGtime actYwGtimeOld = new ActYwGtime();
		// actYwGtimeOld.setGrounpId(actYw.getGroupId());
		actYwGtimeOld.setProjectId(actYw.getRelId());
		actYwGtimeService.deleteByGroupId(actYwGtimeOld);

		ApiStatus ApiStatus = new ApiStatus();
		for (int i = 0; i < beginDate.length; i++) {
			String status = request.getParameter("status" + i);
			String rate = request.getParameter("rate" + i);
			String rateStatus = request.getParameter("rateStatus" + i);
            String hasTpl = request.getParameter("hasTpl" + i);
            String excelTplPath = request.getParameter("excelTplPath" + i);
            String excelTplClazz = request.getParameter("excelTplClazz" + i);

			ActYwGtime actYwGtime = new ActYwGtime();
			actYwGtime.setGrounpId(actYw.getGroupId());
			actYwGtime.setProjectId(actYw.getRelId());

			if (StringUtil.isEmpty(status)) {
				actYwGtime.setStatus(Global.HIDE);
			} else {
				actYwGtime.setStatus(status);
			}

			if (StringUtil.isEmpty(rate)) {
				actYwGtime.setRate(0.0f);
			} else {
				actYwGtime.setRate(Float.parseFloat(rate));
			}

			if (StringUtil.isEmpty(rateStatus)) {
				actYwGtime.setRateStatus(Global.HIDE);
			} else {
				actYwGtime.setRateStatus(rateStatus);
			}

            if (StringUtil.isEmpty(hasTpl)) {
                actYwGtime.setHasTpl(false);
            } else {
                actYwGtime.setHasTpl((hasTpl).equals(Global.YES)?true:false);
            }

            if (StringUtil.isNotEmpty(excelTplPath)) {
                actYwGtime.setExcelTplPath(excelTplPath);
            }
            if (StringUtil.isNotEmpty(excelTplClazz)) {
                actYwGtime.setExcelTplClazz(excelTplClazz);
            }

			if (StringUtil.isNotEmpty(beginDate[i])) {
				actYwGtime.setBeginDate(DateUtil.parseDate(beginDate[i]));
			}

			if (StringUtil.isNotEmpty(endDate[i])) {
				actYwGtime.setEndDate(DateUtil.parseDate(endDate[i]));
			}

			if (StringUtil.isNotEmpty(gNodeId[i])) {
				actYwGtime.setGnodeId(gNodeId[i]);
			}
			actYwGtimeService.save(actYwGtime);
		}
		return ApiStatus;
	}

	@Transactional(readOnly = false)
	public ApiStatus addGtimeNewYear(String year,ActYw actYw, HttpServletRequest request) {
		if ((actYw.getShowTime()).equals(Global.HIDE)) {
			return new ApiStatus(true, "不显示时间！");
		}

		if (StringUtil.isEmpty(actYw.getGroupId())) {
			return new ApiStatus(false, "流程ID不能为空！");
		}

		String[] gNodeId = request.getParameterValues("nodeId");
		if ((gNodeId == null) || (gNodeId.length <= 0)) {
			return new ApiStatus(false, "节点ID不能为空！");
		}
		//申报时间开始结束
		String nodeStartDate = request.getParameter("nodeStartDate");
		String nodeEndDate = request.getParameter("nodeEndDate");
		//项目时间开始结束
		String startYearDate = request.getParameter("startYearDate");
		String endYearDate = request.getParameter("endYearDate");
		ActYwYear actYwYear=new ActYwYear();
		actYwYear.setYear(year);
		if(nodeStartDate!=null){
			actYwYear.setNodeStartDate(DateUtil.parseDate(nodeStartDate));
		}
		if(nodeEndDate!=null){
			actYwYear.setNodeEndDate(DateUtil.parseDate(nodeEndDate));
		}
		if(startYearDate!=null){
			actYwYear.setStartDate(DateUtil.parseDate(startYearDate));
		}
		if(endYearDate!=null){
			actYwYear.setEndDate(DateUtil.parseDate(endYearDate));
		}
//		actYwYear.setActywId(actYw.getId());
//		boolean isOver=actYwYearService.isOverActywId(actYwYear);
//		if(isOver){
//			return new ApiStatus(false, "申报时间不能重复！");
//		}
		actYwYear.setActywId(actYw.getId());
		ActYwYear overYear=actYwYearService.isOverActYear(actYwYear);
		if(overYear!=null){
			return new ApiStatus(false, "申报时间与"+overYear.getYear()+"年重复！");
		}
		actYwYearService.save(actYwYear);

		ApiStatus ApiStatus = new ApiStatus();
		for (int i = 0; i < gNodeId.length; i++) {
			String beginDate = request.getParameter("beginDate" + i);
			String endDate = request.getParameter("endDate" + i);
			String status = request.getParameter("status" + i);
			String rate = request.getParameter("rate" + i);
			String rateStatus = request.getParameter("rateStatus" + i);
            String hasTpl = request.getParameter("hasTpl" + i);
            String excelTplPath = request.getParameter("excelTplPath" + i);
            String excelTplClazz = request.getParameter("excelTplClazz" + i);

			ActYwGtime actYwGtime = new ActYwGtime();
			actYwGtime.setGrounpId(actYw.getGroupId());
			actYwGtime.setProjectId(actYw.getRelId());
			actYwGtime.setYearId(actYwYear.getId());

			if (StringUtil.isEmpty(status)) {
				actYwGtime.setStatus(Global.HIDE);
			} else {
				actYwGtime.setStatus(status);
			}

			if (StringUtil.isEmpty(rate)) {
				actYwGtime.setRate(0.0f);
			} else {
				actYwGtime.setRate(Float.parseFloat(rate));
			}

			if (StringUtil.isEmpty(rateStatus)) {
				actYwGtime.setRateStatus(Global.HIDE);
			} else {
				actYwGtime.setRateStatus(rateStatus);
			}


            if (StringUtil.isEmpty(hasTpl)) {
                actYwGtime.setHasTpl(false);
            } else {
                actYwGtime.setHasTpl((hasTpl).equals(Global.YES)?true:false);
            }

            if (StringUtil.isNotEmpty(excelTplPath)) {
                actYwGtime.setExcelTplPath(excelTplPath);
            }
            if (StringUtil.isNotEmpty(excelTplClazz)) {
                actYwGtime.setExcelTplClazz(excelTplClazz);
            }

			if (StringUtil.isNotEmpty(beginDate)) {
				actYwGtime.setBeginDate(DateUtil.parseDate(beginDate));
			}

			if (StringUtil.isNotEmpty(endDate)) {
				actYwGtime.setEndDate(DateUtil.parseDate(endDate));
			}

			if (StringUtil.isNotEmpty(gNodeId[i])) {
				actYwGtime.setGnodeId(gNodeId[i]);
			}
			actYwGtimeService.save(actYwGtime);
		}
		return ApiStatus;
	}

	@Transactional(readOnly = false)
	public ApiStatus addGtime2(ActYw actYw, HttpServletRequest request) {
		if ((actYw.getShowTime()).equals(Global.HIDE)) {
			return new ApiStatus(true, "不显示时间！");
		}

		if (StringUtil.isEmpty(actYw.getGroupId())) {
			return new ApiStatus(false, "流程ID不能为空！");
		}

		String[] gNodeId = request.getParameterValues("nodeId");
		if ((gNodeId == null) || (gNodeId.length <= 0)) {
			return new ApiStatus(false, "节点ID不能为空！");
		}

		ActYwGtime actYwGtimeOld = new ActYwGtime();
		actYwGtimeOld.setProjectId(actYw.getRelId());
		actYwGtimeService.deleteByGroupId(actYwGtimeOld);

		ApiStatus ApiStatus = new ApiStatus();
		for (int i = 0; i < gNodeId.length; i++) {
			String beginDate = request.getParameter("beginDate" + i);
			String endDate = request.getParameter("endDate" + i);
			String status = request.getParameter("status" + i);
			String rate = request.getParameter("rate" + i);
			String rateStatus = request.getParameter("rateStatus" + i);
            String hasTpl = request.getParameter("hasTpl" + i);
            String excelTplPath = request.getParameter("excelTplPath" + i);
            String excelTplClazz = request.getParameter("excelTplClazz" + i);

			ActYwGtime actYwGtime = new ActYwGtime();
			actYwGtime.setGrounpId(actYw.getGroupId());
			actYwGtime.setProjectId(actYw.getRelId());

			if (StringUtil.isEmpty(status)) {
				actYwGtime.setStatus(Global.HIDE);
			} else {
				actYwGtime.setStatus(status);
			}

			if (StringUtil.isEmpty(rate)) {
				actYwGtime.setRate(0.0f);
			} else {
				actYwGtime.setRate(Float.parseFloat(rate));
			}

			if (StringUtil.isEmpty(rateStatus)) {
				actYwGtime.setRateStatus(Global.HIDE);
			} else {
				actYwGtime.setRateStatus(rateStatus);
			}

            if (StringUtil.isEmpty(hasTpl)) {
                actYwGtime.setHasTpl(false);
            } else {
                actYwGtime.setHasTpl((hasTpl).equals(Global.YES)?true:false);
            }

            if (StringUtil.isNotEmpty(excelTplPath)) {
                actYwGtime.setExcelTplPath(excelTplPath);
            }
            if (StringUtil.isNotEmpty(excelTplClazz)) {
                actYwGtime.setExcelTplClazz(excelTplClazz);
            }

			if (StringUtil.isNotEmpty(beginDate)) {
				actYwGtime.setBeginDate(DateUtil.parseDate(beginDate));
			}

			if (StringUtil.isNotEmpty(endDate)) {
				actYwGtime.setEndDate(DateUtil.parseDate(endDate));
			}

			if (StringUtil.isNotEmpty(gNodeId[i])) {
				actYwGtime.setGnodeId(gNodeId[i]);
			}
			actYwGtimeService.save(actYwGtime);
		}
		return ApiStatus;
	}


	@Transactional(readOnly = false)
	public ApiStatus addGtimeOld(String year,ActYw actYw, HttpServletRequest request) {
		if ((actYw.getShowTime()).equals(Global.HIDE)) {
			return new ApiStatus(true, "不显示时间！");
		}

		if (StringUtil.isEmpty(actYw.getGroupId())) {
			return new ApiStatus(false, "流程ID不能为空！");
		}

		String[] gNodeId = request.getParameterValues("nodeId");
		if ((gNodeId == null) || (gNodeId.length <= 0)) {
			return new ApiStatus(false, "节点ID不能为空！");
		}


		String yearId=actYwYearService.getProByActywIdAndYear(actYw.getId(),year);
		String nodeStartDate = request.getParameter("nodeStartDate");
		String nodeEndDate = request.getParameter("nodeEndDate");

		//项目时间开始结束
		String startYearDate = request.getParameter("startYearDate");
		String endYearDate = request.getParameter("endYearDate");
		//修改申报时间
		ActYwYear actYwYear=actYwYearService.get(yearId);
		if(nodeStartDate!=null){
			actYwYear.setNodeStartDate(DateUtil.parseDate(nodeStartDate));
		}
		if(nodeEndDate!=null){
			actYwYear.setNodeEndDate(DateUtil.parseDate(nodeEndDate));
		}
		if(startYearDate!=null){
			actYwYear.setStartDate(DateUtil.parseDate(startYearDate));
		}
		if(endYearDate!=null){
			actYwYear.setEndDate(DateUtil.parseDate(endYearDate));
		}

		//boolean isOver=actYwYearService.isOverActywId(actYwYear);
		ActYwYear overYear=actYwYearService.isOverActYear(actYwYear);
		if(overYear!=null){
			return new ApiStatus(false, "申报时间与"+overYear.getYear()+"年重复！");
		}
		actYwYearService.save(actYwYear);
		actYwGtimeService.deleteByYear(actYw.getRelId(),yearId);
		//修改节点时间
		ApiStatus ApiStatus = new ApiStatus();
		for (int i = 0; i < gNodeId.length; i++) {
			String beginDate = request.getParameter("beginDate" + i);
			String endDate = request.getParameter("endDate" + i);
			String status = request.getParameter("status" + i);
			String rate = request.getParameter("rate" + i);
			String rateStatus = request.getParameter("rateStatus" + i);
			String hasTpl = request.getParameter("hasTpl" + i);
			String excelTplPath = request.getParameter("excelTplPath" + i);
			String excelTplClazz = request.getParameter("excelTplClazz" + i);

			ActYwGtime actYwGtime = new ActYwGtime();
			actYwGtime.setGrounpId(actYw.getGroupId());
			actYwGtime.setProjectId(actYw.getRelId());
			actYwGtime.setYearId(yearId);
			if (StringUtil.isEmpty(status)) {
				actYwGtime.setStatus(Global.HIDE);
			} else {
				actYwGtime.setStatus(status);
			}

			if (StringUtil.isEmpty(rate)) {
				actYwGtime.setRate(0.0f);
			} else {
				actYwGtime.setRate(Float.parseFloat(rate));
			}

			if (StringUtil.isEmpty(rateStatus)) {
				actYwGtime.setRateStatus(Global.HIDE);
			} else {
				actYwGtime.setRateStatus(rateStatus);
			}

			if (StringUtil.isEmpty(hasTpl)) {
			    actYwGtime.setHasTpl(false);
			} else {
			    actYwGtime.setHasTpl((hasTpl).equals(Global.YES)?true:false);
			}

			if (StringUtil.isNotEmpty(excelTplPath)) {
			    actYwGtime.setExcelTplPath(excelTplPath);
			}
			if (StringUtil.isNotEmpty(excelTplClazz)) {
			    actYwGtime.setExcelTplClazz(excelTplClazz);
			}

			if (StringUtil.isNotEmpty(beginDate)) {
				actYwGtime.setBeginDate(DateUtil.parseDate(beginDate));
			}

			if (StringUtil.isNotEmpty(endDate)) {
				actYwGtime.setEndDate(DateUtil.parseDate(endDate));
			}

			if (StringUtil.isNotEmpty(gNodeId[i])) {
				actYwGtime.setGnodeId(gNodeId[i]);
			}
			actYwGtimeService.save(actYwGtime);
		}
		return ApiStatus;
	}

	@Transactional(readOnly = false)
	public void delete(ActYw actYw) {
		super.delete(actYw);
	}

	public JSONObject ajaxCheckDelete(ActYw actYw) {
		JSONObject js=new  JSONObject();
		if (StringUtil.isNotEmpty(actYw.getId()) && (actYw.getIsDeploy() != null)) {
			//流程状态
			String res = findStateHaveData(actYw.getId());
			if ("3".equals(res)) {
			  js.put("ret","0");
			  js.put("msg", "流程中含有未完成项目");
			}else if("2".equals(res)){
			  js.put("ret","0");
			  js.put("msg", "流程中含有项目");
			}else{
			  js.put("ret","1");
			  js.put("msg", "删除成功");
			}
		}
     	return js;
	}

	@Transactional(readOnly = false)
	public void deleteAll(ActYw actYw) {
		this.beforeDelete(actYw);
		ProProject proProject = actYw.getProProject();
		Menu menu = coreService.getMenu(proProject.getMenuRid());
		// 删除菜单
		if (menu != null) {
		    coreService.deleteMenu(menu);
		}

		// 删除栏目
//		Category category = categoryService.get(proProject.getCategoryRid());
//		if (category != null) {
//			categoryService.delete(category);
//		}

		// 删除项目
		proProjectService.delete(proProject);
		//删除编号规则
		SysNumberRule sysNumberRule=sysNumberRuleService.getRuleByAppType(actYw.getId(),"");
		if(sysNumberRule!=null){
			sysNumberRuleService.delete(sysNumberRule);
		}
		super.delete(actYw);
	}

	/**
	 * 删除自定义项目约束性校验
	 * 1，有项目数据，不可删除
	 * 2，无项目数据，
	 * @param actYw
	 */
	private void beforeDelete(ActYw actYw){
		ProModel proModel = new ProModel();
		proModel.setActYwId(actYw.getId());
		List<ProModel> list = proModelService.findList(proModel);
		if(!list.isEmpty()){
			throw new RuntimeException("有项目数据，无法删除项目");
		}
	}
	@Transactional(readOnly = false)
	public void deleteProject(ActYw actYw) {
		ProProject proProject = actYw.getProProject();
		// 删除菜单
		if (proProject.getMenuRid() != null) {
			Menu menu = coreService.getMenu(proProject.getMenuRid());
			if (menu != null) {
			    coreService.deleteMenu(menu);
			}
		}
		// 删除栏目
//		if (proProject.getCategoryRid() != null) {
//			Category category = categoryService.get(proProject.getCategoryRid());
//			if (category != null) {
//				categoryService.delete(category);
//			}
//		}
	}

	@Transactional(readOnly = false)
	public void deleteModel(ActYw actYw) {
		deleteProject(actYw);
//		ProProject proProject = actYw.getProProject();
//		// 删除菜单
//		if (proProject.getMenuRid() != null) {
//			Menu menu = systemService.getMenu(proProject.getMenuRid());
//			if (menu != null) {
//				systemService.deleteMenu(menu);
//			}
//		}
//		// 删除栏目
//		if (proProject.getCategoryRid() != null) {
//			Category category = categoryService.get(proProject.getCategoryRid());
//			if (category != null) {
//				categoryService.delete(category);
//			}
//		}
		//查找已经发布同类的项目(删除栏目和菜单)
		ProProject proProject = actYw.getProProject();
		List<ActYw> relActYw=findActYwListByRelIdAndState(proProject.getProType(),proProject.getType());
		if(StringUtil.checkNotEmpty(relActYw)){
			for(int i=0;i<relActYw.size();i++ ){
				ActYw delActYw=relActYw.get(i);
				deleteProject(delActYw);
			}
		}

	}


	@Transactional(readOnly = false)
	public void hideModelCategory(ActYw actYw) {
		ProProject proProject = actYw.getProProject();

		// 删除栏目
//		if (proProject.getCategoryRid() != null) {
//			Category category = categoryService.get(proProject.getCategoryRid());
//			if (category != null) {
//				categoryService.delete(category);
//			}
//		}
	}

	/**
	 * 发布项目流程. 以流程标识和项目标识生成流程模板标识和版本（防止多项目共用一个流程是出现菜单、栏目重合）
	 *
	 * @param actYw 项目流程
	 * @return Boolean
	 * @author chenhao
	 */
	@Transactional(readOnly = false)
	public Boolean deploy(ActYw actYw, RepositoryService repositoryService) {
		return deploy(actYw, repositoryService, null, null);
	}

	/**
	 * 发布并部署项目流程. 以流程标识和项目标识生成流程模板标识和版本（防止多项目共用一个流程是出现菜单、栏目重合）
	 *
	 * @param actYw             项目流程
	 * @param repositoryService 流程服务
	 * @param actModelService   流程模型服务
	 * @param isUpdateYw        标识是否更新到业务表
	 * @return Boolean
	 * @author chenhao
	 */
	@Transactional(readOnly = false)
	public Boolean deploy(ActYw actYw, RepositoryService repositoryService, ActModelService actModelService, Boolean isUpdateYw) {
		try {
			if ((actYw == null) || (!actYw.getIsNewRecord()) && StringUtil.isEmpty(actYw.getId())) {
				return false;
			}

			ActYw actYwNew = get(actYw.getId());
			if (((actYwNew == null) || (StringUtil.isEmpty(actYwNew.getId())))
					&& actYw.getIsNewRecord()) {
				save(actYw);
				actYwNew = get(actYw.getId());
			}

			if (actYwNew == null) {
				return false;
			}

			if ((actYwNew.getGroup() == null) && StringUtil.isNotEmpty(actYwNew.getGroupId())) {
				actYwNew.setGroup(actYwGroupDao.get(actYwNew.getGroupId()));
			}
			actYw.setGroup(actYwNew.getGroup());
			ActYwGroup actYwGroup = actYw.getGroup();
			if (actYwGroup == null) {
				return false;
			}

			ProProject proProject = actYw.getProProject();
			if (proProject == null) {
				return false;
			}

			if (StringUtil.isEmpty(actYwGroup.getKeyss()) || StringUtil.isEmpty(proProject.getProjectMark())) {
				return false;
			}

			String modelKey = ActYw.getPkey(actYw);
			if (modelKey == null) {
				return false;
			}
			RtModel rtModel = new RtModel(FlowType.getByKey(actYwGroup.getFlowType()).getName() + ActYw.KEY_SEPTOR + actYwGroup.getName(), modelKey, actYwGroup.getRemarks(), actYwGroup.getFlowType(), null, null);
			org.activiti.engine.repository.Model modelData = ActYwTool.genModelData(rtModel, repositoryService);
			repositoryService.saveModel(modelData);

			Model repModel = repositoryService.getModel(modelData.getId());
//			try {
//              String json = JsonAliUtils.readJson("stencilset-xm3.json");
//              rtModel.setJsonXml(json);
//          } catch (Exception e) {
//              e.printStackTrace();
//          }

            List<ActYwGnode> actYwGnodes = actYwGnodeService.findListBygGroup(new ActYwGnode(actYwGroup));
			rtModel.setJsonXml(ActYwResult.dealJsonException(JSONObject.fromObject(ActYwResult.init(rtModel, actYwGroup, ActYwTool.initProps(actYwGnodes))).toString()));
			logger.info(rtModel.getJsonXml());
			repositoryService.addModelEditorSource(repModel.getId(), rtModel.getJsonXml().getBytes(RtSvl.RtModelVal.UTF_8));

			/**
			 * 如果部署服务不为空，执行部署！
			 */
			if (actModelService != null) {
				ActApiStatus result = actModelService.deploy(modelData.getId());
				/**
				 * 流程发布，流程ID回填到业务表.
				 */
				if (isUpdateYw!=null && isUpdateYw) {
					actYw.setFlowId(result.getId());
					actYw.setDeploymentId(result.getDeploymentId());
					save(actYw);
				}
			}
			return true;
		} catch (UnsupportedEncodingException e) {
			LOGGER.error("不支持编码格式", e);
			return false;
		}
	}
	public boolean findIsHaveData(ActYw actYw) {
		List<ProModel> list=proModelService.findIsHaveData(actYw.getId());
		if(StringUtil.checkNotEmpty(list)){//查找未完结数据
			List<ProModel> list2=proModelService.findIsOverHaveData(actYw.getId(),"1");
			if(StringUtil.checkNotEmpty(list2)){
				return true;
			}
		}
		return false;
	}

	//1：项目没有数据 2：项目有数据都已经结项 3：项目有数据还未结项
	public String  findStateHaveData(String actYwId) {
		List<ProModel> list=proModelService.findIsHaveData(actYwId);
		if(StringUtil.checkNotEmpty(list)){//查找未完结数据
			List<ProModel> list2=proModelService.findIsOverHaveData(actYwId,"1");
			if(StringUtil.checkNotEmpty(list2)){
				//项目有数据还未结项
				return "3";
			}else{
				//项目有数据都已经结项
				return "2";
			}
		}else{
			//项目没有数据
			return "1";
		}
	}
	//根据流程ID找已发布项目
	public List<ActYw> findActYwListByGroupId(String groupId) {
		return dao.findActYwListByGroupId(groupId);
	}

	//根据项目配置ID找已发布项目
	public List<ActYw> findActYwListByProProject(String proType,String type) {
		return dao.findActYwListByProProject(proType,type);
	}

	//根据项目配置ID找未发布项目
	public List<ActYw> findActYwListByRelIdAndState(String proType,String type) {
		return dao.findActYwListByRelIdAndState(proType,type);
	}

	public JSONObject ajaxCheckDeploy(ActYw actYw) {
		JSONObject js=new  JSONObject();
		if (StringUtil.isNotEmpty(actYw.getId()) && (actYw.getIsDeploy() != null)) {
			if(actYw.getIsDeploy()){
				//List<ActYwGtime> timeList=actYwGtimeService.checkTimeByActYw(actYw.getId());
				int yearIndex=actYwYearService.checkYearTimeByActYw(actYw.getId());
				int timeIndex=actYwGtimeService.checkTimeIndex(actYw.getId());


				ActYwGnode actYwGnode = new ActYwGnode(new ActYwGroup(actYw.getGroupId()));
				List<ActYwGnode> sourcelist = actYwGnodeService.findListByMenu(actYwGnode);
				int yearNum=actYwYearService.checkYearByActYw(actYw.getId());
				if((yearIndex+timeIndex) != (sourcelist.size()+1)*yearNum){
					js.put("ret", "0");
					js.put("msg", "流程时间填写不完整，发布失败");
					return js;
				}
				SysNumberRule sysNumberRule=sysNumberRuleService.getRuleByAppType(actYw.getId(),"");
				if(sysNumberRule==null){
					js.put("ret", 0);
					js.put("msg", "该类型项目没有设置编号规则，发布失败");
					return js;
				}
				String relId=actYw.getRelId();
				ProProject proProject=proProjectService.get(relId);
				//查找已经发布的项目
				List<ActYw> actYwList=findActYwListByProProject(proProject.getProType(),proProject.getType());
				if(StringUtil.checkNotEmpty(actYwList)){
					js.put("ret","0");
					js.put("msg", "同一类型项目只能发布一个，该类型项目已经发布一个，发布失败");
				}else{
				  	js.put("ret","1");
			  	}
			}else {
				if(actYw.getIsPreRelease()!=null && actYw.getIsPreRelease()){
					js.put("ret","1");
				}else {
					//流程状态
					String res = findStateHaveData(actYw.getId());
					if ("3".equals(res)) {
						js.put("ret", "0");
						js.put("msg", "流程中含有未完成项目,取消发布失败");
					} else {
						js.put("ret", "1");
					}
				}
			}
		 }
		 return js;
	}

	public List<ActYw> findAllActYwListByGroupId(String groupId) {
		return dao.findAllActYwListByGroupId(groupId);
	}
}