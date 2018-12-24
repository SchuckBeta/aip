package com.oseasy.pact.modules.actyw.dao;

import com.oseasy.pact.modules.actyw.entity.ActYwConfig;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 业务配置项DAO接口.
 * @author chenh
 * @version 2017-11-09
 */
@MyBatisDao
public interface ActYwConfigDao extends CrudDao<ActYwConfig> {

}