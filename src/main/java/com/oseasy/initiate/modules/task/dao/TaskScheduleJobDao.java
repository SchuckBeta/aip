package com.oseasy.initiate.modules.task.dao;

import com.oseasy.initiate.modules.task.entity.TaskScheduleJob;
import com.oseasy.pcore.common.persistence.CrudDao;
import com.oseasy.pcore.common.persistence.annotation.MyBatisDao;

import java.util.List;
@MyBatisDao
public interface TaskScheduleJobDao /*extends CrudDao<TaskScheduleJob> */{
	int deleteByPrimaryKey(Long jobId);

	int insert(TaskScheduleJob record);

	int insertSelective(TaskScheduleJob record);

	TaskScheduleJob selectByPrimaryKey(Long jobId);

	int updateByPrimaryKeySelective(TaskScheduleJob record);

	int updateByPrimaryKey(TaskScheduleJob record);

	List<TaskScheduleJob> getAll();
}