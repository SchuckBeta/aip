package com.oseasy.pact.modules.actyw.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.pact.modules.actyw.entity.ActYwGroup;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 自定义流程DAO接口.
 * @author chenhao
 * @version 2017-05-23
 */
@MyBatisDao
public interface ActYwGroupDao extends CrudDao<ActYwGroup> {
    /**
     * 根据流程keyss 获取对象.
     * @param keyss 流程标识
     * @return ActYwGroup
     */
    public List<ActYwGroup> getByKeyss(@Param("keyss")String keyss);

    /**
     * 查询数据列表，如果需要分页，请设置分页对象，如：entity.setPage(new Page<T>());
     * @param entity
     * @return ActYwGroup
     */
    public List<ActYwGroup> findListByCount(ActYwGroup entity);

    /**
     * 查询记录数.
     * @param actYwGroup
     * @return Long
     */
    public Long findCount(ActYwGroup entity);

}