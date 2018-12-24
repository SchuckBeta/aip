<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <link rel="stylesheet" href="/css/cyjd/switch.css?v=1">
    <script type="text/javascript" src="/js/backTable/sort.js"></script><!--排序js-->
    <style>
        input[disabled].lr-switch {
            cursor: pointer;
        }
    </style>
</head>
<body>
<form:form id="searchForm" modelAttribute="pwRoom" cssStyle="display: none" action="${ctx}/pw/pwRoom/" method="post">
    <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
    <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
    <input type="hidden" id="orderBy" name="orderBy" value="${page.orderBy}"/>
    <input type="hidden" id="orderByType" name="orderByType" value="${page.orderByType}"/>
    <input type="hidden" name="pwSpace.id" value="${pwRoom.pwSpace.id}">
</form:form>
<ul class="nav nav-tabs">
    <li class="active"><a href="${ctx}/pw/pwRoom/list?pwSpace.id=${pwRoom.pwSpace.id}">房间列表</a></li>
    <shiro:hasPermission name="pw:pwRoom:edit">
        <li><a href="${ctx}/pw/pwRoom/form?pwSpace.id=${pwRoom.pwSpace.id}">房间添加</a></li>
    </shiro:hasPermission>
</ul>
<sys:message content="${message}"/>
<%--<div class="text-right mgb-20">--%>
<%--<a href="${ctx}/pw/pwRoom/form" class="btn btn-primary">添加房间</a>--%>
<%--</div>--%>
<table id="contentTable"
       class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap table-sort table-room">
    <thead>
    <tr>
        <th data-name="name"><a class="btn-sort" href="javascript:void(0);">房间名称<i class="icon-sort"></i></a></th>
        <%--<th data-name="alias"><a class="btn-sort" href="javascript:void(0);">别名<i class="icon-sort"></i></a></th>--%>
        <th data-name="type"><a class="btn-sort" href="javascript:void(0);">房间类型<i class="icon-sort"></i></a></th>
        <th data-name="num"><a class="btn-sort" href="javascript:void(0);">容纳人数<i class="icon-sort"></i></a></th>
        <th data-name="isUsable"><a class="btn-sort" href="javascript:void(0);">可否预约<i class="icon-sort"></i></a></th>
        <th data-name="isAssign"><a class="btn-sort" href="javascript:void(0);">可否分配<i class="icon-sort"></i></a></th>
        <th data-name="isAllowm"><a class="btn-sort" href="javascript:void(0);" title="是否允许多团队的入驻">多团队<i
                class="icon-sort"></i></a></th>
        <th>地址</th>
        <%--<th>基地</th>--%>
        <%--<th>楼栋</th>--%>
        <%--<th>楼层</th>--%>
        <%--<th>负责人</th>--%>
        <%--<th>联系电话</th>--%>
        <shiro:hasPermission name="pw:pwRoom:edit">
            <th style="width:23%">操作</th>
        </shiro:hasPermission>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${page.list}" var="pwRoom">
        <tr>
            <td>
                <a href="${ctx}/pw/pwRoom/view?id=${pwRoom.id}">${pwRoom.name}</a>
            </td>
                <%--<td>${pwRoom.alias}</td>--%>
            <td>${fns:getDictLabel(pwRoom.type, 'pw_room_type', '')}</td>
            <td>${pwRoom.num}</td>
                <%--<td>${fns:getDictLabel(pwRoom.isUsable, 'yes_no', '')}</td>--%>
            <td>

                <%--<div style="position:relative;z-index:333;">--%>
                    <%--<label class="switch-label switch-label-usabel">--%>
                        <%--<label class="switch-label-position">--%>
                            <%--<span class="auto-move"--%>
                                    <%--<c:if test="${(pwRoom.isUsable eq 1) && (pwRoom.isAssign eq 0)}">--%>
                                        <%--style="display: block"--%>
                                    <%--</c:if>--%>
                            <%-->是</span>--%>
                            <%--<input class="lr-switch lr-switch-anim" disabled type="checkbox" value="${pwRoom.id}"--%>
                                    <%--<c:if test="${(pwRoom.isUsable eq 1) && (pwRoom.isAssign eq 0)}">--%>
                                        <%--checked--%>
                                    <%--</c:if>--%>
                            <%--/>--%>
                            <%--<span class="hand-move"--%>
                                    <%--<c:if test="${(pwRoom.isUsable ne 0) && (pwRoom.isAssign eq 0)}">--%>
                                        <%--style="display: none;"--%>
                                    <%--</c:if>--%>
                            <%-->否</span>--%>
                        <%--</label>--%>
                    <%--</label>--%>
                <%--</div>--%>
                    <div style="position:relative;z-index:333;">
                        <label class="switch-label switch-label-usabel">
                            <label class="switch-label-position">
                                <span class="auto-move"
                                        <c:if test="${(pwRoom.isUsable eq 1) && (pwRoom.isAssign eq 0)}">
                                            style="display: block"
                                        </c:if>
                                >是</span>
                                <input class="lr-input" disabled type="checkbox" value="${pwRoom.id}"
                                        <c:if test="${(pwRoom.isUsable eq 1) && (pwRoom.isAssign eq 0)}">
                                            checked
                                        </c:if>
                                />
                                <div class="lr-switch lr-switch-anim"></div>
                                <span class="hand-move"
                                        <c:if test="${(pwRoom.isUsable ne 0) && (pwRoom.isAssign eq 0)}">
                                            style="display: none;"
                                        </c:if>
                                >否</span>
                            </label>
                        </label>
                    </div>
            </td>
            <td>
                    <%--${fns:getDictLabel(pwRoom.isAssign, 'yes_no', '')}--%>
                <%--<div style="position:relative;z-index:333;">--%>
                    <%--<label class="switch-label switch-label-assign">--%>
                        <%--<label class="switch-label-use">--%>
                                <%--<span class="auto-move"--%>
                                        <%--<c:if test="${(pwRoom.isUsable eq 0) && (pwRoom.isAssign eq 1)}">--%>
                                            <%--style="display: block"--%>
                                        <%--</c:if>--%>
                                <%-->是</span>--%>
                            <%--<input class="lr-switch lr-switch-anim" disabled type="checkbox" value="${pwRoom.id}"--%>
                                    <%--<c:if test="${(pwRoom.isUsable eq 0) && (pwRoom.isAssign eq 1)}">--%>
                                        <%--checked--%>
                                    <%--</c:if>--%>
                            <%--/>--%>
                            <%--<span class="hand-move"--%>
                                    <%--<c:if test="${(pwRoom.isUsable eq 0) && (pwRoom.isAssign ne 0)}">--%>
                                        <%--style="display: none"--%>
                                    <%--</c:if>--%>
                            <%-->否</span>--%>
                        <%--</label>--%>
                    <%--</label>--%>
                <%--</div>--%>
                        <div style="position:relative;z-index:333;">
                            <label class="switch-label switch-label-assign">
                                <label class="switch-label-position">
                                    <span class="auto-move"
                                            <c:if test="${(pwRoom.isUsable eq 0) && (pwRoom.isAssign eq 1)}">
                                                style="display: block"
                                            </c:if>
                                    >是</span>
                                    <input class="lr-input" disabled type="checkbox" value="${pwRoom.id}"
                                            <c:if test="${(pwRoom.isUsable eq 0) && (pwRoom.isAssign eq 1)}">
                                                checked
                                            </c:if>
                                    />
                                    <div class="lr-switch lr-switch-anim"></div>
                                    <span class="hand-move"
                                            <c:if test="${(pwRoom.isUsable eq 0) && (pwRoom.isAssign ne 0)}">
                                                style="display: none"
                                            </c:if>
                                    >否</span>
                                </label>
                            </label>
                        </div>
            </td>
            <td>${fns:getDictLabel(pwRoom.isAllowm, 'yes_no', '')}</td>
            <td>
                <c:if test="${(not empty pwRoom.pwSpace.parent) && (pwRoom.pwSpace.parent.id ne root)}">
                    <c:if test="${(not empty pwRoom.pwSpace.parent.parent) && (pwRoom.pwSpace.parent.parent.id ne root)}">
                        <c:if test="${(not empty pwRoom.pwSpace.parent.parent.parent) && (pwRoom.pwSpace.parent.parent.parent.id ne root)}">
                            <c:if test="${(not empty pwRoom.pwSpace.parent.parent.parent.parent) && (pwRoom.pwSpace.parent.parent.parent.parent.id ne root)}">
                                ${pwRoom.pwSpace.parent.parent.parent.parent.name}/
                            </c:if>${pwRoom.pwSpace.parent.parent.parent.name}/
                        </c:if>${pwRoom.pwSpace.parent.parent.name}/
                    </c:if>${pwRoom.pwSpace.parent.name}/
                </c:if>${pwRoom.pwSpace.name}
            </td>
                <%--<td>${pwRoom.person}</td>--%>
                <%--<td>${pwRoom.mobile}</td>--%>
            <shiro:hasPermission name="pw:pwRoom:edit">
                <td>
                    <a class="btn btn-small btn-primary"
                       href="${ctx}/pw/pwRoom/formSetZC?id=${pwRoom.id}">分配资产</a>
                    <%--<c:if test="${(pwRoom.isUsable eq 0) && (pwRoom.isAssign eq 0)}">--%>
                        <%--<a class="btn btn-small btn-primary"--%>
                           <%--href="${ctx}/pw/pwRoom/formIsUsable?id=${pwRoom.id}&isUsable=1"--%>
                           <%--onclick="return confirmx('确认开放房间 ${pwRoom.name}预约吗？', this.href)"--%>
                            <%--&lt;%&ndash;data-toggle="confirm"&ndash;%&gt;--%>
                            <%--&lt;%&ndash;data-msg="确认开放房间 ${pwRoom.name}预约吗？"&ndash;%&gt;--%>
                           <%--data-id="${pwRoom.id}">开启预约</a>--%>
                    <%--</c:if>--%>
                    <%--<c:if test="${(pwRoom.isUsable eq 1) && (pwRoom.isAssign eq 0)}">--%>
                        <%--<a class="btn btn-small btn-primary"--%>
                           <%--href="${ctx}/pw/pwRoom/formIsUsable?id=${pwRoom.id}&isUsable=0"--%>
                            <%--&lt;%&ndash;data-toggle="confirm" data-msg="确认关闭房间  ${pwRoom.name} 吗？"&ndash;%&gt;--%>
                           <%--onclick="return confirmx('确认关闭房间${pwRoom.name}预约吗？', this.href)"--%>
                           <%--data-id="${pwRoom.id}">关闭预约</a>--%>
                    <%--</c:if>--%>
                    <%--<c:if test="${(pwRoom.isAssign eq 0) && (pwRoom.isUsable eq 0)}">--%>
                        <%--<a class="btn btn-small btn-primary"--%>
                           <%--href="${ctx}/pw/pwRoom/formIsAssign?id=${pwRoom.id}&isAssign=1"--%>
                            <%--&lt;%&ndash;data-toggle="confirm"&ndash;%&gt;--%>
                           <%--data-msg="确认开启房间 ${pwRoom.name}分配吗？"--%>
                           <%--onclick="return confirmx('确认开启房间 ${pwRoom.name}分配吗？', this.href)"--%>
                           <%--data-id="${pwRoom.id}">开启分配</a>--%>
                    <%--</c:if>--%>
                    <%--<c:if test="${(pwRoom.isAssign eq 1) && (pwRoom.isUsable eq 0)}">--%>
                        <%--<a class="btn btn-small btn-primary"--%>
                           <%--href="${ctx}/pw/pwRoom/formIsAssign?id=${pwRoom.id}&isAssign=0"--%>
                            <%--&lt;%&ndash;data-toggle="confirm" data-msg="确认关闭房间  ${pwRoom.name} 分配吗？"&ndash;%&gt;--%>
                           <%--onclick="return confirmx('确认关闭房间  ${pwRoom.name} 分配吗？', this.href)"--%>
                           <%--data-id="${pwRoom.id}">关闭分配</a>--%>
                        <%--&lt;%&ndash; <a class="btn btn-small btn-primary"--%>
                           <%--href="${ctx}/pw/pwEnterRoom/assignRoomForm?id=${pwRoom.id}"--%>
                           <%--data-id="${pwRoom.id}">分配</a> &ndash;%&gt;--%>
                    <%--</c:if>--%>
                    <a class="btn btn-small btn-primary" href="${ctx}/pw/pwRoom/form?id=${pwRoom.id}">修改</a>
                    <a class="btn btn-small btn-default"
                       href="${ctx}/pw/pwRoom/delete?id=${pwRoom.id}"
                        <%--data-toggle="confirm"--%>
                        <%--data-msg="确认删除房间 ${pwRoom.name} 吗？"--%>
                       onclick="return confirmx('确认删除房间 ${pwRoom.name} 吗？', this.href)"
                       data-id="${pwRoom.id}">删除</a>
                </td>
            </shiro:hasPermission>
        </tr>
    </c:forEach>
    </tbody>
