<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="decorator" content="site-decorator"/>
    <title>${frontTitle}</title>
    <link rel="stylesheet" type="text/css" href="/css/seers.css">
    <link rel="stylesheet" type="text/css" href="/css/studentForm.css">
    <script type="text/javascript" src="${ctxStatic}/My97DatePicker/WdatePicker.js"></script>
    <style>
        .form-dialog {
            padding: 0 15px;
        }

        .ui-prompt .ui-dialog-buttonset {
            border-top: 1px solid #cccccc;
            padding: 10px 0;
        }

        .ui-prompt label.error {
            margin-top: 8px;
        }

        .ui-prompt .form-group {
            text-align: left;
        }

        .btn-verification {
            color: #fff;
            width: 100px;
        }

        .btn-verification:hover, .btn-verification:focus {
            color: #fff;
        }

        .info-card .user-label-control {
            width: 100px;
        }

        .info-card .user-val {
            margin-left: 100px;
        }
    </style>

    <style>
        .ui-dialog .dialog-tip .icon-ok-msg, .ui-dialog .dialog-tip .icon-fail-msg i{
            display: block;
            margin: 0 auto 5px;
        }
        .ui-dialog .dialog-tip{
            max-width: 334px;
            min-width: 280px;
        }
        .dialog-tip span{
            display: block;
            text-align: center;
        }
        .dialog-tip-container .ui-dialog-buttonset button{
            padding: 5px 12px;
            margin-bottom: 15px;
        }
        .dialog-tip-container.ui-widget.ui-widget-content{
            width: auto !important;
            height: auto !important;
        }
    </style>
</head>

