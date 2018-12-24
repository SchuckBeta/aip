/**
 * .
 */

package com.oseasy.psys.common.config;

/**
 * .
 * @author chenhao
 *
 */
public enum SysIds {
    SITE_TOP("1", "系统官方站点");

    private String id;
    private String remark;

    private SysIds(String id, String remark) {
        this.id = id;
        this.remark = remark;
    }

    public String getId() {
        return id;
    }


    public String getRemark() {
        return remark;
    }

    public static SysIds getById(String id) {
        SysIds[] entitys = SysIds.values();
        for (SysIds entity : entitys) {
            if ((id).equals(entity.getId())) {
                return entity;
            }
        }
        return null;
    }

    @SuppressWarnings("unused")
    @Override
    public String toString() {
        if(this != null){
            return "{\"id\":\"" + this.id + ",\"remark\":\"" + this.remark + "\"}";
        }
        return super.toString();
    }
}
