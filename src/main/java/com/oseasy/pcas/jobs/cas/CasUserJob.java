package com.oseasy.pcas.jobs.cas;

import java.util.Date;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.oseasy.pcas.modules.cas.service.SysCasAnZhiService;
import com.oseasy.pcore.jobs.AbstractJobDetail;
import com.oseasy.putil.common.utils.exception.ExceptionUtil;

@Service("casUserJob")
public class CasUserJob extends AbstractJobDetail {
    public final static Logger logger = Logger.getLogger(CasUserJob.class);
    @Autowired
    private SysCasAnZhiService sysCasAnZhiService;

    public void doWork() {
        try {
            logger.info("CAS用户数据同步开始:" + new Date());
            sysCasAnZhiService.casJob();
            logger.info("CAS用户数据同步结束:" + new Date());
        } catch (Exception e) {
            logger.error("CAS用户数据同步出错:" + ExceptionUtil.getStackTrace(e));
        }
    }
}
