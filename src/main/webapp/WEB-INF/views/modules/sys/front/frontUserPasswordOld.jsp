<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="decorator" content="site-decorator"/>
    <title>${frontTitle}</title>
    <link rel="stylesheet" type="text/css" href="/static/css/check_stu_details.css">
    <link rel="stylesheet" type="text/css" href="/css/studentForm.css">
    <link href="/static/jquery-jbox/2.3/Skins/Red/jbox.css" rel="stylesheet"/>
    <script src="/static/jquery-jbox/2.3/jquery.jBox-2.3.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="/js/common.js"></script>
    <script src="/other/jquery-ui-1.12.1/jquery-ui.js" type="text/javascript" charset="utf-8"></script>
    <link href="/static/jquery-validation/1.11.0/jquery.validate.min.css" type="text/css" rel="stylesheet"/>
    <script src="/static/jquery-validation/1.11.0/jquery.validate.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        (function (window, $) {
            $(function () {
                var validate;
                var validate2;
                var $inputForm = $("#inputForm");
                var $inputForm2 = $("#inputForm2");
                var mobile = /^0?(13|14|15|18|17)[0-9]{9}$/;
                var countdown = 60;
                var flag = true;
                var $getMobileValidateCode = $("#getMobileValidateCode");
                var $mobile = $('#mobile');
                var timerId = null;

                showMessage("${message}", "${type}");

                validate = $inputForm.validate({
                    rules: {
                        oldPassword: {
                            rangelength: [6, 20]
                        },
                        newPassword: {
                            rangelength: [6, 20]
                        }
                    },
                    messages: {
                        confirmNewPassword: {
                            equalTo: "输入与上面相同的密码"
                        },
                        oldPassword: {
                            rangelength: '请输入6~20位数字、字母'
                        },
                        newPassword: {
                            rangelength: '请输入6~20位数字、字母'
                        }
                    },
                    errorPlacement: function (error, element) {
                        error.insertAfter(element);
                    }
                });
                validate2 = $inputForm2.validate({
                    rules: {
                        mobile: {
                            isMobile: true,
                            remote: {
                                url: "/f/sys/user/checkMobileExist",
                                type: "post",
                                dataType: "json"
                            }
                        },
                        yzm: {
                            remote: "/f/mobile/checkMobileValidateCode"
                        }
                    },
                    messages: {
                        mobile: {
                            remote: "该手机号已经注册"
                        },
                        yzm: {
                            remote: "验证码不正确"
                        }
                    },
                    errorPlacement: function (error, element) {
                        if (element.attr("name") == "yzm") {
                            error.insertAfter(element.next());
                        } else {
                            error.insertAfter(element);
                        }
                    }
                });

                $.validator.addMethod("isMobile", function (value, element) {
                    var length = value.length;
                    return this.optional(element) || (length == 11 && mobile.test(value));
                }, '请填写正确的手机号码');

                $getMobileValidateCode.on('click', function () {
                    var flag_mobile = validate2.element($("#mobile"));
                    var xhr;
                    if (!flag_mobile) return;
                    if (flag) {
                        flag = true;
                        $getMobileValidateCode.prop('disabled', true);
                        xhr = $.post('/f/mobile/sendMobileValidateCode', {mobile: $mobile.val()});
                        xhr.success(function () {
                            setTime($getMobileValidateCode)
                        })
                    }

                });

                window['submitPassword'] = function () {
                    if (validate.form()) {
                        $inputForm.submit();
                    }
                };

                window['submitPhone'] = function () {
                    if (validate2.form()) {
                        $inputForm2.submit();
                    }
                };

                function showMessage(message, type) {
                    if (message != null && message != undefined
                            && message != "") {
                        showModalMessage(type, message);
                    }
                }

                function setTime(element) {
                    if (countdown === 0) {
                        element.prop('disabled', false);
                        element.val('获取验证码');
                        flag = false;
                        countdown = 60;
                        timerId && clearTimeout(timerId);
                    } else {
                        countdown--;
                        element.val("重新发送(" + countdown + ")");
                    }
                    timerId = setTimeout(function () {
                        setTime(element)
                    }, 1000)
                }
            })
        })(window, $)
    </script>
    <style>

        button{
            width: auto;
            height: auto;
        }
    </style>
