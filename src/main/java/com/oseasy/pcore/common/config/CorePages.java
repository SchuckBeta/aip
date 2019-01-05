package com.oseasy.pcore.common.config;

/**
 * 系统固定ID.
 * @author Administrator
 */
public enum CorePages {
    ERROR_MSG(404, "404", "error/msg"),
    ERROR_404(404, "404", "error/404"),
    FIDX_V1(100, "findex", "modules/pcore/findex"),
    FIDX_VOLD(200, "弃用", "modules/website/indexForTemplate"),
    IDX_BACK_V3(13, "backV3", "modules/sys/sysIndexBackV3"),
    IDX_BACK_V4(14, "backV4", "modules/sys/sysIndexBackV4");

    private Integer val;
    private String idx;
    private String idxUrl;
    private CorePages(Integer val, String idx, String idxUrl) {
        this.val = val;
        this.idx = idx;
        this.idxUrl = idxUrl;
    }
    public String getIdx() {
        return idx;
    }
    public Integer getVal() {
        return val;
    }
    public String getIdxUrl() {
        return idxUrl;
    }
    public static CorePages getByVal(Integer val) {
        CorePages[] entitys = CorePages.values();
        for (CorePages entity : entitys) {
            if ((val).equals(entity.getVal())) {
                return entity;
            }
        }
        return null;
    }

    public static CorePages getByIdx(String idx) {
        CorePages[] entitys = CorePages.values();
        for (CorePages entity : entitys) {
            if ((entity.getIdx()).equals(idx)) {
                return entity;
            }
        }
        return null;
    }
}
