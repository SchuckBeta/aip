<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
</head>
<body>
<div class="container-fluid">
    <sys:message content="${message}"/>
    <form:form id="inputForm" class="form-horizontal form-search-block" modelAttribute="pwRoom"
               action="${ctx}/pw/pwRoom/save" method="post">
        <form:hidden id="roomId" path="id"/>
        <div class="edit-bar edit-bar-sm clearfix" style="margin-top: 0">
            <div class="edit-bar-left">
                <span>房间基本信息</span>
                <i class="line"></i>
            </div>
        </div>
        <div class="row row-info-panel">
            <div class="span6">
                <span class="label-span">名称：</span>${pwRoom.name}
                <c:if test="${not empty pwRoom.alias}">
                (${pwRoom.alias})
                </c:if>
            </div>
            <div class="span6">
                <span class="label-span">人数：</span>${pwRoom.num }人
            </div>
        </div>
        <div class="row row-info-panel">
            <div class="span6">
                <span class="label-span">负责人：</span>${pwRoom.person }
            </div>
            <div class="span6">
                <span class="label-span">电话：</span>${pwRoom.mobile }/${pwRoom.phone }
            </div>
        </div>
        <div class="edit-bar edit-bar-sm clearfix">
            <div class="edit-bar-left">
                <span>入驻团队</span>
                <i class="line"></i>
            </div>
        </div>
        <div class="panel-body collapse in">
            <div class="panel-inner">
                <span>团队名称：</span>
                <div>
                    <select>
                        <option>--请选择--</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="edit-bar edit-bar-sm clearfix">
            <div class="edit-bar-left">
                <span>已入驻团队信息</span>
                <i class="line"></i>
                <a data-toggle="collapse" href="#teamInfo"><i class="icon-collaspe icon-double-angle-up"></i></a>
            </div>
        </div>
        <div class="panel-body collapse in">
            <div class="panel-inner">
                <table class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
                    <thead>
                    <tr>
                        <th>编号</th>
                        <th>团队</th>
                        <th>负责人</th>
                        <th>备注</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody id="assignedTbody"></tbody>
                </table>
            </div>
        </div>
    </form:form>
</div>

<script>

    $(function () {
        var $assignedTbody = $('#assignedTbody');
        var assignedData = [];
        var roomId = $('#roomId').val();
        var $teamSelect = $("#teamSelect");
        $assignedTbody.html();
        appendAssignTbody();
        teamOption();

        function appendAssignTbody() {
            var assignedXhr = $.post('${ctx}/pw/pwEnter/treeData?status=6,3,4,7');
            assignedXhr.success(function (data) {
                var trs = '';
                $assignedTbody.html();
                assignedData.length = 0;
                if (!data && !data.length) {
                    return false;
                }
                assignedData = data;
                data.forEach(function (t, i) {
                    trs += '<tr data-index="' + i + '"><td>' + (i + 1) + '</td><td>' + t.name + '</td><td>' + t.data.applicant.name + '</td><td>' + t.data.remarks + '</td><td><button type="button" class="btn btn-small btn-default btn-delete">取消分配</button></td></tr>'
                });
                $assignedTbody.html(trs);
            });

            assignedXhr.error(function (err) {
                console.log(err);
            })
        }

        $assignedTbody.on('click', 'button.btn-delete', function (e) {
            var i = $(this).parents('tr').attr('data-index');
            var id = assignedData[i].id;
            if (!id) return;
            top.$.jBox.confirm('是否取消入驻？', '系统提示', function (v, h, f) {
                if (v == 'ok') {
                    cancelAssign(id)
                }
            });
            top.$('.jbox-body .jbox-icon').css('top', '55px');
        })


        function cancelAssign(id) {
            var xhr = $.post( '${ctx}/pw/pwEnterRoom/ajaxPwEnterRoom/' + roomId + '?eid=' + id + '&isEnter=false');
            xhr.success(function (data) {
                resetTip();
                location.reload()
            })

            xhr.error(function () {

            })
        }

        function addAssign(id) {
            var xhr = $.post('${ctx}/pw/pwEnterRoom/ajaxPwEnterRoom/' + roomId + '?eid=' + id + '&isEnter=true');
            xhr.success(function (data) {

            });

            xhr.error(function () {

            })
        }

        function teamOption() {
            var url = '${ctx}/pw/pwEnter/treeData?status=1';
            var xhr = $.post(url);
            xhr.success(function (data) {
                var options = '';
                if (!data && !data.length) {
                    return false;
                }
                data.forEach(function (t) {
                    if(t.data.eroom){
                        options += '<option value="'+t.data.eroom.pwEnter.id+'">'+t.name+'</option>'
                    }else{
                        options += '<option>'+t.name+'</option>'
                    }
                })
                $teamSelect.append(options)
            })

            xhr.error(function (err) {
                console.log(err)
            })
        }


    })

</script>
</body>
</html>