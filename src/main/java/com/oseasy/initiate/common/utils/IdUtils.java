/**
 * Copyright (c) 2005-2012 springside.org.cn
 */
package com.oseasy.initiate.common.utils;

import org.springframework.jdbc.support.incrementer.DataFieldMaxValueIncrementer;
import org.springframework.web.context.ContextLoader;

import com.oseasy.initiate.modules.sys.dao.SysNumRuleDao;
import com.oseasy.initiate.modules.sys.entity.SysNumRule;
import com.oseasy.initiate.modules.sys.enums.NumRuleEnum;
import com.oseasy.putil.common.utils.DateUtil;
import com.oseasy.putil.common.utils.StringUtil;

import org.apache.log4j.Logger;
/**
 * 封装根据指定规则生成编号
 * eg：ZZ  20170309 111111  00012  AA
 */
public class IdUtils {
	protected static DataFieldMaxValueIncrementer teamNumGenarater=(DataFieldMaxValueIncrementer)ContextLoader.getCurrentWebApplicationContext().getBean("teamNumGenarater");
	protected static DataFieldMaxValueIncrementer dictNumGenarater=(DataFieldMaxValueIncrementer)ContextLoader.getCurrentWebApplicationContext().getBean("dictNumGenarater");
	protected static DataFieldMaxValueIncrementer projectDeclareIdGenarater=(DataFieldMaxValueIncrementer)ContextLoader.getCurrentWebApplicationContext().getBean("projectDeclareIdGenarater");
	protected static DataFieldMaxValueIncrementer gContestIdGenarater=(DataFieldMaxValueIncrementer)ContextLoader.getCurrentWebApplicationContext().getBean("gContestIdGenarater");
	protected static SysNumRuleDao sysNumRuleDao=(SysNumRuleDao)ContextLoader.getCurrentWebApplicationContext().getBean("sysNumRuleDao");
	public final static Logger logger = Logger.getLogger(IdUtils.class);
    public static String getProjectNumberByDb() {
    	StringBuffer res = new StringBuffer("");
    	SysNumRule sr=sysNumRuleDao.getByType(NumRuleEnum.PROJECT.getValue());
    	try {
			if (StringUtil.isNotEmpty(sr.getPrefix()))res.append(sr.getPrefix());
			if (StringUtil.isNotEmpty(sr.getDateFormat()))res.append(DateUtil.getDate(sr.getDateFormat()));
			if (StringUtil.isNotEmpty(sr.getTimieFormat()))res.append(DateUtil.getDate(sr.getTimieFormat()));
			int numLength=Integer.parseInt(sr.getNumLength());//检验格式
			int next=projectDeclareIdGenarater.nextIntValue();
			if (String.valueOf(next).length()>numLength) {
				res.append(next);
			}else{
				res.append(String.format("%0"+sr.getNumLength()+"d", next));
			}
			if (sr.getSuffix()!=null)res.append(sr.getSuffix());
		} catch (Exception e) {
			res = new StringBuffer("");
			res.append(DateUtil.getDate("yyyyMMddHHmmss")).append(String.format("%06d", projectDeclareIdGenarater.nextIntValue()));
			//logger.error("无效的项目编号规则", e);
		}
    	return res.toString();
    }
    public static String getGContestNumberByDb() {
    	StringBuffer res = new StringBuffer("");
    	SysNumRule sr=sysNumRuleDao.getByType(NumRuleEnum.GCONTEST.getValue());
    	try {
			if (StringUtil.isNotEmpty(sr.getPrefix()))res.append(sr.getPrefix());
			if (StringUtil.isNotEmpty(sr.getDateFormat()))res.append(DateUtil.getDate(sr.getDateFormat()));
			if (StringUtil.isNotEmpty(sr.getTimieFormat()))res.append(DateUtil.getDate(sr.getTimieFormat()));
			int numLength=Integer.parseInt(sr.getNumLength());//检验格式
			int next=gContestIdGenarater.nextIntValue();
			if (String.valueOf(next).length()>numLength) {
				res.append(next);
			}else{
				res.append(String.format("%0"+sr.getNumLength()+"d", next));
			}
			if (sr.getSuffix()!=null)res.append(sr.getSuffix());
		} catch (Exception e) {
			res = new StringBuffer("");
			res.append(DateUtil.getDate("yyyyMMddHHmmss")).append(String.format("%06d", gContestIdGenarater.nextIntValue()));
			//logger.error("无效的大赛编号规则", e);
		}
    	return res.toString();
    }
    public static String getTeamNumberByDb() {
    	StringBuffer res = new StringBuffer("");
    	SysNumRule sr=sysNumRuleDao.getByType(NumRuleEnum.TEAM.getValue());
    	if(sr != null){
        	try {
    			if (StringUtil.isNotEmpty(sr.getPrefix()))res.append(sr.getPrefix());
    			if (StringUtil.isNotEmpty(sr.getDateFormat()))res.append(DateUtil.getDate(sr.getDateFormat()));
    			if (StringUtil.isNotEmpty(sr.getTimieFormat()))res.append(DateUtil.getDate(sr.getTimieFormat()));
    			int numLength=Integer.parseInt(sr.getNumLength());//检验格式
    			int next=teamNumGenarater.nextIntValue();
    			if (String.valueOf(next).length()>numLength) {
    				res.append(next);
    			}else{
    				res.append(String.format("%0"+sr.getNumLength()+"d", next));
    			}
    			if (sr.getSuffix()!=null)res.append(sr.getSuffix());
    		} catch (Exception e) {
    			res = new StringBuffer("");
    			res.append(DateUtil.getDate("yyyyMMddHHmmss")).append(String.format("%06d", teamNumGenarater.nextIntValue()));
    			logger.error("无效的团队编号规则", e);
    		}
        }else{
            res = new StringBuffer("");
            res.append(DateUtil.getDate("yyyyMMddHHmmss")).append(String.format("%06d", teamNumGenarater.nextIntValue()));
        }
    	return res.toString();
    }
    public static String getDictNumberByDb() {
    	return String.format("%010d", dictNumGenarater.nextIntValue());
    }
}
