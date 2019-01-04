package com.oseasy.pcms.modules.cmss.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pcms.modules.cmss.entity.CmsSite;
import com.oseasy.pcore.common.persistence.BaseDao;
import com.oseasy.pcore.common.persistence.TreeDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 站点DAO接口.
 * @author chenh
 * @version 2018-12-25
 */
@MyBatisDao
public interface CmsSiteDao extends TreeDao<CmsSite> {
    /**
     * 获取当前站点
     * a.is_curr = '1'
     * @return CmsSite
     */
    public CmsSite getCurr(CmsSite entity);

    /**
     * 获取所有当前站点
     * a.is_curr = '1'
     * @return List
     */
    public List<CmsSite> getCurrs();

    /**
     * 批量新增.
     * @param entitys
     */
    public void insertPL(@Param("entitys") List<CmsSite> entitys);

    /**
     * 批量修改.
     * @param entitys
     */
    public void updatePL(@Param("entitys") List<CmsSite> entitys);


  	/**
   	 * 物理删除.
   	 * @param entity
   	 */
  	public void deleteWL(CmsSite entity);

   	/**
   	 * 批量状态删除.
   	 * @param entity
   	 */
  	public void deletePL(CmsSite entity);

    /**
   	 * 批量物理删除.
   	 * @param entity
   	 */
  	public void deleteWLPL(CmsSite entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();
}