package com.oseasy.initiate.modules.sys.dao;

import com.oseasy.initiate.modules.sys.entity.SysNo;
import com.oseasy.initiate.modules.sys.entity.SysNoOffice;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 系统机构编号DAO接口.
 * @author chenhao
 * @version 2017-07-17
 */
@MyBatisDao
public interface SysNoOfficeDao extends CrudDao<SysNoOffice> {
  /**
   * 根据唯一标识获取编号对象.
   * @param key 唯一标识
   * @return SysNo 系统编号.
   */
  public SysNoOffice getByKeyss(String key, String officeId);
}