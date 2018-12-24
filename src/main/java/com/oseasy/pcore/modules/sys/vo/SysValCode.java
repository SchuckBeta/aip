/**
 * .
 */

package com.oseasy.pcore.modules.sys.vo;

import com.oseasy.putil.common.utils.StringUtil;

/**
 * 验证码分类.
 * @author chenhao
 */
public enum SysValCode {
    ALL_NOMARL("0001", "0", "所有平台通用验证码"),
    ALL_EMAIL("0100", "0", "所有平台邮件修改验证码"),
    F_LOGIN("1010", "1", "前台登录验证码"),
    F_MOBILE("1020", "1", "前台手机验证码"),

    A_LOGIN("2010", "2", "后台登录验证码");

    private String key;
    private String type;//平台分类：0：所有平台，1前台，2后台
    private String name;//验证码说明

    public static final String VKEY = "validateCode";
    public static final String SYS_VCODES = "sysValCodes";

  private SysValCode(String key, String type, String name) {
    this.key = key;
    this.type = type;
    this.name = name;
  }

    /**
     * 根据key获取枚举 .
     *
     * @author chenhao
     * @param key
     *            枚举标识
     * @return SysValCode
     */
    public static SysValCode getByKey(String key) {
        if ((key != null)) {
            SysValCode[] entitys = SysValCode.values();
            for (SysValCode entity : entitys) {
                if ((key).equals(entity.getKey())) {
                    return entity;
                }
            }
        }
        return null;
    }

    /**
     * 获取验证码惟一标识Key.
     */
    public static String genVcodeKey(SysValCode svcode) {
        return VKEY + StringUtil.SEPARATOR + svcode.getKey();
    }

    public String getKey() {
        return key;
    }

    public String getType() {
        return type;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return "{\"key\":\"" + this.key + "\",\"type\":\"" + this.type + "\",\"name\":\"" + this.name + "\"}";
    }
}
