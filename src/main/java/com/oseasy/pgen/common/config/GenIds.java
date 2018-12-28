/**
 * .
 */

package com.oseasy.pgen.common.config;

/**
 * .
 * @author chenhao
 *
 */
public enum GenIds {
    SITE_TOP("1", "系统官方站点");

    private String id;
    private String remark;

    private GenIds(String id, String remark) {
        this.id = id;
        this.remark = remark;
    }

    public String getId() {
        return id;
    }


    public String getRemark() {
        return remark;
    }

    public static GenIds getById(String id) {
        GenIds[] entitys = GenIds.values();
        for (GenIds entity : entitys) {
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
