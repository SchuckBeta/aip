<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>监听管理</title>
	<%@include file="/WEB-INF/views/include/backtable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
	</script>
</head>
<body>
	<div class="mybreadcrumbs">
		<span>监听</span>
	</div>
	<div class="content_panel">
		<ul class="nav nav-tabs">
			<li><a href="${ctx}/actyw/actYwGclazz/">监听列表</a></li>
			<li class="active"><a href="${ctx}/actyw/actYwGclazz/form?id=${actYwGclazz.id}">监听<shiro:hasPermission name="actyw:actYwGclazz:edit">${not empty actYwGclazz.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="actyw:actYwGclazz:edit">查看</shiro:lacksPermission></a></li>
		</ul><br/>
		<form:form id="inputForm" modelAttribute="actYwGclazz" action="${ctx}/actyw/actYwGclazz/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>
			<div class="control-group">
				<label class="control-label">流程：</label>
				<div class="controls">
					<form:select path="group" class="input-xlarge ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">节点：</label>
				<div class="controls">
					<form:select path="gnode" class="input-xlarge ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">监听：</label>
				<div class="controls">
					<form:select path="listener" class="input-xlarge ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div class="form-actions">
				<shiro:hasPermission name="actyw:actYwGclazz:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</form:form>
	</div>
	<div id="dialog-message" title="信息">
		<p id="dialog-content"></p>
	</div>
</body>
</html>