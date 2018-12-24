<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>业务配置项管理</title>
	<%@include file="/WEB-INF/views/include/backtable.jsp" %>
	<style>
		.table-thead-bg thead tr{
			background-color: #f4e6d4;
		}
		.table th{
			background: none;
		}
		#searchForm{
			height: auto;
			padding: 15px 0 0;
			overflow: hidden;
		}
		.ul-form input[type="text"]{
			height: 20px;
		}
		.ul-form select{
			height: 30px;
			width: 174px;
			max-width: 174px;
		}
		.form-search .ul-form li{
			margin-bottom: 15px;
		}
		.form-search .ul-form li.btns{
			float: right;
		}
		.table{
			margin-bottom: 20px;
		}
	</style>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#ps").val($("#pageSize").val());
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<div class="mybreadcrumbs">
		<span>业务配置项</span>
	</div>
	<div class="content_panel">
		<ul class="nav nav-tabs">
			<li class="active"><a href="${ctx}/actyw/actYwConfig/">业务配置项列表</a></li>
			<shiro:hasPermission name="actyw:actYwConfig:edit"><li><a href="${ctx}/actyw/actYwConfig/form">业务配置项添加</a></li></shiro:hasPermission>
		</ul>
		<form:form id="searchForm" modelAttribute="actYwConfig" action="${ctx}/actyw/actYwConfig/" method="post" class="breadcrumb form-search">
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<ul class="ul-form">
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
				<li><label>项目流程id：</label>
				</li>
			</ul>
		</form:form>
		<sys:message content="${message}"/>
		<table id="contentTable" class="table table-striped table-bordered table-condensed table-thead-bg">
			<thead>
				<tr>
					<th>项目流程id</th>
					<th>是否有流程部署：0,默认是;1,否</th>
					<th>流程部署方式：0,默认全覆盖;1,部分更新(不用重新部署);</th>
					<th>是否固定流程：0,默认否;1,是固定流程</th>
					<th>固定流程XML文件地址;</th>
					<th>是否有学分流程：0,默认否;1,是;</th>
					<th>学分流程ID</th>
					<th>是否有菜单：0,默认否;</th>
					<th>重新发布时是否重置菜单：0,默认否;</th>
					<th>菜单主题：0,默认;</th>
					<th>是否有开启全局审核：1,默认是;0,否;</th>
					<th>审核类型（全局审核为否是启用）：0,学院自审;1,指定学院审核;</th>
					<th>指定审核的学院或部门</th>
					<th>是否有栏目：0,默认否;</th>
					<th>重新发布时是否重置栏目：0,默认否;</th>
					<th>栏目主题：0,默认;</th>
					<th>是否有站内信通知：1,默认,是;0,否;</th>
					<th>是否有站内信消息通知：1,默认,是;0,否;</th>
					<th>是否有站内信邮件通知：1,默认,是;0,否;</th>
					<th>是否有证书：0,默认否;</th>
					<th>证书下发方式：0,默认;</th>
					<th>证书显示位置：默认所有;</th>
					<th>证书开启站内信通知：1,默认,是;0,否;</th>
					<th>证书开启消息通知：1,默认,是;0,否;</th>
					<th>证书开启邮件通知：1,默认,是;0,否;</th>
					<th>是否支持指派：0,默认否;</th>
					<th>指派方式：0,默认;</th>
					<th>指派显示位置：默认所有;</th>
					<th>是否显示时间(0否、1是)</th>
					<th>是否有申报节点：0,默认否（流程没有申报，申报页固定写死）;1,是（申报节点必须为顶一个节点-校验）</th>
					<th>是否申报作为开始节点：0,默认否（项目开始时间以申报节点后一个节点开始时间作为开始）;</th>
					<th>申报节点ID</th>
					<th>申报页URL(自定义申报也可不填)</th>
					<th>是否有申报限制：0,默认否（没有任何申报条件限制，如果有全局配置，则使用全局配置）;1,是</th>
					<th>申报处理方式：0,默认,1人1次; 1,指定次数; 2,指定次数;</th>
					<th>申报次数：默认1</th>
					<th>是否开启通过率：0,默认否;</th>
					<th>通过率处理方式：0,默认;</th>
					<th>通过率显示位置：默认所有;</th>
					<th>是否定制编号规则：0,默认否,系统生成;</th>
					<th>编号规则ID</th>
					<th>是否支持取别名：0,默认否,根据类型生成;1,是;</th>
					<th>别名方式:0,自定义;1,动态维护;</th>
					<th>是否有时间轴：0,否;1,默认是;</th>
					<th>是否有通用标识：0,默认否;1,是;</th>
					<th>通用标识</th>
					<th>是否有限制团队人数：0,默认否,使用全局配置;1,是;</th>
					<th>团队最少人数</th>
					<th>团队最多人数</th>
					<th>是否允许入驻孵化器：0,默认否;1,是;</th>
					<th>是否有孵化器流程：0,默认否;1,是;</th>
					<th>孵化器流程ID</th>
					<th>最后更新时间</th>
					<th>备注</th>
					<shiro:hasPermission name="actyw:actYwConfig:edit"><th>操作</th></shiro:hasPermission>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${page.list}" var="actYwConfig">
				<tr>
					<td><a href="${ctx}/actyw/actYwConfig/form?id=${actYwConfig.id}">
						${actYwConfig.ywId}
					</a></td>
					<td>
						${fns:getDictLabel(actYwConfig.hasFlowDeploy, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.flowDeployWay, 'act_flow_deploy_way', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.flowGd, 'yes_no', '')}
					</td>
					<td>
						${actYwConfig.flowXml}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasScore, 'yes_no', '')}
					</td>
					<td>
						${actYwConfig.scoreFid}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasMenu, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.menuReset, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.menuTheme, 'act_menu_theme', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasGlobalAudit, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.auditType, 'act_audit_type', '')}
					</td>
					<td>
						${actYwConfig.}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasCategpry, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.categpryReset, 'act_categpry_reset', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.categpryTheme, 'act_categpry_theme', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasNotice, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasMsg, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasEmail, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasCert, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.certWay, 'act_cert_way', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.certShowType, 'act_cert_show_type', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.certNotice, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.certMsg, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.certEmail, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasAssign, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.assignWay, 'act_assign_way', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.assignShowType, 'act_assign_show_type', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasTime, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasApypage, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.apypageAsStart, 'yes_no', '')}
					</td>
					<td>
						${actYwConfig.apypageId}
					</td>
					<td>
						${actYwConfig.apypageUrl}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasApplylt, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.applyltWay, 'act_applylt_way', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.applyltNum, 'act_applylt_num', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasPrate, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.prateWay, 'act_prate_way', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.prateShowType, 'act_prate_show_type', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasNrule, 'yes_no', '')}
					</td>
					<td>
						${actYwConfig.nruleId}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasRename, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.renameWay, 'act_rename_way', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasAxis, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasKey, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.keyType, 'act_key_type', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasTeamlt, 'yes_no', '')}
					</td>
					<td>
						${actYwConfig.teamltMin}
					</td>
					<td>
						${actYwConfig.teamltMax}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.allowEnjoy, 'yes_no', '')}
					</td>
					<td>
						${fns:getDictLabel(actYwConfig.hasIncubator, 'yes_no', '')}
					</td>
					<td>
						${actYwConfig.incubatorFid}
					</td>
					<td>
						<fmt:formatDate value="${actYwConfig.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
					<td>
						${actYwConfig.remarks}
					</td>
					<shiro:hasPermission name="actyw:actYwConfig:edit"><td>
	    				<a class="check_btn btn-pray btn-lx-primary" href="${ctx}/actyw/actYwConfig/form?id=${actYwConfig.id}">修改</a>
						<a class="check_btn btn-pray btn-lx-primary" href="${ctx}/actyw/actYwConfig/delete?id=${actYwConfig.id}" onclick="return confirmx('确认要删除该业务配置项吗？', this.href)">删除</a>
					</td></shiro:hasPermission>
				</tr>
			</c:forEach>
			</tbody>
		</table>
		${page.footer}
	</div>
	<div id="dialog-message" title="信息">
		<p id="dialog-content"></p>
	</div>
</body>
</html>