<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8"/>
    <meta name="decorator" content="cyjd-site-default"/>
    <title>${frontTitle}</title>
    <style type="text/css">

        .team-info-item {
            height: 20px;
            margin-bottom: 15px;
            overflow: hidden;
        }

        .team-info-item > span {
            display: inline-block;
            width: 90px;
            line-height: 20px;
            text-align: right;
        }

        .team-info-item .justify-i {
            display: inline-block /* Opera */;
            padding-left: 100%;
        }

        /*.team-info-item .teachers{*/
        /*margin-left: ;*/
        /*}*/
        .team-info-teachers {
            overflow: hidden;
        }

        .team-info-teachers .team-info-item {
            float: left;
        }

        .team-info-teachers .teacher > span {
            display: inline-block;
            margin-right: 10px;
            min-width: 100px;
        }

        .systemright .article-info > span {
            margin-right: 15px;
        }
        .pro-title{
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            font-size: 15px;
            font-weight: 700;
        }
    </style>

</head>
<body>
<input type="hidden" name="p55c4142a72584313a96a8e38d2d16368_foreignId" value="${es.id}"/>
<input type="hidden" name="p55c4142a72584313a96a8e38d2d16368_foreignType" value="1"/>
<input type="hidden" name="p55c4142a72584313a96a8e38d2d16368_likes" value="${es.likes}"/>
<input type="hidden" name="p55c4142a72584313a96a8e38d2d16368_comments" value="${es.comments}"/>
<div class="container container-ct">
    <ol class="breadcrumb" style="margin-top: 0">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li><a href="${ctxFront}/pageProject">优秀项目展示</a></li>
        <li class="active">项目详情</li>
    </ol>
    <h3 class="pro-title">${projectInfo.name }</h3>
    <p style="margin-bottom: 15px;">
        <c:if test="${es.type=='0000000075' }">
            <span>项目来源：${fns:getDictLabel(es.subType, 'project_style', '')}</span>
        </c:if>
        <c:if test="${es.type=='0000000076' }">
            <span>项目来源：${fns:getDictLabel(es.subType, 'competition_type', '')}</span>
        </c:if>
        <span style="margin-left: 8px;">发布时间：<fmt:formatDate value="${es.releaseDate}" pattern="yyyy-MM-dd"/></span>
    </p>
    <div class="system_info clearfix" style="margin-bottom: 30px;">
        <div class="system pull-left" style="width: 330px; height: 186px; overflow: hidden">
            <img class="img-responsive"
                 src="${not empty es.coverImg ? fns:ftpImgUrl(es.coverImg) :'/images/cover-pic.png'}"/>
        </div>
        <div class="systemright" style="margin-left: 360px;">
            <div class="team-info-item"><span>项目负责人：</span>${projectInfo.lname }</div>
            <div class="team-info-item"><span>学院：</span>${projectInfo.oname }</div>
            <div class="team-info-teachers">
                <div class="team-info-item"><span>指导老师：</span></div>
                <c:forEach items="${projectTeacherInfo}" var="item">
                    <div class="teacher">
                        <span>${item.uname }</span>
                        <span>${item.oname }</span>
                        <span>${item.post_title }</span>
                    </div>
                </c:forEach>
            </div>
            <p class="article-info">
                <span>浏览数：${es.views}</span><span>点赞数：${es.likes}</span></p>
            <div class="tags">
                <c:forEach items="${es.keywords}" var="item">
                    <button type="button" class="btn btn-primary btn-sm">${item}</button>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<div class="container">
    ${es.content}
</div>
<div class="container" style="padding-bottom: 60px;">
    <c:if test="${es.isComment=='1'}">
        <%@ include file="/WEB-INF/views/modules/interactive/comment.jsp" %>
    </c:if>
</div>
</body>

</html>