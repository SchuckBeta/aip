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

            $.ajax({
                type: "GET",
                url: "${ctx}/pw/pwEnter/ajaxList",
                data: {
                	keys:"a"
               	},
                dataType: "json",
                success: function(data){
                	console.info(data.data.list);
                }
            });
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
            <%--<span>入驻审核</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>


    <form:form id="searchForm" modelAttribute="pwEnter" action="${ctx}/pw/pwEnter/list" method="post"
               class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="col-control-group">
            <div style="width:100%;height:45px;">
            <div class="control-group">
                <label class="control-label">入驻编号</label>
                <div class="controls">
                    <form:input path="no" htmlEscape="false" maxlength="64" class="input-medium"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">负责人</label>
                <div class="controls">
                    <form:input path="applicant.name" htmlEscape="false" maxlength="64" class="input-medium"/>
                        <%-- <sys:treeselect id="applicant" name="applicant" value="${pwEnter.applicant}"
                                        labelName="user.name" labelValue="${pwEnter.applicant.name}"
                                        title="用户" url="/sys/office/treeData?type=3" cssClass="input-small"
                                        cssStyle="width:120px;" allowClear="true" notAllowSelectParent="true"/> --%>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">状态</label>
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
            <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-sort table-nowrap table-subscribe">
        <thead>
        <tr>
            <th>入驻编号</th>
            <th>负责人</th>
            <th>入驻类型</th>
            <!-- <th>类型|状态|名称</th> -->
            <!-- <th>期限(天)</th> -->
            <!-- <th>周期</th> -->
            <th>入驻时间</th>
            <th>入驻有效期</th>
            <%--<th>最后更新时间</th>--%>
            <%--<th>备注</th>--%>
            <th>状态</th>
            <shiro:hasPermission name="pw:pwEnter:edit">
                <th>操作</th>
            </shiro:hasPermission>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="pwEnter" varStatus="idx">
            <c:if test="${(empty pwEnter.eteam) && (empty pwEnter.eprojects) && (empty pwEnter.ecompany) || (pwEnter.isTemp eq '1')}"><tr style="background-color: #eee;"></c:if>
            <c:if test="${((not empty pwEnter.eteam) || (not empty pwEnter.eprojects) || (not empty pwEnter.ecompany)) && (pwEnter.isTemp eq '0')}"><tr></c:if>
            <td><a href="${ctx}/pw/pwEnter/form?id=${pwEnter.id}">
                    ${pwEnter.no}
            </a></td>
            <td>
                    ${pwEnter.applicant.name}
            </td>
           <%--  <td class="deal-separator">
                <c:if test="${not empty pwEnter.eteam}">${fns:getDictLabel(pwEnter.eteam.type, 'pw_enter_type', '')}/</c:if>
                <c:if test="${not empty pwEnter.eprojects}">${fns:getDictLabel(pwEnter.eprojects[0].type, 'pw_enter_type', '')}/</c:if>
                <c:if test="${not empty pwEnter.ecompany}">${fns:getDictLabel(pwEnter.ecompany.type, 'pw_enter_type', '')}</c:if>
            </td> --%>
            <%-- <td>
                <c:if test="${not empty pwEnter.eteam}"> <span class="bd1 mlr5"> ${fns:getDictLabel(pwEnter.eteam.type, 'pw_enter_type', '')} </span> </c:if>
                <c:if test="${not empty pwEnter.eproject}"> <span class="bd1 mlr5"> ${fns:getDictLabel(pwEnter.eproject.type, 'pw_enter_type', '')} </span> </c:if>
                <c:if test="${not empty pwEnter.ecompany}"> <span class="bd1 mlr5"> ${fns:getDictLabel(pwEnter.ecompany.type, 'pw_enter_type', '')} </span> </c:if>
            </td> --%>
            <%-- <td>
                <c:if test="${(empty pwEnter.eteam) && (empty pwEnter.eproject) && (empty pwEnter.ecompany) || (pwEnter.isTemp eq '1')}">用户申请信息不完整，请督促完善后审核</c:if>
                <c:if test="${((not empty pwEnter.eteam) || (not empty pwEnter.eproject) || (not empty pwEnter.ecompany)) && (pwEnter.isTemp eq '0')}">
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
                </c:if>
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
                <c:if test="${not empty pwEnter.startDate}"><fmt:formatDate value="${pwEnter.startDate}" pattern="yyyy-MM-dd"/></c:if>
                <c:if test="${empty pwEnter.startDate}">-</c:if>
            </td>
            <td>
                <c:if test="${not empty pwEnter.endDate}">
                    <fmt:formatDate value="${pwEnter.endDate}" pattern="yyyy-MM-dd"/>
                </c:if>
                <c:if test="${empty pwEnter.endDate}">-</c:if>
            </td>
            <%--<td>--%>
            <%--<fmt:formatDate value="${pwEnter.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>--%>
            <%--</td>--%>
            <%--<td>--%>
            <%--${pwEnter.remarks}--%>
            <%--</td>--%>
            <td>
                <c:if test="${(not empty pwEnter) && (pwEnter.status eq '3')}">
                    <span class="primary-color">${fns:getDictLabel(pwEnter.status, 'pw_enter_status', '')}</span>
                </c:if>
                <c:if test="${(not empty pwEnter) && (pwEnter.status ne '3')}">
                    ${fns:getDictLabel(pwEnter.status, 'pw_enter_status', '')}
                </c:if>
            </td>
            <shiro:hasPermission name="pw:pwEnter:edit">
                <td style="white-space: nowrap">
                   	<a class="btn-primary btn-small btn" href="${ctx}/pw/pwEnter/form?id=${pwEnter.id}&isView=false&secondName=审核">审核</a>
                    <c:if test="${(empty pwEnter.eteam) && (empty pwEnter.eprojects) && (empty pwEnter.ecompany) || (pwEnter.isTemp eq '1')}">
                        <a class="btn-primary btn-small btn"
                           href="${ctx}/pw/pwEnter/ajaxSendNotify?id=${pwEnter.id}&type=62"
                           onclick="return confirmx('确认要发送申请警告吗？', this.href)">警告</a>
                        <a class="btn-primary btn-small btn"
                           href="${ctx}/pw/pwEnter/ajaxSendNotify?id=${pwEnter.id}&type=61"
                           onclick="return confirmx('确认要提醒完善资料吗？', this.href)">提醒</a>
                        <a class="btn-default btn-small btn"
                           href="${ctx}/pw/pwEnter/ajaxDelete?id=${pwEnter.id}"
                           onclick="return confirmx('确认要删除吗？', this.href)">删除</a>
                    </c:if>
                    <c:if test="${((not empty pwEnter.eteam) || (not empty pwEnter.eprojects) || (not empty pwEnter.ecompany)) && (pwEnter.isTemp eq '0')}">
                        <%--<c:if test="${pwEnter.status ne 0}">--%>
                        <%--<a class="check_btn btn-pray btn-lx-primary"--%>
                        <%--href="${ctx}/pw/pwEnter/form?id=${pwEnter.id}">查看</a>--%>
                        <%--</c:if>--%>
                        <c:if test="${pwEnter.status eq 0}">
                            <a class="btn-primary btn-small btn"
                               href="${ctx}/pw/pwEnter/form?id=${pwEnter.id}&isView=false&secondName=审核">审核</a>
                        </c:if>
                    </c:if>
                </td>
            </shiro:hasPermission>
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