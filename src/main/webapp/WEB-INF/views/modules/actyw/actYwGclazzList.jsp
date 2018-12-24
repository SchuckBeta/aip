<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>监听管理</title>
	<%@include file="/WEB-INF/views/include/backtable.jsp" %>
	<style>
		.table-thead-bg thead tr{
			background-color: #f4e6d4;
		}
		.table th{
			background: none;
		}
		#searchForm{
			height: auto;
			padding: 15px 0 0;
			overflow: hidden;
		}
		.ul-form input[type="text"]{
			height: 20px;
		}
		.ul-form select{
			height: 30px;
			width: 174px;
			max-width: 174px;
		}
		.form-search .ul-form li{
			margin-bottom: 15px;
		}
		.form-search .ul-form li.btns{
			float: right;
		}
		.table{
			margin-bottom: 20px;
		}
	</style>
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
		<span>监听</span>
	</div>
	<div class="content_panel">
		<ul class="nav nav-tabs">
			<li class="active"><a href="${ctx}/actyw/actYwGclazz/">监听列表</a></li>
			<shiro:hasPermission name="actyw:actYwGclazz:edit"><li><a href="${ctx}/actyw/actYwGclazz/form">监听添加</a></li></shiro:hasPermission>
		</ul>
		<form:form id="searchForm" modelAttribute="actYwGclazz" action="${ctx}/actyw/actYwGclazz/" method="post" class="breadcrumb form-search">
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<ul class="ul-form">
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
				<li><label>流程：</label>
					<form:select path="group" class="input-medium">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</li>
				<li><label>节点：</label>
					<form:select path="gnode" class="input-medium">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</li>
				<li><label>监听：</label>
					<form:select path="listener" class="input-medium">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</li>
			</ul>
		</form:form>
		<sys:message content="${message}"/>
		<table id="contentTable" class="table table-striped table-bordered table-condensed table-thead-bg">
			<thead>
				<tr>
					<th>流程</th>
					<th>节点</th>
					<th>监听</th>
					<shiro:hasPermission name="actyw:actYwGclazz:edit"><th>操作</th></shiro:hasPermission>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${page.list}" var="actYwGclazz">
				<tr>
					<td><a href="${ctx}/actyw/actYwGclazz/form?id=${actYwGclazz.id}">
						${fns:getDictLabel(actYwGclazz.group, '', '')}
					</a></td>
					<td>
						${fns:getDictLabel(actYwGclazz.gnode, '', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwGclazz.listener, '', '')}
					</td>
					<shiro:hasPermission name="actyw:actYwGclazz:edit"><td>
	    				<a class="check_btn btn-pray btn-lx-primary" href="${ctx}/actyw/actYwGclazz/form?id=${actYwGclazz.id}">修改</a>
						<a class="check_btn btn-pray btn-lx-primary" href="${ctx}/actyw/actYwGclazz/delete?id=${actYwGclazz.id}" onclick="return confirmx('确认要删除该监听吗？', this.href)">删除</a>
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