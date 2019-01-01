package com.oseasy.initiate.modules.proproject.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oseasy.initiate.common.service.CommonService;
import com.oseasy.initiate.modules.attachment.entity.SysAttachment;
import com.oseasy.initiate.modules.attachment.enums.FileStepEnum;
import com.oseasy.initiate.modules.attachment.enums.FileTypeEnum;
import com.oseasy.initiate.modules.attachment.service.SysAttachmentService;
import com.oseasy.initiate.modules.promodel.entity.ProModel;
import com.oseasy.initiate.modules.promodel.entity.ProReport;
import com.oseasy.initiate.modules.promodel.service.ProModelService;
import com.oseasy.initiate.modules.proproject.entity.ProProject;
import com.oseasy.initiate.modules.sys.utils.UserUtils;
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pact.modules.actyw.entity.ActYwYear;
import com.oseasy.pact.modules.actyw.exception.ActYwRuntimeException;
import com.oseasy.pact.modules.actyw.exception.GroupErrorException;
import com.oseasy.pact.modules.actyw.service.ActYwService;
import com.oseasy.pact.modules.actyw.service.ActYwYearService;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowPcategoryType;
import com.oseasy.pcore.common.config.CoreJkey;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.AttachMentEntity;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.pcore.modules.sys.utils.DictUtils;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.putil.common.utils.exception.ExceptionUtil;

import net.sf.json.JSONObject;

/**
 * 创建项目Controller.
 *
 * @author zhangyao
 * @version 2017-06-15
 */
@Controller
public class FrontProProjectController extends BaseController {

    @Autowired
    private ProModelService proModelService;
    @Autowired
    private ActYwService actYwService;
    @Autowired
    private CommonService commonService;
    @Autowired
    private SysAttachmentService sysAttachmentService;
    @Autowired
    private ActYwYearService actYwYearService;


    @RequestMapping(value = "${frontPath}/proproject/applyStep1")
    public String applyStep1(ProModel proModel, HttpServletRequest request, HttpServletResponse response, Model model) {
        User cuser = CoreUtils.getUser();
        User leader = null;
        String parmact = null;
        if (StringUtil.isNotEmpty(proModel.getId())) {
            proModel = proModelService.get(proModel.getId());
            if (StringUtil.isEmpty(proModel.getDeclareId())
                    || StringUtil.isEmpty(cuser.getId()) || !cuser.getId().equals(proModel.getDeclareId())) {
                return CoreSval.REDIRECT + Global.getFrontPath() + "/promodel/proModel/viewForm?id=" + proModel.getId();
            }
            leader = UserUtils.get(proModel.getDeclareId());
            parmact = proModel.getActYwId();
        } else {
            proModel.setCreateDate(new Date());
            leader = cuser;
            parmact = request.getParameter("actywId");
        }
        proModel.setActYwId(parmact);
        if (StringUtil.isNotEmpty(parmact)) {
            ActYw actYw = actYwService.get(parmact);
            if (actYw != null) {
                ProProject proProject = actYw.getProProject();
                if (proProject != null && Global.PRO_TYPE_PROJECT.equals(proProject.getProType())
                        && StringUtil.isNotEmpty(proProject.getType())) {
                    model.addAttribute("proModelType", DictUtils.getDictLabel(proProject.getType(), "project_style", ""));
                }
            }
        }
        model.addAttribute("proModel", proModel);
        model.addAttribute("leader", leader);
        model.addAttribute("cuser", cuser);
        return "template/formtheme/project/common_applyForm";
    }

