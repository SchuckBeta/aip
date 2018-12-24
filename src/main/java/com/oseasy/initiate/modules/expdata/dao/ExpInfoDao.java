package com.oseasy.initiate.modules.expdata.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.initiate.modules.expdata.entity.ExpInfo;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 导出数据信息DAO接口.
 * @author 奔波儿灞
 * @version 2017-12-27
 */
@MyBatisDao
public interface ExpInfoDao extends CrudDao<ExpInfo> {

  /**
   * 物理删除.
   * @param entity
   */
  public void deleteWL(ExpInfo expInfo);
  public List<ExpInfo> findListByType(String type);
  public void deleteByList(@Param("eis")List<ExpInfo> eis);
}