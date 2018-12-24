/**
 * .
 */

package com.oseasy.pcore.modules.sys.utils;

import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.UnavailableSecurityManagerException;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.session.InvalidSessionException;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;

import com.oseasy.pcore.common.config.CoreIds;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.mapper.JsonMapper;
import com.oseasy.pcore.common.security.Digests;
import com.oseasy.pcore.common.security.shiro.session.JedisSessionDAO;
import com.oseasy.pcore.common.utils.CacheUtils;
import com.oseasy.pcore.common.utils.SpringContextHolder;
import com.oseasy.pcore.common.web.Servlets;
import com.oseasy.pcore.modules.authorize.service.AuthorizeService;
import com.oseasy.pcore.modules.sys.dao.AreaDao;
import com.oseasy.pcore.modules.sys.dao.MenuDao;
import com.oseasy.pcore.modules.sys.dao.OfficeDao;
import com.oseasy.pcore.modules.sys.dao.RoleDao;
import com.oseasy.pcore.modules.sys.dao.UserDao;
import com.oseasy.pcore.modules.sys.entity.Area;
import com.oseasy.pcore.modules.sys.entity.Menu;
import com.oseasy.pcore.modules.sys.entity.Office;
import com.oseasy.pcore.modules.sys.entity.Role;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.enums.RoleBizTypeEnum;
import com.oseasy.pcore.modules.sys.security.SystemAuthorizingRealm.Principal;
import com.oseasy.putil.common.utils.Encodes;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * .
 * @author chenhao
 *
 */
public class CoreUtils {
    public static final int SALT_SIZE = 8;
    public static final int HASH_INTERATIONS = 1024;
    public static final String HASH_ALGORITHM = "SHA-1";
    public static final String USER_PSW_DEFAULT = "123456";

    private static AuthorizeService authorizeService = SpringContextHolder.getBean(AuthorizeService.class);
    private static UserDao userDao = SpringContextHolder.getBean(UserDao.class);
    private static RoleDao roleDao = SpringContextHolder.getBean(RoleDao.class);
    private static OfficeDao officeDao = SpringContextHolder.getBean(OfficeDao.class);
    private static AreaDao areaDao = SpringContextHolder.getBean(AreaDao.class);
    private static MenuDao menuDao = SpringContextHolder.getBean(MenuDao.class);

    public static final String USER_CACHE = "userCache";
    public static final String USER_CACHE_ID_ = "id_";
    public static final String USER_CACHE_LOGIN_NAME_ = "ln";
    public static final String USER_CACHE_LIST_BY_OFFICE_ID_ = "oid_";

    public static final String CACHE_AUTH_INFO = "authInfo";
    public static final String CACHE_ROLE_LIST = "roleList";
    public static final String CACHE_MENU_LIST = "menuList";
    public static final String CACHE_AREA_LIST = "areaList";
    public static final String CACHE_OFFICE_LIST = "officeList";
    public static final String CACHE_OFFICE_ALL_LIST = "officeAllList";
    public static final String CACHE_OFFICE = "office";
    public static final String CACHE_TOKEN = "token";


    /*************************************************************
     * 公共处理的方法.
     *************************************************************/
    /**
     * 生成安全的密码，生成随机的16位salt并经过1024次 sha-1 hash
     */
    public static String entryptPassword(String plainPassword) {
        String plain = Encodes.unescapeHtml(plainPassword);
        byte[] salt = Digests.generateSalt(SALT_SIZE);
        byte[] hashPassword = Digests.sha1(plain.getBytes(), salt, HASH_INTERATIONS);
        return Encodes.encodeHex(salt) + Encodes.encodeHex(hashPassword);
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
        byte[] hashPassword = Digests.sha1(plain.getBytes(), salt, CoreUtils.HASH_INTERATIONS);
        return password.equals(Encodes.encodeHex(salt) + Encodes.encodeHex(hashPassword));
    }

    /**
     * 获取当前用户 (has rolelist)
     * @return 取不到返回 new User()
     */
    public static User getUser() {
        Principal principal = getPrincipal();
        if (principal!=null) {
            User user = get(principal.getId());
            if (user != null) {
                return user;
            }
            return new User();
        }
        // 如果没有登录，则返回实例化空的User对象。
        return new User();
    }

