/**
 *
 */
package com.oseasy.initiate.modules.sys.web;

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

import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
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
 * 登录Controller
 * @author ThinkGem
 * @version 2013-5-31
 */
@Controller
public class LoginController extends BaseController{
	@RequestMapping(value = "${adminPath}/sysMenuIndex", method = RequestMethod.GET)
	public String sysMenuIndex(HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/sys/sysMenuIndex";
	}

	@RequestMapping(value = "${adminPath}/sysOldIndex", method = RequestMethod.GET)
	public String sysOldIndex(HttpServletRequest request, HttpServletResponse response, Model model) {
	  return "modules/sys/sysIndex";
	}

	/**
	 * 获取主题方案
	 */
	@RequestMapping(value = "/theme/{theme}")
	public String getThemeInCookie(@PathVariable String theme, HttpServletRequest request, HttpServletResponse response) {
		if (StringUtil.isNotBlank(theme)) {
			CookieUtils.setCookie(response, "theme", theme);
//		}else{
//			theme = CookieUtils.getCookie(request, "theme");
		}
		return CoreSval.REDIRECT+request.getParameter("url");
	}
}