</table>
${page.footer}
<script>

    function page(n, s) {
        $("#pageNo").val(n);
        $("#pageSize").val(s);
        $("#searchForm").submit();
        return false;
    }

    $(function () {
        var $parentDoc = $(parent.document);
        var $sidebar = $parentDoc.find('.sidebar')
        var $layoutHandlerBar = $parentDoc.find('.layout-handler-bar')

        $("#ps").val($("#pageSize").val());

        if (!$layoutHandlerBar.hasClass('bar-close')) {
            $sidebar.show()
        }
        $layoutHandlerBar.show();
        $parentDoc.find('.room-list-content').css('margin-left', '');

        var $contentTable = $('#contentTable');
        $contentTable.on('click', '.switch-label-usabel,.switch-label-assign', function (e) {
            var $handMove = $(this).find(".hand-move");
            var $autoMove = $(this).find(".auto-move");
            var $checkbox = $(this).find('input[type="checkbox"]');
            var id = $checkbox.val();
            var xhr, url;
            var state = $checkbox.prop('checked') ? '0' : '1';
            url = $(this).hasClass('switch-label-usabel') ? ('${ctx}/pw/pwRoom/ajaxIsUsable?id=' + id + '&isUsable=' + state) : ('${ctx}/pw/pwRoom/ajaxIsAssign?id=' + id + '&isAssign=' + state);
            xhr = $.get(url);
            xhr.success(function (data) {
                if (data.status) {
                    switchToggle($handMove, $autoMove, $checkbox, state)
                } else {
                    alertx(data.msg)
                }
            })
        });


        function switchToggle(label1, label2, checkbox, state) {
            label1[state == '0' ? 'show' : 'hide']();
            label2[state == '1' ? 'show' : 'hide']();
            checkbox.prop('checked', state == '1')
        }

    })
</script>
</body>
</html>