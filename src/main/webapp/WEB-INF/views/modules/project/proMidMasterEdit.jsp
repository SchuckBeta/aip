<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>中期检查报告</title>
	<meta name="decorator" content="site-decorator" />
	<link rel="stylesheet" type="text/css" href="/static/bootstrap/2.3.1/awesome/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="/common/common-css/bootstrap.min.css" />
	<script type="text/javascript" src="/common/common-js/datepicker/My97DatePicker/WdatePicker.js"></script>
	<link rel="stylesheet" type="text/css" href="/css/projectForm.css" />
	<script src="/static/common/mustache.min.js" type="text/javascript"></script>
	<script src="/common/common-js/ajaxfileupload.js"></script>
	<link href="/static/jquery-validation/1.11.0/jquery.validate.min.css" type="text/css" rel="stylesheet" />
	<script src="/static/jquery-validation/1.11.0/jquery.validate.min.js" type="text/javascript"></script>
	<style>
		label.error {
			background-position: 0 3px;
			margin-left: 0px;
		}
	</style>
	<script type="text/javascript">
		var validate;
		$(document).ready(function() {
			validate=$("#inputForm").validate({
				errorPlacement: function(error, element) {
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});


		function submit(){
			if(validate.form()){
				var me = $("#submitBtn");
				if(me.data("data-clicked") === 1) {
					return;
				}
				$("#inputForm").submit();
				me.data("data-clicked", 1);
			}
		}
	</script>
</head>
<body>
	<form action="/f/project/proMid/saveMaster" id="inputForm" method="post">
	<div class="top-title">
		<h3>${projectDeclare.name}</h3>
		<h4>中期检查报告</h4>
		<div class="top-bread">
			<div class="top-prj-num"><span>项目编号:</span>${projectDeclare.number}</div>
			<div class="top-prj-num"><span>创建时间:</span><fmt:formatDate value="${projectDeclare.createDate}" /></div>
			<a href="javascript:;" class="btn btn-sm btn-primary" onclick="history.go(-1);">返回</a>
		</div>
	</div>

		<input type="hidden" name="id" value="${proMid.id}" />

		<div class="outer-wrap">
			<div class="container-fluid">
				            <input type="hidden" id="projectId" name="projectId" value="${projectDeclare.id}">
							<div class="row content-wrap">
								<section class="row">
									<div class="form-horizontal" novalidate>
										<c:set var="leader" value="${fns:getUserById(projectDeclare.leader)}" />
										<div class="form-group col-sm-6 col-md-6 col-lg-6">
											<label class="col-xs-3">项目负责人：</label>
											<p class="col-xs-9">
												${leader.name}
											</p>
										</div>
										<div class="form-group col-sm-2 col-md-2 col-lg-2"></div>
										<div class="form-group col-sm-4 col-md-4 col-lg-4">
											<label class="col-xs-5">专业年级：</label>
											<p  class="col-xs-7">${fns:getOffice(leader.professional).name}<fmt:formatDate value="${student.enterDate}" pattern="yyyy"/></p>
										</div>
									</div>

									<div class="form-horizontal" novalidate>
										<div class="form-group col-sm-6 col-md-6 col-lg-6">
											<label class="col-xs-3 ">项目组成员：</label>
											<p class="col-xs-9">
												${teamList}
											</p>
										</div>
										<div class="form-group col-sm-2 col-md-2 col-lg-2"></div>
										<div class="form-group col-sm-4 col-md-4 col-lg-4">
											<label class="col-xs-5">项目导师：</label>
											<p  class="col-xs-7">${teacher}</p>
										</div>
									</div>

									<div class="form-horizontal" novalidate>
										<div class="form-group col-sm-12 col-md-12 col-lg-12">
											<label class="col-xs-2 ">任务时间段：</label>
											<p class="col-xs-10" style="margin-left: -45px;">
												<fmt:formatDate value="${proMid.taskBeginDate}" pattern="yyyy-MM-dd"/>
												<span>至</span>
												<fmt:formatDate value="${proMid.taskEndDate}" pattern="yyyy-MM-dd"/>
											</p>
										</div>
									</div>
								</section>

								<section class="row">
									<div class="prj_common_info"><h4>计划工作任务</h4><span class="yw-line"></span></div>
									<table class="table table-hover  table-condensed table-bordered">
										<thead>
										<th>序号</th>
										<th>计划时间段</th>
										<th>计划工作任务</th>
										</thead>
										<tbody>
										<c:forEach items="${plans}" var="plan" varStatus="status">
											<tr>
												<td>${status.count}</td>
												<td><fmt:formatDate value="${plan.startDate}" pattern="yyyy-MM-dd"/>  至 <fmt:formatDate value="${plan.endDate}" pattern="yyyy-MM-dd"/></td>
												<td>${plan.content}</td>
											</tr>
										</c:forEach>
										</tbody>
									</table>
								</section>

								<section class="row">
									<div class="prj_common_info"><h4>任务完成情况</h4><span class="yw-line"></span></div>
									<div class="table-wrap">
										<table class="table  table-hover table-bordered">
											<caption style="width:116px;">组成员完成情况</caption>
											<thead>
											<th>项目组成员</th>
											<th>项目分工</th>
											<th>完成情况</th>
											</thead>
											<tbody>
											<c:forEach items="${proSituationList}" var="proSituation" varStatus="status">
												<tr>
													<input type="hidden"  name="proSituationList[${status.index}].user.id" value="${proSituation.user.id}" />
													<td>${proSituation.user.name}</td>
													<td class="td_input">${proSituation.division}</td>
													<td class="td_input">${proSituation.situation}</td>
												</tr>
											</c:forEach>

											</tbody>
										</table>

										<table class="table  table-hover table-bordered">
											<caption style="width:116px;">当前项目进度</caption>
											<thead>
											<th>序号</th>
											<th>实际完成时间</th>
											<th>实际完成情况</th>
											<th>阶段性成果</th>
											</thead>
											<tbody id="prj_process_body">

											<script type="text/template" id="tpl">
												<tr id="progeressTr">
													<td>
														{{idx}}
													</td>
													<td>
														{{row.startDate}}
														<span>至</span>
														{{row.endDate}}
													</td>
													<td class="td_input">
														{{row.situation}}
													</td>
													<td class="td_input">
														{{row.result}}
													</td>
												</tr>
											</script>
											<script type="text/javascript">
												var rowIdx = 1;
												var tpl = $("#tpl").html();
												var delBtn=true;
												function addRow(tbodyId, tpl,row){
													if(rowIdx==1){
														delBtn=false;
													}else{
														delBtn=true;
													}
													$(tbodyId).append(Mustache.render(tpl, {
														idx: rowIdx,nameIdx:rowIdx-1,delBtn:delBtn,row:row
													}));
													rowIdx++;
												}
												function delRow(obj){
													$(obj).parent().parent().remove();
													rowIdx--;
													reOrder();
												}
												function reOrder(){
													//重置序号
													$("#prj_process_body  tr").find("td:first").each(function (i, v) {
														$(this).html(i + 1);
													});
													var index=0;
													var rex="\\[(.+?)\\]";
													$("#prj_process_body tr").each(function (i, v) {
														$(this).find("[name]").each(function (i2, v2) {
															var name=$(this).attr("name");
															var indx=name.match(rex)[1];;
															$(this).attr("name",name.replace(indx,index));
														});
														index++;
													});
												}

												var data = ${fns:toJson(proProgressList)};
												if(data.length>0){
													for (var i=0; i<data.length; i++){
														addRow('#prj_process_body',tpl,data[i]);
													}
												}else{
													addRow('#prj_process_body',tpl,'');
												}

											</script>

											</tbody>
										</table>
									</div>
								</section>

								<section class="row">
									<div class="prj_common_info"><h4>目前存在的问题及解决方案</h4><span class="yw-line"></span></div>
									<div class="textarea-wrap">
										<textarea maxlength="2000"  class="col-xs-12 col-md-12 col-sm-12 col-lg-12 my-textarea" readonly>${proMid.programme}</textarea>
									</div>
								</section>

								<section class="row">
									<div class="prj_common_info" style="height: 40px;line-height: 40px;">
										<h4 class="sub-file">附件 </h4><span class="yw-line"></span>
									</div>
									<div class="textarea-wrap">
										<sys:frontFileUpload fileitems="${fileListMap}" filepath="proMidForm"  readonly="true"></sys:frontFileUpload>
									</div>
								</section>



								<section class="row">
									<div class="prj_common_info" style="height: 40px;line-height: 40px;">
										<h4 class="sub-file" style="margin-top: 25px;">导师意见及建议</h4><span class="yw-line yw-line-fj"></span>
										<span href="javascript:;" class="upload-file" style="background: none;color:#656565 !important;">
											<strong>
												时间：
												<c:choose>
													<c:when test="${not empty proMid.tutorSuggestDate}">
														<fmt:formatDate value="${proMid.tutorSuggestDate}" pattern="yyyy-MM-dd"/>
													</c:when>
													<c:otherwise>${fns:getDate('yyyy-MM-dd')}</c:otherwise>
												</c:choose>
											</strong>
										</span>
									</div>
									<textarea  maxlength="2000" name="tutorSuggest" class="col-xs-12 col-md-12 col-sm-12 col-lg-12 my-textarea"  required >${proMid.tutorSuggest}</textarea>
								</section>

								<div class="footer-btn-wrap">
									<a href="javascript:;" class="btn btn-sm btn-primary" onclick="submit()" id="submitBtn">提交</a>
								</div>
							</div>
			</div>
		</div>
	</form>
	<script src="/js/gcProject/fileUpLoad.js"></script>
</body>
</html>