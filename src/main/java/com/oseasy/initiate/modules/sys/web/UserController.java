/**
 *
 */
package com.oseasy.initiate.modules.sys.web;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.oseasy.initiate.modules.sys.service.SystemService;
import com.oseasy.initiate.modules.sys.utils.UserUtils;
import com.oseasy.pact.modules.act.service.ActTaskService;
import com.oseasy.pcore.common.config.ApiConst;
import com.oseasy.pcore.common.config.ApiResult;
import com.oseasy.pcore.common.config.ApiTstatus;
import com.oseasy.pcore.common.config.CoreIds;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.utils.excel.ExportExcel;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.pcore.modules.sys.entity.Dict;
import com.oseasy.pcore.modules.sys.entity.Office;
import com.oseasy.pcore.modules.sys.entity.Role;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.enums.RoleBizTypeEnum;
import com.oseasy.pcore.modules.sys.service.CoreService;
import com.oseasy.pcore.modules.sys.service.OfficeService;
import com.oseasy.pcore.modules.sys.service.UserService;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.pcore.modules.sys.utils.DictUtils;
import com.oseasy.putil.common.utils.DateUtil;
import com.oseasy.putil.common.utils.StringUtil;
import com.oseasy.putil.common.utils.exception.ExceptionUtil;

import net.sf.json.JSONObject;

