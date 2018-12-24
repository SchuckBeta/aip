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
    <%--<div class="edit-bar edit-bar-tag clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>课程管理</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" modelAttribute="course" action="${ctx}/course/list" method="post"
               class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>

        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">课程分类</label>
                <div class="controls">
                    <form:select path="categoryId" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('0000000086')}" itemLabel="label" itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">类型分类</label>
                <div class="controls">
                    <form:select path="type" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('0000000078')}" itemLabel="label" itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">状态分类</label>
                <div class="controls">
                    <form:select path="status" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('0000000082')}" itemLabel="label" itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group" style="margin-right: 290px;">
                <label class="control-label">是否发布</label>
                <div class="controls">
                    <form:select path="publishFlag" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <form:input path="name" htmlEscape="false" maxlength="200" class="input-medium"
                        placeholder='名称或授课教师'/>
            <button class="btn btn-primary" type="submit">查询</button>
            <a class="btn btn-primary" href="${ctx}/course/form">添加</a>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap table-sort">
        <thead>
        <tr>
            <th width="30%">名称</th>
            <th>授课教师</th>
            <th>专业课程分类</th>
            <th>课程类型分类</th>
            <th>状态分类</th>
            <th>是否发布</th>
            <th>是否置顶</th>
            <th>发布时间</th>
            <th width="110">操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="course">
            <tr>
                <td>
                        ${fns:abbr(course.name,50)}
                </td>
                <td>
                        ${course.teacherNames}
                </td>
                <td>
                        ${course.categoryNames}
                </td>
                <td>
                        ${fns:getDictLabel(course.type, '0000000078', '')}
                </td>
                <td>
                        ${fns:getDictLabel(course.status, '0000000082', '')}
                </td>
                <td>
                        ${fns:getDictLabel(course.publishFlag,"yes_no" , "")}
                </td>
                <td>
                        ${fns:getDictLabel(course.topFlag,"yes_no" , "")}
                </td>
                <td>
                    <fmt:formatDate value="${course.publishDate}" pattern="yyyy-MM-dd"/>
                </td>
                <td>
                    <a href="${ctx}/course/form?id=${course.id}" class="btn btn-primary btn-small">修改</a>
                    <a href="${ctx}/course/delete?id=${course.id}" class="btn btn-default btn-small"
                       onclick="return confirmx('确认要删除该课程吗？', this.href)">删除</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
</body>
</html>