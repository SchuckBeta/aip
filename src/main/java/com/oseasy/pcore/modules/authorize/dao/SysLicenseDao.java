package com.oseasy.pcore.modules.authorize.dao;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.pcore.modules.authorize.entity.SysLicense;

/**
 * 授权信息DAO接口
 * @author 9527
 * @version 2017-04-13
 */
@MyBatisDao
public interface SysLicenseDao extends CrudDao<SysLicense> {
	public void insertWithId(SysLicense s);
}