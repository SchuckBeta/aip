/**
 *
 */
package com.oseasy.initiate.modules.sys.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.oseasy.initiate.common.config.SysIds;
import com.oseasy.initiate.modules.sys.enums.EuserType;
import com.oseasy.initiate.modules.sys.enums.RoleBizTypeEnum;
import com.oseasy.initiate.modules.sys.vo.Utype;
import com.oseasy.pact.modules.act.service.ActTaskService;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.BaseService;
import com.oseasy.pcore.common.utils.CacheUtils;
import com.oseasy.pcore.common.utils.IdGen;
import com.oseasy.pcore.modules.sys.dao.MenuDao;
import com.oseasy.pcore.modules.sys.dao.RoleDao;
import com.oseasy.pcore.modules.sys.dao.UserDao;
import com.oseasy.pcore.modules.sys.entity.Menu;
import com.oseasy.pcore.modules.sys.entity.Role;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.security.SystemAuthorizingRealm;
import com.oseasy.pcore.modules.sys.service.CoreService;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.pcore.modules.sys.utils.LogUtils;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 系统管理，安全相关实体的管理类,包括用户、角色、菜单.
 */
@Service
@Transactional(readOnly = true)
public class SystemService extends BaseService implements InitializingBean {
    @Autowired
    private UserDao userDao;
    @Autowired
    private RoleDao roleDao;
    @Autowired
    private MenuDao menuDao;
    @Resource
    private SystemAuthorizingRealm systemAuthorizingRealm;
    @Autowired
    private CoreService coreService;

    /*************************************************************
     * 公共处理的方法.
     *************************************************************/
    /**has rolelist
     * 获取用户
     *
     * @param id
     * @return
     */
    public User getUser(String id) {
        return CoreUtils.get(id);
    }

    /**
     * 查询学生.
     *
     * @param page 分页
     * @param user 用户
     * @return Page
     */
    public Page<User> findListTreeByUser(Page<User> page, User user) {
        // 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
        //user.getSqlMap().put("dsf", dataScopeFilter(user.getCurrentUser(), "o", "a"));
        // 设置分页参数
        user.setPage(page);
        // 执行分页查询
        List<User> list =userDao.findListTreeByUser(user);
//        if(list!=null&&list.size()>0){
//            List<User> us=teamUserHistoryDao.getUserCurJoinByUsers(list);
//            Map<String,String> map=new HashMap<String,String>();
//            if(us!=null&&us.size()>0){
//                for(User u:us){
//                    map.put(u.getId(), u.getCurJoin());
//                }
//            }
//            for(User s:list){
//                s.setCurJoin(map.get(s.getId()));
//            }
//        }
        page.setList(list);
        return page;
    }

    public void afterPropertiesSet() throws Exception {
        coreService.afterPropertiesSet();
    }

    public Page<User> findUser(Page<User> page, User user) {
        return coreService.findUser(page, user);
    }

    public Page<User> findUserByExpert(Page<User> page, User user) {
        return coreService.findUserByExpert(page, user);
    }

    public String getTeacherTypeByUserId(String userId) {
        return userDao.getTeacherTypeByUserId(userId);
    }

    public Page<User> findListTree(Page<User> page, User user) {
        return coreService.findListTree(page, user);
    }


    /**
     * 查询导师.
     *
     * @param page 分页
     * @param user 用户
     * @return Page
     */
    public Page<User> findListTreeByTeacher(Page<User> page, User user) {
        // 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
        //user.getSqlMap().put("dsf", dataScopeFilter(user.getCurrentUser(), "o", "a"));
        // 设置分页参数
        user.setPage(page);
        // 执行分页查询
        List<User> list =userDao.findListTreeByTeacher(user);
//        if(list!=null&&list.size()>0){
//            List<User> us=teamUserHistoryDao.getUserCurJoinByUsers(list);
//            Map<String,String> map=new HashMap<String,String>();
//            if(us!=null&&us.size()>0){
//                for(User u:us){
//                    map.put(u.getId(), u.getCurJoin());
//                }
//            }
//            for(User s:list){
//                s.setCurJoin(map.get(s.getId()));
//            }
//        }
        page.setList(list);
        return page;
    }


