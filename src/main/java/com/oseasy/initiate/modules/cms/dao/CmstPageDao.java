package com.oseasy.initiate.modules.cms.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.initiate.modules.cms.entity.CmstPage;

/**
 * 模板页面DAO接口.
 * @author chenh
 * @version 2018-12-26
 */
@MyBatisDao
public interface CmstPageDao extends CrudDao<CmstPage> {
    /**
     * 批量新增.
     * @param entitys
     */
    public void insertPL(@Param("entitys") List<CmstPage> entitys);

    /**
     * 批量修改.
     * @param entitys
     */
    public void updatePL(@Param("entitys") List<CmstPage> entitys);


  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(CmstPage entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(CmstPage entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(CmstPage entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();
}