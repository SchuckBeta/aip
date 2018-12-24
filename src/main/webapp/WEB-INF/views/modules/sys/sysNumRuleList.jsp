<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
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
    <div class="edit-bar clearfix">
        <div class="edit-bar-left">
            <span>编号管理</span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <form:form id="searchForm" modelAttribute="sysNumRule"
               action="${ctx}/sys/sysNumRule/" method="post"
               class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden"
               value="${page.pageSize}"/>

        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">编号名称</label>
                <div class="controls">
                    <form:input path="name" htmlEscape="false" maxlength="32" class="input-medium"/>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <button type="submit" class="btn btn-primary">查询</button>
            <a class="btn btn-primary" href="${ctx}/sys/sysNumRule/form?type1='1'">添加规则</a>
        </div>
    </form:form>

    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th>编号名称</th>
            <th>所属编号类别</th>
            <th>前缀</th>
            <th>后缀</th>
            <th>日期</th>
            <th>时间</th>
            <th>开始序号</th>
            <th>编号位数</th>
            <shiro:hasPermission name="sys:sysNumRule:edit">
                <th width="120">操作</th>
            </shiro:hasPermission>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="sysNumRule">
            <tr>
                <td>${sysNumRule.name}</td>
                <td>${fns:getDictLabel(sysNumRule.type, 'sys_role_menu_type', '')}</td>
                <td>${sysNumRule.prefix}</td>
                <td>${sysNumRule.suffix}</td>
                <td>${sysNumRule.dateFormat}</td>
                <td>${sysNumRule.timieFormat}</td>
                <td>${sysNumRule.startNum}</td>
                <td>${sysNumRule.numLength}</td>
                <shiro:hasPermission name="sys:sysNumRule:edit">
                    <td>
                        <a href="${ctx}/sys/sysNumRule/form?id=${sysNumRule.id}" class="btn btn-small btn-primary">修改</a>
                        <a href="${ctx}/sys/sysNumRule/delete?id=${sysNumRule.id}"
                           onclick="return confirmx('确认要删除该编号规则吗？', this.href)" class="btn btn-small btn-default">删除</a>
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