    /**
     * 查询学生.
     *
     * @param page 分页
     * @param user 用户
     * @return Page
     */
    public Page<User> findListTreeByStudent(Page<User> page, User user) {
        // 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
        //user.getSqlMap().put("dsf", dataScopeFilter(user.getCurrentUser(), "o", "a"));
        // 设置分页参数
        user.setPage(page);
        // 执行分页查询
        List<User> list = userDao.findListTreeByStudentNoDomain(user);
//        if(list!=null&&list.size()>0){
//            List<User> us=teamUserHistoryDao.getUserCurJoinByUsers(list);
//            Map<String,String> map=new HashMap<String,String>();
//            if(us!=null&&us.size()>0){
//                for(User u:us){
//                    map.put(u.getId(), u.getCurJoin());
//                }
//            }
//            for(User s:list){
//                s.setCurJoin(map.get(s.getId()));
//                List<Dict> dicts = DictUtils.getDictListByType(User.DICT_TECHNOLOGY_FIELD);
//
//                //处理技术领域
//                if(StringUtil.isEmpty(s.getDomain())){
//                    continue;
//                }
//
//                if(s.getDomainIdList() == null){
//                    s.setDomainIdList(Lists.newArrayList());
//                }
//
//                for (Dict dict : dicts) {
//                    if(s.getDomain().contains(dict.getValue())){
//                        s.getDomainIdList().add(dict.getLabel());
//                    }
//                }
//            }
//        }
        page.setList(list);
        return page;
    }

