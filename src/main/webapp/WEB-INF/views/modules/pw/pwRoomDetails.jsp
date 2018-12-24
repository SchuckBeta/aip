<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
</head>
<body>
<ul class="nav nav-tabs">
    <li><a href="${ctx}/pw/pwRoom/list?pwSpace.id=${pwRoom.pwSpace.id}">房间列表</a></li>
    <li class="active"><a href="${ctx}/pw/pwRoom/form?id=${pwRoom.id}">房间查看</a></li>
</ul>
<form:form id="inputForm" class="form-horizontal" modelAttribute="pwRoom" action="${ctx}/pw/pwRoom/save"
           method="post">
    <form:hidden path="id"/>
    <div class="control-group">
        <label class="control-label">房间名：</label>
        <div class="controls">
            <p class="control-static">${pwRoom.name}</p>
        </div>
    </div>
    <c:if test="${not empty pwRoom.alias}">
    <div class="control-group">
        <label class="control-label">别名：</label>
        <div class="controls">
            <p class="control-static">${pwRoom.alias}</p>
        </div>
    </div>
    </c:if>
    <div class="control-group">
        <label class="control-label">房间类型：</label>
        <div class="controls controls-radio">
            <form:radiobuttons path="type" cssClass="required" items="${fns:getDictList('pw_room_type')}"
                               itemLabel="label" itemValue="value" htmlEscape="false" disabled="true"></form:radiobuttons>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">允许多团队入驻：</label>
        <div class="controls controls-radio">
            <form:radiobuttons path="isAllowm" cssClass="required" items="${fns:getDictList('yes_no')}"
                               itemLabel="label" itemValue="value" htmlEscape="false" disabled="true"></form:radiobuttons>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">容纳人数：</label>
        <div class="controls">
            <p class="control-static">${pwRoom.num}人</p>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">楼/层：</label>
        <div class="controls">
            <p class="control-static">${pwRoom.pwSpace.parent.name}/${pwRoom.pwSpace.name}</p>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">负责人：</label>
        <div class="controls">
            <p class="control-static">${pwRoom.person}</p>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">手机：</label>
        <div class="controls">
            <p class="control-static">${pwRoom.mobile}</p>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">电话：</label>
        <div class="controls">
            <p class="control-static">${pwRoom.phone}</p>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">预约房间色值：</label>
        <div class="controls">
            <span class="help-inline"><i class="color-i" style="background-color:
            <c:if test="${ not empty pwRoom.color}">#${pwRoom.color}</c:if>
            <c:if test="${ empty pwRoom.color}">#e9432d</c:if>
                    " onclick="$('#color').trigger('click')"></i></span>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">备注：</label>
        <div class="controls">
            <p class="control-static color-block">${pwRoom.remarks}</p>
        </div>
    </div>
    <div class="form-actions">
        <button class="btn btn-default" type="button" onclick="history.go(-1)">返回</button>
    </div>
</form:form>
</body>
</html>