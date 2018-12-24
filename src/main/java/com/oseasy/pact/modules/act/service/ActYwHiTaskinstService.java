package com.oseasy.pact.modules.act.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pact.modules.act.dao.ActYwHiTaskinstDao;
import com.oseasy.pact.modules.act.entity.ActYwHiTaskinst;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;

/**
 * 流程历史任务Service.
 *
 * @author chenhao
 * @version 2017-06-08
 */
@Service
@Transactional(readOnly = true)
public class ActYwHiTaskinstService extends CrudService<ActYwHiTaskinstDao, ActYwHiTaskinst> {

  public ActYwHiTaskinst get(String id) {
    return super.get(id);
  }

  public List<ActYwHiTaskinst> findList(ActYwHiTaskinst actYwHiTaskinst) {
    return super.findList(actYwHiTaskinst);
  }

  public Page<ActYwHiTaskinst> findPage(Page<ActYwHiTaskinst> page,
      ActYwHiTaskinst actYwHiTaskinst) {
    return super.findPage(page, actYwHiTaskinst);
  }

  @Transactional(readOnly = false)
  public void save(ActYwHiTaskinst actYwHiTaskinst) {
    super.save(actYwHiTaskinst);
  }

  @Transactional(readOnly = false)
  public void delete(ActYwHiTaskinst actYwHiTaskinst) {
    super.delete(actYwHiTaskinst);
  }

}