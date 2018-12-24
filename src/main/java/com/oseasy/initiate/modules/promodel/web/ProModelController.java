package com.oseasy.initiate.modules.promodel.web;

import static com.oseasy.initiate.modules.attachment.enums.FileStepEnum.S1102;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oseasy.initiate.common.config.SysIdx;
import com.oseasy.initiate.modules.attachment.entity.SysAttachment;
import com.oseasy.initiate.modules.attachment.enums.FileStepEnum;
import com.oseasy.initiate.modules.attachment.enums.FileTypeEnum;
import com.oseasy.initiate.modules.attachment.service.SysAttachmentService;
import com.oseasy.initiate.modules.promodel.entity.ActYwAuditInfo;
import com.oseasy.initiate.modules.promodel.entity.ProModel;
import com.oseasy.initiate.modules.promodel.entity.ProReport;
import com.oseasy.initiate.modules.promodel.service.ProModelService;
import com.oseasy.initiate.modules.promodel.service.ProReportService;
import com.oseasy.initiate.modules.proproject.entity.ProProject;
import com.oseasy.initiate.modules.sys.service.SystemService;
import com.oseasy.pact.modules.act.service.ActTaskService;
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.pact.modules.actyw.service.ActYwGformService;
import com.oseasy.pact.modules.actyw.service.ActYwGnodeService;
import com.oseasy.pact.modules.actyw.service.ActYwService;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowPcategoryType;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowProjectType;
import com.oseasy.pact.modules.actyw.tool.process.vo.FormPageType;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.Dict;
import com.oseasy.pcore.modules.sys.utils.DictUtils;
import com.oseasy.putil.common.utils.StringUtil;

import net.sf.json.JSONObject;

/**
 * proModelController.
 * @author zy
 * @version 2017-07-13
 */
@Controller
@RequestMapping(value = "${adminPath}/promodel/proModel")
public class ProModelController extends BaseController {
    @Autowired
    private ProModelService proModelService;
    @Autowired
    private SysAttachmentService sysAttachmentService;
    @Autowired
    private ActYwService actYwService;
    @Autowired
    private ActYwGnodeService actYwGnodeService;
    @Autowired
    private SystemService systemService;
    @Autowired
    private ActYwGformService actYwGformService;
    @Autowired
    private ProReportService proReportService;
    @Autowired
    private ActTaskService actTaskService;


    @ModelAttribute
    public ProModel get(@RequestParam(required = false) String id) {
        ProModel entity = null;
        if (StringUtil.isNotBlank(id)) {
            entity = proModelService.get(id);
        }
        if (entity == null) {
            entity = new ProModel();
        }
        return entity;
    }

    @RequestMapping(value = "getTaskAssignCountToDo")
    @ResponseBody
    public int getTaskAssignCountToDo(String actYwId) {
        return actTaskService.recordIdsAllAssign(actYwId);
    }

    //大赛信息导出
    @ResponseBody
    @RequestMapping(value = "expGcontestData")
    public JSONObject expGcontestData(ProModel param, HttpServletRequest request, HttpServletResponse response) {
//      proModelService.expGcontestData(param, request, response);
//        return impExpService.expData(request.getParameter(ActYwGroup.JK_ACTYW_ID), new ItReqParam(request), request, response);
        return null;
    }

    @RequiresPermissions("promodel:proModel:view")
    @RequestMapping(value = {"list", ""})
    public String list(ProModel proModel, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<ProModel> page = proModelService.findPage(new Page<ProModel>(request, response), proModel);
        model.addAttribute("page", page);
        return "modules/promodel/proModelList";
    }

    @RequestMapping(value = "view")
    public String view(ProModel proModel, HttpServletRequest request, HttpServletResponse response, Model model) {
        model.addAttribute("proModel", proModel);
        return "modules/promodel/view";
    }

