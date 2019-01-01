package com.oseasy.initiate.modules.promodel.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
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
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pact.modules.actyw.entity.ActYwGnode;
import com.oseasy.pact.modules.actyw.service.ActYwGnodeService;
import com.oseasy.pact.modules.actyw.service.ActYwService;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowPcategoryType;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowProjectType;
import com.oseasy.pact.modules.actyw.tool.process.vo.FormPageType;
import com.oseasy.pcore.common.config.CoreJkey;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.Dict;
import com.oseasy.pcore.modules.sys.utils.DictUtils;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.putil.common.utils.exception.ExceptionUtil;

import net.sf.json.JSONObject;

/**
 * proModelController.
 *
 * @author zy
 * @version 2017-07-13
 */
@Controller
@RequestMapping(value = "${frontPath}/promodel/proModel")
public class FrontProModelController extends BaseController {

    @Autowired
    private ProModelService proModelService;
//    @Autowired
//    private ProModelMdService proModelMdService;
//    @Autowired
//    private ProjectDeclareService projectDeclareService;
    @Autowired
    private SystemService systemService;
    @Autowired
    private ActYwService actYwService;
//    @Autowired
//    private TeamService teamService;
    @Autowired
    SysAttachmentService sysAttachmentService;
//    @Autowired
//    TeamUserRelationService teamUserRelationService;
    @Autowired
    private ProReportService proReportService;
    @Autowired
    private ActYwGnodeService actYwGnodeService;

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


    @RequestMapping(value = {"list", ""})
    public String list(ProModel proModel, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<ProModel> page = proModelService.findPage(new Page<ProModel>(request, response), proModel);
        model.addAttribute("page", page);
        return "modules/promodel/proModelList";
    }


    @RequestMapping(value = "form")
    public String form(ProModel proModel, Model model, HttpServletRequest request, HttpServletResponse response) {
//        User user = systemService.getUser(proModel.getDeclareId());
//        ActYw actYw = actYwService.get(proModel.getActYwId());
//        IWorkFlow workFlow = WorkFlowUtil.getWorkFlowService(actYw);
//        ProProject proProject = actYw.getProProject();
//        if (proProject != null) {
//            showFrontMessage(proProject, model);
//        }
//        if (proModel.getSubTime() != null) {
//            model.addAttribute("sysdate", DateUtil.formatDate(proModel.getSubTime(), "yyyy-MM-dd"));
//        } else {
//            model.addAttribute("sysdate", DateUtil.formatDate(new Date(), "yyyy-MM-dd"));
//        }
//        model.addAttribute("proProject", proProject);
//        model.addAttribute("actYw", actYw);
//        model.addAttribute("sse", user);
//        //关联团队
//        model.addAttribute("teams", projectDeclareService.findTeams(user.getId(), ""));
//        model.addAttribute("projectName", actYw.getProProject().getProjectName());
//        model.addAttribute("team", teamService.get(proModel.getTeamId()));
//        model.addAttribute("teamStu", projectDeclareService.findTeamStudentFromTUH(proModel.getTeamId(), proModel.getId()));
//        model.addAttribute("teamTea", projectDeclareService.findTeamTeacherFromTUH(proModel.getTeamId(), proModel.getId()));
//
//        User cuser = UserUtils.getUser();
//        User leader = UserUtils.getUser();
//        if (StringUtil.isEmpty(proModel.getDeclareId())
//                || StringUtil.isEmpty(cuser.getId()) || !cuser.getId().equals(proModel.getDeclareId())) {
//            return CoreSval.REDIRECT + Global.getFrontPath() + "/promodel/proModel/viewForm?id=?id=" + proModel.getId();
//        }
//        if (actYw != null && proProject != null && Global.PRO_TYPE_PROJECT.equals(proProject.getProType())
//                && StringUtil.isNotEmpty(proProject.getType())) {
//            model.addAttribute("proModelType", DictUtils.getDictLabel(proProject.getType(), "project_style", ""));
//        }
//        model.addAttribute("proModel", proModel);
//        model.addAttribute("leader", leader);
//        model.addAttribute("cuser", cuser);

//        if (StringUtils.isEmpty(workFlow)) {
//            return proModelService.applayForm(FormPageType.FPT_APPLY, model, request, response, proModel, proProject, actYw);
//        }
//
//        return workFlow.applayForm(FormPageType.FPT_APPLY, model, request, response, proModel, proProject, actYw);
        return "";
    }


