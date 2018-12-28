package com.oseasy.pcms.modules.cmss.web.a;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.authz.annotation.RequiresUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.oseasy.initiate.common.config.SysIds;
import com.oseasy.pcms.modules.cmss.entity.CmssCategory;
import com.oseasy.pcms.modules.cmss.service.CmssCategoryService;
import com.oseasy.pcore.common.config.ApiConst;
import com.oseasy.pcore.common.config.ApiResult;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 栏目管理Controller.
 * @author liangjie
 * @version 2018-08-30
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/category")
public class CmssCategoryAcontroller extends BaseController {

    @Autowired
    private CmssCategoryService cmssCategoryService;
//    @Autowired
//    private FileTplService fileTplService;
//    @Autowired
//    private SiteService siteService;

    @ModelAttribute("category")
    public CmssCategory get(@RequestParam(required=false) String id) {
        if (StringUtil.isNotBlank(id)) {
            return cmssCategoryService.get(id);
        }else{
            return new CmssCategory();
        }
    }

    @RequiresPermissions("cms:category:view")
    @RequestMapping(value = {"list", ""})
    public String list(Model model) {
        /*List<Category> list = Lists.newArrayList();
        List<Category> sourcelist = cmssCategoryService.find(true, null);
        Category.sortList(list, sourcelist, SysIds.SITE_CATEGORYS_SYS_ROOT.getId());
        model.addAttribute("list", list);
//        return "modules/cms/categoryList";*/
        return "modules/cms/cmsCategoryList";
    }

    @RequiresPermissions("cms:category:view")
    @RequestMapping(value = "form")
    public String form(CmssCategory category, Model model, HttpServletRequest request) {
        if (category.getParent()==null||category.getParent().getId()==null) {
            category.setParent(new CmssCategory(SysIds.SITE_CATEGORYS_SYS_ROOT.getId()));
        }
        CmssCategory parent = cmssCategoryService.get(category.getParent().getId());
        category.setParent(parent);
//        if (category.getOffice()==null||category.getOffice().getId()==null) {
//            category.setOffice(parent.getOffice());
//        }
        //model.addAttribute("listViewList",getTplContent(Category.DEFAULT_TEMPLATE, request));
        model.addAttribute("category_DEFAULT_TEMPLATE",CmssCategory.DEFAULT_TEMPLATE);
        //model.addAttribute("contentViewList",getTplContent(Article.DEFAULT_TEMPLATE, request));
//        model.addAttribute("article_DEFAULT_TEMPLATE",Article.DEFAULT_TEMPLATE);
//        model.addAttribute("office", category.getOffice());
        model.addAttribute("office", "");
        model.addAttribute("category", category);
        model.addAttribute("parentId", request.getParameter("parentId"));
//        return "modules/cms/categoryForm";
        return "modules/cms/cmsCategoryForm";
    }

    @RequiresPermissions("cms:category:edit")
    @RequestMapping(value = "save")
    public String save(CmssCategory category, Model model, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        if (Global.isDemoMode()) {
            addMessage(redirectAttributes, "演示模式，不允许操作！");
            return CoreSval.REDIRECT + adminPath + "/cms/category/";
        }
        if (!beanValidator(model, category)) {
            return form(category, model, request);
        }
        cmssCategoryService.save(category);
        addMessage(redirectAttributes, "保存栏目'" + category.getName() + "'成功");
        return CoreSval.REDIRECT + adminPath + "/cms/category/";
    }

    @RequiresPermissions("cms:category:edit")
    @RequestMapping(value = "delete")
    public String delete(CmssCategory category, RedirectAttributes redirectAttributes) {
        if (Global.isDemoMode()) {
            addMessage(redirectAttributes, "演示模式，不允许操作！");
            return CoreSval.REDIRECT + adminPath + "/cms/category/";
        }
        if (CmssCategory.isRoot(category.getId())) {
            addMessage(redirectAttributes, "删除栏目失败, 不允许删除顶级栏目或编号为空");
        }else{
            cmssCategoryService.delete(category);
            addMessage(redirectAttributes, "删除栏目成功");
        }
        return CoreSval.REDIRECT + Global.getAdminPath() + "/cms/category/";
    }

    /**
     * 批量修改栏目排序
     */
    @RequiresPermissions("cms:category:edit")
    @RequestMapping(value = "updateSort")
    public String updateSort(String[] ids, Integer[] sorts, RedirectAttributes redirectAttributes) {
        int len = ids.length;
        CmssCategory[] entitys = new CmssCategory[len];
        for (int i = 0; i < len; i++) {
            entitys[i] = cmssCategoryService.get(ids[i]);
            entitys[i].setSort(sorts[i]);
            cmssCategoryService.save(entitys[i]);
        }
        addMessage(redirectAttributes, "保存栏目排序成功!");
        return CoreSval.REDIRECT + adminPath + "/cms/category/";
    }

