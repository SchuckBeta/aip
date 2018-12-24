<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@include file="/WEB-INF/views/include/backtable.jsp" %>
<html>
<head>
<title>通知管理</title>
<link rel="stylesheet" type="text/css" href="/static/common/tablepage.css" />
<script type="text/javascript" src="/static/ueditor/ueditor.config.js"></script>
<script type="text/javascript" src="/static/ueditor/ueditor.all.js"></script>
<script type="text/javascript">
	var validate;
	UE.Editor.prototype._bkGetActionUrl = UE.Editor.prototype.getActionUrl;
	UE.Editor.prototype.getActionUrl = function(action) {
		if (action == 'uploadimage' || action == 'uploadscrawl' || action == 'uploadvideo'
				||action=='uploadfile'||action=='catchimage'||action=='listimage'||action=='listfile'){
			return $frontOrAdmin+'/ftp/ueditorUpload/upload';
		}else {
			return this._bkGetActionUrl.call(this, action);
		}
	}
	$(document).ready(function() {
		$("#title").change(function(){
			var title = $("#title").val();
			$.ajax({
				url:"${ctx}/oa/oaNotify/validateName",
				data:{"title":title},
				type:"post",
				success:function(data){
					if(data>0){
						$("#yzName").text("*该标题已存在！").css("color","red");
					}else{
						$("#yzName").text("");
					}
				}
			})
		});
		$("#inputForm").validate({
							submitHandler : function(form) {
								if (UE.getEditor('content').getContent()==""){
									top.$.jBox.tip('请填写内容','warning');
								}else{
									loading('正在提交，请稍等...');
									form.submit();
								}
							},
							messages: {
								oaNotifyRecordNames: {
									required: "必填信息"
								}
							},
							errorPlacement : function(error, element) {
								if (element.is(":checkbox")
										|| element.is(":radio")) {
									error.appendTo(element.parent().parent());
								}else if(element.attr("name") == "oaNotifyRecordNames"){
									//error.html("必填信息");
									error.appendTo(element.parent().parent());
								} else {
									error.insertAfter(element);
								}
							}
						});

		displayReceiveInput();

		if("${oaNotify.id}"!=""&&"${oaNotify.status}"=="1"){
			$('#sendType').attr("disabled",true);
			$('#title').attr("disabled",true);
			$('#status').attr("disabled",true);
			$('#btnSubmit').hide();
		}

	});
	function saveOAForm(){
		var title = $("#title").val();
			$.ajax({
				url:"${ctx}/oa/oaNotify/validateName",
				data:{"title":title,
						"oldTitle" :"${oaNotify.title}"
						},
				type:"post",
				success:function(data){
					if(data>0){
						$("#yzName").text("*该标题已存在！").css("color","red");
					}else{
						$("#yzName").text("");
						$("#inputForm").submit();
					}
				}
			})
	}

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
#btnSubmit{
  background: #e9432d !important;
}
#btnCancel{
 background:#DDDDDD!important;
}
input{
  height:30px!important;
}

</style>
</head>
<body>
<div class="mybreadcrumbs"><span>通告发布</span></div>
<div class="table-page">
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/oa/oaNotify/broadcastList">通告列表</a></li>
		<li class="active">
			<a href="${ctx}/oa/oaNotify/formBroadcast?id=${oaNotify.id}">
				通告${oaNotify.status eq '1' ? '查看' : not empty oaNotify.id ? '修改':'添加'}
			</a>
		</li>
	</ul>
	<br />
	<form:form id="inputForm" modelAttribute="oaNotify" action="${ctx}/oa/oaNotify/saveBroadcast"
		method="post" class="form-horizontal">
		<form:hidden path="id" />
		<form:hidden path="sId" />
		<form:hidden path="protype" />
		<sys:message content="${message}" />
		<div class="control-group">
			<label class="control-label">
				<span class="help-inline">
					<font color="red">*&nbsp;</font> </span>
				发送方式：
			</label>
			<div class="controls">
				<form:select id="sendType" path="sendType"
					onchange="displayReceiveInput()" class="input-xlarge required">
					<form:option value="1" label="通知公告" />
					<form:option value="2" label="站内信" />
				</form:select>
			</div>
		</div>
		<div class="control-group">

			<label class="control-label">
				<span class="help-inline">
				<font color="red">*&nbsp;</font>
				</span>标题：
			</label>
			<div class="controls">
				<form:input path="title" htmlEscape="false" maxlength="200"	class="input-xlarge required" />
				<span id="yzName"></span>
			</div>
		</div>


		<div class="control-group">
			<label class="control-label">
				<span class="help-inline">
					<font color="red">*&nbsp;</font>
				</span>内容：
			</label>
			<div class="controls">
				<form:textarea path="content" htmlEscape="false" rows="6" maxlength="2000" class="required" style="width:95%;max-width:1170px;height:300px" />
				<script type="text/javascript">
					var ue = UE.getEditor('content');
					//如果是发布状态
					ue.addListener('ready', function () {
						if("${oaNotify.id}"!=""&&"${oaNotify.status}"=="1"){
							ue.setDisabled();
						}
					});
				</script>
			</div>

		</div>

		<c:if test="${oaNotify.status ne '1'}">
			<div class="control-group">
				<label class="control-label"><span class="help-inline"><font
						color="red">*&nbsp;</font></span>状态：</label>
				<div class="controls self-label">
					<form:radiobuttons path="status"
						items="${fns:getDictList('oa_notify_status')}" itemLabel="label"
						itemValue="value" htmlEscape="false" class="required" />
				</div>
			</div>
			<div class="control-group" id="receiveInput1" style="display: block;">
				<label class="control-label"><span class="help-inline">
					<font color="red">*&nbsp;</font> </span>接收对象：</label>
				<div class="controls">
					<sys:treeselect id="oaNotifyRecord" name="oaNotifyRecordIds"
						value="${officeIdList}"
						labelName="oaNotifyRecordNames"
						labelValue="${officeNameList}" title="学院专业"
						url="/sys/office/treeData?type=2"
						cssClass="input-xxlarge required" notAllowSelectParent="true"
						checked="true"  />
				</div>
			</div>
		</c:if>


		<c:if test="${oaNotify.status eq '1'}">
			<div class="control-group">
				<label class="control-label"><span class="help-inline"><font
						color="red">*&nbsp;</font></span>状态：</label>
				<div class="controls self-label">
					<form:radiobuttons path="status" items="${fns:getDictList('oa_notify_status')}" itemLabel="label"
						itemValue="value" htmlEscape="false" class="required"
						readonly="true" />
				</div>
			</div>

			<div class="control-group" id="receiveInput2" style="display: block;">
				<label class="control-label">接收人：</label>
				<div class="controls">
					<table id="contentTable"
						class="table  table-bordered table-condensed">
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



		<div class="form-actions">
			<c:if test="${oaNotify.status ne '1'}">
				<input id="btnSubmit" class="btn btn-primary"  onclick="saveOAForm()" type="button" value="保 存"/>&nbsp;
			</c:if>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
	</div>

</body>
</html>