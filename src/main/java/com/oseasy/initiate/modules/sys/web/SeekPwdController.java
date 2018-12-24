package com.oseasy.initiate.modules.sys.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oseasy.initiate.modules.sys.service.SeekPwdService;
import com.oseasy.pcore.common.utils.CacheUtils;
import com.oseasy.pcore.common.utils.sms.SMSUtilAlidayu;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.vo.SysValCode;
import com.oseasy.putil.common.utils.StringUtil;

@Controller
public class SeekPwdController extends BaseController {
	@Autowired
	private SeekPwdService seekPwdService;

	/**
	 * 确认账号
	 */
	@ResponseBody
	@RequestMapping(value = "${frontPath}/confirm", method = RequestMethod.POST)
	public String confirm(HttpServletRequest request, Model model) {
		String phoneMailNumber = request.getParameter("phonemailxuehao");
		String valiCode = request.getParameter("valiCode");
		String validateCode = (String) request.getSession().getAttribute(SysValCode.VKEY);
		String flag = "3";
		if (StringUtil.isNotBlank(valiCode)) {
			if (valiCode.equalsIgnoreCase(validateCode)) {
				User exitUser = seekPwdService.findUserByPhone(phoneMailNumber);
				if (exitUser != null) {
					request.getSession().removeAttribute(SysValCode.VKEY);
					flag = "1";
				} else {
					flag = "0";
				}
			} else {
				flag = "2";
			}
		}

		return flag;
	}

	/**
	 * 短信发送
	 */
	@ResponseBody
	@RequestMapping(value = "${frontPath}/sendMessage", method = RequestMethod.POST)
	public String sendMessage(HttpServletRequest request, HttpServletResponse response) {
		String phone = request.getParameter("phone");
		String flag = "1";
		try {
//			String sms = SMSUtil.sendSms(phone);
			String sms= SMSUtilAlidayu.sendSms(phone);
			CacheUtils.put("phonecache", phone, sms);
		} catch (Exception e) {
			flag = "0";
		}
		return flag;
	}

	/**
	 * 安全验证
	 */
	@ResponseBody
	@RequestMapping(value = "${frontPath}/safeConfirm", method = RequestMethod.POST)
	public String safeConfirm(HttpServletRequest request, HttpServletResponse response, Model model) {
		String wordValidate = request.getParameter("wordValicode");
		String phone = request.getParameter("phone");
		String flag = null;
		String code = (String) CacheUtils.get("phonecache", phone);
		if (StringUtil.isNotBlank(wordValidate)) {
			if (wordValidate.equals(code)) {
				CacheUtils.remove("phonecache", phone);
				flag = "1";
			} else {
				flag = "0";
			}
		}
		return flag;
	}

	/**
	 * 重置密码
	 */
	@ResponseBody
	@RequestMapping(value = "${frontPath}/resetPwd", method = RequestMethod.POST)
	public String resetPwd(String password, String repassword, HttpServletRequest request) {
		String phone = (String) request.getParameter("phoneNum");
		String flag = "1";
		try {
			if (StringUtil.isNotBlank(password) && StringUtil.isNotBlank(repassword)) {
				seekPwdService.resetPassWord(password, phone);
			}
		} catch (Exception e) {
			flag = "0";
		}

		return flag;
	}

}
