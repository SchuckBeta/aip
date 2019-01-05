/**
 *
 */
package com.oseasy.pcore.modules.sys.web.a;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.UnauthorizedException;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.oseasy.pcms.common.utils.CmsUtil;
import com.oseasy.pcms.modules.cmss.entity.CmsSite;
import com.oseasy.pcore.common.config.CorePages;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.config.CoreSval.CorePaths;
import com.oseasy.pcore.common.security.shiro.session.SessionDAO;
import com.oseasy.pcore.common.utils.IdGen;
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
@RequestMapping(value = "${adminPath}")
public class Acontroller extends BaseController{
    @Autowired
    private SessionDAO sessionDAO;

    /**
     * 登录成功，进入前台首页前置页
     */
    @RequestMapping(value = "ai")
    public String findex(HttpServletRequest request,Model model, HttpServletResponse response) {
        return CorePages.A_IV1.getIdxUrl();
    }

    /*
     * 当前站点内容模板静态文件
     */
    @RequestMapping(value = "t/{page}")
    public String curSitePage(@PathVariable String page, Model model, HttpServletRequest request, HttpServletResponse response) {
        CmsSite curSite = CmsUtil.getCurr(request, response);
        return CorePaths.PH_LAYOUTS_SITES.getKey() + StringUtil.LINE
                + curSite.getParent().getKeyss() + StringUtil.LINE
                + curSite.getKeyss() + CoreSval.getAdminPath() + StringUtil.LINE + page;
    }

    /*
     * 当前站点内容模板静态文件
     */
    @RequestMapping(value = "t/{md}/{page}")
    public String curSiteTplPage(@PathVariable String md, @PathVariable String page, Model model, HttpServletRequest request, HttpServletResponse response) {
        CmsSite curSite = CmsUtil.getCurr(request, response);
        return CorePaths.PH_LAYOUTS_SITES.getKey() + StringUtil.LINE
                + curSite.getParent().getKeyss() + StringUtil.LINE
                + curSite.getKeyss() + CoreSval.getAdminPath()+ StringUtil.LINE
                + md + StringUtil.LINE + page;
    }


    /**
     * 登录成功，进入管理首页
     */
    @RequiresPermissions("user")
    @RequestMapping(value = "")
    public String index(HttpServletRequest request, HttpServletResponse response) {
        Principal principal = CoreUtils.getPrincipal();

        if (logger.isDebugEnabled()) {
            logger.debug("show index, active session size: {}", sessionDAO.getActiveSessions(false).size());
        }
        String token=(String)CoreUtils.getSession().getAttribute("token");
        if(StringUtil.isNotEmpty(token)){
            CookieUtils.setCookie(response, "token", token);
        }


        // 如果已登录，再次访问主页，则退出原账号。
        if (CoreSval.TRUE.equals(Global.getConfig("notAllowRefreshIndex"))) {
            String logined = CookieUtils.getCookie(request, "LOGINED");
            if (StringUtil.isBlank(logined) || "false".equals(logined)) {
                CookieUtils.setCookie(response, "LOGINED", "true");
            }else if (StringUtil.equals(logined, "true")) {
                CoreUtils.getSubject().logout();
                return CoreSval.REDIRECT + adminPath + "/login";
            }
        }

        // 如果是手机登录，则返回JSON字符串
        if (principal.isMobileLogin()) {
            if (request.getParameter("login") != null) {
                return renderString(response, principal);
            }
            if (request.getParameter("index") != null) {
                return "modules/sys/sysMenuIndex";
            }
            return CoreSval.REDIRECT + adminPath + "/login";
        }

//      // 登录成功后，获取当前站点ID
//      Site site=siteService.getAutoSite();
//      if(site!=null){
//          CoreUtils.putCache("siteId", String.valueOf(site.getId()));
//      }

//        //TODO 实现站点维护
//        if(CmsUtil.getCurr(request, response) == null){
//            return CoreSval.REDIRECT + Global.getAdminPath() + "/ai";
//        }

        return "modules/sys/sysMenuIndex";
    }

    /**
     * 管理登录
     */
    @RequestMapping(value = "login", method = RequestMethod.GET)
    public String login(HttpServletRequest request, HttpServletResponse response, Model model) {
        Principal principal = CoreUtils.getPrincipal();

//      // 默认页签模式
//      String tabmode = CookieUtils.getCookie(request, "tabmode");
//      if (tabmode == null) {
//          CookieUtils.setCookie(response, "tabmode", "1");
//      }

        if (logger.isDebugEnabled()) {
            logger.debug("login, active session size: {}", sessionDAO.getActiveSessions(false).size());
        }

        // 如果已登录，再次访问主页，则退出原账号。
        if (CoreSval.TRUE.equals(Global.getConfig("notAllowRefreshIndex"))) {
            CookieUtils.setCookie(response, "LOGINED", "false");
        }

        // 如果已经登录，则跳转到管理首页
        if (principal != null && !principal.isMobileLogin()) {
            return CoreSval.REDIRECT + adminPath;
        }
//      String view;
//      view = "/WEB-INF/views/modules/sys/sysLogin.jsp";
//      view = "classpath:";
//      view += "jar:file:/D:/GitHub/initiate/src/main/webapp/WEB-INF/lib/initiate.jar!";
//      view += "/"+getClass().getName().replaceAll("\\.", "/").replace(getClass().getSimpleName(), "")+"view/sysLogin";
//      view += ".jsp";
        model.addAttribute("isValidateCodeLogin", CoreUtils.isValidateCodeLogin(false, false));
        return "modules/sys/sysLogin";
    }

    /**
     * 登录失败，真正登录的POST请求由Filter完成
     */
    @RequestMapping(value = "login", method = RequestMethod.POST)
    public String loginFail(HttpServletRequest request, HttpServletResponse response, Model model) {
        Principal principal = CoreUtils.getPrincipal();

        // 如果已经登录，则跳转到管理首页
        if (principal != null) {
            return CoreSval.REDIRECT + adminPath;
        }

        String username = WebUtils.getCleanParam(request, AdminFormAuthenticationFilter.DEFAULT_USERNAME_PARAM);
        boolean rememberMe = WebUtils.isTrue(request, AdminFormAuthenticationFilter.DEFAULT_REMEMBER_ME_PARAM);
        boolean mobile = WebUtils.isTrue(request, AdminFormAuthenticationFilter.DEFAULT_MOBILE_PARAM);
        String exception = (String)request.getAttribute(AdminFormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME);
        String message = (String)request.getAttribute(AdminFormAuthenticationFilter.DEFAULT_MESSAGE_PARAM);

        if (StringUtil.isBlank(message) || StringUtil.equals(message, "null")) {
            message = "用户或密码错误, 请重试.";
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
        model.addAttribute("isValidateCodeLogin", CoreUtils.isValidateCodeLogin(false, false));
        return "modules/sys/sysLogin";
    }
}
