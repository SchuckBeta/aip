<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="/common/common-css/common.css"/>
	<link rel="stylesheet" type="text/css" href="/common/common-css/header.css"/>
	<link rel="stylesheet" type="text/css" href="/css/gctontestChange.css"/>
	<link rel="stylesheet" type="text/css" href="/css/checkform.css" >
	<meta name="decorator" content="default"/>
	<title></title>

	<style>
		.content .tg .m-valid{
			border: 1px solid #cbcbcb;
			text-indent: 5px;
			border-radius: 3px;
			width: 55px;;
		}
		.content .tg .m-table-two th{
			background-color: #f4e6d4;
		}
		.content .tg .m-table-hui, .content .tg .m-table-thhui th{
			background-color: #eee;
			font-family: 'Microsoft yahei';
			color: #636363;
			font-size: 14px;
			font-weight: bold;
		}
	</style>
</head>
<body>

	<form:form id="competitionfm" modelAttribute="gContest" action="/f/gcontest/gContest/save" method="post" enctype="multipart/form-data">
		<div class="wholebox" id="wholebox">

			<p class="title">大赛变更表</p>
			<div class="content">

				<ul class="personalinfor">
					<li>
						<label style="width:182px"><span>*</span>申报人：</label>

						<input type="text" name="shenbaoren" readonly="readonly" value="${sse.name}" >
						<input type="hidden" name="declareId" value="${gContest.declareId}" />
					</li>
					<li>
						<label><span>*</span>学院：</label>
						<input path="" type="text" name="company" readonly="readonly"id="company" value="${sse.company.name}"/>
					</li>
					<li>
						<label style="width:182px"><span>*</span>学号（或者毕业年份）：</label>
						<input type="text" name="xuehao" id="zhuanye" readonly="readonly" value="${sse.no}" />
						<input type="text" name="nianfen" id="nianfen" readonly="readonly" value="${sse.graduation}"/>
						<small>年</small>
					</li>
					<li>
						<label><span>*</span>专业年级：</label>
						<input type="text"  readonly="readonly" value="${fns:getProfessional(sse.professional)}"/>
					</li>
					<li>
						<label style="width:182px"><span>*</span>联系电话：</label>
						<input type="text" name="mobile" id="mobile" value="${sse.mobile}" readonly="readonly"/>
					</li>
					<li>
						<label><span>*</span>E-mail：</label>
						<input type="text" name="email" id="email" value="${sse.email}" readonly="readonly"/>
					</li>
				</ul>

				<div class="iteminfor">

					<div class="biaoti">
						<span>大赛基本信息</span>
					</div>
					<c:if test="${relationProject!=null}">
					<p id="myradiobox">
						<label class="linehead">
							<span>*</span>关联项目：
						</label>
							<input type="text" name="relationProject"  value="${relationProject}" readonly="readonly" />
					</p>
					</c:if>
						<!-- <input id="one" name="guochuang" type="radio"  value="1"  disabled="true"  />
						<label class="linehead" for="one">无关联</label>
						<input id="two" name="guochuang" type="radio"  value="2"  disabled="true"  />
						<label class="linehead" for="two">国创项目</label> -->
					<p>
						<label class="linehead">
							<span>*</span>参赛项目名称：
						</label>
						<input type="text" name="pName"  value="${gContest.pName}" readonly="readonly" />
					</p>

					<div class="selecbox">
						<div class="label-wrap" style="width:440px;">
							<label class="linehead">
								<span>*</span>项目类型：
							</label><form:select path="type" class="input-xlarge">
								<form:option value="" label="请选择"/>
								<form:options items="${fns:getDictList('competition_net_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
						<div class="label-wrap">
							<label class="linehead">
								<span>*</span>参赛组别：
							</label><form:select path="level" class="input-xlarge">
								<form:option value="" label="请选择"/>
								<form:options items="${fns:getDictList('gcontest_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
						<div class="label-wrap">
							<label class="linehead">
								<span>*</span>融资情况：
							</label><form:select path="financingStat" class="input-xlarge">
								<form:option value="" label="请选择"/>
								<form:options items="${fns:getDictList('financing_stat')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>

						<%--<select name="rongziqingkuang">
						  <option value="">-请选择-</option>
						  <option value="1">3</option>
						  <option value="2">4</option>
						  <option value="3">5</option>
						</select>--%>
					</div>
				</div>

				<div class="teaminfor">

					<div class="biaoti">
						<span class="char4">团队信息</span>
					</div>

					<p>
						<label><span>*</span>团队信息：</label>
						<form:select  required="required" onchange="DSSB.findTeamPerson();"  path="teamId" class="input-medium"><form:option value="" label="--请选择--"/>
						<form:options items="${teams}" itemValue="id" itemLabel="name" htmlEscape="false"/>
						</form:select>
					</p>

					<p class="studentteam">
						<span>学生团队</span>
					</p>
					<table class="studenttb">
						<thead>
							<tr>
								<th width="50px">序号</th>
								<th width="70px">姓名</th>
								<th width="110px">学号</th>
								<th width="150px">学院</th>
								<th width="140px">专业</th>
								<th>技术领域</th>
								<th width="105px">联系电话</th>
								<th width="90px">在读学位</th>
							</tr>
						</thead>
						<tbody>
						<c:if test="${gContestVo.teamStudent!=null&&gContestVo.teamStudent.size() > 0}">
							<c:forEach items="${gContestVo.teamStudent}" var="item" varStatus="status">
							<tr>
								<td>${status.index+1}</td>
								<td><c:out value="${item.name}" /></td>
								<td><c:out value="${item.no}" /></td>
								<td><c:out value="${item.org_name}" /></td>
								<td><c:out value="${item.professional}" /></td>
								<td><c:out value="${item.domain}" /></td>
								<td><c:out value="${item.mobile}" /></td>
								<td><c:out value="${item.instudy}" /></td>
							<tr>
							</c:forEach>
						</c:if>
						</tbody>
					</table>
					<p class="guideteacher">
						<span>指导教师</span>
					</p>
					<table class="teachertb">
						<thead>
							<tr>
								<th width="50px">序号</th>
								<th width="70px">姓名</th>
								<th >单位（学院或企业、机构）</th>
								<th width="150px">职称（职务）</th>
								<th width="140px">技术领域</th>
								<th width="110px">联系电话</th>
								<th width="170px">E-mail</th>
							</tr>
						</thead>
						<tbody>
						<c:if test="${gContestVo.teamTeacher!=null&&gContestVo.teamTeacher.size() > 0}">
							<c:forEach items="${gContestVo.teamTeacher}" var="item" varStatus="status">
							<tr>
								<td>${status.index+1}</td>
								<td><c:out value="${item.name}" /></td>
								<td><c:out value="${item.org_name}" /></td>
								<td><c:out value="${item.technical_title}" /></td>
								<td><c:out value="${item.domain}" /></td>
								<td><c:out value="${item.mobile}" /></td>
								<td><c:out value="${item.email}" /></td>
							</tr>
							</c:forEach>
						</c:if>
						</tbody>
					</table>

				</div>

				<div class="itemintro">
					<div class="biaoti">
						<span class="char4">项目介绍</span>
					</div>
					<p>
						<label><span>*</span>项目介绍：</label>
					</p>

					<textarea class="introarea" name="introduction"  readonly="readonly" >${gContest.introduction}</textarea>
				</div>


				<div class="other" id="fujian">
					<div class="biaoti" >
						<span class="char2" style="width:40px;">附件</span>
					</div>
					<c:forEach items="${sysAttachments}" var="sysAttachment">
						<p><a  href="javascript:void(0)"  onclick="downfile('${sysAttachment.url}','${sysAttachment.name}');return false">
						${sysAttachment.name}</a>
						</p><br>

					</c:forEach>
					<!-- <p>123456.txt</p>
					<p>项目明细对应表.txt</p> -->

				</div>

				<%--新添加表格--%>
				<div class="itemintro">
					<div class="biaoti">
						<span class="char4">审核记录</span>
					</div>
				</div>
				<div class="other">
					<table class="tg" style="width: 100%;"  cellpadding="0" cellspacing="0" style="border: 1px solid #ccc;">
						<tr>
							<th colspan="2">评分</th>
							<th>排名</th>
							<th colspan="2">建议及意见</th>
						</tr>
						<tr class="m-table-thhui">
							<th colspan="2">学院评分</th>
							<th>学院排名</th>
							<th colspan="2">学院建议及意见</th>
						</tr>
						<c:if test="${fn:length(infocolleges)>0}">
							<c:forEach items="${infocolleges}" var="info" varStatus="state">
							<tr>
								<c:if test="${state.count eq 1}">
									<td rowspan="${fn:length(infocolleges)}" class="m-table-hui" style="width: 70px;">专家评分</td>
								</c:if>
								<td style="padding: 0px;" style="width: 100px;">
									<table class="tg" style="width: 100%;" cellpadding="0" cellspacing="0" style="border: 1px solid #ccc;">
										<tr>
											<td>${fns:getUserById(info.createBy.id).name}</td>
											<td><input type="text" class="m-valid"value="${info.score}"></td>
										</tr>
									</table>
								</td>
								<c:if test="${state.count eq 1}">
									<td rowspan="${fn:length(infocolleges)+2}">第${collegeSecinfo.sort}名</td>
								</c:if>
								<td colspan="2">${info.suggest}</td>
							</tr>
							</c:forEach>
						</c:if>

						<tr>
							<td class="m-table-hui">得分</td>
							<td>
								<c:choose>
									<c:when test="${collegeSecinfo!=null}">
										<input type="text" class="m-valid"value="${collegeSecinfo.score}">
									</c:when>
									<c:otherwise>
										<input type="text" class="m-valid"value="">
									</c:otherwise>
								</c:choose>
							</td>
							<td colspan="2">
								<c:choose>
									<c:when test="${collegeSecinfo!=null}">
										<input type="text" class="m-valid"value="${collegeSecinfo.suggest}">
									</c:when>
									<c:otherwise>
										<input style="width:90%;" type="text" class="m-valid"value="">
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<td class="m-table-hui">审核结果</td>
							<td>
								<select class="input-xlarge"  disabled="true"  >
									<c:choose>
										<c:when test="${collegeSecinfo!=null}">
											<c:if test="${collegeSecinfo.grade ==1}">
												<option value="0" >不合格</option>
			                            		<option value="1" selected="selected">合格</option>
											</c:if>
										    <c:if test="${collegeSecinfo.grade ==0}">
												<option value="0" selected="selected">不合格</option>
			                            		<option value="1">合格</option>
											</c:if>
										</c:when>
										<c:otherwise>   
										 	<option value="0" selected="selected">不合格</option>
			                            	<option value="1">合格</option>
										</c:otherwise>
									</c:choose>
								</select>
							</td>
							<td colspan="2"></td>
						</tr>
						<%--第一部分 结束--%>
						<tr class="m-table-thhui">
							<th colspan="2">学院评分</th>
							<th>学院排名</th>
							<th colspan="2">学院建议及意见</th>
						</tr>
						<tr>
							<td rowspan="3" class="m-table-hui" style="width: 70px;">专家评分</td>
							<td style="padding: 0px;" style="width: 100px;">
								<table class="tg" style="width: 100%;"  cellpadding="0" cellspacing="0" style="border: 1px solid #ccc;">
									<tr>
										<td>某某某(角色)</td>
										<td><input type="text" class="m-valid"></td>
									</tr>
								</table>
							</td>
							<td rowspan="5">第一名</td>
							<td colspan="2">aaa</td>
						</tr>
						<tr>
							<td style="padding: 0px;">
								<table class="tg" style="width: 100%;"  cellpadding="0" cellspacing="0" style="border: 1px solid #ccc;">
									<tr>
										<td>某某某(角色)</td>
										<td><input type="text" class="m-valid"></td>
									</tr>
								</table>
							</td>
							<td colspan="2">aaa</td>
						</tr>
						<tr>
							<td style="padding: 0px;">
								<table class="tg" style="border: 1px solid #ccc; width:100%">
									<tr>
										<td>某某某(角色)</td>
										<td><input type="text" class="m-valid"></td>
									</tr>
								</table>
							</td>
							<td colspan="2">aaa</td>
						</tr>
						<tr>
							<td class="m-table-hui">路演得分</td>
							<td><input type="text" class="m-valid"></td>
							<td colspan="2">aaa</td>
						</tr>
						<tr>
							<td class="m-table-hui">得分</td>
							<td>123</td>
							<td colspan="2">aaa</td>
						</tr>
						<%--第二部分 结束--%>
						<tr class="m-table-thhui">
							<th colspan="2">校赛结果</th>
							<th>荣获奖励</th>
							<th colspan="2">建议及意见</th>
						</tr>
						<tr>
							<td colspan="2">
								<select path="level" class="input-xlarge"  disabled="true"  >
									<option>合格</option>
									<option>不合格</option>
									<option>一等奖</option>
									<option>二等奖</option>
									<option>三等奖</option>
								</select>
							</td>
							<td>88</td>
							<td colspan="2">建议建议123</td>
						</tr>
						<%--第三部分 结束--%>
						<tr class="m-table-thhui">
							<th colspan="2">省赛评分</th>
							<th>省赛排名</th>
							<th>省赛结果</th>
							<th>荣获奖励</th>
						</tr>
						<tr>
							<td class="m-table-hui">第一轮得分</td>
							<td><input type="text" class="m-valid"></td>
							<td>第一名</td>
							<td>一等奖</td>
							<td>5000</td>
						</tr>
						<tr>
							<td class="m-table-hui">第二轮得分</td>
							<td><input type="text" class="m-valid"></td>
							<td>第一名</td>
							<td>一等奖</td>
							<td>5000</td>
						</tr>
						<tr>
							<td class="m-table-hui">第三轮得分</td>
							<td><input type="text" class="m-valid"></td>
							<td>第一名</td>
							<td>一等奖</td>
							<td>5000</td>
						</tr>
						<%--第四部分 结束--%>
						<tr class="m-table-thhui">
							<th colspan="2">国赛评分</th>
							<th>国赛排名</th>
							<th>国赛结果</th>
							<th>荣获奖励</th>
						</tr>
						<tr>
							<td class="m-table-hui">第一轮得分</td>
							<td><input type="text" class="m-valid"></td>
							<td>第一名</td>
							<td>一等奖</td>
							<td>5000</td>
						</tr>
						<tr>
							<td class="m-table-hui">第二轮得分</td>
							<td><input type="text" class="m-valid"></td>
							<td>第一名</td>
							<td>一等奖</td>
							<td>5000</td>
						</tr>
						<tr>
							<td class="m-table-hui">第三轮得分</td>
							<td><input type="text" class="m-valid"></td>
							<td>第一名</td>
							<td>一等奖</td>
							<td>5000</td>
						</tr>
					</table>
				<div class="btngroup">
					<a onClick="history.back(-1)">返回</a>
				</div>

			</div>

		</div>
	</form:form>

<script src="/common/common-js/jquery.validate.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/common/common-js/messages_zh.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/js/DSSB.js" type="text/javascript" charset="utf-8"></script>
<script src="/js/DSSBvalidate.js" type="text/javascript" charset="utf-8"></script>
<script src="/js/fileUpLoad.js" type="text/javascript" charset="utf-8"></script>
</body>
</html>