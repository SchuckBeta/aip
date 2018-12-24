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
    <div class="edit-bar clearfix">
        <div class="edit-bar-left">
            <span>流程表单</span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <form:form id="searchForm" modelAttribute="actYwForm" action="${ctx}/actyw/actYwForm/" method="post"
               class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">表单组</label>
                <div class="controls">
                    <form:select id="theme" path="theme" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${formThemes}" itemLabel="name" itemValue="id" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <%-- <div class="control-group">
                <label class="control-label">流程类型</label>
                <div class="controls">
                    <form:select id="flowType" path="flowType" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('act_category')}" itemLabel="label" itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div> --%>
            <div class="control-group">
                <label class="control-label">流程类型</label>
                <div class="controls">
                    <form:select id="flowType" path="flowType" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${flowTypes}" itemLabel="name" itemValue="key" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">表单类型</label>
                <div class="controls">
                    <form:select id="formType" path="type" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${formTypeEnums}" itemLabel="name" itemValue="key" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">样式类型</label>
                <div class="controls">
                    <form:select id="formStyleType" path="styleType" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${formStyleTypeEnums}" itemLabel="name" itemValue="key"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">客户端类型</label>
                <div class="controls">
                    <form:select id="formClientType" path="clientType" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${formClientTypeEnums}" itemLabel="name" itemValue="key"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group"  style="margin-right: 120px;">
                <label class="control-label">审核类型</label>
                <div class="controls">
                    <form:select id="sgtype" path="sgtype" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${regTypes}" itemLabel="name" itemValue="id" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <%--<div class="control-group" style="margin-right: 120px;">--%>
                <%--<label class="control-label">模式</label>--%>
                <%--<div class="controls">--%>
                    <%--<form:select path="model" class="input-medium">--%>
                        <%--<form:option value="" label="--请选择--"/>--%>
                        <%--<form:options items="${fns:getDictList('act_form_tpltype')}" itemLabel="label" itemValue="value"--%>
                                      <%--htmlEscape="false"/>--%>
                    <%--</form:select>--%>
                <%--</div>--%>
            <%--</div>--%>
        </div>
        <div class="search-btn-box">
            <a class="btn btn-primary" href="${ctx}/actyw/actYwForm/form">添加</a>
            <button type="submit" class="btn btn-primary">查询</button>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable" class="table table-bordered table-condensed table-hover table-center table-orange">
        <thead>
        <tr>
            <th>表单组</th>
            <th>流程类型</th>
            <%--<th>项目类型</th>--%>
            <th>表单名称</th>
            <th>表单类型</th>
            <th>当前、列表模板路径</th>
            <th>客户端</th>
            <th>审核类型</th>
        <%--<th>模式</th>--%>
            <%--<th>模板参数</th>--%>
            <!-- <th>所属机构</th> -->
            <%--<th>最后更新时间</th>--%>
            <%--<th>备注</th>--%>
            <shiro:hasPermission name="actyw:actYwForm:edit">
                <th width="114">操作</th>
            </shiro:hasPermission>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="actYwForm">
            <tr>
                <td>
                    <a href="${ctx}/actyw/actYwForm/form?id=${actYwForm.id}">
                        <c:forEach var="item" items="${formThemes}">
                            <c:if test="${actYwForm.theme eq item.id}">${item.name }</c:if>
                        </c:forEach>
                    </a>
                </td>
                <td>
                    <a href="${ctx}/actyw/actYwForm/form?id=${actYwForm.id}">
                        <c:forEach var="curflowType" items="${actYwForm.flowTypes }" varStatus="idx">
                            ${fns:getDictLabel(curflowType, 'act_category', '')}
                            <c:if test="${(idx.index+1) ne fn:length(actYwForm.flowTypes)}">
                                <c:if test="${(idx.index+1) % 2 == 1}">|</c:if>
                            </c:if>
                            <c:if test="${(idx.index+1) % 2 == 0}"><br></c:if>

                        </c:forEach>
                    </a>
                </td>
                <%--<td>--%>
                    <%--<a href="${ctx}/actyw/actYwForm/form?id=${actYwForm.id}">--%>
                        <%--<c:forEach var="item" items="${actYwForm.proTypes}" varStatus="idx">--%>
                            <%--<c:if test="${(idx.index + 1) ne fn:length(actYwForm.proTypes)}">${fns:getDictLabel(item, 'act_project_type', '')}/</c:if>--%>
                            <%--<c:if test="${(idx.index + 1)  eq fn:length(actYwForm.proTypes)}">${fns:getDictLabel(item, 'act_project_type', '')}</c:if>--%>
                        <%--</c:forEach>--%>
                    <%--</a>--%>
                <%--</td>--%>
                <td>
                        ${actYwForm.name}
                </td>
                <td>
                    <c:forEach var="item" items="${formTypeEnums}">
                        <c:if test="${actYwForm.type eq item.key}">${item.name }</c:if>
                    </c:forEach>
                </td>
                <td style="text-align: left;">
                        <%-- ${actYwForm.name}&nbsp;&nbsp;&nbsp;&nbsp; --%>当前：${fns:substringAfterLast(actYwForm.path, 'form/')}
                    <br>列表：<%-- ${actYwForm.listForm.name}&nbsp;&nbsp;&nbsp;&nbsp; --%>${fns:substringAfterLast(actYwForm.listForm.path, 'form/')}
                </td>
                <td>
                    <c:forEach var="item" items="${formClientTypeEnums}">
                        <c:if test="${actYwForm.clientType eq item.key}">${item.name }</c:if>
                    </c:forEach>
                </td>
                <td>
                    <c:forEach var="item" items="${regTypes}">
                        <c:if test="${actYwForm.sgtype eq item.id}">${item.name }</c:if>
                    </c:forEach>
                </td>

                <%--<td>--%>
                        <%--${fns:getDictLabel(actYwForm.model, 'act_form_tpltype', '')}--%>
                <%--</td>--%>
                    <%--<td>--%>
                    <%--${actYwForm.params}--%>
                    <%--</td>--%>
                    <%-- <td>
                        ${actYwForm.office.name}
                    </td> --%>
                <%--<td>--%>
                    <%--<fmt:formatDate value="${actYwForm.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>--%>
                <%--</td>--%>
                <%--<td>--%>
                        <%--${actYwForm.remarks}--%>
                <%--</td>--%>
                <shiro:hasPermission name="actyw:actYwForm:edit">
                    <td>
                        <a class="btn btn-primary btn-small"
                           href="${ctx}/actyw/actYwForm/form?id=${actYwForm.id}">修改</a>
                        <a class="btn btn-default btn-small"
                           href="${ctx}/actyw/actYwForm/delete?id=${actYwForm.id}"
                           onclick="return confirmx('确认要删除该流程表单吗？', this.href)">删除</a>
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