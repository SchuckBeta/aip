package com.oseasy.pact.modules.actyw.entity;


import org.hibernate.validator.constraints.Length;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.oseasy.initiate.modules.proproject.entity.ProProject;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowProjectType;
import com.oseasy.pact.modules.actyw.tool.process.vo.FormTheme;
import com.oseasy.pcore.common.config.Global;
import com.oseasy.pcore.common.persistence.DataEntity;
import com.oseasy.putil.common.utils.StringUtil;


/**
 * 项目流程关联Entity.
 * @author chenhao
 * @version 2017-05-23
 */
public class ActYw extends DataEntity<ActYw> {
  private static final String KEY_SEPTOR_PREFIX = "F_";
  public static final String KEY_SEPTOR = "_";
  private static final long serialVersionUID = 1L;
  private String relId; // 项目ID
  private String groupId; // 自定义流程ID
  private String flowId; // 流程部署ProcessDefinition ID
  private String deploymentId; // 流程部署 Deployment ID
  private Boolean isPreRelease; // 是否预发布
  private Boolean isDeploy; // 是否发布
  private Boolean isShowAxis; // 是否显示到时间轴

  private Boolean isUpdateYw;

  private ActYwGroup group; // 自定义流程
  private ProProject proProject;
  private List<ActYwYear> years;
  private String status; //消息是否发布(0未发布、1发布)
  private String showTime; //是否显示时间（0否、1是）
  private String keyType; //类别 民大
  private String numberRuleName; //编号规则清除
  private String numberRuleText; //编号规则示例


  public List<ActYwYear> getYears() {
    return years;
  }

  public void setYears(List<ActYwYear> years) {
    this.years = years;
  }

  /**
   * 获取表单主题.
   * @return FormTheme
   */
  @JsonIgnore
  public FormTheme getFtheme() {
      if((this.group != null) && (this.group.getTheme() != null)){
          return FormTheme.getById(this.group.getTheme());
      }
      return null;
  }

  /**
   * 获取项目类型.
   * @return FlowProjectType
   */
  @JsonIgnore
  public FlowProjectType getFptype() {
      if((this.proProject != null) && StringUtil.isNotEmpty(this.proProject.getProType())){
          String key = StringUtil.replace(this.proProject.getProType(), StringUtil.DOTH, StringUtil.EMPTY);
          return FlowProjectType.getByKey(key);
      }
      return null;
  }
  /**
   * 获取项目类型.
   * @return FlowProjectType
   */
  @JsonIgnore
  public String getPname() {
      if((this.proProject != null)){
          return this.proProject.getProjectName();
      }
      return "";
  }

  public String getKeyType() {
      return keyType;
  }

  public void setKeyType(String keyType) {
    this.keyType = keyType;
  }

  public ActYw() {
    super();
  }

  public ActYw(String id) {
    super(id);
  }

  @Length(min = 1, max = 64, message = "项目长度必须介于 1 和 64 之间")
  public String getRelId() {
    return relId;
  }

  public void setRelId(String relId) {
    this.relId = relId;
  }

  @Length(min = 1, max = 64, message = "自定义流程长度必须介于 1 和 64 之间")
  public String getGroupId() {
    if (StringUtil.isEmpty(this.groupId) && (this.group != null) && StringUtil.isNotEmpty(this.group.getId())) {
      this.groupId = this.group.getId();
    }
    return groupId;
  }

  public Boolean getIsShowAxis() {
    return isShowAxis;
  }

  public void setIsShowAxis(Boolean showAxis) {
    isShowAxis = showAxis;
  }

  public String getDeploymentId() {
    return deploymentId;
  }

  public void setDeploymentId(String deploymentId) {
    this.deploymentId = deploymentId;
  }

  public void setGroupId(String groupId) {
    this.groupId = groupId;
  }

  public Boolean getIsPreRelease() {
    return isPreRelease;
}

public void setIsPreRelease(Boolean isPreRelease) {
    this.isPreRelease = isPreRelease;
}

/**
   * @return 获取isDeploy属性值.
   */
  public Boolean getIsDeploy() {
    return isDeploy;
  }

  /**
   * 设置isDeploy属性值.
   */
  public void setIsDeploy(Boolean isDeploy) {
    this.isDeploy = isDeploy;
  }

  /**
   * @return 获取group属性值.
   */
  public ActYwGroup getGroup() {
    return group;
  }

  /**
   * 设置group属性值.
   */
  public void setGroup(ActYwGroup group) {
    this.group = group;
  }

  public ProProject getProProject() {
    return proProject;
  }

  public void setProProject(ProProject proProject) {
    this.proProject = proProject;
  }

  public String getFlowId() {
    return flowId;
  }

  public void setFlowId(String flowId) {
    this.flowId = flowId;
  }

  public static String getPkey(ActYw actYw) {
    if (actYw == null) {
      return null;
    }
    return getPkey(actYw.getGroup(), actYw.getProProject());
  }

  /**
   * 流程模型唯一标识=流程标识+项目标识
   * @param actYwGroup 自定义流程
   * @param proProject 项目
   * @return String
   */
  public static String getPkey(ActYwGroup actYwGroup, ProProject proProject) {
    if ((actYwGroup == null) || (StringUtil.isEmpty(actYwGroup.getKeyss()))) {
      return null;
    }

    if ((proProject == null) || (StringUtil.isEmpty(proProject.getProjectMark()))) {
      return null;
    }
    return KEY_SEPTOR_PREFIX + proProject.getProjectMark() + KEY_SEPTOR + actYwGroup.getKeyss();
  }

  /**
   * 获取pkey中的keyss.
   * @param pkey 流程模型唯一标识=流程标识+项目标识
   * @return String
   */
  public static String pkeySplitKeyss(String pkey) {
    if ((pkey == null) || (StringUtil.isEmpty(pkey))) {
      return null;
    }
    return pkey.substring(pkey.lastIndexOf(KEY_SEPTOR) + KEY_SEPTOR.length());
  }

  public String getNumberRuleName() {
    return numberRuleName;
  }

  public void setNumberRuleName(String numberRuleName) {
    this.numberRuleName = numberRuleName;
  }

  public String getNumberRuleText() {
    return numberRuleText;
  }

  public void setNumberRuleText(String numberRuleText) {
    this.numberRuleText = numberRuleText;
  }

  /**
   * 获取pkey中的keyss.
   * @param pkey 流程模型唯一标识=流程标识+项目标识
   * @return String
   */
  public static String pkeySplitProjectMark(String pkey) {
    if ((pkey == null) || (StringUtil.isEmpty(pkey))) {
      return null;
    }
    return pkey.substring(pkey.indexOf(KEY_SEPTOR_PREFIX) + KEY_SEPTOR_PREFIX.length(), pkey.lastIndexOf(KEY_SEPTOR));
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public String getShowTime() {
    if (showTime == null) {
      return Global.SHOW;
    }
    return showTime;
  }

  public void setShowTime(String showTime) {
    this.showTime = showTime;
  }

  public Boolean getIsUpdateYw() {
    return isUpdateYw;
  }

  public void setIsUpdateYw(Boolean updateYw) {
    isUpdateYw = updateYw;
  }
}