    /**has rolelist
     * 根据ID获取用户
     * @param id
     * @return 取不到返回null
     */
    public static User get(String id) {
        User user = (User)CacheUtils.get(USER_CACHE, USER_CACHE_ID_ + id);
        if (user ==  null) {
            user = userDao.get(id);
            if (user == null) {
                return null;
            }
            user.setRoleList(roleDao.findList(new Role(user)));
            CacheUtils.put(USER_CACHE, USER_CACHE_ID_ + user.getId(), user);
            CacheUtils.put(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getLoginName(), user);
        }
        return user;
    }

    /**
     * 获取所有角色列表
     * @return
     */
    public static List<Role> getAllRoleList() {
        @SuppressWarnings("unchecked")
        List<Role> roleList = (List<Role>)getCache(CACHE_ROLE_LIST);
        if (roleList == null) {
            roleList = roleDao.findAllList(new Role());
            putCache(CACHE_ROLE_LIST, roleList);
        }
        return roleList;
    }

    public static String getRoleBizType(String roleid){
        if(StringUtil.isEmpty(roleid)){
            return null;
        }
        List<Role> rs=getAllRoleList();
        if(rs!=null&&rs.size()>0){
            for(Role r:rs){
                if(roleid.equals(r.getId())){
                    return r.getBizType();
                }
            }
        }
        return null;
    }

    public static boolean checkHasRoleBizType(User user,String rolebiztype) {
        if(user==null||StringUtil.isEmpty(user.getId())||StringUtil.isEmpty(rolebiztype)){
            return false;
        }
        List<Role> rs=user.getRoleList();
        if(rs==null||rs.size()==0){
            throw new RuntimeException("该用户没有角色 User:[" + user.getId() + "] ->RoleBizTypeEnum:[" + rolebiztype + "]");
        }
        for(Role r:rs){
            if(StringUtil.isEmpty(r.getBizType())){
                r.setBizType(CoreUtils.getRoleBizType(r.getId()));
            }
            if(rolebiztype.equals(r.getBizType())){
                return true;
            }
        }
        return false;
    }

    /**
     * 清除当前用户缓存
     */
    public static void clearCache() {
        removeCache(CACHE_AUTH_INFO);
        removeCache(CACHE_ROLE_LIST);
        removeCache(CACHE_MENU_LIST);
        removeCache(CACHE_AREA_LIST);
        removeCache(CACHE_OFFICE_LIST);
        removeCache(CACHE_OFFICE_ALL_LIST);
        CoreUtils.clearCache(getUser());
    }

    /**
     * 清除指定用户缓存
     * @param user
     */
    public static void clearCache(User user) {
        CacheUtils.remove(USER_CACHE, USER_CACHE_ID_ + user.getId());
        CacheUtils.remove(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getLoginName());
        CacheUtils.remove(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getOldLoginName());
        if (user.getOffice() != null && user.getOffice().getId() != null) {
            CacheUtils.remove(USER_CACHE, USER_CACHE_LIST_BY_OFFICE_ID_ + user.getOffice().getId());
        }
    }


    /**检查用户是否有某个角色
     * @param user user对象中有role list
     * @param rolebiztype
     * @return
     */
    public static boolean checkHasRole(User user,String rbtype) {
        if(user==null||StringUtil.isEmpty(user.getId())|| StringUtil.isEmpty(rbtype)){
            return false;
        }else{
            if(StringUtil.checkEmpty(user.getRoleList())){
                user =get(user.getId());
            }
        }
        List<Role> rs=user.getRoleList();
        if(rs==null||rs.size()==0){
            throw new RuntimeException("该用户没有指定角色 User:[" + user.getId() + "] ->rbtype:[" + rbtype + "]");
        }
        for(Role r:rs){
            if(StringUtil.isEmpty(r.getBizType())){
                r.setBizType(getRoleBizType(r.getId()));
            }
            if((rbtype).equals(r.getBizType())){
                return true;
            }
        }
        return false;
    }

    /**根据编号判断授权信息
     * @param num MenuPlusEnum 枚举值序号从0开始
     * @return
     */
    public static boolean checkMenuByNum(Integer num) {
        return authorizeService.checkMenuByNum(num);
    }

