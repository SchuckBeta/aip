<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript">
        $(document).ready(function () {
            //$("#name").focus();
            var $inputForm = $("#inputForm");
            var $btnSubmit = $inputForm.find('button[type="submit"]');
            var validateForm = $inputForm.validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    $btnSubmit.prop('disabled', true);
                    $.ajax({
                        type: 'post',
                        url: "/a/dr/drEquipment/ajaxCheck",
                        data: {
                            id: $("#id").val(),
                            no: $("#no").val(),
                            ip: $("#ip").val(),
                            port: $("#port").val()
                        },
                        success: function (data) {
                            if (data.ret == "1") {
                                form.submit();
                            } else {
                                alertx(data.msg);
                                $btnSubmit.prop('disabled', false);
                            }
                        }
                    });
                    return false;
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
        });
        function submitSave() {


        }
    </script>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>门禁设备</span> <i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="inputForm" modelAttribute="drEquipment" action="${ctx}/dr/drEquipment/save" method="post"
               class="form-horizontal" autocomplete="off">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>
        <input type="hidden" name="secondName" id="secondName" value="${secondName}"/>
        <div class="control-group">
            <label class="control-label"><i>*</i>设备号：</label>
            <div class="controls">
                <form:input path="no" htmlEscape="false" maxlength="64" class="required"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">设备密码：</label>
            <div class="controls">
                <form:input path="psw" htmlEscape="false" maxlength="64" class=""/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><i>*</i>设备名称：</label>
            <div class="controls">
                <form:input path="name" htmlEscape="false" maxlength="64" class="required"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">是否可用:</label>
            <div class="controls">
                    <form:select id="delFlag" path="delFlag" class="input-medium required">
                            <form:option value="" label="--请选择--"/>
                            <form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                    <span class="help-inline"><font color="red">*</font> </span>
            </div>
           </div>
        <div class="control-group">
            <label class="control-label"><i>*</i>设备类型：</label>
            <div class="controls">
                <form:select path="type" class="input-medium">
                    <form:option value="" label="--请选择--"/>
                    <form:options items="${eTypeList}" itemLabel="value" itemValue="key"
                                htmlEscape="false"/>
                </form:select>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><i>*</i>IP地址：</label>
            <div class="controls">
                <form:input path="ip" htmlEscape="false" maxlength="64" class="required ip"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><i>*</i>端口号：</label>
            <div class="controls">
                <form:input path="port" htmlEscape="false" maxlength="5" class="required digits"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">设备出口编号：</label>
            <div class="controls controls-checkbox">
                <form:checkboxes path="drNoList" items="${drKeyList}" itemLabel="name" itemValue="key"
                                 htmlEscape="false" class="required"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">设备索引号：</label>
            <div class="controls controls-checkbox">
                <form:input path="tindex" htmlEscape="false" maxlength="5" class="digits"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">设备每次取号：</label>
            <div class="controls controls-checkbox">
                <form:input path="tsize" htmlEscape="false" maxlength="5" class="digits"/>
            </div>
        </div>
        <div class="form-actions">
            <shiro:hasPermission name="dr:drEquipment:edit">
                <button class="btn btn-primary" type="submit">保存</button>
            </shiro:hasPermission>
            <button class="btn btn-default" type="button" onclick="history.go(-1)">返回</button>
        </div>
    </form:form>
</div>

</body>
</html>