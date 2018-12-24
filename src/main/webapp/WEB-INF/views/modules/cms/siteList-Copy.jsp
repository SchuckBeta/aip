<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroupTitle}</title>
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
            <%--<span>站点管理</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" modelAttribute="site" action="${ctx}/cms/site/" method="post"
               class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>

        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">名称</label>
                <div class="controls">
                    <form:input path="name" htmlEscape="false" maxlength="50" class="input-medium"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">状态</label>
                <div class="controls controls-radio">
                    <form:radiobuttons onclick="$('#searchForm').submit();" path="delFlag"
                                       items="${fns:getDictList('del_flag')}" itemLabel="label" itemValue="value"
                                       htmlEscape="false"/>
                </div>
            </div>
        </div>

        <div class="search-btn-box">
            <button class="btn btn-primary" type="submit">查询</button>
            <%-- <a class="btn btn-primary" href="${ctx}/cms/site/form">添加</a> --%>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th width="25%">名称</th>
            <th>标题</th>
            <th>描述</th>
            <th>关键字</th>
            <th>主题</th>
            <shiro:hasPermission name="cms:site:edit">
                <th width="120">操作</th>
            </shiro:hasPermission></tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="site">
            <tr>
                <td><a href="${ctx}/cms/site/form?id=${site.id}" title="${site.name}">${fns:abbr(site.name,40)}</a></td>
                <td>${fns:abbr(site.title,40)}</td>
                <td>${fns:abbr(site.description,40)}</td>
                <td>${fns:abbr(site.keywords,40)}</td>
                <td>${site.theme}</td>
                <shiro:hasPermission name="cms:site:edit">
                    <td>
                        <a href="${ctx}/cms/site/form?id=${site.id}" class="btn btn-primary btn-small">修改</a>
                        <c:if test="${site.id ne root}">
	                       	<a href="${ctx}/cms/site/delete?id=${site.id}${site.delFlag ne 0?'&isRe=true':''}"
	                           class="btn btn-default btn-small" onclick="return confirmx('确认要${site.delFlag ne 0?'恢复':''}删除该站点吗？', this.href)">${site.delFlag ne 0?'恢复':''}删除</a>
                        </c:if>
                    </td>
                </shiro:hasPermission>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>

</body>
</html>