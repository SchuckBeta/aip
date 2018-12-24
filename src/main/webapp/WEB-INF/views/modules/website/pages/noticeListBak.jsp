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
        <li class="active">通知公告列表</li>
    </ol>
    <form id="searchForm" action="${ctxFront}/frontNotice/noticeList">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
    </form>
    <div class="edit-bar">
        <div class="edit-bar-left">
            <span>通知公告</span>
            <i class="line"></i>
        </div>
    </div>
    <div class="list-group">
        <c:forEach items="${page.list}" var="notify" varStatus="status">
            <a href="${ctxFront}/frontNotice/noticeView?id=${notify.id}" class="list-group-item">
                <span class="date">
                 <fmt:formatDate value="${notify.updateDate}" pattern="yyyy-MM-dd "/>
                </span>
                    ${notify.title}
            </a>
        </c:forEach>
    </div>
    ${page.footer}
</div>
<script type="text/javascript">
    $(function(){
        var minHeight = $(window).height() - $('.footerBox').height() - $('.header').height();
        $('.notice-container').css('min-height',minHeight);
        $("#ps").val($("#pageSize").val());
    })

    function page(n, s) {
        $("#pageNo").val(n);
        $("#pageSize").val(s);
        $("#searchForm").submit();
        return false;
    }
</script>
</body>
</html>