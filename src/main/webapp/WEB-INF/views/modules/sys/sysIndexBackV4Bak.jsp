<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <%--<link rel="stylesheet" type="text/css" href="/common/common-css/bootstrap.min.css">--%>
    <link rel="shortcut icon" href="/images/bitbug_favicon.ico"/>
    <link rel="stylesheet" type="text/css" href="/css/slide_nav.css?v=1121">
    <title>${backgroundTitle}</title>
    <meta name="decorator" content="backPath_header"/>
</head>
<body>
<div class="center-content">
    <div class="slide_nav">
        <ul class="list_wrap" id="list_wrap">
            <li class="level_one">
                <c:if test="${empty firstMenu.href}">
                <a href="javascript:;" style="border-bottom:1px solid #df3b0a;">
                    </c:if>
                    <c:if test="${not empty firstMenu.href}">
                    <a href="${ctx }/${firstMenu.href}" target="mainFrame" style="border-bottom:1px solid #df3b0a;">
                        </c:if>
                        <img src="/img/icon_sc.png">
                        <span>${firstMenu.name}</span>
                    </a>
                    <ul class="sub_list_wrap" id="sub_list_wrap">
                        <c:forEach items="${secondMenus}" var="menu2" varStatus="idx">
                            <c:if test="${fns:checkChildMenu(menu2.id) }">
                                <li class="level_two">
                                    <c:if test="${not empty menu2.href}">
                                        <a data-link="${idx.index}" href="/a${menu2.href}" class="level_two_a"
                                           target="mainFrame">
                                                ${menu2.name}
                                        </a>
                                    </c:if>
                                    <c:if test="${empty menu2.href}">
                                        <a data-link="${idx.index}"
                                           href="${not empty menu2.href?menu2.href:'javascript:;'}" class="level_two_a">
                                                ${menu2.name}
                                        </a>
                                    </c:if>
                                    <ul class="grand_sub_wrap">
                                        <c:forEach items="${menu2.children}" var="menu3" varStatus="idx3">
                                            <li class="level_three">
                                                <a data-link="${idx.index}-${idx3.index}" data-id="${menu3.id}"
                                                   href="/a${menu3.href}"
                                                   target="mainFrame">${menu3.name}
                                                    <c:if test="${menu3.todoCount>0}">
                                                        <i class="unread-tag">${menu3.todoCount}</i>
                                                    </c:if>
                                                    <c:if test="${menu3.todoCount < 0}">
                                                        <i style="display: none" class="unread-tag"></i>
                                                    </c:if>
                                                        <%--<c:if test="${menu3.todoCount<=0}">--%>
                                                        <%--<i class="unread-tag"></i>--%>
                                                        <%--</c:if>--%>
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </li>
                            </c:if>
                        </c:forEach>


                    </ul>
            </li>
        </ul>
    </div>
    <div class="view-panel" id="iframe_wrap">
        <iframe id="mainFrame" name="mainFrame" src="" frameborder="0" height="100%"></iframe>
    </div>
    <%-- 	<div class="view-copyright" id="copyright_wrap">
            <%@ include file="../../../views/layouts/website/copyright.jsp"%>
        </div> --%>
