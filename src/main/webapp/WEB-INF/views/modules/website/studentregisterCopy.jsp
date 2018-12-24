<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="decorator" content="site-decorator"/>
    <%--<link rel="stylesheet" type="text/css" href="/css/studentregister.css?v=2"/>--%>
    <link rel="stylesheet" href="/css/frontCyjd/creatives.css">

    <title>${frontTitle}</title>


</head>
<body>
<!--顶部header公用部分-->
<div id="frontPath" class="hidden">${ctxFront}</div>

<div class="register">
    <div class="wholebox">
        <div class="content">
            <div class="register-matter">
                <p>注册用户</p>
                <div class="register-box">
                    <c:if test="${teacherRegister eq '1'}">
                        <ul class="register-tab">
                            <li id="stu_reg" class="register-acitve" data-user-type="1"><span>学生注册</span></li>
                            <li id="tec_reg" data-user-type="2"><span>导师注册</span></li>
                        </ul>
                    </c:if>
                    <form:form id="registerfm" action="${ctxFront}/register/saveRegister" method="post" class="one register-form student-form"
                               autocomplete="off">
                        <input id="userType" type="hidden" name="userType" value="1"/>
                        <div class="register-row">
                            <span class="arrow-down"></span>
                            <div class="little-img"></div>
                            <select id="reg_type" name="regType" class="register-input student-select required">
                                <option value="mobile">手机注册</option>
                                <option value="no">学号注册</option>
                            </select>
                        </div>
                        <div class="register-row">
                            <div class="little-img"><i class="iconfont icon-yonghudianji"></i></div>
                            <input name="loginName" type="text" class="register-input short" autocomplete="off" placeholder="请设置登录名">
                        </div>
                        <div class="register-row">
                            <div class="little-img"><img src="/img/u1225.png" alt=""></div>
                            <input name="name" minlength="2" type="text" class="register-input short"
                                   placeholder="请输入真实姓名">
                        </div>
                        <div id="div_mobile">
                            <div class="register-row student-phone">
                                <div class="little-img"><i class="iconfont icon-unie64f"></i></div>
                                <input name="mobile" type="text" class="register-input short" autocomplete="off" placeholder="请输入手机号">
                            </div>
                            <div class="register-row student-phone">
                                <button type="button" class="btn register-code" id="getVerity" style="outline: none">获取验证码</button>
                                <input name="yanzhengma" type="text" class="register-input long" autocomplete="off" placeholder="请输入验证码">
                            </div>
                        </div>

                        <div id="div_no">
                            <div class="register-row student-school" >
                                <input name="no" type="text" class="register-input" autocomplete="off" placeholder="请输入学号">
                            </div>
                            <div class="register-row student-school student-register-code" style="display: block">
                                <input name="validateCode" type="text" class="register-input" placeholder="请输入验证码">
                                <span class="validate">
                                    <img src="/f/validateCode/createValidateCode" onclick="$('.validateCodeRefresh').click();" class="validateCode">
                                    <a style="display: none" class="validateCodeRefresh" onclick="$('.validateCode').attr('src','/f/validateCode/createValidateCode?'+new Date().getTime());">换一张</a>
                                </span>
                            </div>
                        </div>

                        <div class="register-row">
                            <div class="little-img"><i class="iconfont icon-jiesuo"></i></div>
                            <input id="password" name="password" type="password" class="register-input short stu-pass" autocomplete="off"
                                   placeholder="请设置6~20位数字、字母登录密码">
                        </div>
                        <div class="register-row">
                            <input name="confirm_password" type="password" class="register-input" autocomplete="off" placeholder="请确认登录密码">
                        </div>
                        <div id="stuError">

                        </div>
                        <div class="register-submit">
                            <button id="btRegister" type="submit" class="btn btn-primary" style="margin-top: 30px;">注 册</button>
                            <a href="/f/toLogin">已有账号，去登录</a>
                        </div>
                    </form:form>


                </div>
            </div>
        </div>
    </div>
