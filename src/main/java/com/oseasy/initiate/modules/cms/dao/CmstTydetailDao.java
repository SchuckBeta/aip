package com.oseasy.initiate.modules.cms.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.initiate.modules.cms.entity.CmstTydetail;

/**
 * 模板类型明细DAO接口.
 * @author chenh
 * @version 2018-12-25
 */
@MyBatisDao
public interface CmstTydetailDao extends CrudDao<CmstTydetail> {
    /**
     * 批量新增.
     * @param entitys
     */
    public void insertPL(@Param("entitys") List<CmstTydetail> entitys);

    /**
     * 批量修改.
     * @param entitys
     */
    public void updatePL(@Param("entitys") List<CmstTydetail> entitys);


  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(CmstTydetail entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(CmstTydetail entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(CmstTydetail entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();
}