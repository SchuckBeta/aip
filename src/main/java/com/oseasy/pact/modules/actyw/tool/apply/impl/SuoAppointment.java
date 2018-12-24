package com.oseasy.pact.modules.actyw.tool.apply.impl;

import java.util.Arrays;
import java.util.List;

import com.google.common.collect.Lists;
import com.oseasy.pact.modules.actyw.tool.apply.ISuObserveApiStatus;
import com.oseasy.pact.modules.actyw.tool.apply.ISuObserverAudit;
import com.oseasy.pact.modules.actyw.tool.apply.vo.SuApiStatusParam;
import com.oseasy.pact.modules.actyw.tool.apply.vo.SuStatus;
import com.oseasy.pact.modules.actyw.tool.apply.vo.SuStatusAparam;
import com.oseasy.pact.modules.actyw.tool.apply.vo.SuStatusGrade;
import com.oseasy.pact.modules.actyw.tool.process.vo.FlowType;

/**
 * 审核处理主题-预约.
 *
 * @author chenhao
 *
 */
public class SuoAppointment extends ISuObserveApiStatus implements ISuObserverAudit<SuApiStatusParam> {
  /**
   * 订阅审核事务.
   **/
  private SuAudit audit;
  private SuAstatus astatus;

  public SuoAppointment(String id, SuAudit audit, SuAstatus astatus) {
    super(FlowType.FWT_APPOINTMENT, id);
    this.audit = audit;
    this.astatus = astatus;
    // 每新建一个学生对象,默认添加到观察者的行列
    this.audit.add(this);
    this.astatus.add(this);
  }

  @Override
  public SuApiStatusParam audit(SuStatusAparam aparam) {
    // TODO Auto-generated method stub
    System.out.println("执行【预约】审核成功！");
    return new SuApiStatusParam();
  }

  @Override
  public List<SuStatusGrade> getStatus() {
    // TODO Auto-generated method stub
    System.out.println("获取【预约】参数成功！");
    List<SuStatusGrade> allGrade = Lists.newArrayList();
    allGrade.add(new SuStatusGrade("A", Arrays.asList(new SuStatus[]{new SuStatus("0", "不通过"), new SuStatus("1", "通过")})));
    allGrade.add(new SuStatusGrade("B", Arrays.asList(new SuStatus[]{new SuStatus("0", "A级别"), new SuStatus("1", "C级别"), new SuStatus("3", "C级别")})));
    allGrade.add(new SuStatusGrade("C", Arrays.asList(new SuStatus[]{new SuStatus("0", "良好"), new SuStatus("1", "优秀")})));
    return allGrade;
  }
}
