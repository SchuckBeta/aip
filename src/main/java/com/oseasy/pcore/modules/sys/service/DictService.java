/**
 *
 */
package com.oseasy.pcore.modules.sys.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.pcore.common.utils.CacheUtils;
import com.oseasy.pcore.modules.sys.dao.DictDao;
import com.oseasy.pcore.modules.sys.entity.Dict;
import com.oseasy.pcore.modules.sys.utils.DictUtils;
import com.oseasy.putil.common.utils.StringUtil;

import net.sf.json.JSONObject;

/**
 * 字典Service
 * @version 2014-05-16
 */
@Service
@Transactional(readOnly = true)
public class DictService extends CrudService<DictDao, Dict> {
	private static Logger logger = LoggerFactory.getLogger(DictService.class);
	@Transactional(readOnly = false)
	public JSONObject edtDict(String id,String name,String sort) {
		int sortint=0;
		JSONObject js=new JSONObject();
		js.put("ret", "1");
		js.put("msg", "修改成功");
		if (StringUtil.isEmpty(id)) {
			js.put("ret", "0");
			js.put("msg", "请选择字典类型");
			return js;
		}
		if (StringUtil.isEmpty(name)) {
			js.put("ret", "0");
			js.put("msg", "请填写字典名称");
			return js;
		}
		/*try {
			name=URLDecoder.decode(name, "utf-8");
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage());
			js.put("ret", "0");
			js.put("msg", "编码错误");
			return js;
		}*/
		if (!StringUtil.isEmpty(sort)) {
			try {
				sortint=Integer.parseInt(sort);
			} catch (Exception e) {
				js.put("ret", "0");
				js.put("msg", "排序编号只能是数字");
				return js;
			}
			if (sort.length()>10) {
				js.put("ret", "0");
				js.put("msg", "排序编号不能超过10个字符");
				return js;
			}
		}
		if (name.length()>100) {
			js.put("ret", "0");
			js.put("msg", "名称不能超过100个字符");
			return js;
		}
		Dict d=dao.get(id);
		if (d==null||"1".equals(d.getDelFlag())) {
			js.put("ret", "0");
			js.put("msg", "该字典已被删除");
			return js;
		}
		Map<String,String> param=new HashMap<String,String>();
		param.put("name", name);
		param.put("id", id);
		param.put("typeid", d.getParentId());
		int count=dao.getDictCountByCdn(param);
		if (count>0) {
			js.put("ret", "0");
			js.put("msg", "已经存在该名称的字典");
			return js;
		}
		d.setLabel(name);
		d.setSort(sortint);
		try {
			this.save(d);
		} catch (Exception e) {
			logger.error(e.getMessage());
			js.put("ret", "0");
			js.put("msg", "系统异常");
			return js;
		}
		CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
		return js;
	}

