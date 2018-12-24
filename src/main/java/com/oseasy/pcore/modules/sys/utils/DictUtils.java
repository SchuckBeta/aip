/**
 *
 */
package com.oseasy.pcore.modules.sys.utils;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.oseasy.pcore.common.mapper.JsonMapper;
import com.oseasy.pcore.common.utils.CacheUtils;
import com.oseasy.pcore.common.utils.SpringContextHolder;
import com.oseasy.pcore.modules.sys.dao.DictDao;
import com.oseasy.pcore.modules.sys.entity.Dict;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 字典工具类


 */
public class DictUtils {
	private static DictDao dictDao = SpringContextHolder.getBean(DictDao.class);

	public static final String CACHE_DICT_MAP = "dictMap";

	public static Dict getProDict(String type) {
	    if (StringUtils.isNotBlank(type)) {
	        return dictDao.getByValue(type);
	    }
	    return null;
	}
	public static String getDictLabelByBoolean(Boolean value, String type, String defaultValue) {
		if (StringUtils.isNotBlank(type)) {
			for (Dict dict : getDictList(type)) {
				if (type.equals(dict.getType()) && (value == Boolean.parseBoolean(dict.getValue()))) {
					return dict.getLabel();
				}
			}
		}
		return defaultValue;
	}

	public static String getDictLabel(String value, String type, String defaultValue) {
	  if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(value)) {
	    for (Dict dict : getDictList(type)) {
	      if (type.equals(dict.getType()) && value.equals(dict.getValue())) {
	        return dict.getLabel();
	      }
	    }
	  }
	  return defaultValue;
	}

	public static String getDictLabels(String values, String type, String defaultValue) {
		if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(values)) {
			List<String> valueList = Lists.newArrayList();
			for (String value : StringUtils.split(values, ",")) {
				valueList.add(getDictLabel(value, type, defaultValue));
			}
			return StringUtils.join(valueList, ",");
		}
		return defaultValue;
	}

	public static String getDictValue(String label, String type, String defaultLabel) {
		if (StringUtils.isNotBlank(type) && StringUtils.isNotBlank(label)) {
			for (Dict dict : getDictList(type)) {
				if (type.equals(dict.getType()) && label.equals(dict.getLabel())) {
					return dict.getValue();
				}
			}
		}
		return defaultLabel;
	}
	public static Dict getDictByLabel(String type,String label) {
		List<Dict> list=getDictList(type);
		if (list!=null&&!list.isEmpty()) {
			for(Dict d:list) {
				if (d.getLabel().equals(label)) {
					return d;
				}
			}
		}else{
			return null;
		}
		return null;
	}
	public static List<Dict> getDictList(String type) {
		@SuppressWarnings("unchecked")
		Map<String, List<Dict>> dictMap = (Map<String, List<Dict>>)CacheUtils.get(CACHE_DICT_MAP);
		if (dictMap==null||dictMap.size()==0) {
			dictMap = Maps.newHashMap();
			for (Dict dict : dictDao.findAllList(new Dict())) {
				List<Dict> dictList = dictMap.get(dict.getType());
				if (dictList != null) {
					dictList.add(dict);
				}else{
					dictMap.put(dict.getType(), Lists.newArrayList(dict));
				}
			}
			CacheUtils.put(CACHE_DICT_MAP, dictMap);
		}
		List<Dict> dictList = dictMap.get(type);
		if (dictList == null) {
			dictList = Lists.newArrayList();
		}
		return dictList;
	}

	/**
	 * 返回字典列表（JSON）
	 * @param type
	 * @return
	 */
	public static String getDictListJson(String type) {
		return JsonMapper.toJsonString(getDictList(type));
	}

	public static List<Dict> getDictListByType(String type) {
		Dict dict = new Dict();
		dict.setType(type);
		return dictDao.findList(dict);
	}

	public static String[] convertArrays(String key){
	    List<Dict> list = DictUtils.getDictList(key);
        if(StringUtil.checkEmpty(list)){
            return null;
        }

        String[] temlist = new String[list.size()];
        for (int i = 0; i < list.size(); i++) {
            if(list.get(i) == null){
                continue;
            }
            temlist[i] = list.get(i).getLabel();
        }
        return temlist;
	}
}
