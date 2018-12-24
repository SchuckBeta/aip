<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>${fns:getConfig('productName')} 登录</title>
    <%@include file="/WEB-INF/views/include/backCommon.jsp" %>
    <link rel="shortcut icon" href="/images/bitbug_favicon.ico" />
    <!--公用重置样式文件-->
    <!--登录页面样式文件-->
    <%--<link rel="stylesheet" type="text/css" href="/css/login.css"/>--%>
    <link rel="stylesheet" type="text/css" href="/css/login2.css"/>

</head>
<body>

<!--[if lte IE 6]>
<br/><div class='alert alert-block' style="text-align:left;padding-bottom:10px;"><a class="close" data-dismiss="alert">x</a><h4>温馨提示：</h4><p>你使用的浏览器版本过低。为了获得更好的浏览体验，我们强烈建议您 <a href="http://browsehappy.com" target="_blank">升级</a> 到最新版本的IE浏览器，或者使用较新版本的 Chrome、Firefox、Safari 等。</p></div><![endif]-->

<%--<h1 class="form-signin-heading">${fns:getConfig('productName')}</h1>--%>
<%--<img class="up" src="/img/login-upbg_01.png"/>--%>
<img class="up img-responsive" src="/img/login2bg_01.jpg"/>
<div class="down">
    <form:form id="loginForm" class="form-signin" action="${ctx}/login" method="post">
        <p><input type="text" id="username" name="username" value="${username}" placeholder="用户名" style="width:370px;" /></p>
        <p><input type="password" id="password" name="password" placeholder="密 码"  style="width:370px;" /></p>

        <%--<p><input type="text" id="username" name="username"  value="${username}"  placeholder="用户名" style="width:370px;" /></p>--%>
        <%--<p><input type="password" id="password" name="password"  placeholder="密 码"  style="width:370px;" /></p>--%>
        <c:if test="${isValidateCodeLogin}">
            <div class="validateCode" style="width:385px;float:right;margin-top: 15px; margin-bottom: 15px;">
                <label class="input-label mid" style="float:left; font-size: 14px;line-height: 28px;margin-right: 10px;" for="validateCode">验证码:</label>
                <sys:validateCode name="validateCode" inputCssStyle="float:left; margin-bottom:0; margin-right:10px; border:1px solid #898989;height:24px;width:80px;"/>
                <style>
                    .validateCode img{
                        margin-right: 10px;
                        float: left;
                    }

                    .validateCode a{
                        float: left;
                        line-height: 28px;
                    }
                </style>
            </div>
        </c:if>
        <div class="alertbox" id="alerboxLogin">
            <div class="header">
                <div id="messageBox" style="height:36px; padding: 0px; background: #fffbf3; position:relative; border:none; ${empty message ? 'display: none' : ''};" class="alert alert-error">
                    <!-- <button style="width: 16px; height: 16px; line-height: 16px; text-align: center; top:10px;left: 0px; position: absolute;border-radius: 100px 100px;" class="close"></button> -->
                    <label style="font-size: 14px !important; color:#e9432d; background: none;padding: 0px;margin-left:0px;line-height: 36px;font-weight: normal;" class="error loginError">${message}</label>
                </div>
            </div>
        </div>
        <div style="width: 180px; margin: 0 auto">
            <input class="" id="submitId"  type="submit" style="display: block;background: #e9432d;line-height: 24px; border-radius: 5px; color: #fff; width: 180px; border: 1px solid #bdb9b3; outline: none;   padding: 4px 12px ;margin-bottom: 15px; font-size: 14px;" value="登        录"/>
            <div style="text-align: center;"><a href="${fns:getSysFrontIp()}/f/toLogin" class="btn-website" >返回前端门户</a></div>
        </div>

    </form:form>
</div>
<%--<form id="loginForm" class="form-signin" action="${ctx}/login" method="post">
    <label class="input-label" for="username">登录名11111</label>
    <input type="text" id="username" name="username" class="input-block-level required" value="${username}">
    <label class="input-label" for="password">密码</label>
    <input type="password" id="password" name="password" class="input-block-level required">
    <c:if test="${isValidateCodeLogin}"><div class="validateCode">
        <label class="input-label mid" for="validateCode">验证码</label>
        <sys:validateCode name="validateCode" inputCssStyle="margin-bottom:0;"/>
    </div></c:if>&lt;%&ndash;
    <label for="mobile" title="手机登录"><input type="checkbox" id="mobileLogin" name="mobileLogin" ${mobileLogin ? 'checked' : ''}/></label> &ndash;%&gt;
    <input class="btn btn-large btn-primary" type="submit" value="登 录"/>&nbsp;&nbsp;
    <label for="rememberMe" title="下次不需要再登录"><input type="checkbox" id="rememberMe" name="rememberMe" ${rememberMe ? 'checked' : ''}/> 记住我（公共场所慎用）</label>
    <div id="themeSwitch" class="dropdown">
        <a class="dropdown-toggle" data-toggle="dropdown" href="#">${fns:getDictLabel(cookie.theme.value,'theme','默认主题')}<b class="caret"></b></a>
        <ul class="dropdown-menu">
          <c:forEach items="${fns:getDictList('theme')}" var="dict"><li><a href="#" onclick="location='${pageContext.request.contextPath}/theme/${dict.value}?url='+location.href">${dict.label}</a></li></c:forEach>
        </ul>
        <!--[if lte IE 6]><script type="text/javascript">$('#themeSwitch').hide();</script><![endif]-->
    </div>
