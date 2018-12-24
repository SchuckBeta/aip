package com.oseasy.pact.modules.actyw.tool.process.vo;

import java.util.List;

import com.google.common.collect.Lists;


/**
 * 表单表单组类型.
 * @author chenhao
 *
 */
public enum FormTheme {
    F_MR(0, false, "", "默认", "默认", "旧的表单模板", ""),
    F_COM(30, true, "common_", "通用项目", "通用项目", "根据产品通用业务制定的表单组", "proModelService"),
    F_GZSMXX(40, false, "gzsmxx_", "桂子山梦想秀大赛", "桂子山梦想秀大赛", "桂子山梦想秀表单组", "proModelGzsmxxService"),
    F_MD(10, true, "md_", "民大2018年项目", "民大2018", "根据民大业务制定的表单组", "proModelMdService"),
    F_MD_XM(90, true, "mdXm_", "民大2019年项目", "民大2019", "根据民大业务制定的表单组", "proModelMdService"),
    F_MD_COM(50, true, "md_", "通用大赛", "通用大赛", "根据民大业务制定的表单组", "proModelService"),
    F_MD_GC(60, false, "mdGc_", "民大大赛", "民大大赛", "根据民大业务制定的表单组", "proModelMdGcService"),
    F_TLXY(70, false, "tlxy_", "铜陵学院项目", "铜陵学院项目", "根据铜陵学院业务制定的表单组", "proModelTlxyService"),
    F_HSXM(100, true, "hsxm_", "华师大创项目", "华师大创项目", "根据华师大创业务制定的表单组", "proModelHsxmService"),
    F_TEST(80, false, "testgx_", "测试模板", "测试模板", "根据测试模板业务制定的表单组", "proModelService"),
    F_GT(20, false, "gt_", "广铁项目", "广铁项目", "根据广铁业务制定的表单组", "proModelGtService")
    ;
    public static final String FLOW_THEMES = "formThemes";

    private FormTheme(Integer id, Boolean enable, String key, String sname, String name, String remark, String serviceName) {
        this.id = id;
        this.key = key;
        this.enable = enable;
        this.sname = sname;
        this.name = name;
        this.remark = remark;
        this.serviceName = serviceName;
    }

    private Integer id;
    private String key;
    private Boolean enable;
    private String sname;
    private String name;
    private String remark;
    private String serviceName;

    /**
     * 获取主题 .
     * @return List
     */
    public static List<FormTheme> getAll(Boolean enable) {
        if(enable == null){
            enable = true;
        }

        List<FormTheme> enty = Lists.newArrayList();
        FormTheme[] entitys = FormTheme.values();
        for (FormTheme entity : entitys) {
            if ((entity.getId() != null) && (entity.getEnable())) {
                enty.add(entity);
            }
        }
        return enty;
    }
    public static List<FormTheme> getAll() {
        return getAll(true);
    }

    /**
     * 获取Ids .
     * @return List
     */
    public static List<Integer> getAllIds(Boolean enable) {
        if(enable == null){
            enable = true;
        }

        List<Integer> ids = Lists.newArrayList();
        FormTheme[] entitys = FormTheme.values();
        for (FormTheme entity : entitys) {
            if ((entity.getId() != null) && (entity.getEnable())) {
                ids.add(entity.getId());
            }
        }
        return ids;
    }
    public static List<Integer> getAllIds() {
        return getAllIds(true);
    }

    /**
     * 根据id获取FormTheme .
     * @author chenhao
     * @param id id惟一标识
     * @return FormTheme
     */
    public static FormTheme getById(Integer id) {
        if (id == null) {
            return null;
        }

        FormTheme[] entitys = FormTheme.values();
        for (FormTheme entity : entitys) {
            if ((entity.getId() == id)) {
                return entity;
            }
        }
        return null;
    }

    /**
     * 根据key获取FormTheme .
     * @author chenhao
     * @param key key惟一标识
     * @return FormTheme
     */
    public static FormTheme getByKey(String key) {
        FormTheme[] entitys = FormTheme.values();
        for (FormTheme entity : entitys) {
            if ((key).equals(entity.getKey())) {
                return entity;
            }
        }
        return null;
    }

    /**
     * 根据theme获取FormThemeVo .
     * @author chenhao
     * @param ptype 项目惟一标识
     * @param pageKey 页面惟一标识
     * @param cmsKey 栏目惟一标识
     * @param menuKey 菜单惟一标识
     * @return FormThemeVo
     */
    public static FormThemeVo getByKey(FormTheme theme, String ptype, String pageKey, String cmsKey, String menuKey) {
        FormPage page = FormPage.getByKey(theme, ptype, pageKey);
        FlowPcms cms = FlowPcms.getByKey(theme, cmsKey);
        FlowPmenu menu = FlowPmenu.getByKey(theme, menuKey);
        return new FormThemeVo(theme, page, cms, menu);
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public Boolean getEnable() {
        return enable;
    }

    public String getSname() {
        return sname;
    }
    public void setSname(String sname) {
        this.sname = sname;
    }
    public void setEnable(Boolean enable) {
        this.enable = enable;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRemark() {
        return remark;
    }
    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    @Override
    public String toString() {
        return "{\"id\":\"" + this.id + "\",\"key\":\""+ this.key +  "\",\"enable\":\""+ this.enable + "\",\"sname\":\""+ this.sname + "\",\"name\":\""+ this.name + "\",\"remark\":\"" + this.remark + "\"}";
    }
}
