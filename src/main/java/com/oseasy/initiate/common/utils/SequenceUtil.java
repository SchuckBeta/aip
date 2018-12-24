package com.oseasy.initiate.common.utils;

import com.oseasy.initiate.modules.sys.dao.SysNumRuleDao;
import org.springframework.web.context.ContextLoader;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Administrator on 2018/9/14 0014.
 */
public class SequenceUtil {
	protected static SysNumRuleDao sysNumRuleDao=(SysNumRuleDao) ContextLoader.getCurrentWebApplicationContext().getBean("sysNumRuleDao");

	public void addSequence(String seqName,int startNum,int updateNum) {
		Map<String,Object> param=new HashMap<String,Object>();
		param.put("seqName",seqName);
		param.put("startNum", startNum);
		param.put("updateNum", updateNum);
		sysNumRuleDao.addSequence(param);
	}
}