    /**
     * 通过专业ID获取用户列表，仅返回用户id和name（树查询用户时用）
     * @param
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<User> findUserByProfessionId(String professionalId) {
        return coreService.findUserByProfessionId(professionalId);
    }
    public List<User> findUserByProfessionIdAndRoleType(String professionalId,RoleBizTypeEnum roletype) {
        User user = new User();
        user.setProfessional(professionalId);
        List<String> rbts=new ArrayList<String>();
        rbts.add(roletype.getValue());
        user.setRoleBizTypes(rbts);
        return userDao.findUserByProfessionIdAndRoleType(user);
    }

    @Transactional(readOnly = false)
    public String saveUser(User user) {
//        if (StringUtil.isBlank(user.getId())) {
//            //新增时默认设置密码为123456
//            if(StringUtil.isEmpty(user.getPassword())){
//                user.setPassword(CoreUtils.entryptPassword(CoreUtils.USER_PSW_DEFAULT));
//            }
//            user.preInsert();
//            userDao.insert(user);
//            if (UserUtils.checkHasRole(user, RoleBizTypeEnum.XS)) {
//                StudentExpansion studentExpansion = new StudentExpansion();
//                //studentExpansion.setId(IdGen.uuid());
//                studentExpansion.setUser(user);
//                saveStudentExpansion(studentExpansion);
//            } else if (UserUtils.checkHasRole(user, RoleBizTypeEnum.DS)) {
//                BackTeacherExpansion backTeacherExpansion = new BackTeacherExpansion();
//                //backTeacherExpansion.setId(IdGen.uuid());
//                backTeacherExpansion.setUser(user);
//                if(StringUtil.isNotEmpty(user.getTeacherType())){
//                    backTeacherExpansion.setTeachertype(user.getTeacherType());
//                }else{
//                    backTeacherExpansion.setTeachertype(TeacherType.TY_XY.getKey());
//                }
//                backTeacherExpansionService.save(backTeacherExpansion);
//            }
//
//            // 更新用户与角色关联
//            userDao.deleteUserRole(user);
//            if (user.getRoleList() != null && user.getRoleList().size() > 0) {
//                userDao.insertUserRole(user);
//            } else {
//                throw new ServiceException(user.getLoginName() + "没有设置角色！");
//            }
//            // 将当前用户同步到Activiti
//            coreService.saveActivitiUser(user);
//            // 清除用户缓存
//            CoreUtils.clearCache(user);
//
//            return "1";
//        } else {
//            // 清除原用户机构用户缓存
//            User oldUser = userDao.get(user.getId());
//            if (oldUser.getOffice() != null && oldUser.getOffice().getId() != null) {
//                CacheUtils.remove(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_LIST_BY_OFFICE_ID_ + oldUser.getOffice().getId());
//            }
//            // 更新用户数据
//            user.preUpdate();
//            userDao.update(user);
//
//            if (UserUtils.checkHasRole(user, RoleBizTypeEnum.DS)) {
//                BackTeacherExpansion backTeacherExpansion = backTeacherExpansionService.findTeacherByUserId(user.getId());
//                if (backTeacherExpansion == null) {
//                    backTeacherExpansion = new BackTeacherExpansion();
//                }
//                backTeacherExpansion.setUser(user);
//                if(StringUtil.isNotEmpty(user.getTeacherType())){
//                    backTeacherExpansion.setTeachertype(user.getTeacherType());
//                }else{
//                    backTeacherExpansion.setTeachertype(TeacherType.TY_XY.getKey());
//                }
//                backTeacherExpansionService.save(backTeacherExpansion);
//            }
//            // 更新用户与角色关联
//            userDao.deleteUserRole(user);
//            if (user.getRoleList() != null && user.getRoleList().size() > 0) {
//                userDao.insertUserRole(user);
//            } else {
//                throw new ServiceException(user.getLoginName() + "没有设置角色！");
//            }
//            // 将当前用户同步到Activiti
//            coreService.saveActivitiUser(user);
//            // 清除用户缓存
//            CoreUtils.clearCache(user);
//            return  "2";
//
//        }
        return "1";
    }

    public Role getRole(String id) {
        return roleDao.get(id);
    }

    public Map<String, String> validateUserRegister(User user) {
        Map<String, String> result = new HashMap<>();
        Integer num = coreService.checkLoginNameUnique(user.getLoginName(), user.getId());
        if (!org.springframework.util.StringUtils.isEmpty(num) && num > 0) {
            result.put("code", "200");
            result.put("msg", "登录名已存在");
            return result;
        }
        if (StringUtils.isNotBlank(user.getMobile())) {
            num = coreService.checkMobileUnique(user.getMobile(), user.getId());
            if (!org.springframework.util.StringUtils.isEmpty(num) && num > 0) {
                result.put("code", "200");
                result.put("msg", "手机号已存在");
                return result;
            }
        }

        if (!org.springframework.util.StringUtils.isEmpty(user.getNo())) {
            num = coreService.checkNoUnique(user.getNo(), user.getId());
            if (!org.springframework.util.StringUtils.isEmpty(num) && num > 0) {
                String msg = user.getUserType().equals(EuserType.UT_C_STUDENT.getType()) ? "学号" : "工号";
                result.put("code", "200");
                result.put("msg", msg + "已存在");
                return result;
            }
        }
        result.put("code", "0");
        return result;
    }

    public Role getNamebyId(String id) {
        return coreService.getNamebyId(id);
    }

    public Role getRoleByName(String name) {
        return coreService.getRoleByName(name);
    }
    public Role getRoleByEnname(String enname) {
        return coreService.getRoleByEnname(enname);
    }

    public List<Role> findRole(Role role) {
        return coreService.findRole(role);
    }

    public List<Role> findAllRole() {
        return coreService.findAllRole();
    }

    //-- Menu Service --//

    @Transactional(readOnly = false)
    public Boolean outUserInRole(Role role, User user) {
        List<Role> roles = user.getRoleList();
        for (Role e : roles) {
            if (e.getId().equals(role.getId())) {
                roles.remove(e);
                saveUser(user);
                return true;
            }
        }
        return false;
    }

    @Transactional(readOnly = false)
    public User assignUserToRole(Role role, User user) {
        if (user == null) {
            return null;
        }
        List<String> roleIds = user.getRoleIdList();
        if (roleIds.contains(role.getId())) {
            return null;
        }
        user.getRoleList().add(role);
        saveUser(user);
        return user;
    }

    public Menu getMenu(String id) {
        return coreService.getMenu(id);
    }

    public Menu getMenuById(String id) {
        return coreService.getMenuById(id);
    }

    public Menu getMenuByName(String name) {
        return coreService.getMenuByName(name);
    }

    public List<Menu> findAllMenu() {
        return coreService.findAllMenu();
    }

    @Transactional(readOnly = false)
    public void saveMenu(Menu menu) {
        coreService.saveMenu(menu);
    }

    /**
     * 根据菜单获取
     */
    public Long menuTodoCount(Menu menu, ActTaskService actTaskService) {
        long count = 0;
        String hreff = menu.getHref();
        if(StringUtil.isEmpty(hreff)){
            return count;
        }
//        String url=hreff.split("\\?")[0];
//        if (StringUtils.isNotBlank(hreff) && hreff.contains("?actywId=") && hreff.contains("&gnodeId=")) {
//            int index1 = hreff.indexOf("?actywId=");
//            int index2 = hreff.indexOf("&gnodeId=");
//            String actywId = hreff.substring(index1 + 9, index2);
//            String gnodeId = hreff.substring(index2 + 9);
//            count = actTaskService.todoCount(actywId, gnodeId);
//        }else if (StringUtil.endsWith(url,"setAuditList")) {
//            count = ProjectUtils.getAuditListCount();
//        }else if (StringUtil.endsWith(url,"middleAuditList")) {
//            count = ProjectUtils.getMidCount();
//        }else if (StringUtil.endsWith(url,"closeAuditList")) {
//            count = ProjectUtils.closeAuditCount();
//        }else if (StringUtil.endsWith(url,"closeReplyingList")) {
//            count= ProjectUtils.closeReplyingCount();
//        }else if (StringUtil.endsWith(url,"assessList")) {
//            count = ProjectUtils.assessCount();
//        }else if (StringUtil.endsWith(url,"collegeExportScore")) {
//            count = GcontestUtils.collegeExportCount();
//        }else if (StringUtil.endsWith(url,"schoolActAuditList")) {
//            count= GcontestUtils.schoolActAuditList();
//        }else if (StringUtil.endsWith(url,"schoolEndAuditList")) {
//            count = GcontestUtils.schoolEndAuditList();
//        }else if (StringUtil.endsWith(url,"team")) {//人才库团队审核
//            count = teamService.getTeamCountToAudit();
//        }else if (StringUtil.endsWith(url,"sco/scoreGrade/courseList")) {//学分认定审核
//            count = scoApplyService.getCountToAudit();
//        }else if (StringUtil.endsWith(url,"pw/pwEnter/list")) {//入驻审核
//            count = pwEnterService.getCountToAudit();
//        }else if (StringUtil.endsWith(url,"pw/pwAppointment/review")) {//预约审核
//            count = pwAppointmentService.getCountToAudit();
//        }else if (StringUtil.contains(url,"taskAssignList")) {//指派
//            int index1 = hreff.indexOf("?actywId=");
//            String actywId = hreff.substring(index1 + 9);
//            count = actTaskService.recordIdsAllAssign(actywId);
//        }
        return count;
    }

