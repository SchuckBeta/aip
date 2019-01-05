/**
 * .
 */

package com.oseasy.pcms.common.config;

import com.oseasy.putil.common.utils.StringUtil;

/**
 * .
 * @author chenhao
 *
 */
public class CmsSval {
    public static final String CMS_SID = "100";
    public static final String KEY_CMS = "cms";
    public static final String KEY_CMS_LD = KEY_CMS + StringUtil.LINE_D;
    public enum CmsKeys {
        SITE_CUR_ID("curSid", "当前站点ID"),


        SITE_IS_EXIST_INDEX_CACHE("isExistIndexCache", "前台首页缓存状态"),
        SITE_CATEGORYS_INDEX("siteIndexCategorys", "前台首页栏目"),
        SITE_CATEGORYS_INDEX_FIRST("siteIndexCategorysFirst", "前台首页栏目-一级"),
        SITE_CATEGORYS_INDEX_SENCOND("siteIndexCategorysSencond", "前台首页栏目-二级");

        private String key;
        private String remark;
        private CmsKeys(String key, String remark) {
            this.key = key;
            this.remark = remark;
        }

        public String getKey() {
            return key;
        }

        public void setKey(String key) {
            this.key = key;
        }

        public String getRemark() {
            return remark;
        }

        public void setRemark(String remark) {
            this.remark = remark;
        }

        public static CmsKeys getByKey(String key) {
            CmsKeys[] entitys = CmsKeys.values();
            for (CmsKeys entity : entitys) {
                if ((key).equals(entity.getKey())) {
                    return entity;
                }
            }
            return null;
        }
    }

    public enum CmsCaches {
        SITE_CURR(KEY_CMS_LD + "currSite", "当前站点"),
        SITE_GCURR(KEY_CMS_LD + "gcurrSite", "当前站点组"),

        CMS_MENU_LIST("cmsMenuList", "CMS菜单缓存"),
        CMSS_MENU_LIST("cmssMenuList", "站点菜单缓存"),
        ;
        private String key;
        private String remark;
        private CmsCaches(String key, String remark) {
            this.key = key;
            this.remark = remark;
        }

        public String getKey() {
            return key;
        }

        public void setKey(String key) {
            this.key = key;
        }

        public String getRemark() {
            return remark;
        }

        public void setRemark(String remark) {
            this.remark = remark;
        }

        public static CmsCaches getByKey(String key) {
            CmsCaches[] entitys = CmsCaches.values();
            for (CmsCaches entity : entitys) {
                if ((key).equals(entity.getKey())) {
                    return entity;
                }
            }
            return null;
        }
    }

}
