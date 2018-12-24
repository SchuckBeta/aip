<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script src="${ctxStatic}/vue/vue.min.js"></script>
    <script src="${ctxStatic}/fullcalendar/moment.min.js"></script>
    <script src="/other/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
<div id="actYwForm" class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left"><span>--%>
            <%--<c:if test="${not empty actYw.group.flowType}">${fpType.name}</c:if>--%>
            <%--<c:if test="${empty actYw.group.flowType}">项目流程</c:if></span> --%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <ul class="nav nav-tabs">
        <li><a href="${ctx}/actyw/actYw/list?group.flowType=${actYw.group.flowType}">${fpType.name}列表</a></li>
        <li class="active"><a href="javascript: void(0);">${fpType.name}
            <shiro:hasPermission
                    name="actyw:actYw:edit">${not empty actYw.id?'修改时间':'添加时间'}</shiro:hasPermission>
            <shiro:lacksPermission
                    name="actyw:actYw:edit">查看</shiro:lacksPermission></a></li>
    </ul>
    <input type="hidden" id="groupId" value="${actYw.groupId}">
    <form:form id="inputForm" modelAttribute="actYw" action="${ctx}/actyw/actYw/ajaxGtime" method="post"
               v-validate="{form: 'actYwTimeForm'}"
               class="form-horizontal">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>
        <input type="hidden" name="secondName" id="secondName" value="${secondName}"/>
        <div class="edit-bar edit-bar-sm clearfix" style="margin-left: 10px;">
            <div class="edit-bar-left"><span>项目属性</span> <i class="line"></i></div>
        </div>
        <div class="control-group">
            <label class="control-label"> 功能类型：</label>
            <div class="controls"><p class="control-static">${fpType.name}</p></div>
        </div>
        <div class="control-group">
            <label class="control-label">名称：</label>
            <div class="controls">
                <p class="control-static">${actYw.proProject.projectName }</p>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">关联流程：</label>
            <div class="controls"><p class="control-static">${actYwGroup.name}</p></div>
        </div>

        <div class="control-group">
            <label class="control-label"><i>*</i>开始时间：</label>
            <div class="controls">
                <input name="startYearDate" type="text" readonly
                       @click="showStartDatePicker($event)"
                       v-model="proProject.startDate"
                       class="Wdate required"
                       />
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><i>*</i>结束时间：</label>
            <div class="controls">
                <input name="endYearDate" type="text" class="Wdate required" readonly
                       @click="showEndDatePicker($event)"
                       v-model="proProject.endDate"
                      />
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><i>*</i>项目年份：</label>
            <div class="controls">
                <input name="proProject.year" type="text" class="Wdate required" readonly
                       v-model="proProject.year"
                       @click.stop.prevent="showProjectYear($event)"/>
            </div>
        </div>
        <div v-show="isShowTime" class="control-group">
            <label class="control-label">申报时间：</label>
            <div class="controls controls-radio">
                <form:radiobuttons path="proProject.nodeState"
                                   items="${fns:getDictList('yes_no')}" itemLabel="label"
                                   v-model="proProject.nodeState"
                                   itemValue="value" htmlEscape="false" class="required"/>
                <span class="help-inline gray-color">申报是否加申请时间控制</span>
            </div>
        </div>
        <div v-show="isShowTime" class="control-group">
            <label class="control-label">显示时间：</label>
            <div class="controls">
                <c:forEach items="${fns:getDictList('yes_no')}" var="showTimes">
                    <label class="radio inline">
                        <input type="radio" name="showTime" value="${showTimes.value}" class="required"
                               v-model="proProject.showTime">${showTimes.label}
                    </label>
                </c:forEach>

                    <%--<form:radiobuttons path="showTime" items="${fns:getDictList('yes_no')}" itemLabel="label"--%>
                    <%--itemValue="value" class="required" v-model="proProject.showTime" />--%>
            </div>
        </div>

        <div class="edit-bar edit-bar-sm clearfix" style="margin-left: 10px;">
            <div class="edit-bar-left"><span>审核时间</span> <i class="line"></i></div>
        </div>
        <table v-show="isLoad" id="tableDate"
               class="table table-bordered table-condensed table-hover table-orange table-center table-actYwForm"
               style="display: none">
            <thead>
            <tr>
                <td>流程节点</td>
                <td>有效期</td>
                <td>导入导出模板</td>
                <td style="display: none">通过率（用于限制专家）</td>
            </tr>
            </thead>
            <tbody>

            <tr v-show="proProject.nodeState == '1'">
                <td>申报</td>
                <td>
                    <div class="control-times">
                        <input name="nodeStartDate" type="text" class="Wdate input-medium"
                               :class="{required: proProject.nodeState == '1'}"
                               readonly
                               @click="showNodeStartDatePicker($event)"
                               v-model="proProject.nodeStartDate"
                        >
                        <span class="zhi">至</span>
                        <input name="nodeEndDate" type="text" class="Wdate input-medium"
                               readonly
                               :class="{required: proProject.nodeState == '1'}"
                               @click="showNodeEndDatePicker($event)"
                               v-model="proProject.nodeEndDate">
                        <div style="width: 120px; display: none; vertical-align: middle">
                        </div>
                        <div class="error-box">
                            <div class="error-first"></div>
                            <div class="error-last"></div>
                        </div>
                    </div>

                </td>
                <td>
                </td>
            </tr>
            <tr v-show="proProject.showTime == 1" v-for="(item, index) in actYwGTimes">
                <td>{{item.gnode && item.gnode.name}}<input type="hidden" name="nodeId" :value="item.gnodeId"></td>
                <td>
                    <div class="control-times">
                        <input :name="'beginDate'+index" type="text" class="Wdate input-medium"
                               :class="{required: actYwGTimes[index].status == '1'}" readonly
                               v-model="actYwGTimes[index].beginDate"
                               @click="showNodeGTimeStartDatePicker(item, index, $event)">
                        <span class="zhi">至</span>
                        <input :name="'endDate'+index" type="text" class="Wdate input-medium"
                               :class="{required: actYwGTimes[index].status == '1'}" readonly
                               v-model="actYwGTimes[index].endDate"
                               @click="showNodeGTimeEndDatePicker(item, index, $event)">
                        <div style="width: 120px; display: none; vertical-align: middle">
                            <label class="radio inline"><input type="radio" :name="'status'+index" true-value="1" false-value="0"
                                                               v-model="actYwGTimes[index].status">是 </label>
                            <label class="radio inline"> <input type="radio" :name="'status'+index" true-value="1" false-value="0"
                                                                v-model="actYwGTimes[index].status">否</label>
                        </div>
                        <div class="error-box">
                            <div class="error-first"></div>
                            <div class="error-last"></div>
                        </div>
                    </div>

                </td>
                <td>
                    <div class="control-rate">
                        <%--<input type="text" :name="'rate'+index" value="100" min="0" max="100" class="input-mini"--%>
                               <%--:class="{required: actYwGTimes[index].hasTpl == '1'}"/>--%>
                        <%--<div class="help-inline">（<span class="red">默认为空，不限制</span>）</div>--%>
                        <label class="radio inline">
                            <input type="radio" :name="'hasTpl'+index" v-model="actYwGTimes[index].hasTpl"  value="1">是
                        </label>
                        <label class="radio inline">
                            <input type="radio"  :name="'hasTpl'+index"  v-model="actYwGTimes[index].hasTpl" value="0">否
                        </label>
                        <%--<input type="hidden" :name="'hasTpl'+index" :value="actYwGTimes[index].hasTpl">--%>
                        <input type="hidden" :name="'excelTplClazz'+index" :value="actYwGTimes[index].excelTplClazz">
                        <select :disabled="actYwGTimes[index].hasTpl != '1'" v-model="actYwGTimes[index].excelTplPath" size="small" :name="'excelTplPath'+index">
                            <option v-for="expType in expTypes" :key="expType.tplpext + expType.tplname" :value="expType.tplpext + expType.tplname">{{expType.name}}</option>
						</select>
						<%--<select name="actYwGTimes[index].excelTplClazz">--%>
							<%--<option value="ProModelTlxy.class">通用导入导出模板</option>--%>
						<%--</select>--%>
                        <div class="error-box"></div>
                    </div>
                </td>
                <td style="display: none">
                    <div class="control-rate">
                        <input type="text" :name="'rate'+index" value="100" min="0" max="100" class="input-mini"
                               :class="{required: actYwGTimes[index].rateStatus == '1'}"/>
                        <div class="help-inline">（<span class="red">默认为空，不限制</span>）</div>
                        <label class="radio inline">
                            <input type="radio" :name="'rateStatus'+index" value="1"
                                   v-model="actYwGTimes[index].rateStatus">是 </label>
                        <label class="radio inline"> <input type="radio" :name="'rateStatus'+index" value="0"
                                                            v-model="actYwGTimes[index].rateStatus">否 </label>
                        <div class="error-box"></div>
                    </div>
                </td>
            </tr>

            </tbody>
        </table>

        <div class="form-actions">
            <shiro:hasPermission name="actyw:actYw:edit">
                <button type="submit" class="btn btn-primary">保存</button>
            </shiro:hasPermission>
            <button type="button" class="btn btn-default" onclick="history.go(-1)">返回</button>
        </div>

    </form:form>
