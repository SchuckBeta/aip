<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#ps").val($("#pageSize").val());
        });
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }
    </script>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>通告发布</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" modelAttribute="oaNotify" action="${ctx}/oa/oaNotify/broadcastList" method="post"
               class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">标题</label>
                <div class="controls">
                    <form:input path="title" htmlEscape="false" maxlength="200" class="input-medium"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">类型</label>
                <div class="controls">
                    <form:select path="type" class="input-medium">
                        <form:option value="" label="请选择"/>
                        <form:options items="${fns:getDictList('oa_notify_type')}" itemLabel="label" itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group" style="margin-right: 120px;">
                <label class="control-label">状态</label>
                <div class="controls controls-radio">
                    <form:radiobuttons path="status" items="${fns:getDictList('oa_notify_status')}" itemLabel="label"
                                       itemValue="value" htmlEscape="false"/>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <button class="btn btn-primary" type="submit">查询</button>
            <a class="btn btn-primary" href="${ctx}/oa/oaNotify/allNoticeForm">添加</a>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th width="30%">标题</th>
            <th>类型</th>
            <th>状态</th>
            <th>发送人</th>
            <th>发布时间</th>
            <th width="150">操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="oaNotify">
            <tr>
                <td>
                        ${fns:abbr(oaNotify.title,50)}
                </td>
                <td>
                    <c:choose>
                        <c:when test="${oaNotify.sendType eq '2'}">
                            站内信
                        </c:when>
                        <c:otherwise>
                            ${fns:getDictLabel(oaNotify.type, 'oa_notify_type', '')}
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>${fns:getDictLabel(oaNotify.status, 'oa_notify_status', '')}
                </td>
                <td>
                        ${fns:getUserById(oaNotify.createBy.id).getName()}
                </td>
                <td><fmt:formatDate value="${oaNotify.updateDate}" pattern="yyyy-MM-dd"/></td>
                <td>
                    <c:choose>
                        <c:when test="${oaNotify.status eq '1'}">
                            <a href="${ctx}/oa/oaNotify/ajaxDeploy?id=${oaNotify.id}&status=0"
                                   class="btn btn-primary btn-small">取消</a>
                            <c:if test="${oaNotify.sendType eq '2'}">
                                <a href="${ctx}/oa/oaNotify/formBroadcast?id=${oaNotify.id}"
                                   class="btn btn-primary btn-small">查看</a>
                            </c:if>
                            <c:if test="${oaNotify.sendType ne '2'}">
                                <a href="${ctx}/oa/oaNotify/allNoticeForm?id=${oaNotify.id}"
                                   class="btn btn-primary btn-small">查看</a>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <a href="${ctx}/oa/oaNotify/ajaxDeploy?id=${oaNotify.id}&status=1"
                                   class="btn btn-primary btn-small">发布</a>
                            <c:if test="${oaNotify.sendType eq '2'}">
                                <a href="${ctx}/oa/oaNotify/formBroadcast?id=${oaNotify.id}"
                                   class="btn btn-primary btn-small">修改</a>
                            </c:if>
                            <c:if test="${oaNotify.sendType ne '2'}">
                                <a href="${ctx}/oa/oaNotify/allNoticeForm?id=${oaNotify.id}"
                                   class="btn btn-primary btn-small">修改</a>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                    <a href="${ctx}/oa/oaNotify/delete?id=${oaNotify.id}"
                       onclick="return confirmx('确认要删除该通告吗？', this.href)" class="btn btn-default btn-small">删除</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
</body>
</html>