    public static boolean checkCategory(String id) {
        return authorizeService.checkCategory(id);
    }

    public static String hiddenMobile(String mobile) {
        if (StringUtil.isEmpty(mobile)) {
            return mobile;
        }
        return mobile.replaceAll("(\\d{3})\\d{4}(\\d{4})","$1****$2");
    }

    public static boolean checkChildMenu(String id) {
        return authorizeService.checkChildMenu(id);
    }

    public static boolean checkMenu(String id) {
        return authorizeService.checkMenu(id);
    }

    /*************************************************************
     * 公共未处理的方法.
     *************************************************************/




    /**
     * 根据登录名获取用户
     * @param loginName
     * @return 取不到返回null
     */
    public static User getByLoginName(String loginName) {
        User user = (User)CacheUtils.get(USER_CACHE, USER_CACHE_LOGIN_NAME_ + loginName);
        if (user == null) {
            user = userDao.getByLoginName(new User(null, loginName));
            if (user == null) {
                return null;
            }
            user.setRoleList(roleDao.findList(new Role(user)));
            CacheUtils.put(USER_CACHE, USER_CACHE_ID_ + user.getId(), user);
            CacheUtils.put(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getLoginName(), user);
        }
        return user;
    }

    public static User getByLoginNameOrNo(String loginNameOrNo) {
        User user = (User)CacheUtils.get(USER_CACHE, USER_CACHE_LOGIN_NAME_ + loginNameOrNo);
        if (user == null) {
            user = userDao.getByLoginNameOrNo(loginNameOrNo,null);
            if (user == null) {
                return null;
            }
            CacheUtils.put(USER_CACHE, USER_CACHE_ID_ + user.getId(), user);
            CacheUtils.put(USER_CACHE, USER_CACHE_LOGIN_NAME_ + user.getLoginName(), user);
        }
        return user;
    }


    public static boolean isExistNo(String no) {
        User    user = userDao.getByLoginNameOrNo(no,null);
        if (user == null) {
            return false;
        }
        return true;
    }
    /**
     * 根据手机号获取用户
     * @param mobile
     * @return 取不到返回null
     */
    public static boolean isExistMobile(String mobile) {
        User p=new User();
        p.setMobile(mobile);
        User    user = userDao.getByMobile(p);
        if (user == null) {
            return false;
        }
        return true;
    }
    public static User getByMobile(String mobile) {
        User p=new User();
        p.setMobile(mobile);
        User    user = userDao.getByMobile(p);
        if (user == null) {
            return null;
        }
        user.setRoleList(roleDao.findList(new Role(user)));
        return user;
    }
    public static User getByMobile(String mobile,String id) {
        User p = new User();
        p.setMobile(mobile);
        p.setId(id);
        User user = userDao.getByMobileWithId(p);
        if (user == null) {
            return null;
        }
        user.setRoleList(roleDao.findList(new Role(user)));
        return user;
    }

    public static Office getOffice(String ofid) {
        if (StringUtil.isNotEmpty(ofid)) {
          Office office = (Office)CacheUtils.get(CACHE_OFFICE,ofid);
          if (office == null) {
            office=officeDao.get(ofid);
            if (office!=null)CacheUtils.put(CACHE_OFFICE,ofid,office);
          }
          return office;
        }
        return null;
      }


    /**
     * 获取当前用户角色列表
     * @return
     */
    public static List<Role> getRoleList() {
        @SuppressWarnings("unchecked")
        List<Role> roleList = (List<Role>)getCache(CACHE_ROLE_LIST);
        if (roleList == null) {
            User user = getUser();
            if (user.getAdmin()) {
                roleList = roleDao.findAllList(new Role());
            }else{
                Role role = new Role();
                //role.getSqlMap().put("dsf", BaseService.dataScopeFilter(user.getCurrentUser(), "o", "u"));
                roleList = roleDao.findList(role);
            }
            putCache(CACHE_ROLE_LIST, roleList);
        }
        return roleList;
    }