	@RequestMapping(value = "process")
   public String process(ProModel proModel, HttpServletRequest request, HttpServletResponse response, Model model) {
//       	model.addAttribute("proModel", proModel);
//		model.addAttribute("teamStu", projectDeclareService.findTeamStudentByTeamId(proModel.getTeamId(), proModel.getId()));
//		model.addAttribute("teamTea", projectDeclareService.findTeamTeacherByTeamId(proModel.getTeamId(), proModel.getId()));
//		List<ProcessVo>  proVoList=new ArrayList<ProcessVo>();
//		//周报
//		ProReport report = new ProReport();
//		report.setProModelId(proModel.getId());
//		List<ProReport> reports = proReportService.findList(report);
//		for (ProReport proReport : reports) {
//			SysAttachment sa=new SysAttachment();
//			sa.setUid(proModel.getId());
//			sa.setType(FileTypeEnum.S11);
//			sa.setGnodeId(proReport.getGnodeId());//每个节点的附件
//			proReport.setFiles(sysAttachmentService.getFiles(sa));
//			ProcessVo processVo=new ProcessVo();
//			processVo.setName("周报");
//			processVo.setStatus("1");
//			processVo.setFileList(proReport.getFiles());
//			processVo.setTime(proReport.getUpdateDate());
//			proVoList.add(processVo);
//		}
//		//附件
//
//		ActYw actYw=actYwService.get(proModel.getActYwId());
//		ActYwGnode actYwGnodeIndex = new ActYwGnode(new ActYwGroup(actYw.getGroupId()));
//		List<ActYwGnode> sourcelist = actYwGnodeService.findListByMenu(actYwGnodeIndex);
//		ActYwGnode curActYwGnode=new ActYwGnode();
//		Boolean isCur =true;
//		//判断项目是否结束
//		if("1".equals(proModel.getState())){
//
//		}else {
//			curActYwGnode = actTaskService.getNodeByProInsId(proModel.getProcInsId());
//		}
//
//		for(int i=0;i<sourcelist.size();i++){
//			ActYwGnode actYwGnode=sourcelist.get(i);
//			SysAttachment sa=new SysAttachment();
//			sa.setUid(proModel.getId());
//			if(i==0){
//				sa.setFileStep(S1102);
//			}else {
//				sa.setGnodeId(actYwGnode.getId());
//			}
//			List<SysAttachment> fileList =  sysAttachmentService.getFiles(sa);
//			ProcessVo processVo=new ProcessVo();
//			processVo.setName(actYwGnode.getName());
//
//			if(isCur){//已经走过节点
//				processVo.setStatus("1");
//			}else{//未走过节点
//				processVo.setStatus("0");
//			}
//			//判断项目进度
//			if("1".equals(proModel.getState())){
//
//			}else {
//				if (curActYwGnode != null && (actYwGnode.getId().equals(curActYwGnode.getId()) || actYwGnode.getId().equals(curActYwGnode.getParentId()))) {
//					isCur = false;
//				}
//			}
//			processVo.setType("node");
//			if(StringUtil.checkNotEmpty(fileList)){
//				processVo.setFileList(fileList);
//                String dateStr = DateUtil.formatDate(fileList.get(0).getUpdateDate());
//				processVo.setDate(dateStr);
//                processVo.setTime(fileList.get(0).getUpdateDate());
//			}
//			proVoList.add(processVo);
//		}
//		Collections.sort(proVoList, new Comparator<ProcessVo>() {
//			@Override
//			public int compare(ProcessVo o1, ProcessVo o2) {
//				if(o1.getTime()==null){
//					return 1;
//				}
//				if(o2.getTime()==null){
//					return -1;
//				}
//				int i = (int)o1.getTime().getTime() - (int)o2.getTime().getTime();
//				return i;
//			}
//		});
//		List<ProcessVo>  newProVoList=new ArrayList<ProcessVo>();
//		for(int i=0;i<proVoList.size();i++){
//			ProcessVo processVo=proVoList.get(i);
//			if(!("1".equals(processVo.getStatus())&&StringUtil.isEmpty(processVo.getDate()))){
//				newProVoList.add(processVo);
//			}
//		}
//		model.addAttribute("timeLineData", newProVoList);

       return "modules/promodel/backTrack";
   }

