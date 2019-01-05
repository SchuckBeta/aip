package com.oseasy.pcms.modules.cmss.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcms.modules.cmss.entity.CmssMenu;
import com.oseasy.pcore.common.persistence.TreeDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 站点菜单DAO接口.
 * @author chenhao
 * @version 2019-01-01
 */
@MyBatisDao
public interface CmssMenuDao extends TreeDao<CmssMenu> {
//    /**
//     * 批量新增.
//     * @param entitys
//     */
//    public void insertPL(@Param("entitys") List<CmssMenu> entitys);
//
//    /**
//     * 批量修改.
//     * @param entitys
//     */
//    public void updatePL(@Param("entitys") List<CmssMenu> entitys);
    /**
     * 查询数据列表，如果需要分页，请设置分页对象，如：entity.setPage(new Page<T>());
     * @param entity
     * @return
     */
    public List<CmssMenu> findListBySite(CmssMenu entity);

  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(CmssMenu entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(CmssMenu entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(CmssMenu entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();

    public CmssMenu getByName(@Param("name") String name);
    public CmssMenu getByHref(@Param("href") String href);
    public void updateSort(CmssMenu menu);
    public void updateIsShow(CmssMenu menu);
    public Integer checkName(CmssMenu menu);
}