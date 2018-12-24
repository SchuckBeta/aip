<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="decorator" content="site-decorator"/>
    <title>${frontTitle}</title>
    <link href="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.css" type="text/css" rel="stylesheet"/>
    <link rel="stylesheet" type="text/css" href="/static/bootstrap/2.3.1/awesome/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="/static/stuAndter/stu_teacher_pool.css">
    <link rel="stylesheet" type="text/css" href="/css/seers.css">
    <link rel="stylesheet" type="text/css" href="/css/slide_nav.css">
    <link rel="stylesheet" type="text/css" href="/css/backTeacherForm.css?v=620">
    <script type="text/javascript" src="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.js"></script>
    <script type="text/javascript" src="${ctxStatic}/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="/common/common-js/ajaxfileupload.js"></script>
    <link href="${ctxStatic}/jquery-jbox/2.3/Skins/Bootstrap/jbox.min.css" rel="stylesheet"/>
    <script src="${ctxStatic}/jquery-jbox/2.3/jquery.jBox-2.3.min.js" type="text/javascript"></script>


    <style type="text/css">
        .jbox-body, .jbox-body * {
            box-sizing: content-box;
        }
        textarea{
            resize: none;
        }
        .info-card .user-label-control{
            width: 100px;
        }
        .info-card .user-val{
            margin-left: 100px;
        }
    </style>

    <!--套用页面取本地字体文件-->
    <script type="text/javascript">
        $(document).ready(function (e) {
            if ("${message}" != "") {
                showModalMessage(1, "${message}", null);
            }
            var validate = $("#inputForm").validate({
                rules: {
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
                    },
                },
                messages: {
                    "user.no": {
                        remote: "该职工号已被占用"
                    },
                    'user.mobile': {
                        remote: '手机号已被注册'
                    }
                },
                errorPlacement: function (error, element) {
                    error.insertAfter(element);
                }
            });

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

            var $teacherType = $('select[name="teachertype"]');
            var $saveUserInfo = $('#saveUserInfo');
            var formsRequired = ['userSex', 'idType', 'papersNumber', 'educationType', 'user.education', 'userEmail', 'mobile', 'serviceWish'];


            $teacherType.on('change', function () {
                var val = $(this).val();
                if (val == 2) {
                    removeRules()
                } else {
                    addMobileRule();
                }
            });
            $teacherType.trigger('change');

            $saveUserInfo.on('click', function () {
                if (validate.form()) {  //表单提交 调用校验
                    $("#inputForm").submit();
                }
            });


            function addMobileRule() {
                $('#mobile').rules('add', {
                    required: true,
                    phone_number: true,
                    digits: true,
                    remote: {
                        async: false,
                        url: "${ctx}/sys/user/checkMobile",     //后台处理程序
                        type: "get",               //数据发送方式
                        dataType: "json",           //接受数据格式
                        data: {                     //要传递的数据
                            id: function () {
                                return $("#userid").val();
                            }
                        }
                    }
                });
                $.each(formsRequired, function (k, v) {
                    if (v !== 'mobile') {
                        ($('[id="' + v + '"]')).rules('add', {required: true});
                    }
                    ($('label[for="' + v + '"]')).find('i').removeClass('hide');
                })
            }

            function removeRules() {
                $.each(formsRequired, function (k, v) {
                    $('label[for="' + v + '"]').find('i').addClass('hide');
                    $('[id="' + v + '"]').rules('remove');
                })
            }
        });

    </script>
</head>

