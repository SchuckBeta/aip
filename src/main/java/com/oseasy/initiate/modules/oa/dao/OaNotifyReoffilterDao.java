package com.oseasy.initiate.modules.oa.dao;

import com.oseasy.initiate.modules.oa.entity.OaNotify;
import com.oseasy.initiate.modules.oa.entity.OaNotifyReoffilter;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 院系通知过滤DAO接口.
 * @author chenhao
 * @version 2018-08-16
 */
@MyBatisDao
public interface OaNotifyReoffilterDao extends CrudDao<OaNotifyReoffilter> {

  /**
   * 物理删除.
   * @param entity
   */
  public void deleteWL(OaNotifyReoffilter oaNotifyReoffilter);

/**
 * .
 * @param oaNotifyReoffilter
 */
public void updateReadOperateFlag(OaNotifyReoffilter oaNotifyReoffilter);

/**
 * .
 * @param oaNotifyReoffilter
 */
public void updateOperateFlag(OaNotifyReoffilter oaNotifyReoffilter);

/**
 * .
 * @param oaNotifyReoffilter
 */
public void updateReadFlag(OaNotifyReoffilter oaNotifyReoffilter);

/**
 * .
 * @param oaNotify
 * @return
 */
public OaNotifyReoffilter getByNidAndUser(OaNotifyReoffilter oaNotify);
}