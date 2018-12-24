<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>项目流程管理</title>
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

        function sendMsg(id) {
            dialogCyjd.createDialog(0, '确定要发布吗？', {
                buttons: [{
                    text: '确定',
                    'class': 'btn btn-primary btn-small',
                    click: function () {
                        $(this).dialog("close");
                        window.location.href = "${ctx}/oa/oaNotify/formBroadcast?protype=3&sId=" + id;
                    }
                }, {
                    text: '取消',
                    'class': 'btn btn-default btn-small',
                    click: function () {
                        $(this).dialog("close");
                    }
                }]
            });
        }
    </script>
</head>
<body>

<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span><c:if test="${not empty flowProjectTypes[0]}">${flowProjectTypes[0].name }</c:if><c:if--%>
                    <%--test="${empty flowProjectTypes[0]}">项目流程</c:if></span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" modelAttribute="actYw" action="${ctx}/actyw/actYw" method="post"
               class="form-horizontal clearfix form-search-block" autocomplete="off">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">名称</label>
                <div class="controls">
                    <form:input path="proProject.projectName" htmlEscape="false" maxlength="255" class="input-medium"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">自定义流程</label>
                <div class="controls">
                    <form:input path="group.name" htmlEscape="false" maxlength="255" class="input-medium"/>
                    <c:if test="${not empty actYw.group.flowType}">
                        <input name="group.flowType" type="hidden" value="${actYw.group.flowType}"/></c:if>
                </div>
            </div>
            <div class="control-group" >
                <label class="control-label">是否预发布</label>
                <div class="controls">
                    <form:select path="isPreRelease" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group" style="margin-right: 120px;">
                <label class="control-label">发布状态</label>
                <div class="controls">
                    <form:select path="isDeploy" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <button type="submit" class="btn btn-primary">查询</button>
            <a class="btn btn-primary" href="${ctx}/actyw/actYw/form?group.flowType=${actYw.group.flowType}&secondName=添加">添加</a>
        </div>
    </form:form>
    <sys:message content="${message}"/>

    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-sort table-nowrap">
        <thead>
        <tr>
            <th>项目名称</th>

            <th width="25%">工作流程</th>
            <%--<th>项目+流程标识</th>--%>
            <th>编号规则</th>
            <th>编号规则示例</th>
            <th>发布类型</th>
            <th>发布状态</th>
            <th>消息状态</th>
            <%--<th>时间轴</th>--%>
            <th>年份</th>
            <th>项目有效期</th>
            <th>修改时间</th>
            <shiro:hasPermission name="actyw:actYw:edit">
                <th>操作</th>
            </shiro:hasPermission>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="actYw">
            <c:set var="rowspan" value="${fn:length(actYw.years)}"></c:set>
            <tr>
                <td rowspan="${rowspan == 0 ? 1 : rowspan}">
                        ${actYw.proProject.projectName}
                </td>

                <td rowspan="${rowspan == 0? 1 : rowspan}"><a href="${ctx}/actyw/actYwGroup/form?id=${actYw.groupId}">
                        ${actYw.group.name}
                </a></td>
                <td rowspan="${rowspan == 0 ? 1 : rowspan}">
                   <a href="/a/sys/sysNumberRule">${fns:isNumberRule(actYw.id)}</a>
                </td>
                <td rowspan="${rowspan == 0 ? 1 : rowspan}">
                    <c:set  var="ruleText" value="${fns:getNumberRule(actYw.id)}"/>
                    <p title="${ruleText}" style="margin: 0 auto; width: 80px;overflow: hidden;text-overflow: ellipsis;white-space: nowrap">
                    ${ruleText}</p>

                </td>
                <td rowspan="${rowspan == 0 ? 1 : rowspan}">
                	<c:if test="${!actYw.isDeploy}">-</c:if>
                	<c:if test="${actYw.isDeploy}">
	                	<c:if test="${!actYw.isPreRelease}">正式发布</c:if>
	                	<c:if test="${actYw.isPreRelease}">预发布</c:if>
                	</c:if>

                <%-- ${fns:getDictLabel(actYw.isPreRelease, 'true_false', '')} --%></td>
                <td rowspan="${rowspan == 0 ? 1 : rowspan}">${fns:getDictLabel(actYw.isDeploy, 'true_false', '')}</td>
                <%--<td rowspan="${rowspan == 0 ? 1 : rowspan}">--%>
                    <%--<c:if test="${actYw.status eq '1'}">发布</c:if>--%>
                    <%--<c:if test="${actYw.status  ne '1'}">未发布</c:if>--%>
                <%--</td>--%>

                    <%--<c:choose>--%>
                    <%--<c:when test="${fn:length(actYw.years) < 2}">--%>
                    <%--<td>--%>
                    <%--<a class="btn btn-primary btn-small"--%>
                    <%--href="${ctx}/actyw/actYw/formGtime?id=${actYw.id}&yearId=${item.id}">修改时间</a>--%>
                    <%--</td>--%>
                    <%--</c:when>--%>
                    <%--<c:otherwise>--%>
                    <%--<c:forEach items="${actYw.years}" var="item" varStatus="status">--%>
                <c:forEach items="${actYw.years}" var="item" varStatus="idx">
                    <c:if test="${idx.index eq 0}">
                        <td>${item.year}</td>
                        <td>
                            <fmt:formatDate value="${item.startDate}" pattern="yyyy-MM-dd"/>
                            <c:if test="${item.startDate != null }"> <span>至</span></c:if>
                            <fmt:formatDate value="${item.endDate}" pattern="yyyy-MM-dd"/>
                        </td>

                        <td class="operate-button-padding">
                            <a class="btn btn-primary btn-small change-time-width"
                               href="${ctx}/actyw/actYw/formGtime?id=${actYw.id}&yearId=${item.id}&secondName=创建时间">修改时间</a>
                        </td>
                    </c:if>
                </c:forEach>
                <c:if test="${empty actYw.years}">
                    <td></td>
                    <td></td>
                    <td class="operate-button-padding">
                        <a class="btn btn-primary btn-small change-time-width"
                           href="${ctx}/actyw/actYw/formGtime?id=${actYw.id}&yearId=${item.id}">修改时间</a>
                    </td>
                </c:if>
                    <td rowspan="${rowspan == 0 ? 1 : rowspan}" class="operate-button-padding" style="width: 170px;">
                        <c:if test="${actYw.id eq ywpId}">
                            <button type="button" class="btn btn-primary btn-small change-time-width" disabled>修改属性</button>
                            <button class="btn btn-primary btn-small change-time-width" disabled type="button">消息发布</button>
                            <button class="btn btn-default btn-small change-time-width" type="button" disabled>取消发布</button>
                        </c:if>

                        <c:if test="${(actYw.id ne ywpId) && (actYw.id ne ywgId)}">
                            <a class="btn btn-primary btn-small change-time-width"
                               href="${ctx}/actyw/actYw/formProp?id=${actYw.id}">修改属性</a>
                        </c:if>

                        <c:if test="${actYw.isDeploy}">
                            <%--<c:if test="${actYw.status  ne '1'}">--%>
                            <%--<a class="check_btn btn-pray btn-lx-primary" href="javascript:void(0);" class="btn sendMsg btn-small" onclick="sendMsg('${actYw.id}');">消息发布</a>--%>
                            <%--</c:if>--%>
							<c:if test="${actYw.isPreRelease}">
	                             <a class="btn btn-primary btn-small change-time-width"
	                                   href="${ctx}/actyw/actYw/ajaxPreRelease?id=${actYw.id}&isPreRelease=false"
	                                   onclick="return confirmx('确认要正式发布项目[${actYw.proProject.projectName}]吗？', this.href)">正式发布</a>
	                        </c:if>
                            <%--<c:if test="${actYw.status  ne '1'}">--%>
                                <%--<a href="javascript:void(0);"--%>
                                   <%--class="btn btn-primary btn-small change-time-width"--%>
                                   <%--onclick="return confirmx('确定要发布吗？', '${ctx}/oa/oaNotify/formBroadcast?protype=3&sId=${actYw.id}')">消息发布</a>--%>
                            <%--</c:if>--%>

                            <c:if test="${(actYw.id ne ywpId) && (actYw.id ne ywgId)}">
                                <a class="btn btn-default btn-small change-time-width"
                                   href="${ctx}/actyw/actYw/ajaxDeploy?id=${actYw.id}&isDeploy=false"
                                   onclick="return confirmx('确认要取消发布项目[${actYw.proProject.projectName}]吗？', this.href)">取消发布</a>
                            </c:if>
                        </c:if>
                        <c:if test="${not actYw.isDeploy}">
                        	<%-- <c:if test="${!actYw.isPreRelease}">
	                             <a class="btn btn-primary btn-small"
	                                   href="${ctx}/actyw/actYw/ajaxPreRelease?id=${actYw.id}&isPreRelease=true"
	                                   onclick="return confirmx('确认要正式发布项目[${actYw.proProject.projectName}]吗？', this.href)">测试发布</a>
	                        </c:if> --%>
                            <%-- <c:if test="${actYw.group.status eq '1'}"><a class="check_btn btn-pray btn-lx-primary" href="${ctx}/actyw/actYw/form?id=${actYw.id}">修改</a></c:if> --%>
                            <a class="btn btn-primary btn-small ready-publish"
                               href="${ctx}/actyw/actYw/ajaxDeploy?id=${actYw.id}&isDeploy=true&isPreRelease=true&isUpdateYw=true"
                               onclick="return confirmx('确认要预发布项目[${actYw.proProject.projectName}]吗？', this.href)">预发布</a>
                            <c:if test="${(actYw.id ne ywpId) && (actYw.id ne ywgId)}">
                                <a class="btn btn-default btn-small second-delete"
                                   href="${ctx}/actyw/actYw/delete?id=${actYw.id}"
                                   onclick="return confirmx('确认要删除该项目流程吗？', this.href)">删除</a>
                            </c:if>
                        </c:if>
                    </td>



            </tr>

            <c:forEach items="${actYw.years}" var="item" varStatus="idx">
                <c:if test="${rowspan > 1 && idx.index > 0}">
                    <tr>
                        <td>${item.year}</td>
                        <td>
                            <fmt:formatDate value="${item.startDate}" pattern="yyyy-MM-dd"/>
                            <c:if test="${item.startDate != null }"> <span>至</span></c:if>
                            <fmt:formatDate value="${item.endDate}" pattern="yyyy-MM-dd"/>
                        </td>
                        <td>
                            <a class="btn btn-primary btn-small change-time-width"
                               href="${ctx}/actyw/actYw/formGtime?id=${actYw.id}&yearId=${item.id}">修改时间</a>
                        </td>
                    </tr>
                </c:if>
            </c:forEach>

        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>
</body>
</html>