<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <title>${frontTitle}</title>
    <meta name="decorator" content="site-decorator"/>
    <link rel="stylesheet" type="text/css" href="/css/calender.css">
    <style>
        /*a.btn+a{*/
        /*margin-top: 4px;*/
        /*}*/

        .btn-current-project{
            color: #4b4b4b;
            background-color: #bebebe;
        }
        .project-name{
            display: block;
            max-width: 300px;
            margin: 0 auto;
            overflow: hidden;
        }
    </style>
</head>
<body>
<div class="container-fluid container-fluid-oe">
    <div class="text-right mgb15">
        <a href="/f/gcontest/gContest/" class="btn btn-current-project">我的大赛列表</a>
        <a href="javascript:void (0);" class="btn btn-primary-oe">当前大赛</a>
    </div>
    <div class="prj-desc">
        <h4 id="form-head-title"></h4>
        <p class="prj-num"><strong>项目编号：</strong><span id="prj-num"></span></p>
    </div>
    <div class="outer-wrap">
        <div class="calender-list" id="calender-list"></div>
    </div>
</div>
<script type="text/javascript" src="/js/calender.js"></script>



</body>
</html>