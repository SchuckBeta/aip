<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>模板页面管理</title>
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
		<span>模板页面</span>
	</div>
	<div class="content_panel">
		<ul class="nav nav-tabs">
			<li><a href="${ctx}/cms/cmstPage/">模板页面列表</a></li>
			<li class="active"><a href="${ctx}/cms/cmstPage/form?id=${cmstPage.id}">模板页面<shiro:hasPermission name="cms:cmstPage:edit">${not empty cmstPage.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="cms:cmstPage:edit">查看</shiro:lacksPermission></a></li>
		</ul><br/>
		<form:form id="inputForm" modelAttribute="cmstPage" action="${ctx}/cms/cmstPage/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>
			<div class="control-group">
				<label class="control-label">模板ID：</label>
				<div class="controls">
					<form:select path="tpl.id" class="input-xlarge required">
						<form:option value="" label="--请选择--"/>
						<%-- <form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/> --%>
					</form:select>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">页面ID：</label>
				<div class="controls">
					<form:select path="cpage.id" class="input-xlarge required">
						<form:option value="" label="--请选择--"/>
						<%-- <form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/> --%>
					</form:select>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">备注信息：</label>
				<div class="controls">
					<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
				</div>
			</div>
			<div class="form-actions">
				<shiro:hasPermission name="cms:cmstPage:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</form:form>
	</div>
	<div id="dialog-message" title="信息">
		<p id="dialog-content"></p>
	</div>
</body>
</html>