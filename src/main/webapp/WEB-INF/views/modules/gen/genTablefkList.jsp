<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>GenTableFk</title>
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
				<span>GenTableFk</span> <i class="line weight-line"></i>
			</div>
		</div>
		<form:form id="searchForm" modelAttribute="genTablefk" action="${ctx}/gen/genTablefk/" method="post" class="form-horizontal clearfix form-search-block">
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<div class="col-control-group">
				<div class="control-group">
					<label class="control-label">表编号</label>
					<div class="controls">
						<form:select path="table.id" class="input-medium">
							<form:option value="" label="--请选择--"/>
							<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">表列编号</label>
					<div class="controls">
						<form:select path="tabcol.id" class="input-medium">
							<form:option value="" label="--请选择--"/>
							<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">表编号</label>
					<div class="controls">
						<form:select path="tabfk.id" class="input-medium">
							<form:option value="" label="--请选择--"/>
							<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
			</div>
			<div class="search-btn-box">
				<button type="submit" class="btn btn-primary">查询</button>
				<shiro:hasPermission name="dr:drEquipment:edit">
					<shiro:hasPermission name="gen:genTablefk:edit"><a  class="btn btn-primary" href="${ctx}/gen/genTablefk/form">GenTableFk添加</a></shiro:hasPermission>
				</shiro:hasPermission>

			</div>
		</form:form>
		<sys:message content="${message}"/>
			<table id="contentTable" class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
				<thead>
					<tr>
						<th>表编号</th>
						<th>表列编号</th>
						<th>表编号</th>
						<th>更新时间</th>
						<th>备注信息</th>
						<shiro:hasPermission name="gen:genTablefk:edit"><th>操作</th></shiro:hasPermission>
					</tr>
				</thead>
				<tbody>
				<c:forEach items="${page.list}" var="genTablefk">
					<tr>
						<td><a href="${ctx}/gen/genTablefk/form?id=${genTablefk.id}">
							${genTablefk.table.name}
						</a></td>
						<td>
							${genTablefk.tabcol.name}
						</td>
						<td>
							${genTablefk.tabfk.name}
						</td>
						<td>
							<fmt:formatDate value="${genTablefk.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
						<td>
							${genTablefk.remarks}
						</td>
						<shiro:hasPermission name="gen:genTablefk:edit"><td>
							<a class="btn btn-small btn-primary" href="${ctx}/gen/genTablefk/form?id=${genTablefk.id}">修改</a>
							<a class="btn btn-small btn-default" href="${ctx}/gen/genTablefk/delete?id=${genTablefk.id}" onclick="return confirmx('确认要删除该GenTableFk吗？', this.href)">删除</a>
						</td></shiro:hasPermission>
					</tr>
				</c:forEach>
				</tbody>
			</table>
			${page.footer}
	</div>
</body>
</html>