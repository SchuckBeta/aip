/**
 *
 */
package com.oseasy.pcore.modules.sys.web.f;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.UnauthorizedException;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oseasy.initiate.modules.sysconfig.utils.SysConfigUtil;
import com.oseasy.pcms.common.utils.CmsUtil;
import com.oseasy.pcms.modules.cmss.entity.CmsSite;
import com.oseasy.pcore.common.config.CorePages;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.CoreSval.CorePaths;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.security.shiro.session.SessionDAO;
import com.oseasy.pcore.common.utils.IdGen;
import com.oseasy.pcore.common.utils.sms.SMSUtilAlidayu;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.security.AdminFormAuthenticationFilter;
import com.oseasy.pcore.modules.sys.security.SystemAuthorizingRealm.Principal;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.pcore.modules.sys.vo.SysValCode;
import com.oseasy.putil.common.utils.CookieUtils;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 网站Controller


 */
@Controller
@RequestMapping(value = "${frontPath}")
public class Fcontroller extends BaseController{
    private static final String LOGIN_FRONT = "modules/website/frontLogin";
    public static final String LOGIN = Global.getFrontPath() + "/toLogin";
    public static final Boolean CAS_LOGIN_OPEN = ((CoreSval.YES).equals(Global.getConfig("cas.login.open")) ? true : false);//展位名  噢易云
    public static final String CAS_LOGIN_URL = Global.getConfig("cas.login.url");//CAS登录地址

	@Autowired
	private SessionDAO sessionDAO;

    public static String getLoginFront() {
        if(CAS_LOGIN_OPEN){
            return CoreSval.REDIRECT + CAS_LOGIN_URL;
        }
        return LOGIN_FRONT;
    }

    /**
     * 登录成功，进入前台首页
     */
    @RequestMapping(value = "")
    public String index(HttpServletRequest request,Model model, HttpServletResponse response) {
        if (logger.isDebugEnabled()) {
            logger.debug("show index, active session size: {}", sessionDAO.getActiveSessions(false).size());
        }
//        if(CmsUtil.getCurr(request, response) == null){
//            return CoreSval.REDIRECT + Global.getFrontPath() + "/fi";
//        }
        return CorePages.F_IDXV1.getIdxUrl();
    }

    /**
     * 登录成功，进入前台首页前置页
     */
    @RequestMapping(value = "fi")
    public String findex(HttpServletRequest request,Model model, HttpServletResponse response) {
        return CorePages.F_IV1.getIdxUrl();
    }

    /*
     * 当前站点内容模板静态文件
     */
    @RequestMapping(value = "t/{page}")
    public String curSitePage(@PathVariable String page, Model model, HttpServletRequest request, HttpServletResponse response) {
        CmsSite curSite = CmsUtil.getCurr(request, response);
        return CorePaths.PH_LAYOUTS_SITES.getKey() + StringUtil.LINE
                + curSite.getParent().getKeyss() + StringUtil.LINE
                + curSite.getKeyss() + CoreSval.getFrontPath() + StringUtil.LINE + page;
    }

    /*
     * 当前站点内容模板静态文件
     */
    @RequestMapping(value = "t/{md}/{page}")
    public String curSiteTplPage(@PathVariable String md, @PathVariable String page, Model model, HttpServletRequest request, HttpServletResponse response) {
        CmsSite curSite = CmsUtil.getCurr(request, response);
        return CorePaths.PH_LAYOUTS_SITES.getKey() + StringUtil.LINE
                + curSite.getParent().getKeyss() + StringUtil.LINE
                + curSite.getKeyss() + CoreSval.getFrontPath()+ StringUtil.LINE
                + md + StringUtil.LINE + page;
    }

	@RequestMapping(value = "login", method = RequestMethod.GET)
    public String login(HttpServletRequest request, HttpServletResponse response, Model model) {
        Principal principal = CoreUtils.getPrincipal();

//      // 默认页签模式

        if (logger.isDebugEnabled()) {
            logger.debug("login, active session size: {}", sessionDAO.getActiveSessions(false).size());
        }

        // 如果已登录，再次访问主页，则退出原账号。
        if (CoreSval.TRUE.equals(Global.getConfig("notAllowRefreshIndex"))) {
            CookieUtils.setCookie(response, "LOGINED", "false");
        }

        // 如果已经登录，则跳转到管理首页
        if (principal != null && !principal.isMobileLogin()) {
            return CoreSval.REDIRECT + frontPath;
        }
        request.setAttribute("loginType", request.getParameter("loginType"));
        request.setAttribute("loginPage", "1");
        model.addAttribute("isValidateCodeLogin", CoreUtils.isValidateCodeLogin(false, false));
        return getLoginFront();
    }

