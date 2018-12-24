/**
 *
 */
package com.oseasy.pcore.modules.sys.dao;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.pcore.modules.sys.entity.User;
import com.oseasy.pcore.modules.sys.vo.UserVo;

/**
 * 用户DAO接口

 * @version 2014-05-16
 */
@MyBatisDao
public interface UserDao extends CrudDao<User> {
	public List<UserVo> findListByVo(UserVo vo);
	public List<UserVo> getTeaInfo(@Param("idsArr")String[] idsArr);
	public List<UserVo> getStudentInfo(@Param("idsArr")String[] idsArr);
	public void updateLikes(@Param("param") Map<String,Integer> param);
	//批量更新浏览量
    public void updateViews(@Param("param") Map<String,Integer> param);
	public User getByMobile(User user);
	public User getByMobileWithId(User user);
	public void updateMobile(User user);

	public  String getTeacherTypeByUserId(@Param("userId") String userId);
	/**
	 * 根据登录名称查询用户
	 * @return
	 */
	public User getByLoginName(User user);

	/**
	 * 根据登录名或者学号查询用户
	 * @param loginNameOrNo 录名或者学号
	 * @return User
     */
	public User getByLoginNameOrNo(@Param("loginNameOrNo")String  loginNameOrNo,@Param("id")String  id);
	public User getByLoginNameAndNo(@Param("loginName")String  loginName,@Param("no")String no);

	/**
	 * 通过OfficeId获取用户列表，仅返回用户id和name（树查询用户时用）
	 * @param user
	 * @return
	 */
	public List<User> findUserByOfficeId(User user);

	/**
	 * 通过professionalId获取用户列表，仅返回用户id和name（树查询用户时用）
	 * @param user
	 * @return
	 */
	public List<User> findUserByProfessionId(User user);
	public List<User> findUserByProfessionIdAndRoleType(User user);

	/**
	 * 查询全部用户数目
	 * @return
	 */
	public long findAllCount(User user);

	/**
	 * 更新用户密码
	 * @param user
	 * @return
	 */
	public int updatePasswordById(User user);

	/**
	 * 更新用户照片
	 * @param user
	 * @return
	 */
	public int updateUserPhoto(User user);
	/**
	 * 更新登录信息，如：登录IP、登录时间
	 * @param user
	 * @return
	 */
	public int updateLoginInfo(User user);

	/**
	 * 删除用户角色关联数据
	 * @param user
	 * @return
	 */
	public int deleteUserRole(User user);

	/**
	 * 插入用户角色关联数据
	 * @param user
	 * @return
	 */
	public int insertUserRole(User user);

	/**
	 * 更新用户信息
	 * @param user
	 * @return
	 */
	public int updateUserInfo(User user);

	public List<User> findListByRoleName(String enname);
	public List<User> getCollegeSecs(String id);
	public List<User> getCollegeExperts(String id);
	public List<User> getSchoolSecs();
	public List<User> getSchoolExperts();

	public List<User> findByType(User user);
	public List<User> findByRoleBizType(User user);

	public int insert(User user);

	public void updateUserByPhone(User user);

	public User findUserByLoginName(String loginName);

	public User getUserByName(String name);

	public List<User> findListTree(User user);

	/**
	 * 查询学生.
   * @param user 用户
   * @return List
	 */
	public List<User> findListTreeByStudent(User user);
	/**
	 * 查询学生.
	 * @param user 用户
	 * @return List
	 */
	public List<User> findListTreeByStudentNoDomain(User user);

  /**
   * 查询导师.
   * @param user 用户
   * @return List
   */
	public List<User> findListTreeByTeacher(User user);

  /**
   * 查询用户（基本信息）.
   * @param user 用户
   * @return List
   */
	public List<User> findListTreeByUser(User user);
	public List<User> getStuByCdn(@Param("no") String no,@Param("name") String name);
	public List<User> getTeaByCdn(@Param("no") String no,@Param("name") String name);
	public User getByNo(@Param("no")String no);
	List<User> findListByRoleId(String roleId);

	List<User> findListByRoleNameAndOffice(@Param("enname") String enname, @Param("userId") String userId);

	public List<UserVo> getUserByPorIdAndTeamId(@Param("proId")String proId, @Param("teamId") String teamId, @Param("userType") String userType);

	/**
	 * 查询所有需要修复的学生.
	 */
  	public List<String> findUserByRepair();

	List<User> findListByRoleIdAndOffice(@Param("roleId")String roleId, @Param("userId")String userId);

	Integer checkLoginNameUnique(@Param("loginName") String loginName, @Param("userId") String userId);

	Integer checkNoUnique(@Param("no") String no, @Param("userId") String userId);

	Integer checkUserNoUnique(@Param("no") String no, @Param("userId") String userId);

	Integer checkMobileUnique(@Param("mobile") String mobile, @Param("userId") String userId);

	public List<User> findListByRoleTypeAndOffice(@Param("officeid")String officeid,@Param("roletype")String roletype);

	List<User> findUserByExpert(User user);

	List<User> findUserListByRoleId(@Param("roleId")String roleId);

	Date getSysDate();
}
