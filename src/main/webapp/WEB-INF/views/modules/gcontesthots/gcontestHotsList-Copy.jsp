<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <title>${backgroudTitle}</title>
    <link rel="stylesheet" type="text/css" href="/static/common/tablepage.css"/>

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
            <%--<span>大赛热点</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" modelAttribute="gcontestHots" action="${ctx}/gcontesthots/list" method="post"
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
        </div>
        <div class="search-btn-box">
            <button class="btn btn-primary" type="submit">查询</button>
            <a class="btn btn-primary" href="${ctx}/gcontesthots/form">添加</a>
        </div>

    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th width="30%">标题</th>
            <th>来源</th>
            <th>发布</th>
            <th>置顶</th>
            <th>发布时间</th>
            <th width="120">操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="hot">
            <tr>
                <td>${fns:abbr(hot.title,50)}</td>
                <td>${fns:abbr(hot.source,50)}</td>
                <td>${fns:getDictLabel(hot.isRelease, 'yes_no', '')}
                </td>
                <td>
                        ${fns:getDictLabel(hot.isTop, 'yes_no', '')}
                </td>
                <td><fmt:formatDate value="${hot.releaseDate}" pattern="yyyy-MM-dd"/></td>
                <td>
                    <a href="${ctx}/gcontesthots/form?id=${hot.id}" class="btn btn-small btn-primary">修改</a>
                    <a href="${ctx}/gcontesthots/delete?id=${hot.id}" onclick="return confirmx('确认要删除吗？', this.href)"
                       class="btn btn-small btn-primary">删除</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
</body>
</html>