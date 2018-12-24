<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>流程表单管理</title>
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
		<span>流程表单</span>
	</div>
	<div class="content_panel">
		<ul class="nav nav-tabs">
			<li class="active"><a href="${ctx}/actyw/actYwForm/">流程表单列表</a></li>
			<shiro:hasPermission name="actyw:actYwForm:edit"><li><a href="${ctx}/actyw/actYwForm/form">流程表单添加</a></li></shiro:hasPermission>
		</ul>
		<form:form id="searchForm" modelAttribute="actYwForm" action="${ctx}/actyw/actYwForm/" method="post" class="breadcrumb form-search">
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<ul class="ul-form">
				<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
				<li><label>表单组</label>
					<form:select id="theme" path="theme" class="input-medium">
						<form:option value="" label="--请选择--"/>
						<form:options items="${formThemes}" itemLabel="name" itemValue="id" htmlEscape="false"/>
					</form:select>
				</li>
				<li><label>流程类型</label>
					<form:select id="flowType" path="flowType" class="input-medium">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_category')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</li>
				<li id="formTypeDiv"><label>表单类型</label>
					<form:select id="formType" path="type" class="input-medium">
						<form:option value="" label="--请选择--"/>
						<form:options items="${formTypeEnums}" itemLabel="name" itemValue="key" htmlEscape="false"/>
					</form:select>
				</li>
				<li id="formStyleTypeDiv"><label>样式类型</label>
					<form:select id="formStyleType" path="styleType" class="input-medium">
						<form:option value="" label="--请选择--"/>
						<form:options items="${formStyleTypeEnums}" itemLabel="name" itemValue="key" htmlEscape="false"/>
					</form:select>
				</li>
				<li id="formClientTypeDiv"><label>客户端类型</label>
					<form:select id="formClientType" path="clientType" class="input-medium">
						<form:option value="" label="--请选择--"/>
						<form:options items="${formClientTypeEnums}" itemLabel="name" itemValue="key" htmlEscape="false"/>
					</form:select>
				</li>
				<script type="text/javascript">
					$(function(){
						changeFormTypeNode();
					});

					function changeFormTypeNode(){
						var flowType = $("#flowType");
						var formType = $("#formType");
						var formTypeDiv = $("#formTypeDiv");
						if($(flowType).val() == null){
							$(formTypeDiv).hide();
						}
						$(flowType).change(function(){
							if((flowType == null) || (flowType == undefined) || (flowType =='')){
								$(formTypeDiv).hide();
							}else{
								$.ajax({
								     type:'post',
								     url:'${ctx}/actyw/actYwForm/getFormTypes?type='+$(flowType).val(),
								     dataType:'json',
								     success:function(data){
								          if((data != null) && (data.length > 0)){
								        	  $(formType).find("option").remove();
								        	  $(formType).append('<option value="" data-value="">--请选择--</option>');
								        	  $.each($(data), function(idx, ele){
									        	  $(formType).append('<option value="' + ele.key + '" data-value="' + ele.value + '">' + ele.flowName + "-" + ele.name + '</option>');
								        	  });
									 		$(formTypeDiv).show();
								          }else{
								        	$(formTypeDiv).hide();
								          }
								      }
								});
							}
						});
					}
				</script>
				<li><label>模式：</label>
					<form:select path="model" class="input-medium">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_form_tpltype')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</li>
			</ul>
		</form:form>
		<sys:message content="${message}"/>
		<table id="contentTable" class="table table-bordered table-condensed table-thead-bg">
			<thead>
				<tr>
					<th>表单组</th>
					<th>流程类型</th>
					<th>项目类型</th>
					<th>表单类型</th>
					<th>客户端</th>
					<th>表单名称</th>
					<th>当前、列表模板路径</th>
					<th>模式</th>
					<%--<th>模板参数</th>--%>
					<!-- <th>所属机构</th> -->
					<th>最后更新时间</th>
					<th>备注</th>
					<shiro:hasPermission name="actyw:actYwForm:edit"><th>操作</th></shiro:hasPermission>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${page.list}" var="actYwForm">
				<tr>
					<td>
						<a href="${ctx}/actyw/actYwForm/form?id=${actYwForm.id}">
							<c:forEach var="item" items="${formThemes}">
								<c:if test="${actYwForm.theme eq item.id}">${item.name }</c:if>
							</c:forEach>
						</a>
					</td>
					<td>
						<a href="${ctx}/actyw/actYwForm/form?id=${actYwForm.id}">
							<c:forEach var="curflowType" items="${actYwForm.flowTypes }" varStatus="idx">
								${fns:getDictLabel(curflowType, 'act_category', '')}
								<c:if test="${(idx.index+1) ne fn:length(actYwForm.flowTypes)}">
									<c:if test="${(idx.index+1) % 2 == 1}">|</c:if>
								</c:if>
								<c:if test="${(idx.index+1) % 2 == 0}"><br></c:if>

							</c:forEach>
						</a>
					</td>
					<td>
						<a href="${ctx}/actyw/actYwForm/form?id=${actYwForm.id}">
						<c:forEach var="item" items="${actYwForm.proTypes}" varStatus="idx">
							<c:if test="${(idx.index + 1) ne fn:length(actYwForm.proTypes)}">${fns:getDictLabel(item, 'act_project_type', '')}/</c:if>
							<c:if test="${(idx.index + 1)  eq fn:length(actYwForm.proTypes)}">${fns:getDictLabel(item, 'act_project_type', '')}</c:if>
						</c:forEach>
						</a>
					</td>
					<td>
						<c:forEach var="item" items="${formTypeEnums}">
							<c:if test="${actYwForm.type eq item.key}">${item.name }</c:if>
						</c:forEach>
					</td>
					<td>
						<c:forEach var="item" items="${formClientTypeEnums}">
							<c:if test="${actYwForm.clientType eq item.key}">${item.name }</c:if>
						</c:forEach>
					</td>
					<td>
						${actYwForm.name}
					</td>
					<td style="text-align: left;">
						<%-- ${actYwForm.name}&nbsp;&nbsp;&nbsp;&nbsp; --%>当前：${actYwForm.path}
						<br>列表：<%-- ${actYwForm.listForm.name}&nbsp;&nbsp;&nbsp;&nbsp; --%>${actYwForm.listForm.path}
					</td>
					<td>
						${fns:getDictLabel(actYwForm.model, 'act_form_tpltype', '')}
					</td>
					<%--<td>--%>
						<%--${actYwForm.params}--%>
					<%--</td>--%>
					<%-- <td>
						${actYwForm.office.name}
					</td> --%>
					<td>
						<fmt:formatDate value="${actYwForm.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
					<td>
						${actYwForm.remarks}
					</td>
					<shiro:hasPermission name="actyw:actYwForm:edit"><td>
	    				<a class="check_btn btn-pray btn-lx-primary" href="${ctx}/actyw/actYwForm/form?id=${actYwForm.id}">修改</a>
						<a class="check_btn btn-pray btn-lx-primary" href="${ctx}/actyw/actYwForm/delete?id=${actYwForm.id}" onclick="return confirmx('确认要删除该流程表单吗？', this.href)">删除</a>
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