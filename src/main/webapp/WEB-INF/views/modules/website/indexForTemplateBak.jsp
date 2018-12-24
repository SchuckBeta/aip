<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<html>

<head>
    <meta charset="utf-8"/>
    <meta name="decorator" content="site-decoratorNew"/>
    <link rel="shortcut icon" href="/images/bitbug_favicon.ico">
    <title>${frontTitle}</title>
    <style type="text/css">
        .bannerBox .slideBox .bd > ul li {
            display: none;
        }

        .bannerBox .slideBox .bd > ul li:first-child {
            display: block;
        }



        .itemDisplayBox .title {
            margin: 0 auto 90px;
        }

        .itemDisplayBox {
            background-color: #fff;
        }

        .itemDisplayBox .threeBlock li.active {
            background-color: #e9442d;
        }

        .itemDisplayBox .threeBlock li.active a {
            color: #fff;
        }

        .itemDisplayBox .content li h5 a {
            color: #333;
        }

        .itemDisplayBox .content li h5 a:hover {
            color: #e9442d;
        }

        .itemDisplayBox .content li p {
            color: #333;
        }

        .hots-container {
            padding-top: 30px;
            padding-bottom: 60px;
            margin-bottom: 60px;
            background-color: #222;
        }

        .hotspotBox .content {
            margin: 0 auto;
        }

        .hotspotBox .title {
            margin: 0 auto -1px;
        }

        .hotspotBox {
            padding-top: 38px;
            background: url('/img/indexdecopic2_x.jpg') no-repeat top center;
        }
    </style>
</head>

<body>
<%--${fns:getHtmlByTemplate("bd7d7b24c07b44d0a38222e142c84a11") }--%>
<%--<!-- banner -->--%>
<%--${fns:getHtmlByTemplate("8f4370e77a184e299c855d6a5c523377") }--%>

<!-- 大赛热点 -->
<!--优秀项目展示-->
<%--<img class="indexdeco" src="/img/indexdecopic_14.png" alt="" />--%>
<div id="goodProjeExcellentProject" class="itemDisplayBox">
    <div class="text-center" style="margin-bottom: 60px;">
        <a href="/f/pageProject">
            <img src="/img/indexItemTitle.png"/>
        </a>
    </div>
    <ul class="threeBlock">
        <li class="active"><a href="#project1" data-toggle="tab">优秀双创项目</a></li>
        <li>
            <c:if test="${excellentShowList.gcontest!=null&&fn:length(excellentShowList.gcontest)>0}">
                <a href="#project0" data-toggle="tab">大赛获奖作品</a>
            </c:if>
            <c:if test="${excellentShowList.gcontest==null||fn:length(excellentShowList.gcontest)==0}">
                <a href="#project0">大赛获奖作品</a>
            </c:if>
        </li>
    </ul>
    <div class="tab-content">
        <ul id="project1" class="active tab-pane content">
            <c:forEach var="porject" items="${excellentShowList.project}">
                <li>
                    <div class="project-thumbnail">
                        <a href="/f/frontExcellentView-${porject.id}"><img
                                src="${not empty porject.coverImg ? fns:ftpImgUrl(porject.coverImg) : '/img/video-default.jpg'}"
                                alt="${porject.name}">
                        </a>
                    </div>
                    <h5><a href="/f/frontExcellentView-${porject.id}">${porject.name}</a></h5>
                    <div class="pro-about"><span>负责人：${porject.leadername}</span><span>指导老师：${porject.teas}</span></div>
                    <p>${porject.introduction}</p>
                        <%--<div class="project-show-footer">--%>
                        <%--<span class="view-count"><img src="/img/pl.png"/> ${porject.comments} </span>--%>
                        <%--<span class="voteup">--%>
                        <%--<img src="/img/ll.png"/> ${porject.views} </span>--%>
                        <%--<span class="votedown">--%>
                        <%--<img src="/img/z.png"/> ${porject.likes}--%>
                        <%--</span>--%>
                        <%--</div>--%>
                    <div class="pro-like-look text-right">
                        <span class="source">来源：${porject.ptypename}</span>
                        <span><img src="/img/ll-gray.png"/>${porject.views}</span>
                        <span><img src="/img/z-gray.png"/>${porject.likes}</span>
                    </div>
                </li>
            </c:forEach>
        </ul>
        <ul id="project0" class="tab-pane content">
            <c:forEach var="porject" items="${excellentShowList.gcontest}">
                <li>
                    <div class="project-thumbnail">
                        <a href="/f/frontExcellentView-${porject.id}">
                            <img src="${not empty porject.coverImg ? fns:ftpImgUrl(porject.coverImg) :'/img/video-default.jpg'}"
                                 alt="${porject.name}"> </a>
                    </div>
                    <h5><a href="/f/frontExcellentView-${porject.id}">${porject.name}</a></h5>
                    <div class="pro-about"><span>负责人：${porject.leadername}</span><span>指导老师：${porject.teas}</span></div>
                    <p>${porject.introduction}</p>

                    <%--<div class="project-show-footer">--%>
							<%--<span class="view-count"><img src="/img/pl-gray.png"/>--%>
								<%--${porject.comments} </span> <span class="voteup"><img--%>
                            <%--src="/img/ll-gray.png"/> ${porject.views} </span> <span class="votedown"><img--%>
                            <%--src="/img/z-gray.png"/> ${porject.likes} </span>--%>
                    <%--</div>--%>
                    <div class="pro-like-look text-right">
                        <span class="source">来源：${porject.ptypename}</span>
                        <span><img src="/img/ll-gray.png"/>${porject.views}</span>
                        <span><img src="/img/z-gray.png"/>${porject.likes}</span>
                    </div>
                </li>
            </c:forEach>
        </ul>
    </div>
