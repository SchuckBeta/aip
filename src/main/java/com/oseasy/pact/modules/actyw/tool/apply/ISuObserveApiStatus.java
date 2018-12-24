package com.oseasy.pact.modules.actyw.tool.apply;

import java.util.List;

import com.oseasy.pact.modules.actyw.tool.apply.vo.SuStatusGrade;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowType;

/**
 * 订阅对象-获取状态.
 * @author chenhao
 */
public abstract class ISuObserveApiStatus implements ISuObserver{
  public String id;//流程实例ID
  public FlowType flowType;//流程类型

  public ISuObserveApiStatus(FlowType flowType, String id) {
    super();
    this.flowType = flowType;
    this.id = id;
  }

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public FlowType getFlowType() {
    return flowType;
  }

  public void setFlowType(FlowType flowType) {
    this.flowType = flowType;
  }

  /**
   * 获取流程当前审核节点状态.
   */
  public abstract List<SuStatusGrade> getStatus();
}
