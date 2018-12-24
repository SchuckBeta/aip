<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>场地分配记录</title>
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
            <span>场地分配记录</span> <i class="line weight-line"></i>
        </div>
    </div>
    <form:form id="inputForm" modelAttribute="pwEnterRoomRecord" action="${ctx}/pw/pwEnterRoomRecord/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>
			<div class="control-group">
				<label class="control-label">	<i>*</i>入驻编号：</label>
				<div class="controls">
					<form:input path="eid" htmlEscape="false" maxlength="64" class=" required"/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	<i>*</i>房间编号：</label>
				<div class="controls">
					<form:input path="rid" htmlEscape="false" maxlength="64" class=" required"/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	记录编号：</label>
				<div class="controls">
					<form:input path="rcid" htmlEscape="false" maxlength="64" class=" "/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	操作类型：</label>
				<div class="controls">
					<form:select path="type" class=" ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	入驻工位数：</label>
				<div class="controls">
					<form:input path="num" htmlEscape="false" maxlength="11" class=" "/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	备注：</label>
				<div class="controls">
					<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="500" class="input-xxlarge "/>

				</div>
			</div>
			<div class="form-actions">
				<shiro:hasPermission name="pw:pwEnterRoomRecord:edit"><button class="btn btn-primary" type="submit">保存</button></shiro:hasPermission>
				<button class="btn btn-default" type="button" onclick="history.go(-1)">返回</button>
			</div>
		</form:form>
</div>
</body>
</html>