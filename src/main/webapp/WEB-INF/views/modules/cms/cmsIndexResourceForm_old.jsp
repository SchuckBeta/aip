<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>首页资源管理</title>
<meta name="decorator" content="default" />
<style>
 li{
list-style:none !important;margin-left: 20px;
}
</style>
<script src="/common/common-js/ajaxfileupload.js"></script>
<!-- <script type="text/javascript" src="/js/DSSB.js"></script> -->
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/cms/cmsIndexResource.js"></script>
<script type="text/javascript">
	$(document).ready(
			function() {
				//$("#name").focus();
				$("#inputForm")
						.validate(
								{
									submitHandler : function(form) {
										loading('正在提交，请稍等...');
										form.submit();
									},
									errorContainer : "#messageBox",
									errorPlacement : function(error, element) {
										$("#messageBox").text("输入有误，请先更正。");
										if (element.is(":checkbox")
												|| element.is(":radio")
												|| element.parent().is(
														".input-append")) {
											error.appendTo(element.parent()
													.parent());
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
		<li><a href="${ctx}/cms/cmsIndexResource/">首页资源列表</a></li>
		<li class="active"><a
			href="${ctx}/cms/cmsIndexResource/form?id=${cmsIndexResource.id}">首页资源<shiro:hasPermission
					name="cms:cmsIndexResource:edit">${not empty cmsIndexResource.id?'修改':'添加'}</shiro:hasPermission>
				<shiro:lacksPermission name="cms:cmsIndexResource:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<br />
	<form:form id="inputForm" modelAttribute="cmsIndexResource"
		action="${ctx}/cms/cmsIndexResource/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<sys:message content="${message}" />
		<div class="control-group">
			<label class="control-label">所属区域类型：</label>
			<div class="controls">
				<form:select path="regionType" class="input-xlarge ">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('regiontype_flag')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*&nbsp;</font> </span>资源名称：</label>
			<div class="controls">
				<form:input path="resName" htmlEscape="false" maxlength="64"
					class="input-xlarge required" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*&nbsp;</font> </span>资源状态：</label>
			<div class="controls">
				<form:select path="resState" class="input-xlarge required">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('resstate_flag')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*&nbsp;</font> </span>资源类型：</label>
			<div class="controls">
				<form:select path="resType" class="input-xlarge required">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('restype_flag')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font color="red">*&nbsp;</font> </span>资源排序：</label>
			<div class="controls">
				<form:input path="resSort" htmlEscape="false" maxlength="64"
					class="input-xlarge required" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">资源内容：</label>
			<div class="controls">
				<form:textarea path="resContent" htmlEscape="false" rows="4"
					class="input-xxlarge " />
				<sys:ckeditor replace="resContent" uploadPath="" />
			</div>
		</div>


		<div class="control-group" style="float: left">
			<label class="control-label">资源地址：</label>
			<div class="controls">
				<form:textarea path="url" id="url" htmlEscape="false" rows="4"
					maxlength="255" class="input-xxlarge " readonly="true" />
			</div>
		</div>

		<div class="other" id="fujian"
			style="float: left; margin-top: 12px; margin-left: 15px">

			<div class="biaoti">
				<span>附件：</span> <a class="upload" id="upload">上传附件</a> <input 
					type="file" style="display: none" id="fileToUpload" name="fileName" />

			</div>
			<ul id="file">
		</div>
		<c:forEach items="${sysAttachments}" var="sysAttachment">
			<ul>
				<li style="margin-left: 20p; list-style: none;">
					<p>
						<a href="javascript:void(0)" id="downfile">
							${sysAttachment.name}</a> <input type="hidden"
							value="${sysAttachment.url}" />
					</p> <input  name="url" value="${sysAttachment.url}" id="url"
					type="hidden" />
					<button type='button' class='del'>删除</button>
				</li>
			</ul>
		</c:forEach>
		<div style="clear: both"></div>
		<div class="control-group">
			<label class="control-label">点击跳转地址：</label>
			<div class="controls">
				<form:textarea path="jumpUrl" htmlEscape="false" rows="4"
					maxlength="255" class="input-xxlarge " />
			</div>
		</div>

		<div class="form-actions">
			<shiro:hasPermission name="cms:cmsIndexResource:edit">
				<input id="btnSubmit" class="btn btn-primary" type="submit"
					value="保 存" />&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回"
				onclick="history.go(-1)" />
		</div>
	</form:form>

	<script type="text/javascript">
		$(function() {
			$("#downfile").click(
					function() {
						var url = $("#downfile").next().val();
						location.href = "/a/download?fileName="
								+ encodeURIComponent(url);
					});
		})
		
	</script>

</body>
</html>