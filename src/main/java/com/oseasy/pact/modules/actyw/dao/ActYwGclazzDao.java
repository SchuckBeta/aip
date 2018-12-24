package com.oseasy.pact.modules.actyw.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pact.modules.actyw.entity.ActYwGclazz;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 监听类DAO接口.
 * @author chenh
 * @version 2018-03-01
 */
@MyBatisDao
public interface ActYwGclazzDao extends CrudDao<ActYwGclazz> {

  /**
   * 物理删除.
   * @param entity
   */
  public void deleteWL(ActYwGclazz actYwGclazz);

  /**
   * 批量保存.
   * @param list 列表
   * @return
   */
  public int savePl(@Param("list") List<ActYwGclazz> list);

  /**
   * 根据groupId批量物理删除.
   * @param groupId 流程ID
   */
  public void deletePlwlByGroup(@Param("groupId") String groupId);
  /**
   * 根据groupId和gnodeId批量物理删除.
   * @param groupId 流程ID
   * @param gnodeId 节点ID
   */
  public void deletePlwl(@Param("groupId") String groupId, @Param("gnodeId") String gnodeId);
}