    /**
     * 报告 申请材料 logo
     *
     * @param proModel
     * @param model
     */
    private void setExtraInfo(ProModel proModel, Model model) {
        //报告（中期、结项等）
        ProReport report = new ProReport();
        report.setProModelId(proModel.getId());
        List<ProReport> reports = proReportService.findList(report);
        for (ProReport proReport : reports) {
            SysAttachment sa = new SysAttachment();
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

        SysAttachment sa = new SysAttachment();
        sa.setUid(proModel.getId());
        sa.setType(FileTypeEnum.S11);
        List<SysAttachment> fileList = sysAttachmentService.getFiles(sa);
        if (!fileList.isEmpty()) {
            List<SysAttachment> applyFiles = new ArrayList<>();
            for (SysAttachment sysAttachment : fileList) {
                if (sysAttachment.getFileStep() == null) {
                    continue;
                }
                if (FileStepEnum.S1101.getValue().equals(sysAttachment.getFileStep().getValue())) {
                    model.addAttribute("logo", sysAttachment);//logo
                } else if (FileStepEnum.S1102.getValue().equals(sysAttachment.getFileStep().getValue())) {
                    applyFiles.add(sysAttachment);//申报附件
                }
            }
            model.addAttribute("applyFiles", applyFiles);//申报附件
        }
        //审核记录
        List<ActYwAuditInfo> actYwAuditInfos = proModelService.getFrontActYwAuditInfo(proModel.getId(), false);
        if (!actYwAuditInfos.isEmpty()) {
            model.addAttribute("actYwAuditInfos", actYwAuditInfos);
        }
    }


//旧的查看
//	@RequestMapping(value = "viewForm")
//	public String viewForm(ProModel proModel, Model model) {
//		model.addAttribute("proModel", proModel);
//		User user=systemService.getUser(proModel.getDeclareId());
//		ActYw actYw=actYwService.get(proModel.getActYwId());
//		ProProject proProject=actYw.getProProject();
//		if (proProject!=null) {
//			showFrontMessage(proProject,model);
//		}
//		if (proModel.getDeclareId()!=null) {
//			model.addAttribute("sse", systemService.getUser(proModel.getDeclareId()));
//		}else{
//			model.addAttribute("sse", user);
//		}
//
//		model.addAttribute("projectName", actYw.getProProject().getProjectName());
//		model.addAttribute("team", teamService.get(proModel.getTeamId()));
//		model.addAttribute("teamStu", projectDeclareService.findTeamStudentFromTUH(proModel.getTeamId(),proModel.getId()));
//		model.addAttribute("teamTea", projectDeclareService.findTeamTeacherFromTUH(proModel.getTeamId(),proModel.getId()));
//		if (StringUtil.isNotEmpty(actYw.getKeyType())) {
//			ProModelMd proModelMd=proModelMdService.getByProModelId(proModel.getId());
//			SysAttachment sa=new SysAttachment();
//			sa.setUid(proModel.getId());
//			/*sa.setFileStep(FileStepEnum.S2000);
//			sa.setType(FileTypeEnum.S10);*/
//			List<SysAttachment> fileListMap =  sysAttachmentService.getFiles(sa);
//			model.addAttribute("sysAttachments", fileListMap);
//			model.addAttribute("proModelMd",proModelMd);
//			return "template/form/project/"+actYw.getKeyType()+"applyView";
//		}
//		ActYwGroup actYwGroup=actYw.getGroup();
//		model.addAttribute("groupId",actYw.getGroupId());
//		String flowType=actYwGroup.getFlowType();
//		String type= FlowType.getByKey(flowType).getType().getKey();
//		SysAttachment sa=new SysAttachment();
//		sa.setUid(proModel.getId());
//
//		List<SysAttachment> fileListMap =  sysAttachmentService.getFiles(sa);
//		model.addAttribute("sysAttachments", fileListMap);
//		return "template/form/"+type+"/viewForm";
//	}


    @RequestMapping(value = "viewForm")
    public String viewForm(ProModel proModel, Model model, HttpServletRequest request, HttpServletResponse response) {
//        /**
//         * 查看页面基本信息，所有的查看页面共有,与表单页面类型，和项目类型无关.
//         */
//        ActYw actYw = actYwService.get(proModel.getActYwId());
//        IWorkFlow workFlow = WorkFlowUtil.getWorkFlowService(actYw);
//        if(actYw==null){
//            return "error/404";
//        }
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
//        model.addAttribute("actYw", actYw);
//        model.addAttribute("proModel", proModel);
//        model.addAttribute("groupId", actYw.getGroupId());
//        model.addAttribute("projectName", actYw.getProProject().getProjectName());
//        model.addAttribute("team", teamService.get(proModel.getTeamId()));
//        model.addAttribute("teamStu", projectDeclareService.findTeamStudentFromTUH(proModel.getTeamId(), proModel.getId()));
//        model.addAttribute("teamTea", projectDeclareService.findTeamTeacherFromTUH(proModel.getTeamId(), proModel.getId()));
//
//        /**
//         * 前台查看页面特殊需求参数及页面跳转.
//         */
//        if (org.springframework.util.StringUtils.isEmpty(workFlow)) {
//            return proModelService.viewForm(FormPageType.FPT_VIEWA, model, request, response, proModel, actYw);
//        }
//        return workFlow.viewForm(FormPageType.FPT_VIEWF, model, request, response, proModel, actYw);
        return "";
    }

    /**
     * 前台查看页面特殊需求参数及页面跳转.
     */
    private String dealPageView(FormPageType fpageType, Model model, HttpServletRequest request, HttpServletResponse response, ProModel proModel, ActYw actYw) {
//        FormTheme formTheme = actYw.getFtheme();
//        if (formTheme != null) {
//            FormPage fpage = FormPage.getByKey(formTheme, actYw.getFptype().getKey(), fpageType.getKey());
//            if ((FormTheme.F_MR).equals(formTheme)) {
//                fpage.getParam().init(model, request, response, new Object[]{});
//                fpage.getParam().initSysAttachment(model, request, response, new Object[]{proModel, sysAttachmentService});
//                return FormPage.getAbsUrl(actYw, fpageType, null);
//            } else if ((FormTheme.F_MD).equals(formTheme)) {
//                //参数实现已经移动至实现类FppMd
//                fpage.getParam().init(model, request, response, new Object[]{});
//                fpage.getParam().initSysAttachment(model, request, response, new Object[]{proModel, sysAttachmentService, proModelMdService});
//                return FormPage.getAbsUrl(actYw, fpageType, null);
//            } else if ((FormTheme.F_COM).equals(formTheme)) {
//                //参数实现已经移动至实现类FppCom
//                fpage.getParam().init(model, request, response, new Object[]{});
//                fpage.getParam().initSysAttachment(model, request, response, new Object[]{proModel, sysAttachmentService});
//                return FormPage.getAbsUrl(actYw, fpageType, null);
//            } else {
//                logger.error("当前流程主题未定义！");
//            }
//        } else {
//            logger.error("流程主题不存在！");
//        }
        return SysIdx.SYSIDX_404.getIdxUrl();
    }

    @RequestMapping(value = "save")
    public String save(ProModel proModel, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request, HttpServletResponse response) {
        if (!beanValidator(model, proModel)) {
            return form(proModel, model, request, response);
        }
        proModelService.save(proModel);
        addMessage(redirectAttributes, "保存proModel成功");
        return CoreSval.REDIRECT + Global.getAdminPath() + "/promodel/proModel/?repage";
    }


    @ResponseBody
    @RequestMapping(value = "findTeamPerson")
    public JSONObject findTeamPerson(@RequestParam(required = true) String id, @RequestParam(required = false) String type, @RequestParam(required = true) String actywId) {
        //List<Map<String,String>>
        JSONObject js = new JSONObject();

//        js.put("teamId", id);
//        js.put(CoreJkey.JK_RET, 0);
//
//        ActYw actYw = actYwService.get(actywId);
//        String subType = actYw.getProProject().getType();//项目分类
//        SysConfigVo scv = SysConfigUtil.getSysConfigVo();
//        PersonNumConf pnc = new PersonNumConf();
//        if (StringUtil.isNotEmpty(type)) {
//            pnc = SysConfigUtil.getProPersonNumConf(scv, subType, type);
//        } else {
//            pnc = SysConfigUtil.getGconPersonNumConf(scv, subType);
//        }
//        if (pnc != null) {
//            Team teamNums = teamService.findTeamJoinInNums(id);
//            if ("1".equals(pnc.getTeamNumOnOff())) {//团队人数范围
//                ConfRange cr = pnc.getTeamNum();
//                int min = Integer.valueOf(cr.getMin());
//                int max = Integer.valueOf(cr.getMax());
//                if (teamNums.getMemberNum() < min || teamNums.getMemberNum() > max) {
//                    if (min == max) {
//                        js.put("msg", DictUtils.getDictLabel(subType, FlowPcategoryType.PCT_XM.getKey(), "") + "项目团队成员人数为" + min + "人");
//                    } else {
//                        js.put("msg", DictUtils.getDictLabel(subType, FlowPcategoryType.PCT_XM.getKey(), "") + "项目团队成员人数为" + min + "~" + max + "人");
//                    }
//                    return js;
//                }
//            }
//            if ("1".equals(pnc.getSchoolTeacherNumOnOff())) {//校园导师人数范围
//                ConfRange cr = pnc.getSchoolTeacherNum();
//                int min = Integer.valueOf(cr.getMin());
//                int max = Integer.valueOf(cr.getMax());
//                if (teamNums.getSchoolTeacherNum() < min || teamNums.getSchoolTeacherNum() > max) {
//                    if (min == max) {
//                        js.put("msg", DictUtils.getDictLabel(subType, FlowPcategoryType.PCT_XM.getKey(), "") + "项目团队校园导师为" + min + "人");
//                    } else {
//                        js.put("msg", DictUtils.getDictLabel(subType, FlowPcategoryType.PCT_XM.getKey(), "") + "项目团队校园导师为" + min + "~" + max + "人");
//                    }
//                    return js;
//                }
//            }
//            if ("1".equals(pnc.getEnTeacherNumOnOff())) {//企业导师人数范围
//                ConfRange cr = pnc.getEnTeacherNum();
//                int min = Integer.valueOf(cr.getMin());
//                int max = Integer.valueOf(cr.getMax());
//                if (teamNums.getEnterpriseTeacherNum() < min || teamNums.getEnterpriseTeacherNum() > max) {
//                    if (min == max) {
//                        js.put("msg", DictUtils.getDictLabel(subType, FlowPcategoryType.PCT_XM.getKey(), "") + "项目企业导师为" + min + "人");
//                    } else {
//                        js.put("msg", DictUtils.getDictLabel(subType, FlowPcategoryType.PCT_XM.getKey(), "") + "项目企业导师为" + min + "~" + max + "人");
//                    }
//                    return js;
//                }
//            }
//        }
//
//		/*if (type != null) {
//            if ((type.equals("1")||type.equals("2"))  && (stuNum>5||stuNum<1)) {
//				js.put(CoreJkey.JK_RET,0);
//				js.put("msg","该团队人数不符合，创新创业训练人数为1-5人。");
//				return  js;
//			}
//			if ((type.equals("3"))  &&(stuNum>7||stuNum<1)) {
//				js.put(CoreJkey.JK_RET,0);
//				js.put("msg","该团队人数不符合，创业实践人数为1-7人。");
//				return  js;
//			}
//		}*/
//
//        List<Map<String, String>> list = new ArrayList<Map<String, String>>();
//        List<Map<String, String>> list1 = projectDeclareService.findTeamStudent(id);
//        List<Map<String, String>> list2 = projectDeclareService.findTeamTeacher(id);
//        for (Map<String, String> map : list1) {
//            list.add(map);
//        }
//        for (Map<String, String> map : list2) {
//            list.add(map);
//        }
//
//        js.put(CoreJkey.JK_RET, 1);
//        js.put("map", list);
        return js;
    }


    @RequestMapping(value = "submit")
    @ResponseBody
    public JSONObject submit(ProModel proModel, Model model, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        JSONObject js = new JSONObject();
//        String gnodeId = request.getParameter("gnodeId");
//        if (StringUtil.isNotEmpty(gnodeId)) {
//            proModel.getAttachMentEntity().setGnodeId(gnodeId);
//        }
//        try {
//            ActYw actYw = actYwService.get(proModel.getActYwId());
//            String serviceName = FormTheme.getById(actYw.getGroup().getTheme()).getServiceName();
//            IWorkFlow workFlow = WorkFlowUtil.getWorkFlowService(serviceName);
//            js=workFlow.submit(proModel, js);
//        //proModelService.auditWithGateWay(proModel, gnodeId);
//        } catch (GroupErrorException e) {
//            js.put(CoreJkey.JK_RET, 0);
//            js.put("msg", e.getCode());
//        }
////       js = proModelService.submit(proModel, js);
        return js;
    }

    @RequestMapping(value = "checkProName")
   	@ResponseBody
   	public boolean linkList(ProModel proModel, HttpServletRequest request, HttpServletResponse response) {
        boolean isHave=proModelService.checkName(proModel);
        return !isHave;
   	}

    @RequestMapping(value = "submitMid")
    @ResponseBody
    public JSONObject submitMid(ProModel proModel, Model model, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        JSONObject js = new JSONObject();
        js.put(CoreJkey.JK_RET, 1);
        String gnodeId = request.getParameter("gnodeId");
        if (StringUtil.isNotEmpty(gnodeId)) {
            proModel.getAttachMentEntity().setGnodeId(gnodeId);
        }
        String msg = proModelService.submitMid(proModel);

        js.put("msg", msg);
        return js;
    }

    @RequestMapping(value = "delete")
    public String delete(ProModel proModel, RedirectAttributes redirectAttributes) {
        proModelService.delete(proModel);
        addMessage(redirectAttributes, "删除proModel成功");
        return CoreSval.REDIRECT + Global.getFrontPath() + "/promodel/proModel/?repage";
    }

    public static void showFrontMessage(ProProject proProject, Model model) {
        List<Dict> finalStatusMap = new ArrayList<Dict>();
        if (proProject.getFinalStatus() != null) {
            String finalStatus = proProject.getFinalStatus();
            if (finalStatus != null) {
                String[] finalStatuss = finalStatus.split(",");
                if (finalStatuss.length > 0) {
                    for (int i = 0; i < finalStatuss.length; i++) {
                        Dict dict = new Dict();
                        dict.setValue(finalStatuss[i]);
                        if (proProject.getProType().contains(FlowProjectType.PMT_DASAI.getKey())) {
                            dict.setLabel(DictUtils.getDictLabel(finalStatuss[i], "competition_college_prise", ""));
                        } else if (proProject.getProType().contains(FlowProjectType.PMT_XM.getKey())) {
                            dict.setLabel(DictUtils.getDictLabel(finalStatuss[i], "project_result", ""));
                        }
                        finalStatusMap.add(dict);
                    }
                }
                model.addAttribute("finalStatusMap", finalStatusMap);
            }
        }
        //前台项目类型
        List<Dict> proTypeMap = new ArrayList<Dict>();
        if (proProject.getType() != null) {
            String proType = proProject.getType();
            if (proType != null) {
                String[] proTypes = proType.split(",");
                if (proTypes.length > 0) {
                    for (int i = 0; i < proTypes.length; i++) {
                        Dict dict = new Dict();

                        dict.setValue(proTypes[i]);
                        if (proProject.getProType().contains(FlowProjectType.PMT_DASAI.getKey())) {
                            dict.setLabel(DictUtils.getDictLabel(proTypes[i], "competition_type", ""));
                        } else if (proProject.getProType().contains(FlowProjectType.PMT_XM.getKey())) {
                            dict.setLabel(DictUtils.getDictLabel(proTypes[i], "project_style", ""));
                        }
                        //proCategoryMap.add(map);
                        proTypeMap.add(dict);

                    }
                }
                model.addAttribute("proTypeMap", proTypeMap);
            }
        }
        //前台项目类别
            /*List<Map<Dict>> proCategoryMap=new ArrayList<Map<String, String>>();*/
        List<Dict> proCategoryMap = new ArrayList<Dict>();
        if (proProject.getProCategory() != null) {
            String proCategory = proProject.getProCategory();
            if (proCategory != null) {
                String[] proCategorys = proCategory.split(",");
                if (proCategorys.length > 0) {
                    for (int i = 0; i < proCategorys.length; i++) {
                        Map<String, String> map = new HashMap<String, String>();
                        Dict dict = new Dict();
                        map.put("value", proCategorys[i]);
                        dict.setValue(proCategorys[i]);
                        if (proProject.getProType().contains(FlowProjectType.PMT_DASAI.getKey())) {
                            map.put("label", DictUtils.getDictLabel(proCategorys[i], "competition_net_type", ""));
                            dict.setLabel(DictUtils.getDictLabel(proCategorys[i], "competition_net_type", ""));
                        } else if (proProject.getProType().contains(FlowProjectType.PMT_XM.getKey())) {
                            map.put("label", DictUtils.getDictLabel(proCategorys[i], FlowPcategoryType.PCT_XM.getKey(), ""));
                            dict.setLabel(DictUtils.getDictLabel(proCategorys[i], FlowPcategoryType.PCT_XM.getKey(), ""));
                        }
                        //proCategoryMap.add(map);
                        proCategoryMap.add(dict);
                    }
                }
                model.addAttribute("proCategoryMap", proCategoryMap);
            }
        }
        //前台项目类别
        List<Dict> prolevelMap = new ArrayList<Dict>();
        if (proProject.getLevel() != null) {
            String proLevel = proProject.getLevel();
            if (proLevel != null) {
                String[] proLevels = proLevel.split(",");
                if (proLevels.length > 0) {
                    for (int i = 0; i < proLevels.length; i++) {
                        Dict dict = new Dict();
                        dict.setValue(proLevels[i]);
                        dict.setLabel(DictUtils.getDictLabel(proLevels[i], "gcontest_level", ""));
                        prolevelMap.add(dict);
                    }
                }
                model.addAttribute("prolevelMap", prolevelMap);
            }
        }
    }

    /*下载模板*/
    @RequestMapping(value = "/downTemplate")
    public void downTemplate(HttpServletRequest request, HttpServletResponse response) {
        String type = request.getParameter("type");
        String rootpath = request.getSession().getServletContext().getRealPath("/");
        FileInputStream fs = null;
        OutputStream out = null;
        try {
            String fileName = null;
            String ext = null;
            String path = rootpath + File.separator + "static" + File.separator + "project-word" + File.separator;
            File fi = new File(path + type + ".json");
            if (fi.exists()) {
                JsonParser jsonParser = new JsonParser();
                InputStreamReader inputStreamReader = new InputStreamReader(new FileInputStream(fi), "UTF-8");
                BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
                JsonObject json=(JsonObject) jsonParser.parse(bufferedReader);
                fileName = json.get("fileName").getAsString();
                ext = json.get("ext").getAsString();
            }
            if (!fi.exists()) {
                return;
            }

            out = response.getOutputStream();
            String headStr = "attachment; filename=\"" + new String(fileName.getBytes(), "ISO-8859-1") + "\"";
            response.setContentType("APPLICATION/OCTET-STREAM");
            response.setHeader("Content-Disposition", headStr);

            fi = new File(path + type + ext);
            fs = new FileInputStream(fi);
            out = response.getOutputStream();
            byte[] b = new byte[1024];
            int len;
            while ((len = fs.read(b)) > 0) {
                out.write(b, 0, len);
            }
        } catch (Exception e) {
            logger.error(ExceptionUtil.getStackTrace(e));
        } finally {
            IOUtils.closeQuietly(out);
            IOUtils.closeQuietly(fs);
        }
    }
}