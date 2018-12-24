package com.oseasy.pact.modules.actyw.tool.apply.vo;

/**
 * 节点审核结果返回状态.
 * @author chenhao
 */
public class SuApiStatus{
  /**
   * 流程节点标识.
   */
  private String gnodeId;
  /**
   * 审核状态.
   */
  private Boolean status;
  /**
   * 审核状态值.
   */
  private SuStatus rtVal;

  public SuApiStatus() {
    super();
  }

  public SuApiStatus(String gnodeId, Boolean status, SuStatus rtVal) {
    super();
    this.gnodeId = gnodeId;
    this.status = status;
    this.rtVal = rtVal;
  }

  public String getGnodeId() {
    return gnodeId;
  }
  public void setGnodeId(String gnodeId) {
    this.gnodeId = gnodeId;
  }
  public Boolean getStatus() {
    return status;
  }
  public void setStatus(Boolean status) {
    this.status = status;
  }

  public SuStatus getRtVal() {
    return rtVal;
  }

  public void setRtVal(SuStatus rtVal) {
    this.rtVal = rtVal;
  }
}
