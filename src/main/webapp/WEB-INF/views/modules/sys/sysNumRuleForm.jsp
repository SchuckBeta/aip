<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#inputForm").validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                    $("#btnSubmit").attr("disabled", true);
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox")
                            || element.is(":radio")
                            || element.parent().is(
                                    ".input-append")) {
                        error.appendTo(element.parent()
                                .parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });


            jQuery.validator.addMethod("firstWord", function (value, element) {
                return this.optional(element) || ((/^[^0-9]/).test(value));
            }, "开头不能为数字");
        });
    </script>
</head>
<body>
<div class="container-fluid">
    <div class="edit-bar clearfix">
        <div class="edit-bar-left">
            <span>编号管理</span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <form:form id="inputForm" modelAttribute="sysNumRule"
               action="${ctx}/sys/sysNumRule/save?type1=${type1 }" method="post"
               class="form-horizontal" autocomplete="off">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>
        <div class="control-group">
            <label class="control-label"><i>*</i>所属编号类别：</label>
            <div class="controls">
                <form:select path="type" class="tt required">
                    <form:option value="" label="请选择"/>
                    <form:options items="${fns:getDictList('sys_role_menu_type')}"
                                  itemLabel="label" itemValue="value" htmlEscape="false"/>
                </form:select>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><i>*</i>编号名称：</label>
            <div class="controls">
                <form:input path="name" id="bhName" htmlEscape="false" maxlength="18"
                            class="required firstWord letterNumber"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">前缀：</label>
            <div class="controls">
                <form:input path="prefix" htmlEscape="false" maxlength="32"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">后缀：</label>
            <div class="controls">
                <form:input path="suffix" htmlEscape="false" maxlength="32"/>
            </div>
        </div>
        <c:choose>
            <c:when test="${sysNumRule.name!=null && sysNumRule.name!='' }">
                <div class="control-group">
                    <label class="control-label">日期：</label>
                    <div class="controls">
                        <label class="checkbox inline">
                            <c:choose>
                                <c:when test="${sysNumRule.year!=null && sysNumRule.year!='' }">
                                    <input type="checkbox" name="year" checked="checked">yyyy
                                </c:when>
                                <c:otherwise>
                                    <input type="checkbox" name="year">yyyy
                                </c:otherwise>
                            </c:choose>
                        </label>
                        <label class="checkbox inline">
                            <c:choose>
                                <c:when test="${sysNumRule.month!=null && sysNumRule.month!='' }">
                                    <input type="checkbox" name="month" checked="checked">MM
                                </c:when>
                                <c:otherwise>
                                    <input type="checkbox" name="month">MM
                                </c:otherwise>
                            </c:choose>
                        </label>
                        <label class="checkbox inline">
                            <c:choose>
                                <c:when test="${sysNumRule.day!=null && sysNumRule.day!='' }">
                                    <input type="checkbox" name="day" checked="checked">dd
                                </c:when>
                                <c:otherwise>
                                    <input type="checkbox" name="day">dd
                                </c:otherwise>
                            </c:choose>
                        </label>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">时间：</label>
                    <div class="controls">
                        <label class="checkbox inline">
                            <c:choose>
                                <c:when test="${sysNumRule.hour!=null && sysNumRule.hour!='' }">
                                    <input type="checkbox" name="hour" checked="checked">HH
                                </c:when>
                                <c:otherwise>
                                    <input type="checkbox" name="hour">HH
                                </c:otherwise>
                            </c:choose>
                        </label>
                        <label class="checkbox inline">
                            <c:choose>
                                <c:when test="${sysNumRule.minute!=null && sysNumRule.minute!='' }">
                                    <input type="checkbox" name="minute" checked="checked">mm
                                </c:when>
                                <c:otherwise>
                                    <input type="checkbox" name="minute">mm
                                </c:otherwise>
                            </c:choose>
                        </label>
                        <label class="checkbox inline">
                            <c:choose>
                                <c:when test="${sysNumRule.second!=null && sysNumRule.second!='' }">
                                    <input type="checkbox" name="second" checked="checked">ss
                                </c:when>
                                <c:otherwise>
                                    <input type="checkbox" name="second">ss
                                </c:otherwise>
                            </c:choose>
                        </label>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="control-group">
                    <label class="control-label">日期：</label>
                    <div class="controls">
                        <label class="checkbox inline">
                            <input type="checkbox" name="year">yyyy
                        </label>
                        <label class="checkbox inline">
                            <input type="checkbox" name="month">MM
                        </label>
                        <label class="checkbox inline">
                            <input type="checkbox" name="day">dd
                        </label>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">时间：</label>
                    <div class="controls">
                        <label class="checkbox inline">
                            <input type="checkbox" name="hour">HH
                        </label>
                        <label class="checkbox inline">
                            <input type="checkbox" name="minute">mm
                        </label>
                        <label class="checkbox inline">
                            <input type="checkbox" name="second">ss
                        </label>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="control-group">
            <label class="control-label"><i>*</i>开始编号：</label>
            <div class="controls">
                <form:input path="startNum" htmlEscape="false"
                            maxlength="${sysNumRule.numLength}" min="0" class="required digits"/>
            </div>

        </div>
        <div class="control-group">
            <label class="control-label"><i>*</i>编号位数：</label>
            <div class="controls">
                <form:input path="numLength" htmlEscape="false"
                            maxlength="${sysNumRule.numLength}" min="0" class="required digits"/>
            </div>
        </div>
        <div class="form-actions">
            <shiro:hasPermission name="sys:sysNumRule:edit">
                <button id="btnSubmit" class="btn btn-primary" type="submit">保存</button>
            </shiro:hasPermission>
            <button class="btn btn-default" type="button" value="" onclick="history.go(-1)">返回</button>
        </div>
    </form:form>
</div>

</body>
</html>