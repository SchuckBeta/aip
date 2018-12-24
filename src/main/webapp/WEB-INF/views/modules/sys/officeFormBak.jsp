<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#inputForm").validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorPlacement: function (error, element) {
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });
        });
    </script>
</head>
<body>
<%--<div class="container-fluid">--%>
    <ul class="nav nav-tabs">
        <li><a href="${ctx}/sys/office/list?id=${office.parent.id}&parentIds=${office.parentIds}">机构列表</a></li>
        <li class="active"><a
                href="${ctx}/sys/office/form?id=${office.id}&parent.id=${office.parent.id}">机构<shiro:hasPermission
                name="sys:office:edit">${not empty office.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission
                name="sys:office:edit">查看</shiro:lacksPermission></a></li>
    </ul>
    <sys:message content="${message}"/>
    <form:form id="inputForm" modelAttribute="office" action="${ctx}/sys/office/save" method="post"
               class="form-horizontal">
        <form:hidden path="id"/>
        <div class="control-group">
            <label class="control-label">上级机构:</label>
            <div class="controls">
                <sys:treeselect id="office" name="parent.id" value="${office.parent.id}" labelName="parent.name"
                                labelValue="${office.parent.name}"
                                title="机构" url="/sys/office/treeData" extId="${office.id}" cssStyle="width: 175px;"
                                allowClear="${office.currentUser.admin}"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><i>*</i>机构名称:</label>
            <div class="controls">
                <form:input path="name" htmlEscape="false" maxlength="50" class="required"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">机构编码:</label>
            <div class="controls">
                <form:input path="code" htmlEscape="false" maxlength="50"/>
            </div>
        </div>
        <c:if test="${office.id eq '1'}">
        <div class="control-group">
            <label class="control-label">城市编码:</label>
            <div class="controls">
                <form:input path="cityCode" htmlEscape="false" maxlength="50"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">高校代码:</label>
            <div class="controls">
                <form:input path="schoolCode" htmlEscape="false" maxlength="50"/>
            </div>
        </div>
        </c:if>
        <div class="form-actions">
            <shiro:hasPermission name="sys:office:edit">
                <button type="submit" class="btn btn-primary">保存</button>
            </shiro:hasPermission>
            <button type="button" class="btn btn-default" onclick="history.go(-1)">返回</button>
        </div>
    </form:form>
<%--</div>--%>
</body>
</html>