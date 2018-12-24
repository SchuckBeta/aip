package com.oseasy.pact.modules.actyw.tool.project;

import com.oseasy.pact.modules.act.vo.ActApiStatus;

/**
 * 流程处理生成策略.
 * @author chenhao
 *
 */
public interface IStrategy {
  /**
   * 策略方法
   */
  public ActApiStatus deal();
}