    /**
     * 获取当前用户授权菜单
     * @return
     */
    public static List<Menu> getMenuList() {
        @SuppressWarnings("unchecked")
        List<Menu> menuList = (List<Menu>)getCache(CACHE_MENU_LIST);
        if (menuList == null) {
            User user = getUser();
            if (user.getAdmin()) {
                menuList = menuDao.findAllList(new Menu());
            }else{
                Menu m = new Menu();
                m.setUserId(user.getId());
                menuList = menuDao.findByUserId(m);
            }
            putCache(CACHE_MENU_LIST, menuList);
        }
        return menuList;
    }

    public static SimpleAuthorizationInfo getSimpleAuthorizationInfo(SimpleAuthorizationInfo info) {
        List<Menu> list = CoreUtils.getMenuList();
        for (Menu menu : list) {
            if (StringUtils.isNotBlank(menu.getPermission())) {
                // 添加基于Permission的权限信息
                for (String permission : StringUtils.split(menu.getPermission(),",")) {
                    info.addStringPermission(permission);
                }
            }
        }
        return info;
    }

    /**
     * 获取当前所有用户授权菜单
     * @return
     */
    public static List<Menu> getAllMenuList() {
        List<Menu> menuList = menuDao.findAllList(new Menu());
        return menuList;
    }

    /**
     * 获取授权主要对象
     */
    public static Subject getSubject() {
        return SecurityUtils.getSubject();
    }

    /**
     * 获取当前登录者对象
     */
    public static Principal getPrincipal() {
        try{
            Subject subject = SecurityUtils.getSubject();
            Principal principal = (Principal)subject.getPrincipal();
            if (principal != null) {
                return principal;
            }
//          subject.logout();
        }catch (UnavailableSecurityManagerException e) {

        }catch (InvalidSessionException e) {

        }
        return null;
    }

    public static Session getSession() {
        try{
            Subject subject = SecurityUtils.getSubject();
            Session session = subject.getSession(false);
            if (session == null) {
                session = subject.getSession();
            }
            if (session != null) {
                return session;
            }
//          subject.logout();
        }catch (InvalidSessionException e) {

        }
        return null;
    }

    // ============== User Cache ==============

    public static Object getCache(String key) {
        return getCache(key, null);
    }

    public static Object getCache(String key, Object defaultValue) {
//      Object obj = getCacheMap().get(key);
        Object obj = getSession().getAttribute(key);
        return obj==null?defaultValue:obj;
    }

    public static void putCache(String key, Object value) {
//      getCacheMap().put(key, value);
        getSession().setAttribute(key, value);
    }

    public static void removeCache(String key) {
//      getCacheMap().remove(key);
        getSession().removeAttribute(key);
    }

    /**
     * 跳转登录页面.
     * @return String
     */
    public static String toLogin() {
      return CoreSval.REDIRECT + Global.getFrontPath() + "/toLogin";
    }

    public static boolean isAdmin(User user){
        String roleIds = StringUtil.listIdToStr(user.getRoleList());
        return roleIds != null && (roleIds).contains(CoreIds.SYS_ADMIN_ROLE.getId());
    }

    public static boolean isAdminOrSuperAdmin(User user){
        List<Role> roles =roleDao.findList(new Role(user));
        boolean isAdmin=false;
        if(StringUtil.checkNotEmpty(roles)){
            for(Role role:roles){
                if(role != null &&
                        (CoreIds.SYS_ADMIN_ROLE.getId().equals(role.getId())
                        || CoreIds.SYS_ROLE_SUPER.getId().equals(role.getId())
                        || CoreIds.SYS_ROLE_ADMIN.getId().equals(role.getId())
                        )){
                    isAdmin=true;
                    break;
                }
            }
        }
        return isAdmin;
    }