<body>
<div class="container" role="main" style="padding-top: 50px; width: 1270px;">
    <div class="edit-bar clearfix">
        <div class="edit-bar-left">
            <span>基本信息</span>
            <i class="line"></i>
        </div>
    </div>
    <div class="row">
        <sys:frontTestCut width="200" height="200" btnid="upload" imgId="fileId" column="user.photo" filepath="user"
                          className="modal-avatar"></sys:frontTestCut>
        <form:form id="inputForm" modelAttribute="backTeacherExpansion" action="${ctx}/sys/frontTeacherExpansion/save"
                   cssClass="form-horizontal">
            <div class="left-aside">
                <div class="user-info">
                    <!--导师个人信息-->
                    <div class="user-inner">
                        <!--导师图像 -->
                        <div class="user-pic">
                            <div class="img-content" style="background:none;">
                                <c:choose>
                                    <c:when test="${backTeacherExpansion.user.photo!=null && backTeacherExpansion.user.photo!='' }">
                                        <img class="user-img" src="${fns:ftpImgUrl(backTeacherExpansion.user.photo) }"
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
                        <div class="user-project-panels">
                            <ul class="user-panel">
                                    <%--<li><label>在研指导项目：</label><span>基于百度地图的武汉老地名查询系统的开发</span></li>--%>
                                    <%--<li><label>项目开始时间：</label><span>2017.3.5</span></li>--%>
                                    <%-- <li><label>项目进度：</label><span>50%</span></li>--%>
                            </ul>
                        </div>
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
            <div class="user-info-content clearfix">
                <div class="user-info-form">

                    <input type="hidden" id="userid" value="${backTeacherExpansion.user.id }"/>
                    <form:hidden path="id"/>

                    <form:hidden id="bu-summary" path="team.summary"/>

                    <input type="hidden" id="loginMsssage" value="${loginNameMessage }"/>
                    <input type="hidden" id="officeId" name="user.office.id"
                           value="${backTeacherExpansion.user.office.id}"/>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="user.no" class="control-label"><i class="icon-require">*</i>职工号：</label>
                                <div class="input-box">
                                    <form:input type="text" path="user.no" htmlEscape="false"
                                                class="form-control" placeholder=""/>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="teacherName" class="control-label"><i class="icon-require">*</i>姓名：</label>
                                <div class="input-box">
                                    <form:input id="teacherName" path="user.name" htmlEscape="false"
                                                cssClass="form-control required" type="text"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="teacherType" class="control-label"><i
                                        class="icon-require">*</i>导师来源：</label>
                                <div class="input-box">
                                    <form:select id="teacherType" path="teachertype" cssClass="form-control required">
                                        <form:option value="" label="--请选择--"/>
                                        <form:options items="${fns:getDictList('master_type')}" itemLabel="label"
                                                      itemValue="value" htmlEscape="false"/>
                                    </form:select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="userSex" class="control-label"><i class="icon-require hide">*</i>性别：</label>
                                <div class="input-box">
                                    <form:select id="userSex" path="user.sex" class="form-control">
                                        <form:options items="${fns:getDictList('sex')}" itemLabel="label"
                                                      itemValue="value"
                                                      htmlEscape="false"/>
                                    </form:select>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="birthday" class="control-label">出生年月：</label>
                                <div class="input-box">
                                    <input id="birthday" name="user.birthday" type="text"
                                           class="form-control"
                                           value="<fmt:formatDate value='${backTeacherExpansion.user.birthday}' pattern='yyyy-MM-dd'/>"
                                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="country" class="control-label">国家/地区：</label>
                                <div class="input-box">
                                    <form:input id="country" type="text" class="form-control" path="user.area"
                                                htmlEscape="false"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="nation" class="control-label">民族：</label>
                                <div class="input-box">
                                    <form:input id="nation" type="text" path="user.national"
                                                class="form-control"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="politicalType" class="control-label">政治面貌：</label>
                                <div class="input-box">
                                    <form:input id="politicalType" type="text" path="user.political"
                                                class="form-control"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="serviceWish" class="control-label"><i
                                        class="icon-require hide">*</i>服务意向：</label>
                                <div class="input-box">
                                    <form:select id="serviceWish" path="serviceIntention"
                                                 class="form-control">
                                        <form:option value="" label="--请选择--"/>
                                        <form:options items="${fns:getDictList('master_help')}"
                                                      itemLabel="label" itemValue="value" htmlEscape="false"/>
                                    </form:select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="idType" class="control-label"><i
                                        class="icon-require hide">*</i>证件类型：</label>
                                <div class="input-box">
                                    <form:select id="idType" path="user.idType"
                                                 class="input-xlarge form-control">
                                        <form:option value="" label="--请选择--"/>
                                        <form:options items="${fns:getDictList('id_type')}"
                                                      itemLabel="label" itemValue="value"
                                                      htmlEscape="false"/>
                                    </form:select>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="papersNumber" class="control-label"><i
                                        class="icon-require hide">*</i>证件号：</label>
                                <div class="input-box">
                                    <form:input id="papersNumber" type="text" path="user.idNumber" htmlEscape="false"
                                                class="form-control"
                                    />
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="companyAdr" class="control-label">工作单位：</label>
                                <div class="input-box">
                                    <form:input id="companyAdr" type="text" path="workUnit" htmlEscape="false"
                                                class="form-control"
                                    />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="educationType" class="control-label"><i
                                        class="icon-require hide">*</i>学历类别：</label>
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
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="user.education" class="control-label"><i
                                        class="icon-require hide">*</i>学历：</label>
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
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="subject" class="control-label">学科门类：</label>
                                <div class="input-box">
                                    <form:select id="subject" path="discipline" class="form-control">
                                        <form:option value="" label="--请选择--"/>
                                        <form:options
                                                items="${fns:getDictList('0000000111')}"
                                                itemLabel="label" itemValue="value" htmlEscape="false"/>
                                    </form:select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
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
                        <div class="col-md-8">
                            <div class="form-group">
                                <label for="professional" class="control-label">学院/专业：</label>
                                <div class="input-box">
                                    <sys:treeselectFrontTeacher id="professional" name="user.professional"
                                                                value="${backTeacherExpansion.user.professional}"
                                                                labelName="professionalName"
                                                                labelValue="${fns:getOffice(backTeacherExpansion.user.professional).name}"
                                                                cssClass="form-control"
                                                                title=""
                                                                allowInput="true"
                                                                url="/sys/office/treeData" hideBtn="true"
                                                                notAllowSelectRoot="true"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="industry" class="control-label">行业：</label>
                                <div class="input-box">
                                    <form:input id="industry" type="text" path="industry" htmlEscape="false"
                                                class="form-control"/>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="postTitle" class="control-label">职务：</label>
                                <div class="input-box">
                                    <form:input id="duty" path="postTitle" htmlEscape="false" class="form-control"
                                    />
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="technicalTitle" class="control-label">职称：</label>
                                <div class="input-box">
                                    <form:select path="technicalTitle"
                                                 class="input-xlarge form-control">
                                        <form:option value="" label="--请选择--"/>
                                        <form:options items="${fns:getDictList('postTitle_type')}"
                                                      itemLabel="label" itemValue="value"
                                                      htmlEscape="false"/>
                                    </form:select>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="userEmail" class="control-label"><i
                                        class="icon-require hide">*</i>邮箱：</label>
                                <div class="input-box">
                                    <form:input id="userEmail" type="text" path="user.email" htmlEscape="false"
                                                class="form-control"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="mobile" class="control-label"><i class="icon-require hide">*</i>手机号：</label>
                                <div class="input-box">
                                    <form:input path="user.mobile" id="mobile" type="text" htmlEscape="false"
                                                class="form-control"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="bank" class="control-label">开户银行：</label>
                                <div class="input-box">
                                    <form:input id="bank" type="text" path="firstBank" htmlEscape="false"
                                                class="form-control"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="bankAccount" class="control-label">账号：</label>
                                <div class="input-box">
                                    <form:input id="bankAccount" type="text" path="bankAccount" maxlength="19" minlength="16" htmlEscape="false"
                                                class="form-control number"/>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="recommendedUnits" class="control-label">推荐单位：</label>
                                <div class="input-box">
                                    <form:input path="recommendedUnits" id="recommendedUnits"
                                                type="text" htmlEscape="false" class="form-control"/>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label for="user.domainIdList" class="control-label">技术领域：</label>
                                    <%--<div class="input-box">
                                        <input type="text" class="form-control" id="territory" placeholder="">
                                    </div>--%>
                                <div class="input-box">
                                    <form:checkboxes path="user.domainIdList" items="${allDomains}"
                                                     itemLabel="label" itemValue="value"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label for="experience" class="control-label">工作经历：</label>
                                <div class="input-box">
                                    <textarea id="experience" placeholder="" name="mainExp" class="form-control"
                                              rows="4">${backTeacherExpansion.mainExp}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div style="text-align: right">
                        <input id="saveUserInfo" type="button" value="保存" class="btn btn-md btn-save"
                               style="margin-right: 5px;"/>
                        <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
                    </div>

                </div>
                <div class="user-details-info">
                    <div class="edit-bar clearfix">
                        <div class="edit-bar-left">
                            <span>详细信息</span>
                            <i class="line"></i>
                        </div>
                    </div>
                    <div class="user-detail-group">
                        <div class="ud-inner">
                            <p class="ud-title">指导项目</p>
                            <div class="info-cards info-comment">
                            <c:forEach items="${projectExpVo}" var="projectExp">
                                <div class="info-card">
                                    <p class="info-card-title"><c:if test="${projectExp.finish==0 }"><span style="color: #e9432d;">【进行中】</span></c:if>${projectExp.proName}</p>
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <div class="ic-box">
                                                <label class="user-label-control">项目周期：</label>
                                                <div class="user-val"><fmt:formatDate value="${projectExp.startDate }" pattern="yyyy/MM/dd"/>-
                                                <fmt:formatDate value="${projectExp.endDate }"
                                                                pattern="yyyy/MM/dd"/></div>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="ic-box">
                                                <label class="user-label-control">项目名称：</label>
                                                <div class="user-val">${projectExp.name}</div>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="ic-box">
                                                <label class="user-label-control">担任角色：</label>
                                                <div class="user-val">
                                                    <c:if test="${cuser==projectExp.leaderId}">项目负责人</c:if>
                                               	<c:if test="${cuser!=projectExp.leaderId&&projectExp.userType=='1'}">组成员</c:if>
                                               	<c:if test="${cuser!=projectExp.leaderId&&projectExp.userType=='2'}">导师</c:if>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="ic-box">
                                                <label class="user-label-control">项目评级：</label>
                                                <div class="user-val">${projectExp.level}</div>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="ic-box">
                                                <label class="user-label-control">项目结果：</label>
                                                <div class="user-val">${projectExp.result }</div>
                                            </div>
                                        </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            <p class="ud-title">指导大赛</p>
                            <div class="info-cards info-comment">
                            <c:forEach items="${gContestExpVo}" var="gContest">
                                <div class="info-card">
                                    <p class="info-card-title"><c:if test="${gContest.finish==0 }"><span style="color: #e9432d;">【进行中】</span></c:if>${gContest.type}</p>
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <div class="ic-box">
                                                <label class="user-label-control">参赛项目名称：</label>
                                                <div class="user-val">${gContest.pName}</div>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="ic-box">
                                                <label class="user-label-control">参赛时间：</label>
                                                <div class="user-val"><fmt:formatDate value="${gContest.createDate }"
                                                                                  pattern="yyyy-MM-dd"/></div>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="ic-box">
                                                <label class="user-label-control">担任角色：</label>
                                                <div class="user-val"><c:if test="${cuser==gContest.leaderId}">项目负责人</c:if>
	                                            <c:if test="${cuser!=gContest.leaderId&&gContest.userType=='1'}">组成员</c:if>
	                                           	<c:if test="${cuser!=gContest.leaderId&&gContest.userType=='2'}">导师</c:if>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
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
            </div>
        </form:form>
    </div>

</div>
</body>
</html>