    /**
     * 登录失败，真正登录的POST请求由Filter完成
     */
    @RequestMapping(value = "login", method = RequestMethod.POST)
    public String loginFail(HttpServletRequest request, HttpServletResponse response, Model model) {
        Principal principal = CoreUtils.getPrincipal();

        // 如果已经登录，则跳转到管理首页
        if (principal != null) {
            return CoreSval.REDIRECT + frontPath;
        }

        String username = WebUtils.getCleanParam(request, AdminFormAuthenticationFilter.DEFAULT_USERNAME_PARAM);
        boolean rememberMe = WebUtils.isTrue(request, AdminFormAuthenticationFilter.DEFAULT_REMEMBER_ME_PARAM);
        boolean mobile = WebUtils.isTrue(request, AdminFormAuthenticationFilter.DEFAULT_MOBILE_PARAM);
        String exception = (String)request.getAttribute(AdminFormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME);
        String message = (String)request.getAttribute(AdminFormAuthenticationFilter.DEFAULT_MESSAGE_PARAM);

        if (StringUtil.isBlank(message) || StringUtil.equals(message, "null")) {
            message = "账号或密码错误, 请重试.";
        }

        model.addAttribute(AdminFormAuthenticationFilter.DEFAULT_USERNAME_PARAM, username);
        model.addAttribute(AdminFormAuthenticationFilter.DEFAULT_REMEMBER_ME_PARAM, rememberMe);
        model.addAttribute(AdminFormAuthenticationFilter.DEFAULT_MOBILE_PARAM, mobile);
        model.addAttribute(AdminFormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME, exception);
        model.addAttribute(AdminFormAuthenticationFilter.DEFAULT_MESSAGE_PARAM, message);

        if (logger.isDebugEnabled()) {
            logger.debug("login fail, active session size: {}, message: {}, exception: {}",
                    sessionDAO.getActiveSessions(false).size(), message, exception);
        }

        // 非授权异常，登录失败，验证码加1。
        if (!UnauthorizedException.class.getName().equals(exception)) {
            model.addAttribute("isValidateCodeLogin", CoreUtils.isValidateCodeLogin(true, false));
        }

        // 验证失败清空验证码
        request.getSession().setAttribute(SysValCode.VKEY, IdGen.uuid());

        // 如果是手机登录，则返回JSON字符串
        if (mobile) {
            return renderString(response, model);
        }
        request.setAttribute("loginType", request.getParameter("loginType"));
        request.setAttribute("loginPage", "1");
        model.addAttribute("isValidateCodeLogin", CoreUtils.isValidateCodeLogin(false, false));
        return getLoginFront();
    }

    @RequestMapping(value="toLogin")
    public String toLogin(HttpServletRequest request, HttpServletResponse response,Model model) {
        request.setAttribute("loginType", request.getParameter("loginType"));
        request.setAttribute("loginPage", "1");
        model.addAttribute("isValidateCodeLogin", CoreUtils.isValidateCodeLogin(false, false));
        return getLoginFront();
    }

    @RequestMapping(value="toRegister")
    public String toRegister(HttpServletRequest request, HttpServletResponse response) {
        if((SysConfigUtil.getSysConfigVo() == null) || (SysConfigUtil.getSysConfigVo().getRegisterConf() == null) || (SysConfigUtil.getSysConfigVo().getRegisterConf().getTeacherRegister() == null)){
            logger.warn("注册配置属性不能为空(SysConfigUtil.sysConfigVo.registerConf.teacherRegister)");
            request.setAttribute("teacherRegister", "0");//默认只支持学生注册
        }else{
            request.setAttribute("teacherRegister", SysConfigUtil.getSysConfigVo().getRegisterConf().getTeacherRegister());
        }
        request.setAttribute("loginPage", "1");
        return "modules/website/studentregister";
    }

    @RequestMapping(value = "help", method = RequestMethod.GET)
    public String help(HttpServletRequest request, HttpServletResponse response, Model model) {
        return "modules/website/frontHelp";
    }

    @RequestMapping(value = "sendSmsCode", method = RequestMethod.GET)
    @ResponseBody
    public String sendSmsCode(HttpServletRequest request, HttpServletResponse response, Model model) {
        String p=request.getParameter("mobile");
        String code=SMSUtilAlidayu.sendSms(p);
        if (code!=null) {
            request.getSession().setAttribute("server_sms_code", code);
            return "1";
        }else{
            return "0";
        }
    }

    @RequestMapping(value = "/loginUserId", method = RequestMethod.GET)
    @ResponseBody
    public String loginUserId() {
        return CoreUtils.getUser().getId();
    }





    /*内容模板静态文件*/
    @RequestMapping(value = "cms/{tpl}/{page}")
    public String modelCms(@PathVariable String tpl, @PathVariable String page, Model model) {
        return "template/cms/" + tpl + StringUtil.LINE + page;
    }
}
