<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <meta name="decorator" content="cyjd-site-default"/>
    <%--<meta name="decorator" content="creative"/>--%>
    <title>${frontTitle}</title>
    <link type="text/css" rel="stylesheet" href="/css/course/lesson.css"/>
    <link type="text/css" rel="stylesheet" href="/css/course/swiper-3.4.2.min.css"/>
    <link rel="stylesheet" href="${ctxStatic}/element@2.3.8/index.css">
    <script type="text/javascript" src="/js/course/swiper-3.4.2.min.js"></script>
    <style>
        .container{
            padding-bottom:0;
            margin-bottom:60px;
        }
    </style>
    <script>
        function downLoadCourse(url){
            var userId="${fns:getUser().id}";
            if(userId==""){
                dialogCyjd.createDialog(2, "未登录，不能下载课件");
            }else{
                var $downCount = $('#downCount');
                var val = parseInt($downCount.text());
                setTimeout(function(){
                    $downCount.text(val+1);
                },200);
                location.href=url;
            }
        }
    </script>
</head>
<body>
<input type="hidden" name="p55c4142a72584313a96a8e38d2d16368_foreignId" value="${course.id}"/>
<input type="hidden" name="p55c4142a72584313a96a8e38d2d16368_foreignType" value="2"/>
<input type="hidden" name="p55c4142a72584313a96a8e38d2d16368_likes" value="${course.likes}"/>
<input type="hidden" name="p55c4142a72584313a96a8e38d2d16368_comments" value="${course.comments}"/>
<div id="lessonIntro" class="container container-ct">
    <ol class="breadcrumb breadcrumb-leesson" style="margin-top: 0">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li><a href="${ctxFront}/course/frontCourseList">${cmsCourse.modelname}</a></li>
        <li class="active">课程详情</li>
    </ol>
    <div class="title-module">
        <h3 title="${course.name}">${course.name}</h3>
        <p class="create-time-type">

            <span class="creat-type">
                课程专业：
                <c:forEach items="${course.categoryList}" var="category">
                    <i>${category.label } </i>
                </c:forEach>
            </span>
            <span class="creat-type">课程类型：
                <i> ${fns:getDictLabel(course.type, '0000000078', '')}</i>
            </span>
             <span class="creat-type">课程状态：
                <i> ${fns:getDictLabel(course.status, '0000000082', '')}</i>
            </span>
            <span class="create-time">发布时间：<fmt:formatDate value="${course.publishDate}" pattern="yyyy-MM-dd"/></span>
        </p>
    </div>
    <div class="row lesson-info-module">
        <div class="col-xs-6">
            <div class="video">
                <c:if test="${ not empty  course.coverImg &&  not empty  course.video}">
                    <video controls poster="${fns:ftpImgUrl(course.coverImg)}">
                        <source src="${fns:ftpImgUrl(course.video)}" type="video/mp4">
                    </video>
                </c:if>
                <c:if test="${ not empty  course.coverImg &&  empty  course.video}">
                    <img src="${fns:ftpImgUrl(course.coverImg)}"/>
                </c:if>
                <c:if test="${  empty  course.coverImg &&  not empty  course.video}">
                    <video controls>
                        <source src="${fns:ftpImgUrl(course.video)}" type="video/mp4" >
                    </video>
                </c:if>
                <c:if test="${  empty  course.coverImg &&   empty  course.video}">
                    <img src="/img/video-default.jpg"> <!-- 此处应该填入默认图片-->
                </c:if>
            </div>
        </div>
        <div class="col-xs-6">
            <div class="description">
                <h4>课程描述</h4>
                <p>${course.description}</p>
            </div>
            <div class="teacher">
                <h4>授课教师
                    <c:forEach items="${course.teacherList}" var="teacher">
                        <span> ${teacher.teacherName} ${teacher.postName}</span>
                    </c:forEach>
                </h4>
            </div>
            <div class="down-video dropdown">
                <button id="dLabel" type="button" class="btn btn-primary" data-toggle="dropdown" aria-haspopup="true"
                        aria-expanded="false">
                    下载课件
                    <span class="caret"></span>
                </button>
                <span>下载数(<i id="downCount" class="down-count" style="font-style: normal">${course.downloads}</i>)</span>
                <ul class="dropdown-menu" aria-labelledby="dLabel">
                    <c:if test="${not empty course.attachmentList}">
                        <c:forEach items="${course.attachmentList}" var="attachment">
                            <li>
                                <a onclick="downLoadCourse('/f/course/downLoad?id=${course.id}&url=${attachment.url}&fileName=${attachment.name}')" href="javascript:void(0);">${attachment.name}</a>
                            </li>
                        </c:forEach>
                    </c:if>
                    <c:if test="${ empty course.attachmentList}">
                        <li><span style="padding: 3px 20px;display: inline-block">暂无课件</span></li>
                    </c:if>
                </ul>
            </div>
        </div>
    </div>
    <div class="lesson-teacher-module">
        <ul class="tab-lesson-teaher-nav clearfix" role="tablist">
            <li role="presentation" class="active"><a href="#tabpanelOne" data-toggle="tab">课程介绍</a></li>
            <li role="presentation"><a href="#tabpanelTwo" data-toggle="tab">导师介绍</a></li>
        </ul>
        <div class="tab-content">
            <div role="tabpanel" id="tabpanelOne" class="tab-pane active">
                ${course.courseSummary}
            </div>
            <div role="tabpanel" id="tabpanelTwo" class="tab-pane">
                ${course.teacherSummary}
            </div>
        </div>
    </div>
    <div class="edit-bar edit-bar-sm">
        <div class="edit-bar-left">
            <span>推荐课程</span>
            <i class="line"></i>
        </div>
    </div>
    <div class="swiper-module">
        <div id="swiperLesson" class="swiper-container">

            <div class="swiper-wrapper">
                <c:forEach items="${courseList}" var="courseItem">
                    <div class="swiper-slide swiper-no-swiping">
                        <c:if test="${not empty courseItem.coverImg}">
                            <a class="pic-box" href="/f/course/view?id=${courseItem.id}" style="background-image: url('${fns:ftpImgUrl(courseItem.coverImg)}')">
                                <%--<img src="${fns:ftpImgUrl(courseItem.coverImg)}">--%>
                            </a>
                        </c:if>
                        <c:if test="${ empty courseItem.coverImg}">
                            <a class="pic-box" href="/f/course/view?id=${courseItem.id}" style="background-image: url('/img/video-default.jpg')">
                                <%--<img src="/img/course/200X150.png"> <!--此处应该填默认图片-->--%>
                            </a>
                        </c:if>
                        <h5 class="lesson-name">
                            <a href="/f/course/view?id=${courseItem.id}">${courseItem.name}</a>
                        </h5>
                    </div>
                </c:forEach>
            </div>
        </div>
        <a class="swiper-prev-out" href="javascript:void(0);"><i class="icon icon-angle-left"></i></a>
        <a class="swiper-next-out" href="javascript:void(0);"><i class="icon icon-angle-right"></i></a>
    </div>
    <c:if test="${course.commentFlag=='1'}">
        <%@ include file="/WEB-INF/views/modules/interactive/comment.jsp" %>
    </c:if>
</div>
<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>

<%--<c:if test="${es.isComment=='1'}">--%>
    <%--<%@ include file="/WEB-INF/views/modules/interactive/comment.jsp" %>--%>
<%--</c:if>--%>
<script type="text/javascript">
    (function (name, definition) {
        var hasDefine = typeof define === 'function';
        var hasExports = typeof module !== 'undefined' && module.exports;
        if (hasDefine) {
            define(definition)
        } else if (hasExports) {
            module.exports = definition()
        } else {
            window[name] = definition()
        }
    })('lessonIntro', function (require, exports, module) {

        var SwiperLesson = new Swiper('#swiperLesson', {
            slidesPerView: 6,
            spaceBetween: 15,
            noSwiping: true,
            prevButton: '.swiper-prev-out',
            nextButton: '.swiper-next-out',
        })
    })


</script>
</body>
</html>