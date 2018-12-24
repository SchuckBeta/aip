package com.oseasy.pact.modules.actyw.entity;

import java.util.List;

import org.hibernate.validator.constraints.Length;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.oseasy.pact.modules.actyw.tool.process.cmd.ActYwRtpl;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowProjectType;
import com.oseasy.pcore.common.config.ApiTstatus;
import com.oseasy.pcore.common.persistence.DataEntity;
import com.oseasy.putil.common.utils.StringUtil;

/**
 * 自定义流程Entity.
 * @author chenhao
 * @version 2017-05-23
 */
public class ActYwGroup extends DataEntity<ActYwGroup> implements ActYwRtpl{
  private static final long serialVersionUID = 1L;
  public static final String GROUP_DEPLOY_0 = "0";
  public static final String GROUP_DEPLOY_1 = "1";
  public static final String GROUP_VERSION = "1.0.0";
  public static final String JK_ACTYW_ID = "actywId";//YWID标识
  public static final String JK_GROUP = "group";
  public static final String JK_GROUP_ID = "groupId";
  public static final String JK_GNODE = "group";
  public static final String JK_GNODE_ID = "gnodeId";

  private String name; // 流程名称
  private String status; // 状态:0、未启用；1、启用
  private String flowId; // 流程模型ID
  private String flowType; // 流程类型
  private String type; // 项目类型
  private String keyss; // 流程唯一标识
  private Integer theme; //表单组类型
  private Boolean temp; //是否临时数据
  private String author; // 流程作者
  private String version; // 流程版本
  private Integer sort;   // 排序
  private String uiHtml;// 设计前端HTML
  private String uiJson;// 设计前端JSON

  private List<ActYw> actYws; // 项目流程
  @JsonIgnore
  private Long ywsize;   // actYws记录数
  @JsonIgnore
  private ApiTstatus<ActYwGnode> ApiStatus;   // 状态

  public ActYwGroup() {
    super();
  }

  public ActYwGroup(String id) {
    super(id);
  }

  public List<ActYw> getActYws() {
    return actYws;
  }

  public void setActYw(List<ActYw> actYws) {
    this.actYws = actYws;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getFlowType() {
    return flowType;
  }

  public void setFlowType(String flowType) {
    this.flowType = flowType;
  }

  @Length(min = 0, max = 1, message = "状态:0、未启用；1、启用长度必须介于 0 和 1 之间")
  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public Long getYwsize() {
    return ywsize;
}

public String getType() {
    return type;
  }

public Boolean getTemp() {
    return temp;
}

public void setTemp(Boolean temp) {
    this.temp = temp;
}

public Integer getTheme() {
    return theme;
}

public void setTheme(Integer theme) {
    this.theme = theme;
}

public String[] getTypes() {
    String[] types = null;
    if (StringUtil.isNotEmpty(this.type) && (this.type.length() > 1)) {
      types = this.type.substring(0, (this.type.length()-1)).split(",");
    }
    return types;
  }

  public void setType(String type) {
    this.type = type;
  }

  @JsonIgnore
  public void setType(FlowProjectType[] flowProjectTypes) {
    StringBuffer proType = new StringBuffer();
    for (FlowProjectType flowProjectType : flowProjectTypes) {
      proType.append(flowProjectType.getKey());
      proType.append(",");
    }
    this.type = proType.toString();
  }

  public Integer getSort() {
    return sort;
  }

  public void setSort(Integer sort) {
    this.sort = sort;
  }

  public String getAuthor() {
    return author;
  }

  public void setAuthor(String author) {
    this.author = author;
  }

  public String getVersion() {
    return version;
  }

  public void setVersion(String version) {
    this.version = version;
  }

  public String getFlowId() {
    return flowId;
  }

  public void setFlowId(String flowId) {
    this.flowId = flowId;
  }

  public String getKeyss() {
    return keyss;
  }

  public void setKeyss(String keyss) {
    this.keyss = keyss;
  }

  public ApiTstatus<ActYwGnode> getApiStatus() {
    if (this.ApiStatus == null) {
      this.ApiStatus = new ApiTstatus<ActYwGnode>();
    }
    return ApiStatus;
  }

  public void setApiStatus(ApiTstatus<ActYwGnode> ApiStatus) {
    this.ApiStatus = ApiStatus;
  }

public String getUiHtml() {
    return uiHtml;
}

public void setUiHtml(String uiHtml) {
    this.uiHtml = uiHtml;
}

public String getUiJson() {
    return uiJson;
}

public void setUiJson(String uiJson) {
    this.uiJson = uiJson;
}
}