</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>

<script type="text/javascript">
    +function ($, Vue) {

        var nodeStartDate = '<fmt:formatDate value="${actYwYear.nodeStartDate}" pattern="yyyy-MM-dd"/>';
        var nodeEndDate = '<fmt:formatDate value="${actYwYear.nodeEndDate}" pattern="yyyy-MM-dd"/>';

        var startDate = '<fmt:formatDate value="${actYwYear.startDate}" pattern="yyyy-MM-dd"/>';
        var endDate = '<fmt:formatDate value="${actYwYear.endDate}" pattern="yyyy-MM-dd"/>';


        var actYwForm = new Vue({
            el: '#actYwForm',
            data: function () {
                return {
                    groupId: '${actYw.groupId}',
                    proProject: {

                        startDate: '<fmt:formatDate value="${actYwYear.startDate}" pattern="yyyy-MM-dd"/>',
                        endDate: '<fmt:formatDate value="${actYwYear.endDate}" pattern="yyyy-MM-dd"/>',
                        showTime: '${actYw.showTime}',
                        year: '${actYwYear.year}',
                        //                        showTime: '1',
                        //                        nodeState: '1',
                        nodeState: '${actYw.proProject.nodeState}',
                        nodeStartDate: nodeStartDate,
                        nodeEndDate: nodeEndDate
                    },

                    actYwGtimeList: JSON.parse('${fns:toJson(actYwGtimeList)}'),
                    actYwGTimes: [],
                    actYwTimeForm: '',
                    curDate: new Date(),
                    gapDay: 1,
                    nodeGayDay: 0,
                    nodeState: '${actYw.proProject.nodeState}',
                    flowType: '${actYw.group.flowType}',
                    actYwForm: '',
                    beforeTime: '',
                    allTimes: [],
                    gDateKey: '',
                    isLoad: true,
                    currentIndex: '',
                    expTypes: []
                }
            },
            directives: {
                validate: {
                    inserted: function (element, binding, vnode) {
                        vnode.context[binding.value.form] = $(element).validate({
                            submitHandler: function (form) {
                                var dateArr = vnode.context.getDateArr();
                                var $form = $(form);
                                var $submit = $form.find('button[type="submit"]');
                                var isValidate;
                                var validateAllTimes;
                                isValidate = vnode.context.validateTimes(dateArr);
                                //                                validateAllTimes = vnode.context.validateAllTimes(dateArr)
                                if (!isValidate.valid) {
                                    dialogCyjd.createDialog(0, isValidate.item.gnode.name + '时间大于后面节点时间');
                                    return false;
                                }
                                //                                if (!validateAllTimes.valid) {
                                //                                    dialogCyjd.createDialog(0, '设置的时间段有问题， 请检查');
                                //                                    return false;
                                //                                }

                                $submit.prop('disabled', true);

                                $.ajax({
                                    url: '${ctx}/actyw/actYw/ajaxGtime',
                                    data: $(form).formSerialize(),
                                    dataType: 'json',
                                    success: function (data) {
                                        if (data.status) {
                                            location.href = '${ctx}/actyw/actYw/list?group.flowType=${actYw.group.flowType}'
                                        } else {
                                            dialogCyjd.createDialog(0, data.msg);
                                        }
                                        $submit.prop('disabled', false);
                                    },
                                    error: function () {
                                        dialogCyjd.createDialog(0, '保存失败, 请重试');
                                        $submit.prop('disabled', false);
                                    }
                                })
                                return false;

                            },
                            errorPlacement: function (error, element) {
                                if (element.is(":checkbox") || element.is(":radio")) {
                                    error.appendTo(element.parent().parent());
                                } else if (element.parent().hasClass('control-times')) {
                                    var name = element.attr('name');
                                    var $errorBox = element.parent().parent().find('.error-box');
                                    if (/nodeStartDate|beginDate/.test(name)) {
                                        error.appendTo($errorBox.find('.error-first'));
                                    } else {
                                        error.appendTo($errorBox.find('.error-last'));
                                    }
                                } else if (element.parent().hasClass('control-rate')) {
                                    var $errorRateBox = element.parent().parent().find('.error-box');
                                    error.appendTo($errorRateBox);
                                } else {
                                    error.insertAfter(element);
                                }
                            }
                        })
                    }
                }
            },
            computed: {
                isShowTime: function () {
                    return this.flowType !== '1' && this.flowType !== '13'
                },
                actYwYear: function () {
                    return {
                        nodeStartDate: this.proProject.nodeStartDate,
                        nodeEndDate: this.proProject.nodeEndDate
                    }
                }
            },
            methods: {

                //获取结束时间
                getEndDate: function (item, key) {
                    var endDate = this.proProject.endDate;
                    if (endDate) {
                        endDate = new Date(endDate);
                        endDate = endDate.setDate(endDate.getDate() - this.nodeGayDay);
                        endDate = moment(endDate).format('YYYY-MM-DD');
                    }
                    if (key === 'endDate') {

                    }
                    if (key === 'beginDate') {
                        endDate = item.endDate || endDate;
                    }
                    return endDate;
                },

                //获取最小时间
                getStartDate: function (item, key) {
                    var minDate = this.proProject.startDate;
                    if (minDate) {
                        minDate = new Date(minDate);
                        minDate = minDate.setDate(minDate.getDate() + this.nodeGayDay);
                        minDate = moment(minDate).format('YYYY-MM-DD');
                    }
                    if (key === 'endDate') {
                        minDate = item.beginDate || minDate;
                    }
                    if (key === 'beginDate') {
                        minDate = this.getBeforeDate(item);
                    }
                    return minDate;
                },

                //获取前一个节点的最小值
                getBeforeDate: function (item) {
                    var dateArr = this.getDateArr();
                    var beforeDates = this.getBeginDateBefore(dateArr, item.id);
                    return this.getBeforeSingleDate(beforeDates)
                },

                getBeforeSingleDate: function (beforeDates) {
                    var date;
                    for (var i = beforeDates.length - 1; i > -1; i--) {
                        var itemDate = beforeDates[i];
                        if ($.type(itemDate) === 'array') {
                            date = this.getBeforeSingleDate(itemDate);
                            if (date) {
                                break;
                            }
                        } else {
                            if (itemDate.endDate) {
                                date = itemDate.endDate;
                                break;
                            }
                            if (itemDate.beginDate) {
                                date = itemDate.beginDate;
                                break;
                            }
                        }
                    }
                    return date;
                },

                getBeginDateBefore: function (arr, id) {
                    var index;
                    for (var i = 0; i < arr.length; i++) {
                        var itemDate = arr[i];
                        if ($.type(itemDate) === 'array') {
                            var hasId = itemDate.some(function (item) {
                                return item.id === id;
                            });
                            if (hasId) {
                                index = i;
                                break;
                            }
                        } else {
                            if (itemDate.id === id) {
                                index = i;
                                break;
                            }
                        }
                    }
                    return arr.slice(0, index);
                },


                //获取去重后的 levles
                getLevels: function () {
                    var levels = [];
                    var levelObj = {};
                    this.actYwGTimes.forEach(function (item) {
                        var level = item.gnode && item.gnode.level;
                        if (level) {
                            if (!levelObj[level]) {
                                levels.push(level);
                            }
                            levelObj[level] = true;
                        }
                    });
                    levels = levels.sort(function (a, b) {
                        return a - b > 0;
                    });
                    return levels;
                },

                //网关数据
                getDateArr: function () {
                    var dates = [];
                    var levelDates;
                    var self = this;
                    var levels = this.getLevels();
                    levels.forEach(function (level) {
                        levelDates = self.getDateByLevel(level);
                        dates.push(levelDates)
                    });
                    dates.unshift({
                        beginDate: this.proProject.nodeStartDate,
                        endDate: this.proProject.nodeEndDate,
                        gnode: {
                            name: '申报'
                        }
                    });
                    return dates;
                },

                //获取同level时间段
                getDateByLevel: function (level) {
                    var dateArr = [];
                    if (!level) {
                        return dateArr
                    }
                    this.actYwGTimes.forEach(function (item) {
                        var itemLevel = item.gnode && item.gnode.level;
                        if (itemLevel === level) {
                            dateArr.push(item);
                        }
                    });
                    return dateArr.length > 1 ? dateArr : dateArr[0];
                },

                //验证时间
                validateTimes: function (dateArr) {
                    var allValid = false;
                    var res;
                    for (var i = 0; i < dateArr.length; i++) {
                        var item = dateArr[i];
                        if ($.type(item) === 'array') {
                            res = this.validateTimes(item);
                            allValid = res.valid;
                        } else {
                            allValid = this.validateSingleDate(item.beginDate, item.endDate);
                            res = {
                                valid: allValid,
                                item: item
                            };
                        }
                        if (!allValid) {
                            break;
                        }
                    }
                    return res;
                },

                //验证单个时间
                validateSingleDate: function (startDate, endDate) {
                    var startTimes, endTimes;
                    if (!startDate || !endDate) {
                        return true;
                    }
                    startTimes = new Date(startDate).getTime();
                    endTimes = new Date(endDate).getTime();
                    return endTimes - startTimes >= this.nodeGayDay * 24 * 60 * 60 * 1000;
                },

                //validateAllTimes;
                validateAllTimes: function (dateArr) {
                    var res = {
                        valid: true
                    };
                    var times, copyTimes;
                    this.getAllTimes(dateArr);
                    this.addOtherTimes();
                    times = this.allTimes;
                    copyTimes = JSON.parse(JSON.stringify(times));
                    copyTimes = copyTimes.sort(function (a, b) {
                        return new Date(a).getTime() - new Date(b).getTime() > 0;
                    });
                    for (var i = 0; i < times.length; i++) {
                        if (times[i] != copyTimes[i]) {
                            res = {
                                valid: false,
                                time: times[i]
                            };
                            break;
                        }
                    }
                    return res;
                },

                //获取所有的时间
                getAllTimes: function (dateArr) {
                    var self = this;
                    self.allTimes = [];
                    dateArr.forEach(function (item) {
                        var beginDate, endDate, maxMin;
                        if ($.type(item) === 'array') {
                            maxMin = self.getArrMaxMinTime(item);
                            if (maxMin.min) {
                                self.allTimes.push(moment(new Date(maxMin.min)).format('YYYY-MM-DD'))
                            }
                            if (maxMin.max) {
                                self.allTimes.push(moment(new Date(maxMin.max)).format('YYYY-MM-DD'))
                            }
                        } else {
                            beginDate = item.beginDate;
                            endDate = item.endDate;
                            if (beginDate) {
                                self.allTimes.push(beginDate)
                            }
                            if (endDate) {
                                self.allTimes.push(endDate)
                            }
                        }
                    })

                },

                getArrMaxMinTime: function (arr) {
                    var bTimes = [], eTimes = [];
                    arr.forEach(function (item) {
                        if (item.beginDate) {
                            bTimes.push(new Date(item.beginDate).getTime())
                        }
                        if (item.endDate) {
                            eTimes.push(new Date(item.endDate).getTime())
                        }
                    });
                    return {
                        max: Math.max.apply(null, bTimes),
                        min: Math.min.apply(null, eTimes)
                    }
                },

                //添加申报时间
                addOtherTimes: function () {
                    //                    var nodeStartDate = this.proProject.nodeStartDate;
                    //                    var nodeEndDate = this.proProject.nodeEndDate;
                    var startDate = this.proProject.startDate;
                    var endDate = this.proProject.endDate;
                    //                    if (nodeEndDate) {
                    //                        this.allTimes.unshift(nodeEndDate)
                    //                    }
                    //                    if (nodeStartDate) {
                    //                        this.allTimes.unshift(nodeStartDate)
                    //                    }
                    if (startDate) {
                        this.allTimes.unshift(startDate)
                    }
                    if (endDate) {
                        this.allTimes.push(endDate)
                    }
                },

                showProjectYear: function ($event) {
                    var self = this;
                    WdatePicker({
                        el: $event.target,
                        isShowToday: false,
                        dateFmt: 'yyyy',
                        isShowClear: true,
                        onpicked: function () {
                            self.proProject.year = $event.target.value
                        },
                        oncleared: function () {
                            self.proProject.year = ''
                        }
                    });
                },

                showNodeGTimeStartDatePicker: function (item, index, $event) {
                    var minDate;
                    var self = this;
                    var maxDate = this.getEndDate(item, 'beginDate');
                    minDate = this.getStartDate(item, 'beginDate');

                    WdatePicker({
                        el: $event.target,
                        minDate: minDate,
                        maxDate: maxDate,
                        onpicked: function () {
                            self.actYwGTimes[index].beginDate = $event.target.value;
                        },
                        oncleared: function () {
                            self.actYwGTimes[index].beginDate = ''
                        }
                    })
                },

                showNodeGTimeEndDatePicker: function (item, index, $event) {
                    var minDate;
                    var self = this;
                    var maxDate = this.getEndDate(item, 'endDate');
                    minDate = this.getStartDate(item, 'endDate');
                    WdatePicker({
                        el: $event.target,
                        minDate: minDate,
                        maxDate: maxDate,
                        onpicked: function () {
                            self.actYwGTimes[index].endDate = $event.target.value;
                        },
                        oncleared: function () {
                            self.actYwGTimes[index].endDate = ''
                        }
                    })
                },

                showStartDatePicker: function ($event) {
                    var endDate = this.proProject.endDate;
                    var self = this;


                    WdatePicker({
                        el: $event.target,
                        //                        minDate: moment(this.curDate).format('YYYY-MM-DD'),
                        maxDate: endDate,
                        onpicked: function () {
                            self.proProject.startDate = $event.target.value;
                            self.emptyTableDate();
                        },
                        oncleared: function () {
                            self.proProject.startDate = '';
                            self.emptyTableDate();
                        }
                    })
                },

                emptyTableDate: function () {
                    this.actYwGTimes.forEach(function (item) {
                        item.beginDate = '';
                        item.endDate = '';
                    })
                    this.proProject.nodeStartDate = '';
                    this.proProject.nodeEndDate = '';
                },

                showEndDatePicker: function ($event) {
                    var self = this;

                    WdatePicker({
                        el: $event.target,
                        minDate: this.proProject.startDate,
                        onpicked: function () {
                            self.proProject.endDate = $event.target.value;
                            self.emptyTableDate();
                        },
                        oncleared: function () {
                            self.proProject.endDate = '';
                            self.emptyTableDate();
                        }
                    })
                },


                showNodeStartDatePicker: function ($event) {
                    var self = this;
                    WdatePicker({
                        el: $event.target,
                        minDate: this.proProject.startDate,
                        maxDate: this.proProject.endDate,
                        onpicked: function () {
                            self.proProject.nodeStartDate = $event.target.value;
                        },
                        oncleared: function () {
                            self.proProject.nodeStartDate = ''
                        }
                    })
                },

                showNodeEndDatePicker: function ($event) {
                    var self = this;

                    WdatePicker({
                        el: $event.target,
                        minDate: this.proProject.nodeStartDate,
                        maxDate: this.proProject.endDate,
                        onpicked: function () {
                            self.proProject.nodeEndDate = $event.target.value;
                        },
                        oncleared: function () {
                            self.proProject.nodeEndDate = ''
                        }
                    })
                },

                computedActYwGtimes: function () {


                    this.actYwGTimes.forEach(function (t) {
                        if (t.beginDate) {
                            t.beginDate = moment(new Date(t.beginDate)).format('YYYY-MM-DD');
                        }
                        if (t.endDate) {
                            t.endDate = moment(new Date(t.endDate)).format('YYYY-MM-DD');
                        }
                        Vue.set(t,'hasTpl',!t.hasTpl  ? '0' : '1' )
                    })
                },

                getExpTypes: function () {
                    var self = this;
                    $.get('${ctx}/impdata/ajaxExpTypes?isAll=true').success(function (response) {
                        var data = response.datas;
                        if(response.status){
                            data = JSON.parse(data);
                            self.expTypes = data;
                        }
                        console.log(response)
                    }).error(function (error) {

                    })
                },

                getNodeTimes: function (groupId) {
                    var self = this;
                    if (this.actYwGtimeList.length) {
                        this.actYwGTimes = [];
                        this.actYwGTimes = this.actYwGtimeList.sort(function (item1, item2) {
                            return item1.gnode.level - item2.gnode.level > 0
                        });
                        this.computedActYwGtimes();
                        return
                    }
                    $.ajax({
                        type: 'GET',
                        url: 'changeModel',
                        data: {
                            id: groupId
                        },
                        dataType: 'json',
                        success: function (data) {
                            self.actYwGTimes = [];
                            self.actYwGtimeList = data;
                            self.actYwGtimeList.forEach(function (item) {
                                self.actYwGTimes.push({
                                    id: item.id,
                                    beginDate: '',
                                    endDate: '',
                                    status: '1',
                                    level: item.level,
                                    hasTpl: '0',
                                    gnode: {
                                        name: item.name,
                                        level: item.level
                                    },
                                    gnodeId: item.id,
                                    rateStatus: '0'
                                })
                            })
                        },
                        error: function (error) {

                        }
                    })
                },
            },
            beforeMount: function () {
                this.proProject.nodeState = this.nodeState !== 'false' ? '1' : '0';
                this.getNodeTimes('${actYw.groupId}');
            },
            mounted: function () {
                this.getExpTypes();
                console.log(this.actYwGtimeList)
            }
        })
    }(jQuery, Vue);


</script>
</body>
</html>