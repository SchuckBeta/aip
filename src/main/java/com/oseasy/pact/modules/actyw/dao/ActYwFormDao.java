package com.oseasy.pact.modules.actyw.dao;

import java.util.List;

import com.oseasy.pact.modules.actyw.entity.ActYwForm;
import com.oseasy.pact.modules.actyw.entity.ActYwFormVo;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 项目流程表单DAO接口.
 * @author chenhao
 * @version 2017-05-23
 */
@MyBatisDao
public interface ActYwFormDao extends CrudDao<ActYwForm> {

  List<ActYwForm> findListByInStyle(ActYwFormVo actYwVo);

}