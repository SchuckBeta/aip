package com.oseasy.pcms.modules.cmsp.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcms.modules.cmsp.entity.CmsPage;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 页面DAO接口.
 * @author chenh
 * @version 2018-12-25
 */
@MyBatisDao
public interface CmsPageDao extends CrudDao<CmsPage> {
    /**
     * 批量新增.
     * @param entitys
     */
    public void insertPL(@Param("entitys") List<CmsPage> entitys);

    /**
     * 批量修改.
     * @param entitys
     */
    public void updatePL(@Param("entitys") List<CmsPage> entitys);


  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(CmsPage entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(CmsPage entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(CmsPage entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();
}