<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%--<%@ page errorPage="/WEB-INF/views/error/formMiss.jsp" %>--%>
<!DOCTYPE html>
<html>
<head>
    <title>项目变更</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script src="/js/frontCyjd/uploaderFile.js"></script>
    <script src="/other/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="/static/moment/moment.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="/js/tlxy_projectEdit.js?v=1" type="text/javascript" charset="utf-8"></script>
    <style type="text/css">
        .modal{
            width:800px;
            margin-left:-400px;
        }

        .minus {
            display: inline-block;
            width: 19px;
            height: 19px;
            background: url(/img/minuse.png) no-repeat;
        }

        .minus:hover {
            background: url(/img/minus2.png) no-repeat;
            cursor: pointer;
        }

        .plus {
            display: inline-block;
            width: 19px;
            height: 19px;
            background: url(/img/plus.png) no-repeat;
        }

        .plus:hover {
            background: url(/img/plus2.png) no-repeat;
            cursor: pointer;
        }

        .gray-border {
            border: 1px solid #f7f7f7;
            padding: 0 40px 20px;
            margin-left: -30px;
            margin-right: -30px;
            border-radius: 10px;
        }

        .back-gray {
            background: #f7f7f7;
            margin: 0 -40px;
            height: 50px;
            line-height: 50px;
            text-align: center;
        }

        .item-label {
            margin-top: 4px;
        }

        .items-box input {
            width: 80%;
            max-width: 206px;
        }

        .items-box select {
            width: 87%;
            max-width: 206px;
        }

        .project-grade span {
            position: relative;
            display: inline-block;
            padding-right: 20px;
            margin-top: 5px;
            font-weight: 400;
            vertical-align: middle;
            cursor: pointer;
        }

        .project-grade span label {
            font-weight: normal;
            margin-left: 20px;
            margin-bottom: 0;
        }

        .project-grade span input {
            position: absolute;
        }

        .team-detail.panel-body {
            padding: 0;
        }

        .change-record {
            text-decoration: underline;
            margin-left: 40px;
        }

        .check-table th {
            background: #F4E6D4;
        }

        .prj_range, .result_score {
            color: red;
            font-weight: bold;
        }

        .Wdate:hover{
            cursor:pointer;
        }

        .tl-basic-info .row-info-fluid .item-label + .items-box{
            margin-top: 4px;
        }

        .error-inline .error{
            display: inline-block;
        }

        .label-error label.error{
            display: inline-block;
        }

    </style>
</head>

<body>


