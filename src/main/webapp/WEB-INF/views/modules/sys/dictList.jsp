<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@include file="/WEB-INF/views/include/backtable.jsp" %>
<html>
<head>
<title>字典管理</title>
<link rel="stylesheet" type="text/css"
	href="/static/common/tablepage.css" />
<!-- <meta name="decorator" content="default" /> -->

<script type="text/javascript">
$(document).ready(function() {
	$("#ps").val($("#pageSize").val());
});
	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
</script>
<style>
	td, th {
		text-align: center !important;
	}
	th {
		background: #f4e6d4 !important;
	}
	#btnSubmit{
	  float:right;
	  background: #e9432d !important;
	}
	table td .btn{
		padding:3px 11px ;
		background: #e5e5e5;
		color:#666;
	}
	table td .btn:hover{
		background:#e9432d ;
		color:#fff;
	}
</style>
</head>
<body>
<div class="mybreadcrumbs"><span>字典管理</span></div>
	<div class="table-page">
		<ul class="nav nav-tabs">
			<li class="active"><a href="${ctx}/sys/dict/">字典列表</a></li>
			<shiro:hasPermission name="sys:dict:edit">
				<li><a href="${ctx}/sys/dict/form?sort=10">字典添加</a></li>
			</shiro:hasPermission>
		</ul>
		<form:form id="searchForm" modelAttribute="dict"
			action="${ctx}/sys/dict/" method="post"
			class="breadcrumb form-search">
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
			<input id="pageSize" name="pageSize" type="hidden"
				value="${page.pageSize}" />
			<label>类型：</label>
			<form:select id="type" path="type" class="input-medium">
				<form:option value="" label="" />
				<form:options items="${typeList}" htmlEscape="false" />
			</form:select>
		&nbsp;&nbsp;<label>描述 ：</label>
			<form:input path="description" htmlEscape="false" maxlength="50"
				class="input-medium" />
		&nbsp;<input id="btnSubmit" class="btn btn-danger" type="submit"
				value="查询" />
		</form:form>
		<sys:message content="${message}" />
		<table id="contentTable"
			class="table table-hover table-bordered table-condensed">
			<thead>
				<tr>
					<th>键值</th>
					<th>标签</th>
					<th>类型</th>
					<th>描述</th>
					<th>排序</th>
					<shiro:hasPermission name="sys:dict:edit">
						<th>操作</th>
					</shiro:hasPermission>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${page.list}" var="dict">
					<tr>
						<td>${dict.value}</td>
						<td><a href="${ctx}/sys/dict/form?id=${dict.id}" style="color:#157ab5 !important">${dict.label}</a></td>
						<td><a href="javascript:"
							onclick="$('#type').val('${dict.type}');$('#searchForm').submit();return false;" style="color:#157ab5 !important" >${dict.type}</a></td>
						<td>${dict.description}</td>
						<td>${dict.sort}</td>
						<shiro:hasPermission name="sys:dict:edit">
							<td style="white-space:nowrap"><a href="${ctx}/sys/dict/form?id=${dict.id}" class="btn">修改</a> <a
								href="${ctx}/sys/dict/delete?id=${dict.id}&type=${dict.type}"
								onclick="return confirmx('确认要删除该字典吗？', this.href)" class="btn">删除</a> <a class="btn"
								href="<c:url value='${fns:getAdminPath()}/sys/dict/form?type=${dict.type}&sort=${dict.sort+10}' ><c:param name='description' value='${dict.description}'/></c:url>">添加键值</a>
							</td>
						</shiro:hasPermission>
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<%-- <div class="pagination">${page}</div> --%>
		${page.footer}
	</div>
</body>
</html>