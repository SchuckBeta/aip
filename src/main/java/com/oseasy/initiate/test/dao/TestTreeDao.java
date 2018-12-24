/**
 * 
 */
package com.oseasy.initiate.test.dao;

import com.oseasy.initiate.test.entity.TestTree;
import com.oseasy.pcore.common.persistence.TreeDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 树结构生成DAO接口

 * @version 2015-04-06
 */
@MyBatisDao
public interface TestTreeDao extends TreeDao<TestTree> {
	
}