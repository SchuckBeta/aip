package com.oseasy.pact.modules.actyw.entity;

import org.hibernate.validator.constraints.Length;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.oseasy.pcore.common.persistence.DataEntity;

/**
 * 项目流程通告Entity.
 * @author chenhao
 * @version 2017-05-23
 */
public class ActYwAnnounce extends DataEntity<ActYwAnnounce> {

  private static final long serialVersionUID = 1L;
  private String gnodeId; // 流程节点编号
  private String content; // 内容
  private String files; // 附件编号
  private Date beginDate; // 开始时间
  private Date endDate; // 结束时间

  public ActYwAnnounce() {
    super();
  }

  public ActYwAnnounce(String id) {
    super(id);
  }

  @Length(min = 1, max = 64, message = "流程节点编号长度必须介于 1 和 64 之间")
  public String getGnodeId() {
    return gnodeId;
  }

  public void setGnodeId(String gnodeId) {
    this.gnodeId = gnodeId;
  }

  public String getContent() {
    return content;
  }

  public void setContent(String content) {
    this.content = content;
  }

  @Length(min = 1, max = 64, message = "附件编号长度必须介于 1 和 64 之间")
  public String getFiles() {
    return files;
  }

  public void setFiles(String files) {
    this.files = files;
  }

  @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
  public Date getBeginDate() {
    return beginDate;
  }

  public void setBeginDate(Date beginDate) {
    this.beginDate = beginDate;
  }

  @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
  public Date getEndDate() {
    return endDate;
  }

  public void setEndDate(Date endDate) {
    this.endDate = endDate;
  }

}