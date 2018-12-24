<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>${backgroundTitle}</title>
	<!-- <meta name="decorator" content="default"/> -->
	<%@include file="/WEB-INF/views/include/backtable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")){
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
		<span>设施</span>
	</div>
	<div class="content_panel">
		<ul class="nav nav-tabs">
			<li><a href="${ctx}/pw/pwSpace/">设施列表</a></li>
			<li class="active"><a href="${ctx}/pw/pwSpace/form?id=${pwSpace.id}&parent.id=${pwSpaceparent.id}">设施<shiro:hasPermission name="pw:pwSpace:edit">${not empty pwSpace.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="pw:pwSpace:edit">查看</shiro:lacksPermission></a></li>
		</ul><br/>
		<form:form id="inputForm" modelAttribute="pwSpace" action="${ctx}/pw/pwSpace/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>
			<div class="control-group">
				<label class="control-label">上级父级编号：</label>
				<div class="controls">
					<sys:treeselect id="parent" name="parent.id" value="${pwSpace.parent.id}" labelName="parent.name" labelValue="${pwSpace.parent.name}"
						title="父级编号" url="/pw/pwSpace/treeData" extId="${pwSpace.id}" cssClass="" allowClear="true"/>
				</div>
			</div>
			<span>${school}</span>
			<div class="control-group">
				<label class="control-label">名称：</label>
				<div class="controls">
					<form:input path="name" htmlEscape="false" maxlength="100" class="input-xlarge required"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">负责人：</label>
				<div class="controls">
					<form:input path="person" htmlEscape="false" maxlength="100" class="input-xlarge required"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">设施类型：</label>
				<div class="controls">
					<form:select path="type" class="input-xlarge ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('pw_space_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">电话：</label>
				<div class="controls">
					<form:input path="phone" htmlEscape="false" maxlength="200" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">手机：</label>
				<div class="controls">
					<form:input path="mobile" htmlEscape="false" maxlength="200" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">开放时间:周：</label>
				<div class="controls">
					<form:checkboxes path="openWeek" items="${fns:getDictList('pw_space_week')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">开放时间：</label>
				<div class="controls">
					<input name="openStartTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
						value="<fmt:formatDate value="${pwSpace.openStartTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
						onclick="WdatePicker({dateFmt:'HH:mm:ss',isShowClear:false});"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">开放时间：</label>
				<div class="controls">
					<input name="openEndTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
						value="<fmt:formatDate value="${pwSpace.openEndTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
						onclick="WdatePicker({dateFmt:'HH:mm:ss',isShowClear:false});"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">楼层数：</label>
				<div class="controls">
					<form:input path="floorNum" htmlEscape="false" max="100" min="0" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label"><i>*</i>占地面积：</label>
				<div class="controls">
					<form:input path="area" htmlEscape="false" maxlength="100" class="input-xlarge required number"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">备注：</label>
				<div class="controls">
					<form:radiobuttons path="remarks" items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="form-actions">
				<shiro:hasPermission name="pw:pwSpace:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</form:form>
	</div>
	<div id="dialog-message" title="信息">
		<p id="dialog-content"></p>
	</div>
</body>
</html>