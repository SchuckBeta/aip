<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>入驻场地需求</title>
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
            <span>入驻场地需求</span> <i class="line weight-line"></i>
        </div>
    </div>
    <form:form id="inputForm" modelAttribute="pwSpacereq" action="${ctx}/pw/pwSpacereq/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>
			<div class="control-group">
				<label class="control-label">	申报编号：</label>
				<div class="controls">
					<form:input path="eid" htmlEscape="false" maxlength="64" class=" "/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	工位数：</label>
				<div class="controls">
					<form:input path="workNum" htmlEscape="false" maxlength="11" class="  digits"/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	场地数：平方米：</label>
				<div class="controls">
					<form:input path="spaceNum" htmlEscape="false" maxlength="11" class="  digits"/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	孵化期限:年：</label>
				<div class="controls">
					<form:input path="term" htmlEscape="false" class="  number"/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	备注：</label>
				<div class="controls">
					<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="200" class="input-xxlarge "/>

				</div>
			</div>
			<div class="form-actions">
				<shiro:hasPermission name="pw:pwSpacereq:edit"><button class="btn btn-primary" type="submit">保存</button></shiro:hasPermission>
				<button class="btn btn-default" type="button" onclick="history.go(-1)">返回</button>
			</div>
		</form:form>
</div>
</body>
</html>