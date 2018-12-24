<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<title>${backgroundTitle}</title>
	<%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
	<!-- <meta name="decorator" content="default"/> -->
	<script type="text/javascript">
		$(document).ready(function() {
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
					} else if(element.attr('name') === 'pwFassetsnoRule.numberLen'){
                        error.appendTo(element.parent());
					}else {
						error.insertAfter(element);
					}
				}
			});
		});
	</script>
</head>
<body>
<div class="container-fluid">
	<%--<div class="edit-bar clearfix">--%>
		<%--<div class="edit-bar-left">--%>
			<%--<span>资产类别</span>--%>
			<%--<i class="line weight-line"></i>--%>
		<%--</div>--%>
	<%--</div>--%>
	<%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
	<div class="content_panel">
		<ul class="nav nav-tabs">
			<li><a href="${ctx}/pw/pwCategory/">资产类别列表</a></li>
			<li class="active"><a href="${ctx}/pw/pwCategory/form?id=${pwCategory.id}&parent.id=${pwCategory.parent.id}">资产类别<shiro:hasPermission name="pw:pwCategory:edit">${not empty pwCategory.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="pw:pwCategory:edit">查看</shiro:lacksPermission></a></li>
		</ul>
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="pwCategory" action="${ctx}/pw/pwCategory/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<input type="hidden" id="secondName" name="secondName"value="${secondName}"/>

			<%--<div class="control-group">--%>
				<%--<label class="control-label">父类别：</label>--%>
				<%--<c:choose>--%>
					<%--<c:when test="${not empty canEditParent and canEditParent == true}">--%>
						<%--<div class="controls">--%>
							<%--<sys:treeselectCategory id="parent" name="parent.id" value="${pwCategory.parent.id}"--%>
													<%--labelName="parent.name" labelValue="${pwCategory.parent.name}"--%>
													<%--title="父级编号" url="/pw/pwCategory/pwCategoryTree"--%>
													<%--extId="${pwCategory.id}" cssClass="" cssStyle="width:175px;" allowClear="false"/>--%>
						<%--</div>--%>
					<%--</c:when>--%>
					<%--<c:otherwise>--%>
						<%--<div class="controls">--%>
							<%--<form:input path="parent.id" value="${pwCategory. parent.name}" htmlEscape="false" readonly="true"/>--%>
						<%--</div>--%>
					<%--</c:otherwise>--%>
				<%--</c:choose>--%>
			<%--</div>--%>
			<c:choose>
				<c:when test="${pwCategory.parent.id != '1'}">
					<div class="control-group">
						<label class="control-label"><i>*</i>父类别：</label>
						<div class="controls">
							<form:select path="parent.id" class="form-control required">
								<form:option value="" label="---请选择---"/>
								<form:options items="${fns:findChildrenCategorys('1')}" itemLabel="name" itemValue="id"
											  htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</c:when>
				<c:otherwise>
					<form:hidden path="parent.id" value="${pwCategory.parent.id}"/>
				</c:otherwise>
			</c:choose>
			<div class="control-group">
				<label class="control-label"><i>*</i>名称：</label>
				<div class="controls">
					<form:input path="name" htmlEscape="false" maxlength="30" class="required"/>
					<span class="help-inline"> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">备注：</label>
				<div class="controls">
					<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="200" class="input-xxlarge "/>
				</div>
			</div>
			<div class="edit-bar edit-bar-sm clearfix">
				<div class="edit-bar-left">
					<span>编号规则</span>
					<i class="line"></i>
				</div>
			</div>


			<div class="control-group">
				<label class="control-label"><i>*</i>前缀：</label>
				<div class="controls">
					<form:input path="pwFassetsnoRule.prefix" htmlEscape="false" maxlength="24" class="required isLetter"/>
				</div>
			</div>
			<div class="control-group control-group-number-rule" style="display:
				<c:if test="${pwCategory.parent.id == '1'}">none</c:if>">
					<label class="control-label"><i>*</i>开始编号：</label>
					<div class="controls">
						<form:input path="pwFassetsnoRule.startNumber" htmlEscape="false" maxlength="8" class="required number digits"/>
					</div>
			</div>
			<div class="control-group control-group-number-rule" style="display:
				<c:if test="${pwCategory.parent.id == '1'}">none</c:if>">
					<label class="control-label"><i>*</i>编号位数：</label>
					<div class="controls">
						<form:input path="pwFassetsnoRule.numberLen" htmlEscape="false" maxlength="2" class="required number digits"/>
						<span class="help-inline gray-color">表示数字最小的位数，不足位数的前面补0</span>
					</div>
			</div>
			<div class="control-group control-group-number-rule" style="display:
			<c:if test="${pwCategory.parent.id == '1'}">none</c:if>">
				<label class="control-label gray-color">示例：</label>
				<div class="controls">
					<span id="example" class="control-static help-inline gray-color"></span>
				</div>
			</div>
			<div class="form-actions">
				<shiro:hasPermission name="pw:pwCategory:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn btn-default" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</form:form>
	</div>
	<div id="dialog-message" title="信息">
		<p id="dialog-content"></p>
	</div>
</div>
<input type="hidden" id="parentPrefix" value="${pwCategory.parent.pwFassetsnoRule.prefix}">
</body>
<script>

    function prefixZero(num, length) {
        return (Array(length).join('0') + num).slice(-length);
    }

    function showExample() {
        var prefix = $("input[name='pwFassetsnoRule.prefix']").val();
        var startNumber = $("input[name='pwFassetsnoRule.startNumber']").val();
        var numberLen = $("input[name='pwFassetsnoRule.numberLen']").val();
        if(prefix && startNumber && numberLen){
            var parentPrefix = $("#parentPrefix").val();
            $("#example").text(parentPrefix + prefix + prefixZero(parseInt(startNumber), parseInt(numberLen)));
        }
    }

    showExample();

	$('input[name="pwFassetsnoRule.prefix"],input[name="pwFassetsnoRule.startNumber"],input[name="pwFassetsnoRule.numberLen"]').on('input propertychange', function () {
        showExample();
    })



</script>
</html>