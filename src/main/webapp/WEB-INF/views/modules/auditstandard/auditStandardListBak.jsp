<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${backgroudTitle}</title>
    <%@ include file="/WEB-INF/views/include/backcyjd.jsp" %>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#ps").val($("#pageSize").val());
        });
        function page(n, s) {
            location.href = "/a/auditstandard/auditStandard?pageNo=" + n + "&pageSize=" + s;
        }
    </script>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>自定义审核标准</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <sys:message content="${message}"/>
    <form:form id="form-search-bar" class="form-horizontal clearfix form-search-block" autocomplete="off">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="text-right mgb-20">
            <a class="btn btn-primary"
               href="${ctx}/auditstandard/auditStandard/form?id=${conf.id}">新建评审标准
            </a>
            <a class="btn btn-primary"
               href="${ctx}/auditstandard/auditStandard/listFlow">关联项目
            </a>
        </div>
    </form:form>
    <table class="table table-bordered table-condensed table-hover table-center table-orange">
        <thead>
        <tr>
            <th width="150">评审标准</th>
            <th>评审标准说明</th>
            <th width="100">操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="sta">
            <tr>
                <td>${sta.name }</td>
                <td>${sta.remarks }</td>
                <td>
                    <a class="btn btn-primary btn-small"
                       onclick="javascript:location.href='${ctx}/auditstandard/auditStandard/form?id=${sta.id}&secondName=编辑'">编辑</a>
                    <a class="btn btn-default btn-small"
                       onclick="javascript:return confirmx('确认要删除吗？', function(){location.href='${ctx}/auditstandard/auditStandard/delete?id=${sta.id}'})">删除</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
</body>
</html>