<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
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
    <!--头部导航公用样式-->
    <link rel="stylesheet" type="text/css" href="${ctx}/common/common-css/header.css"/>

    <script src="${ctxStatic}/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>

    <script src="${ctx}/other/jquery-ui-1.12.1/jquery-ui.js" type="text/javascript" charset="utf-8"></script>
    <script src="${ctx}/common/common-js/bootstrap.min.js" type="text/javascript"></script>
    <!--用于轮播的js-->
    <!--文本溢出-->
    <script src="${ctx}/js/common.js?v=1" type="text/javascript"></script>
    <script src="${ctx}/js/frontCyjd/frontCommon.js?v=21111" type="text/javascript"></script>

    <link rel="stylesheet" href="${ctxStatic}/element@2.3.8/index.css">


    <script src="${ctx}/js/cityData/citydataNew.js?version=${fns: getVevison()}"></script>
    <script src="${ctxStatic}/vue/vue.js"></script>
    <script src="${ctxStatic}/moment/moment.min.js"></script>
    <script src="${ctx}/js/globalUtils/bluebird.min.js"></script> <!--兼容promise对象-->
    <script src="${ctxStatic}/element@2.3.8/index.js"></script>
    <script src="${ctxStatic}/axios/axios.min.js"></script>
    <script src="${ctx}/js/filters/filters.js?version=${fns: getVevison()}"></script>
    <script src="${ctx}/js/mixins/globalUtils/globalUtilsMixin.js?version=${fns: getVevison()}"></script> <!--全局entire-->
    <script src="${ctx}/js/globalUtils/globalUtils.js"></script> <!--全局工具函数-->
    <script src="${ctx}/js/mixins/colleges/collegesMixin.js"></script> <!--所有学院混合宏-->
    <script src="${ctx}/js/mixins/uploadFileMixin/uploadFileMixin.js"></script><!--element 上传文件函数-->

    <script src="${ctx}/js/mixins/verifyExpression/verifyExpressionMixin.js?version=${fns: getVevison()}"></script>
    <script src="${ctx}/js/mixins/verifyExpression/verifyExpressionBackMixin.js"></script>

    <script src="${ctx}/js/components/home/home.js"></script>

    <script src="${ctx}/js/components/condition/e-condition.js?v=1x"></script>
    <script src="${ctx}/js/components/checkbox/checkboxGroup.js"></script>
    <script src="${ctx}/js/components/checkbox/checkbox.js"></script>
    <script src="${ctx}/js/components/radio/radioGroup.js"></script>
    <script src="${ctx}/js/components/radio/radio.js"></script>
    <script src="${ctx}/js/components/proContestDetail/proContestDetail.js"></script>
    <script src="${ctx}/js/components/panel/e-panel.js"></script>
    <script src="${ctx}/js/components/eFileItem/eFileItem.js"></script>
    <script src="${ctx}/js/components/uploadFile/uploadFile.component.js?version=${fns: getVevison()}"></script>
    <script src="${ctx}/js/components/uploadFile/uploadFile.pw.component.js?version=${fns: getVevison()}"></script>
    <script src="${ctx}/js/components/cropperPic/ePicFIle.js"></script>
    <script src="${ctx}/js/components/eColItem/eColItem.js"></script>
    <script src="${ctx}/js/components/stuTea/stuTea.js"></script>
    <script src="${ctx}/js/mixins/userInfo/userFormMixin.js??version=${fns: getVevison()}"></script>


    <script src="${ctx}/js/components/mobileForm/mobileForm.js"></script> <!--手机表单-->
    <script src="${ctx}/js/components/verificationCodeBtn/verificationCodeBtn.js"></script> <!--验证码-->

    <script src="${ctx}/js/components/cropperPic/cropperPic.js"></script> <!--图片裁剪-->
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/cropper/cropper.min.css">
    <script type="text/javascript" src="${ctxStatic}/cropper/cropper.min.js"></script>

    <script src="${ctx}/js/components/passwordForm/passwordForm.js?version=${fns: getVevison()}"></script><!---修改密码-->

    <script src="${ctx}/other/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="${ctx}/js/directives/globalDirectives.js?version=${fns: getVevison()}"></script>
    <script src="${ctx}/js/components/common/commonComponents.js?version=${fns: getVevison()}"></script>
</head>

<body>
<%@ include file="header.jsp" %>
<div id="content">
    <sitemesh:body/>
</div>
<%@ include file="footer.jsp" %>
</body>
</html>