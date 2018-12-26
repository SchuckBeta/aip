package com.oseasy.pcms.modules.cms.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.pcms.modules.cms.entity.CmstType;
import com.oseasy.pcms.modules.cms.service.CmstTypeService;

/**
 * 模板类型Controller.
 * @author chenh
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmstType")
public class CmstTypeController extends BaseController {

	@Autowired
	private CmstTypeService entityService;

	@ModelAttribute
	public CmstType get(@RequestParam(required=false) String id) {
		CmstType entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmstType();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmstType:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmstType entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<CmstType> list = entityService.findList(entity);
		model.addAttribute("list", list);
		return "modules/cms/cmstTypeList";
	}

	@RequiresPermissions("cms:cmstType:view")
	@RequestMapping(value = "form")
	public String form(CmstType entity, Model model) {
		if (entity.getParent()!=null && StringUtil.isNotBlank(entity.getParent().getId())){
			entity.setParent(entityService.get(entity.getParent().getId()));
			// 获取排序号，最末节点排序号+30
			if (StringUtil.isBlank(entity.getId())){
				CmstType entityChild = new CmstType();
				entityChild.setParent(new CmstType(entity.getParent().getId()));
				List<CmstType> list = entityService.findList(entity);
				if (list.size() > 0){
					entity.setSort(list.get(list.size()-1).getSort());
					if (entity.getSort() != null){
						entity.setSort(entity.getSort() + 30);
					}
				}
			}
		}
		if (entity.getSort() == null){
			entity.setSort(30);
		}
		model.addAttribute("cmstType", entity);
		return "modules/cms/cmstTypeForm";
	}

	@RequiresPermissions("cms:cmstType:edit")
	@RequestMapping(value = "save")
	public String save(CmstType entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存模板类型成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmstType/?repage";
	}

	@RequiresPermissions("cms:cmstType:edit")
	@RequestMapping(value = "delete")
	public String delete(CmstType entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除模板类型成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmstType/?repage";
	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<CmstType> list = entityService.findList(new CmstType());
		for (int i=0; i<list.size(); i++){
			CmstType e = list.get(i);
			if (StringUtil.isBlank(extId) || (extId!=null && !extId.equals(e.getId()) && e.getParentIds().indexOf(","+extId+",")==-1)){
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("name", e.getName());
				mapList.add(map);
			}
		}
		return mapList;
	}

}