/**
 * .
 */

package com.oseasy.pcms.modules.cmss.vo;

/**
 * 站点类型.
 * @author chenhao
 *
 */
public enum CmsSiteType {
    DEFAULT("0", "站点"),
    WEB("10", "Web"),
    App("20", "App");

    private String key;
    private String remark;
    private CmsSiteType(String key, String remark) {
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

    public static CmsSiteType getByKey(String key) {
        CmsSiteType[] entitys = CmsSiteType.values();
        for (CmsSiteType entity : entitys) {
            if ((key).equals(entity.getKey())) {
                return entity;
            }
        }
        return null;
    }
}
