/**
 *
 */
package com.oseasy.pcore.modules.sys.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.oseasy.pcore.common.service.BaseService;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;

/**
 *前后台区分拦截器

 * @version 2014-8-19
 */
public class TokenInterceptor extends BaseService implements HandlerInterceptor {
	private static final String FrontOrAdmin="frontOrAdmin_2ed8fe6ddd034cffa47a41e42a694948";
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		String url = request.getRequestURI();
		String[] keys=new String[]{
//		        "save","update","edit","del","change"
        };
		//校验token是否存在并且没有过期

		if(isContains(url,keys)){
			//通过url请求头得到token
			String token = request.getHeader("token");
			//检测token是否为空
			if(token==null) {
				return false;
			}else {
				String sissionToken = (String) CoreUtils.getCache(CoreUtils.CACHE_TOKEN);
				if (sissionToken!=null && !sissionToken.equals(token)) {
					logger.info("token不一致");
					return false;
				}
			}
		}
		return true;
	}
	public static boolean isContains(String container, String[] regx) {
		boolean result = false;
		for (int i = 0; i < regx.length; i++) {
			if (container.toUpperCase().indexOf(regx[i].toUpperCase()) != -1) {
				return true;
			}
		}
		return result;
	}
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {

	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {

	}





}
