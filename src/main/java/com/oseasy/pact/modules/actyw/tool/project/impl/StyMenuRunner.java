package com.oseasy.pact.modules.actyw.tool.project.impl;

import com.oseasy.pact.modules.act.vo.ActApiStatus;
import com.oseasy.pact.modules.actyw.tool.project.IStrategy;
import com.oseasy.pact.modules.actyw.tool.project.IStrategyRunner;

/**
 * 菜单策略执行器.
 * @author chenhao
 * @param <T>
 */
public class StyMenuRunner<T extends IStrategy> implements IStrategyRunner{
  //持有一个具体策略的对象
  private T strategy;

  public StyMenuRunner(T strategy) {
    super();
    this.strategy = strategy;
  }

  @Override
  public ActApiStatus gen() {
    return strategy.deal();
  }
}
