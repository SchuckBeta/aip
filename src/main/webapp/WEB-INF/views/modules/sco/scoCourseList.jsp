<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${backgroundTitle}</title>
    <%@ include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript">
        $(function () {
            $("#ps").val($("#pageSize").val());
        });
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $('#form-search-bar').submit()
            return false;
        }
        function setV(id, cname) {
            location.href = "${ctx}/sco/scoAffirmCriterionCouse/form?foreign_id=" + id + "&fromPage=scoCourse&cname=" + encodeURIComponent(cname);
        }
    </script>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>课程学分认定标准</span> <i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <sys:message content="${message}"/>
    <form id="form-search-bar" class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="text-right mgb-20">
            <button type="button" class="btn btn-primary" onclick="location.href='${ctx}/sco/scoCourse/form'">创建课程
            </button>
        </div>
    </form>
    <table class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th>课程代码</th>
            <th width="25%">课程名</th>
            <th>课程类型</th>
            <th>课程性质</th>
            <th>计划学分</th>
            <th>计划课时</th>
            <th>合格成绩</th>
            <th width="210">操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="course">
            <tr>
                <td>${course.code }</td>
                <td>${course.name }</td>
                <td>${fns:getDictLabel(course.type, '0000000102', '')}</td>
                <td>${fns:getDictLabel(course.nature, '0000000108', '')}</td>
                <td>${course.planScore }</td>
                <td>${course.planTime }</td>
                <td>${course.overScore }</td>
                <td>
                    <button type="button" class="btn btn-primary btn-small"
                            onclick="setV('${course.id}','${course.name }')">设置认定标准
                    </button>
                    <button type="button" class="btn btn-primary btn-small"
                            onclick="location.href='${ctx}/sco/scoCourse/form?id=${course.id}'">编辑
                    </button>
                    <button type="button" class="btn btn-small btn-default"
                            onclick="return confirmx('确认要删除吗？', function(){location.href='${ctx}/sco/scoCourse/delete?id=${course.id}'})">
                        删除
                    </button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
</body>
</html>