/**
 * 
 */
package com.oseasy.pgen.modules.gen.dao;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.pgen.modules.gen.entity.GenTable;

/**
 * 业务表DAO接口


 */
@MyBatisDao
public interface GenTableDao extends CrudDao<GenTable> {
	
}
