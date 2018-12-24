package com.oseasy.initiate.modules.sys.dao;

import com.oseasy.initiate.modules.sys.entity.SysTeacherExpansion;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 导师信息表DAO接口
 * @author l
 * @version 2017-03-28
 */
@MyBatisDao
public interface SysTeacherExpansionDao extends CrudDao<SysTeacherExpansion> {
	
}