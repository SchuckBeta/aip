<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <%--<meta name="decorator" content="site-decorator"/>--%>
    <title>管理门户-导师库详情</title>
    <script type="text/javascript">
    $frontOrAdmin="${frontOrAdmin_2ed8fe6ddd034cffa47a41e42a694948}";
    </script>
    <link rel="stylesheet" type="text/css" href="/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="/common/common-css/pagenation.css"/>
    <link rel="stylesheet" type="text/css" href="/common/common-css/backtable.css"/>
    <link rel="stylesheet" type="text/css" href="/css/backTeacherForm.css">
    <link href="/css/excellent/lessonProjectEditCommon.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="/other/jquery-ui-1.12.1/jquery-ui.js"/>
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.css"/>
    <script type="text/javascript" src="${ctxStatic}/jquery/jquery-1.8.3.min.js"></script>
    <%--<script src="/other/jquery-ui-1.12.1/jquery-ui.js" type="text/javascript" charset="utf-8"></script>--%>
    <%--<script src="/js/frontCyjd/frontCommon.js"></script>--%>
    <script type="text/javascript" src="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.js"></script>
    <link href="${ctxStatic}/jquery-jbox/2.3/Skins/Bootstrap/jbox.min.css" rel="stylesheet"/>
    <script src="${ctxStatic}/jquery-jbox/2.3/jquery.jBox-2.3.min.js" type="text/javascript"></script>
    <script src="${ctxStatic}/common/initiate.js" type="text/javascript"></script>
    <script type="text/javascript" src="${ctxStatic}/My97DatePicker/WdatePicker.js"></script>
    <script src="${ctxStatic}/bootstrap/2.3.1/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="/js/common.js"  type="text/javascript"></script>

    <style>
        .header, .footerBox {
            display: none;
        }
        .row-keyword .keyword{
            border-radius: 5px;
            border: 1px solid #e9432d;
            background-color: transparent;
        }
        .row-keyword .keyword > span{
            color: #e9432d;
            vertical-align: top;
        }
        .row-keyword .delete-keyword{
            display: block;
            width: 16px;
            height: 16px;
            opacity: 1;
            background: url("/images/testCert/unchecked.gif") no-repeat center;
        }
    </style>

    <!--套用页面取本地字体文件-->
    <script type="text/javascript">
        var validate;
        $(document).ready(function () {
            var loginMsssage = $("#loginMsssage").val();
            if (loginMsssage != null && loginMsssage != "") {
                showModalMessage(0, loginMsssage, {
                    确定: function () {
                        $(this).dialog("close");
                    }
                });
                return false;
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
                    url: "${ctx}/sys/office/findProfessionals",
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
            //校验初始化
            validate = $("#inputForm").validate({
                rules: {
                    "user.mobile": {
                        phone_number: true,//自定义的规则
                        remote: {
                            async: false,
                            url: "${ctx}/sys/user/checkMobile",     //后台处理程序
                            type: "get",               //数据发送方式
                            dataType: "json",           //接受数据格式
                            data: {                     //要传递的数据
                                mobile: function () {
                                    return $("input[name='user.mobile']").val();
                                },
                                id: function () {
                                    return $("#userid").val();
                                }
                            }
                        }
                    },
                    "user.no": {
                        numberLetter : true,
                        remote: {
                            async: false,
                            url: "/a/sys/user/checkNo",     //后台处理程序
                            type: "post",               //数据发送方式
                            dataType: "json",           //接受数据格式
                            data: {                     //要传递的数据
                            	userid : "${backTeacherExpansion.user.id}",
                                no : function () {
                                    return $("input[name='user.no']").val();
                                }
                            }
                        }
                    }
                },
                messages: {
                    "user.mobile": {
                        phone_number: "请输入正确的手机号码",
                        remote: "手机号已存在"
                    },
                    "user.no": {
                        remote: "该职工号已被占用"
                    }
                },
                errorPlacement: function (error, element) {
                	if($(element).attr("type")=="checkbox"||$(element).attr("type")=="radio"){
                		error.appendTo($(element).parent().parent());
                	}else{
                    	error.insertAfter(element);
                	}
                }
             });

            //添加自定义验证规则
            jQuery.validator.addMethod("phone_number", function (value, element) {
                var length = value.length;
                return this.optional(element) || (length == 11 && mobileRegExp.test(value));
            }, "手机号码格式错误");

            jQuery.validator.addMethod("numberLetter", function (value, element) {
                var length = value.length;
                return  this.optional(element) ||numberLetterExp.test(value);
            }, "只能输入数字和字母");
            jQuery.validator.addMethod("isIdCardNo", function (value, element) {
                return this.optional(element) || IDCardExp.test(value);
            }, "身份证号码不正确");
            
            
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
            var $teacherType = $("select[name='teachertype']");
            var formsRequired = [ 'serviceIntentionIds','idType','user.sex','user.no','papersNumber','user.mobile', 'educationType', 'user.education', 'user.email'];


            $teacherType.on('change', function () {
                var val = $(this).val();
                if (val == 2) {
                    removeRules();
                } else {
                    addMobileRule();
                }
            });
            $teacherType.trigger('change');
            $("input[name='serviceIntentionIds']").on('click', function () {
            	serviceIntentionChange();
            });
            function serviceIntentionChange(){
            	if($("input[name='serviceIntentionIds'][value='4']:checked").length==1){
            		$("#categorydiv").show();
            	}else{
            		$("#categorydiv").hide();
            		$("#category").val("");
            	}
            }
            serviceIntentionChange();
            
            function addMobileRule() {
                $.each(formsRequired, function (k, v) {
                	if(v=="papersNumber"){
                	    if ($('select[name="user.idType"]').val() == "1") {
                	        $('input[name="user.idNumber"]').rules("add", {isIdCardNo: true});
                	    }else{
                	    	$('input[name="user.idNumber"]').rules('add', {required: true});
                	    }
            	        $('label[for="' + v + '"]').find('i').removeClass('hide');

                	}else if(v=="serviceIntentionIds"){
                		$('[name="' + v + '"]').rules('add', {required: true});
        	            $('label[for="' + v + '"]').find('i').removeClass('hide');
                	}else{
        	            $('[id="' + v + '"]').rules('add', {required: true});
        	            $('label[for="' + v + '"]').find('i').removeClass('hide');
                	}
                })
            }

            function removeRules() {
                $.each(formsRequired, function (k, v) {
                	if(v=="serviceIntentionIds"){
               		 	$('label[for="' + v + '"]').find('i').addClass('hide');
         	            $('[name="' + v + '"]').rules('remove');
         	            $('[name="' + v + '"]').removeClass('error');
         	           	$('label[for="' + v + '"]').next().find('.error').remove();
                	}else{
        	            $('label[for="' + v + '"]').find('i').addClass('hide');
        	            $('[id="' + v + '"]').rules('remove');
        	            $('[id="' + v + '"]').removeClass('error');
        	            $('[id="' + v + '"]').next().remove();
                	}
                })
            }
        });

        function saveform() {
            if (validate.form()) {  //表单提交 调用校验
                $("#inputForm").submit();
            }
        }
        
    </script>
    <style>
        .form-search input, select{
            max-width: none;
        }
        .info-card .user-label-control{
            width: 100px;
        }
        .info-card .user-val{
            margin-left: 100px;
        }
        .info-card .user-label-control{
            width: 100px;
        }
        .info-card .user-val{
            margin-left: 100px;
        }
    </style>
</head>

<body>
<div id="dialog-message" title="信息" style="display: none;">
    <p id="dialog-content"></p>
</div>
<div class="container" role="main">
    <div class="edit-bar clearfix" style="margin-top:10px ">
        <div class="edit-bar-left">
            <span>导师库</span>
            <i class="line"></i>
        </div>
    </div>
    <c:if test="${not empty message}">
		<c:if test="${not empty type}"><c:set var="ctype" value="${type}"/></c:if>
		<c:if test="${empty type}"><c:set var="ctype" value="${fn:indexOf(message,'失败') eq -1?'success':'error'}"/></c:if>
		<div class="alert alert-${ctype}"><button data-dismiss="alert" class="close">×</button>${message}</div>
	</c:if>
    <div style="text-align: right">
        <input id="savebtn" type="button" value="保存"onclick="saveform()" class="btn btn-md btn-save"
               style="margin-right: 5px;"/>
        <input id="btnCancel" class="btn" type="button" value="返 回" onclick="javascript:location.href='/a/sys/backTeacherExpansion'"/>
    </div>
    <sys:frontTestCut width="200" height="200" btnid="upload" imgId="fileId" column="user.photo"  filepath="user"  className="modal-avatar"></sys:frontTestCut>
    <form:form id="inputForm" modelAttribute="backTeacherExpansion" action="${ctx}/sys/backTeacherExpansion/save"
               cssClass="form-horizontal">
    <div class="row">
        <div class="left-aside">
            <div class="user-info">
                <!--导师个人信息-->
                <div class="user-inner">
                    <!--导师图像 -->
                    <div class="user-pic">
                        <input type="file" style="display: none" id="fileToUpload" name="fileName"/>
                        <div class="img-content" style="background:none;">
                            <c:choose>
                                <c:when test="${backTeacherExpansion.user.photo!=null && backTeacherExpansion.user.photo!='' }">
                                    <img class="user-img" src="${fns:ftpImgUrl(backTeacherExpansion.user.photo) }" id="fileId">
                                </c:when>
                                <c:otherwise>
                                    <img class="user-img" src="/img/u4110.png" id="fileId">
                                </c:otherwise>
                            </c:choose>
                        </div>

                                <div class="up-content">
                                    <input type="button" id="upload"  class="btn" style="" value="更新照片" />
                                    <span style="color:red;font-size: 12px;"></span>
                                </div>

                    </div>
                    <div class="user-like">
                        <div class="user-lk-item">
                            浏览量：<span>${backTeacherExpansion.user.views}</span>
                        </div>
                        <div class="user-lk-item">
                            点赞数：<span>${backTeacherExpansion.user.likes}</span>
                        </div>
                    </div>
                    <%--<div class="user-project-panels">--%>
                        <%--<ul class="user-panel">--%>
                            <%--<li><label>在研指导项目：</label><span>基于百度地图的武汉老地名查询系统的开发</span></li>--%>
                            <%--<li><label>项目开始时间：</label><span>2017.3.5</span></li>--%>
                          <%--&lt;%&ndash;  <li><label>项目进度：</label><span>50%</span></li>&ndash;%&gt;--%>
                        <%--</ul>--%>
                    <%--</div>--%>
                </div>
            </div>
        </div>
        <div class="user-info-content clearfix">
            <div class="user-info-form">
                <p class="ud-title">基本信息</p>

                    <input type="hidden" id="userid" value="${backTeacherExpansion.user.id }"/>
                    <form:hidden path="id"/>

                    <form:hidden id="bu-summary" path="team.summary"/>
                    <input type="hidden" id="loginMessage" value="${loginNameMessage }"/>
                    <div class="row">
                    	<div class="col-md-4">
                            <div class="form-group">
                                <label for="teacherType" class="control-label"><i class="icon-require">*</i>导师来源：</label>
                                <div class="input-box">
                                    <form:select id="teacherType" path="teachertype" cssClass="form-control required">
                                        <form:option value="" label="无"/>
                                        <form:options items="${fns:getDictList('master_type')}" itemLabel="label"
                                                      itemValue="value" htmlEscape="false"/>
                                    </form:select>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="teacherName" class="control-label"><i class="icon-require">*</i>姓名：</label>
                                <div class="input-box">
                                    <form:input id="teacherName" path="user.name" htmlEscape="false"
                                                cssClass="form-control required"
                                                type="text"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="user.no" class="control-label"><i class="icon-require">*</i>职工号：</label>
                                <div class="input-box">
                                    <form:input type="text" path="user.no" htmlEscape="false"
                                                class="form-control" placeholder=""/>
                                </div>
                            </div>
                        </div>
                        
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="user.sex" class="control-label"><i class="icon-require">*</i>性别：</label>
                                <div class="input-box">
                                    <form:select path="user.sex" class="form-control">
                                    	<form:option value="" label="无"/>
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
                                 <label for="user.mobile" class="control-label"><i class="icon-require">*</i>手机号：</label>
                                 <div class="input-box">
                                     <form:input path="user.mobile" type="text" htmlEscape="false"
                                                 class="form-control"/>
                                 </div>
                             </div>
                        </div>
                    </div>
                    <div class="row">
                    	<div class="col-md-12">
                            <div class="form-group">
                                <label for="serviceIntentionIds" class="control-label"><i class="icon-require">*</i>服务意向：</label>
                                <div class="input-box">
                                    <form:checkboxes path="serviceIntentionIds" items="${fns:getDictList('master_help')}"
                                                     itemLabel="label" itemValue="value"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                    	<div class="col-md-4" id="categorydiv">
                            <div class="form-group">
                            	<label class="control-label"><i class="icon-require">*</i>导师类型：</label>
                                    <div class="input-box">
                                        <form:select id="category" path="category"
                                                 class="form-control required">
                                        <form:option value="" label="无"/>
                                        <form:options items="${fns:getDictList('0000000215')}"
                                                      itemLabel="label" itemValue="value" htmlEscape="false"/>
                                    </form:select>
                                    </div>
                    		</div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="idType" class="control-label"><i class="icon-require">*</i>证件类型：</label>
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
                                <label for="papersNumber" class="control-label"><i class="icon-require">*</i>证件号：</label>
                                <div class="input-box">
                                    <form:input id="papersNumber" type="text" path="user.idNumber" htmlEscape="false"
                                                class="form-control"
                                    />
                                </div>
                            </div>
                        </div>
                        
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="educationType" class="control-label"><i class="icon-require">*</i>学历类别：</label>
                                <div class="input-box">
                                    <form:select id="educationType" path="educationType"
                                                 class="form-control">
                                        <form:option value="" label="无"/>
                                        <form:options items="${fns:getDictList('enducation_type')}"
                                                      itemLabel="label" itemValue="value" htmlEscape="false"/>
                                    </form:select>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="user.education" class="control-label"><i class="icon-require">*</i>学历：</label>
                                <div class="input-box">
                                    <form:select path="user.education"
                                                 class="form-control">
                                        <form:option value="" label="无"/>
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
                                        <form:option value="" label="无"/>
                                        <form:options
                                                items="${fns:getDictList('professional_type')}"
                                                itemLabel="label" itemValue="value" htmlEscape="false"/>
                                    </form:select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="user.degree" class="control-label">学位类别：</label>
                                <div class="input-box">
                                    <form:select path="user.degree"
                                                 class="form-control">
                                        <form:option value="" label="无"/>
                                        <form:options items="${fns:getDictList('degree_type')}"
                                                      itemLabel="label" itemValue="value" htmlEscape="false"/>
                                    </form:select>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                            	<label for="collegeId" class="control-label">院系名称：</label>
                                            <div class="input-box">
                                                <form:select path="user.office.id"
                                                             class="input-xlarge form-control"
                                                             id="collegeId">
                                                    <form:option value="" label="--请选择--"/>
                                                    <form:options items="${fns:findColleges()}" itemLabel="name"
                                                                  itemValue="id" htmlEscape="false"/>
                                                </form:select>
                                            </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="user.professional" class="control-label">专业：</label>
                                            <div class="input-box">
                                                <form:select path="user.professional"
                                                             class="input-xlarge form-control">
                                                    <form:option value="" label="--请选择--"/>
                                                </form:select>
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
                                    <form:input  path="postTitle" htmlEscape="false" class="form-control"
                                    />
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="technicalTitle" class="control-label">职称：</label>
                                <div class="input-box">
                                <form:input  path="technicalTitle" htmlEscape="false" class="form-control" />
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
                                    <form:input id="bankAccount" type="text" path="bankAccount" htmlEscape="false" maxlength="19" minlength="16"
                                                class="form-control number"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="user.email" class="control-label"><i class="icon-require">*</i>邮箱：</label>
                                <div class="input-box">
                                   <form:input  type="text" path="user.email" htmlEscape="false"
                                               class="form-control"/>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="row">
                    	<div class="col-md-4">
                            <div class="form-group">
                                <label class="control-label">单位类别：</label>
                              <div class="input-box">
                                  <form:select id="workUnitType" path="workUnitType"
                                           class="form-control">
                                  <form:option value="" label="无"/>
                                  <form:options items="${fns:getDictList('0000000218')}"
                                                itemLabel="label" itemValue="value" htmlEscape="false"/>
                              	</form:select>
                              </div>
                            </div>
                        </div>
                    	<div class="col-md-4">
                            <div class="form-group">
                                <label for="companyAdr" class="control-label">工作单位：</label>
                                <div class="input-box">
                                    <form:input id="companyAdr" type="text" path="workUnit" htmlEscape="false"
                                                class="form-control"/>
                                </div>
                            </div>
                        </div>
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
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="firstShow" class="control-label">首页展示：</label>
                                <div class="input-box">
                                    <form:select path="firstShow" class="input-xlarge form-control">
                                           <form:option value="" label="无"/>
                                           <form:options items="${fns:getDictList('yes_no')}"
                                                         itemLabel="label" itemValue="value" htmlEscape="false"/>
                                     </form:select>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="siteShow" class="control-label">栏目展示：</label>
                                <div class="input-box">
                                    <form:select path="siteShow" class="input-xlarge form-control">
                                           <form:option value="" label="无"/>
                                           <form:options items="${fns:getDictList('yes_no')}"
                                                         itemLabel="label" itemValue="value" htmlEscape="false"/>
                                     </form:select>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                    <label for="topShow" class="control-label">风采展示：</label>
                                    <div class="input-box">
                                        <form:select path="topShow" class="input-xlarge form-control">
                                            <form:option value="" label="无"/>
                                            <form:options items="${fns:getDictList('yes_no')}"
                                                            itemLabel="label" itemValue="value" htmlEscape="false"/>
                                        </form:select>
                                    </div>
                                </div>
                            </div>

                    </div>

                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label for="user.domainIdList" class="control-label">技术领域：</label>
                                <div class="input-box">
                                    <form:checkboxes path="user.domainIdList" items="${allDomains}" itemLabel="label" itemValue="value"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group" style="margin-bottom: 5px">
                                <label class="control-label">关键词：</label>
                                <div class="input-box">
                                    <input type="text" class="form-control form-keyword" style="max-width: 300px" id="formKeyword" autocomplete="off" placeholder="输入关键字按回车键添加">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row row-keyword" style="margin-bottom: 15px!important;">
                        <div class="col-md-2 col-w92" style="width:86px;"></div>
                        <div class="col-md-9 col-offset-md-2 col-offset-w92 col-keyword-box" style="margin-left: 96px;">
                            <c:forEach items="${tes}" var="item" >
                                <span class="keyword">
                                    <input name="keywords" value="${item.keyword}" type="hidden"/>
                                    <span>${item.keyword}</span>
                                    <a class="delete-keyword" href="javascript:void(0);" onclick="delKey(this);"></a>
                                </span>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label for="experience" class="control-label">工作简历：</label>
                                <div class="input-box">
                                    <textarea id="experience" placeholder="" name="mainExp" class="form-control" rows="4">${backTeacherExpansion.mainExp}
                                    </textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="user-details-info">
                     <div class="user-detail-group">
                         <div class="ud-inner">
                             <p class="ud-title">指导项目</p>
                             <div class="info-cards">
                                 <c:forEach items="${projectExpVo}" var="projectExp">
                                 <div class="info-card">
                                     <p class="info-card-title"><c:if test="${projectExp.finish==0 }"><span style="color: #e9432d;">【进行中】</span></c:if>${projectExp.proName}</p>
                                     <div class="row">
                                         <div class="col-sm-12">
                                             <div class="ic-box">
                                                 <label class="user-label-control">项目周期：</label>
                                                 <div class="user-val">
                                                     <fmt:formatDate value="${projectExp.startDate }" pattern="yyyy/MM/dd" />
                                                     -
                                                     <fmt:formatDate value="${projectExp.endDate }" pattern="yyyy/MM/dd" />
                                                 </div>
                                             </div>
                                         </div>
                                         <div class="col-sm-6">
                                             <div class="ic-box">
                                                 <label class="user-label-control">项目名称：</label>
                                                 <div class="user-val"> ${projectExp.name }</div>
                                             </div>
                                         </div>
                                        <div class="col-md-6">
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
                                                 <label class="user-label-control">项目级别：</label>
                                                 <div class="user-val"> ${projectExp.level }</div>
                                             </div>
                                         </div>
                                         <div class="col-md-6">
                                             <div class="ic-box">
                                                 <label class="user-label-control">项目结果：</label>
                                                 <div class="user-val">
                                                         ${projectExp.result }
                                                 </div>
                                             </div>
                                         </div>
                                     </div>
                                 </div>
                                 </c:forEach>
                             </div>
                             <p class="ud-title">指导大赛</p>
                             <div class="info-cards">
                                 <c:forEach items="${gContestExpVo}" var="gContest">
                                 <div class="info-card info-match">
                                     <p class="info-card-title"><c:if test="${gContest.finish==0 }"><span style="color: #e9432d;">【进行中】</span></c:if>${gContest.type}</p>
                                     <div class="row">
                                         <div class="col-md-6">
                                             <div class="ic-box">
                                                 <label class="user-label-control">参赛项目名称：</label>
                                                 <div class="user-val">
                                                         ${gContest.pName }
                                                 </div>
                                             </div>
                                         </div>
                                         <div class="col-sm-6">
                                             <div class="ic-box">
                                                 <label class="user-label-control">参赛时间：</label>
                                                 <div class="user-val"><fmt:formatDate value="${gContest.createDate }"  pattern="yyyy/MM/dd" /></div>
                                             </div>
                                         </div>
                                         
										<div class="col-md-6">
                                             <div class="ic-box">
                                                 <label class="user-label-control">担任角色：</label>
                                                 <div class="user-val">
                                                 	<c:if test="${cuser==gContest.leaderId}">项目负责人</c:if>
                                                 	<c:if test="${cuser!=gContest.leaderId&&gContest.userType=='1'}">组成员</c:if>
                                                 	<c:if test="${cuser!=gContest.leaderId&&gContest.userType=='2'}">导师</c:if>
                                                 </div>
                                             </div>
                                         </div>
                                         <div class="col-md-6">
                                             <div class="ic-box">
                                                 <label class="user-label-control">获奖情况：</label>
                                                 <div class="user-val">
                                                   ${gContest.award}
                                                 </div>
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
        </div>
    </div>
    </form:form>
</div>
<script type="text/javascript" src="/js/user/keywordEditT.js"></script>
</body>
</html>