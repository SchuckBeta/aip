/**
 * 
 */
package com.oseasy.pgen.modules.gen.dao;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.pgen.modules.gen.entity.GenTemplate;

/**
 * 代码模板DAO接口


 */
@MyBatisDao
public interface GenTemplateDao extends CrudDao<GenTemplate> {
	
}
