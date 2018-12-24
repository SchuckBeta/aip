<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>

</head>
<body>
<form:form id="searchForm" cssStyle="margin-bottom: 0">
    <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
    <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
</form:form>
<table class="table table-bordered table-condensed table-center table-orange table-nowrap">
    <thead>
    <tr>
        <th>类别</th>
        <th>名称</th>
        <th>型号</th>
        <th>负责人</th>
        <!-- <th>手机/电话</th> -->
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${page.list}" var="pwFassets">
        <tr>
            <td> ${pwFassets.pwCategory.name}</td>
        	<td>${pwFassets.name}</td>
            <td> ${pwFassets.specification}</td>
            <td> ${pwFassets.respName}</td>
            <%-- <td>
            	<c:if test="${not empty pwFassets.respMobile}">${pwFassets.respMobile}</c:if><c:if test="${empty pwFassets.respMobile}">- </c:if>/
            	<c:if test="${not empty pwFassets.respPhone}">${pwFassets.respPhone}</c:if><c:if test="${empty pwFassets.respPhone}"> -</c:if>
            </td> --%>
            <td>
				<a class="btn btn-default btn-small"
                   href="${ctx}/pw/pwFassets/cancel?id=${pwFassets.id}"
                   data-toggle="confirm"
                   data-msg="确认取消[${pwFassets.pwCategory.name} ${pwFassets.name}]分配吗？"
                   data-id="${pwFassets.id}">取消分配</a>
			</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
${page.footer}
</body>
</html>
