package com.oseasy.pcms.modules.cms.dao;

import com.oseasy.pcms.modules.cms.entity.CmstType;
import com.oseasy.pcore.common.persistence.TreeDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

/**
 * 模板类型DAO接口.
 * @author chenh
 * @version 2018-12-25
 */
@MyBatisDao
public interface CmstTypeDao extends TreeDao<CmstType> {
    /**
     * 批量新增.
     * @param entitys
     */
    public void insertPL(@Param("entitys") List<CmstType> entitys);

    /**
     * 批量修改.
     * @param entitys
     */
    public void updatePL(@Param("entitys") List<CmstType> entitys);


  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(CmstType entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(CmstType entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(CmstType entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();
}