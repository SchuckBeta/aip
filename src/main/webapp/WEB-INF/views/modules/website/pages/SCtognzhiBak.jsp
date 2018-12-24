<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <meta name="decorator" content="cyjd-site-default"/>
    <!--双创通知样式页面-->
    <title>${frontTitle}</title>
    <!--公用重置样式文件-->
    <link rel="stylesheet" type="text/css" href="/css/sctz.css"/>
    <script src="/js/projectShow.js"></script>
    <script type="text/javascript">
        var viewUrl = "${ctxFront}/oa/oaNotify/viewDynamic";
        $(document).ready(function () {
            $('#TAB>li').on('click', function () {
                $(this).addClass('active').siblings().removeClass('active')
                $('#tab_chang .tab_select').parent().eq($(this).index()).show().siblings().hide();
            })
            page1(1, 10);
            page2(1, 10);
            page3(1, 10);
            var hash = window.location.hash;
            $(hash).trigger('click');
        });
        function page1(pageNo, pageSize) {
            $.ajax({
                url: "/f/oa/oaNotify/getPageJson",
                dataType: 'json',
                data: {
                    funcName: "page1",
                    type: "4",
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                success: function (data) {
                    var dataList = data.list;
                    var pageHtml = data.courseFooter;
                    var liHtml = ''
                    $(dataList).each(function (i, oaNotify) {
                        var href = viewUrl + "?id=" + oaNotify.id;
                        liHtml += '<li> <a href="' +
                                href +
                                '">' +
                                oaNotify.title +
                                ' <span>' +
                                oaNotify.updateDate +
                                '</span></a> </li>';
                    });
                    $("#page1").html(liHtml)
                    $("#page1").parent().find('.pagination-wrap').append(pageHtml);
                }
            })
        }
        function page2(pageNo, pageSize) {
            $.ajax({
                url: "/f/oa/oaNotify/getPageJson",
                dataType: 'json',
                data: {
                    funcName: "page2",
                    type: "8",
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                success: function (data) {
                    var dataList = data.list;
                    var pageHtml = data.courseFooter;
                    var liHtml = '';
                    $(dataList).each(function (i, oaNotify) {
                        var href = viewUrl + "?id=" + oaNotify.id;
                        liHtml += '<li> <a href="' +
                                href +
                                '">' +
                                oaNotify.title +
                                ' <span>' +
                                oaNotify.updateDate +
                                '</span></a> </li>';


                    });
                    $("#page2").html(liHtml)
                    $("#page2").parent().parent().find('.pagination-wrap').html(pageHtml);
                }
            })
        }
        function page3(pageNo, pageSize) {
            $.ajax({
                url: "/f/oa/oaNotify/getPageJson",
                dataType: 'json',
                data: {
                    funcName: "page3",
                    type: "9",
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                success: function (data) {
                    var dataList = data.list;
                    var pageHtml = data.courseFooter;
                    var liHtml = '';
                    $(dataList).each(function (i, oaNotify) {
                        var href = viewUrl + "?id=" + oaNotify.id;
                        liHtml += '<li> <a href="' +
                                href +
                                '">' +
                                oaNotify.title +
                                ' <span>' +
                                oaNotify.updateDate +
                                '</span></a> </li>';


                    });
                    $("#page3").html(liHtml)
                    $("#page3").parent().parent().find('.pagination-wrap').html(pageHtml);
                }
            })
        }


    </script>

    <style>
        ul, li {
            padding: 0;
            list-style: none;
            margin: 0;
        }

        .pagination_num {
            margin-top: 20px;
        }

        .sxtz_li ul li a:hover, .sxtz_li ul li a:focus {
            color: #e9432d;
            text-decoration: none;
        }

        .tab_clum{
            position: relative;
            height:40px;
        }

        .tab_clum .tab{
            text-align: center;
            width: auto;
            margin: 0 auto;
            overflow: hidden;
            display: inline-block;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
        }

        .tab_clum .tab li.active {
            border-bottom: 2px solid #e92f27;
        }

        .tab_clum .tab li.active a {
            color: #e9432d;
        }

        .tab_clum .tab li a {
            text-decoration: none;
        }

        .sxtz_li li {
            position: relative;
            height: 42px;
            line-height: 42px;
            border-bottom: 1px solid #eee;
        }

        .sxtz_li li:before {
            content: '';
            display: inline-block;
            margin-right: 10px;
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background-color: #333;
            vertical-align: middle;
        }

    </style>
</head>

<body>
<div class="container container-ct">
    <ol class="breadcrumb" style="margin-top: 0">
        <li>
            <a href="${ctxFront}#scNEWS"><i class="icon-home"></i>首页</a>
        </li>
        <li class="active">通知动态</li>
    </ol>
    <div class="scinfo">
        <!-- <div class="scinfonavigation">
            <ul>
                <li><img src="/img/bc_home.png"></li>
                <li><a href="/f/">首页></a>  </li>
                <li>双创通知</li>
            </ul>
        </div> -->
    </div>
    <div style="clear: both;"></div>
    <div class="tab_clum" style="margin-top: 0">
        <ul class="tab" id="TAB">
            <%--<li id="SC" class="active">--%>
                <%--<a href="javascript:void(0);">双创动态</a>--%>
            <%--</li>--%>
            <%--<li id="TZ">--%>
                <%--<a href="javascript:void(0);">双创通知</a>--%>
            <%--</li>--%>
            <%--<li id="SS">--%>
                <%--<a href="javascript:void(0);">双创政策</a>--%>
            <%--</li>--%>


            <c:forEach var="site"
                       items="${fns:siteByCategoryId('3817dff6b23a408b8fe131595dfffcbc') }">
                <c:forEach var="category" items="${site.categorys}">
                        <c:forEach var="region" items="${category.childRegionList}">
                            <c:if test="${(region.id eq '2367106550234879b0bedd745fdd4c96')}">
                                <c:forEach var="resource" items="${region.childResourceList}">
                                    <li id="SC" class="active">
                                        <a href="javascript:void(0);">${resource.title}</a>
                                    </li>
                                </c:forEach>
                            </c:if>
                            <c:if test="${(region.id eq 'b0c0a68c40624a5c8a44fa29dbcac539')}">
                                <c:forEach var="resource" items="${region.childResourceList}">
                                    <li id="TZ">
                                        <a href="javascript:void(0);">${resource.title}</a>
                                    </li>
                                </c:forEach>
                            </c:if>
                            <c:if test="${(region.id eq '7ae366ba21a44934b820364edaa8b292')}">
                                <c:forEach var="resource" items="${region.childResourceList}">
                                    <li id="SS">
                                        <a href="javascript:void(0);">${resource.title}</a>
                                    </li>
                                </c:forEach>
                            </c:if>
                        </c:forEach>
                </c:forEach>
            </c:forEach>


        </ul>
    </div>
    <div style="clear: both;"></div>
    <div id="tab_chang">
        <div>
            <ul id="page1" class="sxtz_li tab_select">
            </ul>
            <div class="pagination-wrap"></div>
        </div>
        <div style="display: none;">
            <ul id="page2" class="sxtz_li tab_select">

            </ul>
            <div class="pagination-wrap"></div>
        </div>
        <div style="display: none;">
            <ul id="page3" class="sxtz_li tab_select">

            </ul>
            <div class="pagination-wrap"></div>
        </div>
    </div>
</div>
</body>
</html>
