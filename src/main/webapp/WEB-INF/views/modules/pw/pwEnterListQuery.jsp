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
    </script>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>入驻查询</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" modelAttribute="pwEnter" action="${ctx}/pw/pwEnter/listQuery" method="post"
               class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="col-control-group">
            <div style="width:110%;height:45px;">
            <div class="control-group">
                <label class="control-label">入驻编号 </label>
                <div class="controls">
                    <form:input path="no" htmlEscape="false" maxlength="64" class="input-medium"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">入驻类型 </label>
                <div class="controls">
                    <form:select path="type" class="input-medium" cssStyle="width: 164px;">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${pwEtypes}" itemLabel="name"
                                      itemValue="key" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">入驻状态 </label>
                <div class="controls">
                    <c:if test="${empty pwEnterStatus}">
                        <form:select path="status" class="input-medium" cssStyle="width: 164px;">
                            <form:option value="" label="--请选择--"/>
                            <form:options items="${fns:getDictList('pw_enter_status')}" itemLabel="label"
                                          itemValue="value" htmlEscape="false"/>
                        </form:select>
                    </c:if>
                    <c:if test="${not empty pwEnterStatus}">
                        <form:select path="status" class="input-medium" cssStyle="width: 164px;">
                            <form:option value="" label="--请选择--"/>
                            <form:options items="${pwEnterStatus}" itemLabel="name"
                                          itemValue="key" htmlEscape="false"/>
                        </form:select>
                    </c:if>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">负责人 </label>
                <div class="controls">
                    <form:input path="applicant.name" htmlEscape="false" maxlength="64" class="input-medium"/>
                        <%-- <sys:treeselect id="applicant" name="applicant" value="${pwEnter.applicant}"
                                        labelName="user.name"
                                        labelValue="${pwEnter.applicant.name}"
                                        title="用户" url="/sys/office/treeData?type=3" cssClass="input-small"
                                        cssStyle="width: 150px;"
                                        allowClear="true"
                                        notAllowSelectParent="true"/> --%>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">所属学院</label>
                <div class="controls">
                    <form:input path="applicant.office.name" htmlEscape="false" maxlength="255" class="input-medium"/>
                </div>
            </div>
            </div>
            <div class="control-group">
                <label class="control-label">入驻时间</label>
                <div class="controls">
                    <input id="qstartQDate" name="startQDate" type="text" readonly="readonly" maxlength="20"
                           class="input-medium Wdate"
                           value="<fmt:formatDate value="${pwEnter.startQDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,maxDate:$('#qstartDate').val()});"/> -
                    <input id="qstartDate" name="startDate" type="text" readonly="readonly" maxlength="20"
                           class="input-medium Wdate"
                           value="<fmt:formatDate value="${pwEnter.startDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true, minDate:$('#qstartQDate').val()});"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">入驻有效期</label>
                <div class="controls">
                    <input id="qendQDate" name="endQDate" type="text" readonly="readonly" maxlength="20"
                           class="input-medium Wdate"
                           value="<fmt:formatDate value="${pwEnter.endQDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,maxDate:$('#qendDate').val()});"/> -
                    <input id="qendDate" name="endDate" type="text" readonly="readonly" maxlength="20"
                           class="input-medium Wdate"
                           value="<fmt:formatDate value="${pwEnter.endDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true, minDate:$('#qendQDate').val()});"/>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <button id="btnSubmit" type="submit" class="btn btn-primary">查询</button>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-orange table-center table-nowrap table-hover">
        <thead>
        <tr>
            <th>入驻编号</th>
            <th>负责人</th>
            <th>状态</th>
            <th>入驻类型</th>
            <!-- <th>类型|状态|名称</th> -->
            <!-- <th>期限(天)</th> -->
            <!-- <th>周期</th> -->
            <th>入驻时间</th>
            <th>入驻有效期</th>
            <%--<th>最后更新时间</th>--%>
            <%--<th>备注</th>--%>
            <%--<shiro:hasPermission name="pw:pwEnter:edit">--%>
            <%--<th>操作</th>--%>
            <%--</shiro:hasPermission>--%>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="pwEnter" varStatus="idx">
            <tr>
                <td><a href="${ctx}/pw/pwEnter/form?id=${pwEnter.id}">
                        ${pwEnter.no}
                </a></td>
                <td>
                        ${pwEnter.applicant.name}
                </td>
                <td>
                    <c:if test="${(not empty pwEnter) && (pwEnter.status eq '3')}">
                        <span class="primary-color">${fns:getDictLabel(pwEnter.status, 'pw_enter_status', '')}</span>
                    </c:if>
                    <c:if test="${(not empty pwEnter) && (pwEnter.status ne '3')}">
                        ${fns:getDictLabel(pwEnter.status, 'pw_enter_status', '')}
                    </c:if>
                </td>
                <td class="deal-separator">
                    <c:if test="${not empty pwEnter.eteam}">${fns:getDictLabel(pwEnter.eteam.type, 'pw_enter_type', '')}/</c:if>
                    <c:if test="${not empty pwEnter.eproject}">${fns:getDictLabel(pwEnter.eproject.type, 'pw_enter_type', '')}/</c:if>
                    <c:if test="${not empty pwEnter.ecompany}">${fns:getDictLabel(pwEnter.ecompany.type, 'pw_enter_type', '')}</c:if>
                </td>
                    <%-- <td>
		                <c:if test="${not empty pwEnter.eteam}"> <span class="bd1 mlr5"> ${fns:getDictLabel(pwEnter.eteam.type, 'pw_enter_type', '')} </span> </c:if>
		                <c:if test="${not empty pwEnter.eproject}"> <span class="bd1 mlr5"> ${fns:getDictLabel(pwEnter.eproject.type, 'pw_enter_type', '')} </span> </c:if>
		                <c:if test="${not empty pwEnter.ecompany}"> <span class="bd1 mlr5"> ${fns:getDictLabel(pwEnter.ecompany.type, 'pw_enter_type', '')} </span> </c:if>
	                </td> --%>
                    <%-- <td>
                        <table style="width: 100%;">
                            <tr>
                                <td style="text-align: left; border-left: none;">
                                    <c:if test="${not empty pwEnter.eteam}">${fns:getDictLabel(pwEnter.eteam.type, 'pw_enter_type', '')}
                                    | ${fns:getDictLabel(pwEnter.eteam.status, 'pw_enter_shstatus', '')}
                                    | ${pwEnter.eteam.team.name}</c:if>
                                    <c:if test="${empty pwEnter.eteam}"> - | - | - </c:if>
                            <tr>
                                <td style="text-align: left; border-left: none;">
                                    <c:if test="${not empty pwEnter.eproject}">${fns:getDictLabel(pwEnter.eproject.type, 'pw_enter_type', '')}
                                    | ${fns:getDictLabel(pwEnter.eproject.status, 'pw_enter_shstatus', '')}
                                    | ${pwEnter.eproject.project.name}</c:if>
                                    <c:if test="${empty pwEnter.eproject}"> - | - | - </c:if>
                            <tr>
                                <td style="text-align: left; border-left: none;">
                                    <c:if test="${not empty pwEnter.ecompany}">${fns:getDictLabel(pwEnter.ecompany.type, 'pw_enter_type', '')} | ${fns:getDictLabel(pwEnter.ecompany.status, 'pw_enter_shstatus', '')} | ${pwEnter.ecompany.pwCompany.name}</c:if>
                                    <c:if test="${empty pwEnter.ecompany}"> - | - | - </c:if>
                                </td>
                            </tr>
                        </table>
                    </td> --%>
                    <%-- <td>
                        <c:set var="iterm" value="${fns:getDictLabel(pwEnter.term, 'pw_enter_term', '')}"></c:set>
                        <c:if test="${empty iterm}">${pwEnter.term} 天</c:if>
                        <c:if test="${not empty iterm}">${iterm}</c:if>
                    </td> --%>
                    <%-- <td>
                        <c:if test="${not empty pwEnter.startDate}"><fmt:formatDate value="${pwEnter.startDate}"
                                                                                    pattern="yyyy-MM-dd"/></c:if>
                        <c:if test="${empty pwEnter.startDate}">-</c:if>至
                        <c:if test="${not empty pwEnter.endDate}"><fmt:formatDate value="${pwEnter.endDate}"
                                                                                  pattern="yyyy-MM-dd"/></c:if>
                        <c:if test="${empty pwEnter.endDate}">-</c:if>
                    </td> --%>
                <td>
                    <c:if test="${not empty pwEnter.startDate}"><fmt:formatDate value="${pwEnter.startDate}"
                                                                                pattern="yyyy-MM-dd"/></c:if>
                    <c:if test="${empty pwEnter.startDate}">-</c:if>
                </td>
                <td>
                    <c:if test="${not empty pwEnter.endDate}">
                        <c:if test="${(not empty pwEnter) && (pwEnter.status eq '3')}">
                            <span class="primary-color"><fmt:formatDate value="${pwEnter.endDate}"
                                                                        pattern="yyyy-MM-dd"/></span>
                        </c:if>
                        <c:if test="${(not empty pwEnter) && (pwEnter.status ne '3')}">
                            <fmt:formatDate value="${pwEnter.endDate}" pattern="yyyy-MM-dd"/>
                        </c:if>
                    </c:if>
                    <c:if test="${empty pwEnter.endDate}">-</c:if>
                </td>
                <%--<td>--%>
                    <%--<c:if test="${not empty pwEnter.updateDate}">--%>
                        <%--<fmt:formatDate value="${pwEnter.updateDate}" pattern="yyyy-MM-dd"/>--%>
                    <%--</c:if>--%>
                    <%--<c:if test="${empty pwEnter.updateDate}">-</c:if>--%>
                <%--</td>--%>
                    <%--<td>--%>
                    <%--${pwEnter.remarks}--%>
                    <%--</td>--%>
                    <%--<shiro:hasPermission name="pw:pwEnter:edit">--%>
                    <%--<td>--%>
                    <%--<a class="check_btn btn-pray btn-lx-primary" href="${ctx}/pw/pwEnter/form?id=${pwEnter.id}">查看</a>--%>
                    <%--</td>--%>
                    <%--</shiro:hasPermission>--%>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>

<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>
</body>
</html>