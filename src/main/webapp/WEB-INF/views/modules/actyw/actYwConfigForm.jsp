<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>业务配置项管理</title>
	<%@include file="/WEB-INF/views/include/backtable.jsp" %>
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
	<div class="mybreadcrumbs">
		<span>业务配置项</span>
	</div>
	<div class="content_panel">
		<ul class="nav nav-tabs">
			<li><a href="${ctx}/actyw/actYwConfig/">业务配置项列表</a></li>
			<li class="active"><a href="${ctx}/actyw/actYwConfig/form?id=${actYwConfig.id}">业务配置项<shiro:hasPermission name="actyw:actYwConfig:edit">${not empty actYwConfig.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="actyw:actYwConfig:edit">查看</shiro:lacksPermission></a></li>
		</ul><br/>
		<form:form id="inputForm" modelAttribute="actYwConfig" action="${ctx}/actyw/actYwConfig/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>
			<div class="control-group">
				<label class="control-label">项目流程id：</label>
				<div class="controls">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有流程部署：0,默认是;1,否：</label>
				<div class="controls">
					<form:radiobuttons path="hasFlowDeploy" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">流程部署方式：0,默认全覆盖;1,部分更新(不用重新部署);：</label>
				<div class="controls">
					<form:select path="flowDeployWay" class="input-xlarge ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_flow_deploy_way')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否固定流程：0,默认否;1,是固定流程：</label>
				<div class="controls">
					<form:radiobuttons path="flowGd" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">固定流程XML文件地址;：</label>
				<div class="controls">
					<form:input path="flowXml" htmlEscape="false" maxlength="1" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有学分流程：0,默认否;1,是;：</label>
				<div class="controls">
					<form:radiobuttons path="hasScore" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">学分流程ID：</label>
				<div class="controls">
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有菜单：0,默认否;：</label>
				<div class="controls">
					<form:radiobuttons path="hasMenu" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">重新发布时是否重置菜单：0,默认否;：</label>
				<div class="controls">
					<form:radiobuttons path="menuReset" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">菜单主题：0,默认;：</label>
				<div class="controls">
					<form:select path="menuTheme" class="input-xlarge required">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_menu_theme')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有开启全局审核：1,默认是;0,否;：</label>
				<div class="controls">
					<form:radiobuttons path="hasGlobalAudit" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">审核类型（全局审核为否是启用）：0,学院自审;1,指定学院审核;：</label>
				<div class="controls">
					<form:select path="auditType" class="input-xlarge required">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_audit_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">指定审核的学院或部门：</label>
				<div class="controls">
					<sys:treeselect id="auditOfficeId" name="auditOfficeId" value="${actYwConfig.auditOfficeId}" labelName="" labelValue="${actYwConfig.}"
						title="部门" url="/sys/office/treeData?type=2" cssClass="" allowClear="true" notAllowSelectParent="true"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有栏目：0,默认否;：</label>
				<div class="controls">
					<form:radiobuttons path="hasCategpry" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">重新发布时是否重置栏目：0,默认否;：</label>
				<div class="controls">
					<form:radiobuttons path="categpryReset" items="${fns:getDictList('act_categpry_reset')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">栏目主题：0,默认;：</label>
				<div class="controls">
					<form:select path="categpryTheme" class="input-xlarge required">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_categpry_theme')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有站内信通知：1,默认,是;0,否;：</label>
				<div class="controls">
					<form:radiobuttons path="hasNotice" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有站内信消息通知：1,默认,是;0,否;：</label>
				<div class="controls">
					<form:radiobuttons path="hasMsg" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有站内信邮件通知：1,默认,是;0,否;：</label>
				<div class="controls">
					<form:radiobuttons path="hasEmail" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有证书：0,默认否;：</label>
				<div class="controls">
					<form:radiobuttons path="hasCert" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">证书下发方式：0,默认;：</label>
				<div class="controls">
					<form:select path="certWay" class="input-xlarge required">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_cert_way')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">证书显示位置：默认所有;：</label>
				<div class="controls">
					<form:select path="certShowType" class="input-xlarge ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_cert_show_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">证书开启站内信通知：1,默认,是;0,否;：</label>
				<div class="controls">
					<form:radiobuttons path="certNotice" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">证书开启消息通知：1,默认,是;0,否;：</label>
				<div class="controls">
					<form:radiobuttons path="certMsg" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">证书开启邮件通知：1,默认,是;0,否;：</label>
				<div class="controls">
					<form:radiobuttons path="certEmail" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否支持指派：0,默认否;：</label>
				<div class="controls">
					<form:radiobuttons path="hasAssign" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">指派方式：0,默认;：</label>
				<div class="controls">
					<form:select path="assignWay" class="input-xlarge required">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_assign_way')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">指派显示位置：默认所有;：</label>
				<div class="controls">
					<form:select path="assignShowType" class="input-xlarge ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_assign_show_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否显示时间(0否、1是)：</label>
				<div class="controls">
					<form:radiobuttons path="hasTime" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有申报节点：0,默认否（流程没有申报，申报页固定写死）;1,是（申报节点必须为顶一个节点-校验）：</label>
				<div class="controls">
					<form:radiobuttons path="hasApypage" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否申报作为开始节点：0,默认否（项目开始时间以申报节点后一个节点开始时间作为开始）;：</label>
				<div class="controls">
					<form:radiobuttons path="apypageAsStart" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">申报节点ID：</label>
				<div class="controls">
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">申报页URL(自定义申报也可不填)：</label>
				<div class="controls">
					<form:hidden id="apypageUrl" path="apypageUrl" htmlEscape="false" maxlength="64" class="input-xlarge"/>
					<sys:ckfinder input="apypageUrl" type="files" uploadPath="/actyw/actYwConfig" selectMultiple="true"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有申报限制：0,默认否（没有任何申报条件限制，如果有全局配置，则使用全局配置）;1,是：</label>
				<div class="controls">
					<form:radiobuttons path="hasApplylt" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">申报处理方式：0,默认,1人1次; 1,指定次数; 2,指定次数;：</label>
				<div class="controls">
					<form:select path="applyltWay" class="input-xlarge required">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_applylt_way')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">申报次数：默认1：</label>
				<div class="controls">
					<form:select path="applyltNum" class="input-xlarge required">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_applylt_num')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否开启通过率：0,默认否;：</label>
				<div class="controls">
					<form:radiobuttons path="hasPrate" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">通过率处理方式：0,默认;：</label>
				<div class="controls">
					<form:select path="prateWay" class="input-xlarge required">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_prate_way')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">通过率显示位置：默认所有;：</label>
				<div class="controls">
					<form:select path="prateShowType" class="input-xlarge ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_prate_show_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否定制编号规则：0,默认否,系统生成;：</label>
				<div class="controls">
					<form:radiobuttons path="hasNrule" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">编号规则ID：</label>
				<div class="controls">
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否支持取别名：0,默认否,根据类型生成;1,是;：</label>
				<div class="controls">
					<form:radiobuttons path="hasRename" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">别名方式:0,自定义;1,动态维护;：</label>
				<div class="controls">
					<form:select path="renameWay" class="input-xlarge required">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_rename_way')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有时间轴：0,否;1,默认是;：</label>
				<div class="controls">
					<form:radiobuttons path="hasAxis" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有通用标识：0,默认否;1,是;：</label>
				<div class="controls">
					<form:radiobuttons path="hasKey" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">通用标识：</label>
				<div class="controls">
					<form:select path="keyType" class="input-xlarge ">
						<form:option value="" label="--请选择--"/>
						<form:options items="${fns:getDictList('act_key_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有限制团队人数：0,默认否,使用全局配置;1,是;：</label>
				<div class="controls">
					<form:radiobuttons path="hasTeamlt" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">团队最少人数：</label>
				<div class="controls">
					<form:input path="teamltMin" htmlEscape="false" maxlength="255" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">团队最多人数：</label>
				<div class="controls">
					<form:input path="teamltMax" htmlEscape="false" maxlength="255" class="input-xlarge "/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否允许入驻孵化器：0,默认否;1,是;：</label>
				<div class="controls">
					<form:radiobuttons path="allowEnjoy" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">是否有孵化器流程：0,默认否;1,是;：</label>
				<div class="controls">
					<form:radiobuttons path="hasIncubator" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">孵化器流程ID：</label>
				<div class="controls">
					<span class="help-inline"><font color="red">*</font> </span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">备注：</label>
				<div class="controls">
					<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="200" class="input-xxlarge "/>
				</div>
			</div>
			<div class="form-actions">
				<shiro:hasPermission name="actyw:actYwConfig:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</form:form>
	</div>
	<div id="dialog-message" title="信息">
		<p id="dialog-content"></p>
	</div>
</body>
</html>