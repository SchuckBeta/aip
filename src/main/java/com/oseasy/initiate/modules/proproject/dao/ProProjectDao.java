package com.oseasy.initiate.modules.proproject.dao;

import com.oseasy.initiate.modules.proproject.entity.ProProject;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 创建项目DAO接口.
 * @author zhangyao
 * @version 2017-06-15
 */
@MyBatisDao
public interface ProProjectDao extends CrudDao<ProProject> {

    ProProject getProProjectByName(String name);

    ProProject getProProjectByMark(String mark);
}