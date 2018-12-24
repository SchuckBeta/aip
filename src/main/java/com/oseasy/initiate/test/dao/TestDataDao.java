/**
 * 
 */
package com.oseasy.initiate.test.dao;

import com.oseasy.initiate.test.entity.TestData;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 单表生成DAO接口

 * @version 2015-04-06
 */
@MyBatisDao
public interface TestDataDao extends CrudDao<TestData> {
	
}