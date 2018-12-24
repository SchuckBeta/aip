<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="decorator" content="cyjd-site-default"/>
    <title>${frontTitle}</title>
    <style>
        .btns-found-member + .table-title {
            margin-top: -15px;
        }
    </style>
</head>

<body>
<div style="display: none" id="message">${message}</div>
<div class="container container-ct window-reload">
    <div class="edit-bar edit-bar-sm clearfix">
        <div class="edit-bar-left">
            <span>团队组建情况</span>
            <i class="line"></i>
        </div>
    </div>
    <div class="text-right btns-found-member">
        <a class="btn btn-sm btn-primary" id="findMember">寻找组员</a>
    </div>
    <div class="table-title">
        <span>学生团队</span>
        <i><c:if test="${teamInfo.size()==0 }">暂无团队信息</c:if></i>
    </div>
    <table class="table table-bordered table-orange text-center table-vertical-middle table-condensed">
        <thead>
        <tr>
            <th>序号</th>
            <th>姓名</th>
            <th>学号</th>
            <th>学院</th>
            <th>专业</th>
            <th>现状</th>
            <th>技术领域</th>
            <th>联系电话</th>
            <th>当前在研</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${teamInfo }" var="info" varStatus="status">
            <tr>
                <td>${status.index+1 }</td>
                <td>${info.uName}</td>
                <td>${info.no }</td>
                <td>${info.officeId }</td>
                <td>${fns:getOffice(info.professional).name}</td>
                <td>${fns:getDictLabel(info.currState, 'current_sate', '')}</td>
                <td>${info.domainlt }</td>
                <td>${info.mobile }</td>
                <td>${info.curJoin }</td>
                <td>
                    <c:if test="${info.state==0 }">已加入</c:if>
                    <c:if test="${info.state==1 }">申请加入</c:if>
                    <c:if test="${info.state==2 }">已发出邀请</c:if>
                </td>
                <td>
                    <c:if test="${info.state==1 }">
                        <a href="${ctxFront}/team/acceptInviation?teamId=${info.teamId}&userId=${info.userId}"
                           class="btn btn-primary btn-sm">同意</a>
                        <a href="${ctxFront}/team/refuseInviation?turId=${info.turId}&teamId=${info.teamId}"
                           class="btn btn-default btn-sm">不同意</a>
                    </c:if>
                    <c:if test="${info.sponsor!=info.userId}">
                        <a href="${ctxFront}/team/deleteTeamUserInfo?turId=${info.turId}&teamId=${info.teamId}&userId=${info.userId}"
                           class="btn btn-default btn-sm">删除</a>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div class="text-right btns-found-member">
        <a class="btn btn-sm btn-primary" id="findTeacher">寻找导师</a>
    </div>
    <div class="table-title">
        <span>导师团队</span>
        <i><c:if test="${teamInfo.size()==0 }">暂无导师信息</c:if></i>
    </div>
    <table class="table table-bordered table-orange text-center table-vertical-middle table-condensed">
        <thead>
        <tr>
            <th>序号</th>
            <th>姓名</th>
            <th>工号</th>
            <th>单位(学院或企业、机构)</th>
            <th>导师来源</th>
            <th>技术领域</th>
            <th>当前指导</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${teamTeacherInfo }" var="tInfo" varStatus="sta">
            <tr>
                <td>${sta.index+1 }</td>
                <td>${tInfo.uName}</td>
                <td>${tInfo.no}</td>
                <td>${tInfo.officeId }</td>
                <td>${fns:getDictLabel(tInfo.teacherType, 'master_type', '')}</td>
                <td>${tInfo.domainlt }</td>
                <td>${tInfo.curJoin }</td>
                <td>
                    <c:if test="${tInfo.state==0 }">已加入</c:if>
                    <c:if test="${tInfo.state==1 }">申请加入</c:if>
                    <c:if test="${tInfo.state==2 }">已发出邀请</c:if>
                </td>
                <td>
                    <c:if test="${tInfo.state==1}">
                        <a href="${ctxFront}/team/checkInfo?teamId=${tInfo.teamId}&userId=${tInfo.userId}"
                           class="btn btn-primary btn-sm">同意</a>
                        <a href="${ctxFront}/refuseInviation" class="btn btn-default btn-sm">不同意</a>
                    </c:if>
                    <c:if test="${tInfo.sponsor!=tInfo.userId}">
                        <a href="${ctxFront}/team/deleteTeamUserInfo?turId=${tInfo.turId}&teamId=${tInfo.teamId}&userId=${tInfo.userId}"
                           class="btn btn-default btn-sm">删除</a>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div class="iframe-wrap" style="margin-bottom: 20px; border-bottom: 1px solid #ddd">
        <iframe id="iframe" src="${ctxFront}/sys/user/index?teamId=${teamId}&&opType=2" frameborder="0"
                style="width: 100%;height: 545px;display:none;overflow: hidden"></iframe>
    </div>
    <div class="text-center">
        <a href="${ctxFront}/team/indexMyTeamList" class="btn btn-default">返回</a>
    </div>
</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>
<script>
    $(function () {

        $.ajax({
            type : "GET",
            url : "/f/team/foundTeamStu",
            dataType: "JSON",
            data : {
                "type" : "1",
                "teamId" : '${teamId}'
            },
            success: function (data) {

                if(data.ret == "1"){
//                    alert("111:"+data.data);
                }
            }
         });

        $('#findMember').click(function () {
            $('#iframe').attr({
                'src': '${ctxFront}/sys/user/index?teamId=${teamId}&&opType=2&&userType=1',
                'style': 'width: 100%;height: 545px;display:block;overflow: hidden'
            });
            $('.iframe-wrap').show();
            backToView();
        });




        $('#findTeacher').click(function () {
            $('#iframe').attr({
                'src': '${ctxFront}/sys/user/index?teamId=${teamId}&&opType=2&&userType=2',
                'style': 'width: 100%;height: 545px;display:block;overflow: hidden'
            });
            $('.iframe-wrap').show();
            backToView();
        })

        function backToView() {
            $(document).scrollTop($('#iframe').offset().top);
        }

        var messageInfo = $("#message").html();
//        console.log(messageInfo);

        if (messageInfo) {
            var msgState = messageInfo.indexOf('成功') > -1 ? '1' : '0';
            dialogCyjd.createDialog(msgState, messageInfo);
            $("#message").html("");
        }

        $('#content').css('minHeight', function () {
            return $(window).height() - 408
        })


    });
</script>
</body>
</html>