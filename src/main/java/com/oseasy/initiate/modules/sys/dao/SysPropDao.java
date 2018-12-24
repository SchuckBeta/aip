package com.oseasy.initiate.modules.sys.dao;

import com.oseasy.initiate.modules.sys.entity.SysProp;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 系统功能DAO接口.
 * @author chenh
 * @version 2018-03-30
 */
@MyBatisDao
public interface SysPropDao extends CrudDao<SysProp> {

  /**
   * 物理删除.
   * @param entity
   */
  public void deleteWL(SysProp sysProp);
}