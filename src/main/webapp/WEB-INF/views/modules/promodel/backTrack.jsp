<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>

</head>
<body>
<div id="app" class="container-fluid mgb-60">
    <div class="mgb-20">
        <div class="edit-bar edit-bar-tag edit-bar_new clearfix auto-defined">
            <div class="edit-bar-left">
                <span>项目查询</span>
                <i>></i>
                <label>进度跟踪</label>
            </div>
        </div>
    </div>
    <div class="pro_info-header mgb-20">
        <div class="pro_info-pic">
            <img src="${empty proModel.logo.url ? '/images/default-pic.png':fns:ftpImgUrl(proModel.logo.url)}">
        </div>
        <div class="pro_info-sider">
            <h4 class="title"> ${proModel.pName}</h4>
            <div class="pro-persons">
                <p class="charge">负责人：<span>${proModel.deuser.name}</span></p>
                <p class="team-member">团队成员：
                    <c:forEach items="${teamStu}" var="student" varStatus="status">
                        <span>${student.name}</span>
                    </c:forEach>
                </p>
                <p class="teachers">指导教师：
                    <c:forEach items="${teamTea}" var="teacher" varStatus="status">
                        <span>${teacher.name}</span>
                    </c:forEach>
                </p>
            </div>
        </div>
    </div>
    <div class="panel">
        <div class="panel-header">
            项目简介
        </div>
        <div class="panel-body">
            <c:if test="${not empty proModel.introduction}">${proModel.introduction}</c:if>
            <c:if test="${empty proModel.introduction}">
                <div class="text-center"><span class="empty">暂无项目介绍</span></div>
            </c:if>
        </div>
    </div>
    <div class="panel">
        <div class="panel-header">进度跟踪</div>
        <div class="panel-body">
            <pro-progress v-model="timeLineData"></pro-progress>
        </div>
    </div>
</div>
<script>
    'use strict';
    new Vue({
        el: '#app',
        data: function () {
            var timeLineData = JSON.parse('${fns: toJson(timeLineData)}') || [];
            return {
                timeLineData: timeLineData,
            }
        },
        created: function () {

        }
    })

</script>
</body>
</html>