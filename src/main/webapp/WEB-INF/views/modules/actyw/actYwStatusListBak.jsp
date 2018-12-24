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

        function editActYwStatus(id) {
            window.location.href = "${ctx}/actyw/actYwStatus/form?id=" + id+"&secondName=修改";
        }
    </script>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>网关节点状态</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <%--<ul class="nav nav-tabs nav-tabs-default">--%>
    <%--<li ><a href="${ctx}/actyw/actYw/list?group.flowType=${actYw.group.flowType}">--%>
    <%--项目流程列表</a></li>--%>
    <%--<li><a href="${ctx}/actyw/actYw/form?group.flowType=${actYw.group.flowType}">项目流程添加</a></li>--%>
    <%--<li class="active"><a href="${ctx}/actyw/actYwStatus">--%>
    <%--网关节点状态</a></li>--%>
    <%--</ul>--%>
    <form:form id="searchForm" modelAttribute="actYw" action="${ctx}/actyw/actYwStatus" method="post"
               class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="text-right mgb-20">
            <a class="btn btn-primary" href="${ctx}/actyw/actYwStatus/form?secondName=添加状态">添加状态</a>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-sort table-nowrap">
        <thead>
        <tr>
            <th>序号</th>
            <th>网关类别</th>
            <th>网关类型</th>
            <th>范围</th>
            <th>状态</th>
            <th>备注</th>
            <th width="120">操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="actYwStatus" varStatus="status">
            <tr>
                <td>
                        ${status.index+1}
                </td>
                <td>
                        ${actYwStatus.name}
                </td>
                <td>
                    <c:forEach var="item" items="${regTypes}">
                        <c:if test="${actYwStatus.regType eq item.id}">${item.name }</c:if>
                    </c:forEach>
                </td>
                <td>
                        ${actYwStatus.alias}
                </td>
                <td>
                        ${actYwStatus.state}
                </td>
                <td>
                        ${actYwStatus.remarks}
                </td>
                <td>
                    <a class="btn btn-small btn-primary"
                       onclick="editActYwStatus('${actYwStatus.id}')">修改</a>
                    <a class="btn btn-small btn-default"
                       href="${ctx}/actyw/actYwStatus/delete?id=${actYwStatus.id}"
                       onclick="return confirmx('确认要删除该类别吗？', this.href)">删除</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
</body>
</html>