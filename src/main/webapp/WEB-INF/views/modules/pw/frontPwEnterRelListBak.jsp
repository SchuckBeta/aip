<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ page errorPage="/WEB-INF/views/error/formMiss.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>${fns:getConfig('frontTitle')}</title>
    <meta name="decorator" content="cyjd-site-default"/>
</head>
<body>
<div class="container container-ct">
    <ol class="breadcrumb" style="margin-top: 0">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li class="active">创业基地</li>
        <li class="active">入驻查询</li>
    </ol>
    <div class="cate-table-module">
        <h4 class="title">我的入驻列表</h4>
        <div class="table-block">
            <table class="table table-bordered table-condensed table-coffee table-nowrap table-center">
                <thead>
                <tr>
                    <!-- <th>申报编号</th> -->
                    <th>入驻编号</th>
                    <th>审核状态</th>
                    <th>入驻房间</th>
                    <th>入驻类型</th>
                    <!-- <th>入驻时间</th> -->
                    <th>入驻团队</th>
                    <th>入驻项目</th>
                    <th>入驻企业</th>
                    <th>申请时间</th>
                    <th>入驻时间</th>
                    <th>入驻有效期</th>
                    <th>续期次数</th>
                    <th>续期时间</th>
                    <th>退孵时间</th>
                    <%--<th>备注</th>--%>
                    <%--<th>操作</th>--%>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${page.list}" var="pwEnterRel">
                    <tr>
                        <%-- <td>
                            <a href="${ctxFront}/pw/pwEnterRel/form?id=${pwEnterRel.id}&actYwApply.id=${pwEnterRel.actYwApply.relId}">${pwEnterRel.actYwApply.no}</a>
                        </td> --%>
                        <td>
                            <a href="${ctxFront}/pw/pwEnterRel/form?id=${pwEnterRel.id}&actYwApply.id=${pwEnterRel.actYwApply.relId}">${pwEnterRel.pwEnterDetail.pwEnter.no}</a>
                        </td>
                        <td>
                        	<c:if test="${(not empty pwEnterRel.pwEnterDetail.pwEnter) && (pwEnterRel.pwEnterDetail.pwEnter.status eq '3')}">
                                <span class="primary-color">${fns:getDictLabel(pwEnterRel.pwEnterDetail.pwEnter.status, 'pw_enter_status', '')}</span>
	                        </c:if>
	                        <c:if test="${(not empty pwEnterRel.pwEnterDetail.pwEnter) && (pwEnterRel.pwEnterDetail.pwEnter.status ne '3')}">
                                ${fns:getDictLabel(pwEnterRel.pwEnterDetail.pwEnter.status, 'pw_enter_status', '')}
	                        </c:if>
                        </td>
                        <td>
                            <c:if test="${not empty pwEnterRel.eroom.pwRoom}">${pwEnterRel.eroom.pwRoom.name}</c:if>
                            <c:if test="${empty pwEnterRel.eroom.pwRoom.name}"> - </c:if>
                        </td>
		                <td class="deal-separator">
			                <c:if test="${not empty pwEnterRel.pwEnterDetail.pwEnter.eteam}">${fns:getDictLabel(pwEnterRel.pwEnterDetail.pwEnter.eteam.type, 'pw_enter_type', '')}/</c:if>
			                <c:if test="${not empty pwEnterRel.pwEnterDetail.pwEnter.eproject}">${fns:getDictLabel(pwEnterRel.pwEnterDetail.pwEnter.eproject.type, 'pw_enter_type', '')}/</c:if>
			                <c:if test="${not empty pwEnterRel.pwEnterDetail.pwEnter.ecompany}">${fns:getDictLabel(pwEnterRel.pwEnterDetail.pwEnter.ecompany.type, 'pw_enter_type', '')} </span> </c:if>
		                </td>
                        <%-- <td>
			                <c:if test="${not empty pwEnterRel.pwEnterDetail.pwEnter.eteam}"> <span class="bd1 mlr5"> ${fns:getDictLabel(pwEnterRel.pwEnterDetail.pwEnter.eteam.type, 'pw_enter_type', '')} </span> </c:if>
			                <c:if test="${not empty pwEnterRel.pwEnterDetail.pwEnter.eproject}"> <span class="bd1 mlr5"> ${fns:getDictLabel(pwEnterRel.pwEnterDetail.pwEnter.eproject.type, 'pw_enter_type', '')} </span> </c:if>
			                <c:if test="${not empty pwEnterRel.pwEnterDetail.pwEnter.ecompany}"> <span class="bd1 mlr5"> ${fns:getDictLabel(pwEnterRel.pwEnterDetail.pwEnter.ecompany.type, 'pw_enter_type', '')} </span> </c:if>
		                </td> --%>
                        <td>
			                <c:if test="${not empty pwEnterRel.pwEnterDetail.pwEnter.eteam}">${pwEnterRel.pwEnterDetail.pwEnter.eteam.team.name}</c:if>
			                <c:if test="${empty pwEnterRel.pwEnterDetail.pwEnter.eteam}">-</c:if>
		                </td>
                        <td>
			                <c:if test="${not empty pwEnterRel.pwEnterDetail.pwEnter.eproject}">${pwEnterRel.pwEnterDetail.pwEnter.eproject.project.name}</c:if>
			                <c:if test="${empty pwEnterRel.pwEnterDetail.pwEnter.eproject}">-</c:if>
		                </td>
                        <td>
			                <c:if test="${not empty pwEnterRel.pwEnterDetail.pwEnter.ecompany}">${pwEnterRel.pwEnterDetail.pwEnter.ecompany.pwCompany.name}</c:if>
			                <c:if test="${empty pwEnterRel.pwEnterDetail.pwEnter.ecompany}">-</c:if>
		                </td>
                        <%-- <td>
                                ${fns:getDictLabel(pwEnterRel.pwEnterDetail.pwEnter.term, 'pw_enter_term', '')}
                        </td> --%>
                        <%-- <td>
                            <c:if test="${not empty pwEnterRel.pwEnterDetail.pwEnter.startDate}"><fmt:formatDate
                                    value="${pwEnterRel.pwEnterDetail.pwEnter.startDate}" pattern="yyyy-MM-dd"/></c:if>
                            <c:if test="${empty pwEnterRel.pwEnterDetail.pwEnter.startDate}">-</c:if>至
                            <c:if test="${not empty pwEnterRel.pwEnterDetail.pwEnter.endDate}"><fmt:formatDate
                                    value="${pwEnterRel.pwEnterDetail.pwEnter.endDate}" pattern="yyyy-MM-dd"/></c:if>
                            <c:if test="${empty pwEnterRel.pwEnterDetail.pwEnter.endDate}">-</c:if>
                        </td> --%>
                        <td>
                            <fmt:formatDate value="${pwEnterRel.actYwApply.createDate}" pattern="yyyy-MM-dd"/>
                        </td>
                        <td>
                            <c:if test="${not empty pwEnterRel.pwEnterDetail.pwEnter.startDate}"><fmt:formatDate
                                    value="${pwEnterRel.pwEnterDetail.pwEnter.startDate}" pattern="yyyy-MM-dd"/></c:if>
                            <c:if test="${empty pwEnterRel.pwEnterDetail.pwEnter.startDate}">-</c:if>
                        </td>
                        <td>
                            <c:if test="${not empty pwEnterRel.pwEnterDetail.pwEnter.endDate}">
	                            <fmt:formatDate value="${pwEnterRel.pwEnterDetail.pwEnter.endDate}" pattern="yyyy-MM-dd"/>
                            </c:if>
                            <c:if test="${empty pwEnterRel.pwEnterDetail.pwEnter.endDate}">-</c:if>
                        </td>
                        <td>
                            ${pwEnterRel.pwEnterDetail.pwEnter.termNum}
                        </td>
                        <td>
                            <c:if test="${not empty pwEnterRel.pwEnterDetail.pwEnter.reDate}">
	                            <fmt:formatDate value="${pwEnterRel.pwEnterDetail.pwEnter.reDate}" pattern="yyyy-MM-dd"/>
                            </c:if>
                            <c:if test="${empty pwEnterRel.pwEnterDetail.pwEnter.reDate}">-</c:if>
                        </td>
                        <td>
	                        <c:if test="${(not empty pwEnterRel.pwEnterDetail.pwEnter) && (pwEnterRel.pwEnterDetail.pwEnter.status eq '5')}">
	                            <fmt:formatDate value="${pwEnterRel.pwEnterDetail.pwEnter.exitDate}" pattern="yyyy-MM-dd"/>
	                            <%-- <fmt:formatDate value="${pwEnterRel.pwEnterDetail.pwEnter.updateDate}" pattern="yyyy-MM-dd"/> --%>
	                        </c:if>
	                        <c:if test="${(empty pwEnterRel.pwEnterDetail.pwEnter) || (pwEnterRel.pwEnterDetail.pwEnter.status ne '5')}">-</c:if>
                        </td>
                            <%--<td>--%>
                            <%--${pwEnterRel.remarks}--%>
                            <%--</td>--%>
                        <%--<td>--%>
                            <%--<a class="btn btn-primary btn-sm" <c:if--%>
                                    <%--test="${pwEnterRel.pwEnterDetail.pwEnter.isAudited }"> disabled </c:if> href="--%>
                            <%--<c:if test="${!pwEnterRel.pwEnterDetail.pwEnter.isAudited }"> ${ctxFront}/pw/pwEnter/form?id=${pwEnterRel.actYwApply.relId}--%>
                            <%--</c:if>--%>
                            <%--<c:if test="${pwEnterRel.pwEnterDetail.pwEnter.isAudited }">javascript: void(0);--%>
                            <%--</c:if>--%>
                        <%--">完善信息</a>--%>
                        <%--</td>--%>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            ${page.footer}
        </div>
    </div>
    <form:form id="searchForm" modelAttribute="pwEnterRel" cssClass="hide" action="${ctxFront}/pw/pwEnterRel/list"
               method="post">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden"
               value="${page.pageSize}"/>
    </form:form>
</div>
<script>
    $(document).ready(function () {
        $("#ps").val($("#pageSize").val());
        $('#content').css('min-height', function () {
            return $(window).height() - 403
        });
    });
    function page(n, s) {
        $("#pageNo").val(n);
        $("#pageSize").val(s);
        $("#searchForm").submit();
        return false;
    }
</script>
</body>
</html>
