package com.oseasy.initiate.modules.sys.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oseasy.initiate.common.config.SysIds;
import com.oseasy.initiate.modules.sys.enums.EuserType;
import com.oseasy.initiate.modules.sys.enums.RoleBizTypeEnum;
import com.oseasy.initiate.modules.sys.service.SystemService;
import com.oseasy.pcore.common.utils.CacheUtils;
import com.oseasy.pcore.common.utils.sms.SMSUtilAlidayu;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.Role;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.security.MyUsernamePasswordToken;
import com.oseasy.pcore.modules.sys.service.CoreService;
import com.oseasy.pcore.modules.sys.service.UserService;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.pcore.modules.sys.vo.SysValCode;
import com.oseasy.putil.common.utils.Msg;

/**
 * 注册Controller
 * @author zhang
 * @version 2017-3-22
 */

@Controller
@RequestMapping(value = "${frontPath}/register")
public class RegisterController extends BaseController {

    /**
     * 短信验证码Key.
     */
    private static final String HQYAZHENMA = "hqyazhenma";
    //注册类型，手机注册或者学号工号注册
    private final static String REG_TYPE_MOBILE = "mobile";
    private final static String REG_TYPE_NO = "no";

    @Autowired
    private UserService userService;

    @Autowired
    private SystemService systemService;
    @Autowired
    private CoreService coreService;

    /**
     * 通过手机验证用户是否已存在
     *
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/validatePhone")
    public Boolean validatePhone(HttpServletRequest request) {
        String mobile = request.getParameter("mobile");
        User user = new User();
        user.setMobile(mobile);
        user.setDelFlag("0");
        user = userService.getByMobile(user);
        if (user != null) {
            return false;
        }
        return true;
    }

    /**
     * 获取短信验证码
     *
     * @param request mobile
     */
    @ResponseBody
    @RequestMapping(value = "/getVerificationCode")
    public String getVerificationCode(HttpServletRequest request) {
        String mobile = request.getParameter("mobile");
        String sm = SMSUtilAlidayu.sendSms(mobile);
        logger.info("VerCode put key:" + HQYAZHENMA + request.getSession().getId() + " , " + HQYAZHENMA + request.getSession().getId());
        CacheUtils.put(HQYAZHENMA + request.getSession().getId(), HQYAZHENMA + request.getSession().getId(), sm);
        CacheUtils.expire(HQYAZHENMA + request.getSession().getId(), 600);
        return "验证码发送完成";
    }

