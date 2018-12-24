<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <%@include file="/WEB-INF/views/include/treetable.jsp" %>
    <script type="text/javascript" src="${ctxStatic}/vue/vue.min.js"></script>
    <style>
        .card-ui-item .input-append .add-on {
            height: 24px;
            line-height: 14px;
            box-sizing: border-box;
        }

        .card-page-wrapper .assigned-room_info > span {
            padding: 0 10px;
        }

        .card-page-wrapper .assigned-room_info > span + span {
            border-left: 1px solid #ddd;
        }

        .card-page-wrapper .assigned-room_info > span:first-child {
            padding-left: 0;
        }

        .table-room_authorization .checkbox {
            font-size: 12px;
            padding-top: 0;

        }

        .table-room_authorization .door-all_check {
            margin-left: 8px;
        }

        .table-room_authorization.tree_table .default_node, .table-room_authorization.tree_table .default_active_node {
            vertical-align: middle;
        }

        .table-room_authorization .room-inline {
            display: inline-block;
            vertical-align: middle;
            width: 25%;
            min-width: 160px;
            text-align: left;
        }

        .table-room_authorization .door-status {
            margin-left: 8px;
            color: #e9432d;
            line-height: 20px;
            vertical-align: middle;
        }
    </style>
</head>
<body>
<div id="doorCard" class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>门禁卡</span> <i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
        <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <div class="card-page-wrapper mgb-20">
        <form id="drCardForm" v-validate-form="{form: 'drCardForm'}" autocomplete="off" method="post" action="#">
            <div class="titlebar_column">
                <span v-show="isLoad" style="display: none" class="name">{{user.id ? '入驻人信息' : '个人信息'}}</span>
            </div>
            <input type="hidden" name="secondName" id="secondName" value="${secondName}"/>
            <temporary-card v-if="!user.id" v-model="tempUser"></temporary-card>
            <common-card v-if="user.id" :rooms="rooms"></common-card>
            <div class="titlebar_column">
                <span class="name">发卡信息</span>
            </div>
            <div class="card-col-con">
                <div class="card-info">
                    <div class="card-inf-item">
                        <label><i>*</i>卡号：</label>
                        <input type="text" name="no" class="input-medium digits required" v-model="no" :disabled="!!cardId"
                               maxlength="10"
                               minlength="4">
                    </div>
                    <div class="card-inf-item">
                        <label>有效期：</label>
                        <input type="text" name="expiry" readonly class="input-medium Wdate" v-model="expiry"
                               @click="showExpiryDate($event)">
                    </div>
                    <%--<div class="card-inf-item">--%>
                    <%--<label><i>*</i>初始密码：</label>--%>
                    <%--<input type="text" name="password" class="input-medium digits required" maxlength="6"--%>
                    <%--minlength="6" autocomplete="new-password" spellcheck="false"--%>
                    <%--oninput="if(this.value==''){this.type='text'}else(this.type='password')">--%>
                    <%--<span class="help-inline">请设置初始6位数密码</span>--%>
                    <%--</div>--%>
                    <%--<div class="card-inf-item">--%>
                    <%--<label>卡状态：</label>--%>
                    <%--<select class="input-medium" name="status" v-model="status" disabled>--%>
                    <%--<option value="">-请选择-</option>--%>
                    <%--<option v-for="status in drCstatuss" :value="status.key">{{status.name}}</option>--%>
                    <%--</select>--%>
                    <%--</div>--%>
                </div>
            </div>
            <div class="titlebar_column">
                <span class="name">授权其它房间使用权限</span>
            </div>
            <div class="card-col-con">

                <table v-tree-table style="display: none"
                       class="table table-bordered table-condensed table-hover table-orange table-nowrap table-center table-room_authorization">
                    <thead>
                    <tr>
                        <th class="text-left" width="240">可使用场地</th>
                        <th>门禁</th>
                        <%--<th width="186">操作</th>--%>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="(space, index) in pwSpaceList" :id="space.sid" :pId="space.pid == '1' ? 0 : space.pid">
                        <td class="text-left door-all_check">
                            <label class="checkbox inline">
                                <input type="checkbox"
                                <%--:disabled="space.disabled"--%>
                                       :name="'doorAll'+ index"
                                       v-model="space.allChecked"
                                       value="1"
                                       @change.stop="checkedAll(space, $event)">{{space.sname}}
                            </label>
                        </td>
                        <td>
                            <div v-for="(door, index2) in space.doors" class="room-inline">
                                <label class="checkbox inline">
                                    <input type="checkbox" :name="'door'+index+index2"
                                    <%--:disabled="door.disabled"--%>
                                           v-model="space.doorsChecked"
                                           :value="door.eptId + ',' + door.eptNo + ',' + door.drNo">{{door.dname
                                    || '门'}}
                                </label>
                                <span v-if="door.selStatus == 1" class="door-status dealId">
                                    授权中
                                </span>
                                <span class="door-status" v-if="door.selStatus == 2">
                                    授权失败
                                </span>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </form>
    </div>
    <div class="text-center mgb-20" v-show="isLoad" style="display: none">
        <button type="submit" :disabled="isSaving" class="btn btn-primary disBtn" @click.stop="activeCard">
            {{isSaving ? '发卡中...' : '发卡'}}
        </button>
        <c:if test="${not empty user.id}">
            <button type="button" :disabled="isSaving" class="btn btn-default"
                    onclick="location.href='${ctx}/dr/drCard/listByUser'">返回
            </button>
        </c:if>
        <c:if test="${empty user.id}">
            <button type="button" :disabled="isSaving" class="btn btn-default"
                    onclick="location.href='${ctx}/dr/drCard/listByTemp'">返回
            </button>
        </c:if>
    </div>