<div class="container-fluid container-fluid-audit" style="margin-bottom: 60px;">
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="inputForm" modelAttribute="proModel" action="${ctx}/promodel/proModel/saveProjectEdit"
               method="post" class="form-horizontal form-container">
        <form:hidden path="id"/>
        <form:hidden path="year"/>
        <form:hidden path="act.taskId"/>
        <form:hidden path="act.taskName"/>
        <form:hidden path="act.taskDefKey"/>
        <form:hidden path="act.procInsId"/>
        <form:hidden path="act.procDefId"/>

        <input type="hidden" name="actionPath" value="${actionPath}"/>
        <input type="hidden" name="gnodeId" value="${gnodeId}"/>
        <input type="hidden" id="secondName" value="${secondName}"/>

        <div class="gray-border">
            <div class="back-gray">${proModel.pName}</div>

            <div class="panel-body">
                <div class="row-fluid row-info-fluid" style="margin-top:30px;">
                    <div class="span8">
                        <span class="item-label">填报日期：</span>
                        <div class="items-box">
                            <input id="declareDate" name="declareDate" type="text" readonly="readonly" maxlength="20"
                                   class="input-medium Wdate date-input" style="width:160px;" required
                                   value="<fmt:formatDate value="${proModel.subTime}" pattern="yyyy-MM-dd"/>"
                                   onclick="WdatePicker();"/>
                        </div>
                    </div>
                    <div class="span4">
                        <span class="item-label">项目编号：</span>
                        <div class="items-box">
                            <c:choose>
                                <c:when test="${proModelTlxy.proModel.finalStatus == '0000000264'}">
                                    <input type="text" name="competitionNumber" required
                                           id="competitionNumber" maxlength="24" value="${proModelTlxy.proModel.competitionNumber}"/>
                                </c:when>
                                <c:otherwise>
                                        <c:choose>
                                            <c:when test="${proModelTlxy.proModel.finalStatus == '0000000265'}">
                                                <input type="text" name="competitionNumber" required
                                                       id="competitionNumber" maxlength="24" value="${proModelTlxy.pCompetitionNumber}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <input type="text" name="competitionNumber" required
                                                       id="competitionNumber" maxlength="24" value="${proModelTlxy.gCompetitionNumber}"/>
                                            </c:otherwise>
                                        </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div>
            </div>

            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>基本信息</span> <i class="line"></i> <a
                        data-toggle="collapse" href="#projectPeopleDetail"><i
                        class="icon-collaspe icon-double-angle-up"></i></a>
                </div>
            </div>
            <div id="projectPeopleDetail" class="panel-body collapse in tl-basic-info">
                <div class="row-fluid row-info-fluid">
                    <div class="span4">
                        <span class="item-label">项目负责人：</span>
                        <div class="items-box">${proModel.deuser.name}</div>
                    </div>
                    <div class="span4">
                        <span class="item-label">学号：</span>
                        <div class="items-box">${proModel.deuser.no}</div>
                    </div>
                    <div class="span4">
                        <span class="item-label">性别：</span>
                        <div class="items-box">
                            <c:choose>
                                <c:when test="${proModel.deuser.sex == '1'}">男</c:when>
                                <c:when test="${proModel.deuser.sex == '0'}">女</c:when>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <div class="row-fluid row-info-fluid">
                    <div class="span4">
                        <span class="item-label">学历：</span>
                        <div class="items-box">学历</div>
                    </div>
                    <div class="span4">
                        <span class="item-label">学位：</span>
                        <div class="items-box">学位</div>
                    </div>
                    <div class="span4">
                        <span class="item-label">所属学院：</span>
                        <div class="items-box">${proModel.deuser.office.name}</div>
                    </div>
                </div>
                <div class="row-fluid row-info-fluid">


                    <div class="span4">
                        <span class="item-label">专业：</span>
                        <div class="items-box">${proModel.deuser.subject.name}</div>
                    </div>
                    <div class="span4">
                        <span class="item-label">联系电话：</span>
                        <div class="items-box">${proModel.deuser.mobile}</div>
                    </div>
                    <div class="span4">
                        <span class="item-label">Email：</span>
                        <div class="items-box">${proModel.deuser.email}</div>
                    </div>
                </div>
            </div>


            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>团队信息</span> <i class="line"></i>
                    <a data-toggle="collapse" href="#teamInfo">
                        <i class="icon-collaspe icon-double-angle-up"></i>
                    </a>
                </div>
            </div>
            <div id="teamInfo" class="panel-body collapse in">
                <div class="panel-inner">
                    <div class="row-fluid row-info-fluid">
                        <div class="span6">
                            <span class="item-label" style="margin-top:0;">团队名称：</span>
                            <div class="items-box">
                                <input type="hidden" id="teamId" value="${team.id}"/>
                                ${team.name}
                                <a href="javascript:void(0);" class="change-record">成员变更记录</a>
                            </div>
                        </div>
                    </div>


                    <div class="table-caption">学生团队</div>
                    <table class="table table-bordered table-condensed table-orange table-center table-nowrap table-hover studenttb">
                        <thead>
                        <tr>
                            <th>姓名</th>
                            <th>学号</th>
                            <th>联系电话</th>
                            <th>学院</th>
                            <th>当前在研</th>
                            <th>职责</th>
                            <th><input type="button" class="btn btn-primary btn-small" userType="1" value="新增"
                                       onclick="selectUser(this)"/></th>
                        </tr>
                        </thead>
                        <tbody id="teamTableStudent">
                        <c:forEach items="${teamStu}" var="item" varStatus="status">
                            <tr userid="${item.userId}">
                                <input class="custindex" type="hidden" name="studentList[${status.index}].userId"
                                       value="${item.userId}">
                                <input class="custindex" type="hidden" name="studentList[${status.index}].utype"
                                       value="1">
                                <td>${item.name}</td>
                                <td>${item.no}</td>
                                <td>${item.mobile}</td>
                                <td>${item.orgName}</td>
                                <td>${item.curJoin}</td>
                                <td>
                                    <select class="zzsel custindex" name="studentList[${status.index}].userzz">
                                        <option value="0"
                                                <c:if test="${item.userId==proModel.declareId}">selected</c:if> >
                                            负责人
                                        </option>
                                        <option value="1"
                                                <c:if test="${item.userId!=proModel.declareId}">selected</c:if> >
                                            组成员
                                        </option>
                                    </select>
                                </td>
                                <td><a class="minus team-minus"></a></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                    <div class="table-caption">指导教师</div>
                    <table
                            class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap teachertb">
                        <thead>
                        <tr>
                            <th>姓名</th>
                            <th>工号</th>
                            <th>导师来源</th>
                            <th>职称（职务）</th>
                            <th>学历</th>
                            <th>联系电话</th>
                            <th>当前指导</th>
                            <th><input type="button" class="btn btn-primary btn-small" userType="2" value="新增"
                                       onclick="selectUser(this)"/></th>
                        </tr>
                        </thead>
                        <tbody id="teamTableTeacher">
                        <c:forEach items="${teamTea}" var="item" varStatus="status">
                            <tr userid="${item.userId}">
                                <input class="custindex" type="hidden" name="teacherList[${status.index}].userId"
                                       value="${item.userId}">
                                <input class="custindex" type="hidden" name="teacherList[${status.index}].utype" value="2">
                                <td>${item.name}</td>
                                <td>${item.no}</td>
                                <td>${item.teacherType}</td>
                                <td>${item.technicalTitle}</td>
                                <td>${fns:getDictLabel(item.education,'enducation_level','')}</td>
                                <td>${item.mobile}</td>
                                <td>${item.curJoin}</td>
                                <td><a class="minus team-minus"></a></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                </div>
            </div>

            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>项目信息</span> <i class="line"></i>
                    <a data-toggle="collapse" href="#teamDetail">
                        <i class="icon-collaspe icon-double-angle-up"></i>
                    </a>
                </div>
            </div>
            <div id="teamDetail" class="panel-body collapse in team-detail">
                <div class="panel-inner">

                    <div class="control-group error-inline" style="display: inline-block;width: 500px;">
                        <label class="control-label"><i>*</i>项目类别：</label>
                        <div class="controls">
                            <form:select path="proCategory" class="required">
                                <%--<form:option value="" label="--请选择--"/>--%>
                                <form:options items="${fns:getDictList('project_type')}" itemValue="value"
                                              itemLabel="label" htmlEscape="false"/></form:select>
                        </div>
                    </div>
                    <div class="control-group error-inline" style="display: inline-block;width: 500px;">
                        <label class="control-label"><i>*</i>项目来源：</label>
                        <div class="controls">
                            <select id="source" name="source" class="form-control required fill">
                                <%--<option value="">--请选择--</option>--%>
                                <c:forEach items="${fns:getDictList('project_source')}" var="item">
                                    <option value="${item.value}"
                                    <c:if test="${proModelTlxy.source eq item.value}">
                                        selected = "selected"
                                    </c:if>
                                >${item.label}</option>
                                </c:forEach>



                            </select>
                        </div>
                    </div>

                    <div class="control-group project-grade">
                        <label class="control-label"><i>*</i>项目级别：</label>
                        <div class="controls">
                            <form:radiobuttons class="required" path="finalStatus"
                                               items="${fns:getDictList(levelDict)}"
                                               itemValue="value"
                                               itemLabel="label" htmlEscape="false"/>
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label"><i>*</i>项目名称：</label>
                        <div class="controls">
                            <input type="text" class="required" style="width:400px;"
                                   maxlength="128" name="pName" value="${proModel.pName}"
                                   placeholder="最多128个字符">
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label">项目拓展及传承：</label>
                        <div class="controls" style="margin-top: 5px;">
                            <span>1、项目能与其他大型比赛、活动对接 </span>
                            <span>2、可在低年级同学中传承 </span>
                            <span>3、结项后能继续开展 </span>
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label"><i>*</i>项目简介：</label>
                        <div class="controls">
                        <textarea class="required input-xxlarge" style="width:87%;"
                                  name="introduction"
                                  rows="3"
                                  maxlength="2000" placeholder="最多2000个字符">${proModel.introduction }</textarea>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">前期调研准备：</label>
                        <div class="controls">
                            <textarea class="input-xxlarge" style="width:87%;"
                                      name="innovation"
                                      rows="3"
                                      maxlength="2000" placeholder="最多2000个字符">${proModelTlxy.innovation}</textarea>
                        </div>
                    </div>
                    <div class="control-group label-error">
                        <label class="control-label"><i>*</i>项目预案：</label>
                        <div class="controls">
                            <table class="table table-bordered table-condensed table-orange table-center table-nowrap table-hover
                             table-team yuantb" style="width:88%;">
                                <thead>
                                <tr>
                                    <th>实施预案</th>
                                    <th style="width:350px;">时间安排</th>
                                    <th>保障措施</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td>
                                        <textarea name="planContent" class="form-control required fill" rows="3" style="width:85%;"
                                                  maxlength="2000">${proModelTlxy.planContent}</textarea>
                                    </td>
                                    <td style="vertical-align: middle">
                                        <div class="time-input-inline">

                                            <input id="qstartQDate" name="planStartDate" type="text" readonly="readonly"
                                                   maxlength="20" required
                                                   class="input-medium Wdate date-input" style="width:113px;"
                                                   value="<fmt:formatDate value="${proModelTlxy.planStartDate}" pattern="yyyy-MM-dd"/>"
                                                   onclick="WdatePicker();"/>
                                            至
                                            <input id="qstartDate" name="planEndDate" type="text" readonly="readonly"
                                                   maxlength="20" required
                                                   class="input-medium Wdate date-input" style="width:113px;"
                                                   value="<fmt:formatDate value="${proModelTlxy.planEndDate}" pattern="yyyy-MM-dd"/>"
                                                   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true, minDate:$('#qstartQDate').val()});"/>
                                        </div>
                                    </td>
                                    <td>
                                        <textarea name="planStep" class="form-control required fill" rows="3" style="width:85%;"
                                                  maxlength="2000">${proModelTlxy.planStep}</textarea>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>


                    <div class="control-group label-error">
                        <label class="control-label"><i>*</i>任务分工：</label>
                        <div class="controls">
                            <table class="table table-bordered table-condensed table-orange table-center table-nowrap table-hover
                            table-team task" style="width:88%;">
                                <thead>
                                <tr>
                                    <th>序号</th>
                                    <th style="width:180px">工作任务</th>
                                    <th style="width:180px">任务描述</th>
                                    <th style="width:320px">时间安排</th>
                                    <th>成本</th>
                                    <th>质量评价</th>
                                    <th>操作</th>
                                </tr>
                                </thead>
                                <tbody>

                                <c:if test="${proModelTlxy.planList==null||proModelTlxy.planList.size() ==0}">
                                    <tr>
                                        <td>
                                            1
                                        </td>
                                        <td>
                                            <textarea name="planList[0].content" maxlength="2000" required rows="3" style="width:120px"
                                                      class="form-control"></textarea>
                                        </td>
                                        <td>
                                            <textarea name="planList[0].description" maxlength="2000" required rows="3" style="width:120px"
                                                      class="form-control"></textarea>
                                        </td>
                                        <td style="vertical-align: middle">
                                            <div class="time-input-inline">

                                                <input required id="plan-start-date-0" class="Wdate date-input required" readonly="readonly"
                                                       style="width: 100px;"
                                                       type="text"
                                                       name="planList[0].startDate"
                                                       onClick="WdatePicker()"/>
                                                <span>至</span>
                                                <input required id="plan-end-date-0" class="Wdate date-input required" type="text" readonly="readonly"
                                                       style="width: 100px;"
                                                       name="planList[0].endDate"
                                                       onClick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true, minDate:$('#plan-start-date-0').val()})"/>
                                            </div>
                                        </td>
                                        <td style="vertical-align: middle">
                                            <input type="number" class="number form-control required" maxlength="20" style="width:45px;"
                                                   name="planList[0].cost"/>
                                        </td>
                                        <td>
                                            <%--<input type="number" class="number form-control required" maxlength="20" style="width:45px;"--%>
                                                   <%--name="planList[0].quality"/>--%>
                                            <textarea name="planList[0].quality" maxlength="2000" required rows="3" style="width:120px"
                                                      class="form-control"></textarea>
                                        </td>
                                        <td style="width:65px;">
                                            <a class="minus project-minus"></a>
                                            <a class="plus"></a>
                                        </td>
                                    </tr>
                                </c:if>
                                <c:if test="${proModelTlxy.planList!=null&&proModelTlxy.planList.size() >0}">
                                    <c:forEach items="${proModelTlxy.planList}" var="item" varStatus="status">
                                        <tr>
                                            <td>
                                                    ${status.index+1}
                                            </td>
                                            <td>
                                                <textarea required maxlength="2000" class="form-control required" rows="3" style="width:120px"
                                                          name="planList[${status.index}].content">${proModelTlxy.planList[status.index].content }</textarea>
                                            </td>
                                            <td>
                                                <textarea required maxlength="2000" class="form-control required" rows="3" style="width:120px"
                                                          name="planList[${status.index}].description">${proModelTlxy.planList[status.index].description }</textarea>
                                            </td>
                                            <td style="vertical-align: middle">
                                                <div class="time-input-inline">
                                                    <input required id="plan-start-date-${status.index}"
                                                           class="Wdate date-input required"
                                                           type="text" readonly="readonly"
                                                           style="width: 100px;"
                                                           value='<fmt:formatDate value="${proModelTlxy.planList[status.index].startDate }" pattern="yyyy-MM-dd"/>'
                                                           name="planList[${status.index}].startDate"
                                                           onClick="WdatePicker()"/>
                                                    <span>至</span>
                                                    <input required id="plan-end-date-${status.index}"
                                                           class="Wdate date-input required" type="text"
                                                           style="width: 100px;" readonly="readonly"
                                                           value='<fmt:formatDate value="${proModelTlxy.planList[status.index].endDate }" pattern="yyyy-MM-dd"/>'
                                                           name="planList[${status.index}].endDate"
                                                           onClick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true, minDate:$('#plan-start-date-${status.index}').val()})"/>
                                                </div>
                                            </td>
                                            <td style="vertical-align: middle">
                                                <input type="text" class="number form-control required" maxlength="20" style="width:45px"
                                                       name="planList[${status.index}].cost"
                                                       value="${proModelTlxy.planList[status.index].cost }"/>
                                            </td>
                                            <td>
                                                <textarea required maxlength="2000"
                                                          name="planList[${status.index}].quality" rows="3" style="width:120px"
                                                          class="form-control">${proModelTlxy.planList[status.index].quality }</textarea>
                                                <%--<input type="text" class="number form-control required" maxlength="20" style="width:45px"--%>
                                                       <%--name="planList[${status.index}].quality"--%>
                                                       <%--value="${proModelTlxy.planList[status.index].quality }"/>--%>
                                            </td>
                                            <td style="width:65px">
                                                <a class="minus project-minus"></a>
                                                <a class="plus"></a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>


                    <div class="control-group project-grade">
                        <label class="control-label"><i>*</i>成果形式：</label>
                        <div class="controls">
                            <%--<form:checkboxes class="required" path="proCategory"--%>
                                             <%--items="${fns:getProCategoryByActywId(proModel.actYwId)}"--%>
                                             <%--itemValue="value"--%>
                                             <%--itemLabel="label" htmlEscape="false"/>--%>
                            <c:forEach items="${fns:getDictList('project_result_type')}" var="item">
                            <span><input name="resultType" class="required" value="${item.value}" type="checkbox">
                                <label>${item.label}</label></span>
                            </c:forEach>
                            <input type="hidden" id="resultTypeStr" value="${proModelTlxy.resultType}"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label"><i>*</i>成果说明：</label>
                        <div class="controls">
                            <textarea class="required input-xxlarge" rows="3" style="width:87%;"
                                      name="resultContent"
                                      maxlength="2000">${proModelTlxy.resultContent}</textarea>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label"><i>*</i>项目经费预算：</label>
                        <div class="controls">
                            <input type="number" class="required input-xxlarge budgetDollar" style="width: 150px;margin-right:10px;" min="0"
                                   maxlength="11" id="budgetDollar" name="budgetDollar" value="${proModelTlxy.budgetDollar}">
                            <span>元（人民币）</span>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label"><i>*</i>经费预算明细：</label>
                        <div class="controls">
                            <textarea class="required input-xxlarge" rows="3" style="width:87%;"
                                      name="budget" placeholder="简要描述在项目各个阶段产生的费用项目及明细，如：硬件采购、耗材费、差旅费等"
                                      maxlength="2000">${proModelTlxy.budget}</textarea>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 学生提交的各种报告-->
            <c:if test="${not empty reports}">
                <c:forEach items="${reports}" var="item" varStatus="status">
                    <c:set var="actywGnode" value="${fns:getActYwGnode(item.gnodeId)}"/>
                    <div class="edit-bar edit-bar-sm clearfix">
                        <div class="edit-bar-left">
                            <span>${actywGnode.name}</span> <i class="line"></i>
                            <a data-toggle="collapse" href="#files${status.index}">
                                <i class="icon-collaspe icon-double-angle-up"></i></a>
                        </div>
                    </div>

                    <div id="files${status.index}" class="panel-body collapse in">
                        <div class="panel-inner">
                            <div class="row-fluid row-info-fluid">
                                <div class="span10">
                                    <span class="item-label">附件：</span>
                                    <div class="items-box">
                                        <sys:frontFileUpload className="accessories-h30"
                                                                gnodeId="${item.gnodeId}"  fileitems="${item.files}"></sys:frontFileUpload>
                                        <%--<sys:frontFileUpload className="accessories-h30" fileitems="${item.files}"--%>
                                                             <%--readonly="true"></sys:frontFileUpload>--%>
                                    </div>
                                </div>
                            </div>
                            <div class="row-fluid row-info-fluid">
                                <div class="span11">
                                    <span class="item-label" style="width:150px;">已取得阶段性成果：</span>
                                    <div class="items-box" style="margin-left: 165px;">
                                            ${item.stageResult}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:if>



            <c:if test="${not empty actYwAuditInfos}">

                <div class="edit-bar edit-bar-sm clearfix">
                    <div class="edit-bar-left">
                        <span>审核记录</span> <i class="line"></i><a data-toggle="collapse" href="#actYwAuditInfos"><i
                            class="icon-collaspe icon-double-angle-up"></i></a>
                    </div>
                </div>

                <div id="actYwAuditInfos" class="panel-body collapse in">
                    <table class="table table-bordered table-condensed table-orange table-center table-nowrap table-hover">
                        <thead>
                        <tr>
                            <th>审核动作</th>
                            <th>审核时间</th>
                            <th>审核人</th>
                            <th>审核结果</th>
                            <th style="width:45%">建议及意见</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${actYwAuditInfos}" var="item">
                            <c:choose>
                                <c:when test="${not empty item.id}">
                                    <tr>
                                        <td>${item.auditName}</td>
                                        <td><fmt:formatDate value="${item.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                        <td>${item.user.name}</td>
                                        <td>${item.result}</td>
                                        <td>${item.suggest}</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5"
                                            style="color: red; text-align: right;font-weight: bold">${item.auditName}：${item.result}</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

            </c:if>

            <c:if test="${not empty changeGnodes}">
            <div class="control-group">
                <span class="control-label">变更流程到节点：</span>
                <div class="controls">
                    <form:select path="toGnodeId">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${changeGnodes}" itemValue="gnodeId"
                                      itemLabel="auditName"
                                      htmlEscape="false"/></form:select>
                </div>
            </div>
            </c:if>

            <div class="form-actions-cyjd text-center" style="border-top: none">
                <button type="button" class="btn  btn-primary" id="submitBtn" href="javascript:void(0)" onclick="submitData()">提交</button>
                <a class="btn btn-default" href="javascript:history.go(-1)">返回</a>
            </div>
        </div>
    </form:form>


