/**
 *
 */
package com.oseasy.pcore.modules.sys.service;

import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.annotation.Resource;

import org.activiti.engine.IdentityService;
import org.activiti.engine.identity.Group;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.config.ApiTstatus;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.security.Digests;
import com.oseasy.pcore.common.security.shiro.session.SessionDAO;
import com.oseasy.pcore.common.service.BaseService;
import com.oseasy.pcore.common.utils.CacheUtils;
import com.oseasy.pcore.common.web.Servlets;
import com.oseasy.pcore.modules.sys.dao.MenuDao;
import com.oseasy.pcore.modules.sys.dao.RoleDao;
import com.oseasy.pcore.modules.sys.dao.UserDao;
import com.oseasy.pcore.modules.sys.entity.Menu;
import com.oseasy.pcore.modules.sys.entity.Office;
import com.oseasy.pcore.modules.sys.entity.Role;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.security.SystemAuthorizingRealm;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.pcore.modules.sys.utils.LogUtils;
import com.oseasy.putil.common.utils.Encodes;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 系统管理，安全相关实体的管理类,包括用户、角色、菜单.
 */
@Service
@Transactional(readOnly = true)
public class CoreService extends BaseService implements InitializingBean {
    public static final String USER_PSW_DEFAULT = "123456";
    public static final String HASH_ALGORITHM = "SHA-1";
    public static final int HASH_INTERATIONS = 1024;
    public static final int SALT_SIZE = 8;
    /**
     * 是需要同步Activiti数据，如果从未同步过，则同步数据。
     */
    public static boolean isSynActivitiIndetity = true;
    @Autowired
    private UserDao userDao;
    @Autowired
    private RoleDao roleDao;
    @Autowired
    private MenuDao menuDao;
    @Autowired
    private SessionDAO sessionDao;
    @Resource
    private SystemAuthorizingRealm systemAuthorizingRealm;
    @Autowired
    private IdentityService identityService;

    /*************************************************************
     * 公共处理的方法.
     *************************************************************/
	public Integer getRoleUserCount(String roleid){
		return roleDao.getRoleUserCount(roleid);
	}

    /**
     * 验证密码
     *
     * @param plainPassword 明文密码
     * @param password      密文密码
     * @return 验证成功返回true
     */
    public static boolean validatePassword(String plainPassword, String password) {
        String plain = Encodes.unescapeHtml(plainPassword);
        byte[] salt = Encodes.decodeHex(password.substring(0, 16));
        byte[] hashPassword = Digests.sha1(plain.getBytes(), salt, HASH_INTERATIONS);
        return password.equals(Encodes.encodeHex(salt) + Encodes.encodeHex(hashPassword));
    }

    public SessionDAO getSessionDao() {
        return sessionDao;
    }

    /**has rolelist
     * 获取用户
     * @param id
     * @return
     */
    public User getUser(String id) {
        return CoreUtils.get(id);
    }


    @Transactional(readOnly = false)
    public void saveRole(Role role) {
        if (StringUtil.isBlank(role.getId())) {
            role.preInsert();
            roleDao.insert(role);
            // 同步到Activiti
            saveActivitiGroup(role);
        } else {
            role.preUpdate();
            roleDao.update(role);
        }
        // 更新角色与菜单关联
        roleDao.deleteRoleMenu(role);
        if (role.getMenuList().size() > 0) {
            roleDao.insertRoleMenu(role);
        }
        // 更新角色与部门关联
        roleDao.deleteRoleOffice(role);
        if (role.getOfficeList().size() > 0) {
            roleDao.insertRoleOffice(role);
        }
        // 同步到Activiti
        saveActivitiGroup(role);
        // 清除用户角色缓存
        CoreUtils.removeCache(CoreUtils.CACHE_ROLE_LIST);
//      // 清除权限缓存
//      systemRealm.clearAllCachedAuthorizationInfo();
    }

    @Transactional(readOnly = false)
    public void deleteRole(Role role) {
        roleDao.delete(role);
        // 同步到Activiti
        deleteActivitiGroup(role);
        // 清除用户角色缓存
        CoreUtils.removeCache(CoreUtils.CACHE_ROLE_LIST);
//      // 清除权限缓存
//      systemRealm.clearAllCachedAuthorizationInfo();
    }

