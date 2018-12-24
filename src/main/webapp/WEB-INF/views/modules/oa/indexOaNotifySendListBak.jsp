<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="decorator" content="site-decorator"/>
    <title>${frontTitle}</title>
    <link rel="stylesheet" type="text/css" href="/css/indexOaNotifyListR.css">
    <style>
        .table>thead>tr>th{
            white-space: nowrap;
        }
        .table>tbody>tr:last-child>td{
            white-space: nowrap;
        }

        span.notify-tr-title{
            display: inline-block;
            width: 230px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .table th,.table td{
            font-size: 12px;
        }
        .breadcrumb {
          margin-top: 30px;
          padding-left: 0;
          background-color: white; }

        .breadcrumb a {
          text-decoration: none; }

        .breadcrumb > li > a {
          color: #333; }

        .breadcrumb > li {
          color: #777; }
        .breadcrumb > li + li:before {
          content: "\003e";
          padding: 0 5px 0 3px;
          color: #ccc; }

        .breadcrumb .icon-home:before {
          content: "\f015";
          margin-right: 7px; }
    </style>
    <script type="text/javascript">
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }
        $(function () {
            var minHeight = $(window).height() - $('.footerBox').height() - $('.header').height();
            $('#content').css('min-height',minHeight)
            var message = "${message}";
            message && message && dialogCyjd.createDialog("1", message, {
                dialogClass: 'dialog-cyjd-container',
                buttons: [{
                    text: '确定',
                    'class': 'btn btn-sm btn-primary',
                    click: function () {
                        $(this).dialog('close');
                    }
                }]
            });
        })
    </script>
</head>
<body>
<div class="container container-fluid-oe">
    <ol class="breadcrumb" style="margin-top: 0">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li class="active">我的消息</li>
        <li class="active">发送消息</li>
    </ol>
    <div class="notify-wrap">
        <h4 class="notify-title">我的消息</h4>
        <%--<sys:message content="${message}"/>--%>
        <div class="tab-container">
            <ul class="nav nav-tabs" role="tablist">
                <li >
                    <a href="${ctxFront}/oa/oaNotify/indexMyNoticeList/" >接收消息</a>
                </li>
                <li class="active">
                    <a href="${ctxFront}/oa/oaNotify/indexMySendNoticeList/" >发送消息</a>
                </li>
            </ul>
            <div class="tab-content">
                <div id="notifyTab1" role="tabpanel" class="tab-pane active">
                    <form:form id="searchForm" modelAttribute="oaNotify"
                               action="${ctxFront}/oa/oaNotify/indexMySendNoticeList" method="post"
                               class="form-search">
                        <div class="form-inline text-right">
                            <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
                            <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
                            <div class="form-group">
                                <form:input path="title" htmlEscape="false" maxlength="200" class="form-control"
                                            placeholder="关键字"/>
                                <button id="btnSubmit" class="btn btn-primary" type="submit">查询</button>
                                <input id="btnSubmit1" class="btn btn-primary" type="button"  value="批量删除" data-toggle="modal" data-target="#myModal"/>
                            </div>
                        </div>
                        <table id="contentTable" class="table table-hover table-bordered table-condensed table-notify">
                            <thead>
                            <tr>
                                <th><input type="checkbox" id="check_all" data-flag="false"></th>
                                <th>序号</th>
                                <th>标题</th>
                                <th style="display: none">消息内容</th>
                                <th>消息类型</th>

                                <th>接收人</th>
                                <th>发布时间</th>
                                <th>操作</th>
                                    <%-- <c:if test="${!oaNotify.isSelf}"><shiro:hasPermission name="oa:oaNotify:edit"><th>操作</th></shiro:hasPermission></c:if> --%>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${page.list}" var="oaNotify" varStatus="status">
                                <tr>
                                    <td class="checkone">
                                        <input type="checkbox" value="${oaNotify.id}" name="boxTd" />
                                    </td>
                                    <td>${status.index+1 }</td>
                                    <td><a href="javascript:void (0);" class="select_info"><span class="notify-tr-title">${fns:abbr(oaNotify.title,50)}</span></a><input value="${oaNotify.id }" type="hidden"/></td>
                                    <td style="display: none" class="text-left"><%--${fn:substring(oaNotify.content,0,30)}--%>
                                    <span class="notify-content">${fn:substring(fns:replaceEscapeHtml(oaNotify.content),0,30)}</span>
                                    </td>
                                    <td>${fns:getDictLabel(oaNotify.type, 'oa_notify_msg_type', '')}</td>

                                    <td>${fns:getUserById(oaNotify.userId).name}</td>
                                        <%-- <td><fmt:formatDate value="${oaNotify.updateDate}"
                                                pattern="yyyy-MM-dd HH:mm:ss" /></td> --%>
                                    <td><fmt:formatDate value="${oaNotify.effectiveDate}"
                                                        pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                    <td data-notify-id="${oaNotify.id }" data-notify-type="${oaNotify.type}">
                                        <%--<a href="javascript:void (0);" class="btn btn-primary btn-sm select_info">查看</a>--%>
                                        <input value="${oaNotify.id }" type="hidden"/>
                                        <a href="${ctxFront}/oa/oaNotify/deleteSend?id=${oaNotify.id}&userId=${oaNotify.userId}" class="btn btn-default btn-sm">删除</a>

                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </form:form>
                    <div class="pagination-container">
                        ${page.footer}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="notifyModal" class="modal notify-modal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                        aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">通知消息</h4>
            </div>
            <div class="modal-body">
                <div class="title-time">
                    <h4 class="title"></h4>
                    <p class="time" data-jst-content="time"></p>
                </div>
                <div class="notify-p-wrap"><p class="notify-content"></p></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>


<div id="myModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3 class="modal-title" id="myModalLabel">批量删除</h3>
            </div>
            <div class="modal-body">
                <div id="selectArea">
                    确定删除勾选的消息么?
                </div>
                <div class="buffer_gif" style="text-align:center;padding:20px 0px;display:none;" id="bufferImg">
                    <img src="/img/jbox-loading1.gif" alt="缓冲图片">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-batch btn-primary-oe" aria-hidden="true" id="confirmBtn" onclick="doBatch('/f/oa/oaNotify/deleteSendBatch');">确定</button>
                <button class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>
<script src="/js/oaNotify/notifyBatchDelete.js"></script>
<script type="text/javascript">
    (function (name, definition) {
        var hasDefine = typeof define === 'function';
        var hasExports = typeof module !== 'undefined' && module.exports;
        if (hasDefine) {
            definition()
        } else if (hasExports) {
            module.exports = definition()
        } else {
            window[name] = definition()
        }
    })('notify', function () {
        function Notify() {
            var provenceStatus = [
                {type: "11", name: "拒绝加入"},
                {type: "10", name: "同意加入"},
                {type: "9", name: "省市动态"},
                {type: "8", name: "双创通知"},
                {type: "7", name: "信息发布"},
                {type: "6", name: "邀请加入"},
                {type: "5", name: "申请加入"},
                {type: "4", name: "双创动态"},
                {type: "3", name: "活动通告"},
                {type: "2", name: "奖惩通告"},
                {type: "1", name: "团建通告"}
            ];
            var $ps = $('#ps');
            var $pageSize = $('#pageSize');
            var pageSize = $pageSize.val();
            var $tableContent = $('#contentTable');
            var $notifyModal = $('#notifyModal');
            var $title = $notifyModal.find('.title');
            var $time = $notifyModal.find('.time');
            var $content = $notifyModal.find('.notify-content');

            $ps.val(pageSize);

            $tableContent.on('click', '.select_info', function () {
                var oaNotifyId = $(this).siblings('input').val();
                var xhr = $.post('${ctxFront}/oa/oaNotify/view', {
                    oaNotifyId: oaNotifyId
                });
                xhr.success(function (data) {
                    $title.text(data.title);
                    $time.text(data.publishDate);
                    $content.text(data.content);
                });
                $notifyModal.modal({
                    show: true,
                    backdrop: false
                });
            });

            $tableContent.on('click', '.btn-promise-reject', function (e) {
                var name = $(this).data('name');
                var notifyId = $(this).parents('td').data('notifyId');
                var url = name == 'accept' ? '/f/acceptInviation' : '/f/refuseInviation';
                var resType, msg;
                var xhr = $.post(url, {
                    send_id: notifyId
                });
                xhr.success(function (res) {
                    if ((res == 1 && name == 'accept') || (res == 0 && name == 'refuse')) {
//                        alert('操作成功');

                        resType = '1';
                        msg = '操作成功'
                    } else if (res = 0 && name == 'accept') {
//                        alert("你已经加入其他团队！");
                        resType = '0';
                        msg = '你已经加入其他团队'
                    } else if (res = 4 && name == 'accept') {
//                        alert("该团队已经解散！");
                        resType = '0';
                        msg = '该团队已经解散或你已经加入团队'
                    }

                    dialogCyjd.createDialog(resType, msg, {
                        dialogClass: 'dialog-cyjd-container',
                        buttons: [{
                            text: '确定',
                            'class': 'btn btn-sm btn-primary',
                            click: function () {
                                $(this).dialog('close');
                                window.location.reload();
                            }
                        }]
                    });
                });
                xhr.error(function (err) {
                    console.log(err)
                });
                return false;
            });

            function getProvenceState(type, status) {
                var curName;
                $.each(status, function (i, item) {
                    if (item.type == type) {
                        curName = item.name;
                        return false
                    }
                });
                return curName;
            }
            $notifyModal.find('.modal-content').draggable({ handle: ".title-time" });
        }

        return new Notify();
    })

</script>

</body>
</html>