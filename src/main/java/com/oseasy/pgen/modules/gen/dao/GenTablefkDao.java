package com.oseasy.pgen.modules.gen.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.pgen.modules.gen.entity.GenTablefk;

/**
 * GenTableFkDAO接口.
 * @author chenh
 * @version 2018-12-28
 */
@MyBatisDao
public interface GenTablefkDao extends CrudDao<GenTablefk> {
    /**
     * 批量新增.
     * @param entitys
     */
    public void insertPL(@Param("entitys") List<GenTablefk> entitys);

    /**
     * 批量修改.
     * @param entitys
     */
    public void updatePL(@Param("entitys") List<GenTablefk> entitys);


  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(GenTablefk entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(GenTablefk entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(GenTablefk entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();
}