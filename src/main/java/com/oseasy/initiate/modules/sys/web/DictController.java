/**
 *
 */
package com.oseasy.initiate.modules.sys.web;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oseasy.initiate.common.utils.IdUtils;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.Dict;
import com.oseasy.pcore.modules.sys.service.DictService;
import com.oseasy.pcore.modules.sys.utils.DictUtils;
import com.oseasy.putil.common.utils.StringUtil;

import net.sf.json.JSONObject;

/**
 * 字典Controller

 * @version 2014-05-16
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/dict")
public class DictController extends BaseController {
	@Autowired
	private DictService dictService;

	@ModelAttribute
	public Dict get(@RequestParam(required=false) String id) {
		if (StringUtil.isNotBlank(id)) {
			return dictService.get(id);
		}else{
			return new Dict();
		}
	}
	/*修改字典*/
	@RequiresPermissions("sys:dict:edit")
	@RequestMapping(value = "edtDict")
	@ResponseBody
	public JSONObject edtDict(HttpServletRequest request, HttpServletResponse response) {
		String id=request.getParameter("id");
		String name=request.getParameter("name");
		String sort=request.getParameter("sort");
		return dictService.edtDict(id,name,sort);
	}
	/*新增字典*/
	@RequiresPermissions("sys:dict:edit")
	@RequestMapping(value = "addDict")
	@ResponseBody
	public JSONObject addDict(HttpServletRequest request, HttpServletResponse response) {
		String typeid=request.getParameter("typeid");
		String name=request.getParameter("name");
		String sort=request.getParameter("sort");
		return dictService.addDict(typeid,name,sort, IdUtils.getDictNumberByDb());
	}
	/*删除字典类型或字典*/
	@RequiresPermissions("sys:dict:edit")
	@RequestMapping(value = "delDictType")
	@ResponseBody
	public JSONObject delDictType(HttpServletRequest request, HttpServletResponse response) {
		String id=request.getParameter("id");
		return dictService.delDictType(id);
	}
	/*修改字典类型*/
	@RequiresPermissions("sys:dict:edit")
	@RequestMapping(value = "edtDictType")
	@ResponseBody
	public JSONObject edtDictType(HttpServletRequest request, HttpServletResponse response) {
		String id=request.getParameter("id");
		String name=request.getParameter("name");
		return dictService.edtDictType(id,name);
	}
	/*新增字典类型*/
	@RequiresPermissions("sys:dict:edit")
	@RequestMapping(value = "addDictType")
	@ResponseBody
	public JSONObject addDictType(HttpServletRequest request, HttpServletResponse response) {
		String name=request.getParameter("name");
		return dictService.addDictType(name, IdUtils.getDictNumberByDb());
	}
	/*获取字典分页数据*/
	@RequiresPermissions("sys:dict:view")
	@RequestMapping(value = "getDictPagePlus")
	@ResponseBody
	public Page<Map<String,String>> getDictPagePlus(HttpServletRequest request, HttpServletResponse response) {
		Map<String,Object> param =new HashMap<String,Object>();
		param.put("typeid", request.getParameter("typeid"));
		param.put("name", request.getParameter("name"));
		Page<Map<String,String>> page = dictService.getDictPagePlus(new Page<Map<String,String>>(request, response), param);
		return page;
	}
	/*获取全部字典类型*/
	@RequiresPermissions("sys:dict:view")
	@RequestMapping(value = "getDictTypeListPlus")
	@ResponseBody
	public List<Map<String, String>> getDictTypeListPlus() {
		return dictService.getDictTypeListPlus();
	}

	@RequiresPermissions("sys:dict:edit")
	@RequestMapping(value = "modifyOldData")
	@ResponseBody
	public String modifyOldData() {
		dictService.modifyOldData();
		return "1";
	}
	@RequiresPermissions("sys:dict:view")
	@RequestMapping(value = {"listPlus"})
	public String listPlus(Dict dict, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/sys/dictListPlus";
	}

	@RequestMapping(value="getDictList", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public List<Dict> getDictList(String type){
		return DictUtils.getDictList(type);
	}
	/*
	@RequiresPermissions("sys:dict:view")
	@RequestMapping(value = {"list", ""})
	public String list(Dict dict, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<String> typeList = dictService.findTypeList();
		model.addAttribute("typeList", typeList);
        Page<Dict> page = dictService.findPage(new Page<Dict>(request, response), dict);
        model.addAttribute("page", page);
		return "modules/sys/dictList";
	}

	@RequiresPermissions("sys:dict:view")
	@RequestMapping(value = "form")
	public String form(Dict dict, Model model) {
		model.addAttribute("dict", dict);
		return "modules/sys/dictForm";
	}

	@RequiresPermissions("sys:dict:edit")
	@RequestMapping(value = "save")//@Valid
	public String save(Dict dict, Model model, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return CoreSval.REDIRECT + adminPath + "/sys/dict/?repage&type="+dict.getType();
		}
		if (!beanValidator(model, dict)) {
			return form(dict, model);
		}
		dictService.save(dict);
		addMessage(redirectAttributes, "保存字典'" + dict.getLabel() + "'成功");
		return CoreSval.REDIRECT + adminPath + "/sys/dict/?repage&type="+dict.getType();
	}

	@RequiresPermissions("sys:dict:edit")
	@RequestMapping(value = "delete")
	public String delete(Dict dict, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return CoreSval.REDIRECT + adminPath + "/sys/dict/?repage";
		}
		dictService.delete(dict);
		addMessage(redirectAttributes, "删除字典成功");
		return CoreSval.REDIRECT + adminPath + "/sys/dict/?repage&type="+dict.getType();
	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String type, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		Dict dict = new Dict();
		dict.setType(type);
		List<Dict> list = dictService.findList(dict);
		for (int i=0; i<list.size(); i++) {
			Dict e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getId());
			map.put("pId", e.getParentId());
			map.put("name", StringUtil.replace(e.getLabel(), " ", ""));
			mapList.add(map);
		}
		return mapList;
	}

	@ResponseBody
	@RequestMapping(value = "listData")
	public List<Dict> listData(@RequestParam(required=false) String type) {
		Dict dict = new Dict();
		dict.setType(type);
		return dictService.findList(dict);
	}
 */

//	@RequestMapping(value="getCurJoinProjects", method = RequestMethod.GET, produces = "application/json")
//	@ResponseBody
//	public List<Dict> getCurJoinProjects(){
//		return ScoUtils.getPublishDictList();
//	}
}
