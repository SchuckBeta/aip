package com.oseasy.pact.modules.act.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pact.modules.act.dao.ActYwHiProcinstDao;
import com.oseasy.pact.modules.act.entity.ActYwHiProcinst;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;

/**
 * 流程历史实例Service.
 *
 * @author chenhao
 * @version 2017-06-08
 */
@Service
@Transactional(readOnly = true)
public class ActYwHiProcinstService extends CrudService<ActYwHiProcinstDao, ActYwHiProcinst> {

  public ActYwHiProcinst get(String id) {
    return super.get(id);
  }

  public List<ActYwHiProcinst> findList(ActYwHiProcinst actYwHiProcinst) {
    return super.findList(actYwHiProcinst);
  }

  public Page<ActYwHiProcinst> findPage(Page<ActYwHiProcinst> page,
      ActYwHiProcinst actYwHiProcinst) {
    return super.findPage(page, actYwHiProcinst);
  }

  @Transactional(readOnly = false)
  public void save(ActYwHiProcinst actYwHiProcinst) {
    super.save(actYwHiProcinst);
  }

  @Transactional(readOnly = false)
  public void delete(ActYwHiProcinst actYwHiProcinst) {
    super.delete(actYwHiProcinst);
  }

}