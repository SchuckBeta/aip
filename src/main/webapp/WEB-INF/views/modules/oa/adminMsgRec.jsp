<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <style>
        .notify-modal .modal-body {
            padding: 0;
        }

        .notify-modal .title {
            margin: 0;
            height: 28px;
            line-height: 28px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            font-size: 16px;
            font-weight: bold;
            text-align: center;

        }

        .notify-modal .time {
            color: #333;
            margin: 0;
            font-size: 12px;
            text-align: right;
        }

        .notify-modal .notify-p-wrap {
            padding: 15px;
            min-height: 150px;
            max-height: 400px;
            overflow-y: auto;
            overflow-x: hidden;
            font-size: 16px;
            text-indent: 32px;
            border-top: 1px solid #ccc;
        }

        .notify-modal .notify-content {
            font-size: 16px;
        }

        .notify-modal .modal-header {
            display: none;
            font-size: 16px;
        }

        .notify-modal .title-time {
            position: relative;
            padding: 15px 15px 5px;

        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#ps").val($("#pageSize").val());
            var $tableContent = $('#contentTable');
            var $notifyModal = $('#notifyModal');
            var $title = $notifyModal.find('.title');
            var $time = $notifyModal.find('.time');
            var $content = $notifyModal.find('.notify-content');
            $tableContent.on('click', '.select_info', function () {
                var atag = $(this);
                var oaNotifyId = $(this).siblings('input').val();
                var xhr = $.post('${ctx}/oa/oaNotify/viewMsg', {
                    oaNotifyId: oaNotifyId
                });
                xhr.success(function (data) {
                    $title.text(data.title);
                    $time.text(data.publishDate);
                    $content.text(data.content);
                    parent.changeUnreadTrForNotify(oaNotifyId);
                });
                $notifyModal.modal({
                    show: true,
                    backdrop: false
                });
            });
            $notifyModal.draggable({handler: ".title-time"});
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
            <span>我的消息</span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <ul class="nav nav-tabs nav-tabs-default">
        <li class="active"><a href="javascript:void(0)">接收消息</a></li>
        <li><a href="/a/oa/oaNotify/msgSendList">发送消息</a></li>
    </ul>
    <div class="tab-content-default">
        <form:form id="searchForm" modelAttribute="oaNotify" class="form-inline" action="/a/oa/oaNotify/msgRecList"
                   method="post">
            <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
            <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
            <div class="text-right" style="padding-right: 15px;">
                <form:input path="title" htmlEscape="false" maxlength="200" class="form-control"
                            placeholder="关键字"/>
                <button type="submit" class="btn btn-primary">查询</button>
                <button type="button" class="btn btn-primary" id="resallbtn" onclick="resall()">批量删除</button>
            </div>
        </form:form>
        <table id="contentTable"
               class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap table-sort table-room">
            <thead>
            <tr>
                <th><input type="checkbox" id="selectAllbtn" onclick="selectAll(this)" data-flag="false"
                           class="all-checkbox"></th>
                <th>序号</th>
                <th>标题</th>
                <th style="display: none">消息内容</th>
                <th>消息类型</th>
                <th>消息状态</th>
                <th>发送人</th>
                <th>发布时间</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${page.list}" var="oaNotify" varStatus="status">
                <tr key_5f820f675bfe4ffbb2b18f49ae12cbfe="${oaNotify.id}"
                    <c:if test="${oaNotify.readFlag!=1 }">class="unreadTr"</c:if> >
                    <td class="checkone">
                        <input type="checkbox" value="${oaNotify.id}" name="subck" onclick="subckchange(this)"/>
                    </td>
                    <td>${status.index+1 }</td>
                    <td><a href="javascript:void(0);" class="select_info"><span
                            class="notify-tr-title">${fns:abbr(oaNotify.title,50)}</span></a><input
                            value="${oaNotify.id }" type="hidden"/></td>
                    <td style="display: none" class="text-left"><span
                            class="notify-content"> ${fn:substring(fns:replaceEscapeHtml(oaNotify.content),0,30)}</span>
                    </td>
                    <td>${fns:getDictLabel(oaNotify.type, 'oa_notify_msg_type', '')}</td>
                    <td>
                        <c:if test="${oaNotify.readFlag==1 }">已读</c:if>
                        <c:if test="${oaNotify.readFlag!=1 }">未读</c:if>
                    </td>
                    <td>${fns:getUserById(oaNotify.createBy.id).name}</td>
                    <td><fmt:formatDate value="${oaNotify.effectiveDate}"
                                        pattern="yyyy-MM-dd HH:mm:ss"/></td>
                    <td data-notify-id="${oaNotify.id }" data-notify-type="${oaNotify.type}">
                        <input value="${oaNotify.id }" type="hidden"/>
                        <a href="/a/oa/oaNotify/deleteRec?id=${oaNotify.id}" class="btn btn-default btn-small">删除</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    ${page.footer}
</div>
<div id="notifyModal" class="modal hide notify-modal" tabindex="-1" role="dialog">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                aria-hidden="true">&times;</span></button>
        <span class="modal-title" style="font-size: 16px;">通知消息</span>
    </div>
    <div class="modal-body">
        <div class="title-time">
            <h4 class="title"></h4>
            <p class="time" data-jst-content="time"></p>
        </div>
        <div class="notify-p-wrap"><p class="notify-content"></p></div>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal" style="width: auto; height: auto">关闭</button>
    </div>
</div>
<script>

    function selectAll(ob) {
        if ($(ob).attr("checked")) {
            $("input[name='subck']:checkbox").attr("checked", true);
        } else {
            $("input[name='subck']:checkbox").attr("checked", false);
        }
    }
    function resall() {
        var temarr = [];
        $("input[name='subck']:checked").each(function (i, v) {
            temarr.push($(v).val());
        });
        if (temarr.length == 0) {
            alertx("请选择要删除的消息");
            return;
        }
        confirmx("确定删除？", function () {
            $.ajax({
                type: 'post',
                url: '/a/oa/oaNotify/deleteRevBatch',
                dataType: "json",
                data: {
                    ids: temarr.join(",")
                },
                success: function (data) {
                    if (data) {
                        window.location.reload();
                    } else {
                        alertx(data.msg);
                    }
                }
            });
        });
    }
    function subckchange(ob) {
        if (!$(ob).attr("checked")) {
            $("#selectAllbtn").attr("checked", false);
        }
    }
</script>
</body>
</html>