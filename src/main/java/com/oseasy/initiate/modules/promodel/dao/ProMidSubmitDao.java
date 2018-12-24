package com.oseasy.initiate.modules.promodel.dao;

import com.oseasy.initiate.modules.promodel.entity.ProMidSubmit;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

import org.apache.ibatis.annotations.Param;

/**
 * 中期提交信息表DAO接口.
 * @author zy
 * @version 2017-12-01
 */
@MyBatisDao
public interface ProMidSubmitDao extends CrudDao<ProMidSubmit> {

	ProMidSubmit getByGnodeId(@Param("promodelId") String promodelId, @Param("gnodeId") String gnodeId);
}