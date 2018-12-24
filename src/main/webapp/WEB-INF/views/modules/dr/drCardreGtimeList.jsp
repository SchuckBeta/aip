<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>卡记录规则时间</title>
	<%@include file="/WEB-INF/views/include/backcyjd.jsp" %>

	<script type="text/javascript">
		$(document).ready(function() {
			$("#ps").val($("#pageSize").val());
		});
		function page(n,s){
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
				<span>卡记录规则时间</span> <i class="line weight-line"></i>
			</div>
		</div>
		<form:form id="searchForm" modelAttribute="drCardreGtime" action="${ctx}/dr/drCardreGtime/" method="post" class="form-horizontal clearfix form-search-block">
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<ul class="ul-form">
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<div class="col-control-group">
					</div>
			</div>
			<div class="search-btn-box">
				<button type="submit" class="btn btn-primary">查询</button>
				<shiro:hasPermission name="dr:drEquipment:edit">
					<shiro:hasPermission name="dr:drCardreGtime:edit"><a  class="btn btn-primary" href="${ctx}/dr/drCardreGtime/form">卡记录规则时间添加</a></shiro:hasPermission>
				</shiro:hasPermission>

			</div>
		</form:form>
		<sys:message content="${message}"/>
			<table id="contentTable" class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
				<thead>
					<tr>
						<shiro:hasPermission name="dr:drCardreGtime:edit"><th>操作</th></shiro:hasPermission>
					</tr>
				</thead>
				<tbody>
				<c:forEach items="${page.list}" var="drCardreGtime">
					<tr>
						<shiro:hasPermission name="dr:drCardreGtime:edit"><td>
							<a class="btn btn-small btn-primary" href="${ctx}/dr/drCardreGtime/form?id=${drCardreGtime.id}">修改</a>
							<a class="btn btn-small btn-default" href="${ctx}/dr/drCardreGtime/delete?id=${drCardreGtime.id}" onclick="return confirmx('确认要删除该卡记录规则时间吗？', this.href)">删除</a>
						</td></shiro:hasPermission>
					</tr>
				</c:forEach>
				</tbody>
			</table>
			${page.footer}
	</div>
</body>
</html>