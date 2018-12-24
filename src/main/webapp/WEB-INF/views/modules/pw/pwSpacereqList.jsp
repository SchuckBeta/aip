<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>入驻场地需求</title>
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
				<span>入驻场地需求</span> <i class="line weight-line"></i>
			</div>
		</div>
		<form:form id="searchForm" modelAttribute="pwSpacereq" action="${ctx}/pw/pwSpacereq/" method="post" class="form-horizontal clearfix form-search-block">
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<ul class="ul-form">
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<div class="col-control-group">
					</div>
					</div>
					</div>
					</div>
					</div>
					</div>
					</div>
					</div>
					</div>
					</div>
					</div>
			</div>
			<div class="search-btn-box">
				<button type="submit" class="btn btn-primary">查询</button>
				<shiro:hasPermission name="dr:drEquipment:edit">
					<shiro:hasPermission name="pw:pwSpacereq:edit"><a  class="btn btn-primary" href="${ctx}/pw/pwSpacereq/form">入驻场地需求添加</a></shiro:hasPermission>
				</shiro:hasPermission>

			</div>
		</form:form>
		<sys:message content="${message}"/>
			<table id="contentTable" class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
				<thead>
					<tr>
						<th>申报编号</th>
						<th>工位数</th>
						<th>场地数：平方米</th>
						<th>孵化期限:年</th>
						<th>最后更新时间</th>
						<th>备注</th>
						<shiro:hasPermission name="pw:pwSpacereq:edit"><th>操作</th></shiro:hasPermission>
					</tr>
				</thead>
				<tbody>
				<c:forEach items="${page.list}" var="pwSpacereq">
					<tr>
						<td><a href="${ctx}/pw/pwSpacereq/form?id=${pwSpacereq.id}">
							${pwSpacereq.eid}
						</a></td>
						<td>
							${pwSpacereq.workNum}
						</td>
						<td>
							${pwSpacereq.spaceNum}
						</td>
						<td>
							${pwSpacereq.term}
						</td>
						<td>
							<fmt:formatDate value="${pwSpacereq.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
						<td>
							${pwSpacereq.remarks}
						</td>
						<shiro:hasPermission name="pw:pwSpacereq:edit"><td>
							<a class="btn btn-small btn-primary" href="${ctx}/pw/pwSpacereq/form?id=${pwSpacereq.id}">修改</a>
							<a class="btn btn-small btn-default" href="${ctx}/pw/pwSpacereq/delete?id=${pwSpacereq.id}" onclick="return confirmx('确认要删除该入驻场地需求吗？', this.href)">删除</a>
						</td></shiro:hasPermission>
					</tr>
				</c:forEach>
				</tbody>
			</table>
			${page.footer}
	</div>
</body>
</html>