</div>
<!--优秀项目展示end-->
<!--名师讲堂-->
<div id="outstandingTeahcers" class="text-center">
    <a href="${ctxFront}/course/frontCourseList">
        <img style="width: 100%;display: block;" src="/img/indexdecopic2_09.png" alt=""/></a>
</div>
<div class="teacher-wrap">
    <div class="teacherClassBox">
        <c:forEach var="course" items="${courseList}">
            <div class="teach-box">
                <div class="media">
                    <div class="date">
                        <strong><fmt:formatDate value="${course.publishDate}"
                                                pattern="dd"/></strong>/
                        <fmt:formatDate value="${course.publishDate}" pattern="MM"/>
                    </div>
                    <a href="/f/course/view?id=${course.id}"> <c:if
                            test="${not empty course.coverImg}">
                        <img src="${fns:ftpImgUrl(course.coverImg)}"/>
                    </c:if> <c:if test="${ empty course.coverImg}">
                        <img src="/img/course/200X150.png"/>
                        <!--默认图片-->
                    </c:if>
                    </a>

                </div>
                <div class="description">
                    <h4><a href="${ctxFront}/course/view?id=${course.id}">${course.name}</a></h4>
                    <div class="teachers"><span class="name">课程讲师：${course.teasNames}</span><span>讲师职称：${course.teasTitles}</span></div>
                    <p class="desc">课程简介：${course.description}</p>
                    <div class="btns">
                        <img src="/img/pl.png"/> <a class="view-count">${course.comments}</a>
                        &nbsp;&nbsp; <img src="/img/ll.png"/> <a class="voteup">${course.views}</a>
                        &nbsp;&nbsp; <img src="/img/z.png"/> <a class="votedown">${course.likes}</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
