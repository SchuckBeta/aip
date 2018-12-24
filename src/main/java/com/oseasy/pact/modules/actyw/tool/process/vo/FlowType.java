package com.oseasy.pact.modules.actyw.tool.process.vo;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.google.common.collect.Lists;
import com.oseasy.putil.common.utils.StringUtil;
import net.sf.json.JSONArray;

/**
 * 流程类型.
 * 对应字典表 act_category .
 * @author chenhao
 */
public enum FlowType {
  FWT_DASAI("1", true, FlowPropertyType.FPT_DASAI, "双创大赛流程", "双创大赛")
 ,FWT_TECHNOLOGY("10", false, FlowPropertyType.FPT_TECHNOLOGY, "科研成果流程", "科研成果")
 ,FWT_XM("13", true, FlowPropertyType.FPT_XM, "双创项目流程", "双创项目")
// ,FWT_QINGJIA("30", false, FlowPropertyType.FPT_ALL, "请假流程", "请假")
 ,FWT_SCORE("120", false, FlowPropertyType.FPT_SCORE, "学分流程", "学分")
 ,FWT_APPOINTMENT("130", false, FlowPropertyType.FPT_APPOINTMENT, "预约流程", "预约")
 ,FWT_ENTER("140", false, FlowPropertyType.FPT_ENTER, "入驻流程", "入驻")
 ,FWT_ALL("100", false, FlowPropertyType.FPT_ALL, "通用流程", "通用");

    public static final String FLOW_TYPES = "flowTypes";
 private String key;
 private Boolean enable;
 private FlowPropertyType type;
 private String name;
 private String sname;


 private FlowType(String key, Boolean enable, FlowPropertyType type, String name, String sname) {
   this.key = key;
   this.enable = enable;
   this.type = type;
   this.name = name;
   this.sname = sname;
 }

 /**
  * 获取流程 .
  * @return List
  */
 public static List<FlowType> getAll(Boolean enable) {
     if(enable == null){
         enable = true;
     }

     List<FlowType> enty = Lists.newArrayList();
     FlowType[] entitys = FlowType.values();
     for (FlowType entity : entitys) {
         if (StringUtil.isNotEmpty(entity.getKey()) && (entity.getEnable())) {
             enty.add(entity);
         }
     }
     return enty;
 }
 public static List<FlowType> getAll() {
     return getAll(true);
 }

 /**
  * 根据key获取枚举 .
  *
  * @author chenhao
  * @param key 枚举标识
  * @return FlowType
  */
 public static FlowType getByKey(String key) {
   if ((key != null)) {
     FlowType[] entitys = FlowType.values();
     for (FlowType entity : entitys) {
       if ((key).equals(entity.getKey())) {
         return entity;
       }
     }
   }
   return null;
 }

  public String getSname() {
  return sname;
}

  public String getKey() {
    return key;
  }

  public Boolean getEnable() {
    return enable;
}

public FlowPropertyType getType() {
    return type;
  }

  public String getName() {
    return name;
  }

  /**
   * 根据projectType获取枚举 .
   *
   * @author chenhao
   * @param projectType 枚举标识
   * @return FlowType
   */
  public static List<FlowType> getByProject(FlowProjectType projectType) {
    if ((projectType != null)) {
      List<FlowType> flowTypes = Lists.newArrayList();
      FlowType[] entitys = FlowType.values();
      for (FlowType entity : entitys) {
        FlowProjectType[] fpTypeArr = entity.getType().getTypes();
        for (FlowProjectType flowProjectType : fpTypeArr) {
          if ((projectType).equals(flowProjectType)) {
            flowTypes.add(entity);
          }
        }
      }
      return flowTypes;
    }
    return null;
  }

  /**
   * 根据key获取枚举 .
   *
   * @author chenhao
   * @param projectType 枚举标识
   * @return FlowType
   */
  public static List<FlowProjectType> getByFlowType(FlowType flowType) {
    if ((flowType != null)) {
      return Arrays.asList(flowType.getType().getTypes());
    }
    return null;
  }


  @Override
  public String toString() {
      return "{\"key\":\"" + this.key + "\",\"name\":\"" + this.name + "\",\"enable\":\"" + this.enable + "\",\"sname\":\"" + this.sname + "\"}";
  }
}