    @RequestMapping(value = "auditForm")
    public String audit(ProModel proModel, HttpServletRequest request, HttpServletResponse response, Model model) {
//        String actionPath = request.getParameter("actionPath");
//        String gnodeId = request.getParameter("gnodeId");
//        String taskName = request.getParameter("taskName");
//        if (StringUtils.isNotBlank(taskName)) {
//            try {
//                model.addAttribute("taskName", new String(URLDecoder.decode(taskName, "UTF-8")));
//            } catch (UnsupportedEncodingException e) {
//                logger.error(e.toString());
//            }
//        }
//        String proModelId = request.getParameter("proModelId");
//        proModel = proModelService.get(proModelId);
//		if(proModel==null){
//			return "/error/404";
//		}
//		ActYw actYw = actYwService.get(proModel.getActYwId());
//
//		model.addAttribute("proModel", proModel);
//
//        IWorkFlow workFlow = WorkFlowUtil.getWorkFlowService(actYw);
//        if (org.springframework.util.StringUtils.isEmpty(workFlow)) {
//            proModelService.audit(gnodeId,proModelId, model);
//        } else {
//            workFlow.audit(gnodeId,proModelId, model);
//        }
//
//        if (proModel.getSubTime() != null) {
//            model.addAttribute("sysdate", DateUtil.formatDate(proModel.getSubTime(), "yyyy-MM-dd"));
//        } else {
//            model.addAttribute("sysdate", DateUtil.formatDate(new Date(), "yyyy-MM-dd"));
//        }
//
//        if (proModel.getTeamId() != null) {
//            Team team = teamService.get(proModel.getTeamId());
//            model.addAttribute("team", team);
//            model.addAttribute("teamStu", projectDeclareService.findTeamStudentFromTUH(proModel.getTeamId(), proModel.getId()));
//            model.addAttribute("teamTea", projectDeclareService.findTeamTeacherFromTUH(proModel.getTeamId(), proModel.getId()));
//        }
//
//        this.setExtraInfo(proModel, model);
//
//        if (actYw != null) {
//            model.addAttribute("actYw", actYw);
//            model.addAttribute("proProject", actYw.getProProject());
//        }
//        model.addAttribute("actionPath", actionPath);
//        model.addAttribute("gnodeId", gnodeId);
//        //得到当前任务节点
//       	// ActYwGnode actYwGnode = actYwGnodeService.getByg(gnodeId);
//
//		ActYwGnode actYwNextGnode = actTaskService.getStartNextGnode(ActYw.getPkey(actYw.getGroup(), actYw.getProProject()));
//		if(actYwNextGnode.getId().equals(gnodeId)){
//			model.addAttribute("isFirst", "1");
//		}
//        //actYwGforms=actYwGnode.getGforms();
//        ActYwGform af = new ActYwGform();
//        af.setGnode(new ActYwGnode(gnodeId));
//        List<ActYwGform> actYwGforms = actYwGformService.findList(af);
//        String urlPath = "";
//        if (actYwGforms != null && actYwGforms.size() > 0) {
//            for (ActYwGform actYwGform : actYwGforms) {
//                if (FormStyleType.FST_FORM.getKey().equals(actYwGform.getForm().getStyleType())) {
//                    urlPath = actYwGform.getForm().getPath();
//                    break;
//                }
//            }
//        }
//		proModelService.moneyList(proModel,gnodeId, model);
//
//        //根据gnodeId得到下一个节点是否为网关，是否需要网关状态
//        List<ActYwStatus> actYwStatusList = proModelService.getActYwStatus(gnodeId);
//        if (actYwStatusList != null) {
//            model.addAttribute("actYwStatusList", actYwStatusList);
//        }
//        return urlPath;
        return null;
    }


    @RequestMapping(value = "promodelAudit")
    public String promodelAudit(ProModel proModel, HttpServletRequest request, HttpServletResponse response, Model model) {
//        proModelService.audit(proModel);
//        //model.addAttribute("proModel", proModel);
//        String actionPath = request.getParameter("actionPath");
//        String gnodeId = request.getParameter("gnodeId");
//        return CoreSval.REDIRECT + CmsController.CMS_FORM_ADMIN + "gContest/" + actionPath + "&gnodeId=" + gnodeId;
        return null;
    }


