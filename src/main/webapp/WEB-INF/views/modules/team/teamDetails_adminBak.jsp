<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>管理门户-查看团队信息</title>
    <link rel="stylesheet" type="text/css" href="/common/common-css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="/css/team.css">
    <style>
        .user-info-form .ud-title {
            margin-top: -6px;
            margin-bottom: 8px;
        }

        .ud-title {
            position: relative;
            padding-left: 8px;
            margin-bottom: 20px;
            line-height: 2;
            font-size: 16px;
            color: #000;
            border-bottom: 1px solid rgb(243, 213, 175);
        }

        .ud-title:after {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            height: 16px;
            margin-top: -8px;
            width: 2px;
            background-color: #fa5a45;
        }

        .info-cards {
            padding: 0 15px;
        }

        .info-card {
            position: relative;
            padding-top: 20px;
            padding-left: 52px;
            margin-bottom: 30px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .info-card-title {
            position: absolute;
            left: 40px;
            top: -10px;
            height: 20px;
            padding: 0 20px;
            margin: 0;
            color: #333;
            background-color: #fff;
        }

        .card-item-span {
            display: block;
            float: left;
            width: 100px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            line-height: 1.5;
        }

        .card-item-box {
            float: left;
            margin-bottom: 0;
            line-height: 1.5;
        }

        .info-card-table {
            margin-bottom: 0;
        }

        .info-card-table > tr > td {
            text-align: left;
        }

        .ic-box {
            margin-bottom: 15px;
            overflow: hidden;
        }

        .info-match .user-label-control {
            width: 100px;
        }

        .info-match .user-val {
            margin-left: 100px;
        }
        .user-label-control {
            float: left;
            width: 72px;
            line-height: 2;
            margin-bottom: 0;
            text-align: right;
            color: #666;
        }
        .user-val {
            margin-left: 72px;
            line-height: 2;
        }

        .table-nowrap > thead > tr > th {
            white-space: nowrap;
        }

        .table-project .pro-info {
            width: 350px;

        }
        .table-project .pro-info > h5{
            margin-top: 0;
            line-height: 20px;
        }
        .table-project .pro-info > h5 > a {
            display: inline-block;
            max-width: 290px;
            color: #222c38;
            letter-spacing: 0;
            font-weight: bold;
            text-decoration: none;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            vertical-align: middle;
        }

        .table-project .pro-info > p {
            margin-bottom: 0;
            height: 60px;
            overflow: hidden;
        }

        .teacher-leaders > a {
            display: block;
            color: #333;
            text-decoration: none;
        }

        .teacher-leaders > a:hover {
            color: #e9442d;
        }

        .table-center > tbody > tr > td {
            text-align: center;
        }

        .table-center > thead > tr > th {
            text-align: center;
        }

        .table-center > tbody > tr > td:first-child {
            text-align: left;
        }

        .students-member {
            display: inline-block;
            vertical-align: middle;
        }

        .students-member > p {
            margin-bottom: 0;
        }

        .students-member a {
            display: inline-block;
            width: 160px;
            color: #333;
            white-space: nowrap;
            text-overflow: ellipsis;
            overflow: hidden;
            text-decoration: none;
            text-align: center;
        }
        .students-member a+a{
            margin-left: 10px;
        }

        .students-member a:hover {
            color: #e9442d;
        }

        .table-middle > tbody > tr > td {
            vertical-align: middle;
        }

        .table-project > thead > tr > th {
            border-bottom: 1px solid #ddd;
        }

        .table-project > tbody > tr > td {
            border-bottom: 1px solid #ddd;
        }

        .table-project .project-status{
            display: inline-block;
            padding: 0 6px;
            margin-left: 4px;
            border-radius: 3px;
            color: #fff;
            background-color: #e9442d;
            vertical-align: middle;
        }
        .table-project .project-status.completed{
            color: #333;
            background-color: #f4e6d4;
        }

    </style>
</head>
<body>
<div class="container-fluid">
    <div class="edit-bar clearfix">
        <div class="edit-bar-left">
            <span>团队建设</span>
            <i class="line"></i>
        </div>
    </div>
    <div class="team-info" role="main">
        <h4 class="title team-title">查看团队信息</h4>
        <div class="wrap">
            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>团队信息</span>
                    <i class="line"></i>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="team-info-group">
                        <label class="ti-label"><i class="icon-require">*</i>团队名称：</label>
                        <div class="ti-box">
                            <p>${teamDetails.name }</p>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6" style="display:none">
                    <div class="team-info-group">
                        <label class="ti-label"><i class="icon-require">*</i>团队有效期：</label>
                        <div class="ti-box">
                            <p><c:if test="${team.validDateStart!=null && team.validDateEnd!=null }">
                                <fmt:formatDate value="${teamDetails.validDateStart }" pattern="yyyy-MM-dd"/>&nbsp;至&nbsp;
                                <fmt:formatDate value="${teamDetails.validDateEnd }" pattern="yyyy-MM-dd"/>
                            </c:if></p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="team-info-group">
                        <label class="ti-label"><i class="icon-require">*</i>所属学院：</label>
                        <div class="ti-box">
                            <p>${teamDetails.localCollege }</p>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="team-info-group">
                        <label class="ti-label"><i class="icon-require">*</i>团队负责人：</label>
                        <div class="ti-box">
                            <p>${teamDetails.sponsor }</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <div class="team-info-group">
                        <label class="ti-label"><i class="icon-require">*</i>团队介绍：</label>
                        <div class="ti-box">
                            <p>${teamDetails.summary }</p>
                        </div>
                    </div>
                </div>
                <div class="col-sm-12" style="display:none">
                    <div class="team-info-group">
                        <label class="ti-label"><i class="icon-require">*</i>项目介绍：</label>
                        <div class="ti-box">
                            <p>${teamDetails.projectIntroduction }</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>团队成员要求</span>
                    <i class="line"></i>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-4">
                    <div class="team-info-group">
                        <label class="ti-label"><i class="icon-require">*</i>项目组人数：</label>
                        <div class="ti-box">
                            <p>${teamDetails.memberNum }人</p>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="team-info-group">
                        <label class="ti-label"><i class="icon-require">*</i>校内导师：</label>
                        <div class="ti-box">
                            <p>${teamDetails.schoolTeacherNum }人</p>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="team-info-group">
                        <label class="ti-label"><i class="icon-require">*</i>企业导师：</label>
                        <div class="ti-box">
                            <p>${teamDetails.enterpriseTeacherNum }人</p>
                        </div>
                    </div>
                </div>
                <div class="col-sm-12">
                    <div class="team-info-group">
                        <label class="ti-label"><i class="icon-require">*</i>组员要求：</label>
                        <div class="ti-box">
                            <p>${teamDetails.membership }</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>团队组建情况</span>
                    <i class="line"></i>
                </div>
            </div>
            <div class="team-table-title">
				<span class="team-status">
					<c:if test="${teamDetails.memberNum-teamInfo.size()==0 }">已组建完成</c:if>
					<c:if test="${teamDetails.memberNum-teamInfo.size()!=0 }">(已加入${teamInfo.size()}人)</c:if>
				</span>
                <span class="team-name">学生团队</span>
            </div>
            <table class="table table-bordered table-team-type">
                <thead>
                <tr>
                    <th>序号</th>
                    <th>姓名</th>
                    <th>学院</th>
                    <th>专业</th>
                    <th>现状</th>
                    <th>当前在研</th>
                    <th>技术领域</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${teamInfo }" var="info" varStatus="status">
                    <tr>
                        <td>${status.index+1 }</td>
                        <td>${info.uName }</td>
                        <td>${info.officeId }</td>
                        <td>${fns:getOffice(info.professional).name}</td>
                        <td>${fns:getDictLabel(info.currState, 'current_sate', '')}</td>
                        <td>${info.curJoin }</td>
                        <td>${info.domainlt }</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div class="team-table-title">
				<span class="team-status">
					<c:if test="${teamDetails.schoolTeacherNum+teamDetails.enterpriseTeacherNum-teamTeacherInfo.size()==0}">已组建完成</c:if>
	  								<c:if test="${teamDetails.schoolTeacherNum+teamDetails.enterpriseTeacherNum-teamTeacherInfo.size()!=0}">(已加入${teamTeacherInfo.size()}人)</c:if>
				</span>
                <span class="team-name">指导教师</span>
            </div>
            <table class="table table-bordered table-team-type">
                <thead>
                <tr>
                    <th>序号</th>
                    <th>姓名</th>
                    <th>单位(学院或企业、机构)</th>
                    <th>导师来源</th>
                    <th>当前指导</th>
                    <th>技术领域</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${teamTeacherInfo }" var="tInfo" varStatus="sta">
                    <tr>
                        <td>${sta.index+1 }</td>
                        <td>${tInfo.uName }</td>
                        <td>${tInfo.officeId }</td>
                        <td>${fns:getDictLabel(tInfo.teacherType, 'master_type', '')}</td>
                        <td>${tInfo.curJoin }</td>
                        <td>${tInfo.domainlt }</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>项目经历</span>
                    <i class="line"></i>
                </div>
            </div>
            <div class="pro-container">
                <table class="table table-project table-nowrap table-center table-middle ">
                    <thead>
                    <tr style="background-color: #f4e6d4">
                        <th>项目</th>
                        <th>指导老师</th>
                        <th>成员/(学号)</th>
                        <th>负责人</th>
                        <th>级别</th>
                        <th>结果</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${projectExpVo}" var="projectExp">
                    <tr>
                        <td>
                            <div class="pro-info">
                                <h5><a href="#">${projectExp.proName}</a>
                                    <c:choose>
                                    <c:when test="${projectExp.finish=='1'}">
                                        <span class="project-status">完成</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="project-status">进行中</span>
                                    </c:otherwise>
                                    </c:choose>
                                </h5>
                                <h5>项目名称：${projectExp.name } </h5>
                                <p>项目周期：<fmt:formatDate value="${projectExp.startDate }" pattern="yyyy-MM-dd"/>
                                -
                                <fmt:formatDate value="${projectExp.endDate }" pattern="yyyy-MM-dd"/></p>
                            </div>
                        </td>
                        <td>
                            <div class="teacher-leaders">
                                <c:forEach items="${projectExp.userList}" var="user" varStatus="sta">
                                <c:if test="${user.userType == '2'}">
                                <a href="#">${user.name}</a>
                                </c:if>
                                </c:forEach>
                            </div>
                        </td>
                        <td>
                            <div class="students-member">
                                <c:forEach items="${projectExp.userList}" var="user" varStatus="sta">
                                    <c:if test="${user.userType == '1'}">
                                    <p><a href="#">${user.name}（${user.no}）</a></p>
                                    </c:if>
                                </c:forEach>

                                <%--<p> <a href="#">王清腾（56465465）</a><a href="#">王清腾（56465465）</a></p>--%>
                            </div>
                        </td>
                        <td>
                            ${fns:getUserById(projectExp.leaderId).name }
                        </td>
                        <td>
                            ${projectExp.level }
                        </td>
                        <td>
                             ${projectExp.result }
                        </td>
                    </tr>
                    </c:forEach>
                    </tbody>

                </table>
            </div>

            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>大赛经历</span>
                    <i class="line"></i>
                </div>
            </div>
            <div class="pro-container">
                <table class="table table-project table-nowrap table-center table-middle ">
                    <thead>
                    <tr style="background-color: #f4e6d4">
                        <th>大赛</th>
                        <th>指导老师</th>
                        <th>成员/(学号)</th>
                        <th>负责人</th>
                        <th>级别</th>
                        <th>结果</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${gContestExpVo}" var="gContest">
                    <tr>
                        <td>
                            <div class="pro-info">
                                <h5><a href="#">${fns:getDictLabel(gContest.type, 'competition_type', '')}</a>
                                    <c:choose>
                                    <c:when test="${gContest.finish=='1'}">
                                        <span class="project-status">完成</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="project-status">进行中</span>
                                    </c:otherwise>
                                    </c:choose>
                                </h5>
                                <h5>大赛名称：${gContest.pName } </h5>
                                <p>大赛参赛时间：<fmt:formatDate value="${gContest.createDate }" pattern="yyyy-MM-dd"/></p>
                            </div>
                        </td>
                        <td>
                            <div class="teacher-leaders">
                                <c:forEach items="${gContest.userList}" var="user" varStatus="sta">
                                <c:if test="${user.userType == '2'}">
                                <a href="#">${user.name}</a>
                                </c:if>
                                </c:forEach>
                            </div>
                        </td>
                        <td>
                            <div class="students-member">
                                <c:forEach items="${gContest.userList}" var="user" varStatus="sta">
                                    <c:if test="${user.userType == '1'}">
                                    <p><a href="#">${user.name}（${user.no}）</a></p>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </td>
                        <td>
                            ${fns:getUserById(gContest.leaderId).name }
                        </td>
                        <td>
                             ${fns:getDictLabel(gContest.level, 'competition_net_type', '')}
                        </td>
                        <td>
                            ${fns:getDictLabel(gContest.award, 'competition_college_prise', '')}
                        </td>
                    </tr>
                    </c:forEach>
                    </tbody>

                </table>
            </div>

         </div>


        <div class="back-box">
            <button type="button" class="btn btn-back-w" onclick="history.go(-1)">返回</button>
        </div>
    </div>
</div>
</body>
</html>