/**
 * 用户Controller
 *
 * @version 2013-8-29
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/user")
public class UserController extends BaseController {

    @Autowired
    private SystemService systemService;
    @Autowired
    private CoreService coreService;
    @Autowired
    private OfficeService officeService;
    @Autowired
    UserService userService;
    @Autowired
    private ActTaskService actTaskService;

    @ModelAttribute
    public User get(@RequestParam(required = false) String id) {
        if (StringUtil.isNotBlank(id)) {
            User user = systemService.getUser(id);
            if (CoreUtils.checkHasRole(user, RoleBizTypeEnum.DS.getValue())) {
                String teacherType = systemService.getTeacherTypeByUserId(id);
                user.setTeacherType(teacherType);
            }
            return user;
        } else {
            return new User();
        }
    }

    // @RequiresPermissions("sys:user:view")
    @RequestMapping(value = {"index"})
    public String index(User user, Model model) {
        return "modules/sys/userIndex";

    }

    @RequiresPermissions("sys:user:view")
    @RequestMapping(value = {"list", ""})
    public String list(User user, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<User> page = systemService.findUser(new Page<User>(request, response), user);
        if (page != null) {
            List<User> userList = page.getList();
            if (userList != null && userList.size() > 0) {
                for (User usertmp : userList) {
                    List<Role> roleList = coreService.findListByUserId(usertmp.getId());
                    usertmp.setRoleList(roleList);
                }
            }
        }

        List<Role> roleList = systemService.findAllRole();
        if (roleList != null & roleList.size() > 0) {
           JSONObject js = new JSONObject();
           for (Role r : roleList) {
               js.put(r.getId(), r.getBizType());
           }
           model.addAttribute("rolesjs", js);
       }

        model.addAttribute("roleList", roleList);

        List<Dict> dictList = DictUtils.getDictList(User.DICT_TECHNOLOGY_FIELD);
        model.addAttribute("allDomains", dictList);
//        model.addAttribute("page", page);
        // return "modules/sys/userList";
        return "modules/sys/userListReDefine";
    }

    @RequestMapping(value="getUserList", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public ApiResult getUserList(User user, HttpServletRequest request, HttpServletResponse response, Model model){
        try {
            Page<User> page = systemService.findUser(new Page<User>(request, response), user);
            if (page != null) {
                List<User> userList = page.getList();
                if (userList != null && userList.size() > 0) {
                    for (User usertmp : userList) {
                        List<Role> roleList = coreService.findListByUserId(usertmp.getId());
                        usertmp.setRoleList(roleList);
                    }
                }
            }

            return ApiResult.success(page);
        }catch (Exception e){
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }

    @RequestMapping(value="checkUserIsAdmin", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public Boolean checkUserIsAdmin(){
        return CoreUtils.getUser().getAdmin() || CoreUtils.getUser().getSysAdmin();
    }

    // @RequiresPermissions("sys:user:view")
    @RequestMapping("userListTree")
    public String userListTree(User user, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<User> page = systemService.findUser(new Page<User>(request, response), user);
        if (page != null) {
            List<User> userList = page.getList();
            if (userList != null && userList.size() > 0) {
                for (User usertmp : userList) {
                    List<Role> roleList = coreService.findListByUserId(usertmp.getId());
                    usertmp.setRoleList(roleList);
                }
            }
        }

        List<Role> roleList = systemService.findAllRole();

        model.addAttribute("roleList", roleList);

        model.addAttribute("page", page);
        // return "modules/sys/userList";
        return "modules/sys/userListTree";
    }

    @RequestMapping("backUserListTree")
    public String backUserListTree(User user, String grade, String professionId, String allTeacher,
                                   HttpServletRequest request, HttpServletResponse response, Model model) {
        String userType = request.getParameter("userType");
        String teacherType = request.getParameter("teacherType");
        String userName = request.getParameter("userName");
        String ids = request.getParameter("ids");
        if (StringUtil.isNotBlank(userName)) {
            user.setIds(Arrays.asList(StringUtil.split(ids, StringUtil.DOTH)));
            model.addAttribute("ids", ids);
        }
        if (StringUtil.isNotBlank(userName)) {
            user.setName(userName);
            model.addAttribute("userName", userName);
        }

        if (StringUtil.isNotBlank(teacherType)) {
            user.setTeacherType(teacherType);
            model.addAttribute("teacherType", teacherType);
        }
        if ("1".equals(allTeacher)) {
            user.setTeacherType(null);
        }
        if (StringUtil.isNotBlank(grade) && "3".equals(grade)) {
            user.setProfessional(professionId);
        }

        Page<User> page = null;
        if (StringUtil.isNotEmpty(userType)) {
            user.setUserType(userType);

            if ((userType).equals("1")) {
                page = systemService.findListTreeByStudent(new Page<User>(request, response), user);
            } else if ((userType).equals("2")) {
                page = systemService.findListTreeByTeacher(new Page<User>(request, response), user);
            } else {
                page = systemService.findListTreeByUser(new Page<User>(request, response), user);
            }
        }

        model.addAttribute("page", page);
        model.addAttribute("userType", userType);
        return "modules/sys/backUserListTree";
    }

    // @RequiresPermissions("sys:user:view")
    @RequestMapping("userQyListTree")
    public String userQyListTree(User user, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<User> page = systemService.findUser(new Page<User>(request, response), user);
        if (page != null) {
            List<User> userList = page.getList();
            if (userList != null && userList.size() > 0) {
                for (User usertmp : userList) {
                    List<Role> roleList = coreService.findListByUserId(usertmp.getId());
                    usertmp.setRoleList(roleList);
                }
            }
        }
        List<Role> roleList = systemService.findAllRole();
        model.addAttribute("roleList", roleList);
        model.addAttribute("page", page);
        // return "modules/sys/userList";
        return "modules/sys/userListTree";
    }

    @ResponseBody
    @RequiresPermissions("sys:user:view")
    @RequestMapping(value = {"listData"})
    public Page<User> listData(User user, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<User> page = systemService.findUser(new Page<User>(request, response), user);
        return page;
    }


    /**
     * addby zhangzheng 检查输入的手机号是否已经注册过
     * @param mobile
     * @return true:没注册，允许修改
     */
    @RequestMapping(value = "checkMobileExist")
    @ResponseBody
    public Boolean checkMobileExist(String mobile, String id) {
        User userForSearch=new User();
        userForSearch.setMobile(mobile);
        User cuser=UserUtils.get(id);
        if (cuser==null||StringUtil.isEmpty(cuser.getId())) {
            return false;
        }
        userForSearch.setId(cuser.getId());
        User user = userService.getByMobileWithId(userForSearch);
        return user==null;
    }

    @RequiresPermissions("sys:user:view")
    @RequestMapping(value = "form")
    public String form(User user, Model model, HttpServletRequest request) {
        if (user.getCompany() == null || user.getCompany().getId() == null) {
            user.setCompany(CoreUtils.getUser().getCompany());
        }
        model.addAttribute("user", user);
        model.addAttribute("cuser", CoreUtils.getUser());
        List<Role> rs = systemService.findAllRole();
        model.addAttribute("allRoles", rs);
        if (rs != null & rs.size() > 0) {
            JSONObject js = new JSONObject();
            for (Role r : rs) {
                js.put(r.getId(), r.getBizType());
            }
            model.addAttribute("rolesjs", js);
        }

//        List<Dict> dictList = DictUtils.getDictList(ItDnStudent.DICT_TECHNOLOGY_FIELD);
//        model.addAttribute("allDomains", dictList);
        String secondName = request.getParameter("secondName");
        if (StringUtil.isNotEmpty(secondName)) {
            model.addAttribute("secondName", secondName);
        }
        return "modules/sys/userForm";
    }

    @RequestMapping(value = "save")
    public String save(User user, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
        String[] str = request.getParameterValues("domainIdList");
        if (str == null) {
            user.setDomainIdList(null);
            user.setDomain(null);
        }
        String oldLoginName = CoreUtils.getUser().getLoginName();
        if (Global.isDemoMode()) {
            addMessage(redirectAttributes, "演示模式，不允许操作！");
            return CoreSval.REDIRECT + adminPath + "/sys/user/list?repage";
        }
        // 修正引用赋值问题，不知道为何，Company和Office引用的一个实例地址，修改了一个，另外一个跟着修改。
        // user.setCompany(new Office(request.getParameter("company.id")));
        user.setOffice(new Office(request.getParameter("office.id")));
        String companyId = officeService.selelctParentId(user.getOffice().getId());
        user.setCompany(new Office());
        user.getCompany().setId((StringUtil.isNotEmpty(companyId)) ? companyId : CoreIds.SYS_OFFICE_TOP.getId());

        // 如果新密码为空，则不更换密码
        if (StringUtil.isNotBlank(user.getNewPassword())) {
            user.setPassword(CoreUtils.entryptPassword(user.getNewPassword()));
        }
        if (!beanValidator(model, user)) {
            return form(user, model, request);
        }
//        if (StringUtil.isNotEmpty(user.getId())) {// 修改时有加入的团队
//            List<Team> tel = teamDao.findTeamListByUserId(user.getId());
//            User old = UserUtils.get(user.getId());
//            if (old != null && StringUtil.isNotEmpty(old.getId())) {
//                String checkRole = UserUtils.checkRoleChange(user, old);
//                if (tel != null && tel.size() > 0 && checkRole != null) {// 用户类型变化了
//                    addMessage(model, "保存失败，该用户已加入团队，" + checkRole);
//                    return form(user, model, request);
//                }
//            }
//        }
//        if (StringUtil.isNotEmpty(user.getId()) && teamUserHistoryService.getBuildingCountByUserId(user.getId()) > 0) {// 修改时有正在进行的项目大赛
//            User old = UserUtils.get(user.getId());
//            if (old != null && StringUtil.isNotEmpty(old.getId())) {
//                String checkRole = UserUtils.checkRoleChange(user, old);
//                if (checkRole != null) {// 用户类型变化了
//                    addMessage(model, "保存失败，该用户有正在进行的项目或大赛，" + checkRole);
//                    return form(user, model, request);
//                } else if (CoreUtils.checkHasRole(old, RoleBizTypeEnum.DS.getValue())) {// 导师类型
//                    BackTeacherExpansion bte = backTeacherExpansionService.getByUserId(old.getId());
//                    if (bte != null && bte.getTeachertype() != null
//                            && !bte.getTeachertype().equals(user.getTeacherType())) {// 导师类型的用户导师来源发生变化
//                        addMessage(model, "保存失败，该用户有正在进行的项目或大赛，不能修改导师来源");
//                        return form(user, model, request);
//                    }
//                }
//            }
//        }

        if (!"true".equals(checkLoginName(user.getLoginName(), user.getId()))) {
            addMessage(model, "保存用户'" + user.getLoginName() + "'失败，登录名已存在");
            return form(user, model, request);
        }
        // 角色数据有效性验证，过滤不在授权内的角色
        List<Role> roleList = Lists.newArrayList();
        List<String> roleIdList = user.getRoleIdList();
        for (Role r : systemService.findAllRole()) {
            if (roleIdList.contains(r.getId())) {
                roleList.add(r);
            }
        }
        user.setRoleList(roleList);

        if (roleList == null || roleList.size() == 0) {
            addMessage(model, "保存失败，未选择角色");
            return form(user, model, request);
        }
        boolean hasStu = false;//是否有学生角色
        boolean hasTea = false;//是否有导师角色
        for (Role r : roleList) {
            if (StringUtil.isEmpty(r.getBizType())) {
                r.setBizType(CoreUtils.getRoleBizType(r.getId()));
            }
            if (RoleBizTypeEnum.XS.getValue().equals(r.getBizType())) {
                hasStu = true;
            }
            if (RoleBizTypeEnum.DS.getValue().equals(r.getBizType())) {
                hasTea = true;
            }
        }
        if (hasStu && hasTea) {
            addMessage(model, "保存失败，不能同时选择学生和导师角色");
            return form(user, model, request);
        }
        if (hasStu) {
            user.setUserType(RoleBizTypeEnum.XS.getValue());
        } else if (hasTea) {
            user.setUserType(RoleBizTypeEnum.DS.getValue());
        } else {
            user.setUserType(null);
        }
        // 保存用户信息
        // logger.info("============user.domain:"+user.getDomain());

        String returnMessage = systemService.saveUser(user);
        if ("1".equals(returnMessage)) {
            addMessage(redirectAttributes, "添加用户成功！初始密码设置为：123456");

        } else if ("2".equals(returnMessage)) {
            addMessage(redirectAttributes, "修改用户成功！");
        }
        // 清除当前用户缓存
        if (user.getLoginName().equals(CoreUtils.getUser().getLoginName())) {
            UserUtils.clearCache();
            // CoreUtils.getCacheMap().clear();
        }
        if (user.getId().equals(CoreUtils.getUser().getId()) && !user.getLoginName().equals(oldLoginName)) {
            UserUtils.getSubject().logout();
        }
        // addMessage(redirectAttributes, "保存用户'" + user.getLoginName() +
        // "'成功");
        return CoreSval.REDIRECT + adminPath + "/sys/user/list?repage";
    }


    @RequestMapping(value = "ajaxSaveUser", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public ApiResult ajaxSaveUser(User user, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
        try {
       			HashMap<String, Object> hashMap = new HashMap<>();
        String[] str = request.getParameterValues("domainIdList");
        if (str == null) {
            user.setDomainIdList(null);
            user.setDomain(null);
        }
        String oldLoginName = CoreUtils.getUser().getLoginName();
        if (Global.isDemoMode()) {
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"演示模式，不允许操作！");

        }
        // 修正引用赋值问题，不知道为何，Company和Office引用的一个实例地址，修改了一个，另外一个跟着修改。
        // user.setCompany(new Office(request.getParameter("company.id")));
            String officeId = request.getParameter("officeId");
            if(StringUtil.isNotEmpty(officeId)){
                user.setOffice(officeService.get(request.getParameter("officeId")));
            }else {
                user.setOffice(new Office());
            }
            String companyId = officeService.selelctParentId(user.getOffice().getId());
            user.setCompany(new Office());
            user.getCompany().setId((StringUtil.isNotEmpty(companyId)) ? companyId : CoreIds.SYS_OFFICE_TOP.getId());


        // 如果新密码为空，则不更换密码
        if (StringUtil.isNotBlank(user.getNewPassword())) {
            user.setPassword(CoreUtils.entryptPassword(user.getNewPassword()));
        }
        if (!beanValidator(model, user)) {
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"数据格式不对");

        }
//        if (StringUtil.isNotEmpty(user.getId())) {// 修改时有加入的团队
//            List<Team> tel = teamDao.findTeamListByUserId(user.getId());
//            User old = UserUtils.get(user.getId());
//            if (old != null && StringUtil.isNotEmpty(old.getId())) {
//                String checkRole = UserUtils.checkRoleChange(user, old);
//                if (tel != null && tel.size() > 0 && checkRole != null) {// 用户类型变化了
//                    addMessage(model, "保存失败，该用户已加入团队，" + checkRole);
//                    return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+ "保存失败，该用户已加入团队，" + checkRole);
//
//                }
//            }
//        }
//        if (StringUtil.isNotEmpty(user.getId()) && teamUserHistoryService.getBuildingCountByUserId(user.getId()) > 0) {// 修改时有正在进行的项目大赛
//            User old = UserUtils.get(user.getId());
//            if (old != null && StringUtil.isNotEmpty(old.getId())) {
//                String checkRole = UserUtils.checkRoleChange(user, old);
//                if (checkRole != null) {// 用户类型变化了
//                    return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"保存失败，该用户有正在进行的项目或大赛，" + checkRole);
//
//                } else if (CoreUtils.checkHasRole(old, RoleBizTypeEnum.DS.getValue())) {// 导师类型
//                    BackTeacherExpansion bte = backTeacherExpansionService.getByUserId(old.getId());
//                    if (bte != null && bte.getTeachertype() != null
//                            && !bte.getTeachertype().equals(user.getTeacherType())) {// 导师类型的用户导师来源发生变化
//                        return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"保存失败，该用户有正在进行的项目或大赛，不能修改导师来源");
//                    }
//                }
//            }
//        }

        if (!"true".equals(checkLoginName(user.getLoginName(), user.getId()))) {
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"保存用户'" + user.getLoginName() + "'失败，登录名已存在");
        }
        // 角色数据有效性验证，过滤不在授权内的角色
        List<Role> roleList = Lists.newArrayList();
        List<String> roleIdList = user.getRoleIdList();
        for (Role r : systemService.findAllRole()) {
            if (roleIdList.contains(r.getId())) {
                roleList.add(r);
            }
        }
        user.setRoleList(roleList);

        if (roleList == null || roleList.size() == 0) {
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"保存失败，未选择角色");
        }
        boolean hasStu = false;//是否有学生角色
        boolean hasTea = false;//是否有导师角色
        for (Role r : roleList) {
            if (StringUtil.isEmpty(r.getBizType())) {
                r.setBizType(CoreUtils.getRoleBizType(r.getId()));
            }
            if (RoleBizTypeEnum.XS.getValue().equals(r.getBizType())) {
                hasStu = true;
            }
            if (RoleBizTypeEnum.DS.getValue().equals(r.getBizType())) {
                hasTea = true;
            }
        }
        if (hasStu && hasTea) {
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+"保存失败，不能同时选择学生和导师角色");
        }
        if (hasStu) {
            user.setUserType(RoleBizTypeEnum.XS.getValue());
        } else if (hasTea) {
            user.setUserType(RoleBizTypeEnum.DS.getValue());
        } else {
            user.setUserType(null);
        }
        // 保存用户信息
        // logger.info("============user.domain:"+user.getDomain());

        String returnMessage = systemService.saveUser(user);
        String msg ="";
        if ("1".equals(returnMessage)) {
            //addMessage(redirectAttributes, "添加用户成功！初始密码设置为：123456");
            msg="添加用户成功！初始密码设置为：123456";

        } else if ("2".equals(returnMessage)) {
            //addMessage(redirectAttributes, "修改用户成功！");
            msg="修改用户成功！";
        }
        // 清除当前用户缓存
        if (user.getLoginName().equals(CoreUtils.getUser().getLoginName())) {
            UserUtils.clearCache();
            // UserUtils.getCacheMap().clear();
        }
        if (user.getId().equals(CoreUtils.getUser().getId()) && !user.getLoginName().equals(oldLoginName)) {
            UserUtils.getSubject().logout();
        }
        return  ApiResult.success(hashMap,msg);
        }catch (Exception e){
            logger.error(e.getMessage());
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }

    //重置密码
    @RequiresPermissions("sys:user:edit")
    @RequestMapping(value = "resetpwd")
    public String resetpwd(User user, RedirectAttributes redirectAttributes) {

        coreService.updatePasswordById(user.getId(), CoreUtils.getUser().getLoginName(), CoreUtils.USER_PSW_DEFAULT);
        addMessage(redirectAttributes, "重置密码成功！密码已重置为：123456");
        return CoreSval.REDIRECT + adminPath + "/sys/user/list?repage";
    }


    @RequestMapping(value="resetPassword", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public ApiResult resetPassword(@RequestBody User user){
        try {
            coreService.updatePasswordById(user.getId(), CoreUtils.getUser().getLoginName(), CoreUtils.USER_PSW_DEFAULT);
            return ApiResult.success();
        }catch (Exception e){
            logger.error(ExceptionUtil.getStackTrace(e));
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }

    @RequestMapping(value="delUser", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public ApiResult delUser(@RequestBody User user){
        try {
            if (CoreUtils.getUser().getId().equals(user.getId())) {
                return ApiResult.failed(ApiConst.STATUS_FAIL,ApiConst.getErrMsg(ApiConst.STATUS_FAIL)+":删除用户失败, 不允许删除当前用户");
            } else if (User.getAdmin(user.getId())) {
                return ApiResult.failed(ApiConst.STATUS_FAIL,ApiConst.getErrMsg(ApiConst.STATUS_FAIL)+":删除用户失败, 不允许删除超级管理员用户");
            } else {
                int todoNum = actTaskService.recordUserId(user.getId());
                if (todoNum > 0) {
                    return ApiResult.failed(ApiConst.STATUS_FAIL,ApiConst.getErrMsg(ApiConst.STATUS_FAIL)+":该用户还有流程任务，不能删除!");
                }
                // 删除对应的学生信息
//                if (CoreUtils.checkHasRole(user, RoleBizTypeEnum.XS.getValue())) {
//                    TeamUserRelation teamUserRelation = new TeamUserRelation();
//                    StudentExpansion studentExpansion = studentExpansionService.getByUserId(user.getId());
//                    teamUserRelation.setUser(user);
//                    teamUserRelation = teamUserRelationService.findUserById(teamUserRelation);
//                    if (teamUserRelation != null) {
//                        return ApiResult.failed(ApiConst.STATUS_FAIL,ApiConst.getErrMsg(ApiConst.STATUS_FAIL)+":该学生已加入团队，不能删除!");
//                    }
//                    studentExpansionService.delete(studentExpansion);
//                }
//                // 删除对应的老师信息
//                if (CoreUtils.checkHasRole(user, RoleBizTypeEnum.DS.getValue())) {
//                    TeamUserRelation teamUserRelation = new TeamUserRelation();
//                    teamUserRelation.setUser(user);
//                    teamUserRelation = teamUserRelationService.findUserById(teamUserRelation);
//                    if (teamUserRelation != null) {
//                        return ApiResult.failed(ApiConst.STATUS_FAIL,ApiConst.getErrMsg(ApiConst.STATUS_FAIL)+":该导师已加入团队，不能删除!");
//                    }
//                    BackTeacherExpansion backTeacherExpansion = backTeacherExpansionService
//                            .findTeacherByUserId(user.getId());
//                    backTeacherExpansionService.delete(backTeacherExpansion);
//                }

                coreService.deleteUser(user); // 删除用户

                return ApiResult.success();
            }
        }catch (Exception e){
            logger.error(ExceptionUtil.getStackTrace(e));
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }

    @RequiresPermissions("sys:user:edit")
    @RequestMapping(value = "delete")
    public String delete(User user, RedirectAttributes redirectAttributes) {
        if (CoreUtils.getUser().getId().equals(user.getId())) {
            addMessage(redirectAttributes, "删除用户失败, 不允许删除当前用户");
        } else if (User.getAdmin(user.getId())) {
            addMessage(redirectAttributes, "删除用户失败, 不允许删除超级管理员用户");
        } else {
            int todoNum = actTaskService.recordUserId(user.getId());
            if (todoNum > 0) {
                addMessage(redirectAttributes, "该用户还有流程任务，不能删除!");
                return CoreSval.REDIRECT + adminPath + "/sys/user/list?repage";
            }
//            // 删除对应的学生信息
//            if (CoreUtils.checkHasRole(user, RoleBizTypeEnum.XS.getValue())) {
//                TeamUserRelation teamUserRelation = new TeamUserRelation();
//                StudentExpansion studentExpansion = studentExpansionService.getByUserId(user.getId());
//                teamUserRelation.setUser(user);
//                teamUserRelation = teamUserRelationService.findUserById(teamUserRelation);
//                if (teamUserRelation != null) {
//                    addMessage(redirectAttributes, "该学生已加入团队，不能删除!");
//                    return CoreSval.REDIRECT + adminPath + "/sys/user/list?repage";
//                }
//                studentExpansionService.delete(studentExpansion);
//            }
//            // 删除对应的老师信息
//            if (CoreUtils.checkHasRole(user, RoleBizTypeEnum.DS.getValue())) {
//                TeamUserRelation teamUserRelation = new TeamUserRelation();
//                teamUserRelation.setUser(user);
//                teamUserRelation = teamUserRelationService.findUserById(teamUserRelation);
//                if (teamUserRelation != null) {
//                    addMessage(redirectAttributes, "该导师已加入团队，不能删除!");
//                    return CoreSval.REDIRECT + adminPath + "/sys/user/list?repage";
//                }
//                BackTeacherExpansion backTeacherExpansion = backTeacherExpansionService
//                        .findTeacherByUserId(user.getId());
//                backTeacherExpansionService.delete(backTeacherExpansion);
//            }

            coreService.deleteUser(user); // 删除用户

            addMessage(redirectAttributes, "删除用户成功");
        }
        return CoreSval.REDIRECT + adminPath + "/sys/user/list?repage";
    }

    @RequiresPermissions("sys:user:edit")
    @RequestMapping(value = "deletePL")
    public String deletePL(User user, RedirectAttributes redirectAttributes) {
        if(StringUtil.checkEmpty(user.getIds())){
            addMessage(redirectAttributes, "请选择用户!");
            return CoreSval.REDIRECT + adminPath + "/sys/user/list?repage";
        }

        User curUser = null;
        for (String cid : user.getIds()) {
            if (((CoreUtils.getUser().getId()).equals(user.getId())) || User.getAdmin(user.getId())) {
                continue;
            }

            int todoNum = actTaskService.recordUserId(user.getId());
            if (todoNum > 0) {
                continue;
            }
            curUser = new User(cid);
//            // 删除对应的学生信息
//            if (CoreUtils.checkHasRole(curUser, RoleBizTypeEnum.XS.getValue())) {
//                TeamUserRelation teamUserRelation = new TeamUserRelation();
//                StudentExpansion studentExpansion = studentExpansionService.getByUserId(user.getId());
//                teamUserRelation.setUser(user);
//                teamUserRelation = teamUserRelationService.findUserById(teamUserRelation);
//                if (teamUserRelation != null) {
//                    continue;
//                }
//                studentExpansionService.delete(studentExpansion);
//            }
//
//            // 删除对应的老师信息
//            if (CoreUtils.checkHasRole(curUser, RoleBizTypeEnum.DS.getValue())) {
//                TeamUserRelation teamUserRelation = new TeamUserRelation();
//                teamUserRelation.setUser(user);
//                teamUserRelation = teamUserRelationService.findUserById(teamUserRelation);
//                if (teamUserRelation != null) {
//                    continue;
//                }
//                BackTeacherExpansion backTeacherExpansion = backTeacherExpansionService.findTeacherByUserId(user.getId());
//                backTeacherExpansionService.delete(backTeacherExpansion);
//            }
            coreService.deleteUser(user); // 删除用户
        }
        return CoreSval.REDIRECT + adminPath + "/sys/user/list?repage";
    }

    @RequestMapping(value="ajaxDelUser", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public ApiResult ajaxDelUser(@RequestBody User user){
        try {
            User curUser = null;
            List<String> idList=user.getIds();
            for (String cid :idList) {
                if (((CoreUtils.getUser().getId()).equals(cid))|| User.getAdmin(cid)) {
                    return ApiResult.failed(ApiConst.STATUS_FAIL,ApiConst.getErrMsg(ApiConst.STATUS_FAIL)+":删除用户失败, 不允许删除超级管理员用户");
                }

                int todoNum = actTaskService.recordUserId(cid);
                if (todoNum > 0) {
                    return ApiResult.failed(ApiConst.STATUS_FAIL,ApiConst.getErrMsg(ApiConst.STATUS_FAIL)+":该用户还有流程任务，不能删除!");
                }
                curUser = UserUtils.get(cid);
               // 删除对应的学生信息
//                if (CoreUtils.checkHasRole(curUser, RoleBizTypeEnum.XS.getValue())) {
//                    TeamUserRelation teamUserRelation = new TeamUserRelation();
//                    StudentExpansion studentExpansion = studentExpansionService.getByUserId(cid);
//                    teamUserRelation.setUser(curUser);
//                    teamUserRelation = teamUserRelationService.findUserById(teamUserRelation);
//                    if (teamUserRelation != null) {
//                        continue;
//                    }
//                        studentExpansionService.delete(studentExpansion);
//                }
//               // 删除对应的老师信息
//                if (CoreUtils.checkHasRole(curUser, RoleBizTypeEnum.DS.getValue())) {
//                    TeamUserRelation teamUserRelation = new TeamUserRelation();
//                    teamUserRelation.setUser(curUser);
//                    teamUserRelation = teamUserRelationService.findUserById(teamUserRelation);
//                    if (teamUserRelation != null) {
//                        continue;
//                    }
//                    BackTeacherExpansion backTeacherExpansion = backTeacherExpansionService.findTeacherByUserId(cid);
//                    backTeacherExpansionService.delete(backTeacherExpansion);
//                }
                coreService.deleteUser(curUser); // 删除用户
            }
            return ApiResult.success();
        }catch (Exception e){
            logger.error(ExceptionUtil.getStackTrace(e));
            return ApiResult.failed(ApiConst.CODE_INNER_ERROR,ApiConst.getErrMsg(ApiConst.CODE_INNER_ERROR)+":"+e.getMessage());
        }
    }


    /**
     * 导出用户数据
     *
     * @param user
     * @param request
     * @param response
     * @param redirectAttributes
     * @return
     */
    @RequiresPermissions("sys:user:view")
    @RequestMapping(value = "export", method = RequestMethod.POST)
    public String exportFile(User user, HttpServletRequest request, HttpServletResponse response,
                             RedirectAttributes redirectAttributes) {
        try {
            String fileName = "用户数据" + DateUtil.getDate("yyyyMMddHHmmss") + ".xlsx";
            Page<User> page = systemService.findUser(new Page<User>(request, response, -1), user);
            new ExportExcel("用户数据", User.class).setDataList(page.getList()).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            addMessage(redirectAttributes, "导出用户失败！失败信息：" + e.getMessage());
        }
        return CoreSval.REDIRECT + adminPath + "/sys/user/list?repage";
    }

    /**
     * 导入用户数据
     *
     * @param file
     * @param redirectAttributes
     * @return
     */
    /*
	 * @RequiresPermissions("sys:user:edit")
	 *
	 * @RequestMapping(value = "import", method=RequestMethod.POST) public
	 * String importFile(MultipartFile file, RedirectAttributes
	 * redirectAttributes) { if (Global.isDemoMode()) {
	 * addMessage(redirectAttributes, "演示模式，不允许操作！"); return CoreSval.REDIRECT +
	 * adminPath + "/sys/user/list?repage"; } try { int successNum = 0; int
	 * failureNum = 0; StringBuilder failureMsg = new StringBuilder();
	 * ImportExcel ei = new ImportExcel(file, 1, 0); List<User> list =
	 * ei.getDataList(User.class); for (User user : list) { try{ if
	 * ("true".equals(checkLoginName("", user.getLoginName(),""))) {
	 * user.setPassword(SystemService.entryptPassword(SystemService.USER_PSW_DEFAULT));
	 * BeanValidators.validateWithException(validator, user);
	 * systemService.saveUser(user); successNum++; }else{ failureMsg.append(
	 * "<br/>登录名 "+user.getLoginName()+" 已存在; "); failureNum++; }
	 * }catch(ConstraintViolationException ex) { failureMsg.append("<br/>登录名 "
	 * +user.getLoginName()+" 导入失败："); List<String> messageList =
	 * BeanValidators.extractPropertyAndMessageAsList(ex, ": "); for (String
	 * message : messageList) { failureMsg.append(message+"; "); failureNum++; }
	 * }catch (Exception ex) { failureMsg.append("<br/>登录名 "
	 * +user.getLoginName()+" 导入失败："+ex.getMessage()); } } if (failureNum>0) {
	 * failureMsg.insert(0, "，失败 "+failureNum+" 条用户，导入信息如下："); }
	 * addMessage(redirectAttributes, "已成功导入 "+successNum+" 条用户"+failureMsg); }
	 * catch (Exception e) { addMessage(redirectAttributes,
	 * "导入用户失败！失败信息："+e.getMessage()); } return CoreSval.REDIRECT + adminPath +
	 * "/sys/user/list?repage"; }
	 */

    /**
     * 下载导入用户数据模板
     *
     * @param response
     * @param redirectAttributes
     * @return
     */
    @RequiresPermissions("sys:user:view")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
        try {
            String fileName = "用户数据导入模板.xlsx";
            List<User> list = Lists.newArrayList();
            list.add(CoreUtils.getUser());
            new ExportExcel("用户数据", User.class, 2).setDataList(list).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
        }
        return CoreSval.REDIRECT + adminPath + "/sys/user/list?repage";
    }

    /**
     * 检查loginName 登录名不能与其他人的登录名相同，不能与其他人的no相同
     *
     * @param loginName
     * @param userid
     * @return
     */
    @ResponseBody
    @RequiresPermissions("sys:user:edit")
    @RequestMapping(value = "checkLoginName")
    public String checkLoginName(String loginName, String userid) {
        if (userService.getByLoginNameOrNo(loginName, userid) == null) {
            return "true";
        }
        return "false";
    }

    /**
     * 用户信息显示及保存
     *
     * @param user
     * @param model
     * @return
     */
    @RequiresPermissions("user")
    @RequestMapping(value = "info")
    public String info(User user, HttpServletResponse response, Model model) {
        User currentUser = CoreUtils.getUser();
        if (StringUtil.isNotBlank(user.getName())) {
            if (Global.isDemoMode()) {
                model.addAttribute("message", "演示模式，不允许操作！");
                return "modules/sys/userInfo";
            }
            currentUser.setEmail(user.getEmail());
            currentUser.setPhone(user.getPhone());
            currentUser.setMobile(user.getMobile());
            currentUser.setRemarks(user.getRemarks());
            currentUser.setPhoto(user.getPhoto());
            coreService.updateUserInfo(currentUser);
            model.addAttribute("message", "保存用户信息成功");
        }
        model.addAttribute("user", currentUser);
        model.addAttribute("Global", new Global());
        return "modules/sys/userInfo";
    }

    /**
     * 返回用户信息
     *
     * @return
     */
    @RequiresPermissions("user")
    @ResponseBody
    @RequestMapping(value = "infoData")
    public User infoData() {
        return CoreUtils.getUser();
    }

    /**
     * 修改个人用户密码
     *
     * @param oldPassword
     * @param newPassword
     * @param model
     * @return
     */
    @RequiresPermissions("user")
    @RequestMapping(value = "modifyPwd")
    public String modifyPwd(String oldPassword, String newPassword, Model model) {
        User user = CoreUtils.getUser();
        if (StringUtil.isNotBlank(oldPassword) && StringUtil.isNotBlank(newPassword)) {
            if (Global.isDemoMode()) {
                model.addAttribute("message", "演示模式，不允许操作！");
                return "modules/sys/userModifyPwd";
            }
            if (CoreUtils.validatePassword(oldPassword, user.getPassword())) {
                coreService.updatePasswordById(user.getId(), user.getLoginName(), newPassword);
                model.addAttribute("message", "修改密码成功");
            } else {
                model.addAttribute("message", "修改密码失败，旧密码错误");
            }
        }
        model.addAttribute("user", user);
        return "modules/sys/userModifyPwd";
    }

    @RequiresPermissions("user")
    @ResponseBody
    @RequestMapping(value = "treeData")
    public List<Map<String, Object>> treeData(@RequestParam(required = false) String officeId,
                                              HttpServletResponse response) {
        List<Map<String, Object>> mapList = Lists.newArrayList();
        List<User> list = coreService.findUserByOfficeId(officeId);
        for (int i = 0; i < list.size(); i++) {
            User e = list.get(i);
            Map<String, Object> map = Maps.newHashMap();
            map.put("id", "u_" + e.getId());
            map.put("pId", officeId);
            map.put("name", StringUtil.replace(e.getName(), " ", ""));
            mapList.add(map);
        }
        return mapList;
    }

    @ResponseBody
    @RequestMapping(value = "checkMobile")
    public String checkMobile(@RequestParam(value = "mobile") String mobile, @RequestParam(value = "id") String id) {
        if (mobile != null && coreService.getUserByMobile(mobile, id) == null) {
            return "true";
        }
        return "false";
    }

    /**
     * 检查学号，学号不能与其他人的学号相同，不能与其他人的loginName相同
     *
     * @param userid
     * @param no
     * @return
     */
    @RequestMapping(value = "checkNo")
    @ResponseBody
    public String checkNo(String no, String userid) {
        if (userService.getByLoginNameOrNo(no, userid) == null) {
            return "true";
        }
        return "false";
    }

    @ResponseBody
    @RequestMapping(value = "uploadPhoto")
    public boolean uploadFTP(HttpServletRequest request, User user) {
        String arrUrl = request.getParameter("arrUrl");
        if (user != null) {
            user.setPhoto(arrUrl);
            userService.updateUser(user);
        }
        return true;
    }

    /**
     * 修复学生导师用户没有角色.
     *
     * @param rid
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "repaireStudentRole/{rid}")
    public ApiTstatus<List<String>> repaireStudentRole(@PathVariable("rid") String rid) {
        if (StringUtil.isNotEmpty(rid)) {
            return coreService.insertPLUserRole(rid, userService.findUserByRepair());
        }
        return new ApiTstatus<List<String>>(false, "修复失败,角色ID为空!");
    }

    @RequestMapping(value="checkUserNoUnique", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public Boolean checkUserNoUnique(@RequestBody User user){
        return userService.checkUserNoUnique(user);
    }

}
