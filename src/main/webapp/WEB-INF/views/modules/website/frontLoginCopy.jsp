<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page
        import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${frontTitle}</title>
    <!--引用装饰器-->
    <meta name="decorator" content="site-decorator"/>


    <!--学生登录页面样式表-->
    <link rel="stylesheet" type="text/css" href="/css/studentlogin.css"/>
    <%--<script src="/common/common-js/jquery.validate.min.js" type="text/javascript" charset="utf-8"></script>--%>
    <script src="/common/common-js/messages_zh.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="/js/studentlogin.js?v=1" type="text/javascript" charset="utf-8"></script>

    <style type="text/css">
        .form-group-ls {
            position: relative;
            margin-bottom: 18px;
        }

        .form-group-ls .btn-getpassword, .form-group-ls .get-code {
            display: block;
            position: absolute;
            padding: 0 8px;
            right: 1px;
            top: 1px;
            height: 32px;
            line-height: 32px;
            text-decoration: none;
            color: #333;
            cursor: pointer;
        }

        .form-group-ls .btn-getpassword:hover, .form-group-ls .get-code:hover {
            text-decoration: underline;
        }

        .form-group-telphone .form-control {
            padding-right: 86px;
        }

        .form-group-ls .yanzhengma {
            display: inline-block;
            width: 232px;
            vertical-align: top;
        }

        .form-group-ls .validate {
            float: right;
            display: inline-block;
            width: 90px;
            border: 1px solid #ccc;
            border-radius: 4px;
            overflow: hidden;
        }

        .form-group-ls .validate img {
            display: block;
            width: 100%;
        }

        .fbtn {
            display: block;
            width: 100%;
            height: 34px;
            font-size: 16px;
            line-height: 20px;
        }
        .fbtn[disabled]{
            cursor: pointer;
        }



    </style>
    <script type="text/javascript">
        $(function () {

            var initStudentLogin = function () {
                studentLogin.messageLogin();
                studentLogin.accountLogin();
            }();
            if ($("[name='fromLogin']").val() == "1") {
                $(".wholebox .content .mainbox .box ul li.message").click();
            } else {
                $(".wholebox .content .mainbox .box ul li.accountpassword").click();
            }

            /* var a=$('<a href="/f/toRegister">注册</a>');
             a.css({
             "position":"absolute",
             "right":"56px",
             "top":"45px",
             "color":"#df4526",
             "font-size":"14px"
             })
             $('.mid').append(a);
             $('.user').append('<a href="/f/toRegister">注册</a>');*/

        });
    </script>
    <c:set var="loginType" value="${(empty loginType)?'2':loginType}"/>
    <script type="text/javascript">
        $(function () {
            $("#validcode").click(
                    function () {
                    	var disable = $("#validcode").attr("disabled");
                    	if (disable == undefined || disable == null
                                || disable == "" || disable == false) {
                    	}else{
                    		return false;
                    	}
                    	domIsShowMsg(1, false, true);
                        var usernameVal = $("#phonelogin").find("[name='username']").val();
                        if ((usernameVal == "") || (usernameVal == undefined)) {
                            $(msgBoxError1).html("请输入手机号码");
                            domIsShowMsg(1, true, true);
                            return false;
                        }
                        if (!mobileRegExp.test(usernameVal)) {
                            $(msgBoxError1).html(messages.msgNo);
                            domIsShowMsg(1, true, true);
                            return false;
                        }
                        var isExistMobile=false;
                        $.ajax({
                            type: "GET",
                            url: "/f/sys/user/isExistMobile",
                            async: false,
                            data: {
                                mobile: usernameVal
                            },
                            success: function (data) {
                                if (data == "true") {
                                	isExistMobile=true;
                                }else{
                                	isExistMobile=false;
                                }
                            }

                        });
                        if (!isExistMobile) {
                            $(msgBoxError1).html("手机号码未注册");
                            domIsShowMsg(1, true, true);
                            return false;
                        }

                        var second = 60;
                        var mobile = $(".account").val();

                        if (mobile == undefined || mobile == null || mobile == "") {
                            return false;
                        }

                       	$("#validcode").attr("disabled", true);
                       	$("#validcode").text(
                                   '' + (--second) + 's' + '后重新发送');
                       	timer = window.setInterval(function () {
                               $("#validcode").text(
                                       '' + (--second) + 's' + '后重新发送');
                               if (second == 0) {
                                   clearInterval(timer);
                                   $("#validcode").attr("disabled", false).text(
                                           '获取验证码');
                                   second = 60;
                               }

                           }, 1000);
                           $.ajax({
                               type: "GET",
                               url: "sendSmsCode",
                               data: {
                                   'mobile': mobile
                               },
                               success: function (data) {
                                   if (data == "1") {

                                   }else{
                                   	clearInterval(timer);
                                       $("#validcode").attr("disabled", false).text(
                                               '获取验证码');
                                       second = 60;
                                       $(msgBoxError1).html("发送验证码失败，请稍后重试");
                                       domIsShowMsg(1, true, true);
                                   }
                               }
                           });

                    });
        });


        var messages = {
            username: "请填写用户名.",
            password: "请填写密码.",
            valCode: "验证码不正确.",
            msgNo: "手机号码不正确.",
            msgValCode: "短信验证码错误, 请重试."
        };

        var hasMsg = ("${message}" == "") ? false : true;
        var msgBox1 = "#messageBox1";
        var msgBox2 = "#messageBox2";
        var msgBoxError1 = "#loginError1";
        var msgBoxError2 = "#loginError2";
        //dom显示隐藏
        function domIsShow(dom, isShow) {
            if (isShow == null || isShow == undefined) {
                isShow = true;
            }
            if (isShow) {
                $(dom).show();
                $(dom).css("display", "block");
            } else {
                $(dom).hide();
                $(dom).css("display", "none");
                if ($(dom).hasClass("hide")) {
                    $(dom).removeClass("hide");
                }
            }
        }

        function domIsShowMsg(type, isShow, hasMsg) {
            if (isShow && hasMsg) {
                isShow = true;
            } else {
                isShow = false;
            }
            if (isShow) {
                if (type == 1) {
                    domIsShow($(msgBox1), true);
                    domIsShow($(msgBoxError1), true);
                } else if (type == 2) {
                    domIsShow($(msgBox2), true);
                    domIsShow($(msgBoxError2), true);
                }
            } else {
                if (type == 1) {
                    domIsShow($(msgBox1), false);
                    domIsShow($(msgBoxError1), false);
                } else if (type == 2) {
                    domIsShow($(msgBox2), false);
                    domIsShow($(msgBoxError1), false);
                }
            }
        }

        function onkeydownFun() {
            document.onkeydown = function (event) {
                e = event ? event : (window.event ? window.event : null);
                if (e.keyCode == 13) {
                    validateLoginForm();
                }
            }
        }
        onkeydownFun();
        function validateLoginForm() {
            $.each($(".fbox"), function () {
                if (($(this).css("display") != 'none')) {
                    if ($(this).hasClass("fillboxtwo")) {
                        validateAccountForm();
                    } else if ($(this).hasClass("fillboxone")) {
                        validatePhoneForm();
                    }
                }
            });
        }
        function validatePhoneForm() {
            var type = 1;
            var form = $("#phonelogin");
            var usernameVal = $(form).find("[name='username']").val();
            var passwordVal = $(form).find("[name='password']").val();

            if ((usernameVal == "") || (usernameVal == undefined) || !mobileRegExp.test(usernameVal)) {
                $(msgBoxError1).html(messages.msgNo);
                domIsShowMsg(1, true, true);
                return false;
            }
            if ((passwordVal == "") || (passwordVal == undefined)) {
                $(msgBoxError1).html(messages.msgValCode);
                domIsShowMsg(1, true, true);
                return false;
            }

            $("#phonelogin").submit();
        }

        //
        function validateAccountForm() {
            var type = 2;
            var form = $("#accountlogin");
            var usernameVal = $(form).find("[name='username']").val();
            var passwordVal = $(form).find("[name='password']").val();
            var validateCodeVal = $(form).find("[name='validateCode']").val();

            if ((usernameVal == "") || (usernameVal == undefined)) {
                $(msgBoxError2).html(messages.username);
                domIsShowMsg(type, true, true);
                return false;
            }

            if ((passwordVal == "") || (passwordVal == undefined)) {
                $(msgBoxError2).html(messages.password);
                domIsShowMsg(type, true, true);
                return false;
            }

            if ($(form).find("[name='validateCode']") != undefined) {
                console.info(validateCodeVal);
                if ((validateCodeVal == "")) {
                    $(msgBoxError2).html(messages.valCode);
                    domIsShowMsg(type, true, true);
                    return false;
                }
            }


            $("#accountlogin").submit();
        }
    </script>

