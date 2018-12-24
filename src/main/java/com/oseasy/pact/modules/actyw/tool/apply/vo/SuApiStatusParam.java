package com.oseasy.pact.modules.actyw.tool.apply.vo;

import java.util.List;

import com.oseasy.pact.modules.actyw.tool.apply.IApiStatus;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowType;

/**
 * 节点审核结果返回状态.
 * @author chenhao
 */
public class SuApiStatusParam implements IApiStatus{
  /**
   * 监听者标识.
   */
  private String key;
  /**
   * 流程标识.
   */
  private FlowType flowType;
  private List<SuApiStatus> status;

  public SuApiStatusParam() {
    super();
  }

  public SuApiStatusParam(String key, FlowType flowType, List<SuApiStatus> status) {
    super();
    this.key = key;
    this.flowType = flowType;
    this.status = status;
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
  public List<SuApiStatus> getStatus() {
    return status;
  }
  public void setStatus(List<SuApiStatus> status) {
    this.status = status;
  }
}
