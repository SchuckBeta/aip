<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>模板</title>
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
				<span>模板</span> <i class="line weight-line"></i>
			</div>
		</div>
		<form:form id="searchForm" modelAttribute="cmsTpl" action="${ctx}/cms/cmsTpl/" method="post" class="form-horizontal clearfix form-search-block">
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<div class="col-control-group">
				<div class="control-group">
					<label class="control-label">模板类型(顶级)</label>
					<div class="controls">
						<form:select path="top.id" class="input-medium">
							<form:option value="" label="--请选择--"/>
							<form:options items="${cmstTopTypes}" itemLabel="name" itemValue="id" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">模板类型</label>
					<div class="controls">
						<form:select path="type.id" class="input-medium">
							<form:option value="" label="--请选择--"/>
							<form:options items="${cmstTypes}" itemLabel="name" itemValue="id" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">名称</label>
					<div class="controls">
						<form:input path="name" htmlEscape="false" maxlength="100" class="input-medium"/>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">创建者</label>
					<div class="controls">
						<form:input path="createBy.id" htmlEscape="false" maxlength="64" class="input-medium"/>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">创建时间</label>
					<div class="controls">
						<input name="createDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
							value="<fmt:formatDate value="${cmsTpl.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
							onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">更新者</label>
					<div class="controls">
						<form:input path="updateBy.id" htmlEscape="false" maxlength="64" class="input-medium"/>
					</div>
				</div>
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
					<shiro:hasPermission name="cms:cmsTpl:edit"><a  class="btn btn-primary" href="${ctx}/cms/cmsTpl/form">模板添加</a></shiro:hasPermission>
				</shiro:hasPermission>

			</div>
		</form:form>
		<sys:message content="${message}"/>
			<table id="contentTable" class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
				<thead>
					<tr>
						<th>模板类型(顶级)</th>
						<th>模板类型</th>
						<th>名称</th>
						<th>更新时间</th>
						<th>备注信息</th>
						<shiro:hasPermission name="cms:cmsTpl:edit"><th>操作</th></shiro:hasPermission>
					</tr>
				</thead>
				<tbody>
				<c:forEach items="${page.list}" var="cmsTpl">
					<tr>
						<td><a href="${ctx}/cms/cmsTpl/form?id=${cmsTpl.id}">
							${cmsTpl.top.name}
						</a></td>
						<td>
							${cmsTpl.type.name}
						</td>
						<td>
							${cmsTpl.name}
						</td>
						<td>
							<fmt:formatDate value="${cmsTpl.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
						<td>
							${cmsTpl.remarks}
						</td>
						<shiro:hasPermission name="cms:cmsTpl:edit"><td>
							<a class="btn btn-small btn-primary" href="${ctx}/cms/cmsTpl/form?id=${cmsTpl.id}">修改</a>
							<a class="btn btn-small btn-default" href="${ctx}/cms/cmsTpl/delete?id=${cmsTpl.id}" onclick="return confirmx('确认要删除该模板吗？', this.href)">删除</a>
						</td></shiro:hasPermission>
					</tr>
				</c:forEach>
				</tbody>
			</table>
			${page.footer}
	</div>
</body>
</html>