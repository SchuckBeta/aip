package com.oseasy.initiate.modules.sys.dao;

import com.oseasy.initiate.modules.sys.entity.SysNo;
import com.oseasy.initiate.modules.sys.entity.SysNumRule;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 系统全局编号DAO接口.
 * @author chenhao
 * @version 2017-07-17
 */
@MyBatisDao
public interface SysNoDao extends CrudDao<SysNo> {
  /**
   * 根据唯一标识获取编号对象.
   * @param key 唯一标识
   * @return SysNo
   */
  public SysNo getByKeyss(String key);
}