    /**has rolelist
     * 根据登录名获取用户
     *
     * @param loginName
     * @return
     */
    public User getUserByLoginName(String loginName) {
    	User user=userDao.getByLoginName(new User(null, loginName));
    	if(user!=null&&StringUtil.isNotEmpty(user.getId())){
    		user.setRoleList(roleDao.findList(new Role(user)));
    	}
        return user;
    }

    /**has rolelist
     * @param loginNameOrNo
     * @return
     */
    public User getUserByLoginNameOrNo(String loginNameOrNo) {
    	User user=userDao.getByLoginNameOrNo(loginNameOrNo, null);
    	if(user!=null&&StringUtil.isNotEmpty(user.getId())){
    		user.setRoleList(roleDao.findList(new Role(user)));
    	}
    	return user;
    }

    public User getUserByLoginNameAndNo(String loginNameOrNo, String no) {
        return userDao.getByLoginNameAndNo(loginNameOrNo, no);
    }

    public User getUserByNo(String no) {
        return userDao.getByNo(no);
    }

    /**has rolelist
     * @param mobile
     * @return
     */
    public User getUserByMobile(String mobile) {
    	User user=CoreUtils.getByMobile(mobile);
    	if(user!=null&&StringUtil.isNotEmpty(user.getId())){
    		user.setRoleList(roleDao.findList(new Role(user)));
    	}
        return user;
    }

    public User getUserByMobile(String mobile, String id) {
        return CoreUtils.getByMobile(mobile, id);
    }

    public Page<User> findUser(Page<User> page, User user) {
        // 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
        //user.getSqlMap().put("dsf", dataScopeFilter(user.getCurrentUser(), "o", "a"));
        // 设置分页参数
        user.setPage(page);
        // 执行分页查询
        page.setList(userDao.findList(user));
        return page;
    }

    public Page<User> findUserByExpert(Page<User> page, User user) {
       user.setPage(page);
       // 执行分页查询
       page.setList(userDao.findUserByExpert(user));
       return page;
    }

    public String getTeacherTypeByUserId(String userId) {
        return userDao.getTeacherTypeByUserId(userId);
    }

    public Page<User> findListTree(Page<User> page, User user) {
        // 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
        //user.getSqlMap().put("dsf", dataScopeFilter(user.getCurrentUser(), "o", "a"));
        // 设置分页参数
        user.setPage(page);
        // 执行分页查询
        page.setList(userDao.findListTree(user));
        return page;
    }


    /**
     * 无分页查询人员列表
     *
     * @param user
     * @return
     */
    public List<User> findUser(User user) {
        // 生成数据权限过滤条件（dsf为dataScopeFilter的简写，在xml中使用 ${sqlMap.dsf}调用权限SQL）
        //user.getSqlMap().put("dsf", dataScopeFilter(user.getCurrentUser(), "o", "a"));
        List<User> list = userDao.findList(user);
        return list;
    }

    /**
     * 通过部门ID获取用户列表，仅返回用户id和name（树查询用户时用）
     *
     * @param
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<User> findUserByOfficeId(String officeId) {
        List<User> list = (List<User>) CacheUtils.get(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_LIST_BY_OFFICE_ID_ + officeId);
        if (list == null) {
            User user = new User();
            user.setOffice(new Office(officeId));
            list = userDao.findUserByOfficeId(user);
            CacheUtils.put(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_LIST_BY_OFFICE_ID_ + officeId, list);
        }
        return list;
    }

    /**
     * 通过专业ID获取用户列表，仅返回用户id和name（树查询用户时用）
     *
     * @param
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<User> findUserByProfessionId(String professionalId) {
        List<User> list = (List<User>) CacheUtils.get(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_LIST_BY_OFFICE_ID_ + professionalId);
        if (list == null) {
            User user = new User();
            user.setProfessional(professionalId);
            list = userDao.findUserByProfessionId(user);
            CacheUtils.put(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_LIST_BY_OFFICE_ID_ + professionalId, list);
        }
        return list;
    }

    @Transactional(readOnly = false)
    public void updateUserInfo(User user) {
        user.preUpdate();
        userDao.updateUserInfo(user);
        // 清除用户缓存
        CoreUtils.clearCache(user);
//      // 清除权限缓存
//      systemRealm.clearAllCachedAuthorizationInfo();
    }


    @Transactional(readOnly = false)
    public void updatePasswordById(String id, String loginName, String newPassword) {
        User user = new User(id);
        user.setPassword(CoreUtils.entryptPassword(newPassword));
        userDao.updatePasswordById(user);
        // 清除用户缓存
        user.setLoginName(loginName);
        CoreUtils.clearCache(user);
//      // 清除权限缓存
//      systemRealm.clearAllCachedAuthorizationInfo();
    }

    //-- Role Service --//

    @Transactional(readOnly = false)
    public void updateUserLoginInfo(User user) {
        // 保存上次登录信息
        user.setOldLoginIp(user.getLoginIp());
        user.setOldLoginDate(user.getLoginDate());
        // 更新本次登录信息
        user.setLoginIp(StringUtil.getRemoteAddr(Servlets.getRequest()));
        user.setLoginDate(new Date());
        userDao.updateLoginInfo(user);
    }

    /**
     * 获得活动会话
     *
     * @return
     */
    public Collection<Session> getActiveSessions() {
        return sessionDao.getActiveSessions(false);
    }