</head>
<body>
<div class="wholebox">
    <div class="content">
        <div class="mainbox">
            <h5>登录</h5>
            <div class="box">
                <%--<div class="redtop"></div>--%>
                <ul>
                    <li class="accountpassword">账号密码登录</li>
                    <li class="current message">短信登录</li>
                </ul>
                <input type="hidden" id="imFrontLoginPage"/>
                <input type="hidden" name="fromLogin" value="${loginType}"/>
                <div class="fillboxone fbox">
                    <form id="phonelogin" class="form-signin" action="login" method="post" autocomplete="on">
                        <div class="form-group-ls">
                            <c:if test="${(loginType == '1')}">
                                <input class="account form-control" type="text" name="username" value="${username }"
                                       placeholder="请输入手机号码"/>
                            </c:if>
                            <c:if test="${(loginType == '2')}">
                                <input class="account form-control" type="text" name="username" value=""
                                       placeholder="请输入手机号码"/>
                            </c:if>
                        </div>
                        <span id="mobileVolide" class="phone-tips"></span>

                        <!-- <button type="button" id="validcode">获取验证码</button> -->
                        <div class="form-group-ls form-group-telphone">
                            <input type="text" name="password" class="password form-control" placeholder="请输入手机获得的6位数" autocomplete="off"/>
                            <a id="validcode" class="get-code">获取验证码</a>
                        </div>
                        <input type="hidden" name="loginType" value="1"/>
                        <c:if test="${(loginType == '1')}">
                            <div id="messageBox1"
                                 style="height: 36px; padding: 0px; position: relative; margin-bottom: 0px;margin-top: 18px;top:-20px; ${empty message ? 'display: none' : ''};"
                                 class="alert alert-error">
                                <button type="button"
                                        onclick="javascript:$(this).parent().remove();"
                                        data-dismiss="alert"
                                        style="width: 16px; height: 16px; line-height: 16px; text-align: center; top: 8px; right: 5px; position: absolute; border-radius: 100px 100px;"
                                        class="close">×
                                </button>
                                <label id="loginError1"
                                       style="font-size: 14px !important; background: none; padding: 0px; margin-top: 0px; margin-left: 5px; line-height: 36px; font-weight: normal; text-align: left;"
                                       class="error">${message}</label>
                            </div>
                        </c:if><c:if test="${(loginType == '2')}">
                        <div id="messageBox1"
                             style="height: 36px; padding: 0px; position: relative; margin-bottom: 0px;margin-top: 18px;top:-20px; display: none;"
                             class="alert alert-error">
                            <button type="button"
                                    onclick="javascript:$(this).parent().remove();"
                                    data-dismiss="alert"
                                    style="width: 16px; height: 16px; line-height: 16px; text-align: center; top: 8px; right: 5px; position: absolute; border-radius: 100px 100px;"
                                    class="close">×
                            </button>
                            <label id="loginError1"
                                   style="font-size: 14px !important; background: none; padding: 0px; margin-top: 0px; margin-left: 5px; line-height: 36px; font-weight: normal; text-align: left; display: none;"
                                   class="error"></label>
                        </div>
                    </c:if>
                        <button class="fbtn btn btn-block btn-primary-oe" disabled type="button" onclick="validatePhoneForm()">登 录</button>
                        <div class="links"><a class="right" href="/f/toRegister">没有账号，去注册</a></div>
                    </form>
                </div>
                <div class="fillboxtwo fbox">
                    <form id="accountlogin" method="post" action="login" autocomplete="on">
                        <div class="form-group-ls">
                            <c:if test="${(loginType == '1')}">
                                <input class="account form-control" type="text" name="username" value=""
                                       placeholder="请输入登录名或学号"/>
                            </c:if>
                            <c:if test="${(loginType == '2')}">
                                <input class="account form-control" name="username" value="${username }" type="text"
                                       placeholder="请输入登录名或学号"/>
                            </c:if>
                        </div>
                        <div class="form-group-ls clearfix">
                            <input class="password form-control" name="password" type="password" placeholder="密码" autocomplete="off"/>
                            <a class="btn-getpassword" href="/f/cms/page-seekpassword">找回密码</a>
                        </div>
                        <input type="hidden" name="loginType" value="2"/>
                        <c:if test="${isValidateCodeLogin}">

                            <div class="form-group-ls">
                                <input class="yanzhengma form-control" name="validateCode" type="text"
                                       placeholder="验证码"/>
                                <span class="validate">
                                        <img src="/f/validateCode/createValidateCode"
                                             onclick="$('.validateCodeRefresh').click();" class="validateCode">
									<a style="display: none" class="validateCodeRefresh"
                                       onclick="$('.validateCode').attr('src','/f/validateCode/createValidateCode?'+new Date().getTime());">换一张</a>
									</span>
                            </div>
                        </c:if>

                        <c:if test="${(loginType == '1')}">
                            <div id="messageBox2"
                                 style="height: 36px; padding: 0px; position: relative;top:-5px; margin-bottom: 15px; display: none;"
                                 class="alert alert-error">
                                <button type="button"
                                        onclick="javascript:$(this).parent().remove();"
                                        data-dismiss="alert"
                                        style="width: 16px; height: 16px; line-height: 16px; text-align: center; top: -8px; right: 5px; position: absolute; border-radius: 50%;border-width:0;"
                                        class="close">×
                                </button>
                                <label id="loginError2"
                                       style="font-size: 14px !important; background: none; padding: 0px; margin-left: 5px; line-height: 30px; font-weight: normal; text-align: left; display: none;"
                                       class="error"></label>
                            </div>
                        </c:if><c:if test="${(loginType == '2')}">
                        <div id="messageBox2"
                             style="height: 36px; padding: 0px; position: relative;top:-5px; margin-bottom: 15px; ${empty message ? 'display: none' : ''};"
                             class="alert alert-error">
                            <button type="button"
                                    onclick="javascript:$(this).parent().remove();"
                                    data-dismiss="alert"
                                    style="width: 16px; height: 16px; line-height: 16px; text-align: center; top: -8px; right: 5px; position: absolute; border-radius: 50%;border-width:0;"
                                    class="close">×
                            </button>
                            <label id="loginError2"
                                   style="font-size: 14px !important; background: none; padding: 0px; margin-left: 5px; line-height: 30px; font-weight: normal; text-align: left;"
                                   class="error">${message}</label>
                        </div>
                    </c:if>
                        <button class="fbtn btn btn-block btn-primary-oe" disabled type="button" onclick="validateAccountForm()">登 录</button>
                        <div class="links"><a class="right" href="/f/toRegister">没有账号，去注册</a></div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <%--</div>--%>


    <%--<div class="navbar navbar-fixed-top" style="position:static;margin-bottom:10px;">
  <div class="navbar-inner">
    <div class="container">
      <c:choose>
           <c:when test="${not empty site.logo}">
               <img alt="${site.title}" src="${site.logo}" class="container" onclick="location='${ctx}/index-${site.id}${fns:getUrlSuffix()}'">
           </c:when>
           <c:otherwise><a class="brand" href="${ctx}/index-${site.id}${fns:getUrlSuffix()}">${site.title}</a></c:otherwise>
         </c:choose>
      <div class="nav-collapse">
        <ul id="main_nav" class="nav nav-pills">
             <li class="${not empty isIndex && isIndex ? 'active' : ''}"><a href="${ctx}/index-1${fns:getUrlSuffix()}"><span>${site.id eq '1'?'首　 页':'返回主站'}</span></a></li>
            <c:forEach items="${fnc:getMainNavList(site.id)}" var="category" varStatus="status"><c:if test="${status.index lt 6}">
                <c:set var="menuCategoryId" value=",${category.id},"/>
                <li class="${requestScope.category.id eq category.id||fn:indexOf(requestScope.category.parentIds,menuCategoryId) ge 1?'active':''}"><a href="${category.url}" target="${category.target}"><span>${category.name}</span></a></li>
            </c:if></c:forEach>
            <li id="siteSwitch" class="dropdown">
                   <a class="dropdown-toggle" data-toggle="dropdown" href="#" title="站点"><i class="icon-retweet"></i></a>
                <ul class="dropdown-menu">
                  <c:forEach items="${fnc:getSiteList()}" var="site"><li><a href="#" onclick="location='${ctx}/index-${site.id}${urlSuffix}'">${site.title}</a></li></c:forEach>
                </ul>
            </li>
            <li id="themeSwitch" class="dropdown">
                   <a class="dropdown-toggle" data-toggle="dropdown" href="#" title="主题切换"><i class="icon-th-large"></i></a>
                <ul class="dropdown-menu">
                  <c:forEach items="${fns:getDictList('theme')}" var="dict"><li><a href="#" onclick="location='${pageContext.request.contextPath}/theme/${dict.value}?url='+location.href">${dict.label}</a></li></c:forEach>
                </ul>
                <!--[if lte IE 6]><script type="text/javascript">$('#themeSwitch').hide();</script><![endif]-->
            </li>
        </ul>
        <form class="navbar-form pull-right" action="${ctx}/search" method="get">
              <input type="text" name="q" maxlength="20" style="width:65px;" placeholder="全站搜索..." value="${q}">
        </form>
      </div><!--/.nav-collapse -->
    </div>
  </div>--%>
