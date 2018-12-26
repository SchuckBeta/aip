package com.oseasy.pcms.modules.cms.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcms.modules.cms.entity.CmsThemeDetail;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 主题明细DAO接口.
 * @author chenhao
 * @version 2018-12-25
 */
@MyBatisDao
public interface CmsThemeDetailDao extends CrudDao<CmsThemeDetail> {
    /**
     * 批量新增.
     * @param entitys
     */
    public void insertPL(@Param("entitys") List<CmsThemeDetail> entitys);

    /**
     * 批量修改.
     * @param entitys
     */
    public void updatePL(@Param("entitys") List<CmsThemeDetail> entitys);


  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(CmsThemeDetail entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(CmsThemeDetail entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(CmsThemeDetail entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();
}