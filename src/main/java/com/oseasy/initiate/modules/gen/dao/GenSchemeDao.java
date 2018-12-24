/**
 *
 */
package com.oseasy.initiate.modules.gen.dao;

import java.util.List;

import com.oseasy.initiate.modules.gen.entity.GenScheme;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 生成方案DAO接口


 */
@MyBatisDao
public interface GenSchemeDao extends CrudDao<GenScheme> {


    /**
     * 查询数据列表，如果需要分页，请设置分页对象，如：entity.setPage(new Page<T>());
     * @param entity
     * @return
     */
    public List<GenScheme> findClass(GenScheme entity);
}
