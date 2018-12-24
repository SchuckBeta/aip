<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${fns:getConfig('frontTitle')}</title>
    <meta name="decorator" content="cyjd-site-default"/>
    <%--<%@include file="/WEB-INF/views/include/backcyjd.jsp" %>--%>
    <%@include file="/WEB-INF/views/include/treeview.jsp" %>
    <link rel="stylesheet" href="${ctxStatic}/fullcalendar/fullcalendar.min.css">
    <link rel="stylesheet" href="${ctxStatic}/fullcalendar/scheduler.min.css">
    <link href="${ctxStatic}/jquery-jbox/2.3/Skins/Bootstrap/jbox.min.css" rel="stylesheet"/>
    <script src="${ctxStatic}/jquery-jbox/2.3/jquery.jBox-2.3.min.js" type="text/javascript"></script>
    <script src="${ctxStatic}/vue/vue.min.js"></script>
    <script src="/js/frontCyjd/floor-tree.js"></script>
    <script src="${ctxStatic}/fullcalendar/moment.min.js"></script>
    <script src="${ctxStatic}/fullcalendar/fullcalendar.min.js"></script>
    <script src="${ctxStatic}/fullcalendar/scheduler.min.js"></script>
    <script src="${ctxStatic}/fullcalendar/locale/zh-cn.js"></script>

    <style>
        .dialog-cyjd-container .dialog-cyjd {
            padding: 20px 15px;
            min-height: 250px;
            min-width: 320px;
            max-width: 360px;
            text-align: center;
            overflow: hidden;
        }



        .modal {
            display: block;
        }





        .modal-body .ztree {
            height: 220px;
            overflow-x: hidden;
            overflow-y: auto;
        }

        .dialog-complete .ui-dialog-titlebar-close {
            display: none;
        }
    </style>