    @RequestMapping(value = "promodelGateAudit")
    public String promodelGateAudit(ProModel proModel, RedirectAttributes redirectAttributes, HttpServletRequest request, HttpServletResponse response, Model model) {
//        //proModelService.audit(proModel);
//        String gnodeId = request.getParameter("gnodeId");
//		ActYw actYw =actYwService.get(proModel.getActYwId());
//        try {
//			String serviceName = FormTheme.getById(actYw.getGroup().getTheme()).getServiceName();
//			IWorkFlow workFlow = WorkFlowUtil.getWorkFlowService(serviceName);
//			workFlow.auditByGateWay(proModel, gnodeId,request);
//			//proModelService.auditWithGateWay(proModel, gnodeId);
//        } catch (GroupErrorException e) {
//            addMessage(redirectAttributes, e.getCode());
//        }
//        ActYwGnode actYwGnode = actYwGnodeService.get(gnodeId);
//        if (GnodeType.GT_PROCESS_TASK.getId().equals(actYwGnode.getType())) {
//            gnodeId = actYwGnode.getParentId();
//        }
//        String actionPath = request.getParameter("actionPath");
//        String actionUrl = actionPath + "?actywId=" + proModel.getActYwId() + "&gnodeId=" + gnodeId;
//        return CoreSval.REDIRECT + Global.getAdminPath() + "/cms/form/gContest/" + actionUrl;
        return null;
    }

    @RequiresPermissions("promodel:proModel:edit")
    @RequestMapping(value = "delete")
    public String delete(ProModel proModel, RedirectAttributes redirectAttributes) {
        proModelService.delete(proModel);
        addMessage(redirectAttributes, "删除proModel成功");
        return CoreSval.REDIRECT + Global.getAdminPath() + "/promodel/proModel/?repage";
    }

    @RequestMapping(value = "viewForm")
    public String viewForm(ProModel proModel, Model model, HttpServletRequest request, HttpServletResponse response) {
//        /**
//         * 查看页面基本信息，所有的查看页面共有,与表单页面类型，和项目类型无关.
//         */
//        ActYw actYw = actYwService.get(proModel.getActYwId());
//		if(actYw==null){
//			return "/error/404";
//		}
//        ProProject proProject = actYw.getProProject();
//        IWorkFlow workFlow = WorkFlowUtil.getWorkFlowService(actYw);
//        if (proProject != null) {
//            showFrontMessage(proProject, model);
//        }
//
//		if (StringUtil.isNotEmpty(proModel.getDeclareId())) {
//			model.addAttribute("sse", systemService.getUser(proModel.getDeclareId()));
//		} else {
//			logger.warn("申报人不存在！");
//		}
//		this.setExtraInfo(proModel, model);
//		model.addAttribute("secondName", "查看");
//		model.addAttribute("actYw", actYw);
//		model.addAttribute("taskName", "查看");
//		model.addAttribute("proModel", proModel);
//		model.addAttribute("groupId", actYw.getGroupId());
//		model.addAttribute("projectName", actYw.getProProject().getProjectName());
//		model.addAttribute("team", teamService.get(proModel.getTeamId()));
////		model.addAttribute("teamStu", projectDeclareService.findTeamStudentByTeamId(proModel.getTeamId(), proModel.getId()));
////		model.addAttribute("teamTea", projectDeclareService.findTeamTeacherByTeamId(proModel.getTeamId(), proModel.getId()));
//		model.addAttribute("teamStu", projectDeclareService.findTeamStudentFromTUH(proModel.getTeamId(), proModel.getId()));
//		model.addAttribute("teamTea", projectDeclareService.findTeamTeacherFromTUH(proModel.getTeamId(), proModel.getId()));
//
//		/**
//		 * 后台查看页面特殊需求参数及页面跳转.
//		 */
//		if (org.springframework.util.StringUtils.isEmpty(workFlow)) {
//			return proModelService.viewForm(FormPageType.FPT_VIEWA, model, request, response, proModel, actYw);
//		}
//		return workFlow.viewForm(FormPageType.FPT_VIEWA, model, request, response, proModel, actYw);
        return null;
	}

