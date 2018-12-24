/**
 * .
 */

package com.oseasy.pcas.common.config;

/**
 * .
 * @author chenhao
 *
 */
public class CasSval {
    public static final String VIEWS_MODULES = "modules/";
    public static final String CAS_LOGOUT_URL = "logoutUrl";
    public static final String ROOT = "root";
    public static final String VIEWS_CAS = "/cas";
    public static final String VIEWS_MD_CAS = VIEWS_MODULES + VIEWS_CAS;
    public static final String CAS_LOGOUT = "http://authserver.uta.edu.cn/authserver/logout";
    public static final Integer CAS_TYPE = 1;//安职业Cas登录
    public static final Integer CAS_TIME_MAX = 3;//数据同步最大允许失败次数
}
