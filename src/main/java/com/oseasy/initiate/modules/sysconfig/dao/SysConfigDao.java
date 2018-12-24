package com.oseasy.initiate.modules.sysconfig.dao;

import com.oseasy.initiate.modules.sysconfig.entity.SysConfig;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 系统配置DAO接口.
 * @author 9527
 * @version 2017-10-19
 */
@MyBatisDao
public interface SysConfigDao extends CrudDao<SysConfig> {
	public SysConfig getSysConfig();
}