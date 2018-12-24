<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8"/>
    <title>${frontTitle}</title>
    <meta name="decorator" content="cyjd-site-default"/>

    <%--<link rel="stylesheet" href="/common/common-css/common.css"/>--%>
    <%--<link rel="stylesheet" href="/common/common-css/bootstrap.min.css"/>--%>
    <%--<link rel="stylesheet" href="/css/msStyle.css"/> <!--名师讲堂样式文件-->--%>
    <link rel="stylesheet" href="/other/icofont/iconfont.css">  <!--图标样式-->
    <link rel="stylesheet" href="/css/lessonVideo.css">

    <title>${frontTitle}</title>
    <script>
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }

        function search() {
            $("#searchForm").submit();
        }

        function downLoadCourse(url) {
            var userId = "${fns:getUser().id}";
            if (userId == "") {
                dialogCyjd.createDialog(0, "未登录，不能下载课件");
            } else {
                location.href = url;
            }
        }

    </script>
</head>


<body>

<div class="container container-ct">
    <ol class="breadcrumb" style="margin-top: 0">
        <li>
            <a href="${ctxFront}#outstandingTeahcers"><i class="icon-home"></i>首页</a>
        </li>
        <li class="active">名师讲堂</li>
    </ol>
    <div class="row">
        <div class="col-xs-8">
            <h3 class="page-title"><span class="text">课程视频</span><span class="line"></span><i class="block"></i></h3>
            <ul class="lesson-videos">
                <c:forEach items="${page.list}" var="course">
                    <li class="lesson-video">
                        <c:if test="${not empty course.coverImg}">
                            <a class="video"
                               href="/f/course/view?id=${course.id}"
                               style="background-image: url('${fns:ftpImgUrl(course.coverImg)}')">
                            </a>
                        </c:if>
                        <c:if test="${ empty course.coverImg}">
                            <a class="video"
                               href="/f/course/view?id=${course.id}"
                               style="background-image: url('/img/video-default.jpg')">
                            </a>
                        </c:if>
                        <div class="lesson-info">
                            <h4 class="lesson-title">
                                <a href="/f/course/view?id=${course.id}">${course.name}</a>
                            </h4>
                            <p class="description">${course.description}</p>
                            <div class="teachers">
                                课程讲师：
                                <c:forEach items="${course.teacherList}" var="teacher" varStatus="status">
                                    ${teacher.teacherName}&nbsp;&nbsp;${teacher.postName}
                                    <c:if test="${!status.last}">
                                        ,
                                    </c:if>
                                </c:forEach>
                            </div>
                            <div class="lesson-info-footer clearfix">
                                <div class="create-info">
                                    <span><i class="iconfont">&#xe609;</i><fmt:formatDate
                                            value="${course.publishDate}" pattern="yyyy-MM-dd"/></span>
                                    <span><i class="iconfont">&#xe61c;</i>${course.views}</span>
                                    <%--<span><i class="iconfont">&#xe60b;</i>${course.comments}</span>--%>
                                    <span><i class="iconfont">&#xe622;</i>${course.likes}</span>
                                </div>
                                <div class="lesson-down">
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-default dropdown-toggle"
                                                data-toggle="dropdown"
                                                aria-haspopup="true" aria-expanded="false">
                                            <img src="/img/upload.jpg">课件下载
                                        </button>
                                        <ul class="dropdown-menu">
                                            <c:if test="${not empty course.attachmentList}">
                                                <c:forEach items="${course.attachmentList}" var="attachment">
                                                    <li>
                                                        <a onclick="downLoadCourse('/f/course/downLoad?id=${course.id}&url=${attachment.url}&fileName=${attachment.name}');"
                                                           href="javascript:void(0);">${attachment.name}</a></li>
                                                </c:forEach>
                                            </c:if>
                                            <c:if test="${ empty course.attachmentList}">
                                                <li><span style="padding: 3px 20px;display: inline-block">暂无课件</span>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </li>
                </c:forEach>
            </ul>
            ${page.courseFooter}
        </div>
        <div class="col-xs-4">
            <form:form action="${ctxFront}/course/frontCourseList" modelAttribute="course" method="post" id="searchForm">
                <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
                <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
                <div class="form-search-box">
                    <form:input path="name" cssClass="form-control-teacher" placeholder="课程名称或者教师名"></form:input>
                    <div class="search-ic"><i class="iconfont" onclick="search();">&#xe606;</i></div>
                    <span class="line"></span>
                </div>
                <h5 class="sidebar-title">课程分类</h5>
                <div class="lesson-type">
                    <p class="lesson-type-title">专业课程分类</p>
                    <div class="tags">
                        <span><input id="categoryAll" name="categoryAll" type="checkbox"
                                     class="check-lesson-type"><label
                                for="categoryAll">全部</label></span>
                        <form:checkboxes path="categoryValueList" items="${fns:getDictList('0000000086')}"
                                         class="check-lesson-type"
                                         itemLabel="label"
                                         itemValue="value"/>
                    </div>
                </div>
                <div class="lesson-type">
                    <p class="lesson-type-title">课程类型分类</p>
                    <div class="tags">
                        <span><input id="typeAll" name="typeAll" type="checkbox" class="check-lesson-type"><label
                                for="typeAll">全部</label></span>
                        <form:checkboxes path="typeList" items="${fns:getDictList('0000000078')}" itemLabel="label"
                                         class="check-lesson-type"
                                         itemValue="value"/>
                    </div>
                </div>
                <div class="lesson-type">
                    <p class="lesson-type-title">状态分类</p>
                    <div class="tags">
                         <span><input id="statusAll" name="statusAll" type="checkbox" class="check-lesson-type"><label
                                 for="statusAll">全部</label></span>
                        <form:checkboxes path="statusList" items="${fns:getDictList('0000000082')}" itemLabel="label"
                                         class="check-lesson-type"
                                         itemValue="value"/>
                    </div>
                </div>
            </form:form>
            <h5 class="sidebar-title">名师讲堂</h5>
            <ul class="teacher-list">
                <c:forEach items="${allTeachers}" var="teacher">
                    <li class="teacher">
                        <div class="teacher-pic-box">
                            <c:if test="${not empty fns:getUserById(teacher.teacherId).photo }">
                                <img class="img-responsive"
                                     src="${fns:ftpImgUrl(fns:getUserById(teacher.teacherId).photo)}">
                            </c:if>
                            <c:if test="${ empty fns:getUserById(teacher.teacherId).photo }">
                                <img class="img-responsive" src="/img/avatar_default.png"> <!--如果老师没有图像 默认图片-->
                            </c:if>
                        </div>
                        <div class="teacher-info">
                            <p class="name">${teacher.teacherName}<span>${teacher.postName}</span></p>
                            <p class="school">${teacher.collegeName}</p>
                        </div>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