    @RequestMapping(value = "projectEdit")
    public String projectEdit(ProModel proModel, Model model, HttpServletRequest request, HttpServletResponse response) {
//        ActYw actYw = actYwService.get(proModel.getActYwId());
//        ProProject proProject = actYw.getProProject();
//        if (proProject != null) {
//            showFrontMessage(proProject, model);
//        }
//
//        if (StringUtil.isNotEmpty(proModel.getDeclareId())) {
//            model.addAttribute("sse", systemService.getUser(proModel.getDeclareId()));
//        } else {
//            logger.warn("申报人不存在！");
//        }
//        this.setExtraInfo(proModel, model);
//		model.addAttribute("secondName", "变更");
//        model.addAttribute("actYw", actYw);
//        model.addAttribute("taskName", request.getParameter("taskName"));
//        model.addAttribute("proModel", proModel);
//        model.addAttribute("groupId", actYw.getGroupId());
//        model.addAttribute("projectName", actYw.getProProject().getProjectName());
//        model.addAttribute("team", teamService.get(proModel.getTeamId()));
//        model.addAttribute("teamStu", projectDeclareService.findTeamStudentByTeamId(proModel.getTeamId(), proModel.getId()));
//        model.addAttribute("teamTea", projectDeclareService.findTeamTeacherByTeamId(proModel.getTeamId(), proModel.getId()));
//        model.addAttribute("changeGnodes", proModelService.getProModelChangeGnode(proModel));
//
//
//		String key=FormTheme.getById(actYw.getGroup().getTheme()).getKey();
//		String serviceName = FormTheme.getById(actYw.getGroup().getTheme()).getServiceName();
//		IWorkFlow workFlow = WorkFlowUtil.getWorkFlowService(serviceName);
//		workFlow.projectEdit(proModel, request,model);
//
//		if(key!=null){
//			return "modules/promodel/"+key+"projectEdit";
//		}else{
//			return "modules/promodel/projectEdit";
//		}
        //return "modules/promodel/projectEdit";
		return null;
    }
    @RequestMapping(value = "gcontestEdit")
    public String gcontestEdit(ProModel proModel, Model model, HttpServletRequest request, HttpServletResponse response) {
//        ActYw actYw = actYwService.get(proModel.getActYwId());
//		if (actYw == null) {
//			return "/error/404";
//		}
//		ProProject proProject = actYw.getProProject();
//        if (proProject != null) {
//            showFrontMessage(proProject, model);
//        }
//
//        if (StringUtil.isNotEmpty(proModel.getDeclareId())) {
//            model.addAttribute("sse", systemService.getUser(proModel.getDeclareId()));
//        } else {
//            logger.warn("申报人不存在！");
//        }
//        this.setExtraInfo(proModel, model);
//
//        model.addAttribute("actYw", actYw);
//		model.addAttribute("secondName", "变更");
//        model.addAttribute("taskName", request.getParameter("taskName"));
//        model.addAttribute("proModel", proModel);
//        model.addAttribute("groupId", actYw.getGroupId());
//        model.addAttribute("projectName", actYw.getProProject().getProjectName());
//        model.addAttribute("team", teamService.get(proModel.getTeamId()));
//        model.addAttribute("teamStu", projectDeclareService.findTeamStudentByTeamId(proModel.getTeamId(), proModel.getId()));
//        model.addAttribute("teamTea", projectDeclareService.findTeamTeacherByTeamId(proModel.getTeamId(), proModel.getId()));
//        model.addAttribute("changeGnodes", proModelService.getProModelChangeGnode(proModel));
//		String key=FormTheme.getById(actYw.getGroup().getTheme()).getKey();
//		String serviceName = FormTheme.getById(actYw.getGroup().getTheme()).getServiceName();
//		IWorkFlow workFlow = WorkFlowUtil.getWorkFlowService(serviceName);
//		workFlow.gcontestEdit(proModel, request,model);
//
//		if(key!=null){
//			return "modules/promodel/"+key+"gcontestEdit";
//		}else{
//			return "modules/promodel/gcontestEdit";
//		}
		return null;

    }

