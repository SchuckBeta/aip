package com.oseasy.pcms.modules.cms.web.a;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oseasy.pcore.common.config.ApiConst;
import com.oseasy.pcore.common.config.ApiParam;
import com.oseasy.pcore.common.config.ApiResult;
import com.oseasy.pcore.common.config.CoreJkey;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.pcms.modules.cms.entity.CmsTheme;
import com.oseasy.pcms.modules.cms.service.CmsThemeService;

/**
 * 主题Controller.
 * @author chenhao
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmsTheme")
public class CmsThemeRestController extends BaseController {

	@Autowired
	private CmsThemeService entityService;

	@ModelAttribute
	public CmsTheme get(@RequestParam(required=false) String id) {
		CmsTheme entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmsTheme();
		}
		return entity;
	}

    @ResponseBody
	@RequestMapping(value = "ajaxList")
    public ApiResult ajaxlist(CmsTheme entity, HttpServletRequest request, HttpServletResponse response, Model model) {
        try {
            Page<CmsTheme> page = entityService.findPage(new Page<CmsTheme>(request, response), entity);
            return ApiResult.success(page);
        }catch (Exception e){
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping(value = "ajaxSave", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    public ApiResult ajaxSave(@RequestBody CmsTheme entity, HttpServletRequest request, HttpServletResponse response, Model model) {
        try {
            if (!beanValidator(model, entity)){
                return ApiResult.failed(ApiConst.CODE_PARAM_ERROR_CODE,ApiConst.getErrMsg(ApiConst.CODE_PARAM_ERROR_CODE)+":参数校验失败！");
            }
            entityService.save(entity);
            return ApiResult.success(entity);
        }catch (Exception e){
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }


    @ResponseBody
    @RequestMapping(value = "ajaxDelete")
    public ApiResult ajaxDelete(CmsTheme entity, HttpServletRequest request, HttpServletResponse response, Model model) {
        try {
            if (StringUtil.isEmpty(entity.getId())){
                return ApiResult.failed(ApiConst.CODE_PARAM_ERROR_CODE,ApiConst.getErrMsg(ApiConst.CODE_PARAM_ERROR_CODE)+":参数校验失败，ID标识和操作不能为空！");
            }
            entityService.delete(entity);
            return ApiResult.success(entity);
        }catch (Exception e){
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }

    @ResponseBody
    @RequestMapping(value = "ajaxDeletePL", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    public ApiResult ajaxDeletePL(@RequestBody CmsTheme entity, HttpServletRequest request, HttpServletResponse response, Model model) {
        try {
            if (StringUtil.checkEmpty(entity.getIds())){
                return ApiResult.failed(ApiConst.CODE_PARAM_ERROR_CODE,ApiConst.getErrMsg(ApiConst.CODE_PARAM_ERROR_CODE)+":参数校验失败，ID标识和操作不能为空！");
            }
            entityService.deletePL(entity);
            return ApiResult.success(entity);
        }catch (Exception e){
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }

}