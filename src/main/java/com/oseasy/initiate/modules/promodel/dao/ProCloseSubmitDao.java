package com.oseasy.initiate.modules.promodel.dao;

import com.oseasy.initiate.modules.promodel.entity.ProCloseSubmit;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

import org.apache.ibatis.annotations.Param;

/**
 * 结项提交信息表DAO接口.
 * @author zy
 * @version 2017-12-01
 */
@MyBatisDao
public interface ProCloseSubmitDao extends CrudDao<ProCloseSubmit> {

	ProCloseSubmit getByGnodeId(@Param("promodelId") String promodelId, @Param("gnodeId") String gnodeId);
}