</div>

<script type="text/javascript">
    $(function () {
        var $accountlogin = $('#accountlogin');
        var $btnAccountSubmit = $accountlogin.find('.fbtn');
        var $username = $accountlogin.find('input[name="username"]');
        var $password = $accountlogin.find('input[name="password"]');
        var $validateCode = $accountlogin.find('input[name="validateCode"]');

        initBtnDisabled($username.val(), $password.val(), $validateCode.size() > 0, $validateCode.size() > 0 ? $validateCode.val() : '');


        $username.on('input propertychange', function (e) {
            var username = $(this).val();
            var password = $password.val();
            var hasValidateCode = $validateCode.size() > 0;
            initBtnDisabled(username, password, hasValidateCode, hasValidateCode ? $validateCode.val() : '')
        });

        $password.on('input propertychange', function (e) {
            var password = $(this).val();
            var username = $username.val();
            var hasValidateCode = $validateCode.size() > 0;
            initBtnDisabled(username, password, hasValidateCode, hasValidateCode ? $validateCode.val() : '')
        });

        $(document).on('input propertychange', '#accountlogin input[name="validateCode"]', function () {
            var username = $username.val();
            var password = $password.val();
            initBtnDisabled(username, password, true, $(this).val())
        });

        function initBtnDisabled(username, password, hasCode, code) {
            if (hasCode) {
                if (username && password && code) {
                    $btnAccountSubmit.prop('disabled', false);
                    return false
                }
            } else {
                if (username && password) {
                    $btnAccountSubmit.prop('disabled', false);
                    return false
                }
            }
            $btnAccountSubmit.prop('disabled', true)
        }

        var $phonelogin = $('#phonelogin');
        var $phoneUserName = $phonelogin.find('input[name="username"]');
        var $phoneValidateCode = $phonelogin.find('input[name="password"]');
        var $phoneBtnSubmit = $phonelogin.find('.fbtn');

        initPhoneBtnDisabled($phoneUserName.val(), $phoneValidateCode.val());

        $phoneUserName.on('input propertychange', function () {
            var username = $phoneUserName.val();
            var code = $phoneValidateCode.val();
            initPhoneBtnDisabled(username, code)
        });

        $phoneValidateCode.on('input propertychange', function () {
            var username = $phoneUserName.val();
            var code = $phoneValidateCode.val();
            initPhoneBtnDisabled(username, code)
        });

        function initPhoneBtnDisabled(username, code) {
            if (username && code) {
                $phoneBtnSubmit.prop('disabled', false);
                return false
            }
            $phoneBtnSubmit.prop('disabled', true)
        }

    })
</script>
</body>


</html>