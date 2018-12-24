<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>项目通告管理</title>
	<%@include file="/WEB-INF/views/include/backtable.jsp" %>
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
	<div class="mybreadcrumbs">
		<span>项目通告</span>
	</div>
	<div class="content_panel">
		<ul class="nav nav-tabs">
			<li class="active"><a href="${ctx}/actyw/actYwAnnounce/">项目通告列表</a></li>
			<shiro:hasPermission name="actyw:actYwAnnounce:edit"><li><a href="${ctx}/actyw/actYwAnnounce/form">项目通告添加</a></li></shiro:hasPermission>
		</ul>
		<form:form id="searchForm" modelAttribute="actYwAnnounce" action="${ctx}/actyw/actYwAnnounce/" method="post" class="breadcrumb form-search">
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<ul class="ul-form">
				<li><label>流程节点编号</label>
				</li>
				<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
				<li class="clearfix"></li>
			</ul>
		</form:form>
		<sys:message content="${message}"/>
		<table id="contentTable" class="table table-bordered table-condensed">
			<thead>
				<tr>
					<th>流程节点编号</th>
					<th>内容</th>
					<th>附件编号</th>
					<th>开始时间</th>
					<th>结束时间</th>
					<th>最后更新时间</th>
					<th>备注</th>
					<shiro:hasPermission name="actyw:actYwAnnounce:edit"><th>操作</th></shiro:hasPermission>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${page.list}" var="actYwAnnounce">
				<tr>
					<td><a href="${ctx}/actyw/actYwAnnounce/form?id=${actYwAnnounce.id}">
						${actYwAnnounce.gnodeId}
					</a></td>
					<td>
						${actYwAnnounce.content}
					</td>
					<td>
						${actYwAnnounce.files}
					</td>
					<td>
						<fmt:formatDate value="${actYwAnnounce.beginDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
					<td>
						<fmt:formatDate value="${actYwAnnounce.endDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
					<td>
						<fmt:formatDate value="${actYwAnnounce.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
					<td>
						${actYwAnnounce.remarks}
					</td>
					<shiro:hasPermission name="actyw:actYwAnnounce:edit"><td>
	    				<a class="check_btn btn-pray btn-lx-primary" href="${ctx}/actyw/actYwAnnounce/form?id=${actYwAnnounce.id}">修改</a>
						<a class="check_btn btn-pray btn-lx-primary" href="${ctx}/actyw/actYwAnnounce/delete?id=${actYwAnnounce.id}" onclick="return confirmx('确认要删除该项目通告吗？', this.href)">删除</a>
					</td></shiro:hasPermission>
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