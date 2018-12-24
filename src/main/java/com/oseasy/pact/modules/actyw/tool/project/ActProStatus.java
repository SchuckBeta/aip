package com.oseasy.pact.modules.actyw.tool.project;

public class ActProStatus {
  private Boolean isIconTrue;
  private Boolean isTimeTrue;
  private Boolean isMenuTrue;
  private Boolean isCategoryTrue;
  private Boolean isActYwTrue;
  private Boolean isDeployTrue;
  private ActProParamVo actProParamVo;

  public ActProStatus() {
    super();
    this.isIconTrue = false;
    this.isTimeTrue = false;
    this.isMenuTrue = false;
    this.isCategoryTrue = false;
    this.isActYwTrue = false;
    this.isDeployTrue = false;
    this.actProParamVo = null;
  }

  public ActProStatus(ActProParamVo actProParamVo) {
    super();
    this.isIconTrue = false;
    this.isTimeTrue = false;
    this.isMenuTrue = false;
    this.isCategoryTrue = false;
    this.isActYwTrue = false;
    this.isDeployTrue = false;
    this.actProParamVo = actProParamVo;
  }

  public ActProStatus(Boolean isIconTrue, Boolean isTimeTrue, Boolean isMenuTrue,
      Boolean isCategoryTrue, Boolean isActYwTrue, Boolean isDeployTrue, ActProParamVo actProParamVo) {
    super();
    this.isIconTrue = isIconTrue;
    this.isTimeTrue = isTimeTrue;
    this.isMenuTrue = isMenuTrue;
    this.isCategoryTrue = isCategoryTrue;
    this.isActYwTrue = isActYwTrue;
    this.isDeployTrue = isDeployTrue;
    this.actProParamVo = actProParamVo;
  }

  public Boolean getIsActYwTrue() {
    return isActYwTrue;
  }

  public void setIsActYwTrue(Boolean isActYwTrue) {
    this.isActYwTrue = isActYwTrue;
  }

  public Boolean getIsDeployTrue() {
    return isDeployTrue;
  }

  public void setIsDeployTrue(Boolean isDeployTrue) {
    this.isDeployTrue = isDeployTrue;
  }

  public Boolean getIsIconTrue() {
    return isIconTrue;
  }
  public void setIsIconTrue(Boolean isIconTrue) {
    this.isIconTrue = isIconTrue;
  }
  public Boolean getIsTimeTrue() {
    return isTimeTrue;
  }
  public void setIsTimeTrue(Boolean isTimeTrue) {
    this.isTimeTrue = isTimeTrue;
  }
  public Boolean getIsMenuTrue() {
    return isMenuTrue;
  }
  public void setIsMenuTrue(Boolean isMenuTrue) {
    this.isMenuTrue = isMenuTrue;
  }
  public Boolean getIsCategoryTrue() {
    return isCategoryTrue;
  }
  public void setIsCategoryTrue(Boolean isCategoryTrue) {
    this.isCategoryTrue = isCategoryTrue;
  }
  public ActProParamVo getActProParamVo() {
    return actProParamVo;
  }
  public void setActProParamVo(ActProParamVo actProParamVo) {
    this.actProParamVo = actProParamVo;
  }

  /**
   * 检验项目是否完全执行成功.
   * true 表示执行成功.
   * false 表示执行失败.
   * @param actProStatus 执行状态对象
   * @return Boolean;
   */
  public static Boolean validateTrue(ActProStatus actProStatus) {
    return (actProStatus.getIsIconTrue() && actProStatus.getIsTimeTrue() && actProStatus.getIsCategoryTrue() && actProStatus.getIsMenuTrue() && actProStatus.getIsActYwTrue() && actProStatus.getIsDeployTrue());
  }
}
