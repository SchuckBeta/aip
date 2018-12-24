/**
 * .
 */

package com.oseasy.pact.modules.actyw.tool.process.vo;

import java.util.Arrays;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.collect.Lists;
import com.oseasy.pact.modules.actyw.tool.process.Gclzz;
import com.oseasy.pact.modules.actyw.tool.process.impl.GclzzGrade;
import com.oseasy.pact.modules.actyw.tool.process.impl.GclzzGradeAll;

/**
 * 监听类.
 * @author chenhao
 *
 */
public enum ClazzThemeListener {
    CMR_A("100", true, FormTheme.F_MR, GclzzGradeAll.class, "exe", "审核结果"),
    CMR_B("110", false, FormTheme.F_MR, GclzzGradeAll.class, "exe", "审核状态"),
    CCOM_A("200", false, FormTheme.F_COM, GclzzGrade.class, "exe", "审核结果"),
    CCOM_B("210", false, FormTheme.F_COM, GclzzGrade.class, "exe", "审核状态")
    ;

    private static Logger logger = LoggerFactory.getLogger(ClazzThemeListener.class);

    private String key;
    private Boolean enable;
    private FormTheme theme;
    private Class<? extends Gclzz> listener;
    private String name;
    private String cmethod;

    private ClazzThemeListener(String key, Boolean enable, FormTheme theme, Class<? extends Gclzz> listener, String name, String cmethod) {
        this.key = key;
        this.enable = enable;
        this.theme = theme;
        this.listener = listener;
        this.name = name;
        this.cmethod = cmethod;
    }

    /**
     * 获取监听.
     * @return List
     */
    public static List<ClazzThemeListener> getAll() {
        return Arrays.asList(ClazzThemeListener.values());
    }

    /**
     * 获取所有可用监听.
     * @author chenhao
     * @param isShow 是否可用
     * @return List
     */
    public static List<ClazzThemeListener> getAll(Boolean enable) {
        ClazzThemeListener[] entitys = ClazzThemeListener.values();
        if(enable == null){
            return Arrays.asList(entitys);
        }

        List<ClazzThemeListener> ctls = Lists.newArrayList();
        for (ClazzThemeListener entity : entitys) {
            if ((enable).equals(entity.getEnable())) {
                ctls.add(entity);
            }
        }
        return ctls;
    }

    /**
     * 根据标识获取枚举 .
     * @author chenhao
     * @param theme 主题标识
     * @return List
     */
    public static ClazzThemeListener getByKey(String key) {
        if (key == null) {
            return null;
        }

        ClazzThemeListener[] entitys = ClazzThemeListener.values();
        for (ClazzThemeListener entity : entitys) {
            if (entity.getKey() == key) {
                return entity;
            }
        }
        return null;
    }

    /**
     * 根据主题获取枚举 .
     * @author chenhao
     * @param theme 主题标识
     * @return List
     */
    public static List<ClazzThemeListener> getByTheme(FormTheme theme) {
        if ((theme == null)) {
            return null;
        }

        List<ClazzThemeListener> ctls = Lists.newArrayList();
        ClazzThemeListener[] entitys = ClazzThemeListener.values();
        for (ClazzThemeListener entity : entitys) {
            if ((theme).equals(entity.getTheme())) {
                ctls.add(entity);
            }
        }
        return ctls;
    }

    /**
     * 根据主题获取枚举 .
     * @author chenhao
     * @param themeId 主题ID标识
     * @return List
     */
    public static List<ClazzThemeListener> getByTheme(Integer themeId) {
        if(themeId == null){
            logger.error("对应主题未定义,id="+themeId);
            return null;
        }
        FormTheme ftheme = FormTheme.getById(themeId);
        if(ftheme == null){
            logger.error("对应主题未定义,id="+themeId);
        }
        return getByTheme(ftheme);
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

    public void setEnable(Boolean enable) {
        this.enable = enable;
    }

    public FormTheme getTheme() {
        return theme;
    }

    public void setTheme(FormTheme theme) {
        this.theme = theme;
    }

    public Class<? extends Gclzz> getListener() {
        return listener;
    }

    public void setListener(Class<? extends Gclzz> listener) {
        this.listener = listener;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCmethod() {
        return cmethod;
    }

    public void setCmethod(String cmethod) {
        this.cmethod = cmethod;
    }

    @Override
    public String toString() {
        return "{\"key\":\"" + this.key + "\",\"enable\":\"" + this.enable+ "\",\"name\":\"" + this.name + "\",\"cmethod\":\"" + this.cmethod + "\",\"theme\":" + this.theme + "\"}";
    }
}
