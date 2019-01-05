package com.oseasy.pcms.modules.cms.dao;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcms.modules.cms.entity.CmsMenu;
import com.oseasy.pcore.common.persistence.TreeDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * CMS菜单DAO接口.
 * @author chenh
 * @version 2019-01-01
 */
@MyBatisDao
public interface CmsMenuDao extends TreeDao<CmsMenu> {
//    /**
//     * 批量新增.
//     * @param entitys
//     */
//    public void insertPL(@Param("entitys") List<CmsMenu> entitys);
//
//    /**
//     * 批量修改.
//     * @param entitys
//     */
//    public void updatePL(@Param("entitys") List<CmsMenu> entitys);


  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(CmsMenu entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(CmsMenu entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(CmsMenu entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();

    public CmsMenu getByName(@Param("name") String name);
    public CmsMenu getByHref(@Param("href") String href);
    public void updateSort(CmsMenu menu);
    public void updateIsShow(CmsMenu menu);
    public Integer checkName(CmsMenu menu);
}