<!--导师风采-->
<div id="topTeachers" class="teacherGraceBox">
    <div class="text-center" style="margin: 60px 0 45px;">
        <a href="/f/pageTeacher">
            <img src="/img/teacherTitle.png" alt=""/>
        </a>
    </div>
    <div class="content">
        <ul class="right">
            <c:forEach var="backTeacherExpansion" items="${siteTeacherList}">
                <li>
                    <div class="people">
                        <c:choose>
                            <c:when
                                    test="${backTeacherExpansion.user.photo!=null && backTeacherExpansion.user.photo!='' }">
                                <img src="${fns:ftpImgUrl(backTeacherExpansion.user.photo) }"
                                     alt="${backTeacherExpansion.user.name}">

                            </c:when>
                            <c:otherwise>
                                <img src="/img/u4110.png"
                                     alt="${backTeacherExpansion.user.name}">

                            </c:otherwise>
                        </c:choose>
                    </div>
                    <p class="infor">
                        <b class="name">${backTeacherExpansion.user.name}</b>
                        <c:forEach var="item" items="${backTeacherExpansion.keywords}">
                            <span>${item}</span>
                        </c:forEach>
                    </p>
                    <p class="intro" id="intro">${backTeacherExpansion.mainExp}</p>
                </li>
            </c:forEach>
        </ul>
        <div class="left">
            <div id="slideBox3" class="slideBox3">
                <div class="hd">
                    <ul>
                        <li></li>
                        <li></li>
                        <li></li>
                    </ul>
                </div>
                <div class="bd">
                    <ul>
                        <c:forEach var="backTeacherExpansion" items="${firstTeacherList}">
                            <li>
                                <div class="infor">
                                    <div class="people">
                                        <c:choose>
                                            <c:when
                                                    test="${backTeacherExpansion.user.photo!=null && backTeacherExpansion.user.photo!='' }">
                                                <img
                                                        src="${fns:ftpImgUrl(backTeacherExpansion.user.photo) }"
                                                        alt="${backTeacherExpansion.user.name}">

                                            </c:when>
                                            <c:otherwise>
                                                <img src="/img/u4110.png"
                                                     alt="${backTeacherExpansion.user.name}">

                                            </c:otherwise>
                                        </c:choose>

                                    </div>
                                    <div class="teacher-name_title"><b
                                            class="name">${backTeacherExpansion.user.name}</b><i class="t-title">${backTeacherExpansion.technicalTitle}</i>
                                    </div>
                                    <div class="teacher-tags">
                                    <c:forEach var="item" items="${backTeacherExpansion.keywords}">
			                            <span>${item}</span>
			                        </c:forEach>
                                    </div>
                                        <%--<p>--%>
                                        <%--<span>${fns:getDictLabel(backTeacherExpansion.user.degree, 'degree_type', '')}</span>--%>
                                        <%--</p>--%>
                                </div>
                                <div class="intro">
                                    <p>${backTeacherExpansion.mainExp}</p>
                                        <%-- <p>教育部人文社科2011年度青年基金项目“基于专业取向的美国教师教育课程思想研究”（11YJC880015） 　　全国教育科学“十二五”规划2011年度教育部重点“美国社区学院兼职教师的专业发展及启示——基于“双师型”教师培养的视角”（GJA114021） 　　湖北省教育科学“十二五”规划2011年度专项资助重点“免费师范生在教师教育课程中的学习经验与成效研究”（2011B096） 　　湖北省教育厅人文社科2011年度指导性项目“推进大学生健康发展——闲暇教育探讨”（405） 　　中央高校基本科研业务费专项资金资助“当代美国教师教育课程思想的发展及其启示”（2010DG027） 　　湖北省基础教育研究中心“启航”项目“我国免费师范生课程设置研究”（11QH16 0012） 　　参与哥伦比亚大学教育学院Goodwin教授 《新教师入职培养项目》（获联邦政府资助975万美元） 　　参与教育部[2007]重大研究项目“教育公平研究”子项目“国际教育公平比较研究”</p>--%>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
                <a class="prev" href="javascript:void(0)"></a> <a class="next"
                                                                  href="javascript:void(0)"></a>
            </div>
        </div>
    </div>
</div>
<!--导师风采end-->

<!-- 通知通告 -->
<%--${fns:getHtmlByTemplate("67d3994d9d274a38840432200d441d7a") }--%>
<div id="scNEWS" style="width: 1240px;margin: 0 auto">
    <%--<c:forEach var="site"--%>
               <%--items="${fns:siteByCategoryId('3817dff6b23a408b8fe131595dfffcbc') }">--%>
        <%--<c:forEach var="category" items="${site.categorys}">--%>
            <%--<div class="sc-news">--%>
                <%--<input id="userId" type="hidden" value="${user }"/>--%>
                <%--<c:forEach var="region" items="${category.childRegionList}">--%>
                    <%--<c:if test="${(region.id eq '2367106550234879b0bedd745fdd4c96')}">--%>
                        <%--<cms:frontDataPanels region="${region }"--%>
                                             <%--oaNotifys="${fns:getOaNotifysSC() }" type="SC"/>--%>
                    <%--</c:if>--%>
                    <%--<c:if test="${(region.id eq 'b0c0a68c40624a5c8a44fa29dbcac539')}">--%>
                        <%--<cms:frontDataPanels region="${region }"--%>
                                             <%--oaNotifys="${fns:getOaNotifysTZ() }" type="TZ"/>--%>
                    <%--</c:if>--%>
                    <%--<c:if test="${(region.id eq '7ae366ba21a44934b820364edaa8b292')}">--%>
                        <%--<cms:frontDataPanels region="${region }"--%>
                                             <%--oaNotifys="${fns:getOaNotifysSS() }" type="SS"/>--%>
                    <%--</c:if>--%>
                <%--</c:forEach>--%>
            <%--</div>--%>
        <%--</c:forEach>--%>
    <%--</c:forEach>--%>
</div>
<!--名师讲堂end-->
<!--本页面相关js部分-->
<script src="/js/index.js" type="text/javascript" charset="utf-8"></script>
</body>
</html>