</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>



<script type="text/x-template" id="temporary-card-template">
    <div class="card-col-con">
        <div class="card-user_info">
            <div class="card-ui-item">
                <label><i>*</i>姓名：</label>
                <input type="text" name="name" maxlength="10" minlength="2" v-model="tempUser.name"
                       class="input-medium required">
            </div>
            <div class="card-ui-item">
                <label><i>*</i>手机号：</label>
                <input type="text" name="phone" v-model="tempUser.phone" class="input-medium phone_number required">
            </div>
            <div class="card-ui-item">
                <label>工号/学号：</label>
                <input type="text" name="phone" v-model="tempUser.no" maxlength="64" class="input-medium letterNumber">
            </div>
        </div>
    </div>
</script>

<script type="text/x-template" id="common-card-template">
    <div class="card-col-con">
        <div class="card-user_info">
            <div class="card-ui-item">
                <label>姓名：</label>
                <span> ${user.name}</span>
            </div>
            <div class="card-ui-item">
                <label>学号：</label><span>${user.no}</span>
            </div>
            <div class="card-ui-item">
                <label> 所属学院：</label><span>${user.office.name}</span>
            </div>
            <div class="card-ui-item">
                <label>入驻类型：</label><span>${pwEnterInfo.enterTypeStr}</span>
            </div>
            <div class="card-ui-item">
                <label> 入驻有效期：</label><span>${pwEnterInfo.enterEndTime}</span>
            </div>
        </div>
        <p class="assigned-room_info">已分配的房间：
            <span v-for="room in rooms">
                {{room.roomFullName}}
            </span>
        </p>
    </div>
</script>

