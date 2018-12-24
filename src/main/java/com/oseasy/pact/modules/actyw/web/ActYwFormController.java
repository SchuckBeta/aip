package com.oseasy.pact.modules.actyw.web;

import java.util.Arrays;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.oseasy.initiate.common.utils.file.impl.FormResourceMngImpl;
import com.oseasy.initiate.modules.proproject.entity.ProProject;
import com.oseasy.initiate.modules.proproject.service.ProProjectService;
import com.oseasy.pact.modules.actyw.entity.ActYwForm;
import com.oseasy.pact.modules.actyw.service.ActYwFormService;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowProjectType;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowType;
import com.oseasy.pact.modules.actyw.tool.process.vo.FormStyleType;
import com.oseasy.pact.modules.actyw.tool.process.vo.FormTheme;
import com.oseasy.pact.modules.actyw.tool.process.vo.FormType;
import com.oseasy.pact.modules.actyw.tool.process.vo.RegType;
import com.oseasy.pcore.common.config.ApiConst;
import com.oseasy.pcore.common.config.ApiResult;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.putil.common.utils.file.FileWrap;

import net.sf.json.JSONObject;

/**
 * 项目流程表单Controller
 * @author chenhao
 * @version 2017-05-23
 */
@Controller
@RequestMapping(value = "${adminPath}/actyw/actYwForm")
public class ActYwFormController extends BaseController {

	@Autowired
	private ActYwFormService actYwFormService;

	@Autowired
	private ProProjectService proProjectService;

	@ModelAttribute
	public ActYwForm get(@RequestParam(required=false) String id) {
		ActYwForm entity = null;
		if (StringUtil.isNotBlank(id)) {
			entity = actYwFormService.get(id);
		}
		if (entity == null) {
			entity = new ActYwForm();
		}
		return entity;
	}

	@RequiresPermissions("actyw:actYwForm:view")
	@RequestMapping(value = {"list", ""})
	public String list(ActYwForm actYwForm, HttpServletRequest request, HttpServletResponse response, Model model) {
		//Page<ActYwForm> page = actYwFormService.findPage(new Page<ActYwForm>(request, response), actYwForm);
		List<ProProject> proProjectList=proProjectService.findList(new ProProject());
		if (proProjectList!=null) {
			model.addAttribute("proProjects",proProjectList);
		}
        ActYwForm pactYwForm = new ActYwForm();
        pactYwForm.setStyleType(FormStyleType.FST_LIST.getKey());
        List<ActYwForm> formLists= actYwFormService.findList(pactYwForm);
        model.addAttribute("formLists", formLists);
//		model.addAttribute("flowTypeAll", FlowType.FWT_ALL);
//        model.addAttribute(FlowType.FLOW_TYPES, FlowType.values());
//		model.addAttribute(FormTheme.FLOW_THEMES, FormTheme.getAll());
//		model.addAttribute("formTypeEnums", FormType.values());
//		model.addAttribute("formStyleTypeEnums", FormStyleType.values());
//		model.addAttribute("formClientTypeEnums", FormClientType.values());
        model.addAttribute("regTypes", RegType.getAll());
        model.addAttribute("filelist", new FormResourceMngImpl().listFile(FormResourceMngImpl.FORM_ROOT, false));
        model.addAttribute("formRoot", FormType.TEMPLATE_FORM_ROOT);
		//model.addAttribute("page", page);
		return "modules/actyw/actYwFormList";
	}

