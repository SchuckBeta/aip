<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>评论</title>
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
            <span>评论</span> <i class="line weight-line"></i>
        </div>
    </div>
    <form:form id="inputForm" modelAttribute="cmsConmment" action="${ctx}/cms/cmsConmment/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>
			<div class="control-group">
				<label class="control-label">	栏目编号：</label>
				<div class="controls">
					<form:select path="category.id" class=" ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	栏目内容的编号：</label>
				<div class="controls">
					<form:select path="cnt.id" class=" ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	评论人：</label>
				<div class="controls">
					<form:select path="uid" class=" ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	<i>*</i>点赞量：</label>
				<div class="controls">
					<form:input path="likes" htmlEscape="false" maxlength="11" class=" required"/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	评论内容：</label>
				<div class="controls">
					<form:textarea path="content" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	审核人：</label>
				<div class="controls">
					<form:select path="user.id" class=" ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	审核时间：</label>
				<div class="controls">
					<input name="auditDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
						value="<fmt:formatDate value="${cmsConmment.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	回复评论：</label>
				<div class="controls">
					<form:input path="reply" htmlEscape="false" maxlength="255" class=" "/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	审核状态（待审核，审核通过，审核不通过）：</label>
				<div class="controls">
					<form:select path="auditstatus" class=" ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('cms_auditstatus')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">	是否推荐（0否1是）：</label>
				<div class="controls">
					<form:select path="isRecommend" class=" ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>

				</div>
			</div>
			<div class="form-actions">
				<shiro:hasPermission name="cms:cmsConmment:edit"><button class="btn btn-primary" type="submit">保存</button></shiro:hasPermission>
				<button class="btn btn-default" type="button" onclick="history.go(-1)">返回</button>
			</div>
		</form:form>
</div>
</body>
</html>