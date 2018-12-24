package com.oseasy.initiate.modules.sys.dao;

import com.oseasy.initiate.modules.sys.entity.SysPropItem;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 系统功能配置项DAO接口.
 * @author chenh
 * @version 2018-03-30
 */
@MyBatisDao
public interface SysPropItemDao extends CrudDao<SysPropItem> {

  /**
   * 物理删除.
   * @param entity
   */
  public void deleteWL(SysPropItem sysPropItem);
}