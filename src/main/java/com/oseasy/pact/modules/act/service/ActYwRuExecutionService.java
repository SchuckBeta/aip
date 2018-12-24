package com.oseasy.pact.modules.act.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pact.modules.act.dao.ActYwRuExecutionDao;
import com.oseasy.pact.modules.act.entity.ActYwRuExecution;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;

/**
 * 流程运行实例Service.
 *
 * @author chenhao
 * @version 2017-06-08
 */
@Service
@Transactional(readOnly = true)
public class ActYwRuExecutionService extends CrudService<ActYwRuExecutionDao, ActYwRuExecution> {

  public ActYwRuExecution get(String id) {
    return super.get(id);
  }

  public List<ActYwRuExecution> findList(ActYwRuExecution actYwRuExecution) {
    return super.findList(actYwRuExecution);
  }

  public Page<ActYwRuExecution> findPage(Page<ActYwRuExecution> page,
      ActYwRuExecution actYwRuExecution) {
    return super.findPage(page, actYwRuExecution);
  }

  @Transactional(readOnly = false)
  public void save(ActYwRuExecution actYwRuExecution) {
    super.save(actYwRuExecution);
  }

  @Transactional(readOnly = false)
  public void delete(ActYwRuExecution actYwRuExecution) {
    super.delete(actYwRuExecution);
  }

}