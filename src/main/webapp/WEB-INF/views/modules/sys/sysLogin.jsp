<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${fns:getConfig('productName')} 登录</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <link rel="shortcut icon" href="/images/bitbug_favicon.ico"/>
    <style>
        .login-box {
            width: 478px;
            padding-left: 75px;
            padding-top: 35px;
            padding-bottom: 15px;
            margin: 0 auto;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .form-login .input-username {
            width: 314px;
            height: 32px;
            font-size: 12px;
            box-sizing: border-box;
        }

        .form-login .input-password {
            width: 314px;
            height: 32px;
            font-size: 12px;
            box-sizing: border-box;
        }

        .form-login .control-btns {
            width: 314px;
        }

        .form-login .control-btns .btn {
            padding: 4px 30px;
            font-size: 12px;
        }

        .form-login .input-item {
            position: relative;
            float: left;
            width: 314px;
        }

        .form-login .input-item input {
            padding-right: 35px;
        }

        .form-login .input-icon {
            position: absolute;
            right: 0;
            top: 7px;
            width: 35px;
            height: 18px;
            border-left: 1px solid #ccc;
            text-align: center;
        }

        .form-login .input-icon img {
            vertical-align: top;
        }

        .form-login .input-error {
            float: left;
            margin-left: 10px;
        }

        .form-login .input-error label {
            font-size: 12px;
            margin: 0;
            color: red;
            line-height: 32px;
        }

        .form-login .validateCodeRefresh {
            display: none;
        }

        .form-login .error-message {
            width: 314px;
            margin-bottom: 20px;
            overflow: hidden;
        }

        .form-login .error-message p {
            color: red;
            font-size: 12px;
            padding-left: 8px;
            padding-right: 8px;
            overflow: hidden;
            margin: 0;
            line-height: 30px;
            background-color: #fffbf3;
        }
    </style>
</head>
<body>

<!--[if lte IE 6]>
<br/>
<div class='alert alert-block' style="text-align:left;padding-bottom:10px;">
    <a class="close" data-dismiss="alert">x</a><h4>温馨提示：</h4>
    <p>你使用的浏览器版本过低。为了获得更好的浏览体验，我们强烈建议您 <a href="http://browsehappy.com" target="_blank">升级</a> 到最新版本的IE浏览器，或者使用较新版本的
        Chrome、Firefox、Safari 等。</p></div><![endif]-->

<img class="up img-responsive" src="/img/login2bg_01.jpg"/>


<div class="login-box">
    <form:form id="loginForm" autocomplete="off" action="${ctx}/login" method="post"
               cssClass="form-horizontal form-login">
        <div class="control-group">
            <div class="input-item">
                <input type="text" class="input-username" id="username" name="username" value="${username}"
                       placeholder="用户名" autocomplete="off">
                <div class="input-icon">
                    <img src="/img/login2usernameicon.png">
                </div>
            </div>
            <div class="input-error">
            </div>
        </div>
        <div class="control-group">
            <div class="input-item">
                <input type="password" class="input-password" id="password" name="password" placeholder="密 码"
                       autocomplete="off">
                <div class="input-icon">
                    <img src="/img/login2passwordicon.png">
                </div>
            </div>
            <div class="input-error">
            </div>
        </div>
        <c:if test="${isValidateCodeLogin}">
            <div class="control-group">
                <div class="input-item">
                    <sys:validateCode name="validateCode" inputCssStyle="width: 196px; font-size: 12px;"/>
                </div>
                <div class="input-error">
                </div>
            </div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="error-message">
                <p>${message}</p>
            </div>
        </c:if>
        <div class="text-center control-btns">
            <button type="submit" class="btn btn-primary">登&nbsp;&nbsp;&nbsp;&nbsp;录</button>

        </div>
    </form:form>
</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>

<script type="text/javascript">

    $(function () {
        var $loginForm = $('#loginForm');
        var loginFormValid = $loginForm.validate({
            rules: {
                username: {
                    required: true,
                },
                password: {
                    required: true,
                },
                validateCode: {
                    required: true,
                    remote: "/a/validateCode/checkValidateCode"
                }
            },
            messages: {
                username: {
                    required: '请输入用户名'
                },
                password: {
                    required: '请输入密码'
                },
                validateCode: {
                    required: '请输入验证码',
                    remote: '验证码错误'
                }
            },
            errorClass: 'login-element_error',
            errorPlacement: function (error, element) {
                error.appendTo(element.parents('.control-group').find('.input-error'));
            }
        });
        var $inputs = $loginForm.find('input');
        var $errorMessageCon = $loginForm.find('.error-message');
        $inputs.on('keyup', function (event) {
            event.stopPropagation();
            if (event.keyCode === 13) {
                if (loginFormValid.form()) {
                    $loginForm.submit();
                    loginFormValid.resetForm();
                }
            }
        })
        $inputs.on('focus', function () {
            $errorMessageCon.hide();
        })

        $(document).on('keyup', function (event) {
            if (event.keyCode === 13) {
                if (loginFormValid.form()) {
                    $loginForm.submit();
                    loginFormValid.resetForm();
                }
            }
        })

        if (self.frameElement && self.frameElement.tagName == "IFRAME" || $('#left').length > 0 || $('.jbox').length > 0) {
            //dialogCyjd.createDialog(0, '未登录或登录超时。请重新登录，谢谢！')
            top.location = "${ctx}";
        }
    })


</script>
<%@ include file="../../../views/layouts/website/copyright.jsp" %>
</body>
</html>