</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>

<div id="modalChangeRecord" data-backdrop="static" class="modal hide" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                        aria-hidden="true">&times;</span></button>
                <span class="modal-title">成员变更记录</span>
            </div>
            <div class="modal-body">
                <table class="table table-bordered table-condensed table-orange table-center table-nowrap table-hover teachertRecord">
                    <thead>
                    <tr>
                        <th>变更成员</th>
                        <%--<th>成员角色</th>--%>
                        <th>变更内容</th>
                        <th>变更时间</th>
                    </tr>
                    </thead>
                    <tbody id="check-record">

                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default btn-small btn-sm" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary btn-small btn-sm" data-dismiss="modal">确定</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->


<script type="text/javascript">

    $(function(){

        $.each($("#resultTypeStr").val().split(","), function (i, item) {
            $("input[name='resultType'][ value='" + item + "']").attr("checked", true);
        });


        var $modalChangeRecord = $('#modalChangeRecord');
        $('.change-record').click(function(){
            $modalChangeRecord.modal('show');
        })

        var projectId = $('#id').val();
        var teamId = $('#teamId').val();
        var $checkRecord = $('#check-record');
        $('.change-record').click(function(){
            if($checkRecord.children().size() > 0){
                return;
            }
            $.ajax({
                type:'POST',
                url:'/a/team/teamUserChange/ajax/getTeamUserChangeList',
                data:{
                    proModelId:projectId,
                    teamId:teamId
                },
                success:function(data){
                    var list = data.list;
                    var recordhtml = "";
                    var tpl = $("#tpl_change_record").html();
                    $.each(list, function (i, v) {
                        recordhtml = recordhtml + Mustache.render(tpl, {
                                    userId: v.userId,
                                    userName: v.name,
//                                    role: dutys[v.duty],
                                    content: v.content,
                                    date: v.date
                                });
                    });
                    $(".teachertRecord>tbody").append(recordhtml);
                }
            })
        })


    })

    var validate;
    $(document).ready(function () {
        validate = $("#inputForm").validate({
            rules: {
                "competitionNumber": {
                    remote: {
                        url: "/a/promodel/proModel/checkNumber",     //后台处理程序
                        type: "post",               //数据发送方式
                        dataType: "json",           //接受数据格式
                        data: {                     //要传递的数据
                            id: "${proModel.id}",
                            num: function () {
                                return $("input[name='competitionNumber']").val();
                            }
                        }
                    }
                }
            },
            messages: {
                "competitionNumber": {
                    remote: "项目编号已存在"
                }
            },
            errorPlacement : function(error,element) {
                if (element.is(":checkbox")|| element.is(":radio")) {
                   error.appendTo(element.parent().parent());
                }else if (element.is(".declareDate")) {
                    error.appendTo(element.parent());
                }else if(element.is(".teamName")){
                    error.appendTo(element.parent());
                }else if(element.is('.Wdate')){
                    error.appendTo(element.parent());
                }else if(element.is(".budgetDollar")){
                    error.appendTo(element.parent());
                }else{
                    error.insertAfter(element);
                }
            }
        });
    });


    /* 团队变更 */
    $(document).on('click', '.team-minus', function (e) {
        var tbd = $(this).parents("tbody");
        var tb = $(this).parents("table");
        $(this).parents("tr").remove();
        resetNameIndex(tbd);
        if (tb.hasClass("studenttb")) {
            $(".xfpbval").val("");
        }
    });
    $(document).on('change', '.zzsel', function (e) {
        if ($(this).val() == "0") {
            $(".zzsel").val("1");
            $(this).val("0");
        }
    });
    function saveModify() {
        var haveFzr = false;
        $(".zzsel").each(function (i, v) {
            if ($(v).val() == "0") {
                haveFzr = true;
                return;
            }
        });
        if (!haveFzr) {
            alertx("请选择负责人");
            return;
        }
        if (validate1.form()) {
            $("#saveBtn").removeAttr("onclick");
            $("#saveBtn").addClass("disabled");
            $("#inputForm").ajaxSubmit(function (data) {
                if (data.ret == "0") {
                    $("#saveBtn").attr("onclick", "saveModify();");
                    $("#saveBtn").removeClass("disabled");
                    alertx(data.msg);
                } else {
                    alertx(data.msg, function () {
                        history.go(-1);
                    });
                }
            });
        }
    }
    function selectUser(ob) {
        var c_btn = $(ob);
        var idsarr = [];
        c_btn.parents("table").find("tbody>tr").each(function (i, v) {
            idsarr.push($(v).attr("userid"));
        });
        var ids = idsarr.join(",");
        var userType = c_btn.attr("userType");
        var ititle = "选择学生";
        if (userType == '2') {
            ititle = "选择导师";
        }
        top.$.jBox.open('iframe:' + '/a/backUserSelect?ids=' + ids + '&userType=' + userType, ititle, 1100, 540, {
            buttons: {"确定": "ok", "关闭": true}, submit: function (v, h, f) {
                var temarr = [];
                $("input[name='boxTd']:checked", $(h.find("iframe")[0].contentDocument).find("iframe")[0].contentDocument)
                        .each(function (i, v) {
                            temarr.push($(v).val());
                        });
                if (v == "ok") {
                    addSelectUser(userType, temarr.join(","));
                    return true;
                }
            },
            loaded: function (h) {
                $(".jbox-content", top.document).css("overflow-y", "hidden");
            }
        });
    }
    function addSelectUser(usertype, ids) {
        if (ids != "") {
            if ("1" == usertype) {
                $.ajax({
                    type: "POST",
                    url: "/a/selectUser/getStudentInfo",
                    data: {ids: ids},
                    success: function (data) {
                        if (data) {
                            var datahtml = "";
                            var tpl = $("#tpl_st").html();
                            $.each(data, function (i, v) {
                                datahtml = datahtml + Mustache.render(tpl, {
                                            userId: v.userId,
                                            name: v.name,
                                            no: v.no,
                                            mobile: v.mobile,
                                            office: v.office,
                                            curJoin: v.curJoin
                                        });
                            });
                            $(".studenttb>tbody").append(datahtml);
                            resetNameIndex($(".studenttb>tbody"));
                        }
                    }
                });
            } else {
                $.ajax({
                    type: "POST",
                    url: "/a/selectUser/getTeaInfo",
                    data: {ids: ids},
                    success: function (data) {
                        if (data) {
                            var datahtml = "";
                            var tpl = $("#tpl_tea").html();
                            $.each(data, function (i, v) {
                                datahtml = datahtml + Mustache.render(tpl, {
                                            userId: v.userId,
                                            name: v.name,
                                            no: v.no,
                                            teacherType: v.teacherType,
                                            postTitle: v.postTitle,
                                            education: v.education,
                                            mobile: v.mobile,
                                            curJoin: v.curJoin
                                        });
                            });
                            $(".teachertb>tbody").append(datahtml);
                            resetNameIndex($(".teachertb>tbody"));
                        }
                    }
                });
            }
        }
    }
    function resetNameIndex(tbodyOb) {
        var indexNum = 0;
        var rex = "\\[(.+?)\\]";
        $(tbodyOb).find("tr").each(function (i, v) {
            $(v).find(".custindex").each(function (ti, tv) {
                var name = $(tv).attr("name");
                var indx = name.match(rex)[1];
                $(tv).attr("name", name.replace(indx, indexNum));
            });
            indexNum++;
        });
    }
    function submitData() {
        var haveFzr = false;
        $(".zzsel").each(function (i, v) {
            if ($(v).val() == "0") {
                haveFzr = true;
                return;
            }
        });
        if (!haveFzr) {
            alertx("请选择负责人");
            return;
        }
        if (validate.form()) {
            $("#submitBtn").removeAttr("onclick");
            $("#submitBtn").addClass("disabled");

            $("#inputForm").ajaxSubmit(function (data) {
                if (data.ret == "0") {
                    $("#submitBtn").attr("onclick", "submitData();");
                    $("#submitBtn").removeClass("disabled");



                    window.parent.sideNavModule.changeUnreadTag('${proModel.actYwId}');
                    window.parent.sideNavModule.changeStaticUnreadTag("/a/promodel/proModel/getTaskAssignCountToDo?actYwId=${proModel.actYwId}", 2500);


                    alertx(data.msg);
                } else {

                    alertx(data.msg, function () {
                        window.location.href = "/a/cms/form/queryMenuList/?actywId=${proModel.actYwId}";
                    });
                }
            });
        }else {
            validate.focusInvalid();
        }
    }