    public Role getRole(String id) {
        return roleDao.get(id);
    }

    public Role getNamebyId(String id) {
        return roleDao.getNamebyId(id);
    }

    public Role getRoleByName(String name) {
        Role r = new Role();
        r.setName(name);
        return roleDao.getByName(r);
    }

    public Role getRoleByEnname(String enname) {
        Role r = new Role();
        r.setEnname(enname);
        return roleDao.getByEnname(r);
    }

    public Boolean checkRoleName(Role role){
        Integer isUnique = roleDao.checkRoleName(role);
        return isUnique < 1;
    }

    public Boolean checkRoleEnName(Role role){
        Integer isUnique = roleDao.checkRoleEnName(role);
        return isUnique < 1;
    }

    public List<Role> findRole(Role role) {
        return roleDao.findList(role);
    }

    public List<Role> findAllRole() {
        return CoreUtils.getRoleList();
    }

    public Menu getMenu(String id) {
        return menuDao.get(id);
    }

    public Menu getMenuById(String id) {
        return menuDao.getById(id);
    }

    public Menu getMenuByName(String name) {
        return menuDao.getMenuByName(name);
    }

    public List<Menu> findAllMenu() {
        return CoreUtils.getMenuList();
    }

    @Transactional(readOnly = false)
    public void saveMenu(Menu menu) {

        // 获取父节点实体
//      menu.setParent(this.getMenu(menu.getParent().getId()));
        menu.setParent(this.getMenuById(menu.getParent().getId()));

        // 获取修改前的parentIds，用于更新子节点的parentIds
        String oldParentIds = menu.getParentIds();

        // 设置新的父节点串
        menu.setParentIds(menu.getParent().getParentIds() + menu.getParent().getId() + ",");

        // 保存或更新实体
        if (StringUtil.isBlank(menu.getId())) {
            menu.preInsert();
            menuDao.insert(menu);
        } else {
            menu.preUpdate();
            menuDao.update(menu);
        }

        // 更新子节点 parentIds
        Menu m = new Menu();
        m.setParentIds("%," + menu.getId() + ",%");
        List<Menu> list = menuDao.findByParentIdsLike(m);
        for (Menu e : list) {
            e.setParentIds(e.getParentIds().replace(oldParentIds, menu.getParentIds()));
            menuDao.updateParentIds(e);
        }
        // 清除用户菜单缓存
        CoreUtils.removeCache(CoreUtils.CACHE_MENU_LIST);
//      // 清除权限缓存
//      systemRealm.clearAllCachedAuthorizationInfo();
        // 清除日志相关缓存
        CacheUtils.remove(LogUtils.CACHE_MENU_NAME_PATH_MAP);
    }

    @Transactional(readOnly = false)
    public void updateMenuSort(Menu menu) {
        menuDao.updateSort(menu);
        // 清除用户菜单缓存
        CoreUtils.removeCache(CoreUtils.CACHE_MENU_LIST);
//      // 清除权限缓存
//      systemRealm.clearAllCachedAuthorizationInfo();
        // 清除日志相关缓存
        CacheUtils.remove(LogUtils.CACHE_MENU_NAME_PATH_MAP);
    }

    ///////////////// Synchronized to the Activiti //////////////////

