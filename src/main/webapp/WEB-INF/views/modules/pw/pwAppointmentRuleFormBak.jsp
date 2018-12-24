<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script src="${ctxStatic}/fullcalendar/moment.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //$("#name").focus();
            $("#inputForm").validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else if (element.attr('name') === 'afterDays' || element.attr('name') === 'autoTime') {
                        error.appendTo(element.parent());
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
    <div class="edit-bar clearfix">
        <%--<div class="edit-bar-left">--%>
            <%--<span>预约设置</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
        <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
        <form:form id="inputForm" modelAttribute="pwAppointmentRule" action="${ctx}/pw/pwAppointmentRule/save"
                   method="post"
                   class="form-horizontal form-horizontal-rule" cssStyle="padding-left: 90px;">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group" style="position: relative;padding-top: 8px;">
                <div class="controls-checkbox"
                     style="padding: 25px 40px 10px 15px; white-space: nowrap; border-radius: 5px; border: 1px solid #ddd;display: inline-block">
                    <div class="control-group" style="width: 634px;">
                        <div class="controls" style="margin-left: 20px;">
                            <label class="radio inline" style="vertical-align: top">
                                <input id="isAuto1" name="isAuto" class="required" value="0"
                                <c:if test="${pwAppointmentRule.isAuto=='0'}">
                                    checked="checked"
                                </c:if>
                                type="radio">手动审核</label>
                        </div>
                    </div>
                    <div class="control-group"  style="width: 634px;">
                        <div class="controls"  style="margin-left: 20px;">
                            <label class="radio inline" style="vertical-align: top">
                                <input id="isAuto2" name="isAuto" class="required" value="1"
                                <c:if test="${pwAppointmentRule.isAuto=='1'}">
                                    checked="checked"
                                </c:if>
                                type="radio">
                                自动审核
                            </label>
                            <form:input path="autoTime" htmlEscape="false" maxlength="2"
                                        class="required input-mini number digits"/>
                            <label class="radio inline" style="vertical-align: top;margin-left:-20px;">分钟未审核，系统自动审核通过</label>
                        </div>
                    </div>

                </div>
                <span style="position: absolute;left: 15px; top: 0; background-color: #fff; padding: 0 8px;"><i style="color:red;margin-right: 4px;font-style: normal">*</i>选择预约审核模式</span>
            </div>
            <div class="control-group" style="position: relative;padding-top: 8px;">
                <div style="padding: 25px 40px 10px 15px;border-radius: 5px; border: 1px solid #ddd;display: inline-block">
                    <div class="control-group">
                        <label class="control-label" style="width: 120px;">允许预约</label>
                        <div class="controls" style="margin-left: 140px;">
                            <form:input path="afterDays" htmlEscape="false" maxlength="2"
                                        class="input-mini number digits required"/>
                            <span class="help-inline">天以内的房间</span>
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label" style="width: 120px;">开放预约周次</label>
                        <div class="controls controls-checkbox" style="margin-left: 140px;">

                            <form:checkboxes path="isAppDayList" items="${weekList}" cssClass="required"
                                             itemLabel="label" itemValue="value"/>
                                <%--<form:input path="isAppDay" htmlEscape="false" maxlength="6" readonly="true" />--%>
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label" style="width: 120px;">开放预约时间段</label>
                        <div class="controls" style="margin-left: 140px;">
                            <label class="radio inline" style="vertical-align: top">
                                <input id="newAuto1" name="isTimeAuto"  value="1"
                                <c:if test="${pwAppointmentRule.isTimeAuto=='1'}">
                                    checked="checked"
                                </c:if>
                                       type="radio">不限
                            </label>
                            <label class="radio inline" style="vertical-align: top">
                                <input id="newAuto0" name="isTimeAuto" value="0"
                                <c:if test="${pwAppointmentRule.isTimeAuto=='0'}">
                                    checked="checked"
                                </c:if>
                                       type="radio">
                            </label>
                            <form:input path="beginTime" htmlEscape="false" maxlength="6" readonly="true"
                                        class="Wdate required input-medium"/>
                            至
                            <form:input path="endTime" htmlEscape="false" maxlength="6" readonly="true"
                                        class="Wdate required input-medium"/>

                        </div>
                    </div>

                </div>
                <span style="position: absolute;left: 15px; top: 0; background-color: #fff; padding: 0 8px;"><i style="color:red;margin-right: 4px;font-style: normal">*</i>预约设置</span>
            </div>
            <div class="form-actions" style="padding-left: 390px;margin-left: -90px;">
                <input class="btn btn-primary" type="submit" value="保 存"/>
                <%--<input class="btn btn-default" type="button" value="返 回" onclick="history.go(-1)"/>--%>
            </div>
        </form:form>
    </div>
</div>

<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>

<script>
    $(function () {
        var $beginTime = $('#beginTime');
        var $endTime = $('#endTime');

        function getDate() {
            var date = new Date();
            return {
                year: date.getFullYear(),
                month: date.getMonth() + 1,
                day: date.getDate()
            }
        }

        $beginTime.on('click', function (e) {
            var maxDate = $endTime.val();
            var da = getDate();
            var cdate = da.year + '-' + da.month + '-' + da.day + ' ' + maxDate;
            WdatePicker({
                dateFmt: 'HH:mm',
                isShowClear: false,
                maxDate: moment(new Date(cdate).getTime() - 30 * 60 * 1000).format('HH:mm')
            });
        });

        $endTime.on('click', function (e) {
            var startDate = $beginTime.val();
            var da = getDate();
            var cdate = da.year + '-' + da.month + '-' + da.day + ' ' + startDate;
            WdatePicker({
                dateFmt: 'HH:mm',
                isShowClear: false,
                minDate: moment(new Date(cdate).getTime() + 30 * 60 * 1000).format('HH:mm')
            });
        })
    })
</script>

</body>
</html>