<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>首页管理</title>
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
            <span>首页管理</span> <i class="line weight-line"></i>
        </div>
    </div>
    <form:form id="inputForm" modelAttribute="cmsIndex" action="${ctx}/cms/cmsIndex/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>
			<div class="control-group">
				<label class="control-label">	频道名称：</label>
				<div class="controls">
					<form:input path="modelname" htmlEscape="false" maxlength="20" class=" "/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	频道英文名称：</label>
				<div class="controls">
					<form:input path="modelename" htmlEscape="false" maxlength="20" class=" "/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	排序：</label>
				<div class="controls">
					<form:input path="sort" htmlEscape="false" maxlength="11" class=" "/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	显示（0否1是）：</label>
				<div class="controls">
					<form:input path="isShow" htmlEscape="false" maxlength="11" class=" "/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	描述：</label>
				<div class="controls">
					<form:input path="description" htmlEscape="false" maxlength="500" class=" "/>

				</div>
			</div>
			<div class="form-actions">
				<shiro:hasPermission name="cms:cmsIndex:edit"><button class="btn btn-primary" type="submit">保存</button></shiro:hasPermission>
				<button class="btn btn-default" type="button" onclick="history.go(-1)">返回</button>
			</div>
		</form:form>
</div>
</body>
</html>