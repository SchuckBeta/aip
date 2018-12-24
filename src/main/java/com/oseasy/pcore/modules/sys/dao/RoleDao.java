/**
 *
 */
package com.oseasy.pcore.modules.sys.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.pcore.modules.sys.entity.Role;

/**
 * 角色DAO接口


 */
@MyBatisDao
public interface RoleDao extends CrudDao<Role> {
	public Integer getRoleUserCount(String roleid);
	public Role getByName(Role role);

	public Role getByEnname(Role role);

	/**
	 * 维护角色与菜单权限关系
	 * @param role
	 * @return
	 */
	public int deleteRoleMenu(Role role);

	public int insertRoleMenu(Role role);

	/**
	 * 维护角色与公司部门关系
	 * @param role
	 * @return
	 */
	public int deleteRoleOffice(Role role);

	public int insertRoleOffice(Role role);

	public List<Role> findListByUserId(@Param(value = "userId") String userId);

	public Role getNamebyId(String id);

	public Integer checkRoleName(Role role);

	public Integer checkRoleEnName(Role role);

	public List<Role> findListByIds(@Param("ids") List<String> ids);
}
