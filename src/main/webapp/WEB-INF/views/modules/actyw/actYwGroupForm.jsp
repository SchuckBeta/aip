<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
</head>
<body>

<style>
    .btn:focus{
        outline:none;
    }
</style>

<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>自定义流程</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <%--<ul class="nav nav-tabs">--%>
    <%--<li><a href="${ctx}/actyw/actYwGroup/">自定义流程列表</a></li>--%>
    <%--<li class="active"><a--%>
    <%--href="${ctx}/actyw/actYwGroup/form?id=${actYwGroup.id}">自定义流程${not empty actYwGroup.id?'修改':'添加'}</a>--%>
    <%--</li>--%>
    <%--</ul>--%>
    <form:form id="inputForm" modelAttribute="actYwGroup" action="${ctx}/actyw/actYwGroup/save" method="post"
               class="form-horizontal" autocomplete="off">
        <form:hidden path="id"/>
        <form:hidden path="temp"/>
        <sys:message content="${message}"/>
        <input type="hidden" id="secondName" name="secondName"value="${secondName}"/>
        <div class="control-group">
            <label class="control-label"><i>*</i>流程名称：</label>
            <div class="controls">
                <form:input path="name" htmlEscape="false" maxlength="50" class="required"/>
            </div>
        </div>
        <%-- <div class="control-group">
            <label class="control-label">流程惟一标识：</label>
            <div class="controls">
                <form:input path="keyss" htmlEscape="false" maxlength="50" class="input-xlarge required"/>
            </div>
        </div> --%>
        <%-- <div class="control-group">
            <label class="control-label">生效状态:</label>
            <div class="controls">
                <form:select path="status" class="input-xlarge required">
                    <form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                </form:select>
            </div>
        </div> --%>
        <c:if test="${actYwGroup.status eq '1'}">
            <form:hidden path="theme"/>
            <form:hidden path="flowType"/>
        </c:if>
        <c:if test="${actYwGroup.status ne '1'}">
            <div class="control-group">
                <label class="control-label"><i>*</i>表单组：</label>
                <div class="controls">
                    <form:select id="theme" path="theme" class="required">
                        <form:option value="" label="--请选择--"/>
                        <c:forEach var="curFormTheme" items="${formThemes}">
                            <c:if test="${curFormTheme.idx ne '0'}">
                                <c:if test="${actYwGroup.theme eq curFormTheme.idx}">
                                    <option value="${curFormTheme.idx}"
                                            selected="selected">${curFormTheme.name }</option>
                                </c:if>
                                <c:if test="${actYwGroup.theme ne curFormTheme.idx}">
                                    <option value="${curFormTheme.idx}">${curFormTheme.name }</option>
                                </c:if>
                            </c:if>
                        </c:forEach>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><i>*</i>流程类型：</label>
                <div class="controls">
                    <form:select id="flowType" path="flowType" class="required">
                        <form:option value="" label="--请选择--"/>
                        <c:forEach var="curFlowType" items="${flowTypes}">
                            <c:if test="${actYwGroup.flowType eq curFlowType.key}">
                                <option value="${curFlowType.key}" selected="selected">${curFlowType.name }</option>
                            </c:if>
                            <c:if test="${actYwGroup.flowType ne curFlowType.key}">
                                <option value="${curFlowType.key}">${curFlowType.name }</option>
                            </c:if>
                        </c:forEach>
                    </form:select>
                        <%-- <form:select path="flowType" class="required">
                            <form:option value="" label="--请选择--"/>
                            <form:options items="${fns:getDictList('act_category')}" itemLabel="label" itemValue="value"
                                          htmlEscape="false"/>
                        </form:select> --%>
                    <span class="help-inline gray-color">供创建双创项目或者双创大赛时使用</span>
                </div>
            </div>
        </c:if>
        <%-- <div class="control-group">
            <label class="control-label">项目类型：</label>
            <div class="controls">
                <form:select path="type" class="input-xlarge required">
                    <form:option value="" label="--请选择--"/>
                    <form:options items="${fns:getDictList('act_project_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                </form:select>
            </div>
        </div> --%>
        <%-- <div class="control-group">
            <label class="control-label">流程作者：</label>
            <div class="controls">
                <form:input path="author" htmlEscape="false" maxlength="50" class="input-xlarge required"/>
            </div>
        </div> --%>
        <%-- <div class="control-group">
            <label class="control-label">流程版本：</label>
            <div class="controls">
                <form:input path="version" htmlEscape="false" maxlength="50" class="input-xlarge required"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">排序：</label>
            <div class="controls">
                <form:input path="sort" htmlEscape="false" maxlength="50" class="input-xlarge required"/>
            </div>
        </div> --%>
        <div class="control-group">
            <label class="control-label">备注：</label>
            <div class="controls">
                <form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="200" class="input-xxlarge"/>
            </div>
        </div>
        <div class="form-actions">
            <%--<shiro:hasPermission name="actyw:actYwGroup:edit">--%>
                <%--<button type="submit" class="btn btn-primary">保存</button>--%>
            <%--</shiro:hasPermission>--%>
            <button type="button" class="btn btn-primary btn-next_step">保存</button>
            <button type="button" class="btn btn-default" onclick="history.go(-1)">返回</button>
        </div>
    </form:form>
</div>


<div id="dialogCyjd" class="dialog-cyjd"></div>


<script>


    $(function () {

        var actYwGroupId = '${actYwGroup.id}';
        var $theme = $('#theme');

        $theme.on('change', function () {
            if (!actYwGroupId) {
                return;
            }
            dialogCyjd.createDialog(0, '确认修改表单组属性吗？若修改，请更新设计页的关联表单，否则流程发布后无法正常审核！！');
        });

        var $inputForm = $('#inputForm');
        var $btnNextStep = $inputForm.find('.btn-next_step');
        var formValidate = $inputForm.validate({
            submitHandler: function (form) {
//                loading('正在提交，请稍等...');
                form.submit();
            },
            errorContainer: "#messageBox",
            errorPlacement: function (error, element) {
                $("#messageBox").text("输入有误，请先更正。");
                if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                    error.appendTo(element.parent().parent());
                } else {
                    error.insertAfter(element);
                }
            }
        });

        $btnNextStep.on('click', function (e) {
            e.stopPropagation();
            if (!formValidate.form()) {
                return false;
            }
            $btnNextStep.prop('disabled', true);
            $.ajax({
                type: 'GET',
                url: '${ctx}/actyw/actYwGroup/ajaxSave',
                data: $inputForm.serialize(),
                success: function (data) {
                    if (data.status) {
                        dialogCyjd.createDialog(1, '自定义流程创建成功', {
                            'buttons': [{
                                'text': '设计流程图',
                                'class': 'btn btn-primary btn-small',
                                'click': function (e) {
                                    e.stopPropagation();
                                    $(this).dialog('close');
                                    location.href = '${ctx}/actyw/actYwGnode/designNew?group.id=' + data.datas + '&groupId=' + data.datas;
                                }
                            }, {
                                'text': '返回列表',
                                'class': 'btn btn-default btn-small',
                                'click': function (e) {
                                    e.stopPropagation();
                                    $(this).dialog('close');
                                    location.href = ' ${ctx}/actyw/actYwGroup/list'
                                }
                            }]
                        });
                    } else {
                        dialogCyjd.createDialog(0, data.msg);
                    }
                    $btnNextStep.prop('disabled', false)
                },
                error: function (error) {
                    $btnNextStep.prop('disabled', false)
                }
            })
        })

    });

</script>

</body>
</html>