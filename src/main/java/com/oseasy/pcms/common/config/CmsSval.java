/**
 * .
 */

package com.oseasy.pcms.common.config;

/**
 * .
 * @author chenhao
 *
 */
public class CmsSval {
    public enum CmsKeys {
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

}