</div>
<script src="/common/common-js/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/common/common-js/jquery.validate.min.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
    $(function () {

        var $divNo = $('#div_no');
        var $divMobile = $('#div_mobile');
        var $userType = $('#userType');
        var $regType = $('#reg_type');
        var $yanzhengma = $('input[name="yanzhengma"]');

        var $getVerity = $('#getVerity');
        var $mobile = $('input[name="mobile"]');
        var timer = null;

        $regType.change(function () {
            $('#registerfm input').val('');
            registerValidate.resetForm();

            $userType.val($('.register-acitve').attr('data-user-type')|| '1');
//            $('#registerfm')[0].reset();

            var value = $(this).val();
            if (value == "mobile") {
                $divNo.hide();
                $divMobile.show();
            } else {
                $divMobile.hide();
                $divNo.show();
            }
        });


        $("#stu_reg").click(function () {
            $divNo.hide();
            $divMobile.show();
            $('#registerfm')[0].reset();
            $userType.val(1);
            $regType.find("option[value='no']").text("学号注册");
            $("input[name='no']").attr("placeholder", "请输入学号");
        });

        $("#tec_reg").click(function () {
            $divNo.hide();
            $divMobile.show();
            $('#registerfm')[0].reset();
            $userType.val(2);
            $regType.find("option[value='no']").text("工号注册");
            $("input[name='no']").attr("placeholder", "请输入工号");
        });

        $('.register-tab li').click(function () {
            registerValidate.resetForm();
            $('.register-tab li').removeClass('register-acitve');
            $(this).addClass('register-acitve');
        })

//        var userTypeVal = $('select option:selected');
        var validateCodeVal = $('input[name="validateCode"]');

        var registerValidate = $('#registerfm').validate({
            rules: {
                loginName: {
                    required: true,
                    remote:'${ctxFront}/register/checkLoginNameUnique'
                },
                name: {
                    required: true,
                    minlength: 2
                },
                mobile: {
                    required: true,
                    digits: true,
                    phone_number: true,
                    remote: '${ctxFront}/register/validatePhone'
                },
                yanzhengma: {
                    required: true,
                    num_letter: true,
                    maxlength: 6,
                    remote: {
                        url: '${ctxFront}/register/validateYZM',
                        data: {
                            'yzma': function () {
                                return $yanzhengma.val()
                            }
                        }
                    }
                },
                no: {
                    required: true,
                    remote:'${ctxFront}/register/checkNoUnique'
//                    digits: true
                },
                validateCode: {
                    required: true,
                    remote:{
                        url:'${ctxFront}/register/checkCode',
                        data:{
                            'regType':function(){
                                return $('select option:selected').val();
                            },
                            'code':function(){
                                return validateCodeVal.val();
                            }
                        }
                    }
                },
                password: {
                    required: true,
                    stu_pwd: true
                },
                confirm_password: {
                    required: true,
                    equalTo: '#password'
                }
            },
            messages: {
                loginName: {
                    required: '*登录名必填',
                    remote:'*登录名已被用'
                },
                name: {
                    required: '*真实姓名必填',
                    minlength: '*真实姓名必须大于一个字符'
                },
                mobile: {
                    required: '*手机号必填',
                    digits: '*手机号必须为数字',
                    remote: '*该手机号已被注册'
                },
                yanzhengma: {
                    required: '*验证码必填',
                    maxlength: '*验证码长度错误',
                    remote: '*验证码错误'
                },
                no: {
                    required: '*学号必填',
                    remote:'*学号/工号已被注册'
//                    digits: '*学号必须为数字'
                },
                validateCode: {
                    required: '*验证码必填',
                    remote:'*验证码错误'
                },
                password: {
                    required: '*密码必填'
                },
                confirm_password: {
                    required: '*确认密码必填',
                    equalTo: '*两次密码输入不一致'
                }
            },
            errorLabelContainer: '#stuError',
            errorClass: 'stu-error',
            submitHandler: function (form) {
                $('#btRegister').prop('disabled', true).text('注册中...')
                form.submit();
            }

        });



        jQuery.validator.addMethod("phone_number", function (value, element) {
            var length = value.length;
            var mobileRegExp = /^0?(13[0-9]|15[012356789]|18[0-9]|17[0-9])[0-9]{8}$/;
            return this.optional(element) || (length == 11 && mobileRegExp.test(value));
        }, "*手机号码格式错误");

        jQuery.validator.addMethod("num_letter", function (value, element) {
            var numLetter = /^([a-zA-Z0-9]+)$/;
            return this.optional(element) || (numLetter.test(value));
        }, "*验证码必须为数字或字母组成");

        jQuery.validator.addMethod("stu_pwd", function (value, element) {
            var stuPwd = /^[0-9A-Za-z]{6,20}$/;
            return this.optional(element) || (stuPwd.test(value));
        }, "*密码必须由6~20位数字或字母组成");


        $getVerity.click(function () {
            var mobile, xhr;
            var timeCount = 60;
            if (registerValidate.element($mobile)) {
                mobile = $mobile.val();
                xhr = $.post('${ctxFront}/register/getVerificationCode', {mobile: mobile});
                xhr.success(function (res) {
                    if (res) {
                        $getVerity.prop('disabled', true);
                        timer = setInterval(function () {
                            if (timeCount <= 0) {
                                $getVerity.prop('disabled', false);
                                $getVerity.text('获取验证码');
                                clearInterval(timer);
                            } else {
                                $getVerity.text((timeCount--) + 's后重新发送')
                            }
                        }, 1000)
                    }
                })
            }
        })




    })
</script>
</body>

</html>
