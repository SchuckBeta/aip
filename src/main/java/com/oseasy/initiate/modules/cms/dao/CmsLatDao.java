package com.oseasy.initiate.modules.cms.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.initiate.modules.cms.entity.CmsLat;

/**
 * 布局DAO接口.
 * @author chenh
 * @version 2018-12-25
 */
@MyBatisDao
public interface CmsLatDao extends CrudDao<CmsLat> {
    /**
     * 批量新增.
     * @param entitys
     */
    public void insertPL(@Param("entitys") List<CmsLat> entitys);

    /**
     * 批量修改.
     * @param entitys
     */
    public void updatePL(@Param("entitys") List<CmsLat> entitys);


  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(CmsLat entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(CmsLat entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(CmsLat entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();
}