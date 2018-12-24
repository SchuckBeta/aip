package com.oseasy.pcore.common.utils.sms.oseasy;

import com.oseasy.pcore.common.config.Global;

public class OeySMSConfig {

  public static final String AILIDAYU_SMS_TemplateInvite = Global.getConfig("ailidayu.sms.oey.template.invite"); //客户邀请短信模板
  public static final String AILIDAYU_SMS_OEY_SIGN = Global.getConfig("ailidayu.sms.oey.sign");//签名  噢易云
  public static final String AILIDAYU_SMS_OEY_PYEAR = Global.getConfig("ailidayu.sms.oey.pyear");//年份  2017
  public static final String AILIDAYU_SMS_OEY_PTIME = Global.getConfig("ailidayu.sms.oey.ptime");//时间  秋季
  public static final String AILIDAYU_SMS_OEY_PADDR = Global.getConfig("ailidayu.sms.oey.paddr");//地点  南京
  public static final String AILIDAYU_SMS_OEY_PADDRNO = Global.getConfig("ailidayu.sms.oey.paddrNo");//展位号  7E22
  public static final String AILIDAYU_SMS_OEY_PPOSNAME = Global.getConfig("ailidayu.sms.oey.pposName");//展位名  噢易云

  public static final String AILIDAYU_SMS_OEY_EXCELFILE = Global.getConfig("ailidayu.sms.oey.excelfile");//签名  噢易云

  public static final Integer EXCEL_ROW = 4; //数据起始行
  public static final Integer EXCEL_COL_INO = 0; //数据列
  public static final Integer EXCEL_COL_AREA = 1; //省份
  public static final Integer EXCEL_COL_OFFICE = 2; //单位
  public static final Integer EXCEL_COL_OFFER = 3; //职位
  public static final Integer EXCEL_COL_NAME = 4; //姓名
  public static final Integer EXCEL_COL_MOBILE = 5; //手机号

}