</div>

<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>
<script type="text/javascript">
    $(function () {

        initCheckbox();

        $(document).on('change', '.check-lesson-type', function () {
            var isChecked = $(this).prop('checked');
            var $tags = $(this).parents('.tags');
            var $firstChild = $tags.find('input[type="checkbox"]').eq(0);
            var id = $firstChild.attr('id');
            var isAllChose;
            $(this).parent().toggleClass('active', isChecked);
            if (/all/i.test($(this).attr('id'))) {
                var allChecked = $firstChild.prop('checked');
                $tags.find('input[type="checkbox"]').prop('checked', allChecked).parent().toggleClass('active', allChecked);
            } else {
                isAllChose = isAll($tags, id);
                if (isAllChose) {
                    $firstChild.prop('checked', true);
                    $firstChild.parent().toggleClass('active', true)
                } else {
                    $firstChild.prop('checked', false);
                    $firstChild.parent().toggleClass('active', false)
                }
            }
            //提交表单
            search();
        });

        function isAll(selector, id) {
            var all = selector.find('input[type="checkbox"]').not(':checked');
            return all.size() === 1 && all.attr('id') === id;
        }

        function initCheckbox() {
            $('.lesson-type .tags').each(function () {
                var $allInputCheckbox = $(this).find('input[type="checkbox"]').eq(0);
                var isAllChose = isAll($(this), $allInputCheckbox.attr('id'));
                $allInputCheckbox.prop('checked', isAllChose).parent().toggleClass('active', isAllChose)
            });
            $('.lesson-type input[type="checkbox"]:checked').parent().addClass('active');
        }
    })
    console.log('${fns: toJson(page.list)}')
</script>

</body>

</html>