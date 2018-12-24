<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript" src="/js/backTable/sort.js"></script><!--排序js-->
    <script src="${ctxStatic}/vue/vue.min.js"></script>
    <title>${backgroundTitle}</title>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#ps").val($("#pageSize").val());
        });

        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();

        }
    </script>
</head>

<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>预约查询</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" modelAttribute="pwAppointment" action="${ctx}/pw/pwAppointment/list"
               method="post"
               cssClass="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <input type="hidden" id="orderBy" name="orderBy" value="${page.orderBy}"/>
        <input type="hidden" id="orderByType" name="orderByType" value="${page.orderByType}"/>
        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">申请人</label>
                <div class="controls">
                    <form:input class="input-small" path="user.name" htmlEscape="false" maxlength="100"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">房间类型</label>
                <div class="controls">
                    <form:select path="pwRoom.type" class="required input-medium" cssStyle="width: auto">
                        <form:option value="" label="---请选择---"/>
                        <form:options items="${fns:getDictList('pw_room_type')}" itemLabel="label" itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">容纳人数范围</label>
                <div class="controls">
                    <form:input path="capacityMin" type="number" value="${pwAppointment.capacityMin}" class="input-mini"
                                oninput="if(value.length>5)value=value.slice(0,5)"/>
                    <span>-</span>
                    <form:input path="capacityMax" type="number" value="${pwAppointment.capacityMax}" class="input-mini"
                                oninput="if(value.length>5)value=value.slice(0,5)"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">状态</label>
                <div class="controls">
                    <form:select path="status" class="required input-medium" cssStyle="width: auto">
                        <form:option value="" label="---请选择---"/>
                        <form:options items="${fns:getDictList('pw_appointment_status')}" itemLabel="label"
                                      itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">预约时间</label>
                <div class="controls">
                    <input name="dateFrom" v-model="dateFrom" type="text"
                           class="Wdate input-small"
                           readonly="false"
                           @click="openPicker('dateFrom', $event, 'yyyy-MM-dd')"
                    />
                    <input name="timeFrom" v-model="timeFrom" type="text"
                           class="Wdate input-mini"
                           readonly="true"
                           @click="openPicker('timeFrom', $event, 'HH:mm')"/>
                    至
                    <input  name="dateTo" v-model="dateTo" type="text"
                            class="Wdate input-small"
                            readonly="true"
                            @click="openPicker('dateTo', $event, 'yyyy-MM-dd')"/>
                    <input  name="timeTo" v-model="timeTo" type="text"
                           class="Wdate input-mini"
                           readonly="true"
                           @click="openPicker('timeTo', $event, 'HH:mm')"/>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <button id="searchBtn" type="submit" class="btn btn-primary">查询</button>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th width="100" data-name="u.name"><a class="btn-sort" href="javascript:void(0);">申请人<i
                    class="icon-sort"></i></a></th>
            <th width="160">预约日期</th>
            <th width="140">预约时间段</th>
            <th width="100" data-name="a.status"><a class="btn-sort" href="javascript:void(0);">状态<i
                    class="icon-sort"></i></a></th>
            <th width="120" data-name="r.name"><a class="btn-sort" href="javascript:void(0);">房间名称<i
                    class="icon-sort"></i></a></th>
            <th width="120" data-name="r.type"><a class="btn-sort" href="javascript:void(0);">房间类型<i
                    class="icon-sort"></i></a></th>
            <th width="120">用途</th>
            <th width="60">参与人数</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="pwAppointment">
            <tr>
                <td>${pwAppointment.user.name}</td>
                <td>
                    <fmt:formatDate value="${pwAppointment.startDate}" pattern="yyyy-MM-dd"/>
                </td>
                <td>
                    <fmt:formatDate value="${pwAppointment.startDate}" pattern="HH:mm"/>-<fmt:formatDate
                        value="${pwAppointment.endDate}" pattern="HH:mm"/>
                </td>
                <td>
                        ${fns:getDictLabel(pwAppointment.status,"pw_appointment_status" , "")}
                    <c:if test="${pwAppointment.status == '0' and pwAppointment.expired}">
                        （已过期）
                    </c:if>

                </td>
                <td>
                        ${pwAppointment.pwRoom.name}
                </td>
                <td>
                        ${fns:getDictLabel(pwAppointment.pwRoom.type,"pw_room_type" , "")}
                </td>
                <td>
                        ${pwAppointment.subject}
                </td>
                <td>
                        ${pwAppointment.personNum}
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>

<script>
    new Vue({
        el: '#searchForm',
        data: function () {
            return {
                dateFrom: '${pwAppointment.dateFrom}',
                dateTo: '${pwAppointment.dateTo}',
                timeFrom: '${pwAppointment.timeFrom}',
                timeTo: '${pwAppointment.timeTo}'
            }
        },
        watch: {
            dateFrom: function (val) {
                if (val) {
                    if (this.timeTo && !this.dateTo) {
                        this.dateTo = this.dateFrom;
                    }
                } else {
                    if (this.dateTo && this.timeFrom) {
                        this.dateFrom = this.dateTo;
                    }
                }
            },
            dateTo: function (val) {
                if (val) {
                    if (this.timeFrom && !this.dateFrom) {
                        this.dateFrom = this.dateTo;
                    }
                } else {
                    if (this.dateFrom && this.timeTo) {
                        this.dateTo = this.dateFrom;
                    }
                }
            },
            timeFrom: function (val) {
                if (val) {
                    if (this.dateTo && !this.dateFrom) {
                        this.dateFrom = this.dateTo;
                    }
                } else {

                }
            },
            timeTo: function (val) {
                if (val) {
                    if (this.dateFrom && !this.dateTo) {
                        this.dateTo = this.dateFrom;
                    }
                } else {

                }
            }
        },
        methods: {
            openPicker: function (key, $event, format) {
                var self = this;
                WdatePicker({
                    el: $event.target,
                    dateFmt: format,
                    isShowClear: true,
                    onpicked: function () {
                        self[key] = $event.target.value;
                    },
                    oncleared: function () {
                        self[key] = $event.target.value;
                    }
                });
            }
        }
    });

</script>
</body>
</html>