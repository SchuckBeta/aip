package com.oseasy.pgen.modules.gen.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.pgen.modules.gen.entity.GenSchemeGtemplate;

/**
 * 模板方案组关联DAO接口.
 * @author chenh
 * @version 2018-12-29
 */
@MyBatisDao
public interface GenSchemeGtemplateDao extends CrudDao<GenSchemeGtemplate> {
    /**
     * 批量新增.
     * @param entitys
     */
    public void insertPL(@Param("entitys") List<GenSchemeGtemplate> entitys);

    /**
     * 批量修改.
     * @param entitys
     */
    public void updatePL(@Param("entitys") List<GenSchemeGtemplate> entitys);


  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(GenSchemeGtemplate entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(GenSchemeGtemplate entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(GenSchemeGtemplate entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();
}