/**
 * 
 */
package com.oseasy.pcore.modules.sys.dao;

import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;
import com.oseasy.pcore.modules.sys.entity.Log;

/**
 * 日志DAO接口

 * @version 2014-05-16
 */
@MyBatisDao
public interface LogDao extends CrudDao<Log> {

}