    /**检查用户是否有后台登录的角色
     * @param user user对象中有role list
//   * @param rolebiztype
     * @return
     */
    public static boolean checkHasAdminRole(User user) {
        if(user==null||StringUtil.isEmpty(user.getId())){
            return false;
        }else{
            user =get(user.getId());
        }
        List<Role> rs=user.getRoleList();
        if(rs==null||rs.size()==0){
            throw new RuntimeException("该用户没有角色 User:[" + user.getId() + "]");
        }
        for(Role r:rs){
            if(StringUtil.isEmpty(r.getBizType())){
                r.setBizType(getRoleBizType(r.getId()));
            }
            if(!RoleBizTypeEnum.XS.getValue().equals(r.getBizType())&&!RoleBizTypeEnum.DS.getValue().equals(r.getBizType())){
                return true;
            }
        }
        return false;
    }
    public static boolean checkHasAdminRole(User user, List<String> bizTypes) {
        if(user==null||StringUtil.isEmpty(user.getId())){
            return false;
        }else{
            user =get(user.getId());
        }
        List<Role> rs=user.getRoleList();
        if(rs==null||rs.size()==0){
            throw new RuntimeException("该用户没有角色 User:[" + user.getId() + "]");
        }
        for(Role r:rs){
            if(StringUtil.isEmpty(r.getBizType())){
                r.setBizType(getRoleBizType(r.getId()));
            }
            if(!(bizTypes).contains(r.getBizType())){
            //if(!RoleBizTypeEnum.XS.getValue().equals(r.getBizType())&&!RoleBizTypeEnum.DS.getValue().equals(r.getBizType())){
                return true;
            }
        }
        return false;
    }


    /**
     * 获取当前用户有权限访问的部门
     * @return
     */
    public static List<Office> getOfficeList() {
        @SuppressWarnings("unchecked")
        List<Office> officeList = (List<Office>)getCache(CACHE_OFFICE_LIST);
        if (officeList == null) {
            User user = getUser();
            if (user.getAdmin()) {
                officeList = officeDao.findAllList(new Office());
            }else{
                Office office = new Office();
                //office.getSqlMap().put("dsf", BaseService.dataScopeFilter(user, "a", ""));
                officeList = officeDao.findList(office);
            }
            putCache(CACHE_OFFICE_LIST, officeList);
        }
        return officeList;
    }

    public static String getOfficeListJson() {
        return JsonMapper.toJsonString(CoreUtils.getOfficeList());
    }

    /**
     * 获取当前用户有权限访问的部门
     * @return
     */
    public static List<Office> getOfficeAllList() {
        @SuppressWarnings("unchecked")
        List<Office> officeList = (List<Office>)getCache(CACHE_OFFICE_ALL_LIST);
        if (officeList == null) {
            officeList = officeDao.findAllList(new Office());
        }
        return officeList;
    }

    public static List<Office> getOfficeListFront() {
        @SuppressWarnings("unchecked")
        List<Office> officeList = (List<Office>)getCache("officeListFront");
        if (officeList == null) {
            /*if (user.isAdmin()) {*/
                officeList = officeDao.findAllList(new Office());
            /*}else{
                Office office = new Office();
            //  office.getSqlMap().put("dsf", BaseService.dataScopeFilter(user, "a", ""));
                officeList = officeDao.findList(office);
            }*/
            putCache("officeListFront", officeList);
        }
        return officeList;
    }

    /**
     * 获取当前用户授权的区域
     * @return
     */
    public static List<Area> getAreaList() {
        @SuppressWarnings("unchecked")
        List<Area> areaList = (List<Area>)getCache(CACHE_AREA_LIST);
        if (areaList == null) {
            areaList = areaDao.findAllList(new Area());
            putCache(CACHE_AREA_LIST, areaList);
        }
        return areaList;
    }

    /**
     * 是否是验证码登录
     * @param isFail 计数加1
     * @param clean 计数清零
     * @return
     */
    public static boolean isValidateCodeLogin(boolean isFail, boolean clean) {
        Integer loginFailNum=null;
        String sessionId=null;
        HttpServletRequest request = Servlets.getRequest();
        if(request!=null){
            Cookie[] cs=request.getCookies();
            if(cs!=null){
                for(Cookie c:cs){
                    if(c!=null&&JedisSessionDAO.SessionIdName.equals(c.getName())){
                        sessionId=c.getValue();
                        break;
                    }
                }
            }
        }
        if(sessionId!=null){
            loginFailNum =(Integer)CacheUtils.get("loginFailMap", sessionId);
        }
        if (loginFailNum==null) {
            loginFailNum = 0;
        }
        if (isFail) {
            loginFailNum++;
            CacheUtils.put("loginFailMap", sessionId, loginFailNum);
        }
        if (clean) {
            CacheUtils.remove("loginFailMap", sessionId);
        }
        return loginFailNum >= 3;
    }

    public static String getVersion(){
        return Global.getConfig("version");
    }
}
