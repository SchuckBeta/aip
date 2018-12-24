package com.oseasy.initiate.common.config;

/**
 * 系统固定ID
 *
 * @author Administrator
 */
public enum SysIds {
//    SYS_ROLE_USER("13757518f4da45ecaa32a3b582e8396a", "学生角色"),
//    SYS_ROLE_TEACHER("21999752ae6049e2bc3d53e8baaac9a5", "导师角色"),
//    SYS_CERT_ROLE("f9c12c05add2409dac0fcdec9387e630", "证书颁发管理员角色Id"),
//    SYS_COLLEGE_EXPERT("ef8b7924557747e2ac71fe5b52771c08", "学院专家角色Id"),
//    SYS_SCHOOL_EXPERT("ecee0da215d04186bdeea0373bf8eeea", "学校专家角色Id"),
//    SYS_OFFICE_XY_QT("049168153f064a8896aeeaa97c10d651", "其他"),
//    SYS_OFFICE_ZY_QT("5e3bff085a0d4dfab174df37e2a6c82a", "其他"),
    SYS_NO_ROOT("0", "系统序号最大值记录"),
    SITE_TOP("1", "系统官方站点"),
    SITE_CATEGORYS_SYS_ROOT("1", "系统顶级栏目"),
//    SITE_CATEGORYS_TOP_ROOT("ca46923a84ef4754b58ae89e21e97d69", "系统网站顶级栏目"),
//    SITE_CATEGORYS_TOP_INDEX("3817dff6b23a408b8fe131595dfffcbc", "系统官方网站首页栏目"),
//    SITE_CATEGORYS_GCONTEST_ROOT("448e7bc14f3c477fa31a7c47fe016c12", "系统大赛栏目"),
//    SITE_MENU_GCONTEST_ROOT("85c6095f275540b9980dde2b06d77382", "系统大赛菜单"),
//    SITE_CATEGORYS_PROJECT_ROOT("c5c65c9a80a849cfbe4a05741b78d902", "系统项目栏目"),
//    SITE_MENU_PROJECT_ROOT("5474e38a3c8a46f590939df6a453d5f8", "系统项目菜单"),
//    SITE_PW_ENTER_ROOT("7cff6f6b9b494e25a38877fc634a613a", "入驻管理"),
//    SITE_PW_APPOINTMENT_ROOT("5b65b4e07abf4827b7d7d5f0a65f5b50", "预约管理"),
//    ISMS("0001", "秘书"),
//    ISCOLLEGE("0002", "院"),
//    DR_CARD_GID("0", "全局GROUP ID")
    ;

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
