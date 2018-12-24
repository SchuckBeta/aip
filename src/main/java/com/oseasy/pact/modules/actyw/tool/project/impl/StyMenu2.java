package com.oseasy.pact.modules.actyw.tool.project.impl;

import com.oseasy.pact.modules.act.vo.ActApiStatus;
import com.oseasy.pact.modules.actyw.tool.project.IStrategy;

/**
 * 菜单生成策略.
 */
public class StyMenu2 implements IStrategy{

  @Override
  public ActApiStatus deal() {

    return new ActApiStatus(true, "StyMenu2 方案执行处理完成了！");
  }
}
