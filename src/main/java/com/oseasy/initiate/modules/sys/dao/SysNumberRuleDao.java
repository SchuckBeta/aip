package com.oseasy.initiate.modules.sys.dao;

import com.oseasy.initiate.modules.sys.entity.SysNumberRule;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

import org.apache.ibatis.annotations.Param;

/**
 * 编号规则管理DAO接口.
 * @author 李志超
 * @version 2018-05-17
 */
@MyBatisDao
public interface SysNumberRuleDao extends CrudDao<SysNumberRule> {

  /**
   * 物理删除.
   * @param entity
   */
  public void deleteWL(SysNumberRule sysNumberRule);

  SysNumberRule getRuleByAppType(@Param("appType") String appType, @Param("id") String id);
}