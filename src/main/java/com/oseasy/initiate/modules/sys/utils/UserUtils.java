/**
 *
 */
package com.oseasy.initiate.modules.sys.utils;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.subject.Subject;

import com.oseasy.initiate.modules.sys.enums.RoleBizTypeEnum;
import com.oseasy.pact.modules.actyw.dao.ActYwSgtypeDao;
import com.oseasy.pact.modules.actyw.entity.ActYwSgtype;
import com.oseasy.pcore.common.config.CoreIds;
import com.oseasy.pcore.common.config.CoreSval;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.utils.CacheUtils;
import com.oseasy.pcore.common.utils.SpringContextHolder;
import com.oseasy.pcore.modules.oa.dao.OaNotifyDao;
import com.oseasy.pcore.modules.oa.entity.OaNotify;
import com.oseasy.pcore.modules.sys.dao.OfficeDao;
import com.oseasy.pcore.modules.sys.dao.RoleDao;
import com.oseasy.pcore.modules.sys.dao.UserDao;
import com.oseasy.pcore.modules.sys.entity.Menu;
import com.oseasy.pcore.modules.sys.entity.Office;
import com.oseasy.pcore.modules.sys.entity.Role;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.utils.CoreUtils;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 用户工具类


 */
public class UserUtils {
	public static final String maxUploadSize = Global.getConfig("web.maxUploadSize");
	private static UserDao userDao = SpringContextHolder.getBean(UserDao.class);

	private static RoleDao roleDao = SpringContextHolder.getBean(RoleDao.class);
	private static OfficeDao officeDao = SpringContextHolder.getBean(OfficeDao.class);
	private static OaNotifyDao oaNotifyDao = SpringContextHolder.getBean(OaNotifyDao.class);
	private static ActYwSgtypeDao actYwSgtypeDao=SpringContextHolder.getBean(ActYwSgtypeDao.class);

	public static final String CACHE_OANOTIFY_LIST = "oaNotifyList";

    /*************************************************************
     * 公共处理的方法.
     *************************************************************/
	/**
     * 清除当前用户缓存
     */
    public static void clearCache() {
        CoreUtils.removeCache(CACHE_OANOTIFY_LIST);
        CoreUtils.clearCache();
    }

    /**获取上传文件最大大小限制
     * @return
     */
    public static String getMaxUpFileSize(){
        return maxUploadSize;
    }

    /**
     * 获取专业名称
     * @return
     */
    public static String getProfessional(String id) {
        Office office = officeDao.get(id);
        if (office!=null&&"3".equals(office.getGrade())) {
            return office.getName();
        }
        return null;
    }

    //得到学院
    public static List<Office> findColleges() {
        return  officeDao.findColleges();
    }

    //根据学院id 得到其下面的专业
    public static List<Office> findProfessionals(String parentId) {
        return  officeDao.findProfessionals(parentId);
    }
    /*************************************************************
     * 公共未处理的方法.
     *************************************************************/


	/**
	 * 获取所有角色列表
	 * @return
	 */
	public static List<Role> getAllRoleList() {
		@SuppressWarnings("unchecked")
		List<Role> roleList = (List<Role>) CoreUtils.getCache(CoreUtils.CACHE_ROLE_LIST);
		if (roleList == null) {
			roleList = roleDao.findAllList(new Role());
			CoreUtils.putCache(CoreUtils.CACHE_ROLE_LIST, roleList);
		}
		return roleList;
	}

