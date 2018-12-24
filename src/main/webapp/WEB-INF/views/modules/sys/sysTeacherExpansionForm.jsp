<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>导师信息修改</title>
	<meta name="decorator" content="default"/>
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
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/sys/sysTeacherExpansion/">导师信息列表</a></li>
		<li class="active"><a href="${ctx}/sys/sysTeacherExpansion/form?id=${sysTeacherExpansion.id}">导师信息<shiro:hasPermission name="sys:sysTeacherExpansion:edit">${not empty sysTeacherExpansion.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:sysTeacherExpansion:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="sysTeacherExpansion" action="${ctx}/sys/sysTeacherExpansion/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">层次：</label>
			<div class="controls">
				<form:input path="arrangement" htmlEscape="false" maxlength="64" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">学科门类：</label>
			<div class="controls">
				<form:input path="discipline" htmlEscape="false" maxlength="11" class="input-xlarge  digits"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">行业：</label>
			<div class="controls">
				<form:input path="industry" htmlEscape="false" maxlength="32" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">职称：</label>
			<div class="controls">
				<form:input path="technicalTitle" htmlEscape="false" maxlength="20" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">服务意向：</label>
			<div class="controls">
				<form:select path="serviceIntention" class="input-xlarge ">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('master_help')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">工作单位：</label>
			<div class="controls">
				<form:input path="workUnit" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">联系地址：</label>
			<div class="controls">
				<form:input path="address" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">工作简历：</label>
			<div class="controls">
				<form:hidden id="resume" path="resume" htmlEscape="false" maxlength="512" class="input-xlarge"/>
				<sys:ckfinder input="resume" type="files" uploadPath="/sys/sysTeacherExpansion" selectMultiple="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">推荐单位：</label>
			<div class="controls">
				<form:input path="recommendedUnits" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">成果名称：</label>
			<div class="controls">
				<form:select path="result" class="input-xlarge ">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('competition_net_prise')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">获奖名称：</label>
			<div class="controls">
				<form:input path="award" htmlEscape="false" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">级别：</label>
			<div class="controls">
				<form:input path="level" htmlEscape="false" maxlength="11" class="input-xlarge  digits"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">评审项目名称：</label>
			<div class="controls">
				<form:input path="reviewName" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">参与评审年份：</label>
			<div class="controls">
				<input name="joinReviewTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
					value="<fmt:formatDate value="${sysTeacherExpansion.joinReviewTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">开户银行：</label>
			<div class="controls">
				<form:input path="firstBank" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">银行账号：</label>
			<div class="controls">
				<form:input path="bankAccount" htmlEscape="false" maxlength="19" minlength="16" class="input-xlarge  digits"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">导师来源：</label>
			<div class="controls">
				<form:select path="teachertype" class="input-xlarge ">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('master_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">是否公开：</label>
			<div class="controls">
				<form:input path="isOpen" htmlEscape="false" maxlength="11" class="input-xlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="sys:sysTeacherExpansion:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>