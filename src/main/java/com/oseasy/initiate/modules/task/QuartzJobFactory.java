package com.oseasy.initiate.modules.task;

import com.oseasy.initiate.modules.task.entity.TaskScheduleJob;
import org.apache.log4j.Logger;
import org.quartz.DisallowConcurrentExecution;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

/**
 * 
 * @Description: 计划任务执行处 无状态job
 */
public class QuartzJobFactory implements Job {
	public final Logger log = Logger.getLogger(this.getClass());

	public void execute(JobExecutionContext context) throws JobExecutionException {
		TaskScheduleJob scheduleJob = (TaskScheduleJob) context.getMergedJobDataMap().get("scheduleJob");
		TaskUtils.invokMethod(scheduleJob);
	}

}