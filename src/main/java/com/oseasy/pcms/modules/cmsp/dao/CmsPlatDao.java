package com.oseasy.pcms.modules.cmsp.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcms.modules.cmsp.entity.CmsPlat;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 页面布局DAO接口.
 * @author chenh
 * @version 2018-12-25
 */
@MyBatisDao
public interface CmsPlatDao extends CrudDao<CmsPlat> {
    /**
     * 批量新增.
     * @param entitys
     */
    public void insertPL(@Param("entitys") List<CmsPlat> entitys);

    /**
     * 批量修改.
     * @param entitys
     */
    public void updatePL(@Param("entitys") List<CmsPlat> entitys);


  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(CmsPlat entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(CmsPlat entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(CmsPlat entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();
}