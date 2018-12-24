package com.oseasy.pact.modules.actyw.web;

import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oseasy.initiate.modules.promodel.entity.ProModel;
import com.oseasy.initiate.modules.promodel.service.ProModelService;
import com.oseasy.initiate.modules.sys.tool.SysNoType;
import com.oseasy.initiate.modules.sys.tool.SysNodeTool;
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pact.modules.actyw.entity.ActYwGroup;
import com.oseasy.pact.modules.actyw.entity.ActYwGtheme;
import com.oseasy.pact.modules.actyw.service.ActYwGroupService;
import com.oseasy.pact.modules.actyw.service.ActYwGthemeService;
import com.oseasy.pact.modules.actyw.service.ActYwService;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowType;
import com.oseasy.pact.modules.actyw.tool.process.vo.FormTheme;
import com.oseasy.pcore.common.config.ApiConst;
import com.oseasy.pcore.common.config.ApiResult;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.config.ApiTstatus;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 自定义流程Controller
 * @author chenhao
 * @version 2017-05-23
 */
@Controller
@RequestMapping(value = "${adminPath}/actyw/actYwGroup")
public class ActYwGroupController extends BaseController {

	@Autowired
	private ActYwGroupService actYwGroupService;
	@Autowired
	private ProModelService proModelService;
	@Autowired
	private ActYwService actYwService;
	@Autowired
	private ActYwGthemeService actYwGthemeService;

	@ModelAttribute
	public ActYwGroup get(@RequestParam(required=false) String id) {
		ActYwGroup entity = null;
		if (StringUtil.isNotBlank(id)) {
			entity = actYwGroupService.get(id);
		}
		if (entity == null) {
			entity = new ActYwGroup();
		}
		return entity;
	}

	@RequiresPermissions("actyw:actYwGroup:view")
	@RequestMapping(value = {"list", ""})
	public String list(ActYwGroup actYwGroup, HttpServletRequest request, HttpServletResponse response, Model model) {
//	    Page<ActYwGroup> page = actYwGroupService.findPageByCount(new Page<ActYwGroup>(request, response), actYwGroup);
//		model.addAttribute("page", page);
//		ActYwGtheme pactYwGtheme = new ActYwGtheme();
//        pactYwGtheme.setEnable(true);
//        model.addAttribute(FormTheme.FLOW_THEMES, actYwGthemeService.findList(pactYwGtheme));
//        model.addAttribute(FlowYwId.FLOW_YWIDS, FlowYwId.getAll());
        model.addAttribute(FlowType.FLOW_TYPES, FlowType.values());
		return "modules/actyw/actYwGroupList";
	}

