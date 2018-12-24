package com.oseasy.initiate.common.utils.image.impl;

import java.io.File;
import java.util.List;

import com.google.common.collect.Lists;
import com.oseasy.initiate.common.utils.image.IWater;
import com.oseasy.pcore.common.config.ApiStatus;
import com.oseasy.pcore.common.config.ApiGstatus;

/**
 * Created by Administrator on 2017/10/26 0026.
 */
public class WaterSrc extends Water<String> {
  public String resource;

  public WaterSrc() {
    super();
    this.isShow = true;
  }

  public WaterSrc(String resource) {
    super();
    this.isShow = true;
    this.resource = resource;
  }

  @Override
  public ApiGstatus validate() {
    ApiGstatus rsgroup = super.validate();
    List<ApiStatus> ApiStatusSuccesss = Lists.newArrayList();
    List<ApiStatus> ApiStatusFails = Lists.newArrayList();

    if ((resource == null)) {
      ApiStatusFails.add(new ApiStatus(false, "资源文件不存在！"));
    } else {
      ApiStatusSuccesss.add(new ApiStatus(true, "资源文件合法！"));
    }

    rsgroup.setSuccesss(ApiStatusSuccesss);
    rsgroup.setFails(ApiStatusFails);
    return rsgroup;
  }

  @Override
  public IWater<String> getWater() {
    return this;
  }

  @Override
  public String getResource() {
    return resource;
  }

  public void setResource(String resource) {
      this.resource = resource;
  }

  @Override
  public void setShow(Boolean show) {
    this.isShow = true;
  }
}