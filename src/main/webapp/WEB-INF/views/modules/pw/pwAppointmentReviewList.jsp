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
    <style>
        .modal-backdrop, .modal-backdrop.fade.in {
            opacity: 0;
            z-index: -1;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            window.parent.sideNavModule.changeStaticUnreadTag("/a/pw/pwAppointment/getCountToAudit");
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
<div id="reviewList" class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>预约审核</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" modelAttribute="pwAppointment" action="${ctx}/pw/pwAppointment/review"
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
                <label class="control-label">状态</label>
                <div class="controls controls-checkbox">
                    <form:select path="status" class="required input-medium" cssStyle="width: auto">
                        <form:option value="" label="---请选择---"/>
                        <form:option value="0">待审核</form:option>
                        <form:option value="1">审核通过</form:option>
                        <form:option value="4">已锁定</form:option>
                    </form:select>
                </div>
            </div>
                <%--<div style="width:100%;">--%>
            <div class="control-group">
                <label class="control-label">预约时间</label>
                <div class="controls">
                    <input name="dateFrom" v-model="searchForm.dateFrom" type="text"
                           class="Wdate input-small"
                           readonly
                           @click="openPicker('dateFrom', $event, 'yyyy-MM-dd')"
                    />
                    <input name="timeFrom" v-model="searchForm.timeFrom" type="text"
                           class="Wdate input-mini"
                           readonly
                           @click="openPicker('timeFrom', $event, 'HH:mm')"/>
                    至
                    <input name="dateTo" v-model="searchForm.dateTo" type="text"
                           class="Wdate input-small"
                           readonly
                           @click="openPicker('dateTo', $event, 'yyyy-MM-dd')"/>
                    <input name="timeTo" v-model="searchForm.timeTo" type="text"
                           class="Wdate input-mini"
                           readonly
                           @click="openPicker('timeTo', $event, 'HH:mm')"/>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <button id="searchBtn" type="submit" class="btn btn-primary">查询</button>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <div v-show="detailsShow"
         style="position: fixed;width: 100%;height: 100%;top: 0;left: 0;display: none;z-index: 1000">
        <div v-drag style="z-index: 1000" class="modal modal-calendar modal-large">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true"
                        @click="detailsShow=false">&times;
                </button>
                <h3>预约详情</h3>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="control-group">
                        <label class="control-label">申请人：</label>
                        <div class="controls">
                            <p class="control-static">{{details.userName}}</p>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">房间：</label>
                        <div class="controls">
                            <p class="control-static">{{details.roomName}}</p>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">可容纳人数：</label>
                        <div class="controls">
                            <p class="control-static">{{details.capacity}}</p>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">预约日期：</label>
                        <div class="controls">
                            <p class="control-static">{{details.day}}</p>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">预约时间段：</label>
                        <div class="controls">
                            <p class="control-static">
                                {{details.startTime}}
                                <span style="margin: 0 4px;">至</span>
                                {{details.endTime}}
                            </p>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">参与人数：</label>
                        <div class="controls">
                            <p class="control-static">{{details.num}}</p>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">用途：</label>
                        <div class="controls">
                            <p class="control-static">{{details.subject}}</p>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-save btn-primary"
                        @click="audit(1)">审核通过
                </button>
                <button type="button" class="btn btn-save btn-primary"
                        @click="audit(0)">审核不通过
                </button>
                <button class="btn btn-default" @click="detailsShow=false"
                        aria-hidden="true">取消
                </button>
            </div>
            <div class="modal-backdrop in"></div>
        </div>
    </div>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th width="180" data-name="u.name"><a class="btn-sort" href="javascript:void(0);">申请人<i
                    class="icon-sort"></i></a></th>
            <th width="170">预约日期</th>
            <th width="160">预约时间段</th>
            <th width="100" data-name="a.status"><a class="btn-sort" href="javascript:void(0);">状态<i
                    class="icon-sort"></i></a></th>
            <th width="150" data-name="r.name"><a class="btn-sort" href="javascript:void(0);">房间名称<i
                    class="icon-sort"></i></a></th>
            <th width="120" data-name="r.type"><a class="btn-sort" href="javascript:void(0);">房间类型<i
                    class="icon-sort"></i></a></th>
            <th width="120">操作</th>
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
                </td>
                <td>
                        ${pwAppointment.pwRoom.name}
                </td>
                <td>
                        ${fns:getDictLabel(pwAppointment.pwRoom.type,"pw_room_type" , "")}
                </td>
                <td>
                    <c:choose>
                        <c:when test="${pwAppointment.status == '0'}">
                            <button class="btn btn-small btn-primary" @click="getAppointment('${pwAppointment.id}')">
                                审核
                            </button>
                        </c:when>
                        <c:when test="${pwAppointment.status == '1'}">
                            <a class="btn btn-small btn-primary"
                               href="${ctx}/pw/pwAppointment/cancel?id=${pwAppointment.id}"
                               onclick="return confirmx('确认要取消该预约吗？', this.href)">取消预约</a>
                        </c:when>
                        <c:when test="${pwAppointment.status == '4'}">
                            <a class="btn btn-small btn-primary"
                               href="${ctx}/pw/pwAppointment/cancel?id=${pwAppointment.id}"
                               onclick="return confirmx('确认要取消锁定吗？', this.href)">取消锁定</a>
                        </c:when>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
<script>
    new Vue({
        el: '#reviewList',
        data: {
            details: {
                id: '',
                userName: '',
                roomName: '',
                capacity: '',
                day: '',
                startTime: '',
                endTime: '',
                num: '',
                subject: ''
            },
            searchForm: {
                dateFrom: '${pwAppointment.dateFrom}',
                dateTo: '${pwAppointment.dateTo}',
                timeFrom: '${pwAppointment.timeFrom}',
                timeTo: '${pwAppointment.timeTo}'
            },
            detailsShow: false
        },
        watch: {
            'searchForm.dateFrom': function (val) {
                if (val) {
                    if (this.searchForm.timeTo && !this.searchForm.dateTo) {
                        this.searchForm.dateTo = this.searchForm.dateFrom;
                    }
                } else {
                    if (this.searchForm.dateTo && this.searchForm.timeFrom) {
                        this.searchForm.dateFrom = this.searchForm.dateTo;
                    }
                }
            },
            'searchForm.dateTo': function (val) {
                if (val) {
                    if (this.searchForm.timeFrom && !this.searchForm.dateFrom) {
                        this.searchForm.dateFrom = this.searchForm.dateTo;
                    }
                } else {
                    if (this.searchForm.dateFrom && this.searchForm.timeTo) {
                        this.searchForm.dateTo = this.searchForm.dateFrom;
                    }
                }
            },
            'searchForm.timeFrom': function (val) {
                if (val) {
                    if (this.searchForm.dateTo && !this.searchForm.dateFrom) {
                        this.searchForm.dateFrom = this.searchForm.dateTo;
                    }
                } else {

                }
            },
            'searchForm.timeTo': function (val) {
                if (val) {
                    if (this.searchForm.dateFrom && !this.searchForm.dateTo) {
                        this.searchForm.dateTo = this.searchForm.dateFrom;
                    }
                } else {

                }
            },
            detailsShow: function (val) {
                if (!val) {
                    this.details.id = '',
                            this.details.userName = '',
                            this.details.roomName = '',
                            this.details.capacity = '',
                            this.details.day = '',
                            this.details.startTime = '',
                            this.details.endTime = '',
                            this.details.num = '',
                            this.details.subject = ''
                }
            },
        },
        methods: {
            getAppointment: function (id) {
                var self = this;
                var result = $.get('${ctx}/pw/pwAppointment/details', {"id": id});
                result.success(function (data) {
                    self.details.id = data.id;
                    self.details.userName = data.user.name;
                    self.details.roomName = data.pwRoom.name;
                    self.details.capacity = data.pwRoom.num;
                    self.details.day = data.startDate.substring(0, 10);
                    self.details.startTime = data.startDate.substring(10);
                    self.details.endTime = data.endDate.substring(10);
                    self.details.num = data.personNum;
                    self.details.subject = data.subject;
                    self.detailsShow = true;
                });
            },
            audit: function (val) {
                if (this.details.id != '') {
                    var result = $.get('${ctx}/pw/pwAppointment/manualAudit/' + this.details.id + '/' + val);
                    result.success(function (data) {
                        window.parent.sideNavModule.changeStaticUnreadTag("/a/pw/pwAppointment/getCountToAudit");
                        self.detailsShow = false;
                        location.reload();
                    })
                }
            },
            openPicker: function (key, $event, format) {
                var self = this;
                WdatePicker({
                    el: $event.target,
                    dateFmt: format,
                    isShowClear: true,
                    onpicked: function () {
                        self.searchForm[key] = $event.target.value;
                    },
                    oncleared: function () {
                        self.searchForm[key] = $event.target.value;
                    }
                });
            }

        }
    });
</script>
</body>
</html>