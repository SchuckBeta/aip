package com.oseasy.initiate.modules.cms.web;

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
import com.oseasy.initiate.modules.cms.entity.CmsSite;
import com.oseasy.initiate.modules.cms.service.CmsSiteService;

/**
 * 站点Controller.
 * @author chenh
 * @version 2018-12-25
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/cmsSite")
public class CmsSiteController extends BaseController {

	@Autowired
	private CmsSiteService entityService;

	@ModelAttribute
	public CmsSite get(@RequestParam(required=false) String id) {
		CmsSite entity = null;
		if (StringUtil.isNotBlank(id)){
			entity = entityService.get(id);
		}
		if (entity == null){
			entity = new CmsSite();
		}
		return entity;
	}

	@RequiresPermissions("cms:cmsSite:view")
	@RequestMapping(value = {"list", ""})
	public String list(CmsSite entity, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<CmsSite> list = entityService.findList(entity);
		model.addAttribute("list", list);
		return "modules/cms/cmsSiteList";
	}

	@RequiresPermissions("cms:cmsSite:view")
	@RequestMapping(value = "form")
	public String form(CmsSite entity, Model model) {
		if (entity.getParent()!=null && StringUtil.isNotBlank(entity.getParent().getId())){
			entity.setParent(entityService.get(entity.getParent().getId()));
			// 获取排序号，最末节点排序号+30
			if (StringUtil.isBlank(entity.getId())){
				CmsSite entityChild = new CmsSite();
				entityChild.setParent(new CmsSite(entity.getParent().getId()));
				List<CmsSite> list = entityService.findList(entity);
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
		model.addAttribute("cmsSite", entity);
		return "modules/cms/cmsSiteForm";
	}

	@RequiresPermissions("cms:cmsSite:edit")
	@RequestMapping(value = "save")
	public String save(CmsSite entity, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, entity)){
			return form(entity, model);
		}
		entityService.save(entity);
		addMessage(redirectAttributes, "保存站点成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsSite/?repage";
	}

	@RequiresPermissions("cms:cmsSite:edit")
	@RequestMapping(value = "delete")
	public String delete(CmsSite entity, RedirectAttributes redirectAttributes) {
		entityService.delete(entity);
		addMessage(redirectAttributes, "删除站点成功");
		return CoreSval.REDIRECT+Global.getAdminPath()+"/cms/cmsSite/?repage";
	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<CmsSite> list = entityService.findList(new CmsSite());
		for (int i=0; i<list.size(); i++){
			CmsSite e = list.get(i);
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