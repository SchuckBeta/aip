package com.oseasy.pact.modules.actyw.tool.project;

import com.oseasy.pact.modules.actyw.entity.ActYw;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowType;
import com.oseasy.pact.modules.actyw.tool.project.impl.ActProProject;
import com.oseasy.pact.modules.actyw.tool.project.impl.ActProScore;

/**
 * Created by Administrator on 2017/7/29 0029.
 */
public class ActProRunner<T extends IActProDeal> {
	private FlowType flowType;
	private T actProDeal;

	public ActProRunner() {}

	public ActProRunner(T actProDeal) {
		this.actProDeal = actProDeal;
	}

	/**
	 * 项目流程操作需要处理的业务步骤.
	 * @param actProParamVo
	 * @return
	 */
	public ActProStatus execute(ActProParamVo actProParamVo) {
		ActProStatus actProStatus = new ActProStatus(actProParamVo);
		actProStatus.setIsIconTrue((actProDeal.requireIcon()) ? actProDeal.dealIcon(actProParamVo) : true);
		actProStatus.setIsTimeTrue((actProDeal.requireTime()) ? actProDeal.dealTime(actProParamVo) : true);
		actProStatus.setIsMenuTrue((actProDeal.requireMenu()) ? actProDeal.dealMenu(actProParamVo) : true);
		actProStatus.setIsCategoryTrue((actProDeal.requireCategory()) ? actProDeal.dealCategory(actProParamVo) : true);

		actProStatus.setIsActYwTrue((actProDeal.requireActYw()) ? actProDeal.dealActYw(actProParamVo) : true);
  	actProStatus.setIsDeployTrue((actProDeal.requireDeploy()) ? actProDeal.dealDeploy(actProParamVo) : true);
		return actProStatus;
	}

	public T getActProDeal() {
		return actProDeal;
	}

	public void setActProDeal(T actProDeal) {
		this.actProDeal = actProDeal;
	}

	public FlowType getFlowType() {
    return flowType;
  }

  public void setFlowType(FlowType flowType) {
    this.flowType = flowType;
  }

  public static void main(String[] args) {
		ActProRunner projectRunner = new ActProRunner(new ActProProject());
		ActProRunner scoreRunner = new ActProRunner(new ActProScore());
		ActYw actYw = new ActYw();
		ActProParamVo actProParamVo =new ActProParamVo();
		actProParamVo.setActYw(actYw);
		projectRunner.execute(actProParamVo);
		scoreRunner.execute(actProParamVo);
	}
}
