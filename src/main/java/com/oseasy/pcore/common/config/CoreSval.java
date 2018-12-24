package com.oseasy.pcore.common.config;

import java.io.File;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.DefaultResourceLoader;

import com.ckfinder.connector.ServletContextFactory;
import com.google.common.collect.Maps;
import com.oseasy.pcore.common.utils.IdGen;
import com.oseasy.putil.common.utils.PropertiesLoader;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 系统常量
 * @author Administrator
 */
public class CoreSval {
    private static Logger logger = LoggerFactory.getLogger(CoreSval.class);

    /**
     * 表单类型
     */
    public static final String EDIT = "edit";
    public static final String VIEW = "view";
    /**
     * 重定向关键字
     */
    public static final String REDIRECT = "redirect:";
    /**
     * 允许登陆的系统类型 0后台 1前台.
     */
    public static final String admin = "1";
    public static final String back = "0";

    /**
     * 当前对象实例.
     */
    private static CoreSval coreSval = new CoreSval();

    /**
     * 保存全局属性值.
     */
    private static Map<String, String> map = Maps.newHashMap();
    private static Map<String, String> emailmap = Maps.newHashMap();
    private static PropertiesLoader emailloader = new PropertiesLoader("properties/email.properties");

    /**
     * 属性文件加载对象.
     */
    private static PropertiesLoader loader = new PropertiesLoader("initiate.properties");

    /**
     * 显示/隐藏.
     */
    public static final String SHOW = "1";
    public static final String HIDE = "0";

    /**
     * 是/否.
     */
    public static final String YES = "1";
    public static final String NO = "0";
    /**
     * 是/否.
     */
    public static final String YES_ZH = "是";
    public static final String NO_ZH = "否";
    /**
     * 对/错.
     */
    public static final String TRUE = "true";
    public static final String FALSE = "false";
    /**
     * 正1/负1.
     */
    public static final Integer Z1 = 1;
    public static final Integer F1 = -1;

    public static String getUuid() {
        return IdGen.uuid();
    }

    /**
     * 上传文件基础虚拟路径.
     */
    public static final String USERFILES_BASE_URL = "/userfiles/";

    /**
     * 获取当前对象实例.
     */
    public static CoreSval getInstance() {
        return coreSval;
    }

    /**
     * 获取配置.
     *
     * @see ${fns:getConfig('adminPath')}
     */
    public static String getConfig(String key) {
        String value = map.get(key);
        if (value == null) {
            value = loader.getProperty(key);
            map.put(key, value != null ? value : StringUtil.EMPTY);
        }
        return value;
    }

    public static String getEmailConfig(String key) {
        String value = emailmap.get(key);
        if (value == null) {
            value = emailloader.getProperty(key);
            emailmap.put(key, value != null ? value : StringUtil.EMPTY);
        }
        return value;
    }

    /**
     * 获取管理端根路径.
     */
    public static String getAdminPath() {
        return getConfig("adminPath");
    }

    /**
     * 获取前端根路径.
     */
    public static String getFrontPath() {
        return getConfig("frontPath");
    }

    /**
     * 获取前端IP地址.
     */
    public static String getSysFrontIp() {
        return getConfig("sysFrontIp");
    }

    /**
     * 获取管理端IP地址.
     */
    public static String getSysAdminIp() {
        return getConfig("sysAdminIp");
    }

    /**
     * 获取URL后缀.
     */
    public static String getUrlSuffix() {
        return getConfig("urlSuffix");
    }

    /**
     * 获取授权开关.
     */
    public static Boolean getLicense() {
        String hasLicense = getConfig("hasLicense");
        return ((CoreSval.TRUE == hasLicense) || StringUtil.isEmpty(hasLicense)) ?  true: false;
    }

    /**
     * 获取URL后缀.
     */
    public static String getDomainlt(String domain, String html) {
        String[] domains = StringUtils.split(domain, StringUtil.DOTH);
        String returnString = "";
        for (int i = 0; i < domains.length; i++) {
            returnString += "<" + html + ">" + domains[i] + "</" + html + ">";
        }
        return returnString;
    }

