package com.oseasy.pact.modules.actyw.tool.project;

import com.oseasy.pact.modules.act.vo.ActApiStatus;
import com.oseasy.pact.modules.actyw.tool.project.impl.StyCategory;
import com.oseasy.pact.modules.actyw.tool.project.impl.StyCategoryRunner;
import com.oseasy.pact.modules.actyw.tool.project.impl.StyDeploy;
import com.oseasy.pact.modules.actyw.tool.project.impl.StyDeployRunner;
import com.oseasy.pact.modules.actyw.tool.project.impl.StyMenu;
import com.oseasy.pact.modules.actyw.tool.project.impl.StyMenu2;
import com.oseasy.pact.modules.actyw.tool.project.impl.StyMenuRunner;

/**
 * 策略执行器.
 */
public interface IStrategyRunner{

  /**
   * 策略方法
   */
  public ActApiStatus gen();

  public static void main(String[] args) {
    System.out.println(new StyMenuRunner<StyMenu>(new StyMenu()).gen().getMsg());
    System.out.println(new StyMenuRunner<StyMenu2>(new StyMenu2()).gen().getMsg());
    System.out.println(new StyCategoryRunner<StyCategory>(new StyCategory()).gen().getMsg());
    System.out.println(new StyDeployRunner<StyDeploy>(new StyDeploy()).gen().getMsg());
  }
}