    /*************************************************************
     * 公共未处理的方法.
     *************************************************************/
    /**
     * 修改用户.
     * @param nuser 用户参数
     * @param user 操作用户
     * @return User
     */
    public User updateUserByLoginName(User nuser, User ouser) {
        if(StringUtil.isNotEmpty(nuser.getName())){
            ouser.setName(nuser.getName());
        }
        if(StringUtil.isNotEmpty(nuser.getMobile())){
            ouser.setMobile(nuser.getMobile());
        }
        if(StringUtil.isNotEmpty(nuser.getEmail())){
            ouser.setEmail(nuser.getEmail());
        }
        if(nuser.getBirthday() != null){
            ouser.setBirthday(nuser.getBirthday());
        }
        if(StringUtil.isNotEmpty(nuser.getSex())){
            ouser.setSex(nuser.getSex());
        }
        if(StringUtil.isNotEmpty(nuser.getDegree())){
            ouser.setDegree(nuser.getDegree());
        }
        if(StringUtil.isNotEmpty(nuser.getEducation())){
            ouser.setEducation(nuser.getEducation());
        }
        if(nuser.getOffice() != null){
            ouser.setOffice(nuser.getOffice());
        }
        if(StringUtil.isNotEmpty(nuser.getProfessional())){
            ouser.setProfessional(nuser.getProfessional());
        }

        userDao.update(ouser);
        CoreUtils.clearCache(ouser);
        return ouser;
    }

