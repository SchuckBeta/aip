/**
 *
 */
package com.oseasy.pcore.modules.sys.security;

import java.util.Collection;
import java.util.List;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.credential.HashedCredentialsMatcher;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.Permission;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.oseasy.pcore.modules.sys.enums.RoleBizTypeEnum;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.utils.SpringContextHolder;
import com.oseasy.pcore.common.web.Servlets;
import com.oseasy.pcore.modules.sys.entity.Menu;
import com.oseasy.pcore.modules.sys.entity.Role;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.service.CoreService;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.pcore.modules.sys.utils.LogUtils;
import com.oseasy.pcore.modules.sys.vo.SysValCode;
import com.oseasy.putil.common.utils.Encodes;

/**
 * 系统安全认证实现类

 * @version 2014-7-5
 */
@Service("frontPasswAuthorizingRealm")
public class FrontPasswAuthorizingRealm extends SystemAuthorizingRealm {

	private Logger logger = LoggerFactory.getLogger(getClass());

//	private SystemService systemService;
    @Autowired
    private CoreService coreService;

	public FrontPasswAuthorizingRealm() {
		this.setCachingEnabled(false);
	}

	/**
	 * 认证回调函数, 登录时调用
	 */
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authcToken) {
		MyUsernamePasswordToken token = (MyUsernamePasswordToken) authcToken;

		int activeSessionSize = getCoreService().getSessionDao().getActiveSessions(false).size();
		if (logger.isDebugEnabled()) {
			logger.debug("login submit, active session size: {}, username: {}", activeSessionSize, token.getUsername());
		}

		// 校验登录验证码
		if (CoreUtils.isValidateCodeLogin(false, false)) {
			Session session = CoreUtils.getSession();
			String code = (String)session.getAttribute(SysValCode.VKEY);
			if (token.getCaptcha() == null || !token.getCaptcha().toUpperCase().equals(code)) {
				throw new AuthenticationException("msg:验证码错误, 请重试.");
			}
		}
		if (StringUtils.isEmpty(token.getUsername())) {
			throw new AuthenticationException("msg:请输入账号.");
		}
		if (token.getPassword()==null||token.getPassword().length==0) {
			throw new AuthenticationException("msg:请输入密码.");
		}
		// 校验用户名密码
		//User user = getSystemService().getUserByLoginName(token.getUsername());
		User user = getCoreService().getUserByLoginNameOrNo(token.getUsername());
		if (user != null) {
			if (!CoreUtils.checkHasRole(user, RoleBizTypeEnum.XS.getValue())&&!CoreUtils.checkHasRole(user, RoleBizTypeEnum.DS.getValue())) {
				throw new  UnknownAccountException();
			}
			if (Global.NO.equals(user.getLoginFlag())) {
				throw new AuthenticationException("msg:该已帐号禁止登录.");
			}
			byte[] salt = Encodes.decodeHex(user.getPassword().substring(0,16));
			return new SimpleAuthenticationInfo(new Principal(user, token.isMobileLogin()),
					user.getPassword().substring(16), ByteSource.Util.bytes(salt), getName());
		} else {
			throw new  UnknownAccountException();
		}
	}

	/**
	 * 获取权限授权信息，如果缓存中存在，则直接从缓存中获取，否则就重新获取， 登录成功后调用
	 */
	protected AuthorizationInfo getAuthorizationInfo(PrincipalCollection principals) {
		if (principals == null) {
            return null;
        }

        AuthorizationInfo info = null;

        info = (AuthorizationInfo)CoreUtils.getCache(CoreUtils.CACHE_AUTH_INFO);

        if (info == null) {
            info = doGetAuthorizationInfo(principals);
            if (info != null) {
            	CoreUtils.putCache(CoreUtils.CACHE_AUTH_INFO, info);
            }
        }

        return info;
	}

	/**
	 * 授权查询回调函数, 进行鉴权但缓存中无用户的授权信息时调用
	 */
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
		Principal principal = (Principal) getAvailablePrincipal(principals);
		// 获取当前已登录的用户
		if (!CoreSval.TRUE.equals(Global.getConfig("user.multiAccountLogin"))) {
			Collection<Session> sessions = getCoreService().getSessionDao().getActiveSessions(true, principal, CoreUtils.getSession());
			if (sessions.size() > 0) {
				// 如果是登录进来的，则踢出已在线用户
				if (CoreUtils.getSubject().isAuthenticated()) {
					for (Session session : sessions) {
					    getCoreService().getSessionDao().delete(session);
					}
				}
				// 记住我进来的，并且当前用户已登录，则退出当前用户提示信息。
				else{
					CoreUtils.getSubject().logout();
					throw new AuthenticationException("msg:账号已在其它地方登录，请重新登录。");
				}
			}
		}
		User user = getCoreService().getUserByLoginNameAndNo(principal.getLoginName(),principal.getNo());
		if (user != null) {
			SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
			List<Menu> list = CoreUtils.getMenuList();
			for (Menu menu : list) {
				if (StringUtils.isNotBlank(menu.getPermission())) {
					// 添加基于Permission的权限信息
					for (String permission : StringUtils.split(menu.getPermission(),",")) {
						info.addStringPermission(permission);
					}
				}
			}
			// 添加用户权限
			info.addStringPermission("user");
			// 添加用户角色信息
			for (Role role : user.getRoleList()) {
				info.addRole(role.getEnname());
			}
			// 更新登录IP和时间
			getCoreService().updateUserLoginInfo(user);
			// 记录登录日志
			LogUtils.saveLog(Servlets.getRequest(), "系统登录");
			return info;
		} else {
			return null;
		}
	}

	@Override
	protected void checkPermission(Permission permission, AuthorizationInfo info) {
		authorizationValidate(permission);
		super.checkPermission(permission, info);
	}

	@Override
	protected boolean[] isPermitted(List<Permission> permissions, AuthorizationInfo info) {
		if (permissions != null && !permissions.isEmpty()) {
            for (Permission permission : permissions) {
        		authorizationValidate(permission);
            }
        }
		return super.isPermitted(permissions, info);
	}

	@Override
	public boolean isPermitted(PrincipalCollection principals, Permission permission) {
		authorizationValidate(permission);
		return super.isPermitted(principals, permission);
	}

	@Override
	protected boolean isPermittedAll(Collection<Permission> permissions, AuthorizationInfo info) {
		if (permissions != null && !permissions.isEmpty()) {
            for (Permission permission : permissions) {
            	authorizationValidate(permission);
            }
        }
		return super.isPermittedAll(permissions, info);
	}

	/**
	 * 授权验证方法
	 * @param permission
	 */
	private void authorizationValidate(Permission permission) {
		// 模块授权预留接口
	}

	/**
	 * 设定密码校验的Hash算法与迭代次数
	 */
	@PostConstruct
	public void initCredentialsMatcher() {
		HashedCredentialsMatcher matcher = new HashedCredentialsMatcher(CoreUtils.HASH_ALGORITHM);
		matcher.setHashIterations(CoreUtils.HASH_INTERATIONS);
		setCredentialsMatcher(matcher);
	}

//	/**
//	 * 清空用户关联权限认证，待下次使用时重新加载
//	 */
//	public void clearCachedAuthorizationInfo(Principal principal) {
//		SimplePrincipalCollection principals = new SimplePrincipalCollection(principal, getName());
//		clearCachedAuthorizationInfo(principals);
//	}

	/**
	 * 清空所有关联认证
	 * @Deprecated 不需要清空，授权缓存保存到session中
	 */
	@Deprecated
	public void clearAllCachedAuthorizationInfo() {
//		Cache<Object, AuthorizationInfo> cache = getAuthorizationCache();
//		if (cache != null) {
//			for (Object key : cache.keys()) {
//				cache.remove(key);
//			}
//		}
	}

	/**
	 * 获取系统业务对象
	 */
	public CoreService getCoreService() {
		if (coreService == null) {
		    coreService = SpringContextHolder.getBean(CoreService.class);
		}
		return coreService;
	}

}
