<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>学生库管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(
			function() {
				//$("#name").focus();
				$("#inputForm")
						.validate(
								{
									submitHandler : function(form) {
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
<style type="text/css">
		ul li{
			list-style-type:none;
		}
	</style>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/sys/studentExpansion/">学生库列表</a></li>
		<li class="active"><a
			href="${ctx}/sys/studentExpansion/form?id=${studentExpansion.id}">学生库列表<shiro:hasPermission
					name="sys:studentExpansion:edit">${not empty studentExpansion.id?'修改':'添加'}</shiro:hasPermission>
				<shiro:lacksPermission name="sys:studentExpansion:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<br />
	<form:form id="inputForm" modelAttribute="studentExpansion"
		action="${ctx}/sys/studentExpansion/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" id="studentId"/>

		<div class="other" id="fujian">
				<div class="biaoti" >
						<input type="file"  style="display: none" id="fileToUpload" name="fileName"/>
					</div>
				<ul id="file">
				</ul>
				<img src="${fns:ftpImgUrl(user.photo) }" alt="请上传头像" id="fileId" />
				<%-- <img src="/a/download?fileName=${fns:urlEncode(user.photo)}" alt="请上传头像" id="fileId" /> --%>
				<input name="url" value="${user.photo}" id="url" type="hidden"/>
				<hr/>
				<a class="upload"id="upload">更新照片</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<c:if test="${user.photo!=null && user.photo!='' }">
					<a class='del'>删除</a>
				</c:if>
			</div>
		<div class="control-group">
			<label class="control-label">姓名：</label>
			<div class="controls">
				<form:input path="user.name" htmlEscape="false"
					class="input-xlarge " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">性别：</label>
			女<input name="user.sex" value="0" type="radio" checked="checked">
			男<input name="user.sex" value="1" type="radio">
		</div>
		<div class="control-group">
			<label class="control-label">证件号码：</label>
			<div class="controls">
				<form:input path="user.idNumber" htmlEscape="false" maxlength="18"
					class="input-xlarge " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">民族：</label>
			<div class="controls">
				<form:select path="user.national" class="input-xlarge ">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('national_type')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">国家：</label>
			<div class="controls">
				<form:input path="user.country" htmlEscape="false" maxlength="11"
					class="input-xlarge " />
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">联系地址：</label>
			<div class="controls">
				<form:input path="user.area" htmlEscape="false" maxlength="11"
					class="input-xlarge " />
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">电子邮箱：</label>
			<div class="controls">
				<form:input path="user.email" htmlEscape="false" maxlength="24"
					class="input-xlarge " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">手机号：</label>
			<div class="controls">
				<form:input path="user.mobile" htmlEscape="false" maxlength="24"
					class="input-xlarge " />
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">院系名称：</label>
			<div class="controls">
				<select name="user.office.id">
					<c:forEach items="${offices }" var="office">
						<option value="${office.id }">${office.name }</option>
					</c:forEach>
				</select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">专业：</label>
			<div class="controls">
				<form:input path="user.professional" htmlEscape="false"
					maxlength="11" class="input-xlarge " />
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">学号：</label>
			<div class="controls">
				<form:input path="user.no" htmlEscape="false" maxlength="11"
					class="input-xlarge " />
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">在读学位：</label>
			<div class="controls">
				<form:input path="instudy" htmlEscape="false" maxlength="32"
					class="input-xlarge " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">学历：</label>
			<div class="controls">
				<form:input path="user.education" htmlEscape="false" maxlength="32"
					class="input-xlarge " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">学位：</label>
			<div class="controls">
				<form:select path="user.degree" class="input-xlarge ">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('degree_type')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">是否公开：</label>
			<div class="controls">
				<form:select path="isOpen" class="input-xlarge ">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('open_Type')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">政治面貌：</label>
			<div class="controls">
				<form:select path="user.political" class="input-xlarge ">
					<form:option value="" label="" />
					<form:options items="${fns:getDictList('poli_type')}"
						itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">毕业时间：</label>
			<div class="controls">
				<input name="graduation" type="text" maxlength="20"
					class="input-medium Wdate "
					value="<fmt:formatDate value="${studentExpansion.graduation}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">休学时间：</label>
			<div class="controls">
				<input name="temporaryDate" type="text" maxlength="20"
					class="input-medium Wdate "
					value="<fmt:formatDate value="${studentExpansion.temporaryDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">技术领域：</label>
			<div class="controls">
				<form:input path="user.domain" htmlEscape="false" maxlength="32"
					class="input-xlarge " />
			</div>
		</div>
		<%-- <div class="control-group">
			<label class="control-label">项目周期</label>
			<c:if test="${studentExpansion.projectDeclare.planStartDate != null }">
			<fmt:formatDate
				value="${studentExpansion.projectDeclare.planStartDate }"
				type="date" dateStyle="medium" />
			--<fmt:formatDate
				value="${studentExpansion.projectDeclare.planEndDate }" type="date"
				dateStyle="medium" /></c:if>
		</div>
		<div class="control-group">
			<label class="control-label">项目名称</label>
			<div class="controls">${studentExpansion.projectDeclare.name }
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">担任角色</label>
			<div class="controls">${studentExpansion.projectDeclare.leader }
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">项目评级</label>
			<div class="controls">${studentExpansion.projectDeclare.level }
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">项目结果</label>
		<div class="controls">
			${studentExpansion.projectDeclare.resultContent }
			</div>
		</div> --%>
		<div class="form-actions">
			<shiro:hasPermission name="sys:studentExpansion:edit">
				<input id="btnSubmit" class="btn btn-primary" type="submit"
					value="保 存" />&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回"
				onclick="history.go(-1)" />
		</div>
	</form:form>
	<script src="/common/common-js/jquery-1.11.2.min.js"></script>
	<script src="/common/common-js/jquery-migrate-1.2.1.min.js"></script>
	<!-- 引用ajaxfileupload.js -->
	<script src="/common/common-js/jquery.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="/common/common-js/jquery.validate.min.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript" src="/js/gcontest/studentExpansion.js"></script>
	<script src="/common/common-js/ajaxfileupload.js"></script>
</body>
</html>