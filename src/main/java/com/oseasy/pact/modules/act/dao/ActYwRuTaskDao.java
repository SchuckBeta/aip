package com.oseasy.pact.modules.act.dao;

import com.oseasy.pact.modules.act.entity.ActYwRuTask;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 流程运行任务DAO接口.
 *
 * @author chenhao
 * @version 2017-06-08
 */
@MyBatisDao
public interface ActYwRuTaskDao extends CrudDao<ActYwRuTask> {

}