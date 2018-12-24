package com.oseasy.initiate.modules.sys.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.initiate.modules.sys.dao.SysNumRuleDao;
import com.oseasy.initiate.modules.sys.entity.SysNumRule;
import com.oseasy.initiate.modules.sys.enums.NumRuleEnum;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;

/**
 * 编号规则Service
 * @author zdk
 * @version 2017-04-01
 */
@Service
@Transactional(readOnly = true)
public class SysNumRuleService extends CrudService<SysNumRuleDao, SysNumRule> {
	
	@Autowired
	private SysNumRuleDao sysNumRuleDao;
	public SysNumRule get(String id) {
		return super.get(id);
	}
	
	public List<SysNumRule> findList(SysNumRule sysNumRule) {
		return super.findList(sysNumRule);
	}
	
	public Page<SysNumRule> findPage(Page<SysNumRule> page, SysNumRule sysNumRule) {
		return super.findPage(page, sysNumRule);
	}
	
	public SysNumRule getByType(String type) {
		return sysNumRuleDao.getByType(type);
		
	}
	
	@Transactional(readOnly = false)
	public void save(SysNumRule sysNumRule) {
		StringBuffer sbBuffer = new StringBuffer();
		if (sysNumRule.getYear()!=null&&sysNumRule.getYear().equals("on")) {
			sbBuffer.append("yyyy");
		}
		if (sysNumRule.getMonth()!=null&&sysNumRule.getMonth().equals("on")) {
			sbBuffer.append("MM");
		}
		if (sysNumRule.getDay()!=null&&sysNumRule.getDay().equals("on")) {
			sbBuffer.append("dd");
		}
		//sbBuffer = sbBuffer.append(sysNumRule.getYear()+sysNumRule.getMonth()+sysNumRule.getDay());
		sysNumRule.setDateFormat(sbBuffer.toString());
		StringBuffer sbBuffer1 = new StringBuffer();
		if (sysNumRule.getHour()!=null&&sysNumRule.getHour().equals("on")) {
			sbBuffer1.append("HH");
		}
		if (sysNumRule.getMinute()!=null&&sysNumRule.getMinute().equals("on")) {
			sbBuffer1.append("mm");
		}
		if (sysNumRule.getSecond()!=null&&sysNumRule.getSecond().equals("on")) {
			sbBuffer1.append("ss");
		}
		//sbBuffer1 = sbBuffer1.append(sysNumRule.getHour()+sysNumRule.getMinute()+sysNumRule.getSecond());
		sysNumRule.setTimieFormat(sbBuffer1.toString());
		super.save(sysNumRule);
		/*根据起始编号修改编号重置事件*/
		NumRuleEnum nr=NumRuleEnum.getEnumByValue(sysNumRule.getType());
		if (nr!=null) {
			Map<String,Object> param=new HashMap<String,Object>();
			param.put("event", nr.getEvent());
			param.put("seq", nr.getSeq());
			param.put("num", Integer.parseInt(sysNumRule.getStartNum()));
			dao.onEventScheduler(param);
			dao.dropNumResetEvent(param);
			dao.createNumResetEvent(param);
		}
		/*根据起始编号修改编号重置事件*/
	}
	
	@Transactional(readOnly = false)
	public void delete(SysNumRule sysNumRule) {
		super.delete(sysNumRule);
	}
	
}