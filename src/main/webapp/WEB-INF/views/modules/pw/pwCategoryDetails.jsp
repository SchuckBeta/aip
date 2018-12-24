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
			<span>资产类别</span>
			<i class="line weight-line"></i>
		</div>
	</div>
	<div class="content_panel">
		<ul class="nav nav-tabs">
			<li><a href="${ctx}/pw/pwCategory/">资产类别列表</a></li>
			<li class="active"><a href="${ctx}/pw/pwCategory/form?id=${pwCategory.id}&parent.id=${pwCategory.parent.id}">资产类别查看</a></li>
		</ul>
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="pwCategory" action="${ctx}/pw/pwCategory/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<div class="control-group">
				<label class="control-label">父类别：</label>
				<div class="controls">
					<p class="control-static">${pwCategory.parent.name}</p>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">名称：</label>
				<div class="controls">
					<p class="control-static">${pwCategory.name}</p>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">备注：</label>
				<div class="controls">
					<p class="control-static">${pwCategory.remarks}</p>
				</div>
			</div>
			<div class="edit-bar edit-bar-sm clearfix">
				<div class="edit-bar-left">
					<span>编号规则</span>
					<i class="line"></i>
				</div>
			</div>


			<div class="control-group">
				<label class="control-label">前缀：</label>
				<div class="controls">
					<p class="control-static" id="prefix">${pwCategory.pwFassetsnoRule.prefix}</p>
				</div>
			</div>
			<div class="control-group control-group-number-rule" style="display:
				<c:if test="${pwCategory.parent.id == '1'}">none</c:if>">
					<label class="control-label">开始编号：</label>
					<div class="controls">
						<p class="control-static" id="startNumber">${pwCategory.pwFassetsnoRule.startNumber}</p>
					</div>
			</div>
			<div class="control-group control-group-number-rule" style="display:
				<c:if test="${pwCategory.parent.id == '1'}">none</c:if>">
					<label class="control-label">编号位数：</label>
					<div class="controls">
						<p class="control-static" id="numberLen">${pwCategory.pwFassetsnoRule.numberLen}
						<span class="help-inline gray-color">表示数字最小的位数，不足位数的前面补0</span>
						</p>
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
    var prefix = $("#prefix").text();
    var startNumber = $("#startNumber").text();
    var numberLen = $("#numberLen").text();
    if(prefix && startNumber && numberLen){
        var parentPrefix = $("#parentPrefix").val();
        $("#example").text(parentPrefix + prefix + prefixZero(parseInt(startNumber), parseInt(numberLen)));
    }

</script>
</html>