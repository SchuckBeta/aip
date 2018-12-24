<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>学院专家大赛评分</title>
    <meta name="decorator" content="default"/>
    <link rel="stylesheet" href="/common/common-css/header.css">
    <link rel="stylesheet" href="/common/common-css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/Expertscoring.css">
    <style type="text/css">
        .mybreadcrumbs {
            margin: 20px 1.5em;
            margin-left: 27px;
            border-bottom: 3px solid #f3d5af;
            padding-bottom: 10px;
        }

        .mybreadcrumbs span {
            position: relative;
            top: 0px;
            font-size: 16px;
            font-weight: bold;
            color: #e9432d;
            display: inline-block;
            background-color: #FFF;
            padding-right: 10px;
            padding-bottom: 10px;
        }

        form {
            margin: 0 20px !important;
            margin-top: 20px !important;
        }

        .info-panel {
            padding: 0 50px;
        }

        .info-panel .panel-body {
            padding: 5px 0 0 0;
        }

        .info-panel p {
            margin-bottom: 20px;
        }

        .info-panel strong {
            width: 122px;
            white-space: nowrap;
            display: inline-block;
            text-align: left;
            font-weight: normal;
        }

        .info-panel .w130 strong {
            width: 130px;
        }

        .info-panel .w142 strong {
            width: 122px;
        }

        .info-panel h2, .info-panel h3 {
            margin-left: 13px;
            margin-right: 13px;
            position: relative;
        }

        .info-panel h2 {
            border-bottom: 4px solid #e9442d;
            padding-bottom: 5px;
            color: #e9442d;
            font-size: 19px;
            font-weight: bold;
            display: none;
        }

        .info-panel h3 {
            font-size: 15px;
            border-bottom: 1px solid #f3d5af;
            margin-bottom: 30px;
        }

        .info-panel h3 span {
            display: inline-block;
            font-weight: bold;
            height: 100%;
            padding-right: 10px;
            background-color: #FFF;
            position: relative;
            top: 8px;
        }

        .info-panel h3.char4:after {
            left: 85px;
        }

        .info-panel h3.char2:after {
            left: 45px;
        }

        .info-panel .panel-toggle {
            float: right;
            position: relative;
            top: 0px;
            color: #e9442d;
            font-weight: bolder;
        }

        .info-panel .input-item {
            margin: 0 15px;
        }

        .info-panel .input-item label {
            font-weight: normal;
            width: 88px;
            vertical-align: top;
        }

        .info-panel .input-item select,
        .info-panel .input-item input[type="text"],
        .info-panel .input-item input[type="number"] {
            width: 140px;
        }

        .info-panel .input-item input[type="number"] {
            height: 34px;
        }

        .info-panel .doc a {
            text-decoration: underline;
            margin-left: 5px;
        }

        .info-panel .table-caption {
            display: inline-block;
            border-radius: 4px 4px 0 0;
            background-color: #ebebeb;
            padding: .5em 1em;
        }

        .info-panel .table-bordered {
            border-collapse: collapse;
        }

        .info-panel .table-bordered th {
            background: #f4e6d4 none;
        }

        .info-panel .table th, .info-panel .table td {
            text-align: center;
            vertical-align: middle;
            white-space: normal;
            word-break: break-all;
        }

        .table-caption + .table-bordered {
            border-top-left-radius: 0;
        }

        .table-caption + .table-bordered thead:first-child tr:first-child > th:first-child {
            border-top-left-radius: 0;
        }

        .btn + .btn {
            margin-left: 30px;
        }

        /* 覆盖bs3样式 */
        .btn-default {
            background-color: #e9432d !important;
            border-color: #e9432d !important;
            color: #FFF !important;
        }
    </style>
    <script src="/common/common-js/jquery.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="/js/Expertscoring.js"></script>
    <script src="/js/fileUpLoad.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
        $(function () {
            $('.info-panel .panel-toggle').click(function () {
                var self = $(this), icon;
                self.closest('.info-panel').children('.panel-body').stop().slideToggle(200);
                icon = self.children('i');
                if (icon.hasClass("icon-double-angle-down")) {
                    icon.removeClass("icon-double-angle-down").addClass("icon-double-angle-up");
                } else {
                    icon.removeClass("icon-double-angle-up").addClass("icon-double-angle-down");
                }
            });
            $('input[type="number"]').keydown(function (e) {
                var code = e.keyCode;
                // backspace or delete or left or right
                if (code === 8 || code === 46 || code === 37 || code === 39) {
                    return;
                }
                if ((code >= 48 && code <= 57) || (code >= 96 && code <= 105)) {
                    // 输入的是数字
                    return;
                }
                e.preventDefault();
                e.stopPropagation();
                return false;
            });
            // 根据附件的名字自动修改其图标
            $('.file-item').each(function () {
                var el = $(this);
                var name = $.trim(el.children('a').text());
                var extname = name.split('.').pop().toLowerCase();
                switch (extname) {
                    case "xls":
                    case "xlsx":
                        extname = "excel";
                        break;
                    case "doc":
                    case "docx":
                        extname = "word";
                        break;
                    case "ppt":
                    case "pptx":
                        extname = "ppt";
                        break;
                        // 我不太确定这个文件格式
//                    case "project":
                    case "jpg":
                    case "jpeg":
                    case "gif":
                    case "png":
                    case "bmp":
                        extname = "image";
                        break;
                    case "rar":
                    case "zip":
                    case "txt":
                    case "project":
                        // just break
                        break;
                    default:
                        extname = "unknow";
                }
                el.children('img').attr('src', "/img/filetype/" + extname + ".png");
            });
        });
        var init = function () {
            toggle.show();
            toggle.hide();
        }();

    </script>
