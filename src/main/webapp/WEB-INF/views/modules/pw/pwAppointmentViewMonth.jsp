<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>
    <link rel="stylesheet" href="${ctxStatic}/fullcalendar/fullcalendar.min.css">
    <link rel="stylesheet" href="${ctxStatic}/fullcalendar/scheduler.min.css">
    <script src="${ctxStatic}/fullcalendar/fullcalendar.min.js"></script>
    <script src="${ctxStatic}/fullcalendar/scheduler.min.js"></script>
    <script src="${ctxStatic}/fullcalendar/locale/zh-cn.js"></script>

</head>
<body>
<div id="app" v-show="pageLoad" class="container-fluid mgb-60" style="display: none">
    <edit-bar></edit-bar>
    <el-form :model="searchListForm" :rules="searchListFormRules" ref="searchListForm" size="mini"
             :show-message="false">
        <div class="conditions">
            <e-condition type="checkbox" v-model="searchListForm.roomTypes" label="房间类型" :options="pwRoomTypes"
                         @change="handleChangeRoomType"
                         name="roomTypes"></e-condition>
            <e-condition type="checkbox" v-model="searchListForm.status" label="房间状态" :options="pwAppointmentStatuses"
                         @change="handleChangeStatus"
                         name="status"></e-condition>
            <e-condition type="radio" v-model="searchListForm.buildingId" label="楼栋" :options="buildingList"
                         @change="handleChangeBuilding"
                         name="build" :default-props="{label: 'name', value: 'id'}"></e-condition>
            <e-condition type="radio" v-model="searchListForm.floorId" label="楼层" :options="floorList"
                         @change="handleChangeFloor"
                         name="build" :default-props="{label: 'name', value: 'id'}"></e-condition>
            <e-condition type="radio" v-model="searchListForm.roomIds" label="房间" name="room" :options="roomList"
                         @change="handleChangeRoom"
                         :default-props="{label: 'name', value: 'id'}"></e-condition>
        </div>
        <div class="search-block_bar clearfix">
            <div class="search-input" style="width: 300px;">
                <el-form-item style="margin-bottom: 0">
                    <el-col :span="9">
                        <el-form-item prop="roomNumMin" style="margin-bottom: 0">
                            <el-input v-model="searchListForm.roomNumMin" placeholder="最小容纳人数"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="2">
                        <span class="divide-zhi">-</span>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item prop="roomNumMax" style="margin-bottom: 0">
                            <el-input v-model="searchListForm.roomNumMax" placeholder="最大容纳人数">
                                <el-button slot="append" icon="el-icon-search"
                                           @click.stop.prevent="searchMonth"></el-button>
                            </el-input>
                        </el-form-item>
                    </el-col>
                </el-form-item>
            </div>
        </div>
    </el-form>
    <div class="table-container" style="padding: 15px">
        <h4 class="text-center" style="font-size: 16px; margin-bottom: 15px;">{{roomPath}}</h4>
        <div v-loading="loadingCalendar">
            <div v-full-calendar-month="fullCalendarOption"></div>
        </div>
    </div>
</div>