	@Transactional(readOnly = false)
	public JSONObject addDict(String typeid,String name,String sort, String value) {
		int sortint=0;
		JSONObject js=new JSONObject();
		js.put("ret", "1");
		js.put("msg", "添加成功");
		if (StringUtil.isEmpty(typeid)) {
			js.put("ret", "0");
			js.put("msg", "请选择字典类型");
			return js;
		}
		if (StringUtil.isEmpty(name)) {
			js.put("ret", "0");
			js.put("msg", "请填写字典名称");
			return js;
		}
		/*try {
			name=URLDecoder.decode(name, "utf-8");
		} catch (UnsupportedEncodingException e) {
			logger.error(e.getMessage());
			js.put("ret", "0");
			js.put("msg", "编码错误");
			return js;
		}*/
		if (!StringUtil.isEmpty(sort)) {
			try {
				sortint=Integer.parseInt(sort);
			} catch (Exception e) {
				js.put("ret", "0");
				js.put("msg", "排序编号只能是数字");
				return js;
			}
			if (sort.length()>10) {
				js.put("ret", "0");
				js.put("msg", "排序编号不能超过10个字符");
				return js;
			}
		}
		if (name.length()>100) {
			js.put("ret", "0");
			js.put("msg", "名称不能超过100个字符");
			return js;
		}
		Dict dicttype=dao.get(typeid);
		if (dicttype==null||"1".equals(dicttype.getDelFlag())) {
			js.put("ret", "0");
			js.put("msg", "所属类型已被删除");
			return js;
		}
		Map<String,String> param=new HashMap<String,String>();
		param.put("name", name);
		param.put("typeid", typeid);
		int count=dao.getDictCountByCdn(param);
		if (count>0) {
			js.put("ret", "0");
			js.put("msg", "已经存在该名称的字典");
			return js;
		}
		Dict d=new Dict();
		d.setLabel(name);
		d.setValue(value);
		d.setType(dicttype.getValue());
		d.setIsSys("0");
		d.setSort(sortint);
		d.setParentId(dicttype.getId());
		try {
			this.save(d);
			js.put("val", d.getValue());
		} catch (Exception e) {
			logger.error(e.getMessage());
			js.put("ret", "0");
			js.put("msg", "系统异常");
			return js;
		}
		CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
		return js;
	}
	@Transactional(readOnly = false)
	public JSONObject delDictType(String id) {
		JSONObject js=new JSONObject();
		js.put("ret", "1");
		js.put("msg", "删除成功");
		if (StringUtil.isEmpty(id)) {
			js.put("ret", "0");
			js.put("msg", "参数错误，没有id");
			return js;
		}
		Dict d=dao.get(id);
		if (d==null||"1".equals(d.getDelFlag())) {
			js.put("ret", "0");
			js.put("msg", "该字典类型已被删除");
			return js;
		}
		if ("1".equals(d.getIsSys())) {
			js.put("ret", "0");
			js.put("msg", "该字典类型属于系统数据，不能被删除");
			return js;
		}
		try {
			dao.delDictType(id);
		} catch (Exception e) {
			logger.error(e.getMessage());
			js.put("ret", "0");
			js.put("msg", "系统异常");
			return js;
		}
		CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
		return js;
	}
	@Transactional(readOnly = false)
	public JSONObject edtDictType(String id,String name) {
		JSONObject js=new JSONObject();
		js.put("ret", "1");
		js.put("msg", "修改成功");
		if (StringUtil.isEmpty(id)) {
			js.put("ret", "0");
			js.put("msg", "参数错误，没有id");
			return js;
		}
		if (StringUtil.isEmpty(name)) {
			js.put("ret", "0");
			js.put("msg", "请填写类型名称");
			return js;
		}
		/*try {
			name=URLDecoder.decode(name, "utf-8");
		} catch (UnsupportedEncodingException e) {
			js.put("ret", "0");
			js.put("msg", "编码错误");
			return js;
		}*/
		if (name.length()>100) {
			js.put("ret", "0");
			js.put("msg", "名称不能超过100个字符");
			return js;
		}
		Dict d=dao.get(id);
		if (d==null||"1".equals(d.getDelFlag())) {
			js.put("ret", "0");
			js.put("msg", "该字典类型已被删除");
			return js;
		}
		Map<String,String> param=new HashMap<String,String>();
		param.put("name", name);
		param.put("id", id);
		int count=dao.getDictTypeCountByCdn(param);
		if (count>0) {
			js.put("ret", "0");
			js.put("msg", "已经存在该名称的字典类型");
			return js;
		}
		d.setLabel(name);
		try {
			this.save(d);
		} catch (Exception e) {
			logger.error(e.getMessage());
			js.put("ret", "0");
			js.put("msg", "系统异常");
			return js;
		}
		CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
		return js;
	}
	@Transactional(readOnly = false)
	public JSONObject addDictType(String name, String value) {
		JSONObject js=new JSONObject();
		js.put("ret", "1");
		js.put("msg", "添加成功");
		if (StringUtil.isEmpty(name)) {
			js.put("ret", "0");
			js.put("msg", "请填写类型名称");
			return js;
		}
		/*try {
			name=URLDecoder.decode(name, "utf-8");
		} catch (UnsupportedEncodingException e) {
			js.put("ret", "0");
			js.put("msg", "编码错误");
			return js;
		}*/
		if (name.length()>100) {
			js.put("ret", "0");
			js.put("msg", "名称不能超过100个字符");
			return js;
		}
		Map<String,String> param=new HashMap<String,String>();
		param.put("name", name);
		int count=dao.getDictTypeCountByCdn(param);
		if (count>0) {
			js.put("ret", "0");
			js.put("msg", "已经存在该名称的字典类型");
			return js;
		}
		Dict d=new Dict();
		d.setLabel(name);
		d.setValue(value);
		d.setIsSys("0");
		d.setParentId("0");
		try {
			this.save(d);
		} catch (Exception e) {
			logger.error(e.getMessage());
			js.put("ret", "0");
			js.put("msg", "系统异常");
			return js;
		}
		CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
		return js;
	}
	public Page<Map<String,String>>  getDictPagePlus(Page<Map<String,String>> page,Map<String,Object> param) {
		if (page.getPageNo()<=0) {
			page.setPageNo(1);
		}
		int count=dao.getDictListPlusCount(param);
		param.put("offset", (page.getPageNo()-1)*page.getPageSize());
		param.put("pageSize", page.getPageSize());
		List<Map<String,String>> list=null;
		if (count>0) {
			list=dao.getDictListPlus(param);
		}
		page.setCount(count);
		page.setList(list);
		page.initialize();
		return page;
	}
	public List<Map<String, String>> getDictTypeListPlus() {
		return dao.getDictTypeListPlus();
	}

	/**
	 * 查询字段类型列表
	 * @return
	 */
	public List<String> findTypeList() {
		return dao.findTypeList(new Dict());
	}

	public Dict findDictByValue(String value){
		return dao.getByValue(value);
	}


	@Transactional(readOnly = false)
	public void modifyOldData() {
		List<Dict> dlist=dao.getAllData();
		if (dlist!=null&&dlist.size()>0) {
			Map<String,Dict> parentMap=new HashMap<String,Dict>();
			for(Dict d:dlist) {
				Dict pd=parentMap.get(d.getType());
				if (pd==null) {
					pd=new Dict();
					pd.setValue(d.getType());
					pd.setLabel(d.getDescription());
					pd.setDescription(d.getDescription());
					pd.setParentId("0");
					pd.setIsSys("1");
					this.save(pd);
					parentMap.put(d.getType(), pd);
				}
				d.setParentId(pd.getId());
				d.setIsSys("1");
				this.save(d);
			}
		}
		CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
	}
	@Transactional(readOnly = false)
	public void save(Dict dict) {
		super.save(dict);
		CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
	}

	@Transactional(readOnly = false)
	public void delete(Dict dict) {
		super.delete(dict);
		CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
	}

}
