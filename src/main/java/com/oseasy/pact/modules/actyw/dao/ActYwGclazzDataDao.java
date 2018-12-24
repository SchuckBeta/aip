package com.oseasy.pact.modules.actyw.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pact.modules.actyw.entity.ActYwGclazzData;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 监听数据DAO接口.
 * @author chenh
 * @version 2018-03-08
 */
@MyBatisDao
public interface ActYwGclazzDataDao extends CrudDao<ActYwGclazzData> {
    /**
     * 批量更新数据
     * @param entity
     * @return
     */
    public int savePl(@Param("list") List<ActYwGclazzData> entitys);

    /**
     * 根据申报ID和节点ID查询数据列表，如果需要分页，请设置分页对象，如：entity.setPage(new Page<T>());
     * @param entity
     * @return
     */
    public List<ActYwGclazzData> findListByAgnode(@Param("applyId") String applyId, @Param("gnodeId") String gnodeId, @Param("entity")ActYwGclazzData entity);

    /**
     * 获取单条数据
     * @param id
     * @return ActYwGclazzData
     */
    public ActYwGclazzData getStart(@Param("applyId") String applyId, @Param("type") String type);

  /**
   * 物理删除.
   * @param entity
   */
  public void deleteWL(ActYwGclazzData actYwGclazzData);
  /**
   * 批量物理删除.
   * @param entity
   */
  public void deleteWLPL(@Param("ids") List<String> ids);

  /**
   * 根据申报ID物理删除.
   * @param entity
   */
  public void deleteWLPLByApply(@Param("applyId") String applyId);

  /**
   * 根据节点监听ID物理删除.
   * @param entity
   */
  public void deleteWLPLByGzlazz(@Param("gclazzId") String gclazzId);
  /**
   * 根据监听类ID物理删除.
   * @param entity
   */
  public void deleteWLPLByClazz(@Param("clazzId") String clazzId);
  /**
   * 根据申报ID和节点ID物理删除.
   * @param entity
   */
  public void deleteWLPLByAgnode(@Param("applyId") String applyId, @Param("gnodeId") String gnodeId);
}