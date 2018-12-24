/**
 * 
 */
package com.oseasy.pact.modules.act.dao;

import com.oseasy.pact.modules.act.entity.Act;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

/**
 * 审批DAO接口
 * @author oseasy
 * @version 2014-05-16
 */
@MyBatisDao
public interface ActDao extends CrudDao<Act> {

	public int updateProcInsIdByBusinessId(Act act);
	
}
