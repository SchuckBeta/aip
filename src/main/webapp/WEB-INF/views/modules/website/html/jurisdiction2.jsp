<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<html>

<head>
    <meta charset="utf-8"/>
    <link rel="stylesheet" href="/common/common-css/common.css"/>
    <link rel="stylesheet" href="/common/common-css/bootstrap.min.css"/>
    <!--名师讲堂样式文件-->
    <link rel="stylesheet" href="/css/msStyle.css"/>
    <link rel="stylesheet" href="/other/icofont/iconfont.css">
    <link rel="stylesheet" href="/other/pages/jquery.page.css">
    <meta name="decorator" content="site-decorator"/>
    <title>${frontTitle}</title>
    <style>
        .jurisdiction-box{
            position: absolute;
            top:50%;
            left: 50%;
            margin-left: -200px;
            margin-top: -200px;
            width: 400px;
            height: 400px;
            background: url('/images/jurisdiction.png') no-repeat center;
        }
    </style>
</head>

<body>
    <div class="container" style="height: 100%;position: relative;min-height: 600px;">
        <div class="jurisdiction-box">
            <div class="text-center" style="padding-top: 190px">
                <p class="text-right" style="display: inline-block;font-size: 24px;font-weight: bold;color: #b5b5b5;">
                    页面错误 代码404
                    <a style="display: block;text-align: right;font-size: 14px;line-height: 48px;color: #959595;font-weight: normal" href="javascript:void (0);">
                    返回&gt;&gt;
                    </a>
                </p>
            </div>
        </div>
    </div>
</body>

</html>