	/**
	 * 报告 申请材料 logo
	 * @param proModel
	 * @param model
	 */
	public void setExtraInfo(ProModel proModel, Model model) {
		//报告（中期、结项等）
		ProReport report = new ProReport();
		report.setProModelId(proModel.getId());
		List<ProReport> reports = proReportService.findList(report);
		for (ProReport proReport : reports) {
			SysAttachment sa=new SysAttachment();
			sa.setUid(proModel.getId());
			sa.setType(FileTypeEnum.S11);
			sa.setGnodeId(proReport.getGnodeId());//每个节点的附件
			if(proReport.getGnodeId()!=null){
				ActYwGnode actYwGnode=actYwGnodeService.get(proReport.getGnodeId());
				proReport.setGnodeName(actYwGnode.getName());
			}

			proReport.setFiles(sysAttachmentService.getFiles(sa));
		}
		model.addAttribute("reports", reports);

		SysAttachment sa=new SysAttachment();
		sa.setUid(proModel.getId());
		sa.setType(FileTypeEnum.S11);
		List<SysAttachment> fileList =  sysAttachmentService.getFiles(sa);
		if (!fileList.isEmpty()) {
			List<SysAttachment> applyFiles = new ArrayList<>();
			for (SysAttachment sysAttachment : fileList) {
				if(sysAttachment.getFileStep() == null){
					continue;
				}
				if (FileStepEnum.S1101.getValue().equals(sysAttachment.getFileStep().getValue())) {
					model.addAttribute("logo", sysAttachment);//logo
				}else if(S1102.getValue().equals(sysAttachment.getFileStep().getValue())){
					applyFiles.add(sysAttachment);//申报附件
				}
			}
			model.addAttribute("applyFiles", applyFiles);//申报附件
		}
		//审核记录
		List<ActYwAuditInfo> actYwAuditInfos = this.getActYwAuditInfo(proModel.getId());
		if (!actYwAuditInfos.isEmpty()) {
			model.addAttribute("actYwAuditInfos", actYwAuditInfos);
		}
	}

//    /**
//     * 后台查看页面特殊需求参数及页面跳转.
//     */
    private String dealPageViewA(FormPageType fpageType, Model model, HttpServletRequest request, HttpServletResponse response, ProModel proModel, ActYw actYw) {
//        FormTheme formTheme = actYw.getFtheme();
//        if(formTheme != null){
//            FormPage fpage = FormPage.getByKey(formTheme, actYw.getFptype().getKey(), fpageType.getKey());
//            if ((FormTheme.F_MR).equals(formTheme)) {
//                fpage.getParam().init(model, request, response, new Object[]{});
//                fpage.getParam().initSysAttachment(model, request, response, new Object[]{proModel, sysAttachmentService});
//                return FormPage.getAbsUrl(actYw, fpageType, null);
//            }else if ((FormTheme.F_MD).equals(formTheme)&& FlowProjectType.PMT_XM.equals(actYw.getFptype())) {
//                //参数实现已经移动至实现类FppMd
//                fpage.getParam().init(model, request, response, new Object[]{});
//                fpage.getParam().initSysAttachment(model, request, response, new Object[]{proModel, sysAttachmentService, proModelMdService});
//                return FormPage.getAbsUrl(actYw, fpageType, null);
//            }else if ((FormTheme.F_MD).equals(formTheme)  && FlowProjectType.PMT_DASAI.equals(actYw.getFptype())) {
//				//参数实现已经移动至实现类FppMd
//				fpage.getParam().init(model, request, response, new Object[]{});
//				fpage.getParam().initSysAttachment(model, request, response, new Object[]{proModel, sysAttachmentService});
//				return FormPage.getAbsUrl(actYw, fpageType, null);
//			}else if ((FormTheme.F_COM).equals(formTheme)) {
//                //参数实现已经移动至实现类FppCom
//                fpage.getParam().init(model, request, response, new Object[]{});
//                fpage.getParam().initSysAttachment(model, request, response, new Object[]{proModel, sysAttachmentService});
//                return FormPage.getAbsUrl(actYw, fpageType, null);
//            }else{
//                logger.error("当前流程主题未定义！");
//            }
//        }else{
//            logger.error("流程主题不存在！");
//        }
        return SysIdx.SYSIDX_404.getIdxUrl();
    }

