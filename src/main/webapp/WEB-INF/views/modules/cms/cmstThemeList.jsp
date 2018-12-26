<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>站点模板主题</title>
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
				<span>站点模板主题</span> <i class="line weight-line"></i>
			</div>
		</div>
		<form:form id="searchForm" modelAttribute="cmstTheme" action="${ctx}/cms/cmstTheme/" method="post" class="form-horizontal clearfix form-search-block">
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<div class="col-control-group">
				<div class="control-group">
					<label class="control-label">删除标记</label>
					<div class="controls">
						<form:select path="delFlag" class="input-medium">
							<form:option value="" label="--请选择--"/>
							<form:options items="${fns:getDictList('del_flag')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
			</div>
			<div class="search-btn-box">
				<button type="submit" class="btn btn-primary">查询</button>
				<shiro:hasPermission name="dr:drEquipment:edit">
					<shiro:hasPermission name="cms:cmstTheme:edit"><a  class="btn btn-primary" href="${ctx}/cms/cmstTheme/form">站点模板主题添加</a></shiro:hasPermission>
				</shiro:hasPermission>

			</div>
		</form:form>
		<sys:message content="${message}"/>
			<table id="contentTable" class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
				<thead>
					<tr>
						<th>模板ID</th>
						<th>模板类型</th>
						<th>创建者</th>
						<th>创建时间</th>
						<th>更新者</th>
						<th>更新时间</th>
						<th>备注信息</th>
						<shiro:hasPermission name="cms:cmstTheme:edit"><th>操作</th></shiro:hasPermission>
					</tr>
				</thead>
				<tbody>
				<c:forEach items="${page.list}" var="cmstTheme">
					<tr>
						<td><a href="${ctx}/cms/cmstTheme/form?id=${cmstTheme.id}">
							${cmstTheme.tpl.name}
						</a></td>
						<td>
							${cmstTheme.theme.name}
						</td>
						<td>
							${cmstTheme.createBy.id}
						</td>
						<td>
							<fmt:formatDate value="${cmstTheme.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
						<td>
							${cmstTheme.updateBy.id}
						</td>
						<td>
							<fmt:formatDate value="${cmstTheme.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
						<td>
							${cmstTheme.remarks}
						</td>
						<shiro:hasPermission name="cms:cmstTheme:edit"><td>
							<a class="btn btn-small btn-primary" href="${ctx}/cms/cmstTheme/form?id=${cmstTheme.id}">修改</a>
							<a class="btn btn-small btn-default" href="${ctx}/cms/cmstTheme/delete?id=${cmstTheme.id}" onclick="return confirmx('确认要删除该站点模板主题吗？', this.href)">删除</a>
						</td></shiro:hasPermission>
					</tr>
				</c:forEach>
				</tbody>
			</table>
			${page.footer}
	</div>
</body>
</html>