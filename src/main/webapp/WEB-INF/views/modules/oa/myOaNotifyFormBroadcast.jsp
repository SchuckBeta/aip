<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@include file="/WEB-INF/views/include/backtable.jsp" %>
<html>
<head>
<title>通知管理</title>
<!-- <meta name="decorator" content="default" /> -->
<meta name="decorator" content="site-decorator" />
<link href="/common/common-css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script src="/static/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
<script type="text/javascript" src="/common/common-js/bootstrap.min.js"></script>
<script src="/static/bootstrap/2.3.1/js/bootstrap.min.js" type="text/javascript"></script>
<link href="/static/bootstrap/2.3.1/awesome/font-awesome.min.css" type="text/css" rel="stylesheet" />
<link href="/static/jquery-select2/3.4/select2.min.css" rel="stylesheet" />
<script src="/static/jquery-select2/3.4/select2.min.js" type="text/javascript"></script>
<link href="/static/jquery-validation/1.11.0/jquery.validate.min.css" type="text/css" rel="stylesheet" />
<script src="/static/jquery-validation/1.11.0/jquery.validate.min.js" type="text/javascript"></script>
<link href="/static/jquery-jbox/2.3/Skins/Bootstrap/jbox.min.css" rel="stylesheet" />
<script src="/static/jquery-jbox/2.3/jquery.jBox-2.3.min.js" type="text/javascript"></script>
<script src="/common/common-js/datepicker/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
<script src="/static/common/mustache.min.js" type="text/javascript"></script>
<link href="/static/common/initiate.css" type="text/css" rel="stylesheet" />
<link href="/common/common-css/pagenation.css" rel="stylesheet" />
<script src="/static/common/initiate.js?v=1" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="/static/common/tablepage.css" />
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

				displayReceiveInput()
				CKEDITOR.config.readOnly = true;
			});

	function displayReceiveInput() {

		var sendType = $("#sendType").val();

		if (sendType == '1') {
			$("#oaNotifyRecordId").attr("class", "input-xxlarge");
			$("#oaNotifyRecordName").attr("class", "input-xxlarge");

			$("#receiveInput1").css("display", "none");
			$("#receiveInput2").css("display", "none");
			//alert($("#oaNotifyRecordName").attr("class"));
		} else if (sendType == '2') {
			$("#oaNotifyRecordId").attr("class", "input-xxlarge required");
			$("#oaNotifyRecordName").attr("class", "input-xxlarge required");
			$("#receiveInput1").css("display", "block");
			$("#receiveInput2").css("display", "block");
			//alert($("#oaNotifyRecordName").attr("class"));
		} else {
			$("#oaNotifyRecordId").attr("class", "input-xxlarge");
			$("#oaNotifyRecordName").attr("class", "input-xxlarge");
			$("#receiveInput1").css("display", "none");
			$("#receiveInput2").css("display", "none");

			//alert($("#oaNotifyRecordName").attr("class"));
		}
	}
</script>

<style>
#content{
   padding:30px;
}
.btn-primary{
  border-color:#e9432d!important;
  
}
input{
  height:30px!important;
}
input:hover{
  height:30px!important;
}
.mybreadcrumbs {
	background-color: #FFF;
	position: relative;
	height: 40px;
	
}

.mybreadcrumbs span {
	font-size: 16px;
	position: absolute;
	left: 0px;
	top: 0px;
	background: #fff;
	padding: 0px 10px;
	z-index: 999;
}
.mybreadcrumbs .yw-line {
	position: absolute;
	width: 100%;
	height: 3px;
	background: orange;
	top: 12px;
}
.control-group{
   border-bottom:none!important;
}
.control-label{
  float:left;
}
</style>
</head>
<body>
<div class="mybreadcrumbs" style="margin-top:30px">
		<span>我的通告</span>
		<p class="yw-line"></p>
	</div>
<div class="table-page">
	<br />
	<div id="effectiveDateStr" style="opacity: 0;">${effectiveDateStr}</div>
	<div id="endDateStr" style="opacity: 0;">${endDateStr}</div>
	<form:form id="inputForm" modelAttribute="oaNotify"
		action="${ctx}/oa/oaNotify/saveBroadcast?sId=${sId}&protype=${protype }"
		method="post" class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="oaNotifyRecordIdsBroadCast" />

		<sys:message content="${message}" />

		<div class="control-group" style="margin-left: 27px">
			<label class="control-label">标题：</label>
			<div class="controls">
				<td>${oaNotify.title}</td>
			</div>
		</div>
		<div class="control-group" style="margin-left: 27px">
			<label class="control-label">内容：</label>
			<td>${oaNotify.content }</td>
		</div>


		<%-- <c:if test="${oaNotify.status eq '1'}">
			<div class="control-group" style="margin-left: 39px">
				<label class="control-label">附件：</label>
				<div class="controls resetBtn">
					<form:hidden id="files" path="files" htmlEscape="false"
						maxlength="255" class="input-xlarge" readonly="readonly"/>
					<sys:ckfinder input="files" type="files" uploadPath="/oa/notify"
						selectMultiple="true" readonly="true" />
				</div>
			</div>
		</c:if> --%>


		<div class="control-group">
			<label class="control-label">发布时间：</label>
			<td>${effDate }</td>
		</div>
		<div class="form-actions" style="text-align:center">
			<input id="btnCancel" style="background-color:#e9432d;color:#fff;border:none"  class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
	</div>
</body>
</html>