    @Transactional(readOnly = false)
    public User newUserByLoginName(User nuser, User user) {
        nuser.setPassword(CoreUtils.entryptPassword(CoreUtils.USER_PSW_DEFAULT));
        List<Role> roleList= Lists.newArrayList();
        if(StringUtil.isNotEmpty(nuser.getUserType())){
//            if((Utype.STUDENT.getKey()).equals(nuser.getUserType())){
//                roleList.add(roleDao.get(SysIds.SYS_ROLE_USER.getId()));
//            }else if((Utype.TEACHER.getKey()).equals(nuser.getUserType())){
//                roleList.add(roleDao.get(SysIds.SYS_ROLE_TEACHER.getId()));
//            }else{
//                logger.error("当前用户类型["+nuser.getUserType()+"]");
//            }
        }else{
            logger.error("用户类型未定义，无法创建角色！");
        }
        nuser.setRoleList(roleList);
        nuser.setId(IdGen.uuid());
        nuser.setSource("1");
        nuser.setPassc("1");
        if (StringUtils.isNotBlank(user.getId())) {
            nuser.setUpdateBy(user);
            nuser.setCreateBy(user);
        }
        nuser.setUpdateDate(new Date());
        nuser.setCreateDate(nuser.getUpdateDate());
        userDao.insert(nuser);
        if(StringUtil.checkNotEmpty(roleList)){
            userDao.insertUserRole(nuser);
        }
        CoreUtils.clearCache(nuser);
        return nuser;
    }


//    /**
//     * 创建学生.
//     * @param nuser 用户参数
//     * @param user 操作用户
//     * @return User
//     */
//    @Transactional(readOnly = false)
//    public User newStudentByLoginName(User nuser, User user) {
//        return newStudentByLoginName(new StudentExpansion(), nuser, user);
//    }
//
//    @Transactional(readOnly = false)
//    public User newStudentByLoginName(StudentExpansion st, User nuser, User user) {
//        nuser.setPassword(CoreUtils.entryptPassword(CoreUtils.USER_PSW_DEFAULT));
//        List<Role> roleList=new ArrayList<Role>();
//        roleList.add(roleDao.get(SysIds.SYS_ROLE_USER.getId()));
//        nuser.setRoleList(roleList);
//        nuser.setId(IdGen.uuid());
//        nuser.setSource("1");
//        nuser.setPassc("1");
//        if (StringUtils.isNotBlank(user.getId())) {
//            nuser.setUpdateBy(user);
//            nuser.setCreateBy(user);
//        }
//        nuser.setUpdateDate(new Date());
//        nuser.setCreateDate(nuser.getUpdateDate());
//        nuser.setUserType(RoleBizTypeEnum.XS.getValue());
//        userDao.insert(nuser);
//        userDao.insertUserRole(nuser);
//        CoreUtils.clearCache(nuser);
//
//        st.setId(IdGen.uuid());
//        if (StringUtils.isNotBlank(user.getId())) {
//            st.setUpdateBy(user);
//            st.setCreateBy(user);
//        }
//        st.setUpdateDate(new Date());
//        st.setCreateDate(st.getUpdateDate());
//        st.setUser(nuser);
//        studentExpansionDao.insert(st);
//        return nuser;
//    }
//
//    /**
//     * 修改学生.
//     * @param st 显示
//     * @param nuser 用户参数
//     * @param user 操作用户
//     * @return User
//     */
//    @Transactional(readOnly = false)
//    public User updateStudentByLoginName(StudentExpansion st, User nuser, User ouser) {
//        if(StringUtil.isNotEmpty(nuser.getName())){
//            ouser.setName(nuser.getName());
//        }
//        if(StringUtil.isNotEmpty(nuser.getMobile())){
//            ouser.setMobile(nuser.getMobile());
//        }
//        if(StringUtil.isNotEmpty(nuser.getEmail())){
//            ouser.setEmail(nuser.getEmail());
//        }
//        if(nuser.getBirthday() != null){
//            ouser.setBirthday(nuser.getBirthday());
//        }
//        if(StringUtil.isNotEmpty(nuser.getSex())){
//            ouser.setSex(nuser.getSex());
//        }
//        if(StringUtil.isNotEmpty(nuser.getDegree())){
//            ouser.setDegree(nuser.getDegree());
//        }
//        if(StringUtil.isNotEmpty(nuser.getEducation())){
//            ouser.setEducation(nuser.getEducation());
//        }
//        if(nuser.getOffice() != null){
//            ouser.setOffice(nuser.getOffice());
//        }
//        if(StringUtil.isNotEmpty(nuser.getProfessional())){
//            ouser.setProfessional(nuser.getProfessional());
//        }
//
//        userDao.update(ouser);
//        CoreUtils.clearCache(ouser);
//        StudentExpansion ost = studentExpansionDao.getByUserId(ouser.getId());
//        if(ost != null){
//            if(StringUtil.isNotEmpty(st.getTClass())){
//                ost.setTClass(st.getTClass());
//            }
//            if(st.getTemporaryDate() != null){
//                ost.setTemporaryDate(st.getTemporaryDate());
//            }
//            if(st.getGraduation() != null){
//                ost.setGraduation(st.getGraduation());
//            }
//            if(StringUtil.isNotEmpty(st.getInstudy())){
//                ost.setInstudy(st.getInstudy());
//            }
//            if(StringUtil.isNotEmpty(st.getCurrState())){
//                ost.setCurrState(st.getCurrState());
//            }
//            studentExpansionDao.update(ost);
//        }
//        return ouser;
//    }
//
//
//    /**
//     * 创建导师.
//     * @param nuser 用户参数
//     * @param user 操作用户
//     * @return User
//     */
//    @Transactional(readOnly = false)
//    public User newTeacherByLoginName(User nuser, User user) {
//        return newTeacherByLoginName(new BackTeacherExpansion(), nuser, user);
//    }
//
//    @Transactional(readOnly = false)
//    public User newTeacherByLoginName(BackTeacherExpansion tc, User nuser, User user) {
//        nuser.setPassword(CoreUtils.entryptPassword(CoreUtils.USER_PSW_DEFAULT));
//        List<Role> roleList=new ArrayList<Role>();
//        roleList.add(roleDao.get(SysIds.SYS_ROLE_TEACHER.getId()));
//        nuser.setRoleList(roleList);
//        nuser.setId(IdGen.uuid());
//        nuser.setSource("1");
//        if (StringUtils.isNotBlank(user.getId())) {
//            nuser.setUpdateBy(user);
//            nuser.setCreateBy(user);
//        }
//        nuser.setUpdateDate(new Date());
//        nuser.setCreateDate(nuser.getUpdateDate());
//        nuser.setUserType(RoleBizTypeEnum.DS.getValue());
//        userDao.insert(nuser);
//        userDao.insertUserRole(nuser);
//        CoreUtils.clearCache(nuser);
//        tc.setId(IdGen.uuid());
//        if (StringUtils.isNotBlank(user.getId())) {
//            tc.setUpdateBy(user);
//            tc.setCreateBy(user);
//        }
//        tc.setUser(nuser);
//        tc.setUpdateDate(new Date());
//        tc.setCreateDate(tc.getUpdateDate());
//        backTeacherExpansionDao.insert(tc);
//        return nuser;
//    }
//
//    /**
//     * 修改导师.
//     * @param tc 导师
//     * @param nuser 用户参数
//     * @param user 操作用户
//     * @return User
//     */
//    @Transactional(readOnly = false)
//    public User updateTeacherByLoginName(BackTeacherExpansion tc, User nuser, User ouser) {
//        if(StringUtil.isNotEmpty(nuser.getName())){
//            ouser.setName(nuser.getName());
//        }
//        if(StringUtil.isNotEmpty(nuser.getMobile())){
//            ouser.setMobile(nuser.getMobile());
//        }
//        if(StringUtil.isNotEmpty(nuser.getEmail())){
//            ouser.setEmail(nuser.getEmail());
//        }
//        if(nuser.getBirthday() != null){
//            ouser.setBirthday(nuser.getBirthday());
//        }
//        if(StringUtil.isNotEmpty(nuser.getSex())){
//            ouser.setSex(nuser.getSex());
//        }
//        if(StringUtil.isNotEmpty(nuser.getDegree())){
//            ouser.setDegree(nuser.getDegree());
//        }
//        if(StringUtil.isNotEmpty(nuser.getEducation())){
//            ouser.setEducation(nuser.getEducation());
//        }
//        if(nuser.getOffice() != null){
//            ouser.setOffice(nuser.getOffice());
//        }
//        if(StringUtil.isNotEmpty(nuser.getProfessional())){
//            ouser.setProfessional(nuser.getProfessional());
//        }
//
//        userDao.update(ouser);
//        CoreUtils.clearCache(ouser);
//        BackTeacherExpansion ost = backTeacherExpansionDao.getByUserId(ouser.getId());
//        if(ost != null){
//            if(StringUtil.isNotEmpty(tc.getWorkUnit())){
//                ost.setWorkUnit(tc.getWorkUnit());
//            }
//            if(tc.getDiscipline() != null){
//                ost.setDiscipline(tc.getDiscipline());
//            }
//            if(StringUtil.isNotEmpty(tc.getIndustry())){
//                ost.setIndustry(tc.getIndustry());
//            }
//            if(StringUtil.isNotEmpty(tc.getTechnicalTitle())){
//                ost.setTechnicalTitle(tc.getTechnicalTitle());
//            }
//            if(StringUtil.isNotEmpty(tc.getServiceIntention())){
//                ost.setServiceIntention(tc.getServiceIntention());
//            }
//            if(StringUtil.isNotEmpty(tc.getAddress())){
//                ost.setAddress(tc.getAddress());
//            }
//            if(StringUtil.isNotEmpty(tc.getFirstBank())){
//                ost.setFirstBank(tc.getFirstBank());
//            }
//            if(StringUtil.isNotEmpty(tc.getBankAccount())){
//                ost.setBankAccount(tc.getBankAccount());
//            }
//            backTeacherExpansionDao.update(ost);
//        }
//        return ouser;
//    }

    @Transactional(readOnly = false)
    public void changeMenuIsShow(Menu menu) {
        menuDao.updateIsShow(menu);
        CoreUtils.removeCache(CoreUtils.CACHE_MENU_LIST);
        // 清除日志相关缓存
        CacheUtils.remove(LogUtils.CACHE_MENU_NAME_PATH_MAP);
    }

    public Boolean checkMenuName(Menu menu){
       Integer isUnique = menuDao.checkMenuName(menu);
        return isUnique < 1;
    }

    public Boolean checkRoleName(Role role){
       return coreService.checkRoleName(role);
    }

    public Boolean checkRoleEnName(Role role){
        return coreService.checkRoleEnName(role);
    }
}
