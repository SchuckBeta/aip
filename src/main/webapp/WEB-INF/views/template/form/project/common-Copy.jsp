<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <%@include file="/WEB-INF/views/include/treetable.jsp" %>
    <%@include file="/WEB-INF/views/include/treeview.jsp" %>
</head>
<body>
<ul class="nav nav-tabs">
    <%-- <li><a href="${ctx}/pw/pwRoom/list?pwSpace.id=${pwRoom.pwSpace.id}">房间列表</a></li> --%>
    <li><a href="${ctx}/pw/pwRoom/list">房间列表</a></li>
    <li class="active">
        <a href="${ctx}/pw/pwRoom/formSetZC?id=${pwRoom.id }">房间<shiro:hasPermission
                name="pw:pwRoom:edit">分配资产</shiro:hasPermission><shiro:lacksPermission
                name="pw:pwRoom:edit">查看</shiro:lacksPermission>
        </a>
    </li>
</ul>
<input id="pwRoomId" type="hidden" value="${pwRoom.id}">
<form:form id="inputForm" modelAttribute="pwRoom" action="${ctx}/pw/pwRoom/save" method="post"
           class="form-horizontal">
    <div class="control-group text-center">
        <label>${pwRoom.pwSpace.parent.parent.parent.name } / ${pwRoom.pwSpace.parent.parent.name }
            / ${pwRoom.pwSpace.parent.name } / ${pwRoom.pwSpace.name } / ${pwRoom.name }
            <c:if test="${not empty pwRoom.alias}">
            (${pwRoom.alias })
            </c:if>
            </label>
    </div>
    ${message}
    <sys:message content="${message}"/>
    <hr>
    <div class="controls" style="margin-left: 0">
        <div class="assets-wrap">
            <div class="assets-ztree">
                <div id="assetsTree" class="ztree"></div>
            </div>
            <div class="assets-table-tree">
                <iframe id="assetListFrame" src="${ctx}/pw/pwFassets/listYfp?pwRoom.id=${pwRoom.id }"></iframe>
            </div>
        </div>
    </div>
    </div>
    <div class="form-actions">
        <button id="saveAssets" type="button" class="btn btn-primary">分配</button>
        <a href="${ctx}/pw/pwRoom/list" class="btn btn-default">返回</a>
    </div>
</form:form>
<script>
    $(function () {
        var varXhx = "_";
        var $parentDoc = $(parent.document);
        $parentDoc.find('.sidebar, .layout-handler-bar').hide()
        $parentDoc.find('.room-list-content').css('margin-left', '0');

        $('#assetListFrame').css('height', $(window).height() - 250)

        var $assetsTree = $('#assetsTree');

        var assetsTree;

        getAssets();

        function getAssets() {
            var xhr = $.get(ctx + '/pw/pwCategory/treeData?isParent=true');
            xhr.success(function (data) {
                var dataRes = [];
                if (data.length > 0) {
                    var xhrFs = $.get(ctx + '/pw/pwFassets/treeDataAll');
                    xhrFs.success(function (dataFs) {
                        data.forEach(function (t) {
                            if (t.pId == 1) {
                                t.open = true;
                            }
                            dataRes.push(t)
                            if (dataFs.status) {

                                dataFs.datas.forEach(function (tFs) {

                                    if (t.id == tFs.pwCategory.id) {
                                        var curNode = {
                                            id: varXhx + tFs.id,
                                            isParent: false,
                                            name: tFs.name,
                                            pId: t.id,
                                            open: false
                                        };
                                        dataRes.push(curNode);
                                    }
                                });
                            }
                        });
                        assetsTree = $.fn.zTree.init($assetsTree, {
                            view: {
                                showIcon: true
                            },
                            check: {
                                enable: true
                            },
                            data: {simpleData: {enable: true, idKey: "id", pIdKey: "pId", rootPId: '1'}},
                            callback: {
                                onClick: function (event, treeId, treeNode, clickFlag) {


                                }
                            }
                        }, dataRes)
//                        assetsTree.expandAll(false)
                    })
                }
            })
        }


        $('#saveAssets').on('click', function () {
            var assetsTreeObj = $.fn.zTree.getZTreeObj("assetsTree");
            var nodes = assetsTreeObj.getCheckedNodes(true);
            var ids = [];

            nodes.forEach(function (item) {
                if (!item.isParent) {
                    ids.push(item.id.replace(varXhx, ''))
                }
            });

            var xhrFs = $.get(ctx + '/pw/pwFassets/ajaxSetPL?pwRoom.id=' + $("#pwRoomId").val() + '&id=' + ids.join(','));
            xhrFs.success(function (data) {
                if (data.status) {
//                    console.log(data)
                    resetTip();
                    location.reload()
                } else {
                    showTip(data.msg)
                }
            });


            return false;
        })


    })
</script>
</body>
</html>