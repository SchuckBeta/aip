package com.oseasy.pgen.modules.gen.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.pgen.modules.gen.entity.GenTgroupTemplate;

/**
 * 模板组关联DAO接口.
 * @author chenh
 * @version 2018-12-29
 */
@MyBatisDao
public interface GenTgroupTemplateDao extends CrudDao<GenTgroupTemplate> {
    /**
     * 批量新增.
     * @param entitys
     */
    public void insertPL(@Param("entitys") List<GenTgroupTemplate> entitys);

    /**
     * 批量修改.
     * @param entitys
     */
    public void updatePL(@Param("entitys") List<GenTgroupTemplate> entitys);


  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(GenTgroupTemplate entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(GenTgroupTemplate entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(GenTgroupTemplate entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();
}