</div>
<%--<script type="text/javascript" src="/js/slide_nav.js"></script>--%>
<!----------页面js初始化----------->
<script type="text/javascript">

    ;
    +function ($) {
        var sideNavModule = {
            sideNav: $('#list_wrap'),
            mainFrame: $('#mainFrame'),
            unreadTimer: null,
            currentHref: '${href}',
            time: 2000,
            initialLink: function () {
                var navIndex = this.getSessionNavIndex();
                var sideNav = this.sideNav;
                var $a = sideNav.find('a[data-link="' + navIndex + '"]');
                var $clickA;
                var isLevelTwo = /javascript/.test($a.attr('href'));
                var currentHref = this.currentHref;
                var $allAs = sideNav.find('a');
                var mainFrame = this.mainFrame;
                if (currentHref) {
                    $allAs.each(function (i, item) {
                        var $item = $(item);
                        var link = $item.attr('href');
                        if (link.indexOf(currentHref) > -1) {
                            mainFrame.attr('src', link);
                            $item.trigger('click.link')
                            return false;
                        }
                    });
                } else {
                    $clickA = isLevelTwo ? sideNav.find('a[data-link="' + navIndex + '-' + 0 + '"]') : $a;
                    mainFrame.attr('src', $clickA.attr('href'));
                    $clickA.trigger('click.link')
                }
            },
            navLinkEvent: function () {
                var sideNav = this.sideNav;
                var self = this;
                this.sideNav.on('click.link', 'a', function (e) {
                    e.stopPropagation();
                    var $li = $(this).parent();
                    var index = $(this).attr('data-link');
                    if ($li.hasClass('level_two')) {
                        $(this).addClass('active').parent().siblings().find('>a').removeClass('active');
                        sideNav.find('.level_three').removeClass('current');
                    } else {
                        $li.addClass('current').siblings().removeClass('current');
                        $li.parents('.level_two').find('>a').addClass('active').end().siblings().find('>a').removeClass('active').next().find('li').removeClass('current');
                    }
                    self.setSessionNavIndex(index)
                })
            },

            changeLink: function (href) {
                var sideNav = this.sideNav;
                var $allAs = sideNav.find('a');
                $allAs.parent().removeClass('current').parent().prev().removeClass('active');
                $allAs.each(function (i, item) {
                    var $item = $(item);
                    var link = $item.attr('href');
                    if (href == link) {
                        $item.parent().addClass('current').parent().prev().addClass('active');
                        return false;
                    }
                });
            },

            changeUnreadTag: function (params) {
                var sideNav = this.sideNav;
                var self = this;
                var levelThrees = sideNav.find('.level_two_a.active').parent().find('.level_three');
                if (this.unreadTimer) {
                    clearTimeout(this.unreadTimer);
                }
                this.unreadTimer = setTimeout(function () {
                    $.ajax({
                        url: '${ctx}/sys/menu/totoReflash/' + params,
                        type: 'GET',
                        dataType: 'json',
                        success: function (data) {
                            var result = data.result;
                            if(!result){
                                sideNav.find('.current').find('i.unread-tag').hide().text('').end().siblings().find('i.unread-tag').hide().text('')
                                return false;
                            }
                            levelThrees.each(function (item) {
                                var $a = $(this).find('>a');
                                var href = $a.attr('href');
                                for (var k in result) {
                                    if (!result.hasOwnProperty(k)) {
                                        continue;
                                    }
                                    if(new RegExp(k, 'i').test(href)){
                                        var value = result[k];
                                        $a.find('i.unread-tag')[(value > 0 ? 'show' : 'hide')]().text(value);
                                    }
                                }
                            })
                        },
                        error: function () {
                        }
                    })
                }, this.time)
            },
            changeStaticUnreadTag: function (dataurl,tagurl, time) {
               setTimeout(function () {
                   $.ajax({
                       url: dataurl,
                       type: 'GET',
                       dataType: 'text',
                       success: function (data) {
                           $("a[href='"+tagurl+"']").find('i.unread-tag')[(data > 0 ? 'show' : 'hide')]().text(data);
                       }
                   });
               }, time || 0)
            },




            setSessionNavIndex: function (index) {
                sessionStorage.setItem('navIndex', index);
            },
            getSessionNavIndex: function () {
                return sessionStorage.getItem('navIndex') || 0;
            },

            topReload: function (url) {
//                location.href = url;
                window.location.reload();
            }
        }
        sideNavModule.navLinkEvent();
        sideNavModule.initialLink();
        window['sideNavModule'] = sideNavModule;


    }(jQuery)


</script>
</body>
</html>
