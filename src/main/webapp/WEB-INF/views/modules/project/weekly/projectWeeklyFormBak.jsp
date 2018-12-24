<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>项目周报</title>
    <meta name="decorator" content="site-decorator"/>
    <link rel="stylesheet" type="text/css" href="/static/bootstrap/2.3.1/awesome/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="/common/common-css/bootstrap.min.css"/>
    <script type="text/javascript" src="/common/common-js/datepicker/My97DatePicker/WdatePicker.js"></script>

    <link rel="stylesheet" type="text/css" href="/css/projectForm1.css"/>
    <script src="/other/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="/common/common-js/jquery.validate.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="/common/common-js/messages_zh.min.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="/static/webuploader/webuploader.min.js"></script>
    <style>
        .footer-btn-wrap a{
            padding: 6px 12px;
        }
       .webuploader-container .webuploader-pick{
            border: none;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="top-title">
        <h3 style="margin-top: 55px;">${projectDeclare.name}</h3>
    </div>
    <form:form id="inputForm" modelAttribute="vo" action="submit"
               method="post" class="form-horizontal" enctype="multipart/form-data">
        <input type="hidden" id="projectWeekly.projectId"
               name="projectWeekly.projectId" value="${projectWeekly.projectId}">
        <input type="hidden" id="projectWeekly.id" name="projectWeekly.id"
               value="${projectWeekly.id}">
        <input type="hidden" id="projectWeekly.lastId"
               name="projectWeekly.lastId" value="${projectWeekly.lastId}">
        <div class="outer-wrap">
            <div class="container-fluid">
                <div class="row content-wrap">
                    <section class="row">
                        <div class="top-bread">
                            <div class="top-prj-num">
                                <span>项目编号:</span>${projectDeclare.number}</div>
                            <div class="top-prj-num">
                                <span>创建时间:</span>
                                <fmt:formatDate value="${projectDeclare.createDate}"/>
                            </div>
                        </div>
                        <p
                                style="width: 100%; height: 40px; line-height: 40px; color: #656565; background-color: #f4e6d4; font-size: 16px; font-weight: bold; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; padding-left: 15px;">
                            项目周报</p>
                    </section>
                    <div style="padding: 50px 140px;">
                        <section class="row">
                            <div class="form-horizontal" novalidate>
                                <div class="form-group col-sm-4 col-md-4 col-lg-4">
                                    <label class="col-xs-5 "
                                           style="padding-left: 0px; width: 40%;">汇报人：</label>
                                    <p class="col-xs-7">${cuser.name}</p>
                                </div>
                                <div class="form-group col-sm-4 col-md-4 col-lg-4"></div>
                                <div class="form-group col-sm-4 col-md-4 col-lg-4">
                                    <label class="col-xs-5" style="padding-left: 0px; width: 40%;">职责：</label>
                                    <p class="col-xs-7">${duty}</p>
                                </div>
                            </div>

                            <div class="form-horizontal" novalidate>
                                <div class="form-group col-sm-4 col-md-4 col-lg-4">
                                    <label class="col-xs-5 "
                                           style="padding-left: 0px; width: 40%;">项目组成员：</label>
                                    <p class="col-xs-7">${teamList}</p>
                                </div>
                                <div class="form-group col-sm-4 col-md-4 col-lg-4"></div>
                                <div class="form-group col-sm-4 col-md-4 col-lg-4">
                                    <label class="col-xs-5" style="padding-left: 0px; width: 40%;">项目导师：</label>
                                    <p class="col-xs-7" style="width: 60%;">${teacher}</p>
                                </div>
                            </div>
                        </section>
                        <c:if test="${user.userType==1}">
                            <section class="row">
                                <div class="prj_common_info"
                                     style="height: 40px; line-height: 40px;">
                                    <h4 class="sub-file" style="margin-top: 25px;">上周任务小结</h4>
                                    <span class="yw-line yw-line-fj"></span> <span
                                        href="javascript:;" class="upload-file2"
                                        style="background: none; color: #656565 !important;"><strong
                                        style="font-weight: 500;">时间：<fmt:formatDate
                                        value="${vo.lastpw.startDate}" pattern="yyyy-MM-dd"/>-<fmt:formatDate
                                        value="${vo.lastpw.endDate}" pattern="yyyy-MM-dd"/></strong></span>
                                </div>
                                <div class="table-wrap">
                                    <div class="form-horizontal" novalidate>
                                        <label class="col-xs-5 " style="padding-left: 0;">上周任务计划：</label>
                                        <div class="textarea-wrap">
												<textarea readonly="readonly"
                                                          class="col-xs-12 col-md-12 col-sm-12 col-lg-12 my-textarea">${vo.lastpw.plan}</textarea>
                                        </div>
                                    </div>

                                    <div class="form-horizontal" novalidate>
                                        <label class="col-xs-5 " style="padding-left: 0;">完成情况：</label>
                                        <div class="textarea-wrap">
												<textarea name="lastpw.achieved"
                                                          class="col-xs-12 col-md-12 col-sm-12 col-lg-12 my-textarea">${vo.lastpw.achieved}</textarea>
                                        </div>
                                    </div>

                                    <div class="form-horizontal" novalidate>
                                        <label class="col-xs-5 " style="padding-left: 0;">存在的问题：</label>
                                        <div class="textarea-wrap">
												<textarea name="lastpw.problem"
                                                          class="col-xs-12 col-md-12 col-sm-12 col-lg-12 my-textarea">${vo.lastpw.problem }</textarea>
                                        </div>
                                    </div>
                                </div>
                            </section>

                            <section class="row">
                                <div class="prj_common_info prj-task-info"
                                     style="height: 40px; line-height: 40px;">
                                    <h4 class="sub-file" style="margin-top: 25px;">本周任务计划</h4>
                                    <span class="yw-line yw-line-fj"></span>
                                    <div class="task_time_wrap">
                                        <span class="time_label">任务时间：</span>
                                        <div class="task_time">
                                            <input required class="Wdate" type="text"
                                                   id="projectWeekly.startDate" name="projectWeekly.startDate"
                                                   value='<fmt:formatDate
												value="${vo.projectWeekly.startDate}" pattern="yyyy-MM-dd" />'
                                                   onClick="WdatePicker({minDate:'${minDate}',maxDate:'#F{$dp.$D(\'projectWeekly.endDate\')}'})"/>
                                            <span>至</span> <input required class="Wdate" type="text"
                                                                  id="projectWeekly.endDate"
                                                                  name="projectWeekly.endDate"
                                                                  value='<fmt:formatDate
												value="${vo.projectWeekly.endDate}" pattern="yyyy-MM-dd" />'
                                                                  onClick="WdatePicker({minDate:'#F{$dp.$D(\'projectWeekly.startDate\')||\'${minDate}\'}'})"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="textarea-wrap">
										<textarea name="projectWeekly.plan" required
                                                  class="col-xs-12 col-md-12 col-sm-12 col-lg-12 my-textarea">${vo.projectWeekly.plan}</textarea>
                                </div>
                            </section>

                            <section class="row">
                                <div class="prj_common_info"
                                     style="height: 40px; line-height: 40px;">
                                    <h4 class="sub-file" style="margin-top: 25px;">附件</h4>
                                    <span class="yw-line yw-line-fj"></span>
                                </div>
                                <sys:frontFileUpload fileitems="${vo.fileInfo}" filepath="weekly"
                                                     btnid="upload"></sys:frontFileUpload>
                            </section>
                            <c:if test="${vo.projectWeekly.id!=null}">
                                <section class="row">
                                    <div class="prj_common_info"
                                         style="height: 40px; line-height: 40px;">
                                        <h4 class="sub-file" style="margin-top: 25px;">导师意见及建议</h4>
                                        <span class="yw-line yw-line-fj"></span> <span
                                            href="javascript:;" class="upload-file2"
                                            style="background: none; color: #656565 !important;"><strong>时间：<fmt:formatDate
                                            value="${vo.projectWeekly.suggestDate}"
                                            pattern="yyyy-MM-dd"/></strong></span>
                                    </div>
                                    <textarea name="suggest" readonly="readonly"
                                              class="col-xs-12 col-md-12 col-sm-12 col-lg-12 my-textarea">${vo.projectWeekly.suggest}</textarea>
                                </section>
                            </c:if>
                        </c:if>
                        <c:if test="${user.userType==2}">
                            <section class="row">
                                <div class="prj_common_info"
                                     style="height: 40px; line-height: 40px;">
                                    <h4 class="sub-file" style="margin-top: 25px;">上周任务小结</h4>
                                    <span class="yw-line yw-line-fj"></span> <span
                                        href="javascript:;" class="upload-file2"
                                        style="background: none; color: #656565 !important;"><strong
                                        style="font-weight: 500;">时间：<fmt:formatDate
                                        value="${vo.lastpw.startDate}" pattern="yyyy-MM-dd"/>-<fmt:formatDate
                                        value="${vo.lastpw.endDate}" pattern="yyyy-MM-dd"/></strong></span>
                                </div>
                                <div class="table-wrap">
                                    <div class="form-horizontal" novalidate>
                                        <label class="col-xs-5 " style="padding-left: 0;">上周任务计划：</label>
                                        <div class="textarea-wrap">
												<textarea readonly="readonly"
                                                          class="col-xs-12 col-md-12 col-sm-12 col-lg-12 my-textarea">${vo.lastpw.plan}</textarea>
                                        </div>
                                    </div>

                                    <div class="form-horizontal" novalidate>
                                        <label class="col-xs-5 " style="padding-left: 0;">完成情况：</label>
                                        <div class="textarea-wrap">
												<textarea readonly="readonly"
                                                          class="col-xs-12 col-md-12 col-sm-12 col-lg-12 my-textarea">${vo.lastpw.achieved}</textarea>
                                        </div>
                                    </div>

                                    <div class="form-horizontal" novalidate>
                                        <label class="col-xs-5 " style="padding-left: 0;">存在的问题：</label>
                                        <div class="textarea-wrap">
												<textarea readonly="readonly"
                                                          class="col-xs-12 col-md-12 col-sm-12 col-lg-12 my-textarea">${vo.lastpw.problem}</textarea>
                                        </div>
                                    </div>
                                </div>
                            </section>

                            <section class="row">
                                <div class="prj_common_info prj-task-info"
                                     style="height: 40px; line-height: 40px;">
                                    <h4 class="sub-file" style="margin-top: 25px;">本周任务计划</h4>
                                    <span class="yw-line yw-line-fj"></span>
                                    <div class="task_time_wrap">
                                        <span class="time_label">任务时间：</span>
                                        <div class="task_time">
                                            <input readonly="readonly" class="Wdate" type="text"
                                                   name="projectWeekly.startDate"
                                                   value='<fmt:formatDate
												value="${vo.projectWeekly.startDate}" pattern="yyyy-MM-dd" />'/>
                                            <span>至</span> <input readonly="readonly"
                                                                  value='<fmt:formatDate
												value="${vo.projectWeekly.endDate}" pattern="yyyy-MM-dd" />'
                                                                  class="Wdate" type="text"
                                                                  name="projectWeekly.endDate"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="textarea-wrap">
										<textarea readonly="readonly" name="projectWeekly.plan"
                                                  class="col-xs-12 col-md-12 col-sm-12 col-lg-12 my-textarea">${vo.projectWeekly.plan}</textarea>
                                </div>
                            </section>

                            <section class="row">
                                <div class="prj_common_info"
                                     style="height: 40px; line-height: 40px;">
                                    <h4 class="sub-file" style="margin-top: 25px;">附件</h4>
                                    <span class="yw-line yw-line-fj"></span>
                                </div>
                                <sys:frontFileUpload fileitems="${vo.fileInfo}" filepath="weekly"
                                                     btnid="upload"></sys:frontFileUpload>
                            </section>
                            <section class="row">
                                <div class="prj_common_info"
                                     style="height: 40px; line-height: 40px;">
                                    <h4 class="sub-file" style="margin-top: 25px;">导师意见及建议</h4>
                                    <span class="yw-line yw-line-fj"></span> <span
                                        href="javascript:;" class="upload-file2"
                                        style="background: none; color: #656565 !important;"><strong>时间：<fmt:formatDate
                                        value="${currentDate}" pattern="yyyy-MM-dd"/></strong></span>
                                </div>
                                <textarea name="projectWeekly.suggest"
                                          class="col-xs-12 col-md-12 col-sm-12 col-lg-12 my-textarea">${projectWeekly.suggest}</textarea>
                            </section>
                        </c:if>


                        <div class="footer-btn-wrap">
                            <c:if test="${user.userType==2}">
                                <a href="javascript:;" class="btn btn-primary btn-save" style="vertical-align: top;"
                                   onclick="weekly.save();">保存</a>
                            </c:if>
                            <c:if test="${user.userType==1}">
                                <a href="javascript:;" class="btn btn-primary" style="vertical-align: top;"
                                   onclick="weekly.subBtn();">提交</a>
                            </c:if>
                            <div id="upload"
                                 style="display: inline-block; font-size: 12px; vertical-align: top; height: 28px;">上传附件
                            </div>
                            <a href="javascript:;" class="btn btn-primary" style="vertical-align: top;"
                               onclick="history.go(-1);">返回</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form:form>
</div>
<script src="/js/projectWeekly.js" type="text/javascript" charset="utf-8"></script>
</body>
</html>