/**
 *
 */
package com.oseasy.pcore.modules.sys.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcore.common.persistence.TreeDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.pcore.modules.sys.entity.Office;

/**
 * 机构DAO接口

 * @version 2014-05-16
 */
@MyBatisDao
public interface OfficeDao extends TreeDao<Office> {

	String selelctParentId(@Param("id") String id);

	List<Office> findProfessionByParentIdsLike(Office office);

	List<Office> findProfessionByParentIds(@Param("officeIds") String officeIds);

	List<Office> findColleges();

	List<Office> findProfessionals(String parentId);
	Office getSchool();
	Office getOrgByName(@Param("oname") String oname);
	Office getOfficeByName(@Param("oname") String oname);
	Office getProfessionalByName(@Param("oname") String oname,@Param("pname") String pname);
	Office getProfessionalByPName(@Param("pname") String pname);
	int checkNameByParent(@Param("parentId") String parentId, @Param("name") String name);

	void updateSpace(Office office);

	int checkByNameAndId(@Param("id") String id, @Param("parentId") String parentId,  @Param("name")String name);
}
