/**
 * 
 */
package com.oseasy.initiate.test.dao;

import com.oseasy.initiate.test.entity.TestDataChild;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 主子表生成DAO接口

 * @version 2015-04-06
 */
@MyBatisDao
public interface TestDataChildDao extends CrudDao<TestDataChild> {
	
}