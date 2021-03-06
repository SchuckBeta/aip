<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
        <script type="text/javascript">
    $frontOrAdmin="${frontOrAdmin_2ed8fe6ddd034cffa47a41e42a694948}";
    </script>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript">
        $(document).ready(function () {
            //左侧菜单加入数字
            $('#sub_list_wrap', window.parent.document).find('li a').each(function () {
                var hrefReg = $(this).attr('href');
                var count = "${page.todoCount}";
                if (hrefReg.indexOf("assessList") != -1) {
                    if (count > 0) {
                        if (count > 99) {
                            //count = "99+";
                        }
                        if ($(this).find('i').size() > 0) {
                            $(this).find('i').text(count);
                        } else {
                            $(this).append('<i class="unread-tag" style="box-sizing: border-box">' + count + '</i>');
                        }
                    } else {
                        $(this).find('i').detach();
                    }
                    window.parent.sideNavModule.changeTotalUnreadTag($(this).parents(".submenu")[0]);
                    return false;
                }
            });
            $("#ps").val($("#pageSize").val());
        });
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }

        function claim(taskId) {
            $.get('${ctx}/act/task/claim', {taskId: taskId}, function (data) {
                top.$.jBox.tip('签收完成');
                location.reload();
            });
        }
    </script>
</head>
<body>
<div class="container-fluid">
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>

    <form:form id="searchForm" modelAttribute="projectDeclare" action="${ctx}/state/assessList" method="post"
               class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>

        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">项目编号</label>
                <div class="controls">
                    <form:input type="text" path="number" cssClass="form-control input-medium"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">项目名称</label>
                <div class="controls">
                    <form:input type="text" path="name" cssClass="form-control input-medium"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">项目类别</label>
                <div class="controls">
                    <form:select path="type" cssClass="form-control input-medium">
                        <form:option value="" label="所有项目类别"/>
                        <form:options items="${fns:getDictList('project_type')}" itemLabel="label"
                                      itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">项目级别</label>
                <div class="controls">
                    <form:select path="level" cssClass="form-control input-medium">
                        <form:option value="" label="请选择"/>
                        <form:options items="${fns:getDictList('project_degree')}" itemLabel="label"
                                      itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">负责人</label>
                <div class="controls">
                    <form:input type="text" path="leader" cssClass="form-control input-medium"/>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <button id="btnSubmit" class="btn btn-primary" type="submit">查询</button>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap table-sort">
        <thead>
        <tr>
            <th width="151">项目编号</th>
            <th width="25%">项目名称</th>
            <th>项目类别</th>
            <th>负责人</th>
            <th>组人数</th>
            <th>指导老师</th>
            <th>项目级别</th>
            <th>项目结果</th>
            <th>年份</th>
            <th>项目审核状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="proDeclare">
            <tr>
                <td>${proDeclare.number}</td>
                <td>
                    <a href="${ctx}/state/infoView?id=${proDeclare.id}&taskDefinitionKey=${proDeclare.act.histTask.taskDefinitionKey}">${proDeclare.name}</a>
                </td>
                <td>
                    ${fns:getDictLabel(proDeclare.type, "project_type", "")}
                </td>
                <td>
                    ${proDeclare.leaderString}
                </td>
                <td>
                    ${proDeclare.snumber}
                </td>
                <td>
                    ${proDeclare.tnames}
                </td>
                <td>
                    ${fns:getDictLabel(proDeclare.level, "project_degree", "")}
                </td>
                <td>
                    ${proDeclare.finalResultString}
                    <%--${fns:getDictLabel(pj:getById(proDeclare.id).finalResult, "project_result", "")}--%>
                </td>
                <td>
                    ${proDeclare.year}
                </td>
                <td>
                    <c:if test="${proDeclare.state=='todo'||proDeclare.state=='claim'}">
                        <c:set var="projectDeclare" value="${pj:getProjectDeclareListVoById(proDeclare.id)}"/>
                        <%-- <a href="${ctx}/act/task/processMap?procDefId=${act.task.processDefinitionId}&proInstId=${act.task.processInstanceId}" target="_blank">待${act.taskName}</a> --%>
                        <a href="${ctx}/actyw/actYwGnode/designView/${projectDeclare.status_code}?groupId=${projectDeclare.groupId}"
                           target="_blank">
                                ${pj:getAuditStatus(projectDeclare.status_code)}
                        </a>
                    </c:if>
                    <c:if test="${proDeclare.state=='finish'}">
                        <c:set var="projectDeclare" value="${pj:getProjectDeclareListVoById(proDeclare.id)}"/>
                        ${pj:getAuditStatus(projectDeclare.status_code)}
                    </c:if>
                </td>
                <td>
                    <c:if test="${proDeclare.state=='claim'}">
                        <a class="btn btn-primary btn-small" href="javascript:void(0)"
                           onclick="claim('${proDeclare.act.task.id}');">签收</a>
                    </c:if>
                    <c:if test="${proDeclare.state =='todo'}">
                        <button type="button" class="btn btn-primary btn-small"
                                onclick='location.href="${ctx}/act/task/form?taskId=${proDeclare.act.task.id}&taskName=${fns:urlEncode(proDeclare.act.task.name)}&taskDefKey=${proDeclare.act.task.taskDefinitionKey}&procInsId=${proDeclare.act.task.processInstanceId}&procDefId=${proDeclare.act.task.processDefinitionId}&status=${proDeclare.state}"'>
                            结果评定
                        </button>
                    </c:if>
                    <c:if test="${proDeclare.state=='finish'}">
                        <a class="btn btn-primary btn-small"
                           href="${ctx}/state/infoView?id=${proDeclare.id}&taskDefinitionKey=${proDeclare.act.histTask.taskDefinitionKey}">查看</a>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
</body>
</html>