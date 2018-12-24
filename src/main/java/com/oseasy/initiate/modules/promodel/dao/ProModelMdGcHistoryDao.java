package com.oseasy.initiate.modules.promodel.dao;

import com.oseasy.initiate.modules.promodel.entity.ProModelMdGcHistory;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 民大大赛记录表DAO接口.
 * @author zy
 * @version 2018-06-05
 */
@MyBatisDao
public interface ProModelMdGcHistoryDao extends CrudDao<ProModelMdGcHistory> {

  /**
   * 物理删除.
   * @param entity
   */
  public void deleteWL(ProModelMdGcHistory proModelMdGcHistory);

  ProModelMdGcHistory getProModelMdGcHistory(ProModelMdGcHistory proModelMdGcHistory);

  List<ProModelMdGcHistory> getProModelMdGcHistoryList(ProModelMdGcHistory proModelMdGcHistory);

  void updateAward(@Param("id")String id, @Param("result")String result);
}