    /**
     * 获取URL后缀. public static String getAge(Date birthday) { String
     * returnString=""; return returnString; }
     */
    public static int getAge(Date birthDay) {
        Calendar cal = Calendar.getInstance();
        if (cal.before(birthDay)) {
            throw new IllegalArgumentException("The birthDay is before Now.It's unbelievable!");
        }

        int yearNow = cal.get(Calendar.YEAR);
        int monthNow = cal.get(Calendar.MONTH);
        int dayOfMonthNow = cal.get(Calendar.DAY_OF_MONTH);
        cal.setTime(birthDay);

        int yearBirth = cal.get(Calendar.YEAR);
        int monthBirth = cal.get(Calendar.MONTH);
        int dayOfMonthBirth = cal.get(Calendar.DAY_OF_MONTH);

        int age = yearNow - yearBirth;
        if (monthNow <= monthBirth) {
            if (monthNow == monthBirth) {
                // monthNow==monthBirth
                if (dayOfMonthNow < dayOfMonthBirth) {
                    age--;
                } else {
                    // do nothing
                }
            } else {
                // monthNow>monthBirth
                age--;
            }
        } else {
            // monthNow<monthBirth
            // donothing
        }
        return age;
    }

    /**
     * 获取前台标题.
     */
    public static String getFrontTitle() {
        return getConfig("frontTitle");
    }

    /**
     * 获取后台标题.
     */
    public static String getBackgroundTitle() {
        return getConfig("backgroundTitile");
    }

    /**
     * 是否是演示模式，演示模式下不能修改用户、角色、密码、菜单、授权.
     */
    public static Boolean isDemoMode() {
        String dm = getConfig("demoMode");
        return "true".equals(dm) || "1".equals(dm);
    }

    /**
     * 在修改系统用户和角色时是否同步到Activiti.
     */
    public static Boolean isSynActivitiIndetity() {
        String dm = getConfig("activiti.isSynActivitiIndetity");
        return "true".equals(dm) || "1".equals(dm);
    }

    /**
     * 页面获取常量.
     *
     * @see ${fns:getConst('YES')}
     */
    public static Object getConst(String field) {
        try {
            return CoreSval.class.getField(field).get(null);
        } catch (Exception e) {
            logger.warn("无配置:" + e.getMessage(), e);
            return null;
            // 异常代表无配置，这里什么也不做
        }
    }

    /**
     * 获取上传文件的根目录.
     *
     * @return dir 上传文件的根目录
     */
    public static String getUserfilesBaseDir() {
        String dir = getConfig("userfiles.basedir");
        if (StringUtil.isBlank(dir)) {
            try {
                dir = ServletContextFactory.getServletContext().getRealPath("/");
            } catch (Exception e) {
                logger.warn("获取目录异常:" + e.getMessage(), e);
                return null;
            }
        }
        if (!dir.endsWith("/")) {
            dir += "/";
        }
        logger.info("userfiles.basedir:" + dir);
        return dir;
    }

    /**
     * 获取工程路径.
     *
     * @return projectPath 工程路径
     */
    public static String getProjectPath() {
        // 如果配置了工程路径，则直接返回，否则自动获取。
        String projectPath = CoreSval.getConfig("projectPath");
        if (StringUtil.isNotBlank(projectPath)) {
            return projectPath;
        }
        try {
            File file = new DefaultResourceLoader().getResource("").getFile();
            if (file == null) {
                return null;
            }

            while (true) {
                File f = new File(file.getPath() + File.separator + "src" + File.separator + "main");
                if (f == null || f.exists()) {
                    break;
                }
                if (file.getParentFile() != null) {
                    file = file.getParentFile();
                } else {
                    break;
                }
            }
            projectPath = file.toString();

        } catch (IOException e) {
            e.printStackTrace();
        }
        return projectPath;
    }

}