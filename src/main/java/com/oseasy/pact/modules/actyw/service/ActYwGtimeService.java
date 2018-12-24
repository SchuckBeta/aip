package com.oseasy.pact.modules.actyw.service;

import java.text.ParseException;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oseasy.pact.modules.actyw.dao.ActYwGtimeDao;
import com.oseasy.pact.modules.actyw.entity.ActYwGtime;
import com.oseasy.pcore.common.persistence.Page;
import com.oseasy.pcore.common.service.CrudService;
import com.oseasy.putil.common.utils.DateUtil;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 时间和组件关联关系Service.
 * @author zy
 * @version 2017-06-27
 */
@Service
@Transactional(readOnly = true)
public class ActYwGtimeService extends CrudService<ActYwGtimeDao, ActYwGtime> {
	@Autowired
	ActYwGtimeDao actYwGtimeDao;
	public ActYwGtime get(String id) {
		return super.get(id);
	}

	public List<ActYwGtime> findList(ActYwGtime actYwGtime) {
		return super.findList(actYwGtime);
	}

	public Page<ActYwGtime> findPage(Page<ActYwGtime> page, ActYwGtime actYwGtime) {
		return super.findPage(page, actYwGtime);
	}

	@Transactional(readOnly = false)
	public void save(ActYwGtime actYwGtime) {
		try {
			actYwGtime.setBeginDate(DateUtil.getStartDate(actYwGtime.getBeginDate()));
			actYwGtime.setEndDate(DateUtil.getEndDate(actYwGtime.getEndDate()));
		} catch (ParseException e) {
			logger.error(e.getMessage());
		}
		super.save(actYwGtime);
	}

	@Transactional(readOnly = false)
	public void delete(ActYwGtime actYwGtime) {
		super.delete(actYwGtime);
	}

	@Transactional(readOnly = false)
	public void deleteByGroupId(ActYwGtime actYwGtime) {
		actYwGtimeDao.deleteByGroupId(actYwGtime);
	}

	public ActYwGtime getTimeByGnodeId(ActYwGtime actYwGtime) {
		return actYwGtimeDao.getTimeByGnodeId(actYwGtime);
	}

	public ActYwGtime getTimeByYnodeId(String ywId, String gnodeId) {
	    return actYwGtimeDao.getTimeByYnodeId(ywId, gnodeId);
	}

    /**
     * 批量保存.
     * @param gtimes
     */
    @Transactional(readOnly = false)
    public void savePl(List<ActYwGtime> gtimes) {
        dao.savePl(gtimes);
    }

    /**
     * 根据流程批量删除.
     * @param groupId 流程ID
     */
    @Transactional(readOnly = false)
    public void deletePlwlByGroup(String groupId) {
        dao.deletePlwlByGroup(groupId);
    }

    /**
     * 根据流程批量删除.
     * @param groupId 流程ID
     * @param gnodeId 节点ID
     */
    @Transactional(readOnly = false)
    public void deletePlwl(String groupId, String gnodeId) {
        dao.deletePlwl(groupId, gnodeId);
    }

	public void deleteByYear(String projectId, String yearId) {
		dao.deleteYearPlwl(projectId, yearId);
	}

	public String getProByProjectIdAndYear(String relId, String year) {
		String yearId=null;
		List<String> list=actYwGtimeDao.getProByProjectIdAndYear(relId,year);
		if(StringUtil.checkNotEmpty(list)){
			yearId=list.get(0);
		}
		return yearId;
	}

	public List<ActYwGtime> checkTimeByActYw(String actYwId) {
		List<ActYwGtime> list=actYwGtimeDao.checkTimeByActYw(actYwId);
		return list;
	}

	public int checkTimeIndex(String actYwId) {
		return actYwGtimeDao.checkTimeIndex(actYwId);
	}
}