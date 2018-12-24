<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>监听数据管理</title>
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
		<span>监听数据</span>
	</div>
	<div class="content_panel">
		<ul class="nav nav-tabs">
			<li><a href="${ctx}/actyw/actYwGclazzData/">监听数据列表</a></li>
			<li class="active"><a href="${ctx}/actyw/actYwGclazzData/form?id=${actYwGclazzData.id}">监听数据<shiro:hasPermission name="actyw:actYwGclazzData:edit">${not empty actYwGclazzData.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="actyw:actYwGclazzData:edit">查看</shiro:lacksPermission></a></li>
		</ul><br/>
		<form:form id="inputForm" modelAttribute="actYwGclazzData" action="${ctx}/actyw/actYwGclazzData/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>
			<div class="control-group">
				<label class="control-label">申报ID：</label>
				<div class="controls">
					<form:input path="applyId" htmlEscape="false" maxlength="64" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">监听ID：</label>
				<div class="controls">
					<form:input path="gclazzId" htmlEscape="false" maxlength="64" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否为第一次触发监听生成的数据：</label>
				<div class="controls">
					<form:select path="isStart" class="input-xlarge ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">传递数据Json：</label>
				<div class="controls">
					<form:input path="datas" htmlEscape="false" class="input-xlarge "/>
				</div>
			</div>
			<div class="form-actions">
				<shiro:hasPermission name="actyw:actYwGclazzData:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</form:form>
	</div>
	<div id="dialog-message" title="信息">
		<p id="dialog-content"></p>
	</div>
</body>
</html>