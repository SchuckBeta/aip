package com.oseasy.pact.modules.actyw.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.oseasy.initiate.modules.sys.tool.SysNoType;
import com.oseasy.initiate.modules.sys.tool.SysNodeTool;
import com.oseasy.initiate.modules.sys.utils.UserUtils;
import com.oseasy.pact.modules.actyw.dao.ActYwGroupDao;
import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pact.modules.actyw.entity.ActYwGroup;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowType;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.config.ApiTstatus;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 自定义流程Service.
 * @author chenhao
 * @version 2017-05-23
 */
@Service
@Transactional(readOnly = true)
public class ActYwGroupService extends CrudService<ActYwGroupDao, ActYwGroup> {
@Autowired
  private ActYwService actYwService;
  @Autowired
  private ActYwGnodeService actYwGnodeService;


  public ActYwGroup get(String id) {
    return super.get(id);
  }

  /**
   * 根据唯一标识获取对象.
   * @param keyss 标识值
   * @return List
   */
  public List<ActYwGroup> getByKeyss(String keyss) {
    return dao.getByKeyss(keyss);
  }

  /**
   * 验证唯一标识是否存在.
   * @param keyss 标识值
   * @param isNew 是否新增
   * @return Boolean
   */
  public Boolean validKeyss(String keyss, Boolean isNew) {
    List<ActYwGroup> actYwGroups = getByKeyss(keyss);
    if ((actYwGroups == null) || (actYwGroups.size() <= 0)) {
      return true;
    }

    int size = actYwGroups.size();
    if (!isNew && (size == 1)) {
        return true;
    }
    return false;
  }

  /**
   * 执行findList时调用  findCount 获取总记录数.
   * @param actYwGroup
   * @return
   */
  public Long findCount(ActYwGroup actYwGroup) {
    return dao.findCount(actYwGroup);
  }

  public List<ActYwGroup> findList(ActYwGroup actYwGroup) {
      return super.findList(actYwGroup);
  }

  public Page<ActYwGroup> findPage(Page<ActYwGroup> page, ActYwGroup actYwGroup) {
    return super.findPage(page, actYwGroup);
  }

  public List<ActYwGroup> findListByCount(ActYwGroup entity) {
      return dao.findListByCount(entity);
  }

  public Page<ActYwGroup> findPageByCount(Page<ActYwGroup> page, ActYwGroup entity) {
      entity.setPage(page);
      page.setList(findListByCount(entity));
      return page;
  }

  /**
   * 查询当前所有已发布的流程.
   * @return List
   */
  public List<ActYwGroup> findListByDeploy() {
    ActYwGroup pactYwGroup = new ActYwGroup();
    pactYwGroup.setStatus(ActYwGroup.GROUP_DEPLOY_1);
    pactYwGroup.setDelFlag(Global.NO);
    return super.findList(pactYwGroup);
  }


  /**
   * 根据类型获取已发布流程.
   * 如果类型为空，返回所有已发布流程.
   * @param ftype 排除的ID
   * @return
   */
  public List<ActYwGroup> listData(String ftype) {
    List<ActYwGroup> actYwGroups = Lists.newArrayList();
    if (StringUtil.isEmpty(ftype)) {
      actYwGroups = findListByDeploy();
    }else{
      FlowType flowType = FlowType.getByKey(ftype);
      if (flowType == null) {
        logger.warn("类型参数未定义!");
        return actYwGroups;
      }
      actYwGroups = findListByDeploy(flowType);
    }
    return actYwGroups;
  }
  /**
   * 查询当前所有未发布的流程.
   * @return List
   */
  public List<ActYwGroup> findListByNoDeploy() {
    ActYwGroup pactYwGroup = new ActYwGroup();
    pactYwGroup.setStatus(ActYwGroup.GROUP_DEPLOY_0);
    pactYwGroup.setDelFlag(Global.NO);
    return super.findList(pactYwGroup);
  }

  /**
   * 根据流程类型查询当前已发布的流程.
   * @param flowType 流程类型.
   * @return List
   */
  public List<ActYwGroup> findListByDeploy(FlowType flowType) {
    if (flowType == null) {
      return null;
    }

    ActYwGroup pactYwGroup = new ActYwGroup();
    pactYwGroup.setStatus(ActYwGroup.GROUP_DEPLOY_1);
    pactYwGroup.setDelFlag(Global.NO);
    pactYwGroup.setFlowType(flowType.getKey());
    return super.findList(pactYwGroup);
  }

  /**
   * 根据流程类型查询当前未发布的流程.
   * @param flowType 流程类型.
   * @return List
   */
  public List<ActYwGroup> findListByNoDeploy(FlowType flowType) {
    if (flowType == null) {
      return null;
    }

    ActYwGroup pactYwGroup = new ActYwGroup();
    pactYwGroup.setStatus(ActYwGroup.GROUP_DEPLOY_0);
    pactYwGroup.setDelFlag(Global.NO);
    pactYwGroup.setFlowType(flowType.getKey());
    return super.findList(pactYwGroup);
  }

  @Transactional(readOnly = false)
  public void save(ActYwGroup actYwGroup) {
    if (actYwGroup.getIsNewRecord()) {
      if (actYwGroup.getSort() == null) {
        actYwGroup.setSort(1);
      }
      if (actYwGroup.getAuthor() == null) {
        actYwGroup.setAuthor(UserUtils.getUser().getId() + StringUtil.LINE_M + UserUtils.getUser().getName());
      }
      if (StringUtil.isEmpty(actYwGroup.getStatus())) {
        actYwGroup.setStatus(ActYwGroup.GROUP_DEPLOY_0);
      }
      if ((actYwGroup.getTemp() == null)) {
          actYwGroup.setTemp(true);
      }
      if (StringUtil.isEmpty(actYwGroup.getVersion())) {
        actYwGroup.setVersion(ActYwGroup.GROUP_VERSION);
      }

      if (StringUtil.isEmpty(actYwGroup.getKeyss())) {
        actYwGroup.setKeyss(SysNodeTool.genByKeyss(SysNoType.NO_FLOW));
      }
    }
    if (StringUtil.isNotEmpty(actYwGroup.getFlowType())) {
      actYwGroup.setType(FlowType.getByKey(actYwGroup.getFlowType()).getType().getTypes());
    }
    if (validKeyss(actYwGroup.getKeyss(), actYwGroup.getIsNewRecord())) {
      super.save(actYwGroup);
    }
  }

  /**
   * 删除流程且做依赖校验.
   * 删除自定义流程约束性校验
   * 1,没关联项目，可以删除
   * 2，有关联项目，无法删除
   * @param actYwGroup
   * @return ActYwApiStatus
   */
  @Transactional(readOnly = false)
  public ApiTstatus<ActYwGroup> deleteCheck(ActYwGroup actYwGroup) {
      ApiTstatus<ActYwGroup> rstats = new ApiTstatus<ActYwGroup>();
      try{
        ActYw actYw = new ActYw();
        actYw.setGroupId(actYwGroup.getId());
        List<ActYw> list = actYwService.findList(actYw);
        if(!list.isEmpty()){
          throw new RuntimeException("流程关联了项目，无法删除");
        }

        actYwGnodeService.deletePlwlByGroup(actYwGroup.getId());
        delete(actYwGroup);
        rstats.setMsg("删除成功！");
      }catch (Exception e){
        logger.error(e.getMessage());
        rstats.setStatus(false);
        rstats.setMsg(e.getMessage());
      }
      return rstats;
  }

  @Transactional(readOnly = false)
  public void delete(ActYwGroup actYwGroup) {
      super.delete(actYwGroup);
  }
}