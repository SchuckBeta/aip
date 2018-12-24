package com.oseasy.initiate.modules.sys.tool;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.google.common.collect.Lists;
import com.oseasy.putil.common.utils.DateUtil;
import com.oseasy.putil.common.utils.FreeMarkers;
import com.oseasy.putil.common.utils.StringUtil;

public class SysNodeFresultVo {
  private SysNodeFresult formatResult;
  private List<SysNodeFresult> formatResults;
  public SysNodeFresultVo() {
    super();
  }
  public SysNodeFresultVo(SysNodeFresult formatResult) {
    super();
    this.formatResult = formatResult;
  }
  public SysNodeFresultVo(SysNodeFresult formatResult, List<SysNodeFresult> formatResults) {
    super();
    this.formatResult = formatResult;
    this.formatResults = formatResults;
  }
  public SysNodeFresult getFormatResult() {
    return formatResult;
  }
  public void setFormatResult(SysNodeFresult formatResult) {
    this.formatResult = formatResult;
  }
  public List<SysNodeFresult> getFormatResults() {
    return formatResults;
  }
  public void setFormatResults(List<SysNodeFresult> formatResults) {
    this.formatResults = formatResults;
  }
}
