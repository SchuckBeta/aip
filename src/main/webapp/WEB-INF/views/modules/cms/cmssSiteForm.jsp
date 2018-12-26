<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>站点明细管理</title>
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
		<span>站点明细</span>
	</div>
	<div class="content_panel">
		<ul class="nav nav-tabs">
			<li><a href="${ctx}/cms/cmssSite/">站点明细列表</a></li>
			<li class="active"><a href="${ctx}/cms/cmssSite/form?id=${cmssSite.id}">站点明细<shiro:hasPermission name="cms:cmssSite:edit">${not empty cmssSite.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="cms:cmssSite:edit">查看</shiro:lacksPermission></a></li>
		</ul><br/>
		<form:form id="inputForm" modelAttribute="cmssSite" action="${ctx}/cms/cmssSite/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>
			<div class="control-group">
				<label class="control-label">父级编号：</label>
				<div class="controls">
					<form:select path="site.id" class="input-xlarge ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">站点标题：</label>
				<div class="controls">
					<form:input path="title" htmlEscape="false" maxlength="100" class="input-xlarge required"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">站点租户Logo：</label>
				<div class="controls">
					<form:input path="logo" htmlEscape="false" maxlength="255" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">站点Logo：</label>
				<div class="controls">
					<form:input path="logoSite" htmlEscape="false" maxlength="255" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">站点首页栏目（必须为根栏目）：</label>
				<div class="controls">
					<form:input path="index" htmlEscape="false" maxlength="64" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">站点域名：</label>
				<div class="controls">
					<form:input path="domain" htmlEscape="false" maxlength="255" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">描述：</label>
				<div class="controls">
					<form:input path="description" htmlEscape="false" maxlength="255" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">关键字：</label>
				<div class="controls">
					<form:input path="keywords" htmlEscape="false" maxlength="255" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">主题：</label>
				<div class="controls">
					<form:input path="theme" htmlEscape="false" maxlength="255" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">版权信息：</label>
				<div class="controls">
					<form:input path="copyright" htmlEscape="false" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">备注信息：</label>
				<div class="controls">
					<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
				</div>
			</div>
			<div class="form-actions">
				<shiro:hasPermission name="cms:cmssSite:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</form:form>
	</div>
	<div id="dialog-message" title="信息">
		<p id="dialog-content"></p>
	</div>
</body>
</html>