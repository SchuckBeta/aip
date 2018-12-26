<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>站点明细</title>
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
				<span>站点明细</span> <i class="line weight-line"></i>
			</div>
		</div>
		<form:form id="searchForm" modelAttribute="cmssSite" action="${ctx}/cms/cmssSite/" method="post" class="form-horizontal clearfix form-search-block">
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<div class="col-control-group">
				<div class="control-group">
					<label class="control-label">父级编号</label>
					<div class="controls">
						<form:select path="site.id" class="input-medium">
							<form:option value="" label="--请选择--"/>
							<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">站点标题</label>
					<div class="controls">
						<form:input path="title" htmlEscape="false" maxlength="100" class="input-medium"/>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">关键字</label>
					<div class="controls">
						<form:input path="keywords" htmlEscape="false" maxlength="255" class="input-medium"/>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">主题</label>
					<div class="controls">
						<form:input path="theme" htmlEscape="false" maxlength="255" class="input-medium"/>
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
					<shiro:hasPermission name="cms:cmssSite:edit"><a  class="btn btn-primary" href="${ctx}/cms/cmssSite/form">站点明细添加</a></shiro:hasPermission>
				</shiro:hasPermission>

			</div>
		</form:form>
		<sys:message content="${message}"/>
			<table id="contentTable" class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
				<thead>
					<tr>
						<th>父级编号</th>
						<th>站点标题</th>
						<th>站点租户Logo</th>
						<th>站点Logo</th>
						<th>站点首页栏目（必须为根栏目）</th>
						<th>站点域名</th>
						<th>描述</th>
						<th>关键字</th>
						<th>主题</th>
						<th>版权信息</th>
						<th>更新时间</th>
						<th>备注信息</th>
						<shiro:hasPermission name="cms:cmssSite:edit"><th>操作</th></shiro:hasPermission>
					</tr>
				</thead>
				<tbody>
				<c:forEach items="${page.list}" var="cmssSite">
					<tr>
						<td><a href="${ctx}/cms/cmssSite/form?id=${cmssSite.id}">
							${cmssSite.site.name}
						</a></td>
						<td>
							${cmssSite.title}
						</td>
						<td>
							${cmssSite.logo}
						</td>
						<td>
							${cmssSite.logoSite}
						</td>
						<td>
							${cmssSite.index}
						</td>
						<td>
							${cmssSite.domain}
						</td>
						<td>
							${cmssSite.description}
						</td>
						<td>
							${cmssSite.keywords}
						</td>
						<td>
							${cmssSite.theme}
						</td>
						<td>
							${cmssSite.copyright}
						</td>
						<td>
							<fmt:formatDate value="${cmssSite.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
						<td>
							${cmssSite.remarks}
						</td>
						<shiro:hasPermission name="cms:cmssSite:edit"><td>
							<a class="btn btn-small btn-primary" href="${ctx}/cms/cmssSite/form?id=${cmssSite.id}">修改</a>
							<a class="btn btn-small btn-default" href="${ctx}/cms/cmssSite/delete?id=${cmssSite.id}" onclick="return confirmx('确认要删除该站点明细吗？', this.href)">删除</a>
						</td></shiro:hasPermission>
					</tr>
				</c:forEach>
				</tbody>
			</table>
			${page.footer}
	</div>
</body>
</html>