    // 已废弃，同步见：ActGroupEntityServiceFactory.java、ActUserEntityServiceFactory.java

    @Transactional(readOnly = false)
    public void deleteMenu(Menu menu) {
        menuDao.delete(menu);
        // 清除用户菜单缓存
        CoreUtils.removeCache(CoreUtils.CACHE_MENU_LIST);
//      // 清除权限缓存
//      systemRealm.clearAllCachedAuthorizationInfo();
        // 清除日志相关缓存
        CacheUtils.remove(LogUtils.CACHE_MENU_NAME_PATH_MAP);
    }


    /**
     * 根据菜单ID查找所有子菜单.
     * @return List
     */
    public List<Menu> findAllMenuByParent(Menu menu) {
        Menu m = new Menu();
        m.setParentIds("%," + menu.getId() + ",%");
        return menuDao.findByParentIdsLike(m);
    }

    public List<Menu> findAllMenuByParent(String id) {
        return findAllMenuByParent(new Menu(id));
    }


    public List<Menu> findRoleMenuByParentIdsLike(List<Role> roles, Menu menu) {
        Menu m = new Menu();
        m.setParentIds("%," + menu.getId() + ",%");
        return menuDao.findRoleMenuByParentIdsLike(StringUtil.listIdToList(roles), m);
    }

    public List<Menu> findRoleMenuByParentIdsLike(List<Role> roles, String mid) {
        return findRoleMenuByParentIdsLike(roles, new Menu(mid));
    }

    public Menu getMenuByHref(String href) {
        return menuDao.getMenuByHref(href);
    }


    public Integer checkLoginNameUnique(String loginName, String userId) {
        return userDao.checkLoginNameUnique(loginName, userId);
    }

    public Integer checkNoUnique(String no, String userId) {
        return userDao.checkNoUnique(no, userId);
    }

    public Integer checkUserNoUnique(String no, String userId) {
        return userDao.checkUserNoUnique(no, userId);
    }

    public Integer checkMobileUnique(String mobile, String userId) {
        return userDao.checkMobileUnique(mobile, userId);
    }


    ///////////////// Synchronized to the Activiti end //////////////////


    public List<Role> findListByUserId(String userId) {

        List<Role> roleList = roleDao.findListByUserId(userId);

        return roleList;
    }

    /**
     * 批量添加用户角色.
     *
     * @param rid  角色ID
     * @param uids 用户IDS
     */
    @Transactional(readOnly = false)
    public ApiTstatus<List<String>> insertPLUserRole(String rid, List<String> uids) {
        if (StringUtil.isNotEmpty(rid)) {
            Role role = new Role(rid);
            List<String> repairedIds = Lists.newArrayList();
            for (String id : uids) {
                User user = new User(id);
                user.getRoleList().add(role);
                insertUserRole(user);
                repairedIds.add(id);
            }
            return new ApiTstatus<List<String>>(true, "修复成功，角色ID为:[" + rid + "],共修复 " + repairedIds.size() + "条", repairedIds);
        }
        return new ApiTstatus<List<String>>(false, "修复失败,角色ID为空!");
    }


    /**
     * 添加用户角色.
     *
     * @param user
     */
    @Transactional(readOnly = false)
    public void insertUserRole(User user) {
        userDao.insertUserRole(user);
    }

    @Transactional(readOnly = false)
    public void deleteUser(User user) {
        userDao.delete(user);
        // 同步到Activiti
        deleteActivitiUser(user);
        // 清除用户缓存
        CoreUtils.clearCache(user);
//      // 清除权限缓存
//      systemRealm.clearAllCachedAuthorizationInfo();
    }

    public void afterPropertiesSet() throws Exception {
        if (!Global.isSynActivitiIndetity()) {
            return;
        }
        if (isSynActivitiIndetity) {
            isSynActivitiIndetity = false;
            // 同步角色数据
            List<Group> groupList = identityService.createGroupQuery().list();
            if (groupList.size() == 0) {
                Iterator<Role> roles = roleDao.findAllList(new Role()).iterator();
                while (roles.hasNext()) {
                    Role role = roles.next();
                    saveActivitiGroup(role);
                }
            }
            // 同步用户数据
            List<org.activiti.engine.identity.User> userList = identityService.createUserQuery().list();
            if (userList.size() == 0) {
                Iterator<User> users = userDao.findAllList(new User()).iterator();
                while (users.hasNext()) {
                    saveActivitiUser(users.next());
                }
            }
        }
    }

