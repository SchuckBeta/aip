/**
 * 
 */
package com.oseasy.initiate.modules.test.dao;

import com.oseasy.initiate.modules.test.entity.Test;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 测试DAO接口


 */
@MyBatisDao
public interface TestDao extends CrudDao<Test> {
	
}
