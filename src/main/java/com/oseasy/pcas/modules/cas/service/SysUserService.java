/**
 * .
 */

package com.oseasy.pcas.modules.cas.service;

import java.util.List;

import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.initiate.modules.sys.service.SystemService;
import com.oseasy.pcas.modules.cas.entity.SysCasUser;
import com.oseasy.pcas.modules.cas.entity.SysUser;
import com.oseasy.pcas.modules.cas.vo.CheckRet;
import com.oseasy.pcas.modules.cas.vo.impl.DBAnZhiVo;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.security.MyUsernamePasswordToken;
import com.oseasy.pcore.modules.sys.security.MyUsernamePasswordToken.LoginType;
import com.oseasy.pcore.modules.sys.service.CoreService;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.putil.common.utils.json.JsonNetUtils;

/**
 * .
 * @author chenhao
 *
 */
@Service
@Transactional(readOnly = true)
public class SysUserService {
    public static Logger logger = Logger.getLogger(SysUserService.class);
    @Autowired
    private CoreService coreService;
    @Autowired
    private SystemService systemService;

    /**
     * 创建用户.
     * @param nuser 用户参数
     * @param user 操作用户
     * @return User
     */
    @Transactional(readOnly = false)
    public User newUserByLoginName(User nuser, User user, SysCasUser casUser) {
        try {
            List<DBAnZhiVo> dbAnZhiVos = JsonNetUtils.toBeans(casUser.getRjson(), DBAnZhiVo.class);
            if(StringUtil.checkNotEmpty(dbAnZhiVos) && dbAnZhiVos.size() == 1){
                nuser = DBAnZhiVo.dealDbvo(nuser, dbAnZhiVos.get(0));
            }
        } catch (Exception e) {
            logger.error("rjson类型转换异常，拓展数据无法初始化！");
        }
//        return systemService.newStudentByLoginName(nuser, user);
        return nuser;
    }

    public List<SysUser> findList(SysUser entity) {
        return SysUser.convertSysUser(coreService.findUser(entity.getUser()));
    }

    /**
     * 检查用户是否存在于sys_user
     * @param entity
     * @return
     */
    public SysUser checkSysUser(SysUser entity) {
        if(entity == null){
            entity = new SysUser();
        }
        entity.setCheckRet(CheckRet.FALSE.getKey());

        if(entity.getUser() == null){
            return entity;
        }

        User user = entity.getUser();
        if(StringUtil.isEmpty(user.getLoginName())){
            return entity;
        }

        User puser = new User();
        puser.setLoginName(user.getLoginName());
        List<SysUser> entitys = findList(new SysUser(puser));
        if((entitys != null) && (entitys.size() == 1)){
            entity = entitys.get(0);
            entity.setCheckRet(CheckRet.TRUE.getKey());
        }
        return entity;
    }


    public void loginToken(SysUser sysUser) {
        try {
            Subject subject = SecurityUtils.getSubject();
            MyUsernamePasswordToken token = new MyUsernamePasswordToken();
            token.setUsername(sysUser.getUser().getLoginName());
            token.setPassword(sysUser.getUser().getPassword().toCharArray());
            token.setLoginType(LoginType.DSF);
            token.setCas((sysUser.isCas() == null) ? false : sysUser.isCas());
            subject.login(token);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.getMessage());
        }
    }
}