    private void saveActivitiGroup(Role role) {
        if (!Global.isSynActivitiIndetity()) {
            return;
        }
        String groupId = role.getEnname();

        // 如果修改了英文名，则删除原Activiti角色
        if (StringUtil.isNotBlank(role.getOldEnname()) && !role.getOldEnname().equals(role.getEnname())) {
            identityService.deleteGroup(role.getOldEnname());
        }

        Group group = identityService.createGroupQuery().groupId(groupId).singleResult();
        if (group == null) {
            group = identityService.newGroup(groupId);
        }
        group.setName(role.getName());
        group.setType(role.getRoleType());
        identityService.saveGroup(group);

        // 删除用户与用户组关系
        List<org.activiti.engine.identity.User> activitiUserList = identityService.createUserQuery().memberOfGroup(groupId).list();
        for (org.activiti.engine.identity.User activitiUser : activitiUserList) {
            identityService.deleteMembership(activitiUser.getId(), groupId);
        }

        // 创建用户与用户组关系
        List<User> userList = findUser(new User(new Role(role.getId())));
        for (User e : userList) {
            String userId = e.getLoginName();//ObjectUtils.toString(user.getId());
            // 如果该用户不存在，则创建一个
            org.activiti.engine.identity.User activitiUser = identityService.createUserQuery().userId(userId).singleResult();
            if (activitiUser == null) {
                activitiUser = identityService.newUser(userId);
                activitiUser.setFirstName(e.getName());
                activitiUser.setLastName(StringUtil.EMPTY);
                activitiUser.setEmail(e.getEmail());
                activitiUser.setPassword(StringUtil.EMPTY);
                identityService.saveUser(activitiUser);
            }
            identityService.createMembership(userId, groupId);
        }
    }

    public void deleteActivitiGroup(Role role) {
        if (!Global.isSynActivitiIndetity()) {
            return;
        }
        if (role != null) {
            String groupId = role.getEnname();
            identityService.deleteGroup(groupId);
        }
    }

    public void saveActivitiUser(User user) {
        if (!Global.isSynActivitiIndetity()) {
            return;
        }
        String userId = user.getLoginName();//ObjectUtils.toString(user.getId());
        org.activiti.engine.identity.User activitiUser = identityService.createUserQuery().userId(userId).singleResult();
        if (activitiUser == null) {
            activitiUser = identityService.newUser(userId);
        }
        activitiUser.setFirstName(user.getName());
        activitiUser.setLastName(StringUtil.EMPTY);
        activitiUser.setEmail(user.getEmail());
        activitiUser.setPassword(StringUtil.EMPTY);
        identityService.saveUser(activitiUser);

        // 删除用户与用户组关系
        List<Group> activitiGroups = identityService.createGroupQuery().groupMember(userId).list();
        for (Group group : activitiGroups) {
            identityService.deleteMembership(userId, group.getId());
        }
        // 创建用户与用户组关系
        for (Role role : user.getRoleList()) {
            String groupId = role.getEnname();
            // 如果该用户组不存在，则创建一个
            Group group = identityService.createGroupQuery().groupId(groupId).singleResult();
            if (group == null) {
                group = identityService.newGroup(groupId);
                group.setName(role.getName());
                group.setType(role.getRoleType());
                identityService.saveGroup(group);
            }
            identityService.createMembership(userId, role.getEnname());
        }
    }

    private void deleteActivitiUser(User user) {
        if (!Global.isSynActivitiIndetity()) {
            return;
        }
        if (user != null) {
            String userId = user.getLoginName();//ObjectUtils.toString(user.getId());
            identityService.deleteUser(userId);
        }
    }

    /**
     * 获取Key加载信息
     */
    public static boolean printKeyLoadMessage() {
        /*StringBuilder sb = new StringBuilder();
        sb.append("\r\n======================================================================\r\n");
        sb.append("\r\n    欢迎使用 "+Global.getConfig("productName")+"  - Powered By http://initiate.com\r\n");
        sb.append("\r\n======================================================================\r\n");
        System.out.println(sb.toString());*/
        return true;
    }
    /*************************************************************
     * 公共未处理的方法.
     *************************************************************/
}
