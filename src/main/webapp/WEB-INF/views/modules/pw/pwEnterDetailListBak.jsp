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
            <%--<span>入驻${pwEnterDetail.pename}管理</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>

    <form:form id="searchForm" modelAttribute="pwEnterDetail"
               action="${ctx}/pw/pwEnterDetail/list?petype=${pwEnterDetail.petype}" method="post"
               class="form-horizontal clearfix form-search-block">
        <input id="type" name="type" type="hidden" value="${type}"/>
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">入驻编号</label>
                <div class="controls">
                    <form:input path="pwEnter.no" htmlEscape="false" maxlength="255" class="input-medium"/>
                </div>
            </div>
            <c:if test="${not empty pwEnterDetail.petype}">
                <%-- <c:if test="${pwEnterDetail.petype eq 0}">
                    <div class="control-group">
                        <label class="control-label">团队名称</label>
                        <div class="controls">
                            <form:input path="team.name" htmlEscape="false" maxlength="255" class="input-medium"/>
                        </div>
                    </div>
                </c:if> --%>
               <%-- <c:if test="${pwEnterDetail.petype eq 1}">
                    <div class="control-group">
                        <label class="control-label">项目名称</label>
                        <div class="controls">
                            <form:input path="project.name" htmlEscape="false" maxlength="255"
                                        class="input-medium"/>
                        </div>
                    </div>
                </c:if>
                <c:if test="${pwEnterDetail.petype eq 2}">
                    <div class="control-group">
                        <label class="control-label">企业名称</label>
                        <div class="controls">
                            <form:input path="pwCompany.name" htmlEscape="false" maxlength="255"
                                        class="input-medium"/>
                        </div>
                    </div>
                </c:if>--%>
            </c:if>

            <div class="control-group">
                <label class="control-label">所属学院</label>
                <div class="controls">
                    <form:select path="pwEnter.applicant.office.name" htmlEscape="false" maxlength="255" class="form-control" id="collegeId">
                        <form:option value="" label="所有学院"/>
                            <form:options items="${fns:findColleges()}" itemLabel="name" itemValue="name"
                                          htmlEscape="false"/>
                        </form:select>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">入驻状态 </label>
                <div class="controls">
                    <c:if test="${empty pwEnterStatus}">
                        <form:select path="pwEnter.status" class="input-medium" cssStyle="width: 164px;">
                            <form:option value="" label="--请选择--"/>
                            <form:options items="${fns:getDictList('pw_enter_status')}" itemLabel="label"
                                          itemValue="value" htmlEscape="false"/>
                        </form:select>
                    </c:if>
                    <c:if test="${not empty pwEnterStatus}">
                        <form:select path="pwEnter.status" class="input-medium" cssStyle="width: 164px;">
                            <form:option value="" label="--请选择--"/>
                            <form:options items="${pwEnterStatus}" itemLabel="name"
                                          itemValue="key" htmlEscape="false"/>
                        </form:select>
                    </c:if>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">入驻时间</label>
                <div class="controls">
                    <input id="qstartQDate" name="pwEnter.startQDate" type="text" readonly="readonly" maxlength="20"
                           class="input-medium Wdate"
                           value="<fmt:formatDate value="${pwEnterDetail.pwEnter.startQDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,maxDate:$('#qstartDate').val()});"/> -
                    <input id="qstartDate" name="pwEnter.startDate" type="text" readonly="readonly" maxlength="20"
                           class="input-medium Wdate"
                           value="<fmt:formatDate value="${pwEnterDetail.pwEnter.startDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true, minDate:$('#qstartQDate').val()});"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">入驻有效期</label>
                <div class="controls">
                    <input id="qendQDate" name="pwEnter.endQDate" type="text" readonly="readonly" maxlength="20"
                           class="input-medium Wdate"
                           value="<fmt:formatDate value="${pwEnterDetail.pwEnter.endQDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,maxDate:$('#qendDate').val()});"/> -
                    <input id="qendDate" name="pwEnter.endDate" type="text" readonly="readonly" maxlength="20"
                           class="input-medium Wdate"
                           value="<fmt:formatDate value="${pwEnterDetail.pwEnter.endDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true, minDate:$('#qendQDate').val()});"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">续期时间</label>
                <div class="controls">
                    <input id="qreQDate" name="pwEnter.reQDate" type="text" readonly="readonly" maxlength="20"
                           class="input-medium Wdate"
                           value="<fmt:formatDate value="${pwEnterDetail.pwEnter.reQDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,maxDate:$('#qreDate').val()});"/> -
                    <input id="qreDate" name="pwEnter.reDate" type="text" readonly="readonly" maxlength="20"
                           class="input-medium Wdate"
                           value="<fmt:formatDate value="${pwEnterDetail.pwEnter.reDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true, minDate:$('#qreQDate').val()});"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">退孵时间</label>
                <div class="controls">
                    <input id="qexitQDate" name="pwEnter.exitQDate" type="text" readonly="readonly" maxlength="20"
                           class="input-medium Wdate"
                           value="<fmt:formatDate value="${pwEnterDetail.pwEnter.exitQDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,maxDate:$('#qexitDate').val()});"/> -
                    <input id="qexitDate" name="pwEnter.exitDate" type="text" readonly="readonly" maxlength="20"
                           class="input-medium Wdate"
                           value="<fmt:formatDate value="${pwEnterDetail.pwEnter.exitDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true, minDate:$('#qexitQDate').val()});"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">关键字</label>
                <div class="controls">
                    <c:if test="${pwEnterDetail.petype eq 0}">
                    <form:input path="pwEnter.keys" htmlEscape="false" maxlength="255" class="input-medium"
                        placeholder="团队/负责人,区分大小写" />
                    </c:if>
                    <c:if test="${pwEnterDetail.petype eq 1}">
                    <form:input path="pwEnter.keys" htmlEscape="false" maxlength="255" class="input-medium"
                    placeholder="团队/负责人/项目名称,区分大小写" />
                    </c:if>
                    <c:if test="${pwEnterDetail.petype eq 2}">
                    <form:input path="pwEnter.keys" htmlEscape="false" maxlength="255" class="input-medium"
                    placeholder="团队/负责人/企业名称,区分大小写" />
                    </c:if>

                        <%-- <input name="pwEnter.keys" value="${pwEnterDetail.pwEnter.keys}" class="input-medium" placeholder="区分大小写"> --%>
                </div>
            </div>
                <%-- <div class="control-group">
                    <label class="control-label">学号</label>
                    <div class="controls">
                        <form:input path="pwEnter.applicant.no" htmlEscape="false" maxlength="255"
                                    class="input-medium"/>
                    </div>
                </div> --%>
                <%-- <li><label>类型</label>
                    <form:select id="type" path="type" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('pw_enter_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </li> --%>
        </div>
        <div class="search-btn-box">
            <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-sort table-nowrap table-subscribe">
        <thead>
        <tr>
            <th>入驻编号</th>
            <th>
                <c:if test="${not empty pwEnterDetail.petype}">
                    <c:if test="${pwEnterDetail.petype eq 0}">团队名称</c:if>
                    <c:if test="${pwEnterDetail.petype eq 1}">项目名称</c:if>
                    <c:if test="${pwEnterDetail.petype eq 2}">企业名称</c:if>
                </c:if>
            </th>
            <th>负责人</th>
            <th>所属学院</th>
            <!-- <th>学号</th> -->
            <th>组员人数</th>
            <th>入驻时间</th>
            <th>入驻有效期</th>
            <th>续期次数</th>
            <th>续期时间</th>
            <th>退孵时间</th>
            <th>状态</th>
            <%--<th>最后更新时间</th>--%>
            <%--<th>备注</th>--%>
            <%--<shiro:hasPermission name="pw:pwEnterDetail:edit"><th>操作</th></shiro:hasPermission>--%>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="cpwEnterDetail">
            <tr>
                <td><a href="${ctx}/pw/pwEnter/form?id=${cpwEnterDetail.pwEnter.id}&isView=true">
                        ${cpwEnterDetail.pwEnter.no}
                </a></td>
                <td class="deal-separator">
                    <c:if test="${pwEnterDetail.petype eq 0}">
                        <c:if test="${not empty cpwEnterDetail.team}">${cpwEnterDetail.team.name}</c:if><c:if
                            test="${empty cpwEnterDetail.team}">-</c:if>
                    </c:if>
                    <c:if test="${pwEnterDetail.petype eq 1}">
                        <c:if test="${not empty cpwEnterDetail.project}">${cpwEnterDetail.project.name}</c:if><c:if
                            test="${empty cpwEnterDetail.project}">-</c:if>
                    </c:if>
                    <c:if test="${pwEnterDetail.petype eq 2}">
                        <c:if test="${not empty cpwEnterDetail.pwCompany}">${cpwEnterDetail.pwCompany.name}</c:if><c:if
                            test="${empty cpwEnterDetail.pwCompany}">-</c:if>
                    </c:if>
                </td>
                <td>
                        ${cpwEnterDetail.pwEnter.applicant.name}
                </td>
                <td>
                        ${cpwEnterDetail.pwEnter.applicant.office.name}
                </td>
                    <%-- <td>
                            ${cpwEnterDetail.pwEnter.applicant.no}
                    </td>
                    <td>
                    	<c:if test="${not empty cpwEnterDetail.pwEnter.startDate}"><fmt:formatDate value="${cpwEnterDetail.pwEnter.startDate}" pattern="yyyy-MM-dd"/></c:if>
                        <c:if test="${empty cpwEnterDetail.pwEnter.startDate}">-</c:if>至
                        <c:if test="${not empty cpwEnterDetail.pwEnter.endDate}"><fmt:formatDate value="${cpwEnterDetail.pwEnter.endDate}" pattern="yyyy-MM-dd"/></c:if>
                        <c:if test="${empty cpwEnterDetail.pwEnter.startDate}">-</c:if>
                    </td> --%>
                <td>
                        ${cpwEnterDetail.pwEnter.teamNum}
                </td>
                <td>
                    <c:if test="${not empty cpwEnterDetail.pwEnter.startDate}"><fmt:formatDate
                            value="${cpwEnterDetail.pwEnter.startDate}" pattern="yyyy-MM-dd"/></c:if>
                    <c:if test="${empty cpwEnterDetail.pwEnter.startDate}">-</c:if>
                </td>
                <td>
                    <c:if test="${not empty cpwEnterDetail.pwEnter.endDate}">
                        <c:if test="${(not empty cpwEnterDetail.pwEnter) && (cpwEnterDetail.pwEnter.status eq '3')}">
                            <span class="primary-color"><fmt:formatDate value="${cpwEnterDetail.pwEnter.endDate}"
                                                                        pattern="yyyy-MM-dd"/></span>
                        </c:if>
                        <c:if test="${(not empty cpwEnterDetail.pwEnter) && (cpwEnterDetail.pwEnter.status ne '3')}">
                            <fmt:formatDate value="${cpwEnterDetail.pwEnter.endDate}" pattern="yyyy-MM-dd"/>
                        </c:if>
                    </c:if>
                    <c:if test="${empty cpwEnterDetail.pwEnter.endDate}">-</c:if>
                </td>
                <td>${cpwEnterDetail.pwEnter.termNum}</td>
                <td>
                    <c:if test="${not empty cpwEnterDetail.pwEnter.reDate}">
                        <fmt:formatDate value="${cpwEnterDetail.pwEnter.reDate}" pattern="yyyy-MM-dd"/>
                    </c:if>
                    <c:if test="${empty cpwEnterDetail.pwEnter.reDate}">-</c:if>
                </td>
                <td>
                    <c:if test="${not empty cpwEnterDetail.pwEnter.exitDate}">
                        <fmt:formatDate value="${cpwEnterDetail.pwEnter.exitDate}" pattern="yyyy-MM-dd"/>
                        <%-- <fmt:formatDate value="${cpwEnterDetail.pwEnter.updateDate}" pattern="yyyy-MM-dd"/> --%>
                    </c:if>
                    <c:if test="${empty cpwEnterDetail.pwEnter.exitDate}">-</c:if>
                </td>
                <td>
                    <c:if test="${(not empty cpwEnterDetail.pwEnter) && (cpwEnterDetail.pwEnter.status eq '3')}">
                        <span class="primary-color">${fns:getDictLabel(cpwEnterDetail.pwEnter.status, 'pw_enter_status', '')}</span>
                    </c:if>
                    <c:if test="${(not empty cpwEnterDetail.pwEnter) && (cpwEnterDetail.pwEnter.status ne '3')}">
                        ${fns:getDictLabel(cpwEnterDetail.pwEnter.status, 'pw_enter_status', '')}
                    </c:if>
                </td>
                    <%--<td>--%>
                    <%--<fmt:formatDate value="${cpwEnterDetail.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>--%>
                    <%--</td>--%>
                    <%--<td>--%>
                    <%--${cpwEnterDetail.remarks}--%>
                    <%--</td>--%>
                    <%--<shiro:hasPermission name="pw:pwEnterDetail:edit"><td>--%>
                    <%--<a class="check_btn btn-pray btn-lx-primary" href="${ctx}/pw/pwEnter/form?id=${cpwEnterDetail.pwEnter.id}&isView=true">查看</a>--%>
                    <%--</td></shiro:hasPermission>--%>
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