	/**
	 * 获取审核记录.
	 *
	 * @param proModelId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "auditInfo/{proModelId}")
	public List<ActYwAuditInfo> getActYwAuditInfo(@PathVariable String proModelId){
		return proModelService.getActYwAuditInfo(proModelId, true);
	}

	public static void  showFrontMessage(ProProject proProject ,Model model) {
		List<Dict> finalStatusMap=new ArrayList<Dict>();
		if (proProject.getFinalStatus()!=null) {
			String finalStatus=proProject.getFinalStatus();
			if (finalStatus!=null) {
				String[] finalStatuss=finalStatus.split(",");
				if (finalStatuss.length>0) {
					for(int i=0;i<finalStatuss.length;i++) {
						Dict dict=new Dict();
						dict.setValue(finalStatuss[i]);
						if (proProject.getProType().contains(FlowProjectType.PMT_DASAI.getKey())) {
							dict.setLabel(DictUtils.getDictLabel(finalStatuss[i],"competition_college_prise",""));
						}else if (proProject.getProType().contains(FlowProjectType.PMT_XM.getKey())) {
							dict.setLabel(DictUtils.getDictLabel(finalStatuss[i],"project_result",""));
						}
						finalStatusMap.add(dict);
					}
				}
				model.addAttribute("finalStatusMap",finalStatusMap);
			}
		}
		//前台项目类型
		List<Dict> proTypeMap=new ArrayList<Dict>();
		if (proProject.getType()!=null) {
			String proType=proProject.getType();
			if (proType!=null) {
				String[] proTypes=proType.split(",");
				if (proTypes.length>0) {
					for(int i=0;i<proTypes.length;i++) {
						Dict dict=new Dict();

						dict.setValue(proTypes[i]);
						if (proProject.getProType().contains(FlowProjectType.PMT_DASAI.getKey())) {
							dict.setLabel(DictUtils.getDictLabel(proTypes[i],"competition_type",""));
						}else if (proProject.getProType().contains(FlowProjectType.PMT_XM.getKey())) {
							dict.setLabel(DictUtils.getDictLabel(proTypes[i],"project_style",""));
						}
						//proCategoryMap.add(map);
						proTypeMap.add(dict);

					}
				}
				model.addAttribute("proTypeMap",proTypeMap);
			}
		}
		//前台项目类别
		/*List<Map<Dict>> proCategoryMap=new ArrayList<Map<String, String>>();*/
		List<Dict> proCategoryMap=new ArrayList<Dict>();
		if (proProject.getProCategory()!=null) {
			String proCategory=proProject.getProCategory();
			if (proCategory!=null) {
				String[] proCategorys=proCategory.split(",");
				if (proCategorys.length>0) {
					for(int i=0;i<proCategorys.length;i++) {
						Map<String, String> map=new HashMap<String, String>();
						Dict dict=new Dict();
						map.put("value",proCategorys[i]);
						dict.setValue(proCategorys[i]);
						if (proProject.getProType().contains(FlowProjectType.PMT_DASAI.getKey())) {
							map.put("label",DictUtils.getDictLabel(proCategorys[i],"competition_net_type",""));
							dict.setLabel(DictUtils.getDictLabel(proCategorys[i],"competition_net_type",""));
						}else if (proProject.getProType().contains(FlowProjectType.PMT_XM.getKey())) {
							map.put("label",DictUtils.getDictLabel(proCategorys[i],FlowPcategoryType.PCT_XM.getKey(),""));
							dict.setLabel(DictUtils.getDictLabel(proCategorys[i],FlowPcategoryType.PCT_XM.getKey(),""));
						}
						//proCategoryMap.add(map);
						proCategoryMap.add(dict);
					}
				}
				model.addAttribute("proCategoryMap",proCategoryMap);
			}
		}
		//前台项目类别
		List<Dict> prolevelMap=new ArrayList<Dict>();
		if (proProject.getLevel()!=null) {
			String proLevel=proProject.getLevel();
			if (proLevel!=null) {
				String[] proLevels=proLevel.split(",");
				if (proLevels.length>0) {
					for(int i=0;i<proLevels.length;i++) {
						Dict dict=new Dict();
						dict.setValue(proLevels[i]);
						dict.setLabel(DictUtils.getDictLabel(proLevels[i],"gcontest_level",""));
						prolevelMap.add(dict);
					}
				}
				model.addAttribute("prolevelMap",prolevelMap);
			}
		}
	}

	@RequestMapping(value = "promodelDelete")
	public String promodelDelete(ProModel proModel, RedirectAttributes redirectAttributes) {
		String actywId=proModel.getActYwId();
		proModelService.promodelDelete(proModel);
		addMessage(redirectAttributes, "删除proModel成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/form/queryMenuList/?actywId="+actywId;
	}

	@RequestMapping(value = "ajaxPromodelDelete")
	@ResponseBody
	public JSONObject ajaxPromodelDelete(String ids,HttpServletRequest request,  RedirectAttributes redirectAttributes) {
		JSONObject  js= new JSONObject();
		String[] idList=ids.split(",");
		try {
			proModelService.promodelDeleteList(idList);
			js.put("ret", "1");
		}catch (Exception e){
			js.put("ret", "0");
		 	js.put("msg", "删除失败,出现了未知的错误，请重试或者联系管理员");
		}
		return js;
	}

    //保存项目变更
    @RequestMapping(value = "saveProjectEdit")
    @RequiresPermissions("promodel:promodel:modify")
    @ResponseBody
    public JSONObject saveProjectEdit(ProModel proModel, HttpServletRequest request) {
		JSONObject  js= new JSONObject();
		try {
//			ActYw actYw = actYwService.get(proModel.getActYwId());
//			String key=FormTheme.getById(actYw.getGroup().getTheme()).getKey();
//			String serviceName = FormTheme.getById(actYw.getGroup().getTheme()).getServiceName();
//			IWorkFlow workFlow = WorkFlowUtil.getWorkFlowService(serviceName);
//			js=workFlow.saveProjectEdit(proModel,request);
            return js;
        } catch (Exception e) {
            logger.error(e.getMessage());

            js.put("ret", "0");
            js.put("msg", "保存失败,出现了未知的错误，请重试或者联系管理员");
            return js;
        }
    }

    //保存大赛变更
    @RequestMapping(value = "saveGcontestEdit")
    @RequiresPermissions("promodel:promodel:modify")
    @ResponseBody
    public JSONObject saveGcontestEdit(ProModel proModel, HttpServletRequest request) {
        try {
            return proModelService.saveGcontestEdit(proModel,request);
        } catch (Exception e) {
            logger.error(e.getMessage());
            JSONObject js = new JSONObject();
            js.put("ret", "0");
            js.put("msg", "保存失败,出现了未知的错误，请重试或者联系管理员");
            return js;
        }
    }

    @RequestMapping(value = "checkNumber")
    @ResponseBody
    public String checkNumber(String num, String id) {
        Integer i = proModelService.getByNumberAndId(num, id);
        if (i == null || i == 0) {
            return "true";
        }
        return "false";
    }


	// ajax 批量修改級別
	//ids 审核promodeid的结合用“，”分隔
	//projectLevel 级别所选的值
	@RequestMapping(value = "ajax/batchAuditLevel")
	@ResponseBody
	public JSONObject batchAuditLevel(String  ids, String finalStatus) {
		JSONObject js=new JSONObject();
		String[] idList=ids.split(",");
		proModelService.batchChangeLevel(idList,finalStatus);
		js.put("ret","1");
		return js;
	}

	// ajax 批量审核
	@RequestMapping(value = "ajax/batchAudit")
	@ResponseBody
	//ids 审核promodeid的结合用“，”分隔
	//grade 审核的结果 页面传值
	//gnodeId 审核的节点
	public JSONObject batchAudit(String  ids, String grade, String gnodeId) {
		JSONObject js=new JSONObject();
		String[] idList=ids.split(",");
		boolean ispass=proModelService.batchAudit(idList,grade,gnodeId);
		if(ispass){
			js.put("ret","1");
		}else{
			js.put("ret","0");
		}

		return js;
	}

	// ajax 批量审核评分
	@RequestMapping(value = "ajax/batchScoreAudit")
	@ResponseBody
	//ids 审核promodeid的结合用“，”分隔
	//score 审核的结果 页面传值
	//gnodeId 审核的节点
	public JSONObject batchScoreAudit(String  ids, String score, String gnodeId) {
		JSONObject js=new JSONObject();
		String[] idList=ids.split(",");
		proModelService.batchScoreAudit(idList,score,gnodeId);
		js.put("ret","1");
		return js;
	}

}