	/**检查用户角色变更是否可行 不可变更则有返回信息
	 * @param nuser now
	 * @param ouser old
	 * @return
	 */
	public static String checkRoleChange(User nuser,User ouser) {
		if(nuser==null||ouser==null){
			return null;
		}
		if(StringUtil.isNotEmpty(nuser.getId()) && StringUtil.checkEmpty(nuser.getRoleList())){
		    nuser.setRoleList(roleDao.findListByUserId(nuser.getId()));
        }
		if(StringUtil.checkEmpty(nuser.getRoleList())){
			return "该用户没有角色 User:[" + nuser.getId() + "]";
		}
		List<Role> ors=ouser.getRoleList();
		if(ors==null||ors.size()==0){
			return null;
		}
		boolean hasStu=false;//是否有学生角色
		boolean hasTea=false;//是否有导师角色
		for(Role r: nuser.getRoleList()){
			if(StringUtil.isEmpty(r.getBizType())){
				r.setBizType(CoreUtils.getRoleBizType(r.getId()));
			}
			if(RoleBizTypeEnum.XS.getValue().equals(r.getBizType())){
				hasStu=true;
				break;
			}
			if(RoleBizTypeEnum.DS.getValue().equals(r.getBizType())){
				hasTea=true;
				break;
			}
		}
		if(hasStu){
			for(Role r:ors){
				if(StringUtil.isEmpty(r.getBizType())){
					r.setBizType(CoreUtils.getRoleBizType(r.getId()));
				}
				if(RoleBizTypeEnum.DS.getValue().equals(r.getBizType())){
					return "不能从导师角色变更为学生角色";
				}
			}
		}
		if(hasTea){
			for(Role r:ors){
				if(StringUtil.isEmpty(r.getBizType())){
					r.setBizType(CoreUtils.getRoleBizType(r.getId()));
				}
				if(RoleBizTypeEnum.XS.getValue().equals(r.getBizType())){
					return "不能从学生角色变更为导师角色";
				}
			}
		}
		return null;
	}
	/*检查用户角色组成 有返回信息则验证不通过*/
	public static String checkRoleList(List<Role> rs) {
		if(rs==null||rs.size()==0){
			return null;
		}
		boolean hasStu=false;//是否有学生角色
		boolean hasTea=false;//是否有导师角色
		for(Role r:rs){
			if(StringUtil.isEmpty(r.getBizType())){
				r.setBizType(CoreUtils.getRoleBizType(r.getId()));
			}
			if(RoleBizTypeEnum.XS.getValue().equals(r.getBizType())){
				hasStu=true;
			}
			if(RoleBizTypeEnum.DS.getValue().equals(r.getBizType())){
				hasTea=true;
			}
			if(hasStu&&hasTea){
				return "用户不能同时有学生和导师的角色";
			}
		}
		return null;
	}

	/**检查用户是否有后台登录的角色
	 * @param user user对象中有role list
//	 * @param rolebiztype
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
				r.setBizType(CoreUtils.getRoleBizType(r.getId()));
			}
			if(!RoleBizTypeEnum.XS.getValue().equals(r.getBizType())&&!RoleBizTypeEnum.DS.getValue().equals(r.getBizType())){
				return true;
			}
		}
		return false;
	}
	/**检查用户是否有某个角色
	 * @param user user对象中有role list
	 * @param rolebiztype
	 * @return
	 */
	public static boolean checkHasRole(User user,RoleBizTypeEnum rolebiztype) {
		if(rolebiztype == null){
			return false;
		}
		return CoreUtils.checkHasRole(user, rolebiztype.getValue());
	}

	//检查用户是否有某个角色
	/*public static boolean checkHasRole(String userid,RoleBizTypeEnum rolebiztype) {
		if(StringUtil.isEmpty(userid)||rolebiztype==null){
			return false;
		}
		List<Role> rs=roleDao.findListByUserId(userid);
		if(rs==null||rs.size()==0){
			return false;
		}
		for(Role r:rs){
			if(rolebiztype.getValue().equals(r.getBizType())){
				return true;
			}
		}
		return false;
	}*/
	//返回true 说明未完善
	public static boolean checkInfoPerfect(User user) {
		if (user==null||StringUtil.isEmpty(user.getId())) {
			return false;
		}
//		if (checkHasRole(user, RoleBizTypeEnum.XS)) {//学生
//			StudentExpansion stu=UserUtils.getStudentByUserId(user.getId());
//			if (StringUtil.isEmpty(user.getLoginName())) {
//				return true;
//			}
//			if (StringUtil.isEmpty(user.getSex())) {
//				return true;
//			}
//			if (StringUtil.isEmpty(user.getName())) {
//				return true;
//			}
//			if (StringUtil.isEmpty(user.getIdType())) {
//				return true;
//			}
//			if (StringUtil.isEmpty(user.getIdNumber())) {
//				return true;
//			}
//			if (StringUtil.isEmpty(user.getMobile())) {
//				return true;
//			}
//			if (StringUtil.isEmpty(user.getEmail())) {
//				return true;
//			}
//			if (user.getOffice()==null||StringUtil.isEmpty(user.getOffice().getId())) {
//				return true;
//			}
//			if (StringUtil.isEmpty(stu.getCurrState())) {
//				return true;
//			}
//			if ("1".equals(stu.getCurrState())) {
//				if (StringUtil.isEmpty(stu.getInstudy())) {
//					return true;
//				}
//				if (StringUtil.isEmpty(user.getNo())) {
//					return true;
//				}
//			}
//			if ("2".equals(stu.getCurrState())) {
//				if (StringUtil.isEmpty(user.getEducation())) {
//					return true;
//				}
//				if (StringUtil.isEmpty(user.getDegree())) {
//					return true;
//				}
//				if (stu.getGraduation()==null) {
//					return true;
//				}
//			}
//			if ("3".equals(stu.getCurrState())) {
//				if (stu.getTemporaryDate()==null) {
//					return true;
//				}
//			}
//			if (stu.getEnterdate()==null) {
//				return true;
//			}
//			if (StringUtil.isEmpty(stu.getCycle())) {
//				return true;
//			}
//		}
//		if (checkHasRole(user, RoleBizTypeEnum.DS)) {//导师
//			BackTeacherExpansion bt=UserUtils.getTeacherByUserId(user.getId());
//			if ((bt != null)) {//不是企业导师
//    		    if (!(TeacherType.TY_QY.getKey()).equals(bt.getTeachertype())) {//不是企业导师
//    				if (StringUtil.isEmpty(user.getLoginName())) {
//    					return true;
//    				}
//    				if (StringUtil.isEmpty(user.getSex())) {
//    					return true;
//    				}
//    				if (StringUtil.isEmpty(user.getNo())) {
//    					return true;
//    				}
//    				if (StringUtil.isEmpty(user.getName())) {
//    					return true;
//    				}
//    				if (StringUtil.isEmpty(bt.getTeachertype())) {
//    					return true;
//    				}
//    				if (StringUtil.isEmpty(bt.getServiceIntention())) {
//    					return true;
//    				}
//    				if (StringUtil.isEmpty(user.getIdType())) {
//    					return true;
//    				}
//    				if (StringUtil.isEmpty(user.getIdNumber())) {
//    					return true;
//    				}
//    				if (StringUtil.isEmpty(bt.getEducationType())) {
//    					return true;
//    				}
//    				if (StringUtil.isEmpty(user.getEducation())) {
//    					return true;
//    				}
//    				if (StringUtil.isEmpty(user.getEmail())) {
//    					return true;
//    				}
//    				if (StringUtil.isEmpty(user.getMobile())) {
//    					return true;
//    				}
//    		    }
//			}
//		}
		return false;
	}
//	public static StudentExpansion getStudentByUserId(String uid) {
//		return studentExpansionDao.getByUserId(uid);
//	}
//	public static BackTeacherExpansion getTeacherByUserId(String uid) {
//		return backTeacherExpansionDao.getByUserId(uid);
//	}

