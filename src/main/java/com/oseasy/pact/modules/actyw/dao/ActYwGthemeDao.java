package com.oseasy.pact.modules.actyw.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pact.modules.actyw.entity.ActYwGtheme;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 表单组DAO接口.
 *
 * @author chenh
 * @version 2018-09-06
 */
@MyBatisDao
public interface ActYwGthemeDao extends CrudDao<ActYwGtheme> {
    /**
     * 批量新增.
     * @param entitys
     */
    public void insertPL(@Param("entitys") List<ActYwGtheme> entitys);

    /**
     * 批量修改.
     * @param entitys
     */
    public void updatePL(@Param("entitys") List<ActYwGtheme> entitys);
    /**
     * 批量修改Sort.
     * @param entitys
     */
    public void updatePLSort(@Param("entitys") List<ActYwGtheme> entitys);

    /**
     * 物理删除.
     * @param entity
     */
    public void deleteWL(ActYwGtheme entity);

    /**
     * 批量状态删除.
     * @param entity
     */
    public void deletePL(ActYwGtheme entity);

    /**
     * 批量物理删除.
     * @param entity
     */
    public void deleteWLPL(ActYwGtheme entity);

    /**
     * 清空表.
     */
    public void deleteWLAll();
}