package com.oseasy.pact.modules.actyw.dao;

import com.oseasy.pact.modules.actyw.entity.ActYwClazz;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 监听DAO接口.
 * @author chenh
 * @version 2018-03-01
 */
@MyBatisDao
public interface ActYwClazzDao extends CrudDao<ActYwClazz> {

  /**
   * 物理删除.
   * @param entity
   */
  public void deleteWL(ActYwClazz actYwClazz);
}