</head>
<body>
<div id="viewWeek" class="container container-ct">
    <ol class="breadcrumb" style="margin-top: 0">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li class="active">创业基地</li>
        <li class="active">预约申请</li>
    </ol>

    <form:form modelAttribute="pwAppointmentVo" class="form-inline form-appointment"
               action="${ctx}/pw/pwAppointment/viewWeek"
               method="post"
               v-show="isLoad" cssStyle="display:none;margin-bottom: 20px;">
        <div class="cate-attrs cate-attrs-auto">
            <div class="cate-attr-key">
                <span>房间类型</span>
            </div>
            <div class="cate-attr-value">
                <ul class="av-collapse">
                    <li class="av-item av-item-all">
                        <div class="ac-item-box">
                            <input type="checkbox" name="roomTypes" @change="changeRoomType($event)"
                                   v-model="roomTypes" value="all" checked>
                            <label class="avi-label">全部</label>
                        </div>
                    </li>
                    <li class="av-item" v-for="item in roomTypeArr">
                        <div class="ac-item-box">
                            <input type="checkbox" name="roomTypes" :value="item.value"
                                   @change="changeRoomType($event)" checked
                                   v-model="roomTypes">
                            <label class="avi-label">{{item.label}}</label>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="cate-attrs cate-attrs-auto">
            <div class="cate-attr-key">
                <span>楼栋</span>
            </div>
            <div class="cate-attr-value">
                <ul class="av-collapse">
                    <li class="av-item av-item-all">
                        <div class="ac-item-box">
                            <input type="radio" v-model="form.buildingId" name="build" checked value=""
                                   @change="changeBuild">
                            <label class="avi-label">不限</label>
                        </div>
                    </li>
                    <li class="av-item" v-for="build in buildList">
                        <div class="ac-item-box">
                            <input type="radio" v-model="form.buildingId" name="build" :value="build.id"
                                   @change="changeBuild">
                            <label class="avi-label">{{build.name}}</label>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="cate-attrs cate-attrs-auto">
            <div class="cate-attr-key">
                <span>楼层</span>
            </div>
            <div class="cate-attr-value">
                <ul class="av-collapse">
                    <li class="av-item av-item-all">
                        <div class="ac-item-box">
                            <input type="radio" name="floor" v-model="form.floorId" checked value=""
                                   @change="changeFloor">
                            <label class="avi-label">不限</label>
                        </div>
                    </li>
                    <li class="av-item" v-for="floor in floorList">
                        <div class="ac-item-box">
                            <input type="radio" v-model="form.floorId" name="floor" :value="floor.id"
                                   @change="changeFloor">
                            <label class="avi-label">{{floor.name}}</label>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="cate-check-bar" style="margin-left: -10px;">
            <div class="ch-wrap">
                <div class="ch-block" style="padding:0 10px;">
                    <label style="font-size: 12px;" v-if="item.label === '通过' || item.label === '待审核'"
                           class="checkbox-inline"
                           v-for="(item, index) in pwAppointmentStatus">
                        <input type="checkbox" :value="item.value" v-model="status">{{item.label}}
                    </label>
                </div>
                <div class="ch-block ch-block-transparent">
                    <div class="ch-num-range">
                        <div class="chn-box" style="font-size: 0;">
                            <span style="line-height: 26px;font-size: 12px;margin-left:5px;">容纳人数范围：</span>
                            <form:input cssStyle="margin-left:5px;" path="roomNumMin" type="number" v-model="form.roomNumMin" cssClass="input-range form-control"/>
                            <span style="margin-left:5px;font-size:12px;">-</span>
                            <form:input cssStyle="margin-left:5px;" path="roomNumMax" type="number" v-model="form.roomNumMax" cssClass="input-range form-control"/>
                            <button style="margin-left:10px;" type="button" class="btn btn-sm btn-primary btn-range-save" @click="search">确定</button>
                        </div>
                    </div>
                </div>
            </div>
            <%--<div class="pull-right">--%>
                <%--<button type="button" class="btn btn-primary" @click="search">查询</button>--%>
            <%--</div>--%>
        </div>
    </form:form>

    <div class="calendar-container">
        <div class="cate-attrs" :class="{'cate-attrs-auto': roomAuto}" style="margin-left: 10px; opacity: 0">
            <div class="cate-attr-key">
                <span>房间</span>
            </div>
            <div class="cate-attr-value" style="padding-right: 48px;">
                <ul class="av-collapse">
                    <li class="av-item av-item-all">
                        <div class="ac-item-box">
                            <input type="radio" name="room" v-model="form.roomId" value="" @change="changeRoom('all')">
                            <label class="avi-label">全部</label>
                        </div>
                    </li>
                    <li class="av-item" v-for="(room, index) in rooms">
                        <div class="ac-item-box">
                            <input type="radio" v-model="form.roomId" name="room" :value="room.id" @change="changeRoom(room, index)">
                            <label class="avi-label">{{room.name}}</label>
                        </div>
                    </li>
                </ul>
                <a v-show="moreShow" style="display: none" v-more class="av-item-more av-room-more" @click="roomAuto = !roomAuto"
                   href="javascript:void (0);">更多</a>
            </div>
        </div>
        <h4 v-show="isLoad" style="display: none; margin-bottom: 20px;" class="text-center room-title">
            预约及查询</h4>
        <h4 v-show="isLoad" style="display: none">{{roomName}}</h4>
        <div id="calendar"></div>
    </div>
    <div id="modalCalendar" style="display: none" v-show="modalCalendarShow" class="modal modal-calendar">
        <div class="modal-dialog">
            <div class="modal-content" v-drag>
                <div class="modal-header">
                    <button type="button" class="close" @click="modalCalendarShow=false"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">预约申请</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" v-validate="{form: 'appointmentValidateForm'}">
                        <div class="form-group">
                            <label class="control-label col-xs-3">申请人：</label>
                            <div class="col-xs-8">
                                <p class="form-control-static">${fns:getUser().name}</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">房间：</label>
                            <div class="col-xs-6">
                                <p class="form-control-static">{{appointmentForm.roomName}}</p>
                                <%--<input type="text" class="form-control input-sm required" name="roomName"--%>
                                <%--v-model="appointmentForm.roomName" readonly :disabled="this.roomIndex !== 'all'"--%>
                                <%--placeholder="-请选择-"--%>
                                <%--@click="showFloorTree">--%>
                                <input type="hidden" name="roomId" class="required" v-model="appointmentForm.roomId"
                                       readonly :disabled="this.roomIndex !== 'all'">

                                <%--<floor-tree :room-id="appointmentForm.roomId" :room-name="appointmentForm.roomName" ctx="${ctxFront}"--%>
                                <%--:disabled="roomIndex !== 'all'" class-name="form-control input-sm"--%>
                                <%--ext-id="${pwRoom.pwSpace.id}" url="/pw/pwRoom/roomTreeData"--%>
                                <%--@room-info="changeAppRoomIdName"></floor-tree>--%>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">可容纳人数：</label>
                            <div class="col-xs-8">
                                <p class="form-control-static">{{appointmentForm.capacity}}人</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">预约日期：</label>
                            <div class="col-xs-8">
                                <%--<input type="text" maxlength="20"--%>
                                <%--class="Wdate input-medium required"--%>
                                <%--@click="openStartDatePicker($event)"--%>
                                <%--disabled--%>
                                <%--v-model="appointmentForm.day"/>--%>
                                <p class="form-control-static">{{appointmentForm.day}}</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3">预约时间段：</label>
                            <div class="col-xs-8">
                                <div class="input-group">
                                    <%--<input id="startDate" type="text" maxlength="20"--%>
                                           <%--name="startDate"--%>
                                           <%--class="Wdate form-control input-sm required"--%>
                                           <%--@click="openStartDatePicker($event)"--%>
                                           <%--disabled--%>
                                           <%--v-model="appointmentForm.startDate"/>--%>
                                    <%--<span class="input-group-addon" style="margin: 0 4px;">至</span>--%>
                                    <%--<input id="endDate" type="text" maxlength="20"--%>
                                           <%--name="endDate"--%>
                                           <%--class="Wdate form-control input-sm required"--%>
                                           <%--v-model="appointmentForm.endDate"--%>
                                           <%--disabled--%>
                                           <%--@click="openEndDatePicker($event)"/>--%>
                                    <p class="form-control-static">
                                        {{appointmentForm.startTimeStr}}
                                        <span style="margin: 0 4px;">至</span>
                                        {{appointmentForm.endTimeStr}}
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3"><i>*</i>参与人数：</label>
                            <div class="col-xs-4">
                                <div class="input-group">
                                    <input style="width:140px;" placeholder="输入最大长度为6位数" id="personNum" type="text" v-model="appointmentForm.personNum" maxlength="6"
                                           name="personNum"
                                           class="form-control input-sm required number positiveNumber digits ">
                                    <div class="input-group-addon">人</div>
                                </div>

                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-xs-3"><i>*</i>用途：</label>
                            <div class="col-xs-8">
                                <textarea id="subject" rows="4" maxlength="50" v-model="appointmentForm.subject"
                                          name="subject"
                                          class="form-control input-sm required" placeholder="输入最大长度为50位字符"></textarea>
                            </div>
                        </div>
                        <input type="hidden" name="startDate" v-model="appointmentForm.startDate"/>
                        <input type="hidden" name="endDate" v-model="appointmentForm.endDate"/>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-save btn-primary" :disabled="isSave"
                            @click="submitAppointmentForm">确定
                    </button>
                    <button type="button" class="btn btn-default" @click="modalCalendarShow=false">取消</button>
                </div>
            </div>
        </div>
    </div>

    <floor-tree :show="treeShow" url="${ctxFront}/pw/pwRoom/roomTreeData?isUsable=1" :room-id="appointmentForm.roomId"
                :room-name="appointmentForm.roomName" @clear="clear" @save="changeRoomId" @cancel="cancel"></floor-tree>
    <div v-show="tooltipShow" class="tooltip bottom" role="tooltip" :style="toolStyle"
         style="opacity: 0; display: none">
        <div class="tooltip-arrow"></div>
        <div class="tooltip-inner">
            <span style="display: block;white-space: pre" v-html="toolTitle"></span>
        </div>
    </div>
    <%--<div v-show="true" class="tooltip bottom" role="tooltip"  style="opacity: 1; display: block;z-index: 10000">--%>
    <%--<div class="tooltip-arrow"></div>--%>
    <%--<div class="tooltip-inner" style="word-break: break-all">--%>
    <%--{{toolTitle}}--%>
    <%--</div>--%>
    <%--</div>--%>

