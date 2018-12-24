package com.oseasy.initiate.modules.task.web;

import com.oseasy.initiate.modules.task.entity.TaskScheduleJob;
import com.oseasy.initiate.modules.task.service.TaskScheduleJobService;
import com.oseasy.initiate.modules.task.support.RetObj;
import com.oseasy.initiate.modules.task.support.spring.SpringUtils;
import com.oseasy.pcore.common.web.BaseController;
import com.oseasy.putil.common.utils.exception.ExceptionUtil;

import org.apache.commons.lang.StringUtils;
import org.quartz.CronScheduleBuilder;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Method;
import java.util.List;

/**
 * 动态添加任务Controller.
 *
 * @author zhangchuansheng
 * @version 2017-12-05
 */
@Controller
@RequestMapping(value = "${adminPath}/task")
public class TaskScheduleJobController extends BaseController {

    @Autowired
    private TaskScheduleJobService taskScheduleJobService;

    @RequestMapping(value = {"list", ""})
    public String list(TaskScheduleJob taskScheduleJob, HttpServletRequest request, HttpServletResponse response, Model model) {
        List<TaskScheduleJob> taskList = taskScheduleJobService.getAllTask();
        request.setAttribute("taskList", taskList);
        return "modules/task/taskList";
    }

    @RequestMapping("add")
    @ResponseBody
    public RetObj taskList(HttpServletRequest request, TaskScheduleJob scheduleJob) {
        RetObj retObj = new RetObj();
        retObj.setFlag(false);
        try {
            CronScheduleBuilder scheduleBuilder = CronScheduleBuilder.cronSchedule(scheduleJob.getCronExpression());
        } catch (Exception e) {
            retObj.setMsg("cron表达式有误，不能被解析！");
            return retObj;
        }
        Object obj = null;
        try {
            if (StringUtils.isNotBlank(scheduleJob.getSpringId())) {
                obj = SpringUtils.getBean(scheduleJob.getSpringId());
                //TODO  可以根据类型获取
            } else {
                Class clazz = Class.forName(scheduleJob.getBeanClass());
                obj = clazz.newInstance();
            }
        } catch (Exception e) {
            logger.error(ExceptionUtil.getStackTrace(e));
        }
        if (obj == null) {
            retObj.setMsg("未找到目标类！");
            return retObj;
        } else {
            Class clazz = obj.getClass();
            Method method = null;
            try {
                method = clazz.getMethod(scheduleJob.getMethodName(), null);
            } catch (Exception e) {
                logger.error(ExceptionUtil.getStackTrace(e));
            }
            if (method == null) {
                retObj.setMsg("未找到目标方法！");
                return retObj;
            }
        }
        try {
            taskScheduleJobService.addTask(scheduleJob);
        } catch (Exception e) {
            logger.error(ExceptionUtil.getStackTrace(e));
            retObj.setFlag(false);
            retObj.setMsg("保存失败，检查 name group 组合是否有重复！");
            return retObj;
        }

        retObj.setFlag(true);
        return retObj;
    }

    @RequestMapping("changeJobStatus")
    @ResponseBody
    public RetObj changeJobStatus(HttpServletRequest request, Long jobId, String cmd) {
        RetObj retObj = new RetObj();
        retObj.setFlag(false);
        try {
            taskScheduleJobService.changeStatus(jobId, cmd);
        } catch (SchedulerException e) {
            logger.error(ExceptionUtil.getStackTrace(e));
            retObj.setMsg("任务状态改变失败！");
            return retObj;
        }
        retObj.setFlag(true);
        return retObj;
    }


    @RequestMapping("delCron")
    @ResponseBody
    public RetObj delCron(HttpServletRequest request, Long jobId) {
        RetObj retObj = new RetObj();
        retObj.setFlag(false);
        try {
            taskScheduleJobService.delete(jobId);
        } catch (SchedulerException e) {
            retObj.setMsg("cron更新失败！");
            return retObj;
        }
        retObj.setFlag(true);
        return retObj;
    }


    @RequestMapping("updateCron")
    @ResponseBody
    public RetObj updateCron(HttpServletRequest request, Long jobId, String cron) {
        RetObj retObj = new RetObj();
        retObj.setFlag(false);
        try {
            CronScheduleBuilder scheduleBuilder = CronScheduleBuilder.cronSchedule(cron);
        } catch (Exception e) {
            retObj.setMsg("cron表达式有误，不能被解析！");
            return retObj;
        }
        try {
            taskScheduleJobService.updateCron(jobId, cron);
        } catch (SchedulerException e) {
            retObj.setMsg("cron更新失败！");
            return retObj;
        }
        retObj.setFlag(true);
        return retObj;
    }
}

