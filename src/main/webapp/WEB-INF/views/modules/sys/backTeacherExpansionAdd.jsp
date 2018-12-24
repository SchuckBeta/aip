<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<html>
<head>

	<title>导师信息管理</title>
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
		<li><a href="${ctx}/sys/backTeacherExpansion/">导师库列表</a></li>
		<li class="active"><a href="${ctx}/sys/backTeacherExpansion/form?id=${backTeacherExpansion.id}">导师库<shiro:hasPermission name="sys:backTeacherExpansion:edit">${not empty backTeacherExpansion.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:backTeacherExpansion:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="backTeacherExpansion" action="${ctx}/sys/backTeacherExpansion/save" method="post" enctype="multipart/form-data" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">职工号：</label>
			<div class="controls">
				<form:input path="user.no" htmlEscape="false" maxlength="64"  class="input-xlarge required"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">姓名：</label>
			<div class="controls">
				<form:input path="user.name" htmlEscape="false" maxlength="11" class="input-xlarge required"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">导师来源：</label>
			<div class="controls">
				<form:select path="teachertype" class="input-xlarge ">
					<form:options items="${fns:getDictList('master_type')}" itemLabel="label" itemValue="value" htmlEscape="false"  />
				</form:select>
			</div>
		</div>
	<div class="control-group">
			<label class="control-label">性别：</label>
			<div class="controls">
				<form:select path="user.sex" class="input-xlarge ">
					<form:options items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false" class="input-xlarge required"/>
				</form:select>
			</div>
			
		</div>
		
		<div class="control-group">
			<label class="control-label">登录名：</label>
			<div class="controls">
				<form:input path="user.loginName" htmlEscape="false" maxlength="11" class="input-xlarge required"/>
				<font color="red" size="3"><span>${loginNameMessage}</span></font>
			</div>
		</div> 
		 <div class="control-group">
			<label class="control-label">登录密码：</label>
			<div class="controls">
				<form:input path="user.password" htmlEscape="false" maxlength="12"  class="input-xlarge required"/>
			</div>
		</div>  
			<div class="control-group">
			<label class="control-label">出生年月：</label>
			<div class="controls">
				<input name="user.birthday" type="text"  maxlength="20" class="input-xlarge required"  class="input-medium Wdate "
					value="<fmt:formatDate value="${backTeacherExpansion.user.birthday}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</div>
			</div>
		 <div class="control-group">
			<label class="control-label">国家/地区：</label>
			<div class="controls">
				<form:input path="user.area" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">民族：</label>
			<div class="controls">
				<form:select path="user.national" class="input-xlarge ">
					<form:options items="${fns:getDictList('national_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">政治面貌：</label>
			<div class="controls">
				<form:select path="user.political" class="input-xlarge ">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('poli_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
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
			<label class="control-label">证件类型：</label>
			<div class="controls">
				<form:input path="user.idType" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
			</div>
			<div class="control-group">
			<label class="control-label">证件号：</label>
			<div class="controls">
				<form:input path="user.idNumber" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
		</div>
			<div class="control-group">
			<label class="control-label">学历类别：</label>
			<div class="controls">
				<form:select path="educationType" class="input-xlarge ">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('enducation_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
			</div>
					<div class="control-group">
						<label class="control-label">学历：</label>
							<div class="controls">
							<form:input path="user.education" htmlEscape="false" maxlength="128"
								class="input-xlarge " />
							</div>
					</div>
			<div class="control-group">
			<label class="control-label">层次：</label>
			<div class="controls">
				<form:input path="arrangement" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
			</div>
			<div class="control-group">
			 <label class="control-label">学科门类：</label>
			<div class="controls">
				<form:select path="discipline" class="input-xlarge ">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('0000000111')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div> 
			</div>
			
			<div class="control-group">
			<label class="control-label">学位：</label>
			<div class="controls">
				<form:select path="user.degree" class="input-xlarge ">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('degree_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
			</div>
			<div class="control-group">
				<label class="control-label">院系名称：</label>
				<div class="controls">
				<select name="user.office.id">
					<c:forEach items="${offices }" var="office">
					<option value="${office.id }" <c:if test="${backTeacherExpansion.user.sex==0}">selected="selected"</c:if>>${office.name }</option>
					</c:forEach>
				</select>
			</div>
		</div>
			<div class="control-group">
			<label class="control-label">专业名称：</label>
			<div class="controls">
				<form:input path="user.professional" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
			</div>
			<div class="control-group">
			<label class="control-label">行业：</label>
			<div class="controls">
				<form:input path="industry" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
			</div>
			<div class="control-group">
			<label class="control-label">职务/职称：</label>
			<div class="controls">
				<form:input path="technicalTitle" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
			</div>
		<div class="control-group">
			<label class="control-label">推荐单位：</label>
			<div class="controls">
				<form:input path="recommendedUnits" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
		</div>
			<div class="control-group">
			<label class="control-label">工作简历：</label>
			<div class="controls">
				<form:input path="resume" htmlEscape="false" maxlength="128" class="input-xlarge "/>
			</div>
			</div>
			<div class="control-group">
			<label class="control-label">技术领域：</label>
			<div class="controls">
				<form:input path="user.domain" htmlEscape="false" maxlength="128" class="input-xlarge "/>
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
				<form:select path="level" class="input-xlarge ">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('teacher_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
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
				<form:input path="joinReviewTime" htmlEscape="false" maxlength="128" class="input-xlarge "/>
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
				<form:input path="bankAccount" htmlEscape="false" maxlength="19" minlength="16" class="input-xlarge number digits"/>
			</div>
		</div>
	
		<div class="control-group">
			<label class="control-label">是否公开：</label>
			<div class="controls">
				<form:select path="isOpen" class="input-xlarge ">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('open_Type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
<!-- 		<div class="other" id="fujian">
			 		<div class="biaoti" >
						<span>附件：</span>
						<a class="upload"id="upload">上传附件</a>
						<input type="file"  style="display: none" id="fileToUpload" name="fileName"/>	
					</div>
		</div> -->
		<div class="form-actions">
			<shiro:hasPermission name="sys:backTeacherExpansion:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div> 
		
	</form:form>
	
	<script src="/common/common-js/jquery-1.11.2.min.js"></script>
	<script src="/common/common-js/jquery-migrate-1.2.1.min.js"></script>
	<!-- 引用ajaxfileupload.js -->
	<script src="/common/common-js/jquery.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="/common/common-js/jquery.validate.min.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript" src="/js/gcontest/teacherup.js"></script>
	<script src="/common/common-js/ajaxfileupload.js"></script>
	<script type="text/javascript">
	$(function(){
		var initDSSB = function(){
			DSSB.tabletrminus();
			DSSB.tabletrplus();
			DSSB.printOut();
		}
		$("#downfile").click(function(){
			var url = $("#downfile").next().val();
			location.href="/a/download?fileName="+encodeURIComponent(url);
		});
	})
	</script>
</body>
</html>