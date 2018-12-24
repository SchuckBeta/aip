package com.oseasy.pact.modules.actyw.dao;

import com.oseasy.pact.modules.actyw.entity.ActYwGassign;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 业务指派表DAO接口.
 * @author zy
 * @version 2018-04-03
 */
@MyBatisDao
public interface ActYwGassignDao extends CrudDao<ActYwGassign> {

  /**
   * 物理删除.
   * @param entity
   */
  public void deleteWL(ActYwGassign actYwGassign);

  List<ActYwGassign> getListByActYwGassign(ActYwGassign actYwGassign);

  void insertPl(@Param("list")List<ActYwGassign> insertActYwGassignList);

  void deleteByAssign(ActYwGassign actYwGassign);
}