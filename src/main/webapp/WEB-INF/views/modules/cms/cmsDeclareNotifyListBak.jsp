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
        function updaterelease(url, id) {
            $.ajax({
                type: 'post',
                url: url,
                data: {
                    id: id
                },
                success: function (data) {
                    if (data.ret == "1") {
                        location.reload();
                    } else {
                        alertx(data.msg);
                    }
                }
            });
        }
        function release(id) {
            var url = "/a/cms/cmsDeclareNotify/release";
            updaterelease(url, id);
        }
        function unrelease(id) {
            var url = "/a/cms/cmsDeclareNotify/unrelease";
            updaterelease(url, id);
        }
    </script>

</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>申报通知</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" modelAttribute="cmsDeclareNotify" action="${ctx}/cms/cmsDeclareNotify/list" method="post"
               class="form-horizontal clearfix form-search-block" autocomplete="off">
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
            <a class="btn btn-primary" href="${ctx}/cms/cmsDeclareNotify/form">添加</a>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th width="40%">标题</th>
            <th>通知类型</th>
            <th>发布</th>
            <th>发布时间</th>
            <th width="200">操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="hot">
            <tr>
                <td>${fns:abbr(hot.title,50)}</td>
                <td>
                        ${fns:getDictLabel(hot.type, '0000000259', '')}
                </td>
                <td>${fns:getDictLabel(hot.isRelease, 'yes_no', '')}
                </td>
                <td><c:if test="${hot.isRelease=='1'}"><fmt:formatDate value="${hot.releaseDate}" pattern="yyyy-MM-dd"/></c:if></td>
                <td>
                    <a href="${ctx}/cms/cmsDeclareNotify/form?id=${hot.id}" class="btn btn-primary btn-small">修改</a>
                    <c:if test="${hot.isRelease=='0'}"><a href="javascript:void(0)" onclick="release('${hot.id}')"
                                                          class="btn btn-primary btn-small">发布</a></c:if>
                    <c:if test="${hot.isRelease=='1'}"><a href="javascript:void(0)" onclick="unrelease('${hot.id}')"
                                                          class="btn btn-default btn-small">取消发布</a></c:if>
                    <a href="${ctx}/cms/cmsDeclareNotify/delete?id=${hot.id}"
                       onclick="return confirmx('确认要删除吗？', this.href)" class="btn btn-default btn-small">删除</a>

                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>

</body>
</html>