package com.oseasy.pact.modules.actyw.tool.process.vo;

import java.util.List;

import com.google.common.collect.Lists;
/**
 * 固定流程ID.
 * @author chenhao
 *
 */
public enum FlowYwId {
    FY_P_MD("04ba36e74ca649d1902b18311280e443", "de1ba2e2c3954f43a68a233a152ad87d", FlowProjectType.PMT_XM, "双创民大固定流程"),
//    FY_P(ProjectNodeVo.YW_ID, ProjectNodeVo.YW_FID, FlowProjectType.PMT_XM, "双创项目固定流程"),
//  FY_G(GContestNodeVo.YW_ID, GContestNodeVo.YW_FID, FlowProjectType.PMT_DASAI, "大赛固定流程"),
  FY_APPOINTMENT("1000", "1000", FlowProjectType.PMT_APPOINTMENT, "预约固定流程"),
  FY_ENTER("2000", "2000", FlowProjectType.PMT_ENTER, "入驻固定流程");

    public static final String FLOW_YWIDS = "flowYwIds";

  private String id;
  private String gid;
  private FlowProjectType fpType;
  private String remark;
  private FlowYwId(String id, String gid, FlowProjectType fpType, String remark) {
    this.id = id;
    this.gid = gid;
    this.fpType = fpType;
    this.remark = remark;
  }

  public String getGid() {
    return gid;
  }

  public String getId() {
    return id;
  }

  public String getRemark() {
    return remark;
  }

  public FlowProjectType getFpType() {
    return fpType;
  }

  public static FlowYwId getById(String id) {
    FlowYwId[] entitys = FlowYwId.values();
    for (FlowYwId entity : entitys) {
      if ((id).equals(entity.getId())) {
        return entity;
      }
    }
    return null;
  }

  public static FlowYwId getByGid(String gid) {
    FlowYwId[] entitys = FlowYwId.values();
    for (FlowYwId entity : entitys) {
      if ((gid).equals(entity.getGid())) {
        return entity;
      }
    }
    return null;
  }

  public static FlowYwId getByFpType(FlowProjectType fpType) {
    FlowYwId[] entitys = FlowYwId.values();
    for (FlowYwId entity : entitys) {
      if ((fpType != null) && (fpType).equals(entity.getFpType())) {
        return entity;
      }
    }
    return null;
  }

  /**
   * 获取ID .
   * @return List
   */
  public static List<FlowYwId> getAll(Boolean enable) {
      if(enable == null){
          enable = true;
      }

      List<FlowYwId> enty = Lists.newArrayList();
      FlowYwId[] entitys = FlowYwId.values();
      for (FlowYwId entity : entitys) {
          enty.add(entity);
      }
      return enty;
  }
  public static List<FlowYwId> getAll() {
      return getAll(true);
  }

  @Override
  public String toString() {
      return "{\"id\":\"" + this.id + "\",\"gid\":\"" + this.gid + "\",\"fpType\":\"" + this.fpType + "\",\"remark\":" + this.remark + "\"}";
  }
}
