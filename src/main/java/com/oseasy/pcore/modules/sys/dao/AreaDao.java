/**
 * 
 */
package com.oseasy.pcore.modules.sys.dao;

import com.oseasy.pcore.common.persistence.TreeDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.pcore.modules.sys.entity.Area;

/**
 * 区域DAO接口

 * @version 2014-05-16
 */
@MyBatisDao
public interface AreaDao extends TreeDao<Area> {
	
}
