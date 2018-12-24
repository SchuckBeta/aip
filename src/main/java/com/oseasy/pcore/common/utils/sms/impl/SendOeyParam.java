package com.oseasy.pcore.common.utils.sms.impl;

import com.oseasy.pcore.common.utils.sms.ISendParam;

public class SendOeyParam extends ISendParam{
  private String inviteNo;

  public SendOeyParam() {
    super();
  }

  public SendOeyParam(String inviteNo) {
    super();
    this.inviteNo = inviteNo;
  }

  public String getInviteNo() {
    return inviteNo;
  }

  public void setInviteNo(String inviteNo) {
    this.inviteNo = inviteNo;
  }
}
