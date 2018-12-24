<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>表单组</title>
	<%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
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
<div class="container-fluid">
    <div class="edit-bar clearfix">
        <div class="edit-bar-left">
            <span>表单组</span> <i class="line weight-line"></i>
        </div>
    </div>
    <form:form id="inputForm" modelAttribute="actYwGtheme" action="${ctx}/actyw/actYwGtheme/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>
			<div class="control-group">
				<label class="control-label">	主题标识：</label>
				<div class="controls">
					<form:input path="key" htmlEscape="false" maxlength="10" class=" "/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	名称：</label>
				<div class="controls">
					<form:input path="name" htmlEscape="false" maxlength="255" class=" "/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	英文名：</label>
				<div class="controls">
					<form:input path="sname" htmlEscape="false" maxlength="255" class=" "/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	服务名：</label>
				<div class="controls">
					<form:input path="serviceName" htmlEscape="false" maxlength="255" class=" "/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	可见：</label>
				<div class="controls">
					<form:radiobuttons path="enable" items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	排序：</label>
				<div class="controls">
					<form:input path="sort" htmlEscape="false" class=" "/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	备注：</label>
				<div class="controls">
					<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="200" class="input-xxlarge "/>

				</div>
			</div>
			<div class="form-actions">
				<shiro:hasPermission name="actyw:actYwGtheme:edit"><button class="btn btn-primary" type="submit">保存</button></shiro:hasPermission>
				<button class="btn btn-default" type="button" onclick="history.go(-1)">返回</button>
			</div>
		</form:form>
</div>
</body>
</html>