<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>状态条件管理</title>
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
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>状态条件</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>


    <form:form id="searchForm" modelAttribute="actYwSgtype" action="${ctx}/actyw/actYwSgtype/" method="post"
               class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">名称</label>
                <div class="controls">
                    <form:input path="name" htmlEscape="false" maxlength="64" class="input-medium"/>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <button type="submit" class="btn btn-primary">查询</button>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable" class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th>名称</th>
            <th width="120">操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="actYwSgtype">
            <tr>
                <td><a href="${ctx}/actyw/actYwSgtype/form?id=${actYwSgtype.id}">
                        ${actYwSgtype.name}
                </a></td>
                <td>
                    <a class="btn-primary btn btn-small"
                       href="${ctx}/actyw/actYwSgtype/form?id=${actYwSgtype.id}&secondName=修改">修改</a>
                    <a class="btn-default btn btn-small"
                       href="${ctx}/actyw/actYwSgtype/delete?id=${actYwSgtype.id}"
                       onclick="return confirmx('确认要删除该状态条件吗？', this.href)">删除</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
</body>
</html>