<script type="text/javascript">
    +function ($, Vue) {
        var pwSpaceList = '${fns: toJson(pwSpaceInfo)}' || '[]';
        var drCstatuss = '${drCstatuss}' || '[]';
        var rooms = '${fns: toJson(pwEnterInfo.rooms)}' || '[]';
        var doorCard;

        var commonCard = Vue.component('common-card', {
            template: '#common-card-template',
            props: {
                rooms: {
                    type: Array,
                    default: function () {
                        return []
                    }
                }
            }
        })

        var temporaryCard = Vue.component('temporary-card', {
            template: '#temporary-card-template',
            model: {
                prop: 'tempUser',
                event: 'change'
            },
            props: {
                tempUser: {
                    type: Object,
                    default: {
                        name: '',
                        phone: '',
                        no: ''
                    }
                }
            },
            data: function () {
                return {}
            },
            mounted: function () {
            }

        })



        doorCard = new Vue({
            el: '#doorCard',
            data: function () {
                return {
                    cardId: '${drCard.id}',
                    no: '${drCard.no}',
                    expiry: '<fmt:formatDate value="${drCard.expiry}" pattern="yyyy-MM-dd"/>',
                    status: '${drCard.status}',
                    pwSpaceList: JSON.parse(pwSpaceList),
                    drCstatuss: JSON.parse(drCstatuss),
                    rooms: JSON.parse(rooms),
                    spaceList: [],
                    spaceAllSubs: {},
                    drCardForm: '',
                    isSaving: false,
                    isLoad: false,
                    tempUser: {
                        name: '${drCard.tmpName}',
                        phone: '${drCard.tmpTel}',
                        no: '${drCard.tmpNo}'
                    },
                    user: {
                        id: '${user.id}'
                    },
                    isProcessing: false,
                    tickTimer: null
                }
            },

            directives: {
                treeTable: {
                    inserted: function (element, binding, vnode) {
                        $(element).treeTable({expandLevel: 10}).show();
                    }
                },
                validateForm: function (element, binding, vnode) {

                    vnode.context[binding.value.form] = $(element).validate({
                        rules: {
                            no: {
                                remote: {
                                    url: '/a/dr/drCard/checkCardNo',
                                    type: "post",               //数据发送方式
                                    dataType: "json",
                                    data: {
                                        cardno: function () {
                                            return vnode.context.no
                                        },
                                        cardid: '${drCard.id}'
                                    }
                                }
                            }
                        },
                        messages: {
                            no: {
                                remote: '卡号已经存在',
                            },
                            password: {
                                digits: '请输入六位数字密码'
                            }
                        }
                    })
                }
            },
            methods: {

                showExpiryDate: function ($event) {
                    var self = this;
                    WdatePicker({
                        el: $event.target,
                        dateFmt: 'yyyy-MM-dd',
                        minDate:'%y-%M-{%d+1}',
                        isShowClear: true,
                        onpicked: function (e) {
                            self.expiry = $event.target.value;
                        },
                        oncleared: function () {
                            self.expiry = '';
                        }
                    })

                },

                lockAssignedRoom: function () {
                    var rooms = this.rooms;
                    var pwSpaceList = this.pwSpaceList;
                    for (var i = 0; i < rooms.length; i++) {
                        var room = rooms[i];
                        for (var s = 0; s < pwSpaceList.length; s++) {
                            var pwSpace = pwSpaceList[s];
                            if (room.roomId === pwSpace.sid) {
                                pwSpace.disabled = true;
                                pwSpace.allChecked = 1;
                                this.checkedSpace(pwSpace.pid);
                                var doors = pwSpace.doors;
                                for (var d = 0; d < doors.length; d++) {
                                    var door = doors[d];
                                    door.disabled = true;
                                    pwSpace.doorsChecked.push(door.eptId + ',' + door.eptNo + ',' + door.drNo)
                                }
                                break;
                            }
                        }
                    }

                },

                checkedSpace: function (parentId) {
                    var pwSpaceList = this.pwSpaceList;
                    for (var s = 0; s < pwSpaceList.length; s++) {
                        var pwSpace = pwSpaceList[s];
                        if (pwSpace.sid === parentId) {
                            pwSpace.allChecked = 1;
                            if (pwSpace.type > 3) {
                                this.checkedSpace(pwSpace.pid)
                            }
                            break;
                        }
                    }

                },


                extendPwSpaceList: function () {
                    var pwSpaceList = this.pwSpaceList;
                    for (var i = 0; i < pwSpaceList.length; i++) {
                        var pwSpace = pwSpaceList[i];
                        var doors = pwSpace.doors;
                        Vue.set(pwSpace, 'doorsChecked', []);
                        Vue.set(pwSpace, 'allChecked', 0);
                        Vue.set(pwSpace, 'disabled', false);
                        for (var d = 0; d < doors.length; d++) {
                            if (doors[d].sel == '1') {
                                var door = doors[d];
                                pwSpace.allChecked = '1';
                                pwSpace.doorsChecked.push(door.eptId + ',' + door.eptNo + ',' + door.drNo);
                                Vue.set(doors[d], 'disabled', false);
                            }
                        }
                    }
                },

                formatTreeList: function (rootId) {
                    var list = this.pwSpaceList;
                    for (var i = 0; i < list.length; i++) {
                        var item = list[i];
                        if (item.pid === rootId) {
                            this.spaceList.push(item);
                            this.formatTreeList(item.sid);
                        }
                    }
                },

                setPwSpaceList: function () {
                    this.formatTreeList('1');
                    this.pwSpaceList = this.spaceList;
                },


                formatRes: function (res) {
                    var sortArr = [];

                    function getList(rootId) {
                        var list = res;
                        for (var i = 0; i < list.length; i++) {
                            var item = list[i];
                            if (item.pid === rootId) {
                                sortArr.push(item);
                                getList(item.sid);
                            }
                        }
                    }

                    getList('1');
                    return sortArr;

                },

                checkedAll: function (space) {
                    var doors = space.doors;
                    var spaceRootId = space.sid;
                    var spaceAllSubs;
                    this.controlsDoors(doors, space, space.allChecked);
                    if (!this.spaceAllSubs[spaceRootId]) {
                        this.getAllChildren(space.sid, spaceRootId);
                    }
                    spaceAllSubs = this.spaceAllSubs[spaceRootId];
                    for (var k in spaceAllSubs) {
                        if (spaceAllSubs.hasOwnProperty(k)) {
                            var subSpace = spaceAllSubs[k];
                            this.controlsDoors(subSpace.doors, subSpace, space.allChecked);
                            this.controlSpace(subSpace, space.allChecked)
                        }
                    }
                },

                getAllChildren: function (rootId, spaceRootId) {
                    var spaceList = this.pwSpaceList;
                    for (var i = 0; i < spaceList.length; i++) {
                        var space = spaceList[i];
                        if (space.pid === rootId) {
                            if (!this.spaceAllSubs[spaceRootId]) {
                                this.spaceAllSubs[spaceRootId] = [];
                            }
                            if (!new RegExp(space.sid).test(this.spaceAllSubs[spaceRootId].join(','))) {
                                this.spaceAllSubs[spaceRootId].push(space);
                                this.getAllChildren(space.sid, spaceRootId)
                            }
                        }
                    }
                },

                controlsDoors: function (doors, space, checked) {
                    var spaceStr = space.doorsChecked.join('|');
                    for (var i = 0; i < doors.length; i++) {
                        var door = doors[i];
                        if (checked == '0') {
//                            if (door.disabled) {
//                                continue;
//                            }
                            space.doorsChecked = [];
                        } else {
                            if (new RegExp(door.eptId + ',' + door.eptNo + ',' + door.drNo).test(spaceStr)) {
                                continue;
                            }
                            space.doorsChecked.push(door.eptId + ',' + door.eptNo + ',' + door.drNo);
                        }
                    }
                },

                controlSpace: function (space, status) {
//                    if (!space.disabled) {
//                        space.allChecked = status;
//                    }
                    space.allChecked = status;
                },

                getCardData: function () {
                    var data = {
                        id: this.cardId,
                        no: this.no,
                        status: this.status,
                        password: '',
                        user: this.user,
                        cardType: this.user.id ? '1' : '0',
                        tmpName: this.tempUser.name,
                        tmpTel: this.tempUser.phone,
                        tmpNo: this.tempUser.no,
                        expiry: this.expiry,
                        drEmentNos: []
                    };
                    var drEmentNos = [];

                    for (var i = 0; i < this.pwSpaceList.length; i++) {
                        var pwSpace = this.pwSpaceList[i];
                        var doorsChecked = pwSpace.doorsChecked;
                        if (!doorsChecked || doorsChecked.length < 1) {
                            continue;
                        }
                        for (var d = 0; d < doorsChecked.length; d++) {
                            var door = doorsChecked[d].split(',');
                            drEmentNos.push({
                                etId: door[0],
                                etNo: door[1],
                                drNo: door[2]
                            })
                        }
                    }
                    data.drEmentNos = drEmentNos;
                    return data;
                },

                activeCard: function () {
                    var postData = {list: []};
                    var self = this;
                    var cardData;
                    if (!this.drCardForm.form()) {
                        return false;
                    }
                    cardData = this.getCardData();
                    if(cardData.drEmentNos.length < 1){
                        dialogCyjd.createDialog(0, '请勾选门禁');
                        return false;
                    }
                    this.isSaving = true;
                    postData.list.push(cardData);
                    $.ajax({
                        type: 'POST',
                        url: '/a/dr/drCard/ajaxCardPublishPl',
                        data: JSON.stringify(postData),
                        contentType: "application/json; charset=utf-8",
                        success: function (data) {
                            self.isSaving = false;
                            if (data.status && !self.cardId) {
                                self.cardId = data.datas[0];
                            }
//                            self.getCardDoors();
                            if (data.status) {
                                dialogCyjd.createDialog(1, data.msg, {
                                    dialogClass: 'dialog-cyjd-container none-close',
                                    buttons: [{
                                        'text': '确定',
                                        'class': 'btn btn-primary',
                                        'click': function () {
                                            $(this).dialog('close');
                                            var hash = location.hash;
                                            if(!hash){
                                                location.href = '/a/dr/drCard/form?id=' + self.cardId + '&user.id='+'${user.id}'+ '#time';
                                                return false;
                                            }
                                            location.reload();
                                        }
                                    }]
                                });
                                return false;
                            }
                            dialogCyjd.createDialog(0, data.msg)
                        },
                        error: function (err) {
                            self.isSaving = false;
                            dialogCyjd.createDialog(0, '网络连接失败，请重试')
                        }
                    })
                },

                getCardDoors: function () {
                    var self = this;
                    $.ajax({
                        type: 'GET',
                        url: '/a/dr/drCard/getCardData',
                        data: {
                            id: this.cardId
                        },
                        success: function (res) {
                            self.isProcessing = false;

                            for (var k in res) {
                                if (!res.hasOwnProperty(k)) {
                                    continue;
                                }
                                var value = res[k];
                                for (var i = 0; i < self.pwSpaceList.length; i++) {
                                    var doors = self.pwSpaceList[i].doors;
                                    if (doors.length < 1) {
                                        continue;
                                    }
                                    for (var d = 0; d < doors.length; d++) {
                                        var door = doors[d];
                                        if (door.eptId + ',' + door.eptNo + ',' + door.drNo === k) {
                                            door.selStatus = value;
                                            if (door.selStatus === '1') {
                                                self.isProcessing = true;
                                            }
                                        }
                                    }
                                }
                            }

                            if (!self.isProcessing) {
                                clearInterval(self.tickTimer);
                            }
                        },
                        error: function () {}
                    });
                },

                getHash: function () {
                    var hash = location.hash;
                    if (!hash) {
                        return;
                    }
                    this.tick(this.getCardDoors)
                },

                tick: function (fn) {
                    this.tickTimer = setInterval(function () {
                        fn && fn();
                    }, '5000')

                }


            },
            beforeMount: function () {
                this.extendPwSpaceList();
                this.lockAssignedRoom();
                this.setPwSpaceList();
                this.getHash();
                this.isLoad = true;
            },
            mounted: function () {
            }
        });

    }(jQuery, Vue);

    var dealdisTimer;
    $(function() {
        var dealdom = ".dealId";
        var dealdisdom = ".disBtn";

        dealdisTimer = setInterval(function() {
            $(dealdisdom).prop("disabled", false);
        }, '${drDealBtnTimerMax/4}')
    });

    /* function initdis(doms, btnDoms) {
        if (($(doms).length > 0)) {
            $(btnDoms).attr("disabled", true);
        }

        $(btnDoms).click(function(){
            $(btnDoms).attr("disabled", true);
        });
    } */
</script>
</body>
</html>