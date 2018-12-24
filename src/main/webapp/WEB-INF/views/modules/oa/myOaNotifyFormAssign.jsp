<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>通知管理</title>
<!-- <meta name="decorator" content="default"/> -->
<meta name="decorator" content="site-decorator" />
<link href="/common/common-css/bootstrap.min.css" type="text/css"
	rel="stylesheet" />
<script src="/static/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
<script type="text/javascript" src="/common/common-js/bootstrap.min.js"></script>
<script src="/static/bootstrap/2.3.1/js/bootstrap.min.js"
	type="text/javascript"></script>
<link href="/static/bootstrap/2.3.1/awesome/font-awesome.min.css"
	type="text/css" rel="stylesheet" />
<link href="/static/jquery-select2/3.4/select2.min.css" rel="stylesheet" />
<script src="/static/jquery-select2/3.4/select2.min.js"
	type="text/javascript"></script>
<link href="/static/jquery-validation/1.11.0/jquery.validate.min.css"
	type="text/css" rel="stylesheet" />
<script src="/static/jquery-validation/1.11.0/jquery.validate.min.js"
	type="text/javascript"></script>
<link href="/static/jquery-jbox/2.3/Skins/Bootstrap/jbox.min.css"
	rel="stylesheet" />
<script src="/static/jquery-jbox/2.3/jquery.jBox-2.3.min.js"
	type="text/javascript"></script>
<script src="/common/common-js/datepicker/My97DatePicker/WdatePicker.js"
	type="text/javascript"></script>
<script src="/static/common/mustache.min.js" type="text/javascript"></script>
<link href="/static/common/initiate.css" type="text/css"
	rel="stylesheet" />
<link href="/common/common-css/pagenation.css" rel="stylesheet" />
<script src="/static/common/initiate.js?v=1" type="text/javascript"></script>
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
				CKEDITOR.config.readOnly = true;
			});
</script>

<style>
.form-actions {
	background: #fff;
	border: none;
}

.control-group {
	border: none;
}

input[type="submit"], input[type="button"] {
	background-color: red;
	color: white;
	width: 60px;
	height: 30px;
	font-size: 15px;
	border: none;
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	padding: 5px 10px;
}

.self-label span {
	margin-top: 5px;
}

.self-label span label {
	margin-right: 10px;
	margin-top: 3px;
}

.help-inline {
	margin-top: -2px !important;
}

.resetBtn  a {
	background: #ececec;
	padding: 2px 12px;
	border: 1px solid #ccc;
}

#content {
	padding: 30px;
}

.control-label {
	float: left;
}

#fj{
	margin-left: 27px;
}

