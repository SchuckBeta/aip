package com.oseasy.pact.modules.actyw.tool.project.impl;

import com.oseasy.pact.modules.act.vo.ActApiStatus;
import com.oseasy.pact.modules.actyw.tool.project.IStrategy;

/**
 * 流程部署策略.
 */
public class StyDeploy implements IStrategy{

  @Override
  public ActApiStatus deal() {
    return new ActApiStatus(true, "StyDeploy1 方案执行处理完成了！");
  }
}
