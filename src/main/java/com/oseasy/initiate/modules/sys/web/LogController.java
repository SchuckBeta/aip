/**
 * 
 */
package com.oseasy.initiate.modules.sys.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oseasy.pcore.modules.sys.service.LogService;
import com.oseasy.pcore.modules.sys.service.UserService;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.Log;
import com.oseasy.pcore.modules.sys.entity.User;

/**
 * 日志Controller

 * @version 2013-6-2
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/log")
public class LogController extends BaseController {

	@Autowired
	private LogService logService;
	
	@Autowired
	private UserService userService;
	
	@RequiresPermissions("sys:log:view")
	@RequestMapping(value = {"list", ""})
	public String list(Log log, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<Log> page = logService.findPage(new Page<Log>(request, response), log); 
        model.addAttribute("page", page);
		return "modules/sys/logList";
	}
	
	/**
	 * 通过手机验证用户是否已存在
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/validatePhone")
	public Boolean validatePhone(HttpServletRequest request) {
		String mobile =  request.getParameter("mobile");
		User user = new User();
		user.setMobile(mobile);
		user.setDelFlag("0");
		user = userService.getByMobile(user);
		if (user!=null) {
			return false;
		}
		return true;
	}

}