</script>
<script type="text/template" id="tpl_st">
    <tr userid="{{userId}}">
        <input type="hidden" class="custindex" name="studentList[custindex].userId" value="{{userId}}">
        <input type="hidden" class="custindex" name="studentList[custindex].utype" value="1">
        <td>{{name}}</td>
        <td>{{no}}</td>
        <td>{{office}}</td>
        <td>{{mobile}}</td>
        <td>{{email}}</td>
        <td>
        <select class="zzsel custindex" name="studentList[custindex].userzz">
        <option value="0">负责人
        </option>
        <option value="1" selected>组成员
        </option>
        </select>
        </td>
        <td>
            <a class="minus team-minus"></a>
        </td>
    </tr>
</script>
<script type="text/template" id="tpl_tea">
    <tr userid="{{userId}}">
        <input type="hidden" class="custindex" name="teacherList[custindex].userId" value="{{userId}}">
        <input type="hidden" class="custindex" name="teacherList[custindex].utype" value="2">
        <td>{{name}}</td>
        <td>{{no}}</td>
        <td>{{teacherType}}</td>
        <td>{{postTitle}}</td>
        <td>{{education}}</td>
        <td>{{mobile}}</td>
        <td>{{curJoin}}</td>

        <td>
            <a class="minus team-minus"></a>
        </td>
    </tr>
</script>
<script type="text/template" id="tpl_change_record">
    <tr userid="{{userId}}">
        <td>{{userName}}</td>
        <%--<td>{{role}}</td>--%>
        <td>{{content}}</td>
        <td>{{date}}</td>
    </tr>
</script>
</body>
</html>
