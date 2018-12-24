package com.oseasy.initiate.modules.sys.web.front;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oseasy.pcore.common.utils.sms.SMSUtilAlidayu;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.vo.SysValCode;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * @author  zhangzheng
 * 发送短信验证码，验证短信验证码
 */
@Controller
@RequestMapping(value = "${frontPath}/mobile")
public class MobilefrontController extends BaseController {
//	private static String mobileValidateCode = "mobileValidateCode";
	private static String mobileValidateCode = SysValCode.genVcodeKey(SysValCode.F_MOBILE);

	/**
	 * 发送短信验证码
	 * @return
	 */
	@RequestMapping("sendMobileValidateCode")
	@ResponseBody
	public Boolean sendMobileValidateCode(HttpServletRequest request) {
		String mobile = request.getParameter("mobile");
		//发送短信 ，方法返回验证码
//		String code =  String.format("%06d", rand.nextInt(1000000));
		String code =  SMSUtilAlidayu.sendSms(mobile);
		//短信验证码保存到session
		request.getSession().setAttribute(mobileValidateCode, code);
		System.out.println(code);
		return true;
	}

	/**
	 * 验证短信验证码   true:验证通过    false：验证不通过
	 * @return
	 */
	@RequestMapping("checkMobileValidateCode")
	@ResponseBody
	public Boolean validateCode(HttpServletRequest request,String yzm) {
		//session  获取验证码
		String code = (String)request.getSession().getAttribute(MobilefrontController.mobileValidateCode);
		// 比较验证码
		if (StringUtil.equals(yzm, code)) {
			return true;
		}
		return false;
	}



}
