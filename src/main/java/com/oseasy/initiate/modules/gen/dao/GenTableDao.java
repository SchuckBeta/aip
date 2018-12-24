/**
 * 
 */
package com.oseasy.initiate.modules.gen.dao;

import com.oseasy.initiate.modules.gen.entity.GenTable;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 业务表DAO接口


 */
@MyBatisDao
public interface GenTableDao extends CrudDao<GenTable> {
	
}
