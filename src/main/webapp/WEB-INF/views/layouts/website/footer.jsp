<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="stylesheet" type="text/css" href="/common/common-css/notify.css?v=11">
<link rel="stylesheet" type="text/css" href="/common/dialog/dialog.css?v=1">
<%--<script type="text/javascript" src="/js/jquery.cookie.js"></script>--%>
<script src="/js/websocket.js" type="text/javascript"></script>
<script src="/js/frontCyjd/frontCommon.js" type="text/javascript"></script>
<%--<script type="text/javascript" src="/common/common-js/bootstrap.min.js"></script>--%>
<input type="hidden" id="userid_27218e9429b04f06bb54fee0a2948350" value="${fns:getUser().id}">
<input type="hidden" id="notifyShow_27218e9429b04f06bb54fee0a2948350" value="${notifyShow}">
<div class="footer" style="background:#40444e url('/img/footerbg.jpg') center bottom no-repeat">
    <div class="container">
        <div class="friend-links">
            <c:forEach items="${fns:getCmsLinks()}" var="cmsLink">
                <div class="friend-col">
                    <div class="friend-link">
                        <a href="http://${cmsLink.sitelink}" target="_blank">
                            <c:if test="${'2' eq cmsLink.sitetype}">
                                <img src="${fns:ftpImgUrl(cmsLink.logo)}">
                            </c:if>
                            <c:if test="${cmsLink.sitetype eq '1'}">
                                  <span>${cmsLink.linkname}</span>
                            </c:if>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
        <hr class="split-line">
        <div class="copyright">
            <%-- <c:choose>
                <c:when test="${fnc:getAutoSite().copyright != null && fnc:getAutoSite().copyright != ''}">
                    ${fnc:getAutoSite().copyright}<br>
                    技术支持:武汉噢易云计算股份有限公司

                        <a style="font-size: 12px; color: rgb(0,0,199);text-decoration: underline" href="${fns:getSysFrontIp()}/a" >进入管理门户</a>

                </c:when>
                <c:otherwise>
                    Copyright © 2015-2018 :武汉噢易云计算股份有限公司<br>

                       <a style="font-size: 12px; color: rgb(0,0,199);text-decoration: underline" href="${fns:getSysFrontIp()}/a" >进入管理门户</a>

                </c:otherwise>
            </c:choose> --%>
        </div>

    </div>
</div>
<!--留言-->

<div class="fixed-float-bar">
    <ul class="float-bar-actions">
        <li class="fba-item fba-item-comment">
            <a href="/f/cms/cmsGuestbook/list" target="_blank" title="网站留言">
                <i class="iconfont icon-liuyan"></i>
                <p>留言</p>
            </a>
        </li>
        <li class="fba-item fba-item-top"><a href="javascript: void(0);" title="返回顶部"><i class="iconfont icon-fanhuidingbu"></i></a></li>
    </ul>
</div>

<div id="notifyModule" class="footer-notify-container">
    <div class="notify-wrap">
        <div class="notify-header clearfix">
            <span>消息内容<span class="no-readbar">（<span class="no-read-num"></span>条）</span></span>
            <a href="javascript:void(0);" class="notify-close">
                <img src="/images/notice-close-black.png">
            </a>
            <div class="open-scale">
                <%--<a href="javascript:void(0);" class="open"></a>--%>
                <a href="javascript:void(0);" class="open"><img src="/images/scale-up-black.png"></a>
                <a href="javascript:void(0);" class="scale"><img src="/images/scale-down-black.png"></a>
            </div>
            <!-- <p class="no-read-tip"><span class="no-read-num"></span>条未读消息</p> -->
        </div>
        <div class="notify-body">
            <div class="carousel carousel-notify-generic">
                <div class="carousel-inner" role="listbox">

                </div>
            </div>
        </div>
        <div class="notify-footer">
            <div class="notify-btns text-center">
                <a class="btn-prev disabled" href="javascript:void (0);">上一条</a>
                <a class="btn-next" href="javascript:void (0);">下一条</a>
            </div>
            <%--<div class="notify-know text-center" style="display: none">--%>
            <%--<a class="btn-know" href="javascript:void (0);">我知道了</a>--%>
            <%--</div>--%>
        </div>
    </div>
</div>
<div id="dialogCyjdFooter" class="dialog-cyjd"></div>
<script src="/js/frontCyjd/footer.js"></script>

