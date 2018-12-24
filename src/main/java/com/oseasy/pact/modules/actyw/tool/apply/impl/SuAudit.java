package com.oseasy.pact.modules.actyw.tool.apply.impl;

import java.util.List;

import com.google.common.collect.Lists;
import com.oseasy.pact.modules.actyw.tool.apply.ISuObserverAudit;
import com.oseasy.pact.modules.actyw.tool.apply.ISubject;
import com.oseasy.pact.modules.actyw.tool.apply.vo.SuApiStatus;
import com.oseasy.pact.modules.actyw.tool.apply.vo.SuApiStatusParam;
import com.oseasy.pact.modules.actyw.tool.apply.vo.SuStatusAparam;
import com.oseasy.pact.modules.actyw.tool.apply.vo.SuStatusParam;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowType;

/**
 * 审核主题-入驻.
 * @author chenhao
 *
 */
public class SuAudit implements ISubject<ISuObserverAudit, SuApiStatusParam> {
  /**
   * 用来存放和记录观察者.
   */
  private List<ISuObserverAudit> suObservers = Lists.newArrayList();

  /**
   * 记录订阅执行状态.
   */
  private String key;
  private FlowType flowType;
  private SuStatusAparam aparam;
  private List<SuApiStatusParam> suApiStatus;

  @Override
  public void add(ISuObserverAudit sobj) {
    suObservers.add(sobj);
  }

  @Override
  public void delete(ISuObserverAudit sobj) {
    suObservers.remove(sobj);
  }

  @Override
  public List<SuApiStatusParam> notifys() {
    this.suApiStatus = Lists.newArrayList();
    for (ISuObserverAudit isuObserver : suObservers) {
//      SuApiStatusParam suStatusParam = isuObserver.audit(aparam);
//      if (suStatusParam != null) {
//
//        return new SuApiStatusParam(aparam.getKey(), this.flowType, ssParam.getStatus());
//        suApiStatus.add(isuObserver.audit(aparam));
//      }
    }
    return suApiStatus;
  }

  /**
   * 获取所有审核结果.
   * @param aparam 审核参数
   * @return List
   */
  public List<SuApiStatusParam> dealAuditss(SuStatusAparam aparam) {
    this.aparam = aparam;
    /**
     * TOTD 公共审核业务.
     */
    return this.notifys();
  }

  /**
   * 获取所有审核结果.
   * @param aparam 审核参数
   * @param key 监听者标识.
   * @param flowType 流程标识.
   * @return List
   */
  public SuApiStatusParam dealAudits(SuStatusAparam aparam, String key, FlowType flowType) {
    this.key = key;
    this.flowType = flowType;
    this.aparam = aparam;
    /**
     * TOTD 公共审核业务.
     */
    for (SuApiStatusParam suRstatuParm : this.notifys()) {
      if ((suRstatuParm.getKey()).equals(key) && (suRstatuParm.getFlowType()).equals(flowType)) {
        return suRstatuParm;
      }
    }
    return null;
  }

  /**
   * 获取所有审核结果.
   * @param aparam 审核参数
   * @param key 监听者标识.
   * @param flowType 流程标识.
   * @return List
   */
  public SuApiStatus dealAudit(SuStatusAparam aparam, String key, FlowType flowType) {
    this.key = key;
    this.flowType = flowType;
    this.aparam = aparam;
    /**
     * TOTD 公共审核业务.
     */
    for (SuApiStatusParam suRstatuParm : this.notifys()) {
      if ((suRstatuParm.getKey()).equals(key) && (suRstatuParm.getFlowType()).equals(flowType)) {
        for (SuApiStatus suRstatu : suRstatuParm.getStatus()) {
          if ((suRstatu.getGnodeId()).equals(aparam.getGnodeId())) {
            return suRstatu;
          }
        }
      }
    }
    return null;
  }

  public String getKey() {
    return key;
  }

  public void setKey(String key) {
    this.key = key;
  }

  public FlowType getFlowType() {
    return flowType;
  }

  public void setFlowType(FlowType flowType) {
    this.flowType = flowType;
  }

  public SuStatusAparam getAparam() {
    return aparam;
  }

  public void setAparam(SuStatusAparam aparam) {
    this.aparam = aparam;
  }
}