	/**检查当前用户对foreignId是否点过赞
	 * @param foreignId
	 * @return
	 */
	public static boolean checkIsLikeForUserInfo(String foreignId) {
		User user=UserUtils.getUser();
		if (StringUtil.isEmpty(user.getId())) {
			return true;
		}
		if (user.getId().equals(foreignId)) {
			return true;
		}
//		SysLikes sc=new SysLikes();
//		sc.setUserId(user.getId());
//		sc.setForeignId(foreignId);
//		if (sysLikesDao.getExistsLike(sc)>0) {
//			return true;
//		}else{
//			return false;
//		}
        return false;
	}
	/**has rolelist
	 * 根据ID获取用户
	 * @param id
	 * @return 取不到返回null
	 */
	public static User get(String id) {
	User user = (User)CacheUtils.get(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_ID_ + id);
		if (user ==  null) {
			user = userDao.get(id);
			if (user == null) {
				return null;
			}
			user.setRoleList(roleDao.findList(new Role(user)));
			CacheUtils.put(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_ID_ + user.getId(), user);
			CacheUtils.put(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_LOGIN_NAME_ + user.getLoginName(), user);
		}
		return user;
	}

	/**
	 * 根据登录名获取用户
	 * @param loginName
	 * @return 取不到返回null
	 */
	public static User getByLoginName(String loginName) {
		User user = (User)CacheUtils.get(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_LOGIN_NAME_ + loginName);
		if (user == null) {
			user = userDao.getByLoginName(new User(null, loginName));
			if (user == null) {
				return null;
			}
			user.setRoleList(roleDao.findList(new Role(user)));
			CacheUtils.put(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_ID_ + user.getId(), user);
			CacheUtils.put(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_LOGIN_NAME_ + user.getLoginName(), user);
		}
		return user;
	}

	public static User getByLoginNameOrNo(String loginNameOrNo) {
		User user = (User)CacheUtils.get(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_LOGIN_NAME_ + loginNameOrNo);
		if (user == null) {
			user = userDao.getByLoginNameOrNo(loginNameOrNo,null);
			if (user == null) {
				return null;
			}
			CacheUtils.put(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_ID_ + user.getId(), user);
			CacheUtils.put(CoreUtils.USER_CACHE, CoreUtils.USER_CACHE_LOGIN_NAME_ + user.getLoginName(), user);
		}
		return user;
	}


