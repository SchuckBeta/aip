<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <%--<meta name="decorator" content="site-decorator"/>--%>
    <title>${backgroundTitle}</title>
    <script type="text/javascript">
    $frontOrAdmin="${frontOrAdmin_2ed8fe6ddd034cffa47a41e42a694948}";
    </script>
    <link rel="stylesheet" type="text/css" href="/common/common-css/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="/static/bootstrap/2.3.1/awesome/font-awesome.min.css">
    <link rel="stylesheet" type="text/css"  href="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.css"/>
    <link rel="stylesheet" type="text/css" href="/css/dialog/alert-dialog.css">
    <link rel="stylesheet" type="text/css" href="/other/jquery-ui-1.12.1/jquery-ui.css?v=2"/>
    <link rel="stylesheet" type="text/css" href="/css/pagination.css">


    <!--无用css-->
    <%--<link rel="stylesheet" type="text/css" href="/common/common-css/common.css"/>--%>

    <link rel="stylesheet" type="text/css" href="/css/common.css?v=1"/>
    <link rel="stylesheet" type="text/css" href="/css/index.css"/>
    <!--focus样式表-->
    <link rel="stylesheet" type="text/css" href="/common/common-css/focustyle.css"/>
    <!--头部导航公用样式-->
    <link rel="stylesheet" type="text/css" href="/common/common-css/header.css"/>



    <script src="${ctxStatic}/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.js" type="text/javascript"></script>

    <script src="/js/template.js" type="text/javascript"></script>
    <script src="/other/jquery-ui-1.12.1/jquery-ui.js" type="text/javascript" charset="utf-8"></script>
    <script src="/common/common-js/bootstrap.min.js" type="text/javascript"></script>
    <!--用于轮播的js-->
    <script src="/common/common-js/jquery.SuperSlide.2.1.1.js" type="text/javascript"></script>
    <!--文本溢出-->
    <script type="text/javascript" src="/js/team/mock-min.js"></script>
    <script src="${ctxStatic}/common/initiate.js" type="text/javascript"></script>
    <script src="/js/common.js?v=1" type="text/javascript"></script>

    <link rel="stylesheet" type="text/css" href="/css/seers.css">
    <link rel="stylesheet" type="text/css" href="/css/studentForm.css">
    <script src="${ctxStatic}/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <style>
        .form-dialog {
            padding: 0 15px;

        }

        .dialog-content-phone {
            width: 340px;
            min-height: 100px;
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

        .ui-dialog .ui-dialog-buttonpane button {
            padding: 4px 12px;
            margin: 0;
        }

        .ui-dialog .ui-dialog-buttonpane button + button {
            margin-left: .4em;
        }

        .w350 {
            width: 350px;
            margin-right: 30px;
            padding-left: 0;
            padding-right: 0;
        }

        .has-form-control-show {
            margin-left: 0;
            margin-right: 0;
        }

        .has-form-control-show .w350:last-child {
            margin-right: 0;
        }

        button {
            width: auto;
            height: auto;
        }

        .edit-mobile-num {
            float: right;
            margin-right: 16px;
            line-height: 34px;
            color: #333;
        }

        .edit-mobile-num:hover {
            color: #df4526;
        }

        .ui-widget.ui-widget-content.ui-prompt {
            width: auto !important;
            height: auto !important;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            //提示框
            if ("${message}" != "") {
                showModalMessage(1, "${message}", [{
                    text: '确定',
                    click: function () {
                        $( this ).dialog( "close" );
                        if("${message}".indexOf("成功")!=-1&&$("#custRedict").val()=="1"){
                            location.href=$("#okurl").val();
                        }
                    }
                }]);
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
                        if (!data.length) {
                            $userProfessional.removeClass('required').parent().prev().find('i').hide();
                            $userProfessional.next().hide()
                        } else {
                            $userProfessional.addClass('required').parent().prev().find('i').show()
                        }
                        $.each(data, function (i, val) {
                            if (val.id == "${studentExpansion.user.professional}") {
                                $userProfessional.append('<option selected="selected" value="' + val.id + '">' + val.name + '</option>')
                            } else {
                                $userProfessional.append('<option value="' + val.id + '">' + val.name + '</option>')
                            }

                        })
                    }
                });
            });
            $collegeId.trigger('change');

            $(document).scrollTop('0px');

            //添加自定义验证规则
            jQuery.validator.addMethod("numberLetter", function (value, element) {
                var length = value.length;
                return this.optional(element) || numberLetterExp.test(value);
            }, "只能输入数字和字母");

            jQuery.validator.addMethod("isIdCardNo", function (value, element) {
                return this.optional(element) || IDCardExp.test(value);
            }, "身份证号码不正确");

            jQuery.validator.addMethod('isQQ', function (value, element) {
                return this.optional(element) || (/^[1-9][0-9]{4,11}$/).test(value);
            }, '不是有效QQ号');

            validate1 = $("#inputForm").validate({
                rules: {
                    "user.mobile": {
                        isMobileNumber: true,//自定义的规则
                        remote: {
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
                    "user.loginName": {
                        remote: {
                            url: "${ctx}/sys/user/checkLoginName",     //后台处理程序
                            type: "post",               //数据发送方式
                            dataType: "json",           //接受数据格式
                            data: {                     //要传递的数据
                                userid: "${studentExpansion.user.id}",
                                loginName: function () {
                                    return $("input[name='user.loginName']").val();
                                }
                            }
                        }
                    },
                    "user.no": {
                        numberLetter: true,
                        remote: {
                            url: "${ctx}/sys/user/checkNo",     //后台处理程序
                            type: "post",               //数据发送方式
                            dataType: "json",           //接受数据格式
                            data: {                     //要传递的数据
                                userid: "${studentExpansion.user.id}",
                                no: function () {
                                    return $("input[name='user.no']").val();
                                }
                            }
                        }
                    }
                },
                messages: {
                    "user.loginName": {
                        remote: "该登录名已被占用"
                    },
                    "user.no": {
                        remote: "该学号已被占用"
                    },
                    "user.mobile": {
                        isMobileNumber: "请输入正确的手机号码",
                        remote: "手机号已存在"
                    }
                },

                errorPlacement: function (error, element) {
                    if (element.is(":radio")) {
                        error.appendTo(element.parent().parent());
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


            //ui-dialog-buttonset
            //我的信息，侧边导航点击哪个调到ui-dialog-buttonset相应视野区
            //用户详情导航注释
            $('#private-list').on('click', 'li', function () {
                $(this).addClass("active").siblings().removeClass();
                var sectionId = $(this).attr('data-id');
                if (!sectionId) {
                    return;
                }
                $(document).scrollTop($('#' + sectionId).offset().top - 100);

            });
        });

        function saveform() {
            if (validate1.form()) {
                $("#inputForm").submit();
            }
        }


        $(function () {
            //手机号修改
            var $editMobileNum = $('#editMobileNum');
            var $dialogEditPhone = $('#dialogEditPhone');
            var phoneNumberValidate = null;
            var countDownNumber = 60;
            var timer = null;
            var $phoneNumberForm = $('#phoneNumberForm');
            var $formControlPhone = $phoneNumberForm.find('.form-control-phone');
            var $formControlYzm = $phoneNumberForm.find('.form-control-yzm');


            phoneNumberValidate = $phoneNumberForm.validate({
                rules: {
                    mobile: {
                        isMobileNumber: true,
                        remote: '${ctx}/sys/user/checkMobileExist'
                    },
                    yzm: {
                        remote: '${ctx}/mobile/checkMobileValidateCode'
                    }
                },
                messages: {
                    mobile: {
                        remote: '该手机号已经注册'
                    },
                    yzm: {
                        remote: '验证码错误'
                    }
                },
                errorPlacement: function (error, element) {
                    error.insertAfter(element)
                }
            });


            $editMobileNum.on('click', function (e) {
                e.preventDefault();
                $dialogEditPhone.dialog({
                    modal: true,
                    resizable: false,
                    width: 400,
                    title: '修改手机号',
                    dialogClass: 'ui-prompt',
                    buttons: [{
                        text: '确定',
                        click: function (e) {
                            var $this = $(this);
                            var $btn = $this.next().find('button:first');
                            var mobile = $formControlPhone.val()
                            if (phoneNumberValidate.form()) {
                                countDownNumber = -1;
                                $btn.prop('disabled', true);
                                var xhr = $.post('${ctx}/sys/frontStudentExpansion/updateMobile', {
                                    mobile: mobile,
                                    yzm: $formControlYzm.val()
                                });
                                xhr.success(function (data) {
                                    phoneNumberValidate.resetForm();
                                    $phoneNumberForm[0].reset();
                                    $formControlPhone.val('')
                                    $formControlYzm.val('');
                                    $editMobileNum.text('更新').next().text(mobile)
                                    $btn.prop('disabled', false);
                                    $this.dialog('close')
                                    showModalMessage(1, '修改成功')
                                })
                            }
                            return false;
                        }
                    }, {
                        text: '取消',
                        click: function (e) {
                            countDownNumber = -1;
                            phoneNumberValidate.resetForm();
                            $phoneNumberForm[0].reset();
                            $formControlPhone.val('')
                            $formControlYzm.val('');
                            $(this).dialog('close')
                        }
                    }],
                    open: function (event, ui) {
                        $(this).parent().focus();
//                        var mobile = $editMobileNum.next().text();
//                        if(mobile){
//                            $formControlPhone.val(mobile)
//                        }
                    }//取消获取焦点
                })
            });


            //获取验证码
            $(document).on('click', 'button.getVeri', function (e) {
                var $phoneNumberForm = $('#phoneNumberForm');
                var $formControlPhone = $phoneNumberForm.find('.form-control-phone');
                var xhrYzm;
                var $btn = $(this);
                if ($formControlPhone.val() == $editMobileNum.next().text()) {
                    showModalMessage(0, '号码未发生改变');
                    return false;
                }
                if (phoneNumberValidate.element('.form-control-phone')) {
                    $(this).prop('disabled', true);
                    //执行倒计时
                    xhrYzm = $.post('${ctx}/mobile/sendMobileValidateCode', {mobile: $formControlPhone.val()});
                    xhrYzm.success(function () {
                        countDown()
                    });
                    xhrYzm.error(function () {
                        $btn.prop('disabled', false);
                        showModalMessage(0, '验证码请求失败')
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


            // 手机号码验证
            jQuery.validator.addMethod("isMobileNumber", function (value, element) {
                var length = value.length;
                return this.optional(element) || (length == 11 && mobileRegExp.test(value));
            }, "请正确填写您的手机号码");
        })

    </script>

</head>

<body>

<div class="container">
    <div class="edit-bar clearfix" style="margin: 15px 0">
        <div class="edit-bar-left">
            <span>学生库</span>
            <i class="line" style="border-width: 2px;"></i>
        </div>
    </div>
    <sys:frontTestCut width="200" height="200" btnid="upload" imgId="fileId" column="user.photo" filepath="user"
                      className="modal-avatar"></sys:frontTestCut>
    <form:form id="inputForm" modelAttribute="studentExpansion"
               action="${ctx}/sys/studentExpansion/save" method="post"
               class="form-horizontal">
        <input type="hidden" name="custRedict" id="custRedict" value="${custRedict}"/>
        <input type="hidden" name="okurl" id="okurl" value="${okurl}"/>
        <input type="hidden" name="backurl" id="backurl" value="${backurl}"/>
        <div class="main-content" role="main" style="padding: 0 15px;">
                <input type="hidden" id="userid" value="${studentExpansion.user.id }"/>   <!--图片上传 隐藏域  -->
                <form:hidden path="id" id="studentId"/>
                <div class="left-aside">
                    <div class="user-info">
                        <div class="user-inner">
                            <div class="user-pic">
                                <input type="file" style="display: none" id="fileToUpload" name="fileName"/>
                                <div class="img-content" style="background:none;">
                                    <c:choose>
                                        <c:when test="${user.photo!=null && user.photo!='' }">
                                            <img src="${fns:ftpImgUrl(user.photo) }" id="fileId"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="/img/u4110.png" id="fileId"/>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="up-content">
                                    <input type="button" id="upload" class="btn" style="" value="更新照片"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="user-info-content clearfix">
                    <div class="user-info-form">
                        <div class="row">
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label for="user.loginName" class="control-label"><i
                                            class="icon-require">*</i>登录名：</label>
                                    <div class="input-box">
                                        <form:input type="text" path="user.loginName" maxlength="15"
                                                    htmlEscape="false"
                                                    class="form-control required"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label for="user.name" class="control-label"><i
                                            class="icon-require">*</i>姓名：</label>
                                    <div class="input-box">
                                        <form:input type="text" path="user.name" maxlength="15"
                                                    htmlEscape="false"
                                                    class="form-control required"/>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label class="control-label"><i class="icon-require">*</i>性别：</label>
                                    <div class="input-box">
                                        <form:radiobuttons path="user.sex" items="${fns:getDictList('sex')}"
                                                           itemLabel="label" itemValue="value"
                                                           class="required"/>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label for="user.idType" class="control-label"><i
                                            class="icon-require">*</i>证件类型：</label>
                                    <div class="input-box">
                                        <form:select path="user.idType"
                                                     class="form-control required">
                                            <form:option value="" label="--请选择--"/>
                                            <form:options items="${fns:getDictList('id_type')}"
                                                          itemLabel="label" itemValue="value"
                                                          htmlEscape="false"/>
                                        </form:select>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label for="user.idNumber" class="control-label"><i
                                            class="icon-require">*</i>证件号：</label>
                                    <div class="input-box">
                                        <form:input type="text" path="user.idNumber" htmlEscape="false"
                                                    maxlength="128"
                                                    class="required form-control"/>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label for="user.country" class="control-label">国家/地区：</label>
                                    <div class="input-box">
                                        <form:input type="text" path="user.country"
                                                    htmlEscape="false"
                                                    maxlength="20"
                                                    class="form-control"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label for="user.national" class="control-label">民族：</label>
                                    <div class="input-box">
                                        <form:input path="user.national" htmlEscape="false" maxlength="15"
                                                    type="text"
                                                    class="inputSp form-control"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label class="control-label">
                                        <i class="icon-require">*</i>手机号：
                                    </label>
                                    <div class="input-box">
                                        <form:input path="user.mobile" htmlEscape="false" class="required form-control"/>
                                        <%--<a href="javascript: void(0);" id="editMobileNum"--%>
                                           <%--class="edit-mobile-num">${empty studentExpansion.user.mobile ? '绑定手机号': '更新'}</a>--%>
                                        <%--<p style="height: 34px;  padding: 6px 12px;   line-height: 1.42857143;">${studentExpansion.user.mobile}</p>--%>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label for="user.political" class="control-label">政治面貌：</label>
                                    <div class="input-box">
                                        <form:input path="user.political" type="text" maxlength="15"
                                                    class="inputSp  form-control"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label for="user.email" class="control-label"><i
                                            class="icon-require">*</i>电子邮箱：</label>
                                    <div class="input-box">
                                        <form:input path="user.email" htmlEscape="false"
                                                    type="email"
                                                    maxlength="100"
                                                    class="form-control required"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label for="enterdate" class="control-label">
                                        <i class="icon-require">*</i>入学年份：</label>
                                    <div class="input-box">
                                        <input id="enterdate" name="enterdate" type="text" onchange="changeCurSt()"
                                               maxlength="20"
                                               class="Wdate isTime form-control required"
                                            <%--onclick="WdatePicker({dateFmt:'yyyy',isShowClear:false});"--%>
                                               style="height: 34px;"
                                               readonly="readonly"
                                               value='<fmt:formatDate value="${studentExpansion.enterdate}" pattern="yyyy-MM"/>'
                                        />
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <div class="form-group">
                                    <label for="cycle" class="control-label"><i class="icon-require">*</i>学制(年)：</label>
                                    <div class="input-box">
                                       <form:select path="cycle" onchange="changeCurSt()"
                                             class="required form-control required">
		                                    <form:option value="" label="--请选择--"/>
		                                    <form:options items="${fns:getDictList('0000000262')}"
		                                                  itemLabel="label" itemValue="value"
		                                                  htmlEscape="false"/>
		                                </form:select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row user-info-form">
                	<div class="col-xs-4">
                                <div class="form-group">
                                    <label for="user.email" class="control-label">QQ：</label>
                                    <div class="input-box">
                                        <form:input path="user.qq" htmlEscape="false" type="text"
                                                    maxlength="255" class="number isQQ form-control"/>
                                    </div>
                                </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label for="user.birthday" class="control-label">出生年月：</label>
                            <div class="input-box">
                                <input id="user.birthday" name="user.birthday" type="text"
                                       maxlength="20"
                                       class="Wdate isTime form-control"
                                       style="height: 34px;"
                                    <%--onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"--%>
                                       readonly
                                       value='<fmt:formatDate value="${studentExpansion.user.birthday}" pattern="yyyy-MM-dd"/>'
                                />
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label for="address" class="control-label">联系地址：</label>
                            <div class="input-box">
                                <form:input type="text" path="address" htmlEscape="false"
                                            class="form-control"/>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row user-info-form">
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label for="collegeId" class="control-label"><i
                                    class="icon-require">*</i>院系名称：</label>
                            <div class="input-box">
                                <form:select path="user.office.id"
                                             class="required form-control"
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
                            <label for="user.professional" class="control-label"><i
                                    class="icon-require">*</i>专业：</label>
                            <div class="input-box">
                                <form:select path="user.professional"
                                             class="form-control">
                                    <form:option value="" label="--请选择--"/>
                                </form:select>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <label for="currState" class="control-label">
                                <i class="icon-require">*</i>现状：
                            </label>
                            <div class="input-box">
                                <form:select path="currState" oldv="${studentExpansion.currState}"
                                             class="required form-control">
                                    <form:option value="" label="--请选择--"/>
                                    <form:options items="${fns:getDictList('current_sate')}"
                                                  itemLabel="label" itemValue="value"
                                                  htmlEscape="false"/>
                                </form:select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row user-info-form">
                    <div class="col-xs-4 w350">
                        <div class="form-group">
                            <label for="instudy" class="control-label">在读学位：</label>
                            <div class="input-box">
                                <form:select path="instudy"
                                             class=" form-control instudyForm">
                                    <form:option value="" label="--请选择--"/>
                                    <form:options items="${fns:getDictList('degree_type')}"
                                                  itemLabel="label" itemValue="value"
                                                  htmlEscape="false"/>
                                </form:select>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4 w350">
                        <div class="form-group">
                            <label for="user.education" class="control-label">学历：</label>
                            <div class="input-box">
                                <form:select path="user.education"
                                             class="form-control userEducationForm">
                                    <form:option value="" label="--请选择--"/>
                                    <form:options items="${fns:getDictList('enducation_level')}"
                                                  itemLabel="label" itemValue="value"
                                                  htmlEscape="false"/>
                                </form:select>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4 w350">
                        <div class="form-group">
                            <label for="user.degree" class="control-label">学位：</label>
                            <div class="input-box">
                                <form:select id="user.degree" path="user.degree"
                                             class="form-control userDegreeForm">
                                    <form:option value="" label="--请选择--"/>
                                    <form:options items="${fns:getDictList('degree_type')}"
                                                  itemLabel="label" itemValue="value"
                                                  htmlEscape="false"/>
                                </form:select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row user-info-form">
                    <div class="col-xs-4 w350">
                        <div class="form-group">
                            <label for="graduation" class="control-label">
                                毕业时间：
                            </label>
                            <div class="input-box">
                                <input id="graduation" name="graduation"
                                       class="Wdate  form-control graduationForm" style="height: 34px;"
                                       readonly
                                       value="<fmt:formatDate value='${studentExpansion.graduation}' pattern='yyyy-MM-dd'/>"
                                />
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4 w350">
                        <div class="form-group">
                            <label for="user.no" class="control-label">学号：</label>
                            <div class="input-box">
                                <form:input type="text" path="user.no" htmlEscape="false"
                                            maxlength="15"
                                            class="form-control userNoForm"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-4 w350">
                        <div class="form-group">
                            <label for="tClass" class="control-label">
                                班级：
                            </label>
                            <div class="input-box">
                                <form:input type="text" path="tClass" htmlEscape="false" maxlength="20"
                                            class="form-control tClassForm"/>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row user-info-form">
                    <div class="col-xs-4 w350">
                        <div class="form-group">
                            <label for="temporaryDate" class="control-label">休学时间：</label>
                            <div class="input-box">
                                <input id="temporaryDate" name="temporaryDate"
                                       class="Wdate form-control temporaryDateForm"
                                       style="height: 34px;"
                                       readonly
                                       value="<fmt:formatDate value="${studentExpansion.temporaryDate}" pattern="yyyy-MM-dd"/>"/>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row user-info-form">
                    <div class="col-xs-12">
                        <div class="form-group">
                            <label class="control-label">技术领域：</label>
                            <div class="input-box">
                                <form:checkboxes path="user.domainIdList" items="${allDomains}"
                                                 itemLabel="label" itemValue="value"/>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="edit-bar clearfix">
                    <div class="edit-bar-left">
                        <span>详细信息</span>
                        <i class="line"></i>
                    </div>
                </div>
                <c:if test="${operateType ne '1'}">
                    <div class="ud-inner">
                        <p id="jsProjectExp" class="ud-title">项目经历</p>
                        <div class="info-cards">
                            <c:forEach items="${projectExpVo}" var="projectExp">
                                <div class="info-card">
                                    <p class="info-card-title"><c:if test="${projectExp.finish==0 }"><span
                                            style="color: #e9432d;">【进行中】</span></c:if>${projectExp.proName}</p>
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <div class="ic-box">
                                                <label class="user-label-control">项目周期：</label>
                                                <div class="user-val"><fmt:formatDate
                                                        value="${projectExp.startDate }"
                                                        pattern="yyyy/MM/dd"/>-<fmt:formatDate
                                                        value="${projectExp.endDate }"
                                                        pattern="yyyy/MM/dd"/></div>
                                            </div>
                                        </div>
                                        <div class="col-xs-6">
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
                                        <div class="col-xs-6">
                                            <div class="ic-box">
                                                <label class="user-label-control">项目评级：</label>
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
                        <p id="jsBigExp" class="ud-title">大赛经历</p>
                        <div class="info-cards">
                            <c:forEach items="${gContestExpVo}" var="gContest">
                                <div class="info-card info-match">
                                    <p class="info-card-title"><c:if test="${gContest.finish==0 }"><span
                                            style="color: #e9432d;">【进行中】</span></c:if>${gContest.type}</p>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="ic-box">
                                                <label class="user-label-control">参赛项目名称：</label>
                                                <div class="user-val">
                                                        ${gContest.pName }
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-xs-6">
                                            <div class="ic-box">
                                                <label class="user-label-control">参赛时间：</label>
                                                <div class="user-val"><fmt:formatDate
                                                        value="${gContest.createDate }"
                                                        pattern="yyyy-MM-dd"/></div>
                                            </div>
                                        </div>

                                        <div class="col-xs-6">
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
                </c:if>
                <div class="text-center" style="margin: 60px auto">
                    <button id="btnSubmit" type="button" class="btn btn-primary-oe" onclick="saveform();">保 存</button>
                    <button id="btnCancel" type="button" class="btn btn-default-oe" onclick="history.go(-1)">返 回
                    </button>
                </div>
            </div>
    </form:form>
</div>
<div id="dialogEditPhone" style="display: none">
    <div id="dialogContentPhone" class="dialog-content-phone">
        <form id="phoneNumberForm" class="form-horizontal form-dialog">
            <div class="form-group">
                <div class="col-md-12">
                    <input type="text" id="mobile" autocomplete="off" name="mobile"
                           value="${studentExpansion.user.mobile}"
                           class="form-control form-control-phone required" placeholder="填写手机号">
                </div>
            </div>
            <div class="form-group">
                <div class="col-md-7">
                    <input type="text" id="yzm" autocomplete="off" name="yzm"
                           class="form-control form-control-yzm required number" placeholder="验证码">
                </div>
                <div class="col-md-5">
                    <button type="button" class="btn btn-primary-oe pull-right btn-verification getVeri">获取验证码</button>
                </div>
                <div class="edit-phone-error"></div>
            </div>
        </form>
    </div>
</div>
<script>
	var first=true;
    $(function () {
        $('#graduation, #temporaryDate').on('click', function () {
            var year = $('#enterdate').val()
            WdatePicker({el: $(this).attr('id'), dateFmt:'yyyy-MM-dd',isShowClear:false, minDate: year + '-01-01'});
        })
        $('input[name="user.birthday"]').on('click', function () {
            var year = $('#enterdate').val()
            WdatePicker({el: $(this).attr('id'), dateFmt:'yyyy-MM-dd',isShowClear:false, maxDate: year + '-01-01'});
        })
        $('#enterdate').on('click', function () {
            var temporaryDate = $('#temporaryDate').val()
            var graduation = $('#graduation').val()
            WdatePicker({el: 'enterdate', dateFmt:'yyyy-MM',isShowClear:false, maxDate: graduation || temporaryDate});
        })
    })

    $(function () {
        var currStates = {
            noState: [{
                cls: 'userNoForm', //学号
                require: false,
                show: false
            }, {
                cls: 'instudyForm', //在读学位
                require: false,
                show: false
            }, {
                cls: 'userEducationForm', //学历
                require: false,
                show: false
            }, {
                cls: 'userDegreeForm', //学位
                require: false,
                show: false
            }, {
                cls: 'tClassForm', //班级
                require: false,
                show: false
            }, {
                cls: 'graduationForm', //毕业时间
                require: false,
                show: false
            }, {
                cls: 'temporaryDateForm', //休学时间
                require: false,
                show: false
            }],
            graduation: [{
                cls: 'userNoForm', //学号
                require: false,
                show: true
            }, {
                cls: 'instudyForm', //在读学位
                require: false,
                show: false
            }, {
                cls: 'userEducationForm', //学历
                require: true,
                show: true
            }, {
                cls: 'userDegreeForm', //学位
                require: true,
                show: true
            }, {
                cls: 'tClassForm', //班级
                require: false,
                show: false
            }, {
                cls: 'graduationForm', //毕业时间
                require: true,
                show: true
            }, {
                cls: 'temporaryDateForm', //休学时间
                require: false,
                show: false
            }],
            temporary: [
                {
                    cls: 'userNoForm', //学号
                    require: false,
                    show: true
                }, {
                    cls: 'instudyForm', //在读学位
                    require: false,
                    show: false
                }, {
                    cls: 'userEducationForm', //学历
                    require: true,
                    show: false
                }, {
                    cls: 'userDegreeForm', //学位
                    require: false,
                    show: false
                }, {
                    cls: 'tClassForm', //班级
                    require: false,
                    show: false
                }, {
                    cls: 'graduationForm', //毕业时间
                    require: false,
                    show: false
                }, {
                    cls: 'temporaryDateForm', //休学时间
                    require: true,
                    show: true
                }
            ],
            inSchool: [
                {
                    cls: 'userNoForm', //学号
                    require: true,
                    show: true
                }, {
                    cls: 'instudyForm', //在读学位
                    require: true,
                    show: true
                }, {
                    cls: 'userEducationForm', //学历
                    require: false,
                    show: false
                }, {
                    cls: 'userDegreeForm', //学位
                    require: false,
                    show: false
                }, {
                    cls: 'tClassForm', //班级
                    require: false,
                    show: true
                }, {
                    cls: 'graduationForm', //毕业时间
                    require: false,
                    show: false
                }, {
                    cls: 'temporaryDateForm', //休学时间
                    require: false,
                    show: false
                }
            ]
        };
        var $currState = $('#currState');


        //现状增加change事件，当选择毕业时，毕业时间必填
        $currState.change(function () {
            var value = $(this).val();
            if(!first){
	          	//判断是否符合选项
	            var enterDateStr=$("#enterdate").val();
	    		var cyclev=$("#cycle").val();
	    		if(enterDateStr!=""&&cyclev!=""){
	    			var cycle=$("#cycle").find("option:selected").text(); 
	    			if(isGraduate(enterDateStr,cycle)){//毕业
	    				if(value=="1"||value=="3"){
	   						alertx('选择错误，你已经毕业');
	   						$("#currState").val($(this).attr("oldv"));
	    					return;
	    				}
	    			}else{
	    				if(value=="2"){
	    					alertx('选择错误，你还未毕业');
	    					$("#currState").val($(this).attr("oldv"));
		   					return;
	   					}
	    			}
	    		}
	    		$(this).attr("oldv",value);
            }
            first=false;
            var nVal = parseInt(value);
            var state;
            var stateArr;
            switch (nVal) {
                case 1:
                    state = 'inSchool';
                    break;
                case 2:
                    state = 'graduation';
                    break;
                case 3:
                    state = 'temporary';
                    break;
                default:
                    state = 'noState';
                    break;
            }
            stateArr = currStates[state];
            $.each(stateArr, function (i, item) {
                var cls = item.cls;
                var require = item.require;
                var show = item.show;
                var $ele = $('.' + cls);
                var $parent = $ele.parents('.col-xs-4');
                var $label = $parent.find('label.control-label');
                var $iconHtml = '<i class="icon-require">*</i>';
                var $icon = $label.find('i');
                var text;
                if (show) {
                    $parent.show().addClass('show').addClass('hide');
                    $parent.parent().addClass('has-form-control-show');
                    if (require) {
                        $ele.rules('add', {required: true});
                        text = $label.text();
                        $label.html($iconHtml + text);
                    } else {
                        $ele.rules('remove', 'required');
                        $icon.remove();
                    }
                } else {
                    $parent.hide().addClass('hide').removeClass('show');
                    $ele.rules('remove', 'required');
                    $icon.remove();
                    $parent.find('.form-control').removeClass('error').next('label').remove();
                }
            });

            $('.has-form-control-show').each(function (i, row) {
                var $row = $(row);
                var size = $row.find('.show').length;
                var staticWidth = 317;
                $row.css({
                    'float': 'left',
                    'width': size * staticWidth
                });
            }).siblings().css({
                'left': '',
                'width': ''
            })
        }).change();
    })
	var curDateStr="${curDate}";//当前日期
	var graduateMonth="${graduateMonth}";//学校的毕业月份
	function changeCurSt(){
		var enterDateStr=$("#enterdate").val();
		var cyclev=$("#cycle").val();
		if(enterDateStr!=""&&cyclev!=""){
			var cycle=$("#cycle").find("option:selected").text(); 
			if(isGraduate(enterDateStr,cycle)){//毕业
				$("#currState").val("2");
			}else{
				$("#currState").val("1");
			}
			if($('#currState').attr("oldv")!=$('#currState').val()){
				$('#currState').change();
			}
		}
    }
	function isGraduate(enterDateStr,cycle){
		var enterDate=new Date(enterDateStr+"-01");
		var y=enterDate.getFullYear()+parseInt(cycle);
		var grdate;
		if(graduateMonth!=""){
			grdate=new Date(y+"-"+graduateMonth+"-"+"01");
		}else{
			grdate=new Date(y+"-"+(enterDate.getMonth()+1)+"-"+"01");
		}
		var curDate=new Date(curDateStr);
		return curDate>=grdate;
	}

</script>


</body>
</html>