	@RequestMapping(value = "ajaxList")
    @ResponseBody
    public ApiResult ajaxlist(ActYwForm actYwForm, HttpServletRequest request, HttpServletResponse response, Model model) {
        try {
            Page<ActYwForm> page = actYwFormService.findPage(new Page<ActYwForm>(request, response), actYwForm);
            return ApiResult.success(page);
        }catch (Exception e){
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }

	@RequiresPermissions("actyw:actYwForm:view")
	@RequestMapping(value = "form")
	public String form(ActYwForm actYwForm, Model model) {
		model.addAttribute("actYwForm", actYwForm);
		if (StringUtil.isNotEmpty(actYwForm.getType())) {
	    model.addAttribute("formTypeName", FormType.getByKey(actYwForm.getType()).getName());
		}

    FormType[] formTypeEnums =FormType.values();
		ActYwForm pactYwForm = new ActYwForm();
		pactYwForm.setStyleType(FormStyleType.FST_LIST.getKey());
    List<ActYwForm> formLists= actYwFormService.findList(pactYwForm);

        model.addAttribute("formLists", formLists);
		model.addAttribute("flowTypeAll", FlowType.FWT_ALL);
		model.addAttribute("formTypeEnums", formTypeEnums);
		model.addAttribute("formRoot", FormType.TEMPLATE_FORM_ROOT);
        model.addAttribute("projectMarkTypeEnums", FlowProjectType.values());
        model.addAttribute(FormTheme.FLOW_THEMES, FormTheme.getAll());
        model.addAttribute("regTypes", RegType.getAll());

        model.addAttribute("filelist", new FormResourceMngImpl().listFile(FormResourceMngImpl.FORM_ROOT, false));
		return "modules/actyw/actYwFormForm";
	}

	@RequiresPermissions("actyw:actYwForm:edit")
	@RequestMapping(value = "save")
	public String save(ActYwForm actYwForm, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, actYwForm)) {
			return form(actYwForm, model);
		}

		actYwFormService.save(actYwForm);
		addMessage(redirectAttributes, "保存流程表单成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwForm/?repage";
	}

    @ResponseBody
    @RequestMapping(value = "/ajaxSave", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    public ApiResult ajaxSave(@RequestBody JSONObject gps) {
        try {
              Map<String, Class> classMap = new HashMap<String, Class>();
              ActYwForm actYwForm = (ActYwForm) JSONObject.toBean(gps, ActYwForm.class, classMap);
//            if (!beanValidator(model, actYwForm)){
//                return ApiResult.failed(ApiConst.CODE_PARAM_ERROR_CODE,ApiConst.getErrMsg(ApiConst.CODE_PARAM_ERROR_CODE)+":参数校验失败！");
//            }
            actYwFormService.save(actYwForm);
            return ApiResult.success(new ActYwForm(actYwForm.getId()));
        }catch (Exception e){
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }

	@RequiresPermissions("actyw:actYwForm:edit")
	@RequestMapping(value = "delete")
	public String delete(ActYwForm actYwForm, RedirectAttributes redirectAttributes) {
		actYwFormService.delete(actYwForm);
		addMessage(redirectAttributes, "删除流程表单成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/actyw/actYwForm/?repage";
	}

	@RequestMapping(value = "ajaxDelete")
    @ResponseBody
    public ApiResult ajaxDelete(ActYwForm actYwForm, HttpServletRequest request, HttpServletResponse response, Model model) {
        try {
            if (StringUtil.isEmpty(actYwForm.getId())){
                return ApiResult.failed(ApiConst.CODE_PARAM_ERROR_CODE,ApiConst.getErrMsg(ApiConst.CODE_PARAM_ERROR_CODE)+":参数校验失败，ID标识和操作不能为空！");
            }
            actYwFormService.delete(actYwForm);
            return ApiResult.success(actYwForm);
        }catch (Exception e){
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "getFormTypes")
	public List<Map<String, Object>> delete(@RequestParam(required=false) String type, HttpServletResponse response) {
    List<Map<String, Object>> mapList = Lists.newArrayList();
    List<FormType> formTypeEnums = null;
    if (type == null) {
      formTypeEnums = Arrays.asList(FormType.values());
    }else{
      formTypeEnums = FormType.getByType(type);
    }

    for (FormType e : formTypeEnums) {
      Map<String, Object> map = Maps.newHashMap();
      map.put("key", e.getKey());
      map.put("type", Arrays.asList(e.getType()));
      map.put("name", e.getName());
      map.put("value", e.getValue());
      mapList.add(map);
    }
    return mapList;
  }

  /**
   * 获取对应主题和类型的表单模板
   * @param groupId 流程ID
   * @param gnodeId 节点ID
   * @return List
   */
  @ResponseBody
  @RequestMapping(value = "/ajaxFormTpls", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
  public List<FileWrap> ajaxFormTpls(@RequestParam(required = false) Integer themeId,  @RequestParam(required = false) String ftkey) {
      FormTheme ftheme = FormTheme.getById(themeId);
      FormType ftype = FormType.getByKey(ftkey);
      return new FormResourceMngImpl().listFile(FormResourceMngImpl.FORM_ROOT, ftheme, ftype, false);
  }
}