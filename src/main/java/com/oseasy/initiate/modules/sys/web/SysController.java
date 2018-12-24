package com.oseasy.initiate.modules.sys.web;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Lists;
import com.oseasy.pcore.common.config.CoreJkey;
import com.oseasy.pcore.common.mapper.JsonMapper;
import com.oseasy.pcore.common.utils.IdGen;
import com.oseasy.pcore.modules.sys.service.SysService;

@Controller
public class SysController {

  @Autowired
  private SysService sysService;

  /**
   * 获取系统同步时钟.
   * @param type 类型
   * @return Date
   */
  @ResponseBody
  @RequestMapping(value = "${adminPath}/sys/type/{type}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
  public Date getDbCurDate(@PathVariable String type) {
    return sysService.getDbCurDate(type);
  }

  @ResponseBody
  @RequestMapping(value = "${frontPath}/sys/type/{type}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
  public Date fgetDbCurDate(@PathVariable String type) {
    return sysService.getDbCurDate(type);
  }

  /**
   * 获取系统同步UUID.
   * @return String
   */
  @ResponseBody
  @RequestMapping(value = "${adminPath}/sys/uuid", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
  public Map<String, Object> uuid() {
      Map<String, Object> ret = new HashMap<>();
      ret.put(CoreJkey.JK_STATUS, true);
      ret.put(CoreJkey.JK_ID, IdGen.uuid());
    return ret;
  }

  @ResponseBody
  @RequestMapping(value = "${adminPath}/sys/uuids/{num}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
  public Map<String, Object> uuids(@PathVariable int num) {
      Map<String, Object> ret = new HashMap<>();
      List<String> ids = Lists.newArrayList();
      if(num <= 0){
          ret.put(CoreJkey.JK_STATUS, false);
          ret.put(CoreJkey.JK_ID, ids);
          return ret;
      }

      for (int i = 0; i < num; i++) {
          ids.add(IdGen.uuid());
      }
      ret.put(CoreJkey.JK_STATUS, true);
      ret.put(CoreJkey.JK_ID, JsonMapper.toJsonString(ids));
      return ret;
  }

  @ResponseBody
  @RequestMapping(value = "${frontPath}/sys/uuid", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
  public Map<String, Object> fuuid() {
    return uuid();
  }

  @ResponseBody
  @RequestMapping(value = "${frontPath}/sys/uuids/{num}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
  public Map<String, Object> fuuids(@PathVariable int num) {
      return uuids(num);
  }

  /**
   * 获取系统同步时钟.
   * @param type 类型
   * @return Date
   */
  @ResponseBody
  @RequestMapping(value = "${adminPath}/sys/sysCurDateYmdHms", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
  public Date sysCurDateYmdHms() {
      return sysService.getSysCurDateYmdHms();
  }

  @ResponseBody
  @RequestMapping(value = "${frontPath}/sys/sysCurDateYmdHms", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
  public Date fsysCurDateYmdHms() {
      return sysService.getSysCurDateYmdHms();
  }
}
