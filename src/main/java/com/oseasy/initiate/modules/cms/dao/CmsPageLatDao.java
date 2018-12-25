package com.oseasy.initiate.modules.cms.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.initiate.modules.cms.entity.CmsPageLat;

/**
 * 页面布局DAO接口.
 * @author chenh
 * @version 2018-12-25
 */
@MyBatisDao
public interface CmsPageLatDao extends CrudDao<CmsPageLat> {
    /**
     * 批量新增.
     * @param entitys
     */
    public void insertPL(@Param("entitys") List<CmsPageLat> entitys);

    /**
     * 批量修改.
     * @param entitys
     */
    public void updatePL(@Param("entitys") List<CmsPageLat> entitys);


  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(CmsPageLat entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(CmsPageLat entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(CmsPageLat entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();
}