<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/views/include/backtable.jsp" %>
    <link type="text/css" rel="stylesheet" href="/css/resetBS2FormHeight.css">
    <link rel="stylesheet" type="text/css" href="/other/jquery-ui-1.12.1/jquery-ui.css"/>
	<script src="/other/jquery-ui-1.12.1/jquery-ui.js" type="text/javascript" charset="utf-8"></script>
	<script src="/js/common.js" type="text/javascript"></script>
	<script src="/common/common-js/ajaxfileupload.js"></script>
    
</head>
<body>
<div class="mybreadcrumbs">
    <span><c:if test="${not empty flowProjectTypes[0]}">${flowProjectTypes[0].name }</c:if><c:if test="${empty flowProjectTypes[0]}">项目流程</c:if></span>
</div>
<div class="content_panel">
    <ul class="nav nav-tabs">
        <li><a href="${ctx}/actyw/actYw/list?group.flowType=${actYw.group.flowType}"><c:if test="${not empty flowProjectTypes[0]}">${flowProjectTypes[0].name }</c:if><c:if test="${empty flowProjectTypes[0]}">项目流程</c:if> 列表</a></li>
        <li class="active"><a href="${ctx}/actyw/actYw/form?id=${actYw.id}&group.flowType=${actYw.group.flowType}"><c:if test="${not empty flowProjectTypes[0]}">${flowProjectTypes[0].name }</c:if><c:if test="${empty flowProjectTypes[0]}">项目流程</c:if> <shiro:hasPermission
                name="actyw:actYw:edit">${not empty actYw.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission
                name="actyw:actYw:edit">查看</shiro:lacksPermission></a></li>
    </ul>
    <br/>
    <form:form id="createProjectForm" modelAttribute="actYw" action="${ctx}/actyw/actYw/save?group.flowType=${actYw.group.flowType}" method="post" class="form-horizontal">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>
        <div class="control-group">
            <label class="control-label">
                <span class="help-inline"><font color="red">*&nbsp;</font> </span>项目名称：</label>
            <div class="controls">
                <form:input path="proProject.projectName" htmlEscape="false" maxlength="64" class="form-control required"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">
                <span class="help-inline"><font color="red">*&nbsp;</font> </span>自定义流程：
            </label>
            <div class="controls controls-datetime">
                <form:input path="proProject.projectName" htmlEscape="false" maxlength="64" class="form-control required"/><span>至</span> <form:input path="proProject.projectName" htmlEscape="false" maxlength="64" class="form-control required"/>
                <div class="error-box"></div>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">关联流程：</label>
            <div class="controls">
                <form:select path="groupId" class="form-control required">
                    <form:option value="" label="--请选择--"/>
                    <c:forEach var="actYwGroup" items="${actYwGroups }">
                        <c:if test="${actYw.groupId eq actYwGroup.id}">
                            <option value="${actYwGroup.id}" selected="selected">${actYwGroup.name}</option>
                        </c:if>
                        <c:if test="${actYw.groupId ne actYwGroup.id}">
                            <option value="${actYwGroup.id}" >${actYwGroup.name}</option>
                        </c:if>
                    </c:forEach>
                </form:select>
                <div class="help-inline">（<span class="red">以下审核节点与选择的流程联动</span>）</div>
            </div>
        </div>
        <div class="control-group">
            <table class="table table-bordered">
                <thead>
                <tr>
                    <td>流程节点</td>
                    <td>有效期</td>
                    <td>通过率（用于限制专家）</td>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>项目申报</td>
                    <td class="controls-datetime">
                        <form:input path="" cssClass="input-small required Wdate"></form:input><span>至</span><form:input path="" cssClass="input-small required Wdate"></form:input>
                        <div class="error-box"></div>
                    </td>
                    <td>
                        项目申报数量<form:input path="" cssClass="input-mini"></form:input><div class="help-inline">（<span class="red">默认为空，不限制</span>）</div>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="form-actions">
            <shiro:hasPermission name="actyw:actYw:edit">
                <input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
                <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </form:form>
</div>

<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>

<script type="text/javascript">
    $(function () {
        var $createProjectForm = $('#createProjectForm');
        var createProjectForm = $createProjectForm.validate({

            errorPlacement: function (error, element) {
                var $parent = element.parent();
                //验证时间错误提交到errorbox里面
                if($parent.hasClass('controls-datetime')){
                    $parent.find('.error-box').html(error);
                }else{
                    error.insertAfter(element);
                }
            }
        });

//        $(document).on('change','.Wdate',function (e) {
//            var $this = $(this);
//            var $endTime;
//            var $startTime;
//            var endTime;
//            var startTime;
//            if($this.hasClass('approval')){
//                if($this.hasClass('start')){
//                    $endTime = $this.nextAll('end');
//                    endTime = $endTime.val();
//                    if(endTime){
//                        endTime = new Date(endTime).getTime();
//                    }
//                }
//            }
//        })


    })
</script>

</body>
</html>