    @RequestMapping(value = "${frontPath}/proproject/applyStep2")
    public String applyStep2(ProModel proModel, HttpServletRequest request, HttpServletResponse response, Model model) {
//        User cuser = CoreUtils.getUser();
//        User leader =null;
//        String parmact=null;
//        if (StringUtil.isNotEmpty(proModel.getId())) {
//            proModel = proModelService.get(proModel.getId());
//            if (StringUtil.isEmpty(proModel.getDeclareId())
//                    ||StringUtil.isEmpty(cuser.getId())||!cuser.getId().equals(proModel.getDeclareId())) {
//                return CoreSval.REDIRECT+Global.getFrontPath()+"/promodel/proModel/viewForm?id="+proModel.getId();
//            }
//            model.addAttribute("teamStu", projectDeclareService.findTeamStudentFromTUH(proModel.getTeamId(),proModel.getId()));
//            model.addAttribute("teamTea", projectDeclareService.findTeamTeacherFromTUH(proModel.getTeamId(),proModel.getId()));
//            leader=UserUtils.get(proModel.getDeclareId());
//            parmact=proModel.getActYwId();
//        }else{
//            proModel.setCreateDate(new Date());
//            leader=cuser;
//            parmact=request.getParameter("actywId");
//        }
//        model.addAttribute("teams", projectDeclareService.findTeams(leader.getId(),proModel.getTeamId()));
//        proModel.setActYwId(parmact);
//        if (StringUtil.isNotEmpty(parmact)){
//            ActYw actYw =actYwService.get(parmact);
//            if (actYw!=null) {
//                ProProject proProject=actYw.getProProject();
//                if (proProject!=null&&Global.PRO_TYPE_PROJECT.equals(proProject.getProType())
//                        &&StringUtil.isNotEmpty(proProject.getType())) {
//                    model.addAttribute("proModelType", DictUtils.getDictLabel(proProject.getType(), "project_style", ""));
//                }
//            }
//        }
//        model.addAttribute("proModel", proModel);
//        model.addAttribute("leader", leader);
//        model.addAttribute("cuser", cuser);
        return "template/formtheme/project/common_applyStep2";
    }

    @RequestMapping(value = "${frontPath}/proproject/saveStep1")
    @ResponseBody
    public JSONObject saveStep1(ProModel proModel, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        JSONObject js = new JSONObject();
        if(StringUtil.isEmpty(proModel.getYear())){
        	proModel.setYear(commonService.getApplyYear(proModel.getActYwId()));
		}
        js = commonService.onProjectSaveStep1(proModel.getActYwId(), proModel.getId(),proModel.getYear());
        return js;
    }

    @RequestMapping(value = "${frontPath}/proproject/saveStep2")
    @ResponseBody
    public JSONObject saveStep2(ProModel proModel, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        JSONObject js = new JSONObject();
        if(StringUtil.isEmpty(proModel.getYear())){
        	proModel.setYear(commonService.getApplyYear(proModel.getActYwId()));
		}
        js = commonService.onProjectSaveStep2(proModel.getId(), proModel.getActYwId(), proModel.getProCategory(), proModel.getTeamId(),proModel.getYear());
        if (!"1".equals(js.getString(CoreJkey.JK_RET))) {
            return js;
        }
        try {
            ActYw actYw = actYwService.get(proModel.getActYwId());
            if (actYw != null) {
                ProProject proProject = actYw.getProProject();
                if (proProject != null) {
                    proModel.setProType(proProject.getProType());
                    proModel.setType(proProject.getType());
                    setYear(proModel);
                }

            }
            User cuser = CoreUtils.getUser();
            proModel.setDeclareId(cuser.getId());
//            if (StringUtil.isEmpty(proModel.getCompetitionNumber())) {
//                proModel.setCompetitionNumber(IdUtils.getProjectNumberByDb());
//            }
            proModelService.saveStep2(proModel);
        } catch (Exception e) {
            logger.error(ExceptionUtil.getStackTrace(e));
            js.put(CoreJkey.JK_RET, 0);
            js.put("msg", "保存失败,系统异常请联系管理员");
            return js;
        }
        js.put(CoreJkey.JK_RET, 1);
        js.put("id", proModel.getId());
        js.put("msg", "保存成功");
        return js;
    }

    private void setYear(ProModel proModel) {
        List<ActYwYear> years = actYwYearService.findListByActywId(proModel.getActYwId());
        long now = new Date().getTime();
        for (ActYwYear year : years) { //设置年份
            if(now >= year.getNodeStartDate().getTime() && now <= year.getNodeEndDate().getTime()){
                proModel.setYear(year.getYear());
                break;
            }
        }
    }

