<%@page import="com.oseasy.pcore.modules.sys.entity.User" %>
<%@page import="com.oseasy.pcore.modules.sys.utils.CoreUtils" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%request.setAttribute("user", UserUtils.getUser());%>
<!DOCTYPE html>
<html>
<head>
    <meta name="renderer" content="webkit">
    <script type="text/javascript">
        $frontOrAdmin = "${frontOrAdmin_2ed8fe6ddd034cffa47a41e42a694948}";
        var ftpHttp = '${ftpHttp}'; //修复bug使用
        var webMaxUpFileSize = "${fns:getMaxUpFileSize()}";//修复bug使用
    </script>
    <title><sitemesh:title/></title>
    <link rel="shortcut icon" href="/images/bitbug_favicon.ico"/>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <meta http-equiv="Cache-Control" content="no-store"/>
    <meta http-equiv="Pragma" content="no-cache"/>
    <meta http-equiv="Expires" content="0"/>

    <link rel="stylesheet" type="text/css" href="${ctxStatic}/frontCyjd/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/frontCyjd/jquery-ui.css?v=1"/>
    <%--<link rel="stylesheet" type="text/css" href="/other/jquery-ui-1.12.1/jquery-ui.css"/>--%>
    <!--头部导航公用样式-->
    <link rel="stylesheet" type="text/css" href="/common/common-css/header.css"/>

    <link rel="stylesheet" type="text/css" href="/css/index.css?v=1"/>
    <link rel="stylesheet" type="text/css" href="/css/commonCyjd.css"/>
    <link rel="stylesheet" type="text/css" href="/css/frontCyjd/frontBime.css?v=q111121">


    <link rel="stylesheet" type="text/css" href="/css/allCommonTest.css"/>
    <!--focus样式表-->

    <script src="${ctxStatic}/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>

    <script src="/other/jquery-ui-1.12.1/jquery-ui.js" type="text/javascript" charset="utf-8"></script>
    <script src="/common/common-js/bootstrap.min.js" type="text/javascript"></script>
    <!--用于轮播的js-->
    <!--文本溢出-->
    <script src="/js/common.js?v=1" type="text/javascript"></script>
    <script src="/js/frontCyjd/frontCommon.js?v=21111" type="text/javascript"></script>


    <link rel="stylesheet" href="${ctxStatic}/element@2.3.8/index.css">
    <link rel="stylesheet" href="/css/cyjd/common.css">
    <%--<link rel="stylesheet" href="/css/cyjd/creatives.css?v=x">--%>
    <%--<link rel="stylesheet" href="/css/frontCyjd/creatives.css?v=q12">--%>
    <%--<link rel="stylesheet" href="/css/vendors/vendors.59d1419f63c48a7da6d0.css">--%>
    <link rel="stylesheet" href="/css/common/common.bundle.css">
    <link rel="stylesheet" href="/css/common/headerFooter.bundle.css">
    <link rel="stylesheet" href="/css/frontCyjd/frontCreative.bundle.css">


    <script src="/js/cityData/citydataNew.js?version=${fns: getVevison()}"></script>
    <script src="${ctxStatic}/vue/vue.js"></script>
    <script src="${ctxStatic}/moment/moment.min.js"></script>
    <script src="/js/globalUtils/bluebird.min.js"></script> <!--兼容promise对象-->
    <script src="${ctxStatic}/element@2.3.8/index.js"></script>
    <script src="${ctxStatic}/axios/axios.min.js"></script>
    <script src="/js/filters/filters.js?version=${fns: getVevison()}"></script>
    <script src="/js/mixins/globalUtils/globalUtilsMixin.js?version=${fns: getVevison()}"></script> <!--全局entire-->
    <script src="/js/globalUtils/globalUtils.js"></script> <!--全局工具函数-->
    <script src="/js/mixins/colleges/collegesMixin.js"></script> <!--所有学院混合宏-->
    <script src="/js/mixins/uploadFileMixin/uploadFileMixin.js"></script><!--element 上传文件函数-->

    <script src="/js/mixins/verifyExpression/verifyExpressionMixin.js?version=${fns: getVevison()}"></script>
    <script src="/js/mixins/verifyExpression/verifyExpressionBackMixin.js"></script>

    <script src="/js/components/home/home.js"></script>

    <script src="/js/components/condition/e-condition.js?v=1x"></script>
    <script src="/js/components/checkbox/checkboxGroup.js"></script>
    <script src="/js/components/checkbox/checkbox.js"></script>
    <script src="/js/components/radio/radioGroup.js"></script>
    <script src="/js/components/radio/radio.js"></script>
    <script src="/js/components/proContestDetail/proContestDetail.js"></script>
    <script src="/js/components/panel/e-panel.js"></script>
    <script src="/js/components/eFileItem/eFileItem.js"></script>
    <script src="/js/components/uploadFile/uploadFile.component.js?version=${fns: getVevison()}"></script>
    <script src="/js/components/uploadFile/uploadFile.pw.component.js?version=${fns: getVevison()}"></script>
    <script src="/js/components/cropperPic/ePicFIle.js"></script>
    <script src="/js/components/eColItem/eColItem.js"></script>
    <script src="/js/components/stuTea/stuTea.js"></script>
    <script src="/js/mixins/userInfo/userFormMixin.js??version=${fns: getVevison()}"></script>


    <script src="/js/components/mobileForm/mobileForm.js"></script> <!--手机表单-->
    <script src="/js/components/verificationCodeBtn/verificationCodeBtn.js"></script> <!--验证码-->

    <script src="/js/components/cropperPic/cropperPic.js"></script> <!--图片裁剪-->
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/cropper/cropper.min.css">
    <script type="text/javascript" src="${ctxStatic}/cropper/cropper.min.js"></script>

    <script src="/js/components/passwordForm/passwordForm.js?version=${fns: getVevison()}"></script><!---修改密码-->

    <script src="/other/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="/js/directives/globalDirectives.js?version=${fns: getVevison()}"></script>
    <script src="/js/components/common/commonComponents.js?version=${fns: getVevison()}"></script>
    <script type="text/javascript" src="/js/components/pwEnter/pwEnterMixin.js?version=${fns: getVevison()}"></script>
    <script type="text/javascript" src="/js/components/updateMember/updateMember.js?version=${fns: getVevison()}"></script>
    <script type="text/javascript" src="/js/components/pwEnter/pwEnterApplyRules.js?version=${fns: getVevison()}"></script>
    <script type="text/javascript" src="/js/components/pwEnter/pwEnterApplyForm.js?version=${fns: getVevison()}"></script>
    <script type="text/javascript" src="/js/components/pwEnter/pwEnterList.js?version=${fns: getVevison()}"></script>
    <script type="text/javascript" src="/js/components/pwEnter/pwEnterView.js?version=${fns: getVevison()}"></script>
    <script>


        +function (Vue, axios, window) {

            'use strict';
            var ftpHttp = '${fns:ftpHttpUrl()}';
            var webMaxUpFileSize = "${fns:getMaxUpFileSize()}";
            var $frontOrAdmin = "${frontOrAdmin_2ed8fe6ddd034cffa47a41e42a694948}";
            var token = (function () {
                var arr, reg = new RegExp("(^| )" + 'token' + "=([^;]*)(;|$)");
                return (arr = document.cookie.match(reg)) ? unescape(arr[2]) : null;
            })();


            Vue.mixin({
                data: function () {
                    return {
                        pageLoad: false,
                        formSubmitMessage: '${message}',
                        ftpHttp: '${fns:ftpHttpUrl()}',
                        frontOrAdmin: "${frontOrAdmin_2ed8fe6ddd034cffa47a41e42a694948}",
                        domainPrefix: '${frontOrAdmin_2ed8fe6ddd034cffa47a41e42a694948}',
                        webMaxUpFileSize: parseInt(webMaxUpFileSize),
                        xhrErrorMsg: '请求失败',
                        loginCurUser: JSON.parse(JSON.stringify(${fns: toJson(user)})) || {},
                    }
                },
                computed: {
                    isStudent: function () {
                        return this.loginCurUser.userType === '1';
                    },
                    isTeacher: function () {
                        return this.loginCurUser.userType === '2';
                    }
                },
                methods: {
                    show$message: function (data, message) {
                        var type = (parseInt(data.ret) || data.status) ? 'success' : 'error';
                        var msg = data.msg || message;
                        if (!msg) {
                            return false;
                        }
                        this.$message({
                            type: type,
                            center: true,
                            message: msg
                        })
                    },
                },
                created: function () {
                    this.pageLoad = true;

//                    this.$message({
//                        duration: 1000
//                    })
                }
            });

            window.ctxFront = '${ctxFront}';
            //全局配置axios；
            axios.defaults.baseURL = '${ctxFront}';
            axios.defaults.timeout = 60 * 1000;
            axios.interceptors.request.use(function (config) {
                if (config.url.indexOf('?') == -1) {
                    config.url += '?';
                } else {
                    config.url += '&';
                }
                config.url += 't=' + Date.parse(new Date()) / 1000;
                return config
            }, function (error) {
                try {
                    return Promise.reject(error)
                } catch (e) {

                }
            })
//            console.log(Promise)
            axios.interceptors.response.use(function (response) {
                // Do something with response data
                var data = response;
                try {
                    data.data = JSON.parse(data.data);
                } catch (e) {

                }
                return data;
            }, function (error) {
                // Do something with response error
                try {
                    return Promise.reject(error);
                } catch (e) {

                }
            });
            axios.defaults.headers = {
                'token': token
            };

            Vue.prototype.$axios = axios;


            //封装object assign
            if (typeof Object.assign != 'function') {
                (function () {
                    Object.assign = function (target) {
                        'use strict';
                        if (target === undefined || target === null) {
                            throw new TypeError('Cannot convert undefined or null to object');
                        }

                        var output = Object(target);
                        for (var index = 1; index < arguments.length; index++) {
                            var source = arguments[index];
                            if (source !== undefined && source !== null) {
                                for (var nextKey in source) {
                                    if (source.hasOwnProperty(nextKey)) {
                                        output[nextKey] = source[nextKey];
                                    }
                                }
                            }
                        }
                        return output;
                    };
                })();
            }


            Object.toURLSearchParams = function (data) {
                'use strict';
                if (data === undefined || data === null) {
                    throw new TypeError('Cannot convert undefined or null to object');
                }
                if (typeof URLSearchParams === 'function') {
                    var params = new URLSearchParams();
                    for (var k in data) {
                        if (data.hasOwnProperty(k)) {
                            if (data[k]) {
                                params.append(k, data[k]);
                            }
                        }
                    }
                    return params;
                }
                var str = [];
                var strObj = {};
                for (var k2 in data) {
                    if (data.hasOwnProperty(k2)) {
                        if ({}.toString.call(data[k2]) === '[object Array]') {
                            var vStr = data[k2].join(',');
                            if (vStr) {
                                strObj[k2] = (k2 + '=' + encodeURI(vStr))
                            }
                        } else {
                            if (data[k2] != undefined) {
                                strObj[k2] = (k2 + '=' + encodeURI(data[k2]))
                            }
                        }

                        strObj[k2] && str.push(strObj[k2])
                    }
                }
                return str.join('&')
            }


        }(Vue, axios, window)

    </script>
    <sitemesh:head/>
</head>

<body>
<%@ include file="headerNew.jsp" %>
<div id="content">
    <sitemesh:body/>
</div>
<%@ include file="footer.jsp" %>
<div id="dialog-message" title="信息" style="display: none;">
    <p id="dialog-content"></p>
</div>
</body>
</html>