<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="decorator" content="cyjd-site-default"/>
    <script src="/js/md/download.js" type="text/javascript" charset="utf-8"></script>
    <%--<link rel="stylesheet" type="text/css" href="/css/sco/frontCreditModule.css">--%>
    <link rel="stylesheet" type="text/css" href="/css/project/form.css"/>
    <link rel="stylesheet" type="text/css" href="/css/md_applyForm.css">
    <title>${frontTitle}</title>
    <style type="text/css">
        .file-list {
            list-style: none;
            padding: 0;
            margin: 0; }
        .file-list .icon-remove-sign {
            display: none;
            color: #dd4814;
            font-size: 18px;
            margin-left: 8px;
            vertical-align: middle;
            cursor: pointer; }
        .file-list a {
            text-decoration: none; }
        .file-list > li {
            position: relative;
            line-height: 34px;
            margin-bottom: 10px; }
        .file-list > li:first-child {
            margin-bottom: 0; }
        .file-list > li .file-info {
            padding: 0 15px;
            border-radius: 5px; }
        .file-list > li:hover .file-info {
            background-color: #cecece; }
        .file-list > li:hover a {
            color: #dd4814; }
        .file-list > li:hover .icon-remove-sign {
            display: inline; }
        .file-list .pic-icon {
            margin-right: 6px; }
        .file-list .loading {
            display: none;
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            width: 100%;
            height: 34px;
            text-align: center;
            background-color: rgba(0, 0, 0, 0.3);
            z-index: 10; }
        .file-list .loading > img {
            display: inline-block;
            width: 24px; }

        .file-list li p.error {
            line-height: 24px;
            margin: 0;
            color: red;
            padding-left: 15px; }

        .file-list li p.progress {
            width: 100%;
            height: 8px;
            overflow: hidden;
            z-index: 50;
            margin: 0;
            border-radius: 0;
            background: none;
            -webkit-box-shadow: 0 0 0; }

        .file-list li p.progress span {
            display: none;
            overflow: hidden;
            width: 0;
            height: 100%;
            background: #1483d8 url(../static/webuploader/progress.png) repeat-x;
            -webit-transition: width 200ms linear;
            -webkit-transition: width 200ms linear;
            transition: width 200ms linear;
            -webkit-animation: progressmove 2s linear infinite;
            animation: progressmove 2s linear infinite;
            -webkit-transform: translateZ(0); }
    </style>
</head>
<body>


<div class="container project-view-contanier">
    <input type="hidden" id="pageType" value="edit">
    <div class="contest-content contest-content-one form-horizontal">
        <div class="tool-bar" style="height:44px;">
            <div class="inner">
                <%--<c:set var="sse" value="${fns:getUserById(proModel.declareId)}"/>--%>
                <%--<span>项目编号：</span>--%>
                <%--<i>${proModel.competitionNumber}</i>--%>
                <%--<span style="margin-left: 15px;">填报日期:</span>--%>
                <%--<i><fmt:formatDate value='${proModel.createDate}' pattern='yyyy-MM-dd'/></i>--%>
                <%--<span style="margin-left: 15px">申请人:</span>--%>
                <%--<i>${sse.name}</i>--%>
                <div class="row row-user-info">
                    <c:set var="sse" value="${fns:getUserById(proModel.declareId)}"/>
                    <div class="col-xs-4">
                        <label class="label-static">项目编号：</label>
                        <p class="form-control-static p-left">${proModel.competitionNumber}</p>
                    </div>
                    <div class="col-xs-4">
                        <label class="label-static">填报日期：</label>
                        <p class="form-control-static p-left"><fmt:formatDate value='${proModel.createDate}' pattern='yyyy-MM-dd'/></p>
                    </div>
                    <div class="col-xs-4">
                        <label class="label-static">申报人：</label>
                        <p class="form-control-static p-left">${sse.name}</p>
                    </div>
                </div>

            </div>
        </div>
        <h4 class="contest-title">项目申报表</h4>
        <div class="contest-wrap form-horizontal form-horizontal-apply">
            <div class="row row-user-info">
                <%--<div class="col-md-6">--%>
                <%--<div class="form-group">--%>
                <%--<label class="control-label">项目负责人：</label>--%>
                <%--<div class="input-box">--%>
                <%--<p class="form-control-static">${sse.name}</p>--%>
                <%--</div>--%>
                <%--</div>--%>
                <%--</div>--%>
                <div class="col-xs-6">
                    <label class="label-static">项目负责人：</label>
                    <p class="form-control-static">${sse.name}</p>
                </div>
                <%--<div class="col-md-6">--%>
                <%--<div class="form-group">--%>
                <%--<label class="control-label">学号：</label>--%>
                <%--<div class="input-box">--%>
                <%--<p class="form-control-static">${sse.no}</p>--%>
                <%--</div>--%>
                <%--</div>--%>
                <%--</div>--%>
                <div class="col-xs-6">
                    <label class="label-static">学号：</label>
                    <p class="form-control-static">${sse.no}</p>
                </div>
            </div>
            <div class="row row-user-info">
                <%--<div class="col-md-6">--%>
                <%--<div class="form-group">--%>
                <%--<label class="control-label">性别：</label>--%>
                <%--<div class="input-box">--%>
                <%--<p class="form-control-static">--%>
                <%--${fns:getDictLabel(sse.sex, 'sex', '')}--%>
                <%--</p>--%>
                <%--</div>--%>
                <%--</div>--%>
                <%--</div>--%>
                <div class="col-xs-6">
                    <label class="label-static">性别：</label>
                    <p class="form-control-static">${fns:getDictLabel(sse.sex, 'sex', '')}</p>
                </div>
                <%--<div class="col-md-6">--%>
                <%--<div class="form-group">--%>
                <%--<label class="control-label">民族：</label>--%>
                <%--<div class="input-box">--%>
                <%--<p class="form-control-static">${sse.national}</p>--%>
                <%--</div>--%>
                <%--</div>--%>
                <%--</div>--%>
                <div class="col-xs-6">
                    <label class="label-static">民族：</label>
                    <p class="form-control-static">${sse.national}</p>
                </div>
            </div>
            <div class="row row-user-info">
                <%--<div class="col-md-6">--%>
                <%--<div class="form-group">--%>
                <%--<label class="control-label">学院：</label>--%>
                <%--<div class="input-box">--%>
                <%--<p class="form-control-static">${sse.office.name}</p>--%>
                <%--</div>--%>
                <%--</div>--%>
                <%--</div>--%>
                <div class="col-xs-6">
                    <label class="label-static">学院：</label>
                    <p class="form-control-static">${sse.office.name}</p>
                </div>
                <%--<div class="col-md-6">--%>
                <%--<div class="form-group">--%>
                <%--<label class="control-label">专业年级：</label>--%>
                <%--<div class="input-box">--%>
                <%--<p class="form-control-static">${fns:getProfessional(sse.professional)}</p>--%>
                <%--</div>--%>
                <%--</div>--%>
                <%--</div>--%>
                <div class="col-xs-6">
                    <label class="label-static">专业年级：</label>
                    <p class="form-control-static">${fns:getProfessional(sse.professional)}</p>
                </div>
            </div>
            <div class="row row-user-info">
                <%--<div class="col-md-6">--%>
                <%--<div class="form-group">--%>
                <%--<label class="control-label">联系电话：</label>--%>
                <%--<div class="input-box">--%>
                <%--<p class="form-control-static">${sse.mobile}</p>--%>
                <%--</div>--%>
                <%--</div>--%>
                <%--</div>--%>
                <div class="col-xs-6">
                    <label class="label-static">联系电话：</label>
                    <p class="form-control-static">${sse.mobile}</p>
                </div>
                <%--<div class="col-md-6">--%>
                <%--<div class="form-group">--%>
                <%--<label class="control-label">E-mail：</label>--%>
                <%--<div class="input-box">--%>
                <%--<p class="form-control-static">${sse.email}</p>--%>
                <%--</div>--%>
                <%--</div>--%>
                <%--</div>--%>
                <div class="col-xs-6">
                    <label class="label-static">E-mail：</label>
                    <p class="form-control-static">${sse.email}</p>
                </div>
            </div>
            <div class="row row-user-info">
                <%--<div class="col-md-6">--%>
                <%--<div class="form-group">--%>
                <%--<label class="control-label">身份证号：</label>--%>
                <%--<div class="input-box">--%>
                <%--<p class="form-control-static">${sse.idNumber}</p>--%>
                <%--</div>--%>
                <%--</div>--%>
                <%--</div>--%>
                <div class="col-xs-6">
                    <label class="label-static">身份证号：</label>
                    <p class="form-control-static">${sse.idNumber}</p>
                </div>
                <%--<div class="col-md-6">--%>
                <%--<div class="form-group">--%>
                <%--<label class="control-label">QQ：</label>--%>
                <%--<div class="input-box">--%>
                <%--<p class="form-control-static">${sse.qq}</p>--%>
                <%--</div>--%>
                <%--</div>--%>
                <%--</div>--%>
                <div class="col-xs-6">
                    <label class="label-static">QQ：</label>
                    <p class="form-control-static">${sse.qq}</p>
                </div>
            </div>
            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>项目基本信息</span>
                    <i class="line"></i>
                    <a data-toggle="collapse" href="#applicatioinDetail"><i
                            class="icon-collaspe icon-double-angle-up"></i></a>
                </div>
            </div>
            <div class="form-horizontal form-horizontal-apply" style="margin-bottom:40px;">
                <div id="applicatioinDetail" class="panel-body collapse in">
                    <div class="row row-user-info">
                        <%--<div class="col-md-6">--%>
                        <%--<div class="form-group">--%>
                        <%--<label class="control-label">项目名称：</label>--%>
                        <%--<div class="input-box">--%>
                        <%--<p class="form-control-static">${proModel.pName}</p>--%>
                        <%--</div>--%>
                        <%--</div>--%>
                        <%--</div>--%>
                        <div class="col-xs-6">
                            <label class="label-static">项目名称：</label>
                            <p class="form-control-static">${proModel.pName}</p>
                        </div>

                        <%--<div class="col-md-6">--%>
                        <%--<div class="form-group">--%>
                        <%--<label class="control-label">项目类别：</label>--%>
                        <%--<div class="input-box">--%>
                        <%--<p class="form-control-static"> ${fns:getDictLabel(proModel.proCategory, "project_type","" )}</p>--%>
                        <%--</div>--%>
                        <%--</div>--%>
                        <%--</div>--%>
                        <div class="col-xs-6">
                            <label class="label-static">项目类别：</label>
                            <p class="form-control-static">${fns:getDictLabel(proModel.proCategory, "project_type","" )}</p>
                        </div>
                    </div>
                    <%--<div class="col-xs-12">--%>
                    <%--<div class="form-group">--%>
                    <%--<label class="control-label">项目简介：</label>--%>
                    <%--<div class="input-box">--%>
                    <%--<p class="form-control-static">打发奖金大家分开撒娇的看法打发奖金大家分开撒娇的看法--%>
                    <%--打发奖金大家分开撒娇的看法打发奖金大家分开撒娇的看法打发奖金大家分开撒娇的看法打发奖金大家分开撒娇的看法打发奖金大家分开撒娇的看法--%>
                    <%--打发奖金大家分开撒娇的看法打发奖金大家分开撒娇的看法打发奖金大家分开撒娇的看法打发奖金大家分开撒娇的看法--%>
                    <%--打发奖金大家分开撒娇的看法打发奖金大家分开撒娇的看法打发奖金大家分开撒娇的看法打发奖金大家分开撒娇的看法--%>
                    <%--打发奖金大家分开撒娇的看法打发奖金大家分开撒娇的看法打发奖金大家分开撒娇的看法${proModel.introduction}</p>--%>
                    <%--</div>--%>
                    <%--</div>--%>
                    <%--</div>--%>
                    <div class="row row-user-info">
                        <div class="col-xs-9">
                            <label class="label-static">项目简介：</label>
                            <p class="form-control-static">${proModel.introduction}</p>
                        </div>
                    </div>

                    <%--<div class="col-md-6">--%>
                    <%--<div class="form-group">--%>
                    <%--<label class="control-label">项目logo：</label>--%>
                    <%--<div class="input-box">--%>
                    <%--<div>--%>
                    <%--<img style="width:40px;height: 40px;border-radius:50%;" id="logoImg" paramurl="${proModel.logo.url }" class="backimg" src="${empty proModel.logo.url ? '/images/upload-default-image1.png':fns:ftpImgUrl(proModel.logo.url)}">--%>
                    <%--</div>--%>
                    <%--</div>--%>
                    <%--</div>--%>
                    <%--</div>--%>
                    <div class="row row-user-info">
                        <div class="col-xs-4">
                            <label class="label-static">项目logo：</label>
                            <p class="form-control-static"><img style="width:40px;height: 40px;border-radius:50%;" id="logoImg" paramurl="${proModel.logo.url }" class="backimg" src="${empty proModel.logo.url ? '/images/upload-default-image1.png':fns:ftpImgUrl(proModel.logo.url)}"></p>
                        </div>
                    </div>
                </div>


                <div class="edit-bar edit-bar-sm clearfix">
                    <div class="edit-bar-left">
                        <span>团队信息</span>
                        <i class="line"></i>
                        <a data-toggle="collapse" href="#projectDetail"><i
                                class="icon-collaspe icon-double-angle-up"></i></a>
                    </div>
                </div>
                <div class="table-condition form-horizontal form-horizontal-apply">
                    <div id="projectDetail" class="panel-body collapse in">
                        <div class="row row-user-info">
                            <%--<div class="form-group">--%>
                            <%--<label class="control-label">团队信息：</label>--%>
                            <%--<div class="input-box" style="max-width: 394px;">--%>
                            <%--<p class="form-control-static">${team.name}</p>--%>
                            <%--</div>--%>
                            <%--</div>--%>
                            <div class="col-xs-8">
                                <label class="label-static">团队信息：</label>
                                <p class="form-control-static">${team.name}</p>
                            </div>
                        </div>

                        <div class="table-title">
                            <span>学生团队</span>
                            <span id="ratio" style="background-color: #fff;color: #df4526;"></span>
                        </div>
                        <table class="table table-bordered table-pro-work table-condensed table-theme-default studenttb">
                            <thead>
                            <tr id="studentTr">
                                <th>序号</th>
                                <th>姓名</th>
                                <th>学号</th>
                                <th>手机号</th>
                                <th>所在学院</th>
                                <%--  <th>项目分工</th>--%>
                            </tr>
                            </thead>
                            <tbody>
                            <c:if test="${teamStu!=null&&teamStu.size() > 0}">
                                <c:forEach items="${teamStu}" var="item" varStatus="status">
                                    <tr>
                                        <td>${status.index+1}</td>
                                        <td><c:out value="${item.name}"/></td>
                                        <td><c:out value="${item.no}"/></td>
                                        <td><c:out value="${item.mobile}"/></td>
                                        <td><c:out value="${item.org_name}"/></td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            </tbody>
                        </table>
                        <div class="table-title">
                            <span>指导教师</span>
                        </div>
                        <table class="table table-bordered table-condensed table-theme-default teachertb">
                            <thead>
                            <tr>
                                <th>序号</th>
                                <th>姓名</th>
                                <th>工号</th>
                                <th>导师来源</th>
                                <th>职称（职务）</th>
                                <th>学历</th>
                                <th>联系电话</th>
                                <th width="175">E-mail</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:if test="${teamTea!=null&&teamTea.size() > 0}">
                                <c:forEach items="${teamTea}" var="item" varStatus="status">
                                    <tr>
                                        <td>${status.index+1}</td>
                                        <td><c:out value="${item.name}"/></td>
                                        <td><c:out value="${item.no}"/></td>
                                        <td><c:out value="${item.teacherType}"/></td>
                                        <td><c:out value="${fns:getDictLabel(item.technical_title,'postTitle_type','')}"/></td>
                                        <td><c:out value="${fns:getDictLabel(item.education,'enducation_level','')}"/></td>
                                        <td><c:out value="${item.mobile}"/></td>
                                        <td><c:out value="${item.email}"/></td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="edit-bar edit-bar-sm clearfix">
                    <div class="edit-bar-left">
                        <span>项目申报资料</span>
                        <i class="line"></i>
                        <a data-toggle="collapse" href="#elseDetail"><i
                                class="icon-collaspe icon-double-angle-up"></i></a>
                    </div>
                </div>
                <div id="elseDetail" class="panel-body collapse in">
                    <div class="form-group" style="margin-left:20px;">
                        <label class="control-label">上传申报资料：</label>
                        <div class="input-box" style="margin-top:5px;">
                            <sys:frontFileUpload fileitems="${sysAttachments}" readonly="true" ></sys:frontFileUpload>

                        </div>
                    </div>
                </div>
                <%--<div class="btngroup">--%>
                <%--<button type="button" class="btn btn-default" onclick="history.go(-1)">返回</button>--%>
                <%--</div>--%>
            </div>

        </div>

    </div>
    <div class="btngroup" style="margin-top:30px">
        <button type="button" class="btn btn-default" onclick="javascript:location.href='/f/project/projectDeclare/list'">返回</button>
    </div>
</div>
</body>
</html>