    @RequestMapping(value = "${frontPath}/proproject/saveStep2Uncheck")
    @ResponseBody
    public JSONObject saveStep2Uncheck(ProModel proModel, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        JSONObject js = new JSONObject();
        try {
            if (!StringUtil.isEmpty(proModel.getId())) {//修改
                ProModel pm = proModelService.get(proModel.getId());
                if (pm == null || "1".equals(pm.getDelFlag())) {
                    js.put(CoreJkey.JK_RET, 0);
                    js.put("msg", "保存失败，项目已被删除");
                    return js;
                }
                if (Global.YES.equals(pm.getSubStatus())) {
                    js.put(CoreJkey.JK_RET, 0);
                    js.put("msg", "保存失败，项目已被提交");
                    return js;
                }
            }
            ActYw actYw = actYwService.get(proModel.getActYwId());
            if (actYw != null) {
                ProProject proProject = actYw.getProProject();
                if (proProject != null) {
                    proModel.setProType(proProject.getProType());
                    proModel.setType(proProject.getType());
                    setYear(proModel);
                }

            }
            User cuser = CoreUtils.getUser();
            proModel.setDeclareId(cuser.getId());
//            if (StringUtil.isEmpty(proModel.getCompetitionNumber())) {
//                proModel.setCompetitionNumber(IdUtils.getProjectNumberByDb());
//            }
            proModelService.saveStep2(proModel);
        } catch (Exception e) {
            logger.error(ExceptionUtil.getStackTrace(e));
            js.put(CoreJkey.JK_RET, 0);
            js.put("msg", "保存失败,系统异常请联系管理员");
            return js;
        }
        js.put(CoreJkey.JK_RET, 1);
        js.put("id", proModel.getId());
        js.put("msg", "保存成功");
        return js;
    }

    @RequestMapping(value = "${frontPath}/proproject/applyStep3")
    public String applyStep3(ProModel proModel, HttpServletRequest request, HttpServletResponse response, Model model) {
        User cuser = CoreUtils.getUser();
        User leader = null;
        if (StringUtil.isNotEmpty(proModel.getId())) {
            proModel = proModelService.get(proModel.getId());
            if (StringUtil.isEmpty(proModel.getDeclareId())
                    || StringUtil.isEmpty(cuser.getId()) || !cuser.getId().equals(proModel.getDeclareId())) {
                return CoreSval.REDIRECT + Global.getFrontPath() + "/promodel/proModel/viewForm?id=" + proModel.getId();
            }
            leader = UserUtils.get(proModel.getDeclareId());
        }
        String parmact = proModel.getActYwId();
        if (StringUtil.isNotEmpty(parmact)) {
            ActYw actYw = actYwService.get(parmact);
            if (actYw != null) {
                ProProject proProject = actYw.getProProject();
                if (proProject != null && Global.PRO_TYPE_PROJECT.equals(proProject.getProType())
                        && StringUtil.isNotEmpty(proProject.getType())) {
                    model.addAttribute("proModelType", DictUtils.getDictLabel(proProject.getType(), "project_style", ""));
                }
            }
        }
        SysAttachment sa = new SysAttachment();
        sa.setUid(proModel.getId());
        sa.setFileStep(FileStepEnum.S1102);
        sa.setType(FileTypeEnum.S11);
        proModel.setFileInfo(sysAttachmentService.getFiles(sa));
        model.addAttribute("proModel", proModel);
        model.addAttribute("leader", leader);
        model.addAttribute("cuser", cuser);
        return "template/formtheme/project/common_applyStep3";
    }

    @RequestMapping(value = "${frontPath}/proproject/saveStep3")
    @ResponseBody
    public JSONObject saveStep3(ProModel proModel, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        JSONObject js = new JSONObject();
        AttachMentEntity attachMentEntity = proModel.getAttachMentEntity();
        proModel = proModelService.get(proModel.getId());
        proModel.setAttachMentEntity(attachMentEntity);
        if(StringUtil.isEmpty(proModel.getYear())){
        	proModel.setYear(commonService.getApplyYear(proModel.getActYwId()));
		}
        js = commonService.onProjectSaveStep2(proModel.getId(), proModel.getActYwId(), proModel.getProCategory(), proModel.getTeamId(),proModel.getYear());
        if (!"1".equals(js.getString(CoreJkey.JK_RET))) {
            return js;
        }
        try {
            proModelService.saveStep3(proModel);
        } catch (Exception e) {
            logger.error(ExceptionUtil.getStackTrace(e));
            js.put(CoreJkey.JK_RET, 0);
            js.put("msg", "保存失败,系统异常请联系管理员");
            return js;
        }
        js.put(CoreJkey.JK_RET, 1);
        js.put("msg", "保存成功");
        return js;
    }

