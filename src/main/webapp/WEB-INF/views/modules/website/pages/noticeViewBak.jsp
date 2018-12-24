<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8"/>
    <meta name="decorator" content="cyjd-site-default"/>
    <title>${frontTitle}</title>
    <link type="text/css" rel="stylesheet" href="/css/noticeCommon.css">

</head>
<body>
<div class="container container-ct">
    <ol class="breadcrumb" style="margin-top: 0">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li><a href="${ctxFront}/frontNotice/noticeList">通知公告</a></li>
        <li class="active">公告详情</li>
    </ol>
    <h3 class="letter-title">${title}</h3>
    <div class="letter-content">
        ${content}
    </div>
</div>
<script type="text/javascript">
    $(function(){
        var minHeight = $(window).height() - $('.footerBox').height() - $('.header').height();
        $('#content').css('min-height',minHeight)
    })
</script>
</body>
</html>
