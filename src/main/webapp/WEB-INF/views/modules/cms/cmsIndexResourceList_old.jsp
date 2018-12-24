<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>首页资源管理</title>
	<meta name="decorator" content="default"/>
		<link rel="stylesheet" type="text/css"
	href="/static/common/tablepage.css" /> 
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function page(n,s){
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
background:#e9432d;
 float:right;
}
.form-actions{
  border-top:none;
}

</style>
</head>
<body>
<div class="table-page">
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/cmsIndexResource/">首页资源列表</a></li>
		<shiro:hasPermission name="cms:cmsIndexResource:edit"><li><a href="${ctx}/cms/cmsIndexResource/form">首页资源添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="cmsIndexResource" action="${ctx}/cms/cmsIndexResource/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label style="width: 100px">所属区域类型：</label>
				<form:select path="regionType" class="input-medium">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('regiontype_flag')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>资源名称：</label>
				<form:input path="resName" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li><label>资源状态：</label>
				<form:select path="resState" class="input-medium">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('resstate_flag')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-bordered table-condensed">
		<thead>
			<tr>
				<th>所属区域类型</th>
				<th>资源名称</th>
				<th>资源状态</th>
				<th>资源类型</th>
				<th>资源排序</th>
				<th>资源内容</th>
				<th>资源地址</th>
				<th>点击跳转地址</th>
				<shiro:hasPermission name="cms:cmsIndexResource:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="cmsIndexResource">
			<tr>
				<td><a href="${ctx}/cms/cmsIndexResource/form?id=${cmsIndexResource.id}">
					${fns:getDictLabel(cmsIndexResource.regionType, 'regiontype_flag', '')}
				</a></td>
				<td>
					${cmsIndexResource.resName}
				</td>
				<td>
					${fns:getDictLabel(cmsIndexResource.resState, 'resstate_flag', '')}
				</td>
				<td>
					${fns:getDictLabel(cmsIndexResource.resType, 'restype_flag', '')}
				</td>
				<td>
					${cmsIndexResource.resSort}
				</td>
				<td>
					${cmsIndexResource.resContent}
				</td>
				<td>
					${cmsIndexResource.url}
				</td>
				
				<td>
					${cmsIndexResource.jumpUrl}
				</td>
				<shiro:hasPermission name="cms:cmsIndexResource:edit"><td style="white-space:nowrap">
    				<a href="${ctx}/cms/cmsIndexResource/form?id=${cmsIndexResource.id}">修改</a>
					<a href="${ctx}/cms/cmsIndexResource/delete?id=${cmsIndexResource.id}" onclick="return confirmx('确认要删除该首页资源管理吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	</div>
</body>
</html>