    @RequestMapping(value = "${frontPath}/proproject/submitStep3")
    @ResponseBody
    public JSONObject submitStep3(ProModel proModel, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        JSONObject js = new JSONObject();
        AttachMentEntity attachMentEntity = proModel.getAttachMentEntity();
        proModel = proModelService.get(proModel.getId());
        proModel.setAttachMentEntity(attachMentEntity);
        if(StringUtil.isEmpty(proModel.getYear())){
        	proModel.setYear(commonService.getApplyYear(proModel.getActYwId()));
		}
        js = commonService.onProjectSubmitStep3(proModel.getId(), proModel.getActYwId(), proModel.getProCategory(), proModel.getTeamId(),proModel.getYear());
        if (!"1".equals(js.getString(CoreJkey.JK_RET))) {
            return js;
        }

        try {
            proModelService.submitStep3(proModel);
        } catch (Exception e) {
            logger.error(ExceptionUtil.getStackTrace(e));
            js.put(CoreJkey.JK_RET, 0);
            js.put("msg", "提交失败,系统异常请联系管理员");
            return js;
        }
        ActYw actYw = actYwService.get(proModel.getActYwId());
		if (actYw != null) {
			js.put("pptype", actYw.getProProject().getType());
			js.put("proProjectId", actYw.getProProject().getId());
		}
        js.put("actywId", proModel.getActYwId());
		js.put("projectId", proModel.getId());
        js.put(CoreJkey.JK_RET, 1);
        js.put("msg", "提交成功");
        return js;
    }

    /*下载模板*/
    @RequestMapping(value = "${frontPath}/proproject/downTemplate")
    public void downTemplate(HttpServletRequest request, HttpServletResponse response) {
        String type = request.getParameter("type");
        String rootpath = request.getSession().getServletContext().getRealPath("/");
        FileInputStream fs = null;
        OutputStream out = null;
        try {
            String fileName = null;
            String fileName2 = type + ".doc";
            File fi = new File(rootpath + File.separator + "static" + File.separator + "project-word"
                    + File.separator + fileName2);
            if (fi.exists()) {
                if ("mid".equals(type)) {
                    fileName = "大学生创新创业项目中期检查表.doc";
                } else if ("close".equals(type)) {
                    fileName = "大学生创新创业项目结项报告.doc";
                } else if ("modify".equals(type)) {
                    fileName = "大学生创新创业项目调整申请表.doc";
                } else if ("spec".equals(type)) {
                    fileName = "大学生创新创业项目免鉴定申请表.doc";
                } else {
                    fileName = DictUtils.getDictLabel(type, FlowPcategoryType.PCT_XM.getKey(), "") + "项目申请表.doc";
                }
            } else {
                if ("mid".equals(type)) {
                    fileName = "大学生创新创业项目中期检查表.docx";
                } else if ("close".equals(type)) {
                    fileName = "大学生创新创业项目结项报告.docx";
                } else if ("modify".equals(type)) {
                    fileName = "大学生创新创业项目调整申请表.docx";
                } else if ("spec".equals(type)) {
                    fileName = "大学生创新创业项目免鉴定申请表.docx";
                } else {
                    fileName = DictUtils.getDictLabel(type, FlowPcategoryType.PCT_XM.getKey(), "") + "项目申请表.docx";
                }
                fileName2 = type + ".docx";
                fi = new File(rootpath + File.separator + "static" + File.separator + "projectgt-word"
                        + File.separator + fileName2);
            }
            if (!fi.exists()) {
                return;
            }
            out = response.getOutputStream();
            String headStr = "attachment; filename=\"" + new String(fileName.getBytes(), "ISO-8859-1") + "\"";
            response.setContentType("APPLICATION/OCTET-STREAM");
            response.setHeader("Content-Disposition", headStr);

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

    /**
     * 学生端提交报告（比如中期报告、结项报告）
     * @param proReport
     * @param model
     * @param request
     * @param redirectAttributes
     * @return
     */
    @RequestMapping(value = "${frontPath}/proproject/reportSubmit")
    @ResponseBody
    public JSONObject reportSubmit(ProReport proReport, Model model, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        try {
            String gnodeId=request.getParameter("gnodeId");
            return proModelService.reportSubmit(proReport,gnodeId);
        } catch (GroupErrorException e) {
            logger.error(ExceptionUtil.getStackTrace(e));
            JSONObject js = new JSONObject();
            js.put("msg", "提交失败," + e.getCode());
            js.put(CoreJkey.JK_RET, 0);
            return js;
        }catch (ActYwRuntimeException e) {
            logger.error(ExceptionUtil.getStackTrace(e));
            JSONObject js = new JSONObject();
            js.put("msg", "提交失败," + e.getMessage());
            js.put(CoreJkey.JK_RET, 0);
            return js;
        } catch (Exception e) {
            logger.error(ExceptionUtil.getStackTrace(e));
            JSONObject js = new JSONObject();
            js.put("msg", "提交失败,系统异常请联系管理员");
            js.put(CoreJkey.JK_RET, 0);
            return js;
        }
    }
}