</form>--%>
<%--<div class="footer">
    Copyright &copy; 2012-${fns:getConfig('copyrightYear')} <a href="${pageContext.request.contextPath}${fns:getFrontPath()}">${fns:getConfig('productName')}</a> - Powered By <a href="http://initiate.com" target="_blank">JeeSite</a> ${fns:getConfig('version')}
</div>--%>
<%--<script src="${ctxStatic}/flash/zoom.min.js" type="text/javascript"></script>--%>

<script type="text/javascript">
    var hasMsg = ("${message}" == "")?false:true;
    var alerboxLogin = $("#alerboxLogin");
    var alerboxLoginHeader =  $("#alerboxLogin .header");
    var alerboxMsgBox = $("#messageBox");
    var alerboxLoginClose = $("#alerboxLogin .close");
    var alerboxLoginForm = $("#loginForm");
    var alerboxLoginError = $("#alerboxLogin .loginError");

    //dom显示隐藏
    function domIsShow(dom, isShow){
        if(isShow == null || isShow == undefined){
            isShow = true;
        }
        if(isShow){
            $(dom).show();
            $(dom).css("display","block");
            //$(dom).css("color","#e9432d");
            //$(dom).addClass("hide");
        }else{
            $(dom).hide();
            $(dom).css("display","none");
            //$(dom).css("color","#fff");
            if($(dom).hasClass("hide")){
                $(dom).removeClass("hide");
            }
        }
    }

    function domIsShowMsg(isShow, hasMsg){
        if(isShow && hasMsg){
            isShow = true;
        }else{
            isShow = false;
        }
        if(isShow){
            domIsShow(alerboxLogin, true);
            domIsShow(alerboxLoginHeader, true);
            domIsShow(alerboxMsgBox, true);
            domIsShow(alerboxLoginError, true);
        }else{
            domIsShow(alerboxLogin, false);
            domIsShow(alerboxLoginHeader, false);
            domIsShow(alerboxMsgBox, false);
            domIsShow(alerboxLoginError, false);
        }
    }

    function onkeydownFun(){
        document.onkeydown = function (event) {
            e = event ? event : (window.event ? window.event : null);
            if (e.keyCode == 13) {
                //执行的方法
                $("#submitId").click();
            }
        }
    }

    var valRule = {
        rules: {
            validateCode: {remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"} ,
            username:{required:true},
            password:{required:true},
            validateCode:{required:true}
        },
        messages: {
            username:{required:"请填写用户名."},
            password:{required:"请填写密码."},
            validateCode: {remote: "验证码不正确.", required: "请填写验证码."}
        }
    };
    $.validator.setDefaults({
        submitHandler: function(form) {
            console.info(form);
            var usernameVal = $(form).find("[name='username']").val();
            var passwordVal = $(form).find("[name='password']").val();
            var validateCodeVal = $(form).find("[name='validateCode']").val();

            if((usernameVal == "") || (usernameVal == undefined)){
                $(alerboxLoginError).html(valRule.messages.username.required);
                domIsShowMsg(true, true);
                return false;
            }

            if((passwordVal == "") || (passwordVal == undefined)){
                $(alerboxLoginError).html(valRule.messages.password.required);
                domIsShowMsg(true, true);
                return false;
            }

            if((validateCodeVal == "") && (validateCodeVal != undefined)){
                $(alerboxLoginError).html(valRule.messages.validateCode.required);
                domIsShowMsg(true, true);
                return false;
            }
            form.submit();
        }
    });

    $(document).ready(function() {
        $(alerboxLoginForm).validate();

        //$(alerboxLoginClose).click(function(){
        //	domIsShowMsg(false, false);
        //});

        // 如果在框架或在对话框中，则弹出提示并跳转到首页
        if(self.frameElement && self.frameElement.tagName == "IFRAME" || $('#left').length > 0 || $('.jbox').length > 0){
//				alert('未登录或登录超时。请重新登录，谢谢！');
            showModalMessage(0, '未登录或登录超时。请重新登录，谢谢！')
            top.location = "${ctx}";
        }

        domIsShowMsg(hasMsg, hasMsg);
        onkeydownFun();//回车提交
    });


</script>
<%@ include file="../../../views/layouts/website/copyright.jsp"%>
</body>
</html>