<body>
<div class="container" style="padding-top: 50px;padding-bottom: 30px;width: 1270px;">
    <ol class="breadcrumb" style="background: none">
        <li><a href="/f/"><i class="icon-home"></i>首页</a></li>
        <li><a href="/f/sys/frontStudentExpansion/findUserInfoById">教师信息查看</a></li>
        <li class="active">编辑</li>
    </ol>
    <form:form id="inputForm" modelAttribute="backTeacherExpansion" action="${ctxFront}/sys/frontTeacherExpansion/save"
               cssClass="form-horizontal">
               <input type="hidden" name="custRedict" id="custRedict" value="${custRedict}"/>
               <input type="hidden" name="okurl" id="okurl" value="${okurl}"/>
               <input type="hidden" name="backurl" id="backurl" value="${backurl}"/>
        <div class="row">
            <div class="left-menu col-md-3" role="complementary">
                <div class="lm-inner">
                    <h4 class="title">我的信息</h4>
                    <div class="me-info">
                        <p class="update-time">更新：<fmt:formatDate value="${backTeacherExpansion.updateDate}"
                                                                  pattern="yyyy-MM-dd"/></p>
                        <div class="public">是否公开：
                            <form:radiobuttons path="isOpen" items="${fns:getDictList('yes_no')}" itemLabel="label"
                                               itemValue="value"/>
                        </div>
                    </div>
                    <div id="nav-list" class="nav-list">
                        <ul class="nav">
                            <li><a href="#jsBaseInfo"><i class="iconx-info-school"></i>基本情况</a></li>
                            <li><a href="#jsProjectExp"><i class="iconx-info-exp"></i>指导项目</a></li>
                            <li><a href="#jsBigExp"><i class="iconx-info-bigExp"></i>指导大赛</a></li>
                            <li><a href="/f/sys/frontStudentExpansion/frontUserPassword"><i
                                    class="iconx-info-per"></i>修改密码</a></li>
                            <li><a href="/f/sys/frontStudentExpansion/frontUserMobile"><i
                                    class="iconx-info-per"></i>修改手机信息</a></li>
                        </ul>
                    </div>
                </div>
                <ul class="nav nav-tabs nav-tabs-good" role="tablist" style="margin-top: 15px;">
                    <li role="presentation" class="active"><a href="#seeMe" data-toggle="tab">谁看过我</a></li>
                    <li role="presentation"><a href="#seeOthers" data-toggle="tab">我看过谁</a></li>
                </ul>
                <div class="tab-content"
                     style="border: solid #ddd;border-width: 0 1px;padding-top: 10px;padding-left:5px;padding-right:5px;">
                    <ul id="seeMe" class="seers tab-pane active seers-small">
                        <c:forEach items="${visitors}" var="vi">
                            <c:if test="${vi.user_type=='1'}">
                                <li class="seer">
                                    <a href="/f/sys/frontStudentExpansion/form?id=${vi.st_id}">
                                        <img class="seer-pic"
                                             src="${empty vi.photo ? '/img/u4110.png':fns:ftpImgUrl(vi.photo)}">
                                        <span class="seer-name">${vi.name}</span>
                                    </a>
                                    <p class="see-date"><fmt:formatDate value='${vi.create_date}'
                                                                        pattern='yyyy-MM-dd'/></p>
                                </li>
                            </c:if>
                            <c:if test="${vi.user_type=='2'}">
                                <li class="seer">
                                    <a href="/f/sys/frontTeacherExpansion/view?id=${vi.te_id}">
                                        <img class="seer-pic"
                                             src="${empty vi.photo ? '/img/u4110.png':fns:ftpImgUrl(vi.photo)}">
                                        <span class="seer-name">${vi.name}</span>
                                    </a>
                                    <p class="see-date"><fmt:formatDate value='${vi.create_date}'
                                                                        pattern='yyyy-MM-dd'/></p>
                                </li>
                            </c:if>
                        </c:forEach>
                    </ul>
                    <ul id="seeOthers" class="seers tab-pane seers-small">
                        <c:forEach items="${browse}" var="vi">
                            <c:if test="${vi.user_type=='1'}">
                                <li class="seer">
                                    <a href="/f/sys/frontStudentExpansion/form?id=${vi.st_id}">
                                        <img class="seer-pic"
                                             src="${empty vi.photo ? '/img/u4110.png':fns:ftpImgUrl(vi.photo)}">
                                        <span class="seer-name">${vi.name}</span>
                                    </a>
                                    <p class="see-date"><fmt:formatDate value='${vi.create_date}'
                                                                        pattern='yyyy-MM-dd'/></p>
                                </li>
                            </c:if>
                            <c:if test="${vi.user_type=='2'}">
                                <li class="seer">
                                    <a href="/f/sys/frontTeacherExpansion/view?id=${vi.te_id}">
                                        <img class="seer-pic"
                                             src="${empty vi.photo ? '/img/u4110.png':fns:ftpImgUrl(vi.photo)}">
                                        <span class="seer-name">${vi.name}</span>
                                    </a>
                                    <p class="see-date"><fmt:formatDate value='${vi.create_date}'
                                                                        pattern='yyyy-MM-dd'/></p>
                                </li>
                            </c:if>
                        </c:forEach>
                    </ul>
                </div>
                <div class="see-count">
                    <div class="see-item">
                        <span>浏览量</span>
                        <span>${backTeacherExpansion.user.views}</span>
                    </div>
                    <div class="see-item">
                        <span>点赞数</span>
                        <span id="likespan">${backTeacherExpansion.user.likes}</span>
                    </div>
                </div>
            </div>
            <div class="main-content col-md-9" role="main">
                <div class="left-aside">
                    <div id="jsBaseInfo" class="user-info">
                        <div class="user-inner">
                            <div class="user-pic">
                                <div class="img-content" style="background:none;">
                                    <c:choose>
                                        <c:when test="${backTeacherExpansion.user.photo!=null && backTeacherExpansion.user.photo!='' }">
                                            <img class="user-img"
                                                 src="${fns:ftpImgUrl(backTeacherExpansion.user.photo) }"
                                                 id="fileId">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="user-img" src="/img/u4110.png" id="fileId">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="up-content">
                                    <input type="button" id="upload" class="btn" value="更新照片"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="user-info-content clearfix">
                    <div class="user-info-form">
                        <input type="hidden" id="userid" value="${backTeacherExpansion.user.id }"/>
                        <form:hidden path="id"/>

                        <form:hidden id="bu-summary" path="team.summary"/>

                        <input type="hidden" id="loginMsssage" value="${loginNameMessage }"/>
                        <div class="row">
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label class="control-label"><i class="icon-require">*</i>登录名：</label>
                                    <div class="input-box">
                                        <form:input type="text" path="user.loginName" maxlength="15"
                                                    htmlEscape="false"
                                                    class="form-control required"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label class="control-label"><i class="icon-require">*</i>姓名：</label>
                                    <div class="input-box">
                                        <form:input path="user.name" htmlEscape="false" maxlength="15"
                                                    cssClass="form-control required" type="text"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label class="control-label"><i class="icon-require">*</i>导师来源：</label>
                                    <div class="input-box">
                                        <form:radiobuttons path="teachertype" items="${fns:getDictList('master_type')}"
                                                           itemLabel="label" itemValue="value"
                                                           class="required"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label for="user.no" class="control-label"><i class="icon-require">*</i>职工号：</label>
                                    <div class="input-box">
                                        <form:input type="text" path="user.no" htmlEscape="false" maxlength="15"
                                                    class="form-control" placeholder=""/>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="row">

                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label for="user.sex" class="control-label"><i class="icon-require">*</i>性别：</label>
                                    <div class="input-box">
                                        <form:radiobuttons path="user.sex" items="${fns:getDictList('sex')}"
                                                           itemLabel="label" itemValue="value"/>
                                    </div>
                                </div>

                            </div>
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label class="control-label" for="imobile">
                                        <i class="icon-require">*</i>手机号：
                                    </label>
                                    <div class="input-box">
                                        <a href="javascript: void(0);" id="editMobileNum"
                                           class="edit-mobile-num">${empty backTeacherExpansion.user.mobile ? '绑定手机号': '更新'}</a>
                                        <p style="height: 34px;  padding: 6px 12px;   line-height: 1.42857143;">${backTeacherExpansion.user.mobile}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label class="control-label">出生年月：</label>
                                    <div class="input-box">
                                        <input id="birthday" name="user.birthday" type="text" style="height: 34px;"
                                               readonly
                                               class="Wdate form-control"
                                               value="<fmt:formatDate value='${backTeacherExpansion.user.birthday}' pattern='yyyy-MM-dd'/>"
                                               onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label class="control-label">国家/地区：</label>
                                    <div class="input-box">
                                        <form:input type="text" class="form-control" path="user.area" maxlength="20"
                                                    htmlEscape="false"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label class="control-label">民族：</label>
                                    <div class="input-box">
                                        <form:input type="text" path="user.national" maxlength="15"
                                                    class="form-control"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label class="control-label">政治面貌：</label>
                                    <div class="input-box">
                                        <form:input type="text" path="user.political" maxlength="15"
                                                    class="form-control"/>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label for="idType" class="control-label"><i class="icon-require">*</i>证件类型：</label>
                                    <div class="input-box">
                                        <form:select id="idType" path="user.idType"
                                                     class="form-control">
                                            <form:option value="" label="--请选择--"/>
                                            <form:options items="${fns:getDictList('id_type')}"
                                                          itemLabel="label" itemValue="value"
                                                          htmlEscape="false"/>
                                        </form:select>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label for="papersNumber" class="control-label"><i
                                            class="icon-require">*</i>证件号：</label>
                                    <div class="input-box">
                                        <form:input id="papersNumber" type="text" path="user.idNumber"
                                                    htmlEscape="false"
                                                    maxlength="128"
                                                    class=" form-control"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row user-info-form">
                    <div class="col-xs-8">
                        <div class="form-group">
                            <label for="serviceIntentionIds" class="control-label"><i
                                    class="icon-require">*</i>服务意向：</label>
                            <div class="input-box">
                                <form:checkboxes path="serviceIntentionIds" items="${fns:getDictList('master_help')}"
                                                 itemLabel="label" itemValue="value"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4" id="categorydiv">
                        <div class="form-group">
                            <label class="control-label"><i class="icon-require">*</i>导师类型：</label>
                            <div class="input-box">
                                <form:select id="category" path="category"
                                             class="form-control required">
                                    <form:option value="" label="--请选择--"/>
                                    <form:options items="${fns:getDictList('0000000215')}"
                                                  itemLabel="label" itemValue="value" htmlEscape="false"/>
                                </form:select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row user-info-form">
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label class="control-label">单位类别：</label>
                            <div class="input-box">
                                <form:select id="workUnitType" path="workUnitType"
                                             class="form-control">
                                    <form:option value="" label="--请选择--"/>
                                    <form:options items="${fns:getDictList('0000000218')}"
                                                  itemLabel="label" itemValue="value" htmlEscape="false"/>
                                </form:select>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label class="control-label">工作单位：</label>
                            <div class="input-box">
                                <form:input path="workUnit" htmlEscape="false" maxlength="128"
                                            type="text"
                                            class="inputSp  form-control"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label class="control-label">推荐单位：</label>
                            <div class="input-box">
                                <form:input path="recommendedUnits" htmlEscape="false" maxlength="128"
                                            type="text"
                                            class="inputSp  form-control"/>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row user-info-form">
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label for="educationType" class="control-label"><i class="icon-require">*</i>学历类别：</label>
                            <div class="input-box">
                                <form:select id="educationType" path="educationType"
                                             class="form-control">
                                    <form:option value="" label="--请选择--"/>
                                    <form:options items="${fns:getDictList('enducation_type')}"
                                                  itemLabel="label" itemValue="value" htmlEscape="false"/>
                                </form:select>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label for="user.education" class="control-label"><i class="icon-require">*</i>学历：</label>
                            <div class="input-box">
                                <form:select id="user.education" path="user.education"
                                             class="form-control">
                                    <form:option value="" label="--请选择--"/>
                                    <form:options
                                            items="${fns:getDictList('enducation_level')}"
                                            itemLabel="label" itemValue="value" htmlEscape="false"/>
                                </form:select>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label class="control-label">学科门类：</label>
                            <div class="input-box">
                                <form:select id="subject" path="discipline" class="form-control">
                                    <form:option value="" label="--请选择--"/>
                                    <form:options
                                            items="${fns:getDictList('professional_type')}"
                                            itemLabel="label" itemValue="value" htmlEscape="false"/>
                                </form:select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row user-info-form">
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label for="degreeType" class="control-label">学位类别：</label>
                            <div class="input-box">
                                <form:select id="degreeType" path="user.degree"
                                             class="form-control">
                                    <form:option value="" label="--请选择--"/>
                                    <form:options items="${fns:getDictList('degree_type')}"
                                                  itemLabel="label" itemValue="value" htmlEscape="false"/>
                                </form:select>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label for="collegeId" class="control-label">院系名称：</label>
                            <div class="input-box">
                                <form:select path="user.office.id"
                                             class="form-control"
                                             id="collegeId">
                                    <form:option value="" label="--请选择--"/>
                                    <form:options items="${fns:findColleges()}" itemLabel="name"
                                                  itemValue="id" htmlEscape="false"/>
                                </form:select>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label for="user.professional" class="control-label">专业：</label>
                            <div class="input-box">
                                <form:select path="user.professional"
                                             class="form-control">
                                    <form:option value="" label="--请选择--"/>
                                </form:select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row user-info-form">
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label class="control-label">行业：</label>
                            <div class="input-box">
                                <form:input type="text" path="industry" htmlEscape="false" maxlength="32"
                                            class="form-control"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label class="control-label">职务：</label>
                            <div class="input-box">
                                <form:input path="postTitle" htmlEscape="false" class="form-control" maxlength="64"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label class="control-label">职称：</label>
                            <div class="input-box">
                                <form:input path="technicalTitle" htmlEscape="false" class="form-control"
                                            maxlength="20"/>
                            </div>
                        </div>
                    </div>

                </div>
                <div class="row user-info-form">
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label for="userEmail" class="control-label"><i class="icon-require">*</i>邮箱：</label>
                            <div class="input-box">
                                <form:input id="userEmail" type="email" path="user.email" htmlEscape="false"
                                            maxlength="100"
                                            class="form-control"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label class="control-label">开户银行：</label>
                            <div class="input-box">
                                <form:input id="bank" type="text" path="firstBank" htmlEscape="false" maxlength="100"
                                            class="form-control"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label class="control-label">账号：</label>
                            <div class="input-box">
                                <form:input id="bankAccount" type="text" path="bankAccount" maxlength="19"
                                            minlength="16" htmlEscape="false"
                                            class="form-control number"/>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row user-info-form">
                    <div class="col-xs-12">
                        <div class="form-group">
                            <label for="user.domainIdList" class="control-label">技术领域：</label>
                            <div class="input-box">
                                <form:checkboxes path="user.domainIdList" items="${allDomains}"
                                                 itemLabel="label" itemValue="value"/>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row user-info-form">
                    <div class="col-xs-12">
                        <div class="form-group">
                            <label class="control-label">工作经历：</label>
                            <div class="input-box">
                                <textarea id="experience" placeholder="" name="mainExp" class="form-control"
                                          maxlength="1000"
                                          rows="4">${backTeacherExpansion.mainExp}</textarea>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="text-right">
                    <button type="submit" class="btn btn-primary-oe">保存</button>
                    <button type="button" class="btn btn-default-oe" onclick="history.go(-1)">返回</button>
                </div>
                <div class="edit-bar clearfix">
                    <div class="edit-bar-left">
                        <span>详细信息</span>
                        <i class="line"></i>
                    </div>
                </div>
                <div class="ud-inner">
                    <p id="jsProjectExp" class="ud-title">指导项目</p>
                    <div class="info-cards info-comment">
                        <c:forEach items="${projectExpVo}" var="projectExp">
                            <div class="info-card">
                                <p class="info-card-title"><c:if test="${projectExp.finish==0 }"><span
                                        style="color: #e9432d;">【进行中】</span></c:if>${projectExp.proName}</p>
                                <div class="row">
                                    <div class="col-xs-6">
                                        <div class="ic-box">
                                            <label class="user-label-control">项目周期：</label>
                                            <div class="user-val"><fmt:formatDate value="${projectExp.startDate }"
                                                                                  pattern="yyyy/MM/dd"/>-
                                                <fmt:formatDate value="${projectExp.endDate }"
                                                                pattern="yyyy/MM/dd"/></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-6">
                                        <div class="ic-box">
                                            <label class="user-label-control">项目名称：</label>
                                            <div class="user-val">${projectExp.name}</div>
                                        </div>
                                    </div>
                                    <div class="col-xs-6">
                                        <div class="ic-box">
                                            <label class="user-label-control">担任角色：</label>
                                            <div class="user-val">
                                                <c:if test="${cuser==projectExp.leaderId}">项目负责人</c:if>
                                                <c:if test="${cuser!=projectExp.leaderId&&projectExp.userType=='1'}">组成员</c:if>
                                                <c:if test="${cuser!=projectExp.leaderId&&projectExp.userType=='2'}">导师</c:if>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xs-6">
                                        <div class="ic-box">
                                            <label class="user-label-control">项目评级：</label>
                                            <div class="user-val">${projectExp.level}</div>
                                        </div>
                                    </div>
                                    <div class="col-xs-6">
                                        <div class="ic-box">
                                            <label class="user-label-control">项目结果：</label>
                                            <div class="user-val">${projectExp.result }</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <p id="jsBigExp" class="ud-title">指导大赛</p>
                    <div class="info-cards info-comment">
                        <c:forEach items="${gContestExpVo}" var="gContest">
                            <div class="info-card">
                                <p class="info-card-title"><c:if test="${gContest.finish==0 }"><span
                                        style="color: #e9432d;">【进行中】</span></c:if>${gContest.type}</p>
                                <div class="row">
                                    <div class="col-xs-6">
                                        <div class="ic-box">
                                            <label class="user-label-control">参赛项目名称：</label>
                                            <div class="user-val">${gContest.pName}</div>
                                        </div>
                                    </div>
                                    <div class="col-xs-6">
                                        <div class="ic-box">
                                            <label class="user-label-control">参赛时间：</label>
                                            <div class="user-val"><fmt:formatDate value="${gContest.createDate }"
                                                                                  pattern="yyyy-MM-dd"/></div>
                                        </div>
                                    </div>
                                    <div class="col-xs-6">
                                        <div class="ic-box">
                                            <label class="user-label-control">担任角色：</label>
                                            <div class="user-val"><c:if test="${cuser==gContest.leaderId}">项目负责人</c:if>
                                                <c:if test="${cuser!=gContest.leaderId&&gContest.userType=='1'}">组成员</c:if>
                                                <c:if test="${cuser!=gContest.leaderId&&gContest.userType=='2'}">导师</c:if>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xs-6">
                                        <div class="ic-box">
                                            <label class="user-label-control">获奖情况：</label>
                                            <div class="user-val">${gContest.award}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </form:form>
