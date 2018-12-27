/**
 * 
 */
package com.oseasy.pgen.modules.gen.dao;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.pgen.modules.gen.entity.GenTableColumn;

/**
 * 业务表字段DAO接口


 */
@MyBatisDao
public interface GenTableColumnDao extends CrudDao<GenTableColumn> {
	
	public void deleteByGenTableId(String genTableId);
}