</head>
<body>
<div class="container-fluid">
    <div class="mybreadcrumbs"><span>
        <c:if test="${state=='1'}">
            待学院专家评分
        </c:if>
        <c:if test="${state=='2'}">
            待学院秘书审核
        </c:if>
        <c:if test="${state=='3'}">
            待学院专家评分
        </c:if>
        <c:if test="${state=='4'}">
            待学院管理员审核
        </c:if>
         <c:if test="${state=='5'}">
             待学院管理员路演
         </c:if>
        <c:if test="${state=='6'}">
            待学院管理员评级
        </c:if>
        <c:if test="${state=='7'}">
            学院管理员评级
        </c:if>
        <c:if test="${state=='8'}">
            学院审核未通过
        </c:if>
        <c:if test="${state=='9'}">
            学院审核未通过
        </c:if>
        </span>
    </div>


    <!--  <form action="Expertscoring_submit" > -->

    <form:form id="inputForm" modelAttribute="gContest" action="${ctx}/gcontest/gContest/saveAuditWangping"
               method="post" class="form-horizontal">
        <form:hidden path="id"/>
        <form:hidden path="procInsId"/>
        <form:hidden path="auditState"/>
        <div class="row info-panel">

            <div class="panel-body">
                <div class="col-md-6 col-lg-6 col-sm-6 w142">
                    <p><strong>大赛编号：</strong>${gContest.competitionNumber}</p>
                    <p><strong>申报人：</strong>${sse.name}</p>
                    <p><strong>学号(毕业年份)：</strong>${sse.no}</p>
                    <p><strong>联系电话：</strong>${sse.mobile}</p>
                </div>
                <div class="col-md-6 col-lg-6 col-sm-6">
                    <p><strong>填表日期：</strong><fmt:formatDate value="${gContest.subTime}" pattern="yyyy-MM-dd"/></p>
                    <p><strong>学院：</strong>
                        <c:if test="${sse.office!=null}">
                            ${sse.office.name}
                        </c:if>
                    </p>
                    <p><strong>专业年级：</strong> ${fns:getProfessional(sse.professional)}</p>
                    <p><strong>E-mail：</strong>${sse.email}</p>
                </div>
            </div>
        </div>
        <div class="row info-panel">
            <h3><a href="javascript:;" class="panel-toggle"><i class="icon-double-angle-up"
                                                               aria-hidden="true"></i></a><span>项目基本信息</span></h3>
            <div class="panel-body">
                <div class="col-md-4 col-lg-4">
                    <p><strong>参赛项目名称：</strong>${gContest.pName}</p>
                </div>
                <div class="col-md-4 col-lg-4">
                   <c:if test='${gContest.pId!=null && gContest.pId!=""}'>
                       <p class="pf-item"><strong>关联项目：</strong>${relationProject}</p>
                   </c:if>
                </div>
            </div>
        </div>
        <div class="row info-panel">
            <h3 class="char4"><a href="javascript:;" class="panel-toggle"><i class="icon-double-angle-up"
                                                                             aria-hidden="true"></i></a><span>团队信息</span>
            </h3>
            <div class="panel-body">
                <div class="col-md-12 col-lg-12">
                    <p><strong>项目团队：</strong>${team.name}</p>
                </div>
                <div class="col-md-12 col-lg-12">
                    <div class="table-caption">学生团队</div>
                    <table class="table table-bordered">
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
                        <c:if test="${turStudents!=null&&turStudents.size() > 0}">
                        <c:forEach items="${turStudents}" var="item" varStatus="status">
                            <tr>
                                <td>${status.index+1}</td>
                                <td><c:out value="${item.name}"/></td>
                                <td><c:out value="${item.no}"/></td>
                                <td><c:out value="${item.org_name}"/></td>
                                <td><c:out value="${item.professional}"/></td>
                                <td>${item.domain}</td>
                                <td><c:out value="${item.mobile}"/></td>
                                <td><c:out value="${item.instudy}"/></td>
                            <tr>
                        </c:forEach>
                        </c:if>
                        </tbody>
                    </table>
                    <div class="table-caption">指导老师</div>
                    <table class="table table-bordered">
                        <thead>
                        <tr>
                            <th width="50px">序号</th>
                            <th width="70px">姓名</th>
                            <th>单位（学院或企业、机构）</th>
                            <th width="150px">职称（职务）</th>
                            <th width="140px">技术领域</th>
                            <th width="110px">联系电话</th>
                            <th width="170px">E-mail</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${turTeachers!=null&&turTeachers.size() > 0}">
                            <c:forEach items="${turTeachers}" var="item" varStatus="status">
                                <tr>
                                    <td>${status.index+1}</td>
                                    <td><c:out value="${item.name}"/></td>
                                    <td><c:out value="${item.org_name}"/></td>
                                    <td><c:out value="${item.technical_title}"/></td>
                                    <td>${item.domain}</td>
                                    <td><c:out value="${item.mobile}"/></td>
                                    <td><c:out value="${item.email}"/></td>
                                </tr>
                            </c:forEach>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="row info-panel">
            <h3 class="char4"><a href="javascript:;" class="panel-toggle"><i class="icon-double-angle-up"
                                                                             aria-hidden="true"></i></a><span>项目介绍</span>
            </h3>
            <div class="panel-body">
                <div class="input-item">
                    <label>项目简介：</label>
                    <textarea class="form-control" rows="5" name="" readonly="readonly"
                              style="width:90%;"> ${gContest.introduction}</textarea>
                </div>
            </div>
        </div>
        <c:if test="${sysAttachments!=null }">
            <div class="row info-panel">
                <h3 class="char2"><span>附&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;件</span></h3>
                <div class="panel-body">
                    <div style="padding-left: 40px;">
                        <c:forEach items="${sysAttachments}" var="sysAttachment">
                            <div class="doc file-item">
                                <img src="/img/filetype/unknow.png"/>
                                <a href="javascript:void(0)"
                                   onclick="downfile('${sysAttachment.url}','${sysAttachment.name}');return false">
                                        ${sysAttachment.name}</a>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty asdiList}">
        <div class="row info-panel">
            <h3 class="char4"><a href="javascript:;" class="panel-toggle">
                <i class="icon-double-angle-up" aria-hidden="true"></i></a><span>审核标准</span>
            </h3>
            <table class="table table-bordered" id="tableFormReview" >
                <thead>
                <tr>
                    <th width="270"><i class="require-star">*</i>检查要点</th>
                    <th><i class="require-star">*</i>审核元素</th>
                    <th width="150"><i class="require-star">*</i>分值</th>
                    <c:if test="${not empty isScore }">
                        <th width="150">评分</th>
                    </c:if>
                </tr>
                </thead>
            <%--   添加评分标准--%>
                <tbody>
                    <c:forEach items="${asdiList}" var="de">
                        <tr>
                            <td>
                                <div class="form-control-box">
                                    ${de.checkPoint }
                                </div>
                            </td>
                            <td>
                                <div class="form-control-box">
                                    ${de.checkElement }
                                </div>
                            </td>
                            <td>
                                <div class="form-control-box">
                                    ${de.viewScore }
                                </div>
                            </td>
                            <c:if test="${not empty isScore }">
                            <td>
                                ${de.score }
                            </td>
                            </c:if>
                        </tr>
                    </c:forEach>

                    </tbody>
                    <tfoot>
                    <c:if test="${not empty isScore }">
                    <tr>
                        <td>总分</td>
                        <td colspan="3" id="totalScoreV">${auditStandard.totalScore}</td>
                    </tr>
                    </c:if>
                    </tfoot>
                </table>
            </div>
        </c:if>

        <c:if test="${state=='1'}">
            <c:if test="${infos!=null}">
                <div class="row info-panel">
                    <h3 class="char4"><span>审核记录</span></h3>
                    <div class="panel-body">
                        <div class="col-md-12 col-lg-12">
                            <table class="table table-bordered">
                                <tr>
                                    <th colspan="4">学院审核记录</th>
                                </tr>
                                <tr class="m-table-b">
                                    <th class="col-md-2 col-lg-2" style="width: 8%">学院专家</th>
                                    <th class="col-md-2 col-lg-2" style="width: 7%">评分</th>
                                    <th class="col-md-6 col-lg-6" colspan="2">建议及意见</th>
                                </tr>
                                <c:forEach items="${infos}" var="info">
                                    <c:if test="${info.createBy.id == loginUser.id}">
                                        <tr>
                                            <td>${fns:getUserById(info.createBy.id).name}</td>
                                            <td>${info.score}</td>
                                            <td colspan="2">${info.suggest}</td>
                                        </tr>
                                    </c:if>
                                </c:forEach>

                            </table>
                        </div>
                    </div>
                </div>
            </c:if>
        </c:if>

        <c:if test="${state=='2'}">
            <c:if test="${infos!=null}">
                <div class="row info-panel">
                    <h3 class="char4"><span>审核记录</span></h3>
                    <div class="panel-body">
                        <div class="col-md-12 col-lg-12">
                            <table class="table table-bordered">
                                <tr>
                                    <th colspan="4">学院审核记录</th>
                                </tr>
                                <tr class="m-table-b">
                                    <th class="col-md-2 col-lg-2" style="width: 8%">学院专家</th>
                                    <th class="col-md-2 col-lg-2" style="width: 7%">评分</th>
                                    <th class="col-md-6 col-lg-6" colspan="2">建议及意见</th>
                                </tr>
                                <c:forEach items="${infos}" var="info">
                                <tr>
                                    <td>${fns:getUserById(info.createBy.id).name}</td>
                                    <td>${info.score}</td>
                                    <td colspan="2">${info.suggest}</td>
                                <tr>
                                    </c:forEach>

                            </table>
                        </div>
                    </div>
                </div>
            </c:if>
        </c:if>
        <c:if test="${state=='3'}">
            <c:if test="${infos!=null}">
                <div class="row info-panel">
                    <h3><span>审核记录</span></h3>
                    <div class="panel-body">
                        <div class="col-md-12 col-lg-12">
                            <table class="table table-bordered">
                                <tr>
                                    <th colspan="4">学院审核记录</th>
                                </tr>
                                <c:if test="${collegeExportinfos!=null && fn:length(collegeExportinfos) > 0}">
                                    <tr class="m-table-b">
                                        <th class="col-md-2 col-lg-2" style="width: 8%">学院专家</th>
                                        <th class="col-md-2 col-lg-2" style="width: 7%">评分</th>
                                        <th class="col-md-6 col-lg-6" colspan="2">建议及意见</th>
                                    </tr>
                                    <c:forEach items="${collegeExportinfos}" var="info">
                                        <tr>
                                            <td>${fns:getUserById(info.createBy.id).name}</td>
                                            <td>${info.score}</td>
                                            <td colspan="2">${info.suggest}</td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                                <tr>
                                    <th class="col-md-2 col-lg-2">学院评分</th>
                                    <th class="col-md-2 col-lg-2">排名</th>
                                    <th colspan="2" class="col-md-6 col-lg-6">建议及意见</th>
                                </tr>
                                <c:forEach items="${infos}" var="info">
                                    <tr>
                                        <td>${info.score}</td>
                                        <td>${info.sort}</td>
                                        <td colspan="2">${info.suggest}</td>
                                    </tr>
                                </c:forEach>
                                <tr>
                                    <td class="m-table-d">学院网评得分</td>
                                    <td colspan="3">${gContest.gScore}</td>
                                </tr>
                                <c:if test="${schoolExportinfos!=null && fn:length(schoolExportinfos) > 0}">
                                    <tr>
                                        <th colspan="4">学院审核记录</th>
                                    </tr>
                                    <tr class="m-table-b">
                                        <th>学院专家</th>
                                        <th>评分</th>
                                        <th colspan="2">建议及意见</th>
                                    </tr>

                                    <c:forEach items="${schoolExportinfos}" var="info">
                                        <c:if test="${info.createBy.id == loginUser.id}">
                                            <tr>
                                                <td>${fns:getUserById(info.createBy.id).name}</td>
                                                <td>${info.score}</td>
                                                <td>${info.suggest}</td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>
        </c:if>

        <c:if test="${state=='4'}">
            <c:if test="${infos!=null}">
                <div class="row info-panel">
                    <h3><span>审核记录</span></h3>
                    <div class="panel-body">
                        <div class="col-md-12 col-lg-12">
                            <table class="table table-bordered">
                                <tr>
                                    <th colspan="4">学院审核记录</th>
                                </tr>
                                <c:if test="${collegeExportinfos!=null && fn:length(collegeExportinfos) > 0}">
                                    <tr class="m-table-b">
                                        <th class="col-md-2 col-lg-2" style="width: 8%">学院专家</th>
                                        <th class="col-md-2 col-lg-2" style="width: 7%">评分</th>
                                        <th class="col-md-6 col-lg-6" colspan="2">建议及意见</th>
                                    </tr>
                                    <c:forEach items="${collegeExportinfos}" var="info">
                                        <tr>
                                            <td>${fns:getUserById(info.createBy.id).name}</td>
                                            <td>${info.score}</td>
                                            <td colspan="2">${info.suggest}</td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                                <tr>
                                    <td class="m-table-d">学院网评得分</td>
                                    <td colspan="3">${collegeInfo.score}</td>
                                </tr>
                                <tr>
                                    <td class="m-table-d">学院排名</td>
                                    <td colspan="3">${collegeInfo.sort}</td>
                                </tr>
                                <tr>
                                    <th colspan="4">学院审核记录</th>
                                </tr>
                                <tr class="m-table-b">
                                    <th>学院专家</th>
                                    <th>评分</th>
                                    <th colspan="2">建议及意见</th>
                                </tr>
                                <c:forEach items="${infos}" var="info">

                                    <tr>
                                        <td>${fns:getUserById(info.createBy.id).name}</td>
                                        <td>${info.score}</td>
                                        <td>${info.suggest}</td>
                                    </tr>

                                </c:forEach>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>
        </c:if>
        <c:if test="${state=='5'}">

            <div class="row info-panel">
                <h3><span>审核记录</span></h3>
                <div class="panel-body">
                    <div class="col-md-12 col-lg-12">
                        <table class="table table-bordered">
                            <tr>
                                <th colspan="4">学院审核记录</th>
                            </tr>
                            <c:if test="${collegeExportinfos!=null && fn:length(collegeExportinfos) > 0}">
                                <tr class="m-table-b">
                                    <th class="col-md-2 col-lg-2" style="width: 8%">学院专家</th>
                                    <th class="col-md-2 col-lg-2" style="width: 7%">评分</th>
                                    <th class="col-md-6 col-lg-6" colspan="2">建议及意见</th>
                                </tr>
                                <c:forEach items="${collegeExportinfos}" var="info">
                                    <tr>
                                        <td>${fns:getUserById(info.createBy.id).name}</td>
                                        <td>${info.score}</td>
                                        <td colspan="2">${info.suggest}</td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <tr>
                                <td class="m-table-d">学院网评得分</td>
                                <td colspan="3">${collegeInfo.score}</td>
                            </tr>
                            <tr>
                                <td class="m-table-d">学院排名</td>
                                <td colspan="3">${collegeInfo.sort}</td>
                            </tr>

                            <tr>
                                <th colspan="4">学院审核记录</th>
                            </tr>
                            <tr class="m-table-b">
                                <th>学院专家</th>
                                <th>评分</th>
                                <th colspan="2">建议及意见</th>
                            </tr>
                            <c:forEach items="${schoolExportinfos}" var="info">
                                <tr>
                                    <td>${fns:getUserById(info.createBy.id).name}</td>
                                    <td>${info.score}</td>
                                    <td>${info.suggest}</td>
                                </tr>
                            </c:forEach>
                            <tr>
                                <td class="m-table-d">学院网评得分</td>
                                <td colspan="3">${gContest.gScore}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>

        </c:if>
        <c:if test="${state=='6'}">
            <div class="row info-panel">
                <h3><span>审核记录</span></h3>
                <div class="panel-body">
                    <div class="col-md-12 col-lg-12">
                        <table class="table table-bordered">
                            <tr>
                                <th colspan="4">学院审核记录</th>
                            </tr>
                            <c:if test="${collegeExportinfos!=null && fn:length(collegeExportinfos) > 0}">
                                <tr class="m-table-b">
                                    <th class="col-md-2 col-lg-2" style="width: 8%">学院专家</th>
                                    <th class="col-md-2 col-lg-2" style="width: 7%">评分</th>
                                    <th class="col-md-6 col-lg-6" colspan="2">建议及意见</th>
                                </tr>
                                <c:forEach items="${collegeExportinfos}" var="info">
                                    <tr>
                                        <td>${fns:getUserById(info.createBy.id).name}</td>
                                        <td>${info.score}</td>
                                        <td colspan="2">${info.suggest}</td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <tr>
                                <td class="m-table-d">学院网评得分</td>
                                <td colspan="3">${collegeInfo.score}</td>
                            </tr>
                            <tr>
                                <td class="m-table-d">学院排名</td>
                                <td colspan="3">${collegeInfo.sort}</td>
                            </tr>
                            <tr>
                                <th colspan="4">学院审核记录</th>
                            </tr>
                            <tr class="m-table-b">
                                <th>学院专家</th>
                                <th>评分</th>
                                <th colspan="2">建议及意见</th>
                            </tr>
                            <c:forEach items="${schoolExportinfos}" var="info">
                                <tr>
                                    <td>${fns:getUserById(info.createBy.id).name}</td>
                                    <td>${info.score}</td>
                                    <td colspan="2">${info.suggest}</td>
                                </tr>
                            </c:forEach>
                            <tr>
                                <td class="m-table-d">学院网评得分</td>
                                <td colspan="3">${schoolinfo.score}</td>
                            </tr>
                            <tr>
                                <td class="m-table-d">路演得分</td>
                                <td colspan="3">${lyinfo.score}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${state=='7'}">
            <div class="row info-panel">
                <h3><span>审核记录</span></h3>
                <div class="panel-body">
                    <div class="col-md-12 col-lg-12">
                        <table class="table table-bordered">
                            <tr>
                                <th colspan="4">学院审核记录</th>
                            </tr>
                            <c:if test="${collegeExportinfos!=null && fn:length(collegeExportinfos) > 0}">
                                <tr class="m-table-b">
                                    <th class="col-md-2 col-lg-2" style="width: 8%">学院专家</th>
                                    <th class="col-md-2 col-lg-2" style="width: 7%">评分</th>
                                    <th class="col-md-6 col-lg-6" colspan="2">建议及意见</th>
                                </tr>
                                <c:forEach items="${collegeExportinfos}" var="info">
                                    <tr>
                                        <td>${fns:getUserById(info.createBy.id).name}</td>
                                        <td>${info.score}</td>
                                        <td colspan="2">${info.suggest}</td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <tr>
                                <td class="m-table-d">学院网评得分</td>
                                <td colspan="3">${collegeInfo.score}</td>
                            </tr>
                            <tr>
                                <td class="m-table-d">学院排名</td>
                                <td colspan="3">${collegeInfo.sort}</td>
                            </tr>
                            <tr>
                                <th colspan="4">学院审核记录</th>
                            </tr>
                            <tr class="m-table-b">
                                <th>学院专家</th>
                                <th>评分</th>
                                <th colspan="2">建议及意见</th>
                            </tr>
                            <c:forEach items="${schoolExportinfos}" var="info">
                                <tr>
                                    <td>${fns:getUserById(info.createBy.id).name}</td>
                                    <td>${info.score}</td>
                                    <td colspan="2">${info.suggest}</td>
                                </tr>
                            </c:forEach>
                            <tr>
                                <td class="m-table-d">学院网评得分</td>
                                <td colspan="3">${schoolinfo.score}</td>
                            </tr>
                            <tr>
                                <td class="m-table-d">路演得分</td>
                                <td colspan="3">${lyinfo.score}</td>
                            </tr>
                            <tr>
                                <td class="m-table-d">学院排名</td>
                                <td colspan="3">${pjinfos.sort}</td>
                            </tr>
                            <tr>
                                <th colspan="4">校赛结果</th>
                            </tr>
                            <tr class="m-table-b">
                                <th>校赛总得分</th>
                                <th>校赛排名</th>
                                <th>校赛结果</th>
                                <th>建议及意见</th>
                            </tr>
                            <tr>
                                <td>${pjinfos.score}</td>
                                <td>${pjinfos.sort}</td>
                                <td>
                                        ${fns:getDictLabel(pjinfos.grade, "competition_college_prise", "")}
                                </td>
                                <td>${pjinfos.suggest}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </c:if>

        <div class="text-center mar_bottom">
            <button class="btn btn-default" type="button" onclick="history.go(-1)" class="button">返回</button>
        </div>
    </form:form>
</div>
</body>
</html>