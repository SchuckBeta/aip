<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <title>关于</title>
    <script src="${ctxStatic}/jquery/jquery-1.8.3.min.js"
            type="text/javascript"></script>
    <link
            href="${ctxStatic}/bootstrap/2.3.1/css_${not empty cookie.theme.value ? cookie.theme.value : 'cerulean'}/bootstrap.min.css"
            type="text/css" rel="stylesheet"/>
    <script src="${ctxStatic}/bootstrap/2.3.1/js/bootstrap.min.js"
            type="text/javascript"></script>
    <link href="${ctxStatic}/bootstrap/2.3.1/awesome/font-awesome.min.css"
          type="text/css" rel="stylesheet"/>
    <link href="${ctxStatic}/jquery-select2/3.4/select2.min.css"
          rel="stylesheet"/>
    <script src="${ctxStatic}/jquery-select2/3.4/select2.min.js"
            type="text/javascript"></script>
    <link
            href="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.css"
            type="text/css" rel="stylesheet"/>
    <script
            src="${ctxStatic}/jquery-validation/1.11.0/jquery.validate.min.js"
            type="text/javascript"></script>
    <link href="${ctxStatic}/jquery-jbox/2.3/Skins/Bootstrap/jbox.min.css"
          rel="stylesheet"/>
    <script src="${ctxStatic}/jquery-jbox/2.3/jquery.jBox-2.3.min.js"
            type="text/javascript"></script>
    <script src="${ctxStatic}/My97DatePicker/WdatePicker.js"
            type="text/javascript"></script>
    <script src="${ctxStatic}/common/mustache.min.js" type="text/javascript"></script>
    <link href="${ctxStatic}/common/initiate.css" type="text/css"
          rel="stylesheet"/>
    <script src="${ctxStatic}/common/initiate.js?v=1" type="text/javascript"></script>
    <script type="text/javascript">
        var ctx = '${ctx}', ctxStatic = '${ctxStatic}';
    </script>
    <!--公用重置样式文件-->
    <link rel="stylesheet" type="text/css"
          href="/common/common-css/common.css"/>
    <!--头部样式文件公共部分-->
    <link rel="stylesheet" type="text/css"
          href="/common/common-css/header2.css"/>
    <!--创新创业云服务平台管理一级页面样式表-->
    <link rel="stylesheet" type="text/css"
          href="/css/managePlatFormLeverOne.css"/>
    <link rel="stylesheet" type="text/css"
          href="/other/jquery-ui-1.12.1/jquery-ui.css"/>
    <script src="/other/jquery-ui-1.12.1/jquery-ui.js"
            type="text/javascript" charset="utf-8"></script>
    <script src="/js/common.js" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="/css/common.css"/>
    <link rel="stylesheet" type="text/css" href="/css/accredit.css">
    <link rel="stylesheet" type="text/css" href="/css/about.css">
    <script src="/common/common-js/ajaxfileupload.js"></script>
    <script src="/js/accreditInner.js" type="text/javascript"></script>
    <style type="text/css">

        .card {
            position: relative;
            padding: 40px 30px;
            border: 1px solid #ddd;
            max-width: 500px;
            margin-bottom: 40px;
        }

        .card .card-title {
            display: block;
            position: absolute;
            left: 20px;
            top: -10px;
            line-height: 20px;
            height: 20px;
            padding: 0 10px;
            font-size: 14px;
            font-weight: bold;
            color: #333;
            background-color: #fff;
        }

        .card .link {
            color: rgb(0, 0, 230);
            text-decoration: underline;
        }

        .card .license-file {
            color: #e04527;
        }

        .edit-bar {
            margin-bottom: 15px;
        }

        .edit-bar-left {
            position: relative;
        }

        .edit-bar-left > span {
            position: relative;
            padding: 0 15px 0 0;
            color: #e9432d;
            font-size: 16px;
            font-weight: 700;
            line-height: 2.5;
            background: #fff;
            z-index: 1;
        }

        .edit-bar-left .line {
            display: block;
            position: absolute;
            left: 0;
            top: 50%;
            right: 0;
            border-top: 1px solid #f4e6d4;
        }

        .edit-bar .edit-bar-left .weight-line {
            border-top: 3px solid #f4e6d4;
        }

        .edit-bar-sm .edit-bar-left > span {
            color: #000;
            font-size: 16px;
            font-weight: normal;
        }

        .edit-bar-tag .edit-bar-left > span {
        }

        .edit-bar .unread-tag {
            display: inline-block;
            min-width: 10px;
            padding: 3px 7px;
            margin-left: 8px;
            line-height: 1;
            text-align: center;
            border-radius: 10px;
            font-size: 12px;
            font-weight: normal;
            font-style: normal;
            background-color: #e9432d;
            color: #fff;
            vertical-align: middle;
            margin-top: -3px;
        }
    </style>
</head>
<body>
<div id="dialog-message" title="信息" style="display: none;">
    <p id="dialog-content"></p>
</div>

<div class="container-fluid" style="padding-top:15px;">
    <div class="content-wrap">
        <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
        <%--<span>关于</span>--%>
        <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
        <%--</div>--%>
        <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
        <div class="card">
            <span class="card-title">版本信息 </span>
            <p>
                <strong>产品名称：</strong></span>噢易创新创业教育云平台（简称“开创啦”）
            </p>
            <p>
                <strong>版本号：</strong>4.2.1
            </p>
            <p>
                <strong>产品状态：</strong><c:if test="${valid=='1'}">已激活</c:if><c:if test="${valid=='0'}">未激活</c:if><c:if
                    test="${valid=='2'}">已过期</c:if>
            </p>
            <p>
                <strong>产品有效期：</strong><c:if test="${valid=='1'||valid=='2'}">${fns: substringBeforeLast(exp, '00:00:00')}</c:if>

            </p>
        </div>

        <div class="card">
            <span class="card-title">警告</span>
            <p>本产品受版权及国际公约保护，任何单位和个人，在没有经过版权所有者的书面认可下，不得以任何手段复制、改编、引用本文件，版权所有者对该软件的侵权行为诉诸法律的权利。</p>
        </div>

        <%--<div class="footerBox"--%>
             <%--style="height: 40px; line-height: 40px; text-align: center; background-color: rgb(255, 255, 255); position: fixed; bottom: 0px; width: 100%; border-top: 1px solid #ddd;">--%>
            <%--<p class="copyright" style="margin: 0px 10px;">--%>
                <%--<img src="/images/net.png"><span>公司名称：武汉中骏龙新能源科技有限公司</span> <img--%>
                    <%--src="/images/net.png"><span>官方网址：www.os-easy.com</span> <img--%>
                    <%--src="/images/net.png"><span>官方网址400服务电话：4001-027-580</span>--%>
            <%--</p>--%>
        <%--</div>--%>
    </div>
</div>
</body>
</html>