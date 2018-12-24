package com.oseasy.pact.modules.actyw.tool.project.impl;

import com.oseasy.pact.modules.act.vo.ActApiStatus;
import com.oseasy.pact.modules.actyw.tool.project.IStrategy;

/**
 * 栏目生成策略.
 */
public class StyCategory implements IStrategy{

  @Override
  public ActApiStatus deal() {
    return new ActApiStatus(true, "StyCategory1 方案执行处理完成了！");
  }
}
