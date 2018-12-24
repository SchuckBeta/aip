<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>留言</title>
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
				<span>留言</span> <i class="line weight-line"></i>
			</div>
		</div>
		<form:form id="searchForm" modelAttribute="cmsGuestbook" action="${ctx}/cms/cmsGuestbook/" method="post" class="form-horizontal clearfix form-search-block">
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<ul class="ul-form">
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<div class="col-control-group">
					</div>
						<div class="control-group">
							<label class="control-label">留言分类（咨询，问题反馈）</label>
							<div class="controls">
							<form:select path="type" class="input-medium">
								<form:option value="" label="--请选择--"/>
								<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
						<div class="control-group">
							<label class="control-label">留言内容</label>
							<div class="controls">
							<form:input path="content" htmlEscape="false" maxlength="255" class="input-medium"/>
						</div>
					</div>
						<div class="control-group">
							<label class="control-label">姓名</label>
							<div class="controls">
							<form:input path="name" htmlEscape="false" maxlength="100" class="input-medium"/>
						</div>
					</div>
						<div class="control-group">
							<label class="control-label">邮箱</label>
							<div class="controls">
							<form:input path="email" htmlEscape="false" maxlength="100" class="input-medium"/>
						</div>
					</div>
						<div class="control-group">
							<label class="control-label">手机号</label>
							<div class="controls">
							<form:input path="phone" htmlEscape="false" maxlength="100" class="input-medium"/>
						</div>
					</div>
						<div class="control-group">
							<label class="control-label">QQ</label>
							<div class="controls">
							<form:input path="qq" htmlEscape="false" maxlength="50" class="input-medium"/>
						</div>
					</div>
					</div>
					</div>
					</div>
					</div>
					</div>
						<div class="control-group">
							<label class="control-label">回复内容</label>
							<div class="controls">
							<form:input path="reContent" htmlEscape="false" maxlength="64" class="input-medium"/>
						</div>
					</div>
					</div>
			</div>
			<div class="search-btn-box">
				<button type="submit" class="btn btn-primary">查询</button>
				<shiro:hasPermission name="dr:drEquipment:edit">
					<shiro:hasPermission name="cms:cmsGuestbook:edit"><a  class="btn btn-primary" href="${ctx}/cms/cmsGuestbook/form">留言添加</a></shiro:hasPermission>
				</shiro:hasPermission>

			</div>
		</form:form>
		<sys:message content="${message}"/>
			<table id="contentTable" class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
				<thead>
					<tr>
						<th>留言分类（咨询，问题反馈）</th>
						<th>留言内容</th>
						<th>姓名</th>
						<th>邮箱</th>
						<th>手机号</th>
						<th>QQ</th>
						<th>审核状态（待审核，审核通过，审核不通过）</th>
						<th>是否推荐（0否1是）</th>
						<th>留言时间</th>
						<th>回复人</th>
						<th>回复时间</th>
						<th>回复内容</th>
						<shiro:hasPermission name="cms:cmsGuestbook:edit"><th>操作</th></shiro:hasPermission>
					</tr>
				</thead>
				<tbody>
				<c:forEach items="${page.list}" var="cmsGuestbook">
					<tr>
						<td><a href="${ctx}/cms/cmsGuestbook/form?id=${cmsGuestbook.id}">
							${fns:getDictLabel(cmsGuestbook.type, '', '')}
						</a></td>
						<td>
							${cmsGuestbook.content}
						</td>
						<td>
							${cmsGuestbook.name}
						</td>
						<td>
							${cmsGuestbook.email}
						</td>
						<td>
							${cmsGuestbook.phone}
						</td>
						<td>
							${cmsGuestbook.qq}
						</td>
						<td>
							${cmsGuestbook.auditstatus}
						</td>
						<td>
							${fns:getDictLabel(cmsGuestbook.isRecommend, '', '')}
						</td>
						<td>
							<fmt:formatDate value="${cmsGuestbook.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
						<td>
							${cmsGuestbook.reUser.name}
						</td>
						<td>
							<fmt:formatDate value="${cmsGuestbook.reDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
						<td>
							${cmsGuestbook.reContent}
						</td>
						<shiro:hasPermission name="cms:cmsGuestbook:edit"><td>
							<a class="btn btn-small btn-primary" href="${ctx}/cms/cmsGuestbook/form?id=${cmsGuestbook.id}">修改</a>
							<a class="btn btn-small btn-default" href="${ctx}/cms/cmsGuestbook/delete?id=${cmsGuestbook.id}" onclick="return confirmx('确认要删除该留言吗？', this.href)">删除</a>
						</td></shiro:hasPermission>
					</tr>
				</c:forEach>
				</tbody>
			</table>
			${page.footer}
	</div>
</body>
</html>