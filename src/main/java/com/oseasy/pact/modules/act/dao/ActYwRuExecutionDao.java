package com.oseasy.pact.modules.act.dao;

import com.oseasy.pact.modules.act.entity.ActYwRuExecution;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 流程运行实例DAO接口.
 *
 * @author chenhao
 * @version 2017-06-08
 */
@MyBatisDao
public interface ActYwRuExecutionDao extends CrudDao<ActYwRuExecution> {

}