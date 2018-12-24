package com.oseasy.initiate.modules.sys.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oseasy.initiate.modules.sys.entity.SysCertificate;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 系统证书表DAO接口.
 * @author chenh
 * @version 2017-10-23
 */
@MyBatisDao
public interface SysCertificateDao extends CrudDao<SysCertificate> {

  /**
   * 批量更新使用状态.
   * @param entitys 修改记录（id不能为空）
   * @param hasUse 修改值
   */
  public void updateHasUsePL(@Param("entitys") List<SysCertificate> entitys, @Param("hasUse") Boolean hasUse);

}