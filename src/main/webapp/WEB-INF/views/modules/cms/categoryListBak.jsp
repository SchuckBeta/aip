<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <!-- <meta name="decorator" content="default"/> -->
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <%@include file="/WEB-INF/views/include/treetable.jsp" %>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#treeTable").treeTable({expandLevel: 2});
        });
        function updateSort() {
            loading('正在提交，请稍等...');
            $("#listForm").attr("action", "${ctx}/cms/category/updateSort");
            $("#listForm").submit();
        }
    </script>

</head>

<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>栏目管理</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <div class="text-right mgb-20">
        <a class="btn btn-primary" href="${ctx}/cms/category/form">栏目添加</a>
    </div>
    <sys:message content="${message}"/>
    <form id="listForm" method="post">
        <table id="treeTable"
               class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
            <thead>
            <tr>
                <th>栏目名称</th>
                <%--<th>链接</th>--%>
                <th>归属机构</th>
                <th>栏目模型</th>
                <th style="text-align:center;">排序</th>
                <th title="是否在导航中显示该栏目">导航菜单</th>
                <th title="是否在分类页中显示该栏目的文章列表">栏目列表</th>
                <th>展现方式</th>
                <th width="205">操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${list}" var="tpl">
                <tr id="${tpl.id}" pId="${tpl.parent.id ne '1'?tpl.parent.id:'0'}">
                    <td style="text-align:left">
                        <a href="${ctx}/cms/category/form?id=${tpl.id}">${tpl.name}</a></td>
                        <%--<td style="text-align:left;">${tpl.href}</td>--%>
                    <td>${tpl.office.name}</td>
                    <td>${fns:getDictLabel(tpl.module, 'cms_module', '公共模型')}</td>
                    <td>
                        <shiro:hasPermission name="cms:category:edit">
                            <input type="hidden" name="ids" value="${tpl.id}"/>
                            <input name="sorts" type="text" value="${tpl.sort}" class="input-mini text-center"
                                   style="margin-bottom: 0">
                        </shiro:hasPermission><shiro:lacksPermission name="cms:category:edit">
                        ${tpl.sort}
                    </shiro:lacksPermission>
                    </td>
                    <td>${fns:getDictLabel(tpl.inMenu, 'show_hide', '隐藏')}</td>
                    <td>${fns:getDictLabel(tpl.inList, 'show_hide', '隐藏')}</td>
                    <td>${fns:getDictLabel(tpl.showModes, 'cms_show_modes', '默认展现方式')}</td>
                    <td>
                            <%-- <a href="${pageContext.request.contextPath}${fns:getFrontPath()}/list-${tpl.id}${fns:getUrlSuffix()}" class="btn" target="_blank">访问</a> --%>
                        <shiro:hasPermission name="cms:category:edit">
                            <c:if test="${tpl.parent.id ne '1'}">
                                <a href="${ctx}/cms/category/form?id=${tpl.id}" class="btn btn-primary btn-small">修改</a>
                                <a href="${ctx}/cms/category/delete?id=${tpl.id}" class="btn btn-default btn-small"
                                   onclick="return confirmx('要删除该栏目及所有子栏目项吗？', this.href)">删除</a>
                            </c:if>
                            <a href="${ctx}/cms/category/form?parent.id=${tpl.id}" class="btn btn-primary btn-small">添加下级栏目</a>
                        </shiro:hasPermission>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <shiro:hasPermission name="cms:category:edit">
            <div class="text-right">
                <button class="btn btn-primary" type="button" onclick="updateSort();">保存排序</button>
            </div>
        </shiro:hasPermission>
    </form>
</div>
</body>
</html>