	@RequestMapping(value = "getActYwGroupList", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public ApiResult getActYwGroupList(ActYwGroup actYwGroup, HttpServletRequest request, HttpServletResponse response){
		try {
			Page<ActYwGroup> page = actYwGroupService.findPageByCount(new Page<ActYwGroup>(request, response), actYwGroup);
			return ApiResult.success(page);
		}catch (Exception e){
			logger.error(e.getMessage());
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}

	@RequestMapping(value="getFlowThemes", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public ApiResult getFlowThemes(){
		try {
			ActYwGtheme pactYwGtheme = new ActYwGtheme();
			pactYwGtheme.setEnable(true);
			List<ActYwGtheme> list = actYwGthemeService.findList(pactYwGtheme);
			return ApiResult.success(list);
		}catch (Exception e){
			logger.error(e.getMessage());
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}
	@RequestMapping(value="getFlowTypes", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public ApiResult getFlowTypes(){
		try {
//			HashMap<String, Object> hashMap = new HashMap<>();
//			hashMap.put(FlowType.FLOW_TYPES, Arrays.asList(FlowType.values()).toString());
			return ApiResult.success(Arrays.asList(FlowType.values()).toString());
		}catch (Exception e){
			logger.error(e.getMessage());
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}



	@RequiresPermissions("actyw:actYwGroup:view")
	@RequestMapping(value = "form")
	public String form(ActYwGroup actYwGroup, Model model, HttpServletRequest request) {
		model.addAttribute("actYwGroup", actYwGroup);
        ActYwGtheme pactYwGtheme = new ActYwGtheme();
        pactYwGtheme.setEnable(true);
        model.addAttribute(FormTheme.FLOW_THEMES, actYwGthemeService.findList(pactYwGtheme));
        model.addAttribute(FlowType.FLOW_TYPES, FlowType.getAll());
		String secondName=request.getParameter("secondName");
		if(StringUtil.isNotEmpty(secondName)){
			model.addAttribute("secondName",secondName);
		}
		return "modules/actyw/actYwGroupForm";
	}

	@RequestMapping(value = "ajaxDeploy")
	public String ajaxDeploy(ActYwGroup actYwGroup, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
		if (StringUtil.isNotEmpty(actYwGroup.getId()) && StringUtil.isNotEmpty(actYwGroup.getStatus())) {
		  	ActYwGroup newActYwGroup = actYwGroupService.get(actYwGroup.getId());
		  	if (newActYwGroup.getTemp()) {
				addMessage(redirectAttributes, "流程设计未提交,发布失败!");
				return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGroup/?repage";
		  	}
			//测试流程 取消发布动作
			if(actYwGroup.getStatus().equals("0")){
				//含有该流程已发布的
				List<ActYw> actList= actYwService.findActYwListByGroupId(actYwGroup.getId());
				if(actList!=null && actList.size()>0){
					addMessage(redirectAttributes, "含该流程项目已发布,取消发布失败!");
					return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGroup/?repage";
				}
				//没有正式发布数据 可以取消发布。
				List<ProModel> proList= proModelService.getListByGroupId(actYwGroup.getId());
				if(proList!=null && proList.size()>0){
					addMessage(redirectAttributes, "流程已有数据,取消发布失败!");
					return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGroup/?repage";
				}
				List<ActYw> actAllList= actYwService.findAllActYwListByGroupId(actYwGroup.getId());
				for(ActYw actYw:actAllList){
					proModelService.clearPreReleaseData(actYw.getId());
				}
			}else{
				//发布动作
				List<ActYw> actList= actYwService.findAllActYwListByGroupId(actYwGroup.getId());
				Boolean isHaveRe=true;
				for(ActYw actYw:actList){
					if(actYw.getIsPreRelease()){
						isHaveRe=false;
					}
				}
				if(isHaveRe){
					for(ActYw actYw:actList){
						proModelService.clearPreReleaseData(actYw.getId());
					}
				}
			}
		  	newActYwGroup.setStatus(actYwGroup.getStatus());
		  	return save(newActYwGroup, model, redirectAttributes,request);
		}
    	return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGroup/?repage";
	}


	@RequestMapping(value = "ajaxDeployJson")
	@ResponseBody
	public ApiResult ajaxDeployJson(@RequestBody ActYwGroup actYwGroup, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
		try{
			if (StringUtil.isNotEmpty(actYwGroup.getId()) && StringUtil.isNotEmpty(actYwGroup.getStatus())) {
				ActYwGroup newActYwGroup = actYwGroupService.get(actYwGroup.getId());
				if (newActYwGroup.getTemp()) {
					return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"流程设计未提交,发布失败!");

				}
				//测试流程 取消发布动作
				if(actYwGroup.getStatus().equals("0")){
					//含有该流程已发布的
					List<ActYw> actList= actYwService.findActYwListByGroupId(actYwGroup.getId());
					if(actList!=null && actList.size()>0){
						return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"含该流程项目已发布,取消发布失败!");
					}
					//没有正式发布数据 可以取消发布。
					List<ProModel> proList= proModelService.getListByGroupId(actYwGroup.getId());
					if(proList!=null && proList.size()>0){
						return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"流程已有数据,取消发布失败!");
					}
					List<ActYw> actAllList= actYwService.findAllActYwListByGroupId(actYwGroup.getId());
					for(ActYw actYw:actAllList){
						proModelService.clearPreReleaseData(actYw.getId());
					}
				}else{
					//发布动作
					List<ActYw> actList= actYwService.findAllActYwListByGroupId(actYwGroup.getId());
					Boolean isHaveRe=true;
					for(ActYw actYw:actList){
						if(actYw.getIsPreRelease()){
							isHaveRe=false;
						}
					}
					if(isHaveRe){
						for(ActYw actYw:actList){
							proModelService.clearPreReleaseData(actYw.getId());
						}
					}
				}
				newActYwGroup.setStatus(actYwGroup.getStatus());
				return saveJson(newActYwGroup, model, redirectAttributes,request);
			}else{
				return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"数据不完整");
			}
		}catch (Exception e){
			logger.error(e.getMessage());
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}




	/*发布王清腾*/
	@ResponseBody
    @RequestMapping(value = "ajaxRelease")
    public ApiTstatus<String> ajaxRelease(ActYwGroup actYwGroup, Model model, RedirectAttributes redirectAttributes) {
        ApiTstatus<String> req = new ApiTstatus<String>();
        if (StringUtil.isNotEmpty(actYwGroup.getId()) && StringUtil.isNotEmpty(actYwGroup.getStatus())) {
            ActYwGroup newActYwGroup = actYwGroupService.get(actYwGroup.getId());
            if (newActYwGroup.getTemp()) {
                req.setStatus(false);
                req.setMsg("流程设计未提交,发布失败");
                return req;
            }
            //测试流程
            if(actYwGroup.getStatus().equals("0")){
                //含有该流程已发布的
                List<ActYw> actList= actYwService.findActYwListByGroupId(actYwGroup.getId());
                if(actList!=null && actList.size()>0){
                    req.setStatus(false);
                    req.setMsg("含该流程项目已发布,取消发布失败");
                    return req;
                }
                //没有数据 可以取消发布。
                List<ProModel> proList= proModelService.getListByGroupId(actYwGroup.getId());
                if(proList!=null && proList.size()>0){
                    req.setStatus(false);
                    req.setMsg("流程已有数据,取消发布失败");
                    return req;
                }
            }
            newActYwGroup.setStatus(actYwGroup.getStatus());
            return ajaxSave(newActYwGroup, model);
        }
        req.setStatus(true);
        req.setMsg("流程已有数据,取消发布失败");
        return req;
    }


	public ApiResult saveJson(ActYwGroup actYwGroup, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
		if (StringUtil.isEmpty(actYwGroup.getKeyss())) {
		  actYwGroup.setKeyss(SysNodeTool.genByKeyss(SysNoType.NO_FLOW));
		}
	  	Boolean isTrue = actYwGroupService.validKeyss(actYwGroup.getKeyss(), actYwGroup.getIsNewRecord());
		if (StringUtil.isNotEmpty(actYwGroup.getStatus()) && (!actYwGroup.getTemp()) && (actYwGroup.getStatus()).equals(ActYwGroup.GROUP_DEPLOY_1)) {
		  	isTrue = true;
		}
	  	if (!isTrue) {
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"流程不合法,没有流程节点，修改失败!");
	  	}
		actYwGroupService.save(actYwGroup);
		return ApiResult.success();
	}


	@RequiresPermissions("actyw:actYwGroup:edit")
	@RequestMapping(value = "save")
	public String save(ActYwGroup actYwGroup, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request) {
		if (!beanValidator(model, actYwGroup)) {
			return form(actYwGroup, model,request);
		}

		if (StringUtil.isEmpty(actYwGroup.getKeyss())) {
		  actYwGroup.setKeyss(SysNodeTool.genByKeyss(SysNoType.NO_FLOW));
		}

	  	Boolean isTrue = actYwGroupService.validKeyss(actYwGroup.getKeyss(), actYwGroup.getIsNewRecord());
		if (!isTrue) {
		  	addMessage(redirectAttributes, "自定义流程惟一标识 ["+actYwGroup.getKeyss()+"] 已经存在，修改失败");
		  	return form(actYwGroup, model,request);
		}

		if (StringUtil.isNotEmpty(actYwGroup.getStatus()) && (!actYwGroup.getTemp()) && (actYwGroup.getStatus()).equals(ActYwGroup.GROUP_DEPLOY_1)) {
		  	isTrue = true;
		}

	  	if (!isTrue) {
			addMessage(redirectAttributes, "流程不合法,没有流程节点，修改失败!");
			return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGroup/?repage";
	  	}

		actYwGroupService.save(actYwGroup);
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGroup/?repage";
	}

	/*王清腾添加下一步*/
	@ResponseBody
	@RequestMapping(value = "ajaxSave")
	public ApiTstatus<String> ajaxSave(ActYwGroup actYwGroup, Model model) {
		ApiTstatus<String> req = new ApiTstatus<String>();
		if (!beanValidator(model, actYwGroup)) {
			req.setStatus(false);
			req.setMsg("自定义流程不合格，请检查");
			return req;
		}

		if (StringUtil.isEmpty(actYwGroup.getKeyss())) {
			actYwGroup.setKeyss(SysNodeTool.genByKeyss(SysNoType.NO_FLOW));
		}

		Boolean isTrue = actYwGroupService.validKeyss(actYwGroup.getKeyss(), actYwGroup.getIsNewRecord());
		if (!isTrue) {
			req.setStatus(false);
			req.setMsg("自定义流程不合格，请检查");
			return req;
		}

		if (StringUtil.isNotEmpty(actYwGroup.getStatus()) && (!actYwGroup.getTemp()) && (actYwGroup.getStatus()).equals(ActYwGroup.GROUP_DEPLOY_1)) {
			isTrue = true;
		}

		if (!isTrue) {
			req.setStatus(false);
			req.setMsg("流程不合法,没有流程节点，修改失败!");
			return req;
		}

		actYwGroupService.save(actYwGroup);
		req.setStatus(true);
		req.setMsg("自定义流程执行成功");
		req.setDatas(actYwGroup.getId());
		return req;
	}

	@RequiresPermissions("actyw:actYwGroup:edit")
	@RequestMapping(value = "delete")
	public String delete(ActYwGroup actYwGroup, RedirectAttributes redirectAttributes) {
		try {
			actYwGroupService.deleteCheck(actYwGroup);
			addMessage(redirectAttributes, "删除自定义流程成功");
		} catch (Exception e){
			addMessage(redirectAttributes, "删除自定义流程失败");
		}
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwGroup/?repage";
	}
	@RequestMapping(value = "delActYwGroup", method = RequestMethod.POST, produces = "application/json")
	@ResponseBody
	public ApiResult delActYwGroup(@RequestBody ActYwGroup actYwGroup){
		try {
			actYwGroupService.deleteCheck(actYwGroup);
			return ApiResult.success(actYwGroup);
		}catch (Exception e){
			logger.error(e.getMessage());
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}

}