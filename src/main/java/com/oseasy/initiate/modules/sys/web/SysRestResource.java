package com.oseasy.initiate.modules.sys.web;

import java.util.Arrays;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.oseasy.initiate.modules.sys.vo.SysPropType;
import com.oseasy.pcore.common.config.ApiTstatus;

@RestController
@RequestMapping(value = "${adminPath}/sys/")
public class SysRestResource {
    private static Logger logger = LoggerFactory.getLogger(SysRestResource.class);

    /****************************************************************************************************************
     * 新修改的接口.
     ***************************************************************************************************************/
    /**
     * 获取门禁特权类型.
     * @return ActYwApiStatus
     */
    @ResponseBody
    @RequestMapping(value = "/ajaxSysPropTypes", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    public ApiTstatus<String> ajaxSysPropTypes() {
        return new ApiTstatus<String>(true, "查询成功！", (Arrays.asList(SysPropType.values())).toString());
    }
}
