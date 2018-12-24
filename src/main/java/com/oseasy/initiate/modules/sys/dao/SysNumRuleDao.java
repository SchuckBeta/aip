package com.oseasy.initiate.modules.sys.dao;

import java.util.Map;

import com.oseasy.initiate.modules.sys.entity.SysNumRule;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 编号规则DAO接口
 * @author zdk
 * @version 2017-04-01
 */
@MyBatisDao
public interface SysNumRuleDao extends CrudDao<SysNumRule> {
	public void onEventScheduler(Map<String,Object> param);
	public void dropNumResetEvent(Map<String,Object> param);
	public void createNumResetEvent(Map<String,Object> param);
	public SysNumRule getByType(String type);

	void addSequence(Map<String, Object> param);

	void nextSequence(String seqName);
}