</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>


<script>
    +(function ($) {
        var viewWeek = new Vue({
            el: '#viewWeek',
            data: function () {
                return {
                    appList: JSON.parse('${fns:toJson(list)}'),
                    appRule: JSON.parse('${fns:toJson(appRule)}'),
                    user: JSON.parse('${fns:toJson(fns:getUser())}'),
                    modalCalendarShow: false,
                    roomName: '全部场地',
                    roomTypeArr: JSON.parse('${fns:toJson(fns:getDictList('pw_room_type'))}'),
                    roomTypes: ['all'],
                    pwAppointmentStatus: JSON.parse('${fns:toJson(fns:getDictList('pw_appointment_status'))}'),
                    status: [],
                    form: {
                        roomType: '',
                        buildingId: '',
                        floorId: '',
                        roomNumMin: '',
                        roomNumMax: '',
                        status: '',
                        roomId: ''
                    },
                    tooltipShow: false,
                    toolTitle: '',
                    toolStyle: {
                        left: '',
                        top: '',
                        opacity: 0
                    },
                    roomForm: {
                        roomIds: '',
                        status: 0
                    },
                    appointmentForm: {
                        roomName: '',
                        roomId: '',
                        capacity:'',
                        subject: '',
                        personNum: '',
                        startDate: '',
                        endDate: '',
                        remarks: '',
                        day: '',
                        startTimeStr: '',
                        endTimeStr: ''
                    },
                    appointmentValidateForm: '',
                    rooms: JSON.parse('${fns:toJson(rooms)}'),
                    roomStatus: [],
                    buildList: [],
                    floorList: [],
                    roomIndex: 'all',
                    calendar: '',
                    eventData: {},
                    currentRoom: {},
                    isSave: false,
                    treeShow: false,
                    isLoad: false,
                    roomAuto: false,
                    moreShow: false,
                    tooltipTime: '',
                    tooltipSubject: '',
                    tooltipUserName: ''
                }
            },
            computed: {
                eventList: function () {
                    var eventList = [];
                    var self = this;
                    this.appList.forEach(function (t) {
                        var item = {
                            id: t.id,
                            start: t.startDate,
                            end: t.endDate
                        };
                        if (t.user.id == self.user.id) {
                            item.color = '#' + t.color;
                            item.title = '用途：' + t.subject + '\n预约人：' + t.user.name + '';
                        } else {
                            item.overlap = false;
                            item.rendering = 'background';
                            item.color = '#d7d7d7'
                        }
                        eventList.push(item)
                    })
                    return eventList;
                },
                isAppDayList: function () {
                    var i = this.appRule.isAppDayList.indexOf('7');
                    if(i > -1){
                        this.appRule.isAppDayList.splice(i, 1, '0');//0表示周日
                    }
                    return this.appRule.isAppDayList;
                }
            },
            watch: {
                'appointmentForm.roomId': function () {
                    this.appointmentForm['pwRoom.id'] = this.appointmentForm.roomId;
                },
                modalCalendarShow: function (val) {
                    if (!val) {
                        var roomId = this.appointmentForm.roomId;
                        var roomName = this.appointmentForm.roomName;
                        var capacity = this.appointmentForm.capacity;
                        this.appointmentForm = {
                            subject: '',
                            personNum: '',
                            remarks: '',
                            roomName: roomName,
                            roomId: roomId,
                            capacity: capacity,
                            startDate: '',
                            endDate: ''
                        };

                        this.appointmentValidateForm.resetForm();

                        if (this.form.roomId) {
                            this.appointmentForm.roomId = this.form.roomId
                            this.appointmentForm.roomName = this.rooms[this.roomIndex]['name']
                        }
                    }
                },
                'roomTypes': function () {
                    this.form.roomTypes = this.roomTypes.join(',')
                    if(this.isLoad){
                        this.search();
                    }
                },
                'status': function () {
                    this.form.status = this.status.join(',')
                    if(this.isLoad){
                        this.search();
                    }
                },
                'rooms': function (val) {
                    var element = $('.av-room-more')[0];
                    var $avCollapse = $(element).prev();
                    var avCW = $avCollapse.width();
                    var avItemWidth = $avCollapse.find('.av-item').eq(1).width();
                    if(avItemWidth < 1){
                        this.moreShow = false;
                        return;
                    }
                    this.moreShow = (avCW / (avItemWidth + 8)) < val.length;
                },
                'appointmentForm.startDate': function (val) {
                    if(val){
                        this.appointmentForm.day = moment(this.appointmentForm.startDate).format('YYYY-MM-DD');
                        this.appointmentForm.startTimeStr = moment(this.appointmentForm.startDate).format('HH:mm');
                    }


                },
                'appointmentForm.endDate': function (val) {
                    if(val){
                        var s = moment(this.appointmentForm.endDate).format('HH:mm');
                        this.appointmentForm.endTimeStr = (s == '00:00' ? '24:00' : s);
                    }
                }
            },
            directives: {
                validate: {
                    inserted: function (element, binding, vnode) {
                        vnode.context[binding.value.form] = $(element).validate({
                            errorPlacement: function (error, element) {
                                if (element.is(":checkbox") || element.is(":radio") || element.parent().hasClass('input-group')) {
                                    error.appendTo(element.parent().parent());
                                } else if ((/Date/).test(element.attr('name'))) {
                                    error.appendTo(element.parent());
                                } else if (element.nextAll('.help-inline').size() > 0) {
                                    error.appendTo(element.parent());
                                } else {
                                    error.insertAfter(element);
                                }
                            }
                        })
                    }
                },
                more: {
                    inserted: function (element, binding, vnode) {
                        var $avCollapse = $(element).prev();
                        var avCW = $avCollapse.width();
                        var avItemWidth = $avCollapse.find('.av-item').eq(1).width();
                        $avCollapse.parents('.cate-attrs').css('opacity', '');
                        if(avItemWidth < 1){
                            vnode.context.moreShow = false;
                            return;
                        }
                        vnode.context.moreShow = (avCW / (avItemWidth + 8)) < vnode.context.rooms.length
                    }
                },
                drag: function (element, binding, vnode) {
                    $(element).draggable({
                        handle: ".modal-header",
                        containment: "body"
                    })
                }
            },
            methods: {
                changeRoomType: function ($event) {
                    var val = $event.target.value;
                    var self = this;
                    var isAll = false;
                    if (val === 'all') {
                        if ($event.target.checked) {
                            this.roomTypeArr.forEach(function (t) {
                                if (!(self.roomTypes.indexOf(t.value) > -1)) {
                                    self.roomTypes.push(t.value)
                                }
                            })
                        } else {
                            this.roomTypes.length = 0;
                        }
                    } else {
                        if ($event.target.checked) {
                            isAll = true;
                            if (this.roomTypes.length == this.roomTypeArr.length) {
                                this.roomTypes.forEach(function (t) {
                                    if (!t) {
                                        isAll = false
                                    }
                                })
                                this.roomTypes.push('all')
                            }
                        } else {
                            this.roomTypes.forEach(function (t, i) {
                                if (t == 'all') {
                                    self.roomTypes.splice(i, 1)
                                }
                            })
                        }
                    }

                },
                //打开楼层树
                showFloorTree: function () {
                    this.treeShow = true;
                },

                cancel: function () {
                    this.treeShow = false;
                },
                changeRoomId: function (arr) {
                    this.appointmentForm.roomId = arr[0];
                    this.appointmentForm.roomName = arr[1];
                    this.treeShow = false;
                },

                clear: function () {
                    this.appointmentForm.roomId = '';
                    this.appointmentForm.roomName = '';
                    this.treeShow = false;
                },

                //获取楼栋
                getBuildList: function () {
                    var self = this;
                    var buildListXhr = $.get('${ctxFront}/pw/pwSpace/jsonList', {type: 3});
                    buildListXhr.success(function (data) {
                        self.buildList = data;
                        self.isLoad = true;
                    })
                    buildListXhr.error(function (error) {
                        self.isLoad = true;
                    })
                },


                //获取楼层
                changeBuild: function () {
                    var self = this;
                    var floorListXhr;
                    self.form.floorId = '';
                    if (!this.form.buildingId) {
                        self.floorList.length = 0;
                        if(this.isLoad){
                            this.search();
                        }
                        return false;
                    }
                    floorListXhr = $.get('${ctxFront}/pw/pwSpace/children/' + this.form.buildingId);
                    floorListXhr.success(function (data) {
                        self.floorList = data;
                    });
                    floorListXhr.error(function (error) {
                        self.floorList.length = 0;
                    })
                    this.search();

                },

                //查询
                search: function () {
                    var self = this;
                    var xhr = $.get('${ctxFront}/pw/pwAppointment/weekSearch', this.form);
                    xhr.success(function (data) {
                        self.rooms = data.rooms;
                        self.form.roomId = '';
                        self.getRoomStatus()
                        self.changeCalendarData(data)
                    })

                    xhr.error(function () {

                    })

                },

                //房间查询
                changeRoom: function (item, index) {
                    var xhr, roomIds = [], self = this;
                    if (item === 'all') {
                        this.roomName = '全部场地';
                        this.roomStatus.forEach(function (t, i) {
                            t.status = true;
                            roomIds.push(self.rooms[i].id);
                        });
                        this.roomForm.roomIds = roomIds.join(',');
                        this.appointmentForm.roomId = '';
                        this.appointmentForm.roomName = '';
                        this.appointmentForm.capacity = '';
                        this.currentRoom = {};
                        this.form.roomId = '';
                    } else {
                        self.roomName = this.rooms[index].path;
                        this.roomStatus.forEach(function (t, i) {
                            t.status = true;
                            if (!t.status && self.rooms[i]) {
                                roomIds.push(self.rooms[i].id);
                            }
                        });
                        this.roomStatus[index].status = !this.roomStatus[index].status;
                        this.roomForm.roomIds = this.rooms[index].id;
                        this.appointmentForm.roomId = this.rooms[index].id;
                        this.appointmentForm.roomName = this.rooms[index].name;
                        this.appointmentForm.capacity = this.rooms[index].num;
                        this.currentRoom = this.rooms[index];
                        this.form.roomId = this.rooms[index].id;
                        this.roomIndex = index;
                    }


                    if (!this.roomForm.roomIds) {
                        //数据置空，不发送请求
                        return false;
                    }
                    this.roomForm.status = this.form.status;
                    xhr = $.get('${ctxFront}/pw/pwAppointment/weekSearch', this.roomForm);
                    xhr.success(function (data) {
                        self.changeCalendarData(data)
                    });
                    xhr.error(function (error) {

                    })
                },

                //获取房间状态
                getRoomStatus: function () {
                    var self = this;
                    this.roomStatus.length = 0;
                    this.rooms.forEach(function (t) {
                        self.roomStatus.push({
                            status: true
                        });
                    });
                },
                //改变视图数据
                changeCalendarData: function (data) {
                    this.appList = data.list;
                    this.calendar.fullCalendar('removeEvents');
                    if (this.eventList.length > 0) {
                        this.calendar.fullCalendar('addEventSource', this.eventList)
                    }
                },

                openStartDatePicker: function ($event) {
                    var self = this;
                    WdatePicker({
                        dateFmt: 'yyyy-MM-dd HH:mm',
                        isShowClear: false,
                        onpicked: function (i) {
                            self.appointmentForm.startDate = $event.target.value;
                        }
                    });
                },

                openEndDatePicker: function ($event) {
                    var self = this;
                    WdatePicker({
                        dateFmt: 'yyyy-MM-dd HH:mm',
                        isShowClear: false,
                        onpicked: function () {
                            self.appointmentForm.endDate = $event.target.value;
                        }
                    });
                },

                //提交预约
                submitAppointmentForm: function () {
                    var xhr;
                    var self = this;
                    this.appointmentForm['pwRoom.id'] = this.appointmentForm.roomId;
                    if (this.appointmentValidateForm.form()) {
                        this.isSave = true;
                        xhr = $.post('${ctxFront}/pw/pwAppointment/asySave', this.appointmentForm);
                        xhr.success(function (data) {
                            data = JSON.parse(data)
                            if (data.success) {
//                                self.calendar.
                                self.isSave = false;
                                var eventData = {
                                    id: data.id,
//                                    title: self.user.name + ('【' + (self.appointmentForm.subject || '锁定') + '】'),
                                    title: '用途：' + self.appointmentForm.subject + '\n预约人：' + self.user.name + '',
                                    start: self.eventData.start,
                                    end: self.eventData.end,
                                    color: '#' + self.getRoomColor(self.appointmentForm.roomId)[0].color
                                };
                                self.calendar.fullCalendar('renderEvent', eventData, true);
                                self.modalCalendarShow = false;
                                self.appointmentForm = {
                                    roomId: '',
                                    roomName: '',
                                    capacity: '',
                                    startDate: '',
                                    endDate: '',
                                    remarks: ''
                                }
                            } else {
                                self.isSave = false;
                                self.modalCalendarShow = false;
                                dialogCyjd.createDialog(0, data.msg);
                            }
                            self.appointmentValidateForm.resetForm();

                        })
                        xhr.error(function (error) {
                            self.isSave = false;
                            self.modalCalendarShow = false;
                            dialogCyjd.createDialog(0, '错误代码' + error.status);
                        })
                    }
                },
                getRoomColor: function (id) {
                    var room;
                    return this.rooms.filter(function (t) {
                        return t.id === id;
                    })
                },
                //选择房间
                changeAppRoomIdName: function (room) {
                    this.appointmentForm.roomId = room[0];
                    this.appointmentForm.roomName = room[1];
                },
                changeFloor: function () {
                    this.search();
                }
            },
            beforeMount: function () {
                var self = this;
                this.getBuildList();
                this.changeBuild();
                this.getRoomStatus();
                this.roomTypeArr.forEach(function (t) {
                    self.roomTypes.push(t.value)
                })
            },
            mounted: function () {
                var self = this;
                this.calendar = $('#calendar').fullCalendar({
                    defaultDate: moment('${now}').format(),
                    defaultView: 'agendaWeek',
                    weekends: true,
                    slotDuration: '00:30:00',
                    slotLabelFormat: 'HH:mm',
                    minTime: this.appRule.isTimeAuto == '1' ? '00:00:00' : this.appRule.beginTime,
                    maxTime: this.appRule.isTimeAuto == '1' ? '24:00:00' : this.appRule.endTime,
                    customButtons: {
                        mButton: {
                            text: '月',
                            click: function () {
                                location.href = '${ctxFront}/pw/pwAppointment/viewMonth'
                            }
                        },
                        dayButton: {
                            text: '日',
                            click: function () {
                                location.href = '${ctxFront}/pw/pwAppointment/viewDay'
                            }
                        },
                        tButton: {
                            text: '本周',
                            click: function () {
                                self.calendar.fullCalendar('gotoDate', '${now}')
                            }
                        }
                    },
                    header: {
                        left: 'prev,next tButton',
                        center: 'title',
                        right: 'mButton,agendaWeek,dayButton'
                    },
                    allDaySlot: false,
                    navLinks: true, // can click day/week names to navigate views
                    navLinkDayClick: function (date, jsEvent) {
                        location.href = '${ctxFront}/pw/pwAppointment/viewDay?searchDay='+ date._i;
                    },
                    editable: false,
                    height: 'auto',
                    selectable: true,
                    businessHours: {
                        dow: this.isAppDayList,
                        start: this.appRule.isTimeAuto == '1' ? '00:00:00' : this.appRule.beginTime,
                        end: this.appRule.isTimeAuto == '1' ? '24:00:00' : this.appRule.endTime
                    }, // display business hours锁定工作日
                    selectConstraint: 'businessHours',
                    schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
                    eventRender: function (event, element) {
                        if (event.rendering !== 'background') {
                            element.append('<span class="fc-close" style="position: absolute;right: 0;top: 0; cursor: pointer; z-index: 100">X</span>')
                        }
                    },
                    select: function (start, end) {
                        self.eventData.start = start;
                        self.eventData.end = end;
                        self.appointmentForm.startDate = moment(start).format('YYYY-MM-DD HH:mm');
                        self.appointmentForm.endDate = moment(end).format('YYYY-MM-DD HH:mm');
                        self.calendar.fullCalendar('unselect');
                        if (!self.appointmentForm.roomId) {
                            dialogCyjd.createDialog(0, '请选择房间，然后预约');
                            return false;
                        }
                        if (new Date().getTime() - new Date(self.appointmentForm.startDate).getTime() > 0) {
                            dialogCyjd.createDialog(0, '不能预约过去的时间')
                        } else {
                            self.modalCalendarShow = true;
                        }
                    },
                    selectOverlap: function (event) {
                        return event.rendering === '#ff9f89';
                    },
                    eventClick: function (date, event, jsEvent, view) {
                        var id = date.id;
                        if (event.target.className === 'fc-close') {
                            dialogCyjd.createDialog(0, '是否取消此预约？', {
                                buttons: [{
                                    text: '确定',
                                    'class': 'btn btn-primary',
                                    click: function () {
                                        var $this = $(this);
                                        var $button = $this.next().find('button.btn-primary');
                                        $button.prop('disabled', true);
                                        var xhr = $.post('${ctxFront}/pw/pwAppointment/asyCancel', {id: id});
                                        xhr.success(function (data) {
                                            data = JSON.parse(data);
                                            if (data.success) {
                                                self.calendar.fullCalendar('removeEvents', date.id);
                                                $button.prop('disabled', false);
                                                $this.dialog('close');
                                            } else {
                                                $button.prop('disabled', false);
                                                dialogCyjd.createDialog(0, data.msg)
                                            }
                                        });
                                        xhr.error(function (error) {
                                            $button.prop('disabled', false);
                                            dialogCyjd.createDialog(0, '请求失败');
                                        })
                                    }
                                }, {
                                    text: '取消',
                                    'class': 'btn btn-default',
                                    click: function () {
                                        $(this).dialog('close')
                                    }
                                }]
                            })
                        }
                    },
                    events: this.eventList
                });
            }
        });
        $(document).on('mouseenter', 'div.fc-content', function () {
            var time = $(this).find('.fc-time').text();
            var title = $(this).find('.fc-title').html();
            var width = $(this).width();
            var height = $(this).height();
            var left = $(this).offset().left;
            var top = $(this).offset().top;
            var toolWidth;
            viewWeek.$data.tooltipShow = true;
            viewWeek.$data.toolTitle = time + '\n' + title;
            setTimeout(function () {
                toolWidth = $('.tooltip .tooltip-inner').width();
                viewWeek.$data.toolStyle = {
                    left: (left - (toolWidth - width) / 2) + 'px',
                    top: (top + height) + 'px',
                    opacity: 1
                }
            }, 0)
        }).on('mouseleave', 'div.fc-content', function (e) {
            if ($(e.target).hasClass('tooltip') || $(e.target).parents('.tooltip').size() > 0) {
                return false;
            }
            viewWeek.$data.toolStyle.opacity = 0;
            viewWeek.$data.tooltipShow = false;
        })
    })(jQuery);

    var complete = ${fns:isUserinfoComplete()};
    if (!complete) {
        dialogCyjd.createDialog(0, "个人信息未完善，立即完善个人信息？", {
            'dialogClass': 'dialog-complete dialog-cyjd-container',
            closeOnEscape: false,
            buttons: [{
                text: '确定',
                click: function () {
                    location.href = "${ctxFront}/sys/frontStudentExpansion/findUserInfoById?custRedict=1&isEdit=1";
                }
            }]
        });
    }
</script>
</body>
</html>