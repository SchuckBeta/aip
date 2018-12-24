package com.oseasy.initiate.modules.sys.dao;

import com.oseasy.initiate.modules.sys.entity.SysNumberRuleDetail;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 编号规则详情表DAO接口.
 * @author 李志超
 * @version 2018-05-17
 */
@MyBatisDao
public interface SysNumberRuleDetailDao extends CrudDao<SysNumberRuleDetail> {

  /**
   * 物理删除.
   * @param entity
   */
  public void deleteWL(SysNumberRuleDetail sysNumberRuleDetail);

  void batchSave(List<SysNumberRuleDetail> sysNumberRuleDetailList);

  /**
   * 根据SysNumberRule表id删除对应明细
   * @param ruleId
   */
  void deleteByRuleId(@Param("ruleId") String ruleId);

  List<SysNumberRuleDetail> findSysNumberRuleDetailList(@Param("ruleId") String ruleId);

  SysNumberRuleDetail getBySysNumberRule(@Param("sysNumberRuleId")String sysNumberRuleId, @Param("ruleType")String ruleType);
}