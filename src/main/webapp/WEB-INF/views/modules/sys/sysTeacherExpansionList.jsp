<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>导师信息管理</title>
	<meta name="decorator" content="default"/>
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
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/sys/sysTeacherExpansion/">导师信息列表</a></li>
		<shiro:hasPermission name="sys:sysTeacherExpansion:edit"><li><a href="${ctx}/sys/sysTeacherExpansion/form">导师信息添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="sysTeacherExpansion" action="${ctx}/sys/sysTeacherExpansion/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>职称：</label>
				<form:input path="technicalTitle" htmlEscape="false" maxlength="20" class="input-medium"/>
			</li>
			<li><label>服务意向：</label>
				<form:select path="serviceIntention" class="input-medium">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('master_help')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>导师来源：</label>
				<form:select path="teachertype" class="input-medium">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('master_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table  table-bordered table-condensed">
		<thead>
			<tr>
				<th>职工号</th>
				<th>姓名</th>
				<th>性别</th>
				<th>老师类型</th>
				<th>在研项目</th>
				<th>服务意向</th>
				<th>职称</th>
				<th>学历</th>
				<th>学位</th>
				<th>学院</th>
				<th>专业</th>
				<th>是否公开</th>
				<shiro:hasPermission name="sys:sysTeacherExpansion:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="sysTeacherExpansion">
			<tr>
				<td>
					${sysTeacherExpansion.user.no}
				</td>
				<td>
					${sysTeacherExpansion.user.name}
				</td>
				<td>
					<c:if test="${sysTeacherExpansion.user.sex == 1}">男</c:if>

					<c:if test="${sysTeacherExpansion.user.sex == 0}">女</c:if>
				</td>
				<td>
				  <c:if test="${sysTeacherExpansion.teachertype==0}">校园导师</c:if>

				  <c:if test="${sysTeacherExpansion.teachertype==1}">企业导师</c:if>
				</td>
				<td>
					<%-- ${sysTeacherExpansion.teachertype} --%>xm
				</td>
					
					
				<td>
				  <c:if test="${sysTeacherExpansion.serviceIntention==1}">开课</c:if>
				  <c:if test="${sysTeacherExpansion.serviceIntention==2}">讲座</c:if>
				  <c:if test="${sysTeacherExpansion.serviceIntention==3}">担任评委</c:if>
				  <c:if test="${sysTeacherExpansion.serviceIntention==4}">指导帮扶</c:if>
				  <c:if test="${sysTeacherExpansion.serviceIntention==5}">其他</c:if>
					
				</td>
					
				<td>
					${sysTeacherExpansion.technicalTitle}
				</td>
					
				<td>
					${sysTeacherExpansion.user.education}
				</td>
					
				<td>
					${sysTeacherExpansion.user.degree}
				</td>
					
				<td>
					${sysTeacherExpansion.user.office.name}
				</td>
					
				<td>
					${sysTeacherExpansion.user.professional}
				</td>
					
				<td>
				<c:if test="${sysTeacherExpansion.isOpen ==0}">公开</c:if>
				<c:if test="${sysTeacherExpansion.isOpen ==1}">不公开</c:if>
					
				</td>
					
					
				<shiro:hasPermission name="sys:sysTeacherExpansion:edit"><td>
    				<a href="${ctx}/sys/sysTeacherExpansion/form?id=${sysTeacherExpansion.id}">修改</a>
					<a href="${ctx}/sys/sysTeacherExpansion/delete?id=${sysTeacherExpansion.id}" onclick="return confirmx('确认要删除该导师信息吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>