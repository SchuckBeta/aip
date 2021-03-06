package com.oseasy.pcms.modules.cmst.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcms.modules.cmst.entity.CmstTheme;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 站点模板主题DAO接口.
 * @author chenh
 * @version 2018-12-25
 */
@MyBatisDao
public interface CmstThemeDao extends CrudDao<CmstTheme> {
    /**
     * 批量新增.
     * @param entitys
     */
    public void insertPL(@Param("entitys") List<CmstTheme> entitys);

    /**
     * 批量修改.
     * @param entitys
     */
    public void updatePL(@Param("entitys") List<CmstTheme> entitys);


  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(CmstTheme entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(CmstTheme entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(CmstTheme entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();
}