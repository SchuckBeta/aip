<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>proModel管理</title>
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
		<span>proModel</span>
	</div>
	<div class="content_panel">
		<ul class="nav nav-tabs">
			<li><a href="${ctx}/promodel/proModel/">proModel列表</a></li>
			<li class="active"><a href="${ctx}/promodel/proModel/form?id=${proModel.id}">proModel<shiro:hasPermission name="promodel:proModel:edit">${not empty proModel.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="promodel:proModel:edit">查看</shiro:lacksPermission></a></li>
		</ul><br/>
		<form:form id="inputForm" modelAttribute="proModel" action="${ctx}/promodel/proModel/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>
			<div class="control-group">
				<label class="control-label">项目名称：</label>
				<div class="controls">
					<form:input path="pName" htmlEscape="false" maxlength="128" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">申报人ID：</label>
				<div class="controls">
					<form:input path="declareId" htmlEscape="false" maxlength="64" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">项目类型：</label>
				<div class="controls">
					<form:input path="type" htmlEscape="false" maxlength="20" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">项目级别：</label>
				<div class="controls">
					<form:input path="level" htmlEscape="false" maxlength="20" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">项目简介：</label>
				<div class="controls">
					<form:input path="introduction" htmlEscape="false" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">融资情况 0 未，1 100w一下 2 100w以上：</label>
				<div class="controls">
					<form:input path="financingStat" htmlEscape="false" maxlength="20" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">团队ID：</label>
				<div class="controls">
					<form:input path="teamId" htmlEscape="false" maxlength="64" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">流程实例id：</label>
				<div class="controls">
					<form:input path="procInsId" htmlEscape="false" maxlength="64" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">项目标识：</label>
				<div class="controls">
					<form:input path="proMark" htmlEscape="false" maxlength="64" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">source：</label>
				<div class="controls">
					<form:input path="source" htmlEscape="false" maxlength="64" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">大赛编号：</label>
				<div class="controls">
					<form:input path="competitionNumber" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">大赛结果：</label>
				<div class="controls">
					<form:input path="grade" htmlEscape="false" maxlength="20" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">学院评分：</label>
				<div class="controls">
					<form:input path="gScore" htmlEscape="false" class="input-xlarge "/>
				</div>
			</div>
			<div class="form-actions">
				<shiro:hasPermission name="promodel:proModel:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</form:form>
	</div>
	<div id="dialog-message" title="信息">
		<p id="dialog-content"></p>
	</div>
</body>
</html>