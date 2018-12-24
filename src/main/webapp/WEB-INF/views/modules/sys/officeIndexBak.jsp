<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>机构管理</title>
    <%--<%@include file="/WEB-INF/views/include/backCommon.jsp" %>--%>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <%@include file="/WEB-INF/views/include/treeview.jsp" %>
</head>
<body>

<div class="container-fluid">
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <sys:message content="${message}"/>
    <div class="row-room organization-content">
        <div class="sidebar sidebar-floor">
            <div class="z-tree-body">
                <div id="ztree" class="ztree"></div>
            </div>

            <a class="btn-refresh pull-right" href="javascript:void (0)"></a>
        </div>


        <div class="layout-handler-bar"></div>
        <div class="room-list-content">
            <iframe id="officeContent" src="${ctx}/sys/office/list?id=&parentIds=" width="100%" height="100%"
                    frameborder="0"></iframe>
        </div>
    </div>
</div>

</div>
<script type="text/javascript">

    $(function () {
        var $layoutHandlerBar = $('.layout-handler-bar');
        var $btnRefresh = $('.btn-refresh');
        var $organizationContent = $('.organization-content');
        var setting = {
            data: {simpleData: {enable: true, idKey: "id", pIdKey: "pId", rootPId: '0'}},
            callback: {
                onClick: function (event, treeId, treeNode) {
                    var id = treeNode.pId == '0' ? '' : treeNode.pId;
                    $('#officeContent').attr("src", "${ctx}/sys/office/list?id=" + id + "&parentIds=" + treeNode.pIds);
                }
            }
        };
        $btnRefresh.on('click', function (e) {
            e.stopPropagation();
            e.preventDefault();
            $.getJSON("${ctx}/sys/office/treeData", function (data) {
                $.fn.zTree.init($("#ztree"), setting, data).expandAll(true);
            });
        }).click();

        if (!$layoutHandlerBar.hasClass('bar-close')) {
            $organizationContent.show()
        }
        $layoutHandlerBar.show();

        $('.room-list-content').css('margin-left', '');
    });


</script>
</body>
</html>