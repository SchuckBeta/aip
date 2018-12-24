package com.oseasy.pact.modules.actyw.tool.project.impl;

import org.springframework.transaction.annotation.Transactional;

import com.oseasy.initiate.common.config.SysIds;
import com.oseasy.pact.modules.actyw.tool.project.ActProParamVo;
import com.oseasy.pact.modules.actyw.tool.project.IActProDeal;
import com.oseasy.pcore.common.utils.SpringContextHolder;

/**
 * Created by Administrator on 2017/7/29 0029.
 */
//预约栏目和菜单创建
public class ActProAppointment implements IActProDeal {
//
 	ActProUtil actProUtil = (ActProUtil) SpringContextHolder.getBean(ActProUtil.class);

	@Override
	@Transactional(readOnly = false)
	public Boolean dealMenu(ActProParamVo actProParamVo) {
//		return actProUtil.dealMenu1(actProParamVo, SysIds.SITE_PW_APPOINTMENT_ROOT.getId());
		return true;
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean dealCategory(ActProParamVo actProParamVo) {
		//return actProUtil.dealCategory(actProParamVo, SysIds.SITE_CATEGORYS_PROJECT_ROOT.getId(), "");
		return true;
	}

	@Override
	public Boolean dealTime(ActProParamVo actProParamVo) {
		return true;
	}

	@Override
	public Boolean dealIcon(ActProParamVo actProParamVo) {
		return true;
	}

	@Override
	public Boolean dealActYw(ActProParamVo actProParamVo) {
		return true;
	}

	@Override
	public Boolean dealDeploy(ActProParamVo actProParamVo) {
		return true;
	}

	@Override
	public Boolean requireMenu() {
		return true;
	}

	@Override
	public Boolean requireCategory() {
		return true;
	}

	@Override
	public Boolean requireTime() {
		return true;
	}

	@Override
	public Boolean requireIcon() {
		return true;
	}

	@Override
	public Boolean requireActYw() {
		return true;
	}

	@Override
	public Boolean requireDeploy() {
		return true;
	}
}