	public static boolean isExistNo(String no) {
		User	user = userDao.getByLoginNameOrNo(no,null);
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
		User	user = userDao.getByMobile(p);
		if (user == null) {
			return false;
		}
		return true;
	}
	public static User getByMobile(String mobile) {
		User p=new User();
		p.setMobile(mobile);
		User	user = userDao.getByMobile(p);
		if (user == null) {
			return null;
		}
		user.setRoleList(roleDao.findList(new Role(user)));
		return user;
	}
	public static User getByMobile(String mobile,String id) {
		User p=new User();
		p.setMobile(mobile);
		p.setId(id);
		User	user = userDao.getByMobileWithId(p);
		if (user == null) {
			return null;
		}
		user.setRoleList(roleDao.findList(new Role(user)));
		return user;
	}

	/**
	 * 获取当前用户 (has rolelist)
	 * @return 取不到返回 new User()
	 */
	public static User getUser() {
	    return CoreUtils.getUser();
	}

	/**
	 * 获取当前用户角色列表
	 * @return
	 */
	public static List<Role> getRoleList() {
		@SuppressWarnings("unchecked")
		List<Role> roleList = (List<Role>) CoreUtils.getCache(CoreUtils.CACHE_ROLE_LIST);
		if (roleList == null) {
			User user = getUser();
			if (user.getAdmin()) {
				roleList = roleDao.findAllList(new Role());
			}else{
				Role role = new Role();
				//role.getSqlMap().put("dsf", BaseService.dataScopeFilter(user.getCurrentUser(), "o", "u"));
				roleList = roleDao.findList(role);
			}
			CoreUtils.putCache(CoreUtils.CACHE_ROLE_LIST, roleList);
		}
		return roleList;
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


	public static Office getAdminOffice() {
		Office office = (Office)CacheUtils.get(CoreUtils.CACHE_OFFICE, CoreIds.SYS_OFFICE_TOP.getId());
		if (office == null) {
			office = officeDao.get(CoreIds.SYS_OFFICE_TOP.getId());
			if (office!=null)CacheUtils.put(CoreUtils.CACHE_OFFICE, CoreIds.SYS_OFFICE_TOP.getId(),office);
		}
		return office;
	}

	public static List<Office> getOfficeListFront() {
		@SuppressWarnings("unchecked")
		List<Office> officeList = (List<Office>) CoreUtils.getCache("officeListFront");
		if (officeList == null) {
			/*if (user.isAdmin()) {*/
				officeList = officeDao.findAllList(new Office());
			/*}else{
				Office office = new Office();
			//	office.getSqlMap().put("dsf", BaseService.dataScopeFilter(user, "a", ""));
				officeList = officeDao.findList(office);
			}*/
			CoreUtils.putCache("officeListFront", officeList);
		}
		return officeList;
	}



	/**
	 * 获取授权主要对象
	 */
	public static Subject getSubject() {
		return SecurityUtils.getSubject();
	}

	// ============== User Cache ==============
	public static Object getCache(String key, Object defaultValue) {
//		Object obj = getCacheMap().get(key);
		Object obj = CoreUtils.getSession().getAttribute(key);
		return obj==null?defaultValue:obj;
	}

	public static List<OaNotify> getOaNotifyList(OaNotify oaNotify) {
		@SuppressWarnings("unchecked")
		List<OaNotify> oaNotifyList = (List<OaNotify>) CoreUtils.getCache(CACHE_OANOTIFY_LIST);
		if (oaNotifyList == null) {
			oaNotifyList = oaNotifyDao.findList(oaNotify);
			CoreUtils.putCache(CACHE_OANOTIFY_LIST, oaNotifyList);
		}
		return oaNotifyList;
	}

	public static List<ActYwSgtype> getActywStatusList(){
	    return actYwSgtypeDao.findList(new ActYwSgtype());
	}

	/**
	 * 跳转登录页面.
	 * @return String
	 */
	public static String toLogin() {
	  return CoreSval.REDIRECT + Global.getFrontPath() + "/toLogin";
	}


	public static boolean isAdmin(User user){
//		Role role = user.getRole();
//		return role != null && CoreIds.SYS_ADMIN_ROLE.getId().equals(role.getId());
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

//	public static Boolean isCompleteUserInfo(User user, StudentExpansion studentExpansion){
//		Boolean isComplete = true;
//		List<String> userKeys = new ArrayList<>();
//		userKeys.add("getMobile");
//		userKeys.add("email");
//		userKeys.add("idType");
//		userKeys.add("idNumber");
//		for (String keyItem: userKeys){
//			if(StringUtil.isEmpty(user.getIdType())){
//				isComplete = false;
//				break;
//			}
//		}
//		return  isComplete;
//	}
}
