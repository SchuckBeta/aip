/**
 * 
 */
package com.oseasy.initiate.modules.gen.dao;

import com.oseasy.initiate.modules.gen.entity.GenTableColumn;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 业务表字段DAO接口


 */
@MyBatisDao
public interface GenTableColumnDao extends CrudDao<GenTableColumn> {
	
	public void deleteByGenTableId(String genTableId);
}