<script type="text/javascript">
    'use strict';

    Vue.directive('full-calendar-month', {
        inserted: function (element, binding, vnode) {
            var option = binding.value;
            var frontOrAdmin = option.frontOrAdmin;
            var eventList = option.eventList;
            var eventColors = option.eventColors;
            var computedEventList = eventList.map(function (item) {
                var colorTypes = eventColors[(item.state)];
                for (var k in colorTypes) {
                    if (colorTypes.hasOwnProperty(k)) {
                        item[k] = colorTypes[k];
                    }
                }
                return item;
            });

            vnode.context.fullCalendar = $(element).fullCalendar({
                weekends: true,
                defaultDate: moment(option.now).format('YYYY-MM-DD'),
                schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
                header: {
                    left: 'prev,next ,tButton',
                    center: 'title',
                    right: 'month,wButton,dButton'
                },
                customButtons: {
                    dButton: {
                        text: '日',
                        click: function () {
                            location.href = frontOrAdmin + '/pw/pwAppointment/viewDay'
                        }
                    },
                    wButton: {
                        text: '周',
                        click: function () {
                            location.href = frontOrAdmin + '/pw/pwAppointment/viewWeek'
                        }
                    },
                    tButton: {
                        text: '本月',
                        click: function () {
                            $(element).fullCalendar('gotoDate', option.now);
                        }
                    },
                },
                aspectRatio: 2,
                allDaySlot: false,
                navLinks: false, // can click day/week names to navigate views
                editable: false,
                selectable: false,
                events: computedEventList,
                dayClick: function (calEvent) {
                    var date = calEvent._d;
                    location.href = option.frontOrAdmin + '/pw/pwAppointment/viewDay?searchDay=' + moment(date).format('YYYY-MM-DD');
                },
                eventClick: function (calEvent, jsEvent, view) {
                    if (calEvent.state == 0) {
                        location.href = frontOrAdmin + '/pw/pwAppointment/review';
                    }
                    if (calEvent.state == 1 || calEvent.state == 3) {
                        location.href = frontOrAdmin + '/pw/pwAppointment/list';
                    }
                    return false;
                }
            })
        }
    });

    new Vue({
        el: '#app',
        data: function () {
            var pwRoomTypes = JSON.parse('${fns:toJson(fns:getDictList('pw_room_type'))}');
            var pwAppointmentStatuses = JSON.parse('${fns: toJson(fns:getDictList('pw_appointment_status'))}');
            var appList = JSON.parse('${fns:toJson(list)}') || [];
            var validatorNumber = function (rule, value, callback) {
                if (value) {
                    if (!(/^\d{1,}$/.test(value))) {
                        return callback(new Error('请输入数字'))
                    } else {
                        if (value > 99999) {
                            return callback(new Error('请输入小于100000数字'))
                        }
                        callback()
                    }
                }
                callback()
            };

            return {
                appList: appList,
                appRule: JSON.parse('${fns:toJson(appRule)}'),
                user: JSON.parse('${fns:toJson(fns:getUser())}'),
                pwRoomTypes: pwRoomTypes,
                now: '${now}',
                pwAppointmentStatuses: pwAppointmentStatuses,
                rooms: JSON.parse('${fns:toJson(rooms)}'),
                loadingCalendar: false,
                pwSpaceList: [],
                fullCalendar: {},
                fullCalendarOption: {},
                fullCalendarLoad: false,
                searchListForm: {
                    roomTypes: [],
                    buildingId: '',
                    floorId: '',
                    roomNumMin: '',
                    roomNumMax: '',
                    status: [],
                    roomIds: ''
                },
                searchListFormRules: {
                    roomNumMin: [
                        {validator: validatorNumber, trigger: 'blur'}
                    ],
                    roomNumMax: [
                        {validator: validatorNumber, trigger: 'blur'}
                    ]
                }
            }
        },
        computed: {
            buildingList: {
                get: function () {
                    return this.pwSpaceList.filter(function (item) {
                        return item.type == '3';
                    })
                }
            },
            floorList: {
                get: function () {
                    var buildingId = this.searchListForm.buildingId;
                    return this.pwSpaceList.filter(function (item) {
                        return item.pId === buildingId;
                    })
                }
            },
            roomList: {
                get: function () {
                    var floorId = this.searchListForm.floorId;
                    if (!floorId) {
                        return this.rooms;
                    }
                    return this.rooms.filter(function (item) {
                        return item.pwSpace.id === floorId;
                    })
                }
            },
            roomPath: {
                get: function () {
                    var roomId = this.searchListForm.roomIds;
                    if (!roomId) {
                        return '全部场地'
                    }
                    for (var i = 0; i < this.rooms.length; i++) {
                        var roomItem = this.rooms[i];
                        if (roomId === roomItem.id) {
                            return roomItem.path;
                        }
                    }
                }
            },
            postParams: {
                get: function () {
                    var params = {};
                    var searchListForm = this.searchListForm;
                    for (var k in searchListForm) {
                        if (searchListForm.hasOwnProperty(k)) {
                            if (typeof searchListForm[k] == 'undefined') {
                                continue;
                            }
                            if ({}.toString.call(searchListForm[k]) === '[object Array]') {
                                if (searchListForm[k].length > 0) {
                                    params[k] = searchListForm[k].join(',')
                                }
                            } else {
                                params[k] = searchListForm[k]
                            }
                        }
                    }
                    return params
                }
            }

        },
        methods: {

            searchMonth: function () {
                var self = this;
                this.loadingCalendar = true;
                this.$axios({
                    url: '/pw/pwAppointment/mouthSearch',
                    method: 'GET',
                    timeout: 5 * 1000,
                    params: this.postParams
                }).then(function (response) {
                    var data = response.data;
                    self.changeCalendarEventList(data.list);
                    self.loadingCalendar = false;
                }).catch(function () {
                    self.loadingCalendar = false;
                })
            },
            getFullCalendarOption: function () {
                return {
                    now: this.now,
                    frontOrAdmin: this.frontOrAdmin,
                    eventList: this.appList,
                    eventColors: {
                        '1': {color: '#52c41a', textColor: '#fff'},
                        '0': {color: '#e9432d', textColor: '#fff'},
                        '2': {color: '#d9d9d9', textColor: '#333'},
                        '4': {color: '#1890FF', textColor: '#fff'}
                    }
                }
            },

            handleChangeFloor: function () {
                this.searchListForm.roomIds = '';
                this.searchMonth();
            },

            handleChangeRoom: function (room) {
                this.searchMonth();
            },


            handleChangeBuilding: function () {
                this.searchListForm.floorId = '';
                this.searchListForm.roomIds = '';
                this.searchMonth();
            },

            handleChangeRoomType: function () {
                this.searchMonth();
            },

            handleChangeStatus: function () {
                this.searchMonth();
            },

            changeCalendarEventList: function (list) {
                var eventColors = this.fullCalendarOption.eventColors;
                list.map(function (item) {
                    var colorTypes = eventColors[(item.state)];
                    for (var k in colorTypes) {
                        if (colorTypes.hasOwnProperty(k)) {
                            item[k] = colorTypes[k];
                        }
                    }
                    return item;
                })
                this.fullCalendar.fullCalendar('removeEvents');
                this.fullCalendar.fullCalendar('addEventSource', list)

            },

            getSpaceList: function () {
                var self = this;
                return this.$axios.get('/pw/pwSpace/treeData').then(function (response) {
                    self.pwSpaceList = response.data;
                }).catch(function (e) {
                })
            }
        },
        beforeMount: function () {
            this.getSpaceList();
        },
        created: function () {
            this.fullCalendarOption = this.getFullCalendarOption();
            this.fullCalendarLoad = true;
        }
    })
</script>

</body>
</html>