    @RequiresUser
    @ResponseBody
    @RequestMapping(value = "treeData")
    public List<Map<String, Object>> treeData(String module, @RequestParam(required=false) String extId, HttpServletResponse response) {
        response.setContentType("application/json; charset=UTF-8");
        List<Map<String, Object>> mapList = Lists.newArrayList();
        List<CmssCategory> list = cmssCategoryService.find(true, module);
        for (int i=0; i<list.size(); i++) {
            CmssCategory e = list.get(i);
            if (extId == null || (extId!=null && !extId.equals(e.getId()) && e.getParentIds().indexOf(","+extId+",")==-1)) {
                Map<String, Object> map = Maps.newHashMap();
                map.put("id", e.getId());
                map.put("pId", e.getParent()!=null?e.getParent().getId():0);
                map.put("name", e.getName());
                map.put("module", e.getModule());
                mapList.add(map);
            }
        }
        return mapList;
    }

    private List<String> getTplContent(String prefix, HttpServletRequest request) {
//        fileTplService.setContext(request);
//        List<String> tplList = fileTplService.getNameListByPrefix(siteService.get(Site.getCurrentSiteId()).getCmsSiteconfig().getSolutionPath());
//        tplList = TplUtils.tplTrim(tplList, prefix, "");
//        return tplList;
        return null;
    }

	/**
	 栏目管理列表查询接口
	 */
	@RequestMapping(value = "cmsCategoryList", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	@ResponseBody
	public ApiResult cmsCategoryList(CmssCategory cmsCategory, HttpServletRequest request, HttpServletResponse response) {
        Page pages =new Page<CmssCategory>(request, response);
        pages.setPageSize(10000);
	    Page<CmssCategory> page = cmssCategoryService.findPage(pages, cmsCategory);
		try {
			return ApiResult.success(page);

		}catch (Exception e){
			logger.error(e.getMessage());

			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}

	//栏目列表
    @RequestMapping(value="cmsCategoryAllList")
    @ResponseBody
    public ApiResult cmsCategoryAllList(CmssCategory cmsCategory){
	    List<CmssCategory> cmsCategoryAllList = cmssCategoryService.findList(cmsCategory);
        try {
	        return ApiResult.success(cmsCategoryAllList);
        }catch (Exception e){
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }


	/**
	 添加保存，修改保存接口
	 */
	@RequestMapping(value="editSaveCmsCategory", method = RequestMethod.POST, produces = "application/json")
	@ResponseBody
	public ApiResult editSaveCmsCategory(CmssCategory cmsCategory){
	    CmssCategory categoryTemp = new CmssCategory();
	    categoryTemp.setPublishCategory(cmsCategory.getPublishCategory());
	    List<CmssCategory> category = cmssCategoryService.findList(categoryTemp);
	    if( category.size() >0 && StringUtil.isNotBlank(cmsCategory.getPublishCategory()) && !category.get(0).getId().equals(cmsCategory.getId())){
            return ApiResult.failed(ApiConst.CODE_CATEGORYMORE_ERROR,ApiConst.getErrMsg(ApiConst.CODE_CATEGORYMORE_ERROR));
        }else{
            if(null != cmsCategory.getId() && StringUtil.isNotBlank(cmsCategory.getId())){
                //修改保存
                cmssCategoryService.update(cmsCategory);
                return ApiResult.success();
            }else{
                //添加保存
                try {
                    cmsCategory.setIsSys(0);
                    cmssCategoryService.save(cmsCategory);
                    return ApiResult.success();
                }catch (Exception e){
                    e.printStackTrace();
                    return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
                }
            }
        }


	}

	/**
	 删除接口
	 */
	@RequestMapping(value = "deleteCmsCategory")
    @ResponseBody
	public ApiResult deleteCmsCategory(CmssCategory cmsCategory){
		try{
			cmssCategoryService.deleteByCheck(cmsCategory);
			return ApiResult.success();
		}catch (Exception e){
			e.printStackTrace();
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}
	/**
	 显示与隐藏
	 */
	@RequestMapping(value = "updateShow")
	@ResponseBody
	public ApiResult updateShow(CmssCategory cmsCategory){
		try{
			cmssCategoryService.update(cmsCategory);
			return ApiResult.success();
		}catch (Exception e){
			e.printStackTrace();
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}


	/**
	 批量修改栏目排序
	 */
	@RequestMapping(value = "ajaxUpdateSort")
	@ResponseBody
	public ApiResult updateSort(String ids,String sorts){
		try{
			cmssCategoryService.updateOrder(ids,sorts);
			return ApiResult.success();
		}catch (Exception e){
			e.printStackTrace();
			return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
		}
	}
}