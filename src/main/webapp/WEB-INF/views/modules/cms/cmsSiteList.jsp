<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>站点管理</title>
	<!-- <meta name="decorator" content="default"/> -->
	<%@include file="/WEB-INF/views/include/backtable.jsp" %>
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data = ${fns:toJson(list)}, ids = [], rootIds = [];
			for (var i=0; i<data.length; i++){
				ids.push(data[i].id);
			}
			ids = ',' + ids.join(',') + ',';
			for (var i=0; i<data.length; i++){
				if (ids.indexOf(','+data[i].parentId+',') == -1){
					if ((','+rootIds.join(',')+',').indexOf(','+data[i].parentId+',') == -1){
						rootIds.push(data[i].parentId);
					}
				}
			}
			for (var i=0; i<rootIds.length; i++){
				addRow("#treeTableList", tpl, data, rootIds[i], true);
			}
			$("#treeTable").treeTable({expandLevel : 5});
		});
		function addRow(list, tpl, data, pid, root){
			for (var i=0; i<data.length; i++){
				var row = data[i];
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {
						dict: {
							isCurr: getDictLabel(${fns:toJson(fns:getDictList(''))}, row.isCurr),
							isZzd: getDictLabel(${fns:toJson(fns:getDictList(''))}, row.isZzd),
						blank123:0}, pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
		}
	</script>
</head>
<body>
	<div class="mybreadcrumbs">
		<span>站点</span>
	</div>
	<div class="content_panel">
		<ul class="nav nav-tabs">
			<li class="active"><a href="${ctx}/cms/cmsSite/">站点列表</a></li>
			<shiro:hasPermission name="cms:cmsSite:edit"><li><a href="${ctx}/cms/cmsSite/form">站点添加</a></li></shiro:hasPermission>
		</ul>
		<form:form id="searchForm" modelAttribute="cmsSite" action="${ctx}/cms/cmsSite/" method="post" class="breadcrumb form-search">
			<ul class="ul-form">
				<li><label>编号：</label>
					<form:input path="id" htmlEscape="false" maxlength="64" class="input-medium"/>
				</li>
				<li><label>父级编号：</label>
				</li>
				<li><label>所有父级编号：</label>
					<form:input path="parentIds" htmlEscape="false" maxlength="2000" class="input-medium"/>
				</li>
				<%-- <li><label>配置编号：</label>
					<form:input path="config.id" htmlEscape="false" maxlength="64" class="input-medium"/>
				</li> --%>
				<li><label>站点名称：</label>
					<form:input path="name" htmlEscape="false" maxlength="100" class="input-medium"/>
				</li>
				<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
				<li class="clearfix"></li>
			</ul>
		</form:form>
		<sys:message content="${message}"/>
		<table id="treeTable" class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
					<th>编号</th>
					<th>父级编号</th>
					<th>所有父级编号</th>
					<th>站点名称</th>
					<th>是否当前站点</th>
					<th>是否子站点:0、否；1、是</th>
					<th>更新时间</th>
					<th>备注信息</th>
					<shiro:hasPermission name="cms:cmsSite:edit"><th>操作</th></shiro:hasPermission>
				</tr>
			</thead>
			<tbody id="treeTableList"></tbody>
		</table>
	</div>
	<div id="dialog-message" title="信息">
		<p id="dialog-content"></p>
	</div>
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td><a href="${ctx}/cms/cmsSite/form?id={{row.id}}">
				{{row.name}}
			</a></td>
			<td>
				{{row.parent.name}}
			</td>
			<td>
				{{row.name}}
			</td>
			<td>
				{{dict.isCurr}}
			</td>
			<td>
				{{dict.isZzd}}
			</td>
			<td>
				{{row.updateDate}}
			</td>
			<td>
				{{row.remarks}}
			</td>
			<shiro:hasPermission name="cms:cmsSite:edit"><td>
   				<a class="check_btn btn-pray btn-lx-primary" href="${ctx}/cms/cmsSite/form?id={{row.id}}">修改</a>
				<a class="check_btn btn-pray btn-lx-primary" href="${ctx}/cms/cmsSite/delete?id={{row.id}}" onclick="return confirmx('确认要删除该站点及所有子站点吗？', this.href)">删除</a>
				<a class="check_btn btn-pray btn-lx-primary" href="${ctx}/cms/cmsSite/form?parent.id={{row.id}}">添加下级站点</a>
			</td></shiro:hasPermission>
		</tr>
	</script>
</body>
</html>