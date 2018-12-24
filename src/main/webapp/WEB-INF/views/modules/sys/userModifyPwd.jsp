<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>${backgroudTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript">
        $(function () {
            $("#oldPassword").focus();
            $("#inputForm").validate({
                rules: {
                    oldPassword: {
                        rangelength: [6,20]
                    },
                    newPassword: {
                        rangelength: [6,20]
                    }
                },
                messages: {
                    confirmNewPassword: {
                        equalTo: "输入与上面相同的密码"
                    },
                    oldPassword: {
                        rangelength: '请输入6~20位数字、字母'
                    },
                    newPassword: {
                        rangelength: '请输入6~20位数字、字母'
                    }
                },
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorPlacement: function (error, element) {
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });
        });
    </script>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar edit-bar-tag clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>修改密码</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="inputForm" modelAttribute="user"
               action="${ctx}/sys/user/modifyPwd" method="post"
               class="form-horizontal">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>
        <div class="control-group">
            <label class="control-label"><i>*</i>旧密码:</label>
            <div class="controls">
                <input id="oldPassword" name="oldPassword" type="password" value="" class="required"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><i>*</i>新密码:</label>
            <div class="controls">
                <input id="newPassword" name="newPassword" type="password" value="" class="required"/>

            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><i>*</i>确认新密码:</label>
            <div class="controls">
                <input id="confirmNewPassword" name="confirmNewPassword"
                       type="password" value=""
                       class="required" equalTo="#newPassword"/>
            </div>
        </div>
        <div class="form-actions">
            <button type="submit" class="btn btn-primary">保存</button>
            <button type="button" class="btn btn-default" onclick="history.go(-1)">返回</button>
        </div>
    </form:form>
</div>

</body>
</html>