</head>
<body>
<div class="container" style="padding-top: 50px;padding-bottom: 30px;width: 1270px;">
    <ol class="breadcrumb" style="background: none">
        <li><a href="/f/"><i class="icon-home"></i>首页</a></li>
        <li><a href="/f/sys/frontStudentExpansion/findUserInfoById"><c:if test="${studentExpansion.user.userType==1 }">学生</c:if><c:if test="${studentExpansion.user.userType==2 }">教师</c:if>信息查看</a></li>
        <li class="active">编辑</li>
    </ol>
    <div class="row">
        <div class="left-menu col-md-3 hidden-sm hidden-xs" role="complementary">
            <div class="affix-box">
                <div class="lm-inner">
                    <h4 class="title">我的信息</h4>
                    <div class="me-info">
                        <p class="update-time">更新：
                            <fmt:formatDate value="${studentExpansion.updateDate}" pattern="yyyy-MM-dd"/></p>
                        <div class="public">是否公开：
                            <c:if test="${studentExpansion.isOpen==1 }">
                                <label>
                                    <input type="radio" name="isOpen" value="1" checked="checked">&nbsp;是&nbsp;
                                </label>
                                <label>
                                    <input type="radio" name="isOpen" value="0">&nbsp;否&nbsp;
                                </label>
                            </c:if>
                            <c:if test="${studentExpansion.isOpen==0 }">
                                <label>
                                    <input type="radio" name="isOpen" value="1">&nbsp;是&nbsp;
                                </label>
                                <label>
                                    <input type="radio" name="isOpen" value="0" checked="checked">&nbsp;否&nbsp;
                                </label>
                            </c:if>
                        </div>
                    </div>
                    <div id="nav-list" class="nav-list">
                        <ul class="nav">
                            <li><a href="/f/sys/frontStudentExpansion/findUserInfoById#jsBaseInfo"><i
                                    class="iconx-info-school"></i>基本情况</a></li>
                            <c:if test="${not empty studentExpansion.user.userType}"> <li><a href="/f/sys/frontStudentExpansion/findUserInfoById#jsProjectExp"><i
                                    class="iconx-info-exp"></i><c:if test="${studentExpansion.user.userType==1 }">项目经历</c:if><c:if test="${studentExpansion.user.userType==2 }">指导项目</c:if></a></li></c:if>
                            <c:if test="${not empty studentExpansion.user.userType}"><li><a href="/f/sys/frontStudentExpansion/findUserInfoById#jsBigExp"><i
                                    class="iconx-info-bigExp"></i><c:if test="${studentExpansion.user.userType==1 }">大赛经历</c:if><c:if test="${studentExpansion.user.userType==2 }">指导大赛</c:if></a></li></c:if>
                            <li class="active"><a href="javascript:void(0);"><i class="iconx-info-per"></i>修改密码</a></li>
                            <li><a href="/f/sys/frontStudentExpansion/frontUserMobile"><i class="iconx-info-mobile"></i>修改手机信息</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="main-content col-md-9" role="main">
            <input type="hidden" id="userid" value="${studentExpansion.user.id }"/>   <!--图片上传 隐藏域  -->
            <div class="user-info-content clearfix" style="margin-left: 0">
                <form id="inputForm" class="form-horizontal"
                      action="${ctxFront}/sys/frontStudentExpansion/updatePassWord" method="post">
                    <div class="edit-bar edit-bar-sm edit-bar-both clearfix">
                        <div class="edit-bar-left">
                            <span>登录密码</span>
                            <button type="button" class="btn btn-save btn-sm" onclick="submitPassword();">保 存</button>
                            <i class="line"></i>
                        </div>
                    </div>
                    <div class="user-info-form user-password-fom mgb-30" style="width: 600px;">
                        <c:if test="${studentExpansion.user.passc==1 }">
                            <div class="form-group">
                                <label style="color:red">初始的密码不安全，请修改密码</label>
                            </div>
                        </c:if>
                        <div class="form-group">
                            <label for="oldPassword" class="control-label"><i
                                    class="icon-require">*</i>旧密码：</label>
                            <div class="input-box">
                                <input id="oldPassword" name="oldPassword" type="password" class="form-control"
                                       autocomplete="off"
                                       class="required"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="newPassword" class="control-label"><i
                                    class="icon-require">*</i>新密码：</label>
                            <div class="input-box">
                                <input id="newPassword" name="newPassword" type="password" class="form-control"
                                       autocomplete="off"
                                       class="required"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="confirmNewPassword" class="control-label"><i
                                    class="icon-require">*</i>确认新密码：</label>
                            <div class="input-box">
                                <input id="confirmNewPassword" name="confirmNewPassword" type="password"
                                       autocomplete="off"
                                       class="required form-control" equalTo="#newPassword"/>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>

</body>
</html>