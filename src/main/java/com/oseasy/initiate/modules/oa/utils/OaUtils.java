/**
 *
 */
package com.oseasy.initiate.modules.oa.utils;

import java.util.List;

import com.google.common.collect.Lists;
import com.oseasy.initiate.modules.oa.entity.OaNotify;
import com.oseasy.initiate.modules.oa.service.OaNotifyService;
import com.oseasy.initiate.modules.oa.vo.OaNotifySendType;
import com.oseasy.initiate.modules.oa.vo.OaNotifyType;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.utils.CacheUtils;
import com.oseasy.pcore.common.utils.SpringContextHolder;

/**
 * 内容管理工具类


 */
public class OaUtils {
	private static OaNotifyService oaNotifyService = SpringContextHolder.getBean(OaNotifyService.class);

	private static final String OA_CACHE = "oaCache";
	/**
	 * 通知显示最大记录数：5
	 */
	private static final Integer OA_CACHE_NOTIFYS_MAXNUM = 5;

	/**
	 * 获得系统广播通知-双创动态
	 */
	public static List<OaNotify> getOaNotifysSC() {
//		OaNotify oaNotify = new OaNotify();
//		oaNotify.setType(OaNotifyType.SCDT.getVal());
//		oaNotify.setSendType(OaNotifySendType.DIS_DIRECRIONAL.getVal());
//		oaNotify.setStatus("1");
//		return getOaNotifys(SysCacheKeys.OA_CACHE_NOTIFYS_SC, oaNotify);
		return Lists.newArrayList();
	}

	/**
	 * 获得系统广播通知-双创通知
	 */
	public static List<OaNotify> getOaNotifysTZ() {
//		OaNotify oaNotify = new OaNotify();
//		oaNotify.setType(OaNotifyType.SCTZ.getVal());
//		oaNotify.setSendType(OaNotifySendType.DIS_DIRECRIONAL.getVal());
//		oaNotify.setStatus("1");
//		return getOaNotifys(SysCacheKeys.OA_CACHE_NOTIFYS_TZ, oaNotify);
        return Lists.newArrayList();
	}

	/**
	 * 获得系统广播通知-省市动态
	 */
	public static List<OaNotify> getOaNotifysSS() {
//		OaNotify oaNotify = new OaNotify();
//		oaNotify.setType(OaNotifyType.SSDT.getVal());
//		oaNotify.setSendType(OaNotifySendType.DIS_DIRECRIONAL.getVal());
//		oaNotify.setStatus("1");
//		return getOaNotifys(SysCacheKeys.OA_CACHE_NOTIFYS_SS, oaNotify);
        return Lists.newArrayList();
	}

	/**
	 * 根据类型获得系统广播通知
	 */
//	public static List<OaNotify> getOaNotifys(SysCacheKeys key, OaNotify oaNotify) {
//		List<OaNotify> oaNotifys = Lists.newArrayList();
////		禁用缓存
////		List<OaNotify> oaNotifys = (List<OaNotify>)CacheUtils.get(OA_CACHE, key.getKey());
//		if ((oaNotifys ==  null) || (oaNotifys.isEmpty())) {
//			Page<OaNotify> page = new Page<OaNotify>(1, OA_CACHE_NOTIFYS_MAXNUM);
//			page = oaNotifyService.findPage(page, oaNotify);
//			oaNotifys = page.getList();
//			CacheUtils.put(OA_CACHE, key.getKey(), oaNotifys);
//		}
//		return oaNotifys;
//	}
}