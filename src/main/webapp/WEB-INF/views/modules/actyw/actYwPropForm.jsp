<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script src="/other/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>


</head>
<body>
<div class="container-fluid">
    <div class="edit-bar clearfix">
        <div class="edit-bar-left">
            <span><c:if test="${not empty flowProjectTypes[0]}">${flowProjectTypes[0].name }</c:if><c:if
                    test="${empty flowProjectTypes[0]}">项目流程</c:if></span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <form:form id="inputForm" modelAttribute="actYw"
               action="${ctx}/actyw/actYw/ajaxProp?group.flowType=${actYw.group.flowType}&isUpdateYw=false"
               method="post"
               class="form-horizontal">
        <form:hidden path="id"/>
        <form:hidden path="isPreRelease"/>
        <form:hidden path="keyType"/>
        <sys:message content="${message}"/>
        <form:hidden path="proProject.id"/>
        <form:hidden path="proProject.menu.id"/>
        <form:hidden path="proProject.category.id"/>
        <form:hidden id="proProjectProjectName" path="proProject.projectName"></form:hidden>
        <input name="fpkey" value="${fpType.key }" type="hidden"/>
        <input type="hidden" name="proProject.imgUrl" value="/images/upload.png"/>
        <div class="control-group">
            <label class="control-label"> 功能类型：</label>
            <div class="controls">
                <p class="control-static">${fpType.name }</p>
            </div>
        </div>
        <%--<div class="control-group">
            <label class="control-label"><font color="red">*&nbsp;</font> 名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称：</label>
            <div class="controls">
                <form:input id="proProjectProjectName" path="proProject.projectName" htmlEscape="false" maxlength="64" class="input-xlarge "/>
                <span id="yazheng"></span>
            </div>
        </div>--%>
        <c:if test="${!showFlow}">
            <input name="actYw.groupId" value="${flowYwId.id }" type="hidden"/>
        </c:if>
        <c:if test="${showFlow}">
            <div class="control-group">
                <label class="control-label">关联流程：</label>
                <div class="controls">
                    <form:select path="groupId" class="input-xlarge required">
                        <form:option value="" label="--请选择--"/>
                        <c:forEach var="actYwGroup" items="${actYwGroups }">
                            <c:if test="${curActYw.id eq actYw.id}">
                                <c:if test="${curActYw.groupId eq actYwGroup.id}">
                                    <option value="${actYwGroup.id}" data-type="${actYwGroup.flowType}"
                                            selected="selected">${actYwGroup.name}</option>
                                </c:if>
                            </c:if>
                            <c:if test="${curActYw.id ne actYw.id}">
                                <c:if test="${actYw.groupId eq actYwGroup.id}">
                                    <option value="${actYwGroup.id}" data-type="${actYwGroup.flowType}"
                                            selected="selected">${actYwGroup.name}</option>
                                </c:if><c:if test="${actYw.groupId ne actYwGroup.id}">
                                <option value="${actYwGroup.id}"
                                        data-type="${actYwGroup.flowType}">${actYwGroup.name}</option>
                            </c:if>
                            </c:if>
                        </c:forEach>
                    </form:select>
                    <span class="help-inline">更换流程需要重新发布项目才能生效</span>
                </div>
            </div>
        </c:if>
        <c:if test="${not empty fpType.type.key }">
            <form:hidden id="proProjectType" path="proProject.type"/>
            <div class="control-group">
                <label class="control-label"> ${fpType.type.name}：</label>
                <div class="controls">
                    <p class="control-static"><c:forEach var="item" items="${fns:getDictList(fpType.type.key)}">
                        <c:if test="${actYw.proProject.type eq item.value}">
                            ${item.label}
                        </c:if>
                    </c:forEach></p>
                        <%-- <form:radiobuttons id="proProjectType" path="proProject.type"
                                             items="${fns:getDictList(fpType.type.key)}" itemLabel="label"
                                             itemValue="value" htmlEscape="false" class="required" onchange="updateProjectName(this)"/> --%>
                </div>
            </div>
        </c:if>
        <c:if test="${not empty fpType.category.key }">
            <div class="control-group ">
                <label class="control-label"><i>*</i> ${fpType.category.name}：</label>
                <div class="controls controls-checkbox">
                    <form:checkboxes path="proProject.proCategorys" items="${fns:getDictList(fpType.category.key)}"
                                     itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
                </div>
            </div>
        </c:if>
        <%-- <c:if test="${not empty fpType.level.key }">
            <div class="control-group ">
                <label class="control-label"><font color="red">*&nbsp;</font> ${fpType.level.name}：</label>
                <div class="controls">
                    <form:checkboxes path="proProject.levels" items="${fns:getDictList(fpType.level.key)}"
                                     itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
                    <span class="help-inline">项目属于哪一级别</span>
                </div>
            </div>
        </c:if>
        <c:if test="${not empty fpType.status.key }">
            <div class="control-group ">
                <label class="control-label"><font color="red">*&nbsp;</font> ${fpType.status.name}：</label>
                <div class="controls">
                    <form:checkboxes path="proProject.finalStatuss"
                                     items="${fns:getDictList(fpType.status.key)}" itemLabel="label"
                                     itemValue="value" htmlEscape="false" class="required"/>
                    <span class="help-inline">项目有哪几项审核结果状态</span>
                </div>
            </div>
        </c:if> --%>
        <script type="text/javascript">
            function updateProjectName(dom) {
                if ($(dom).is(':checked')) {
                    $("#proProjectProjectName").val($(dom).parent().find("label").html());
                }
            }
        </script>
        <div class="control-group">
            <label class="control-label">开始时间：</label>
            <div class="controls">
                <p class="control-static"><fmt:formatDate value="${actYw.proProject.startDate}"
                                                          pattern="yyyy-MM-dd"/></p>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">结束时间：</label>
            <div class="controls">
                <p class="control-static"><fmt:formatDate value="${actYw.proProject.endDate}" pattern="yyyy-MM-dd"/></p>
            </div>
        </div>
        <%--<div class="control-group">--%>
            <%--<label class="control-label"><i>*</i>项目年份：</label>--%>
            <%--<div class="controls">--%>
                <%--<form:input path="proProject.year" class="Wdate required" readonly="true"--%>
                            <%--onclick="WdatePicker({isShowToday: false, dateFmt:'yyyy',isShowClear:true});"/>--%>
            <%--</div>--%>
        <%--</div>--%>
        <div class="control-group" style="display: none;">
            <label class="control-label">重置栏目：</label>
            <div class="controls controls-radio">
                <form:radiobuttons path="proProject.restCategory"
                                   items="${fns:getDictList('yes_no')}" itemLabel="label"
                                   itemValue="value" htmlEscape="false" class="required"/>
                <span class="help-inline gray-color">该前台栏目子栏目是否恢复到初始状态</span>
            </div>
        </div>
        <div class="control-group" style="display: none;">
            <label class="control-label">重置菜单：</label>
            <div class="controls controls-radio">
                <form:radiobuttons path="proProject.restMenu"
                                   items="${fns:getDictList('yes_no')}" itemLabel="label"
                                   itemValue="value" htmlEscape="false" class="required"/>
                <span class="help-inline gray-color">该后台菜单子菜单是否恢复到初始状态</span>
            </div>
        </div>
        <div class="form-actions">
                <%--<c:forEach items="${actYwGtimeList}" var="actYwGtime">--%>
                <%--<input type="hidden" disabled  value="${actYwGtime.beginDate}">--%>
                <%--</c:forEach>--%>
            <shiro:hasPermission name="actyw:actYw:edit">
                <button type="submit" class="btn btn-primary">保存</button>
            </shiro:hasPermission>

            <button type="button" class="btn btn-default" onclick="history.go(-1)">返回</button>
        </div>

    </form:form>
</div>


<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>

<script type="text/javascript">

    $(document).ready(function () {
        //$("#name").focus();
        var $inputForm = $("#inputForm");


        var inputFormValidate = $inputForm.validate({
            submitHandler: function (form) {
                var data;
                loading('正在提交，请稍等...');
                data = $inputForm.serialize();
                $.ajax({
                    type: 'POST',
                    url: '${ctx}/actyw/actYw/ajaxProp?group.flowType=${actYw.group.flowType}&isUpdateYw=false',
                    data: data,
                    dataType: 'JSON',
                    success: function (data) {
                        if (data.status) {
                            showTip(data.msg, 'success', 300)
                        } else {
                            showTip(data.msg, 'fail', 300)
                        }
                        closeLoading();
                    },
                    error: function () {
                        showTip('保存失败', 'fail', 300);
                        closeLoading();
                    }
                })
                return false;
            },
            errorPlacement: function (error, element) {
                $("#messageBox").text("输入有误，请先更正。");
                if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                    error.appendTo(element.parent().parent());
                } else if (element.parent().hasClass('controls-rate')) {
                    error.appendTo(element.parent())
                } else {
                    error.insertAfter(element);
                }
            }
        });


    });

</script>
</body>
</html>