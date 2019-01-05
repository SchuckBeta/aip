package com.oseasy.pcore.common.config;

/**
 * 系统固定URL.
 * @author Administrator
 */
public enum CoreUrl {
    F_ROOT("/f", "前台"),
    A_ROOT("/a", "后台");

    private String url;
    private String remark;
    private CoreUrl(String url, String remark) {
        this.url = url;
        this.remark = remark;
    }

    public String getUrl() {
        return url;
    }

    public String getRemark() {
        return remark;
    }

    public static CoreUrl getByUrl(String val) {
        CoreUrl[] entitys = CoreUrl.values();
        for (CoreUrl entity : entitys) {
            if ((val).equals(entity.getUrl())) {
                return entity;
            }
        }
        return null;
    }
}