</div>
<sys:frontTestCut width="200" height="200" btnid="upload" imgId="fileId" column="user.photo" filepath="user"
                  className="modal-avatar"></sys:frontTestCut>
<div id="dialogEditPhone" class="hide">
    <div id="dialogContentPhone">
        <form id="phoneNumberForm" class="form-horizontal form-dialog">
            <div class="form-group">
                <div class="col-md-12">
                    <input type="text" id="mobile" autocomplete="off" name="mobile"
                           value="${backTeacherExpansion.user.mobile}"
                           class="form-control form-control-phone required" placeholder="填写手机号">
                </div>
            </div>
            <div class="form-group">
                <div class="col-md-7">
                    <input type="text" id="yzm" autocomplete="off" name="yzm"
                           class="form-control form-control-yzm required number" placeholder="验证码">
                </div>
                <div class="col-md-5">
                    <button type="button" disabled class="btn btn-primary-oe pull-right btn-verification getVeri">获取验证码</button>
                </div>
                <div class="edit-phone-error"></div>
            </div>
        </form>
    </div>
</div>
<div id="dialogTip" class="dialog-tip" title="信息" style="display: none;">
</div>
<script>



    function showModalXiMessage(ret, msg, buttons) {
        var html = null;
        //ret 3种状态，0表示操作失败，1表示操作成功，2表示操作出现警告
        switch (parseInt(ret)) {
            case 0 :
                html = createFailMessage(msg);
                break;
            case 1 :
                html = createOkMessage(msg);
                break;
            case 2 :
                html = warningMessage(msg);
                break;
            default:
                break;

        }
        $("#dialogTip").html(html);
        $("#dialogTip").dialog({
            modal: true,
            resizable: false,
            dialogClass: 'dialog-tip-container',
            buttons: buttons || {
                确定: function () {
                    $(this).dialog("close");
                }
            }
        });
    }

    $(document).ready(function (e) {
    	if ("${message}" != "") {
    		dialogCyjd.createDialog(1, "${message}", {
                dialogClass: 'dialog-cyjd-container none-close',
                buttons: [{
                    text: '确定',
                    'class': 'btn btn-sm btn-primary',
                    click: function () {
                        $(this).dialog('close');
                        if("${message}".indexOf("成功")!=-1&&$("#custRedict").val()=="1"){
                    		location.href=$("#okurl").val();
                    	}
                    }
                }]
            });
        }
        var $collegeId = $('#collegeId');
        var $userProfessional = $('select[name="user.professional"]');
        //增加学院下拉框change事件
        $collegeId.change(function () {
            var parentId = $(this).val();
            //根据当前学院id 更改
            $userProfessional.empty().append('<option value="">--请选择--</option>');
            $.ajax({
                type: "post",
                url: "/f/sys/office/findProfessionals",
                data: {"parentId": parentId},
                async: true,
                success: function (data) {
                    $.each(data, function (i, val) {
                        if (val.id == "${backTeacherExpansion.user.professional}") {
                            $userProfessional.append('<option selected="selected" value="' + val.id + '">' + val.name + '</option>')
                        } else {
                            $userProfessional.append('<option value="' + val.id + '">' + val.name + '</option>')
                        }
                    })
                }
            });
        });
        $collegeId.trigger('change');
        //添加自定义验证规则
        jQuery.validator.addMethod("phone_number", function (value, element) {
            var length = value.length;
            return this.optional(element) || (length == 11 && mobileRegExp.test(value));
        }, "手机号码格式错误");
        //添加自定义验证规则
        jQuery.validator.addMethod("numberLetter", function (value, element) {
            var length = value.length;
            return this.optional(element) || numberLetterExp.test(value);
        }, "只能输入数字和字母");
        jQuery.validator.addMethod("isIdCardNo", function (value, element) {
            return this.optional(element) || IDCardExp.test(value);
        }, "身份证号码不正确");

        var validate = $("#inputForm").validate({
            rules: {
                "user.loginName": {
                    remote: {
                        async: false,
                        url: "/f/sys/user/checkLoginName",     //后台处理程序
                        type: "post",               //数据发送方式
                        dataType: "json",           //接受数据格式
                        data: {                     //要传递的数据
                            userid: "${backTeacherExpansion.user.id}",
                            loginName: function () {
                                return $("input[name='user.loginName']").val();
                            }
                        }
                    }
                },
                "user.no": {  //职工号校验
                    numberLetter: true,
                    remote: {
                        async: false,
                        url: "/f/sys/user/checkNo",     //后台处理程序
                        type: "post",               //数据发送方式
                        dataType: "json",           //接受数据格式
                        data: {                     //要传递的数据
                            userid: "${backTeacherExpansion.user.id}",
                            no: function () {
                                return $("input[name='user.no']").val();
                            }
                        }
                    }
                }
            },
            messages: {
                "user.no": {
                    remote: "该职工号已被占用"
                },
                'user.loginName': {
                    remote: '该登录名已被占用'
                }
            },
            errorPlacement: function (error, element) {
                if ($(element).attr("type") == "checkbox" || $(element).attr("type") == "radio") {
                    error.appendTo($(element).parent().parent());
                } else {
                    error.insertAfter(element);
                }
            }
        });

        var $idType = $('select[name="user.idType"]');
        var $userIdNumber = $('input[name="user.idNumber"]');

        if ($idType.val() == "1") {
            $userIdNumber.rules("add", {isIdCardNo: true});
        }

        $idType.change(function () {
            if ($(this).val() == '1') {
                $userIdNumber.rules("add", {isIdCardNo: true});
            } else {
                $userIdNumber.rules("remove", "isIdCardNo");
                $userIdNumber.removeClass("error");
                $userIdNumber.next("label").hide();
            }
        });
        var $teacherType = $("input[name='teachertype']");
        var formsRequired = ['serviceIntentionIds', 'idType', 'user.sex', 'imobile', 'user.no', 'papersNumber', 'educationType', 'user.education', 'userEmail'];


        $teacherType.on('click', function () {
            teacherTypeClick($(this));
        });
        function teacherTypeClick(ob) {
            var val = ob.val();
            if (val == 2) {
                removeRules();
            } else {
                addMobileRule();
            }
        }

        teacherTypeClick($("input[name='teachertype']:checked"));


        $("input[name='serviceIntentionIds']").on('click', function () {
            serviceIntentionChange();
        });
        function serviceIntentionChange() {
            if ($("input[name='serviceIntentionIds'][value='4']:checked").length == 1) {
                $("#categorydiv").show();
            } else {
                $("#categorydiv").hide();
                $("#category").val("");
            }
        }

        serviceIntentionChange();
        $('#saveUserInfo').on('click', function () {
            if (validate.form()) {  //表单提交 调用校验
                $("#inputForm").submit();
            }
        });


        function addMobileRule() {
            $.each(formsRequired, function (k, v) {
                if (v == "papersNumber") {
                    if ($('select[name="user.idType"]').val() == "1") {
                        $('input[name="user.idNumber"]').rules("add", {isIdCardNo: true});
                    } else {
                        $('input[name="user.idNumber"]').rules('add', {required: true});
                    }
                    $('label[for="' + v + '"]').find('i').removeClass('hide');

                } else if (v == "serviceIntentionIds") {
                    $('[name="' + v + '"]').rules('add', {required: true});
                    $('label[for="' + v + '"]').find('i').removeClass('hide');
                } else if (v == "user.sex") {
                    $('[name="' + v + '"]').rules('add', {required: true});
                    $('label[for="' + v + '"]').find('i').removeClass('hide');
                } else if (v == "imobile") {
                    $('label[for="' + v + '"]').find('i').removeClass('hide');
                } else {
                    $('[id="' + v + '"]').rules('add', {required: true});
                    $('label[for="' + v + '"]').find('i').removeClass('hide');
                }
            })
        }

        function removeRules() {
            $.each(formsRequired, function (k, v) {
                if (v == "serviceIntentionIds") {
                    $('label[for="' + v + '"]').find('i').addClass('hide');
                    $('[name="' + v + '"]').rules('remove');
                    $('[name="' + v + '"]').removeClass('error');
                    $('label[for="' + v + '"]').next().find('.error').remove();
                } else if (v == "user.sex") {
                    $('label[for="' + v + '"]').find('i').addClass('hide');
                    $('[name="' + v + '"]').rules('remove');
                    $('[name="' + v + '"]').removeClass('error');
                    $('label[for="' + v + '"]').next().find('.error').remove();
                } else if (v == "imobile") {
                    $('label[for="' + v + '"]').find('i').addClass('hide');
                } else {
                    $('label[for="' + v + '"]').find('i').addClass('hide');
                    $('[id="' + v + '"]').rules('remove');
                    $('[id="' + v + '"]').removeClass('error');
                    $('[id="' + v + '"]').next().remove();
                }
            })
        }
    });


    $(function () {
        //手机号修改
        var $editMobileNum = $('#editMobileNum');
        var $phoneFormControlStatic = $editMobileNum.next();
        var $dialogEditPhone = $('#dialogEditPhone');
        var $dialogContentPhone = $('#dialogContentPhone');
        var phoneNumberValidate = null;
        var countDownNumber = 60;
        var timer = null;
        var createdPrompt = false;

        var $phoneNumberForm = $('#phoneNumberForm');
        phoneNumberValidate = $phoneNumberForm.validate({
            rules: {
                mobile: {
                    isMobileNumber: true
                }
            },
            errorPlacement: function (error, element) {
                error.insertAfter(element)
            }
        });

        var validMobile = false;
        var validYzm = false;


        $(document).on('input propertychange', 'input[name="mobile"]', function (e) {
            var val = $(this).val();
            var xhr;
            var $parent = $(this).parent();
            var $btnVeri = $('button.getVeri');
            if (phoneNumberValidate.element('#mobile')) {
                xhr = $.post('/f/sys/user/checkMobileExist', {mobile: val});
                xhr.success(function (data) {
                    if (data) {
                        $btnVeri.prop('disabled', false);
                        $parent.find('label').hide()
                        validMobile = true
                    } else {
                        if ($parent.find('label').size() > 0) {
                            $parent.find('label').text('该手机号已经注册').show()
                        } else {
                            $parent.append('<label for="mobile" class="error">该手机号已经注册</label>')
                        }
                        $btnVeri.prop('disabled', true)
                        validMobile = false
                    }
                });
                xhr.error(function () {
                    $btnVeri.prop('disabled', true)
                    validMobile = false
                })
            }
        });
        $('input[name="mobile"]').blur(function () {
            var $parent = $(this).parent();
            if (!validMobile) {
                if ($parent.find('label').size() > 0) {
                    $parent.find('label').text('该手机号已经注册').show()
                } else {
                    $parent.append('<label for="mobile" class="error">该手机号已经注册</label>')
                }
            }
        })


        $(document).on('change', 'input[name="yzm"]', function (e) {
            var val = $(this).val();
            var xhr;
            var $parent = $(this).parent();
            if (phoneNumberValidate.element('#yzm')) {
                xhr = $.post('/f/mobile/checkMobileValidateCode', {yzm: val});
                xhr.success(function (data) {
                    if (data) {
                        $parent.find('label').hide();
                        validYzm = true
                    } else {
                        if ($parent.find('label').size() > 0) {
                            $parent.find('label').text('验证码不正确').show()
                        } else {
                            $parent.append('<label for="yzm" class="error">验证码不正确</label>')
                        }
                        validYzm = false;
                    }
                });
                xhr.error(function () {
                })
            }
        });

        $('input[name="yzm"]').blur(function () {
            var $parent = $(this).parent();
            if (!validYzm) {
                if ($parent.find('label').size() > 0) {
                    $parent.find('label').text('验证码不正确').show()
                } else {
                    $parent.append('<label for="yzm" class="error">验证码不正确</label>')
                }
            }
        })

        $editMobileNum.on('click', function (e) {
            e.preventDefault();
            if (!createdPrompt) {
                createdPrompt = true;
                createPrompt(function submitPhoneNumber(e, $element) {
                    if (phoneNumberValidate && phoneNumberValidate.form() && validYzm && validMobile) {
                        var xhrPhoneNumberPromise = xhrPhoneNumber();
                        var $phoneNumberForm = $('#phoneNumberForm');
                        var $formControlPhone = $phoneNumberForm.find('.form-control-phone');
                        var $editPhoneError = $phoneNumberForm.find('.edit-phone-error');
                        xhrPhoneNumberPromise.success(function (data) {
                            //成功回显
                            changePhoneNum($formControlPhone.val());
                            $editMobileNum.text('更新');
                            $element.dialog('close');
                            dialogCyjd.createDialog(1, "修改成功", {
                                dialogClass: 'dialog-cyjd-container none-close',
                                buttons: [{
                                    text: '确定',
                                    'class': 'btn btn-sm btn-primary',
                                    click: function () {
                                        $(this).dialog('close');
                                    }
                                }]
                            });
                            $('#yzm').val('');
                            countDownNumber = -1;
                        })
                    }
                });
            } else {
                $dialogEditPhone.dialog("open");

            }
        });


        //获取验证码
        $(document).on('click', 'button.getVeri', function (e) {
            var $phoneNumberForm = $('#phoneNumberForm');
            var $formControlPhone = $phoneNumberForm.find('.form-control-phone');
            var xhrYzm;
            var $btn = $(this);
            if (phoneNumberValidate.element('.form-control-phone')) {
                $(this).prop('disabled', true);
                //执行倒计时
                xhrYzm = $.post('/f/mobile/sendMobileValidateCode', {mobile: $formControlPhone.val()});
                xhrYzm.success(function () {
                    countDown()
                });
                xhrYzm.error(function () {
                    $btn.prop('disabled', false);
                    dialogCyjd.createDialog(0, "验证码请求失败", {
                        dialogClass: 'dialog-cyjd-container none-close',
                        buttons: [{
                            text: '确定',
                            'class': 'btn btn-sm btn-primary',
                            click: function () {
                                $(this).dialog('close');
                            }
                        }]
                    });
                })
            }
        });
        //倒计时
        function countDown() {
            var $phoneNumberForm = $('#phoneNumberForm');
            var $getVeri = $phoneNumberForm.find('.getVeri');
            if (countDownNumber < 0) {
                $getVeri.prop('disabled', false).text('获取验证码');
                countDownNumber = 60;
                clearTimeout(timer);
            } else {
                $getVeri.prop('disabled', true).text(countDownNumber + '秒');
                timer = setTimeout(countDown, 1000);
                countDownNumber--;
            }
        }

        //请求验证手机号
        function xhrPhoneNumber() {
            var $phoneNumberForm = $('#phoneNumberForm');
            var $formControlPhone = $phoneNumberForm.find('.form-control-phone');
            var $formControlYzm = $phoneNumberForm.find('.form-control-yzm');
            var xhr = $.post('/f/sys/frontStudentExpansion/updateMobile', {
                mobile: $formControlPhone.val(),
                yzm: $formControlYzm.val()
            });

            xhr.error(function (error) {
                console.log(error);
            });
            return xhr;
        }

        //create 并 show 弹出框
        function createPrompt(submit, cancel) {
            $dialogContentPhone.css('line-height', '1');
            $dialogEditPhone.dialog({
                modal: true,
                resizable: false,
                width: 400,
                title: '修改手机号',
                classes: {
                    "ui-dialog": "ui-prompt"
                },
                buttons: [{
                    text: '确定',
                    click: function (e) {
                        submit && submit(e, $(this))
                    }
                }, {
                    text: '取消',
                    click: function (e) {
                        countDownNumber = -1;
                        $('#mobile').val('');
                        $('#yzm').val('');
                        phoneNumberValidate.resetForm();
                        $(this).dialog('close')
                    }
                }]
            })
        }


        $dialogEditPhone.on('dialogopen', function () {
            var $mobile = $('input[name="mobile"]')
            $mobile.val($('#editMobileNum').next().text())
            $dialogEditPhone.removeClass('hide');
            $mobile.trigger('input propertychange');
        });

        $dialogEditPhone.on('dialogclose', function () {
            $dialogEditPhone.addClass('hide')
        });

        //初始化手机按钮文字
        function initEditMobileText() {
            var hasPN = hasPhoneNumber();
            var text = hasPN ? '更新' : '绑定手机号';
            $editMobileNum.text(text);
        }

        //修改手机号
        function changePhoneNum(number) {
            $phoneFormControlStatic.text(number);
        }

        //判断是否有手机号
        function hasPhoneNumber() {
            var number = $.trim($editMobileNum.next().text());
            return typeof number != 'undefined' && number != '';
        }

        // 手机号码验证
        jQuery.validator.addMethod("isMobileNumber", function (value, element) {
            var length = value.length;
            var mobile = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
            return this.optional(element) || (length == 11 && mobile.test(value));
        }, "请正确填写您的手机号码");
    });
</script>
</body>
</html>