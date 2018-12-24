/**
 *
 */
package com.oseasy.pcore.modules.sys.utils;

import com.oseasy.pcore.common.config.CoreIds;
import com.oseasy.pcore.common.utils.CacheUtils;
import com.oseasy.pcore.common.utils.SpringContextHolder;
import com.oseasy.pcore.modules.sys.dao.OfficeDao;
import com.oseasy.pcore.modules.sys.entity.Office;

/**
 * 工具类
 */
public class OfficeUtils {
	private static OfficeDao officeDao = SpringContextHolder.getBean(OfficeDao.class);
	private static String schoolName="schoolName";
	public static Office getTop() {
		Office o = (Office)CacheUtils.get(CoreUtils.CACHE_OFFICE, CoreIds.SYS_OFFICE_TOP.getId());
		if (o==null) {
			o = officeDao.get(CoreIds.SYS_OFFICE_TOP.getId());
			if (o==null) {
				return o;
			}
			CacheUtils.put(CoreUtils.CACHE_OFFICE, CoreIds.SYS_OFFICE_TOP.getId(),o);
		}
		return o;
	}
	public static Office getOrgByName(String name) {
	    Office o = (Office)CacheUtils.get(CoreUtils.CACHE_OFFICE,name);
	    if (o==null) {
	        o=officeDao.getOrgByName(name);
	        if (o==null) {
	            return o;
	        }
	        CacheUtils.put(CoreUtils.CACHE_OFFICE, name,o);
	    }
	    return o;
	}
	public static Office getSchool() {
		Office o = (Office)CacheUtils.get(CoreUtils.CACHE_OFFICE,schoolName);
		if (o==null) {
			o = officeDao.getSchool();
			if (o==null) {
				return o;
			}
			CacheUtils.put(CoreUtils.CACHE_OFFICE, schoolName,o);
		}
		return o;
	}
	public static Office getOfficeByName(String officename) {
		Office o = (Office)CacheUtils.get(CoreUtils.CACHE_OFFICE,officename);
		if (o==null) {
			o=officeDao.getOfficeByName(officename);
			if (o==null) {
				return o;
			}
			CacheUtils.put(CoreUtils.CACHE_OFFICE, officename,o);
		}
		return o;
	}
	public static Office getProfessionalByName(String pname) {
		Office o=officeDao.getProfessionalByPName(pname);
		return o;
	}
	public static Office getProfessionalByName(String officename, String pname) {
		Office o = (Office)CacheUtils.get(CoreUtils.CACHE_OFFICE, officename+"_"+pname);
		if (o==null) {
			o=officeDao.getProfessionalByName(officename,pname);
			if (o==null) {
				return o;
			}
			CacheUtils.put(CoreUtils.CACHE_OFFICE, officename+"_"+pname,o);
		}
		return o;
	}
	public static void clearCache() {
		CacheUtils.removeAll(CoreUtils.CACHE_OFFICE);;
	}
}