    /**
     * 验证验证码是否输入正确
     *
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "validateYZM")
    public Boolean validateYZM(HttpServletRequest request) {
        String sruyazhengma = request.getParameter("yzma");
        return sruyazhengma.equals(getVerCode(request, sruyazhengma));
    }

    private String getVerCode(HttpServletRequest request, String sruyazhengma) {
        String hqyazhengma = (String) CacheUtils.get(HQYAZHENMA + request.getSession().getId(), HQYAZHENMA + request.getSession().getId());
        logger.info("VerCode get key:" + HQYAZHENMA + request.getSession().getId()  + " , " + HQYAZHENMA + request.getSession().getId() + " = " + hqyazhengma + "-->"+sruyazhengma.equals(hqyazhengma));
        return hqyazhengma;
    }

    /**
     * 保存用户
     *
     * @param user
     * @return
     */
    @RequestMapping(value = "/saveRegister")
    public String register(User user, Model model, HttpServletRequest request, HttpServletResponse response) {

        String regType = request.getParameter("regType");//注册类型，手机注册1或2学号工号注册
        String url = "modules/website/studentregistersuccessful";

        //校验验证码
        if (regType.equals(REG_TYPE_NO)) {
            String validateCode = request.getParameter("validateCode");
            if (!request.getSession().getAttribute(SysValCode.VKEY).toString().equals(validateCode.toUpperCase())) {
                throw new RuntimeException("验证码输入不正确");
            }

            if (StringUtils.isEmpty(user.getUserType())) {
                throw new RuntimeException("注册用户类型不能为空！");
            }
        } else {
            String sruyazhengma = request.getParameter("yanzhengma");
            String hqyazhengma = getVerCode(request, sruyazhengma);
            if (!hqyazhengma.equals(sruyazhengma)) {
                throw new RuntimeException("验证码输入不正确");
            }
        }

        //验证登录名、手机号
        Map<String, String> validate = systemService.validateUserRegister(user);
        if ("200".equals(validate.get("code"))) {
            throw new RuntimeException(validate.get("msg"));
        }

        String password = user.getPassword();
        user.setPassword(CoreUtils.entryptPassword(user.getPassword()));
        user.setCreateBy(user);
        Date date = new Date();
        user.setCreateDate(date);
        user.setUpdateBy(user);
        user.setUpdateDate(date);
        user.setDelFlag("0");
//        if (user.getUserType().equals(EuserType.UT_C_TEACHER.getType())) {
//            List<Role> roleList=new ArrayList<>();
//            roleList.add(new Role(SysIds.SYS_ROLE_TEACHER.getId()));
//            user.setUserType(RoleBizTypeEnum.DS.getValue());
//            user.setRoleList(roleList);
//        } else {
//            List<Role> roleList=new ArrayList<>();
//            roleList.add(new Role(SysIds.SYS_ROLE_USER.getId()));
//            user.setUserType(RoleBizTypeEnum.XS.getValue());
//            user.setRoleList(roleList);
//        }
        systemService.saveUser(user);
        model.addAttribute("name", user.getLoginName());
        try {
            Subject subject = SecurityUtils.getSubject();
            MyUsernamePasswordToken token = new MyUsernamePasswordToken();
            token.setUsername(user.getLoginName());
            token.setPassword(password.toCharArray());
            token.setLoginType(MyUsernamePasswordToken.LoginType.PWD);
            subject.login(token);
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        model.addAttribute("userType", user.getUserType());
        return url;
    }

    @RequestMapping(value = "/studentExpanSion")
    public String studentExpanSion() {
        return "modules/website/studentregistersuccess";
    }

    /**
     * 校验登录名唯一性
     * @param loginName
     * @param userId
     * @return
     */
    @RequestMapping(value = "/checkLoginNameUnique")
    @ResponseBody
    public Boolean checkLoginNameUnique(String loginName, String userId) {
        Integer num = coreService.checkLoginNameUnique(loginName, userId);
        return  StringUtils.isEmpty(num) || num == 0;
    }

    /**
     * 校验学号/工号唯一性
     * @param no
     * @param userId
     * @param userType
     * @return
     */
    @RequestMapping(value = "/checkNoUnique")
    @ResponseBody
    public Boolean checkNoUnique(String no, String userId, String userType) {
        Integer num = coreService.checkNoUnique(no, userId);
        return StringUtils.isEmpty(num) || num == 0;
    }

    @RequestMapping(value = "/checkMobileUnique")
    @ResponseBody
    public Msg checkMobileUnique(String mobile, String userId) {
        Integer num = coreService.checkMobileUnique(mobile, userId);
        if (StringUtils.isEmpty(num) || num == 0) {
            return Msg.ok("手机号可使用");
        } else {
            return Msg.error("手机号已存在");
        }
    }

    /**
     * 校验验证码
     * @param request
     * @param regType 注册类型，手机：mobile, 学号/工号：no
     * @param code 验证码
     * @return
     */
    @RequestMapping(value = "/checkCode")
    @ResponseBody
    public Boolean checkCode(HttpServletRequest request, String regType, String code) {
        if (regType.equals(REG_TYPE_NO)) {
            return request.getSession().getAttribute(SysValCode.VKEY).toString().equals(code.toUpperCase());
        } else {
            String hqyazhengma = getVerCode(request, code);
            return hqyazhengma.equals(code);
        }
    }

}