tr{
  text-align:center;
}
th{
   background: #f4e6d4 !important;
   text-align: center !important;
   color: #656565 !important;
}
</style>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctxFront}/sys/user/indexMyNoticeList">定向通知列表</a></li>
		<li class="active"><a
			href="${ctx}/oa/oaNotify/formAssign?id=${oaNotify.id}">定向通知<shiro:hasPermission
					name="oa:oaNotify:edit">${oaNotify.status eq '1' ? '查看' : not empty oaNotify.id ? '修改' : '添加'}</shiro:hasPermission>
				<shiro:lacksPermission name="oa:oaNotify:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<br />
	<form:form id="inputForm" modelAttribute="oaNotify"
		action="${ctx}/oa/oaNotify/saveAssign" method="post"
		class="form-horizontal">
		<form:hidden path="id" />
		<sys:message content="${message}" />
		<div class="control-group">
			<label class="control-label"><span class="help-inline"><font
					color="red">*&nbsp;</font> </span>发送方式：</label>
			<%-- <div class="controls">
				<form:input path="sendType"  value="定向"  readonly="true" htmlEscape="false" maxlength="200" class="input-xlarge"/>
			</div> --%>
			<td><c:if test="${oaNotify.sendType==1}">
						广播方式
					</c:if> <c:if test="${oaNotify.sendType==2}">
						定向方式
					</c:if></td>
		</div>
		<div class="control-group" style="margin-left: 27px">
			<label class="control-label"><span class="help-inline"><font
					color="red">*&nbsp;</font> </span>标题：</label>
			<div class="controls">
				<%-- <form:input path="title" htmlEscape="false" maxlength="200" class="input-xlarge required" readonly="true"/> --%>
				<td>${oaNotify.title}</td>
			</div>
		</div>
		<div class="control-group" style="margin-left: 27px">
			<label class="control-label"><span class="help-inline"><font
					color="red">*&nbsp;</font> </span>内容：</label>
			<%-- <div class="controls">
				<form:textarea path="content" htmlEscape="false" rows="6" maxlength="2000" class="input-xxlarge required" readonly="true"/>
				<sys:ckeditor replace="content"  uploadPath="/oa/content" />
			</div> --%>
			<td>${oaNotify.title}</td>
		</div>
		
		<c:if test="${oaNotify.status ne '1'}">
			<div class="control-group" style="margin-left: 21px">
				<label class="control-label" style="margin-left:41px">附件：</label>
				<div class="controls resetBtn">
					<form:hidden id="files" path="files" htmlEscape="false"
						maxlength="255" class="input-xlarge" />
					<sys:ckfinder input="files" type="files" uploadPath="/oa/notify"
						selectMultiple="true" readonly="readonly" />
				</div>
			</div>
			<div class="control-group" style="margin-left: 21px">
				<label class="control-label"><span class="help-inline"><font
						color="red">*&nbsp;</font></span>状态：</label>
				<%-- <div class="controls self-label">
					<form:radiobuttons path="status" items="${fns:getDictList('oa_notify_status')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required" readonly="readonly"/>
					<span class="help-inline"><font color="red">(发布后不能进行操作)</font> </span>
				</div> --%>
				${fns:getDictLabel(oaNotify.status, 'oa_notify_status', '')}
			</div>
			<div class="control-group" style="margin-left: 27px">
				<label class="control-label"><span class="help-inline"><font
						color="red">*&nbsp;</font> </span>接收人：</label>
				<div class="controls">
					<sys:treeselect id="oaNotifyRecord" name="oaNotifyRecordIds"
						value="${oaNotify.oaNotifyRecordIds}"
						labelName="oaNotifyRecordNames"
						labelValue="${oaNotify.oaNotifyRecordNames}" title="用户"
						url="/sys/office/treeData?type=3"
						cssClass="input-xxlarge required" notAllowSelectParent="true"
						checked="true" />
				</div>
			</div>

		</c:if>
		<c:if test="${oaNotify.status eq '1'}">
			<div class="control-group" style="margin-left: 21px">
				<label class="control-label" style="margin-left:20px;">附件：</label>
				<div class="controls resetBtn">
					<form:hidden id="files" path="files" htmlEscape="false"
						maxlength="255" class="input-xlarge" />
					<sys:ckfinder input="files" type="files" uploadPath="/oa/notify"
						selectMultiple="true" readonly="true" />
				</div>
			</div>
			<div class="control-group" style="margin-left: 21px">
				<label class="control-label">接收人：</label>
				<div class="controls">
					<table id="contentTable"
						class="table table-hover table-bordered table-condensed">
						<thead>
							<tr>
								<th>接受人</th>
								<th>接受学院</th>
								<th>阅读状态</th>
								<th>阅读时间</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${oaNotify.oaNotifyRecordList}"
								var="oaNotifyRecord">
								<tr>
									<td>${oaNotifyRecord.user.name}</td>
									<td>${oaNotifyRecord.user.office.name}</td>
									<td>${fns:getDictLabel(oaNotifyRecord.readFlag, 'oa_notify_read', '')}
									</td>
									<td><fmt:formatDate value="${oaNotifyRecord.readDate}"
											pattern="yyyy-MM-dd HH:mm:ss" /></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					已查阅：${oaNotify.readNum} &nbsp; 未查阅：${oaNotify.unReadNum} &nbsp;
					总共：${oaNotify.readNum + oaNotify.unReadNum}
				</div>

			</div>
		</c:if>
		<div class="form-actions" style="text-align:center">
			<c:if test="${oaNotify.status ne '1'}">
				<shiro:hasPermission name="oa:oaNotify:edit">
					<input id="btnSubmit" type="submit" value="确认" />&nbsp;</shiro:hasPermission>
			</c:if>
			<input style="background-color: #e9432d;" id="btnCancel" type="button" value="取消"
				onclick="history.go(-1)" />
		</div>
	</form:form>
</body>
</html>