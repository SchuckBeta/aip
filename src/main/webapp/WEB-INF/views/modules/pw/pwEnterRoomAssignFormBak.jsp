<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>固定资产管理</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript" src="${ctxStatic}/vue/vue.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#inputForm").validate({
                rules: {
                    'pwSpace.name': 'required'
                },
                messages: {
                    'pwSpace.name': {
                        required: '必填信息'
                    }
                },
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox") || element.is(":radio")) {
                        error.appendTo(element.parent().parent());
                    } else if (element.attr('name') === 'pwSpace.name') {
                        error.appendTo(element.parent())
                    } else {
                        error.insertAfter(element);

                    }
                }
            });
        });
    </script>
</head>
<body>

<div id="roomDefined" class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>入驻场地分配</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <div class="content_panel">
        <sys:message content="${message}"/>
        <form:form id="inputForm" modelAttribute="pwEnterRoom" action="${ctx}/pw/pwEnterRoom/assignRoom" method="post"
                   class="form-horizontal">

            <form:hidden path="pwEnter.id" value="${pwEnterRoom.pwEnter.id}"/>
            <input type="hidden" id="secondName" name="secondName"value="${secondName}"/>

           期望工位数: ${pwEnterRoom.pwEnter.expectWorkNum }
     期望入孵时间,单位：年:       ${pwEnterRoom.pwEnter.expectTerm }
     申请 场地 备注:       ${pwEnterRoom.pwEnter.expectRemark }


            <div class="control-group">
                <label class="control-label">入驻编号：</label>
                <div class="controls">
                    <p class="control-static">${pwEnterRoom.pwEnter.no}</p>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">入驻类型：</label>
                <div class="controls">
                    <p class="control-static">
                        <c:if test="${not empty pwEnterRoom.pwEnter.eteam}"> <span
                                class="bd1 mlr5"> ${fns:getDictLabel(pwEnterRoom.pwEnter.eteam.type, 'pw_enter_type', '')} </span> </c:if>
                       <%--  <c:if test="${not empty pwEnterRoom.pwEnter.eproject}"> <span
                                class="bd1 mlr5"> ${fns:getDictLabel(pwEnterRoom.pwEnter.eproject.type, 'pw_enter_type', '')} </span> </c:if> --%>
                        <c:if test="${not empty pwEnterRoom.pwEnter.ecompany}"> <span
                                class="bd1 mlr5"> ${fns:getDictLabel(pwEnterRoom.pwEnter.ecompany.type, 'pw_enter_type', '')} </span> </c:if>
                    </p>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">负责人：</label>
                <div class="controls">
                    <p class="control-static">${pwEnterRoom.pwEnter.applicant.name}</p>
                </div>
            </div>
            <div class="control-group" v-show="hasCampus">
                <label class="control-label">校区：</label>
                <div class="controls">
                    <select name="campuses" v-model="campusId" @change="changeCampus">
                        <option value="">-请选择-</option>
                        <option v-for="item in campuses" :key="item.id" :value="item.id">{{item.name}}</option>
                    </select>
                </div>
            </div>
            <div class="control-group" v-show="hasBase">
                <label class="control-label">基地：</label>
                <div class="controls">
                    <select name="base" v-model="baseId" @change="changeBase">
                        <option value="">-请选择-</option>
                        <option v-for="item in bases" :key="item.id" :value="item.id">{{item.name}}</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><i>*</i>楼栋：</label>
                <div class="controls">
                    <select name="building" v-model="buildingId" @change="changeBuilding" class="required">
                        <option value="">-请选择-</option>
                        <option v-for="item in buildings" :key="item.id" :value="item.id">{{item.name}}</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><i>*</i>楼层：</label>
                <div class="controls">
                    <select name="floor" v-model="floorId" @change="changeFloor" class="required">
                        <option value="">-请选择-</option>
                        <option v-for="item in floors" :key="item.id" :value="item.id">{{item.name}}</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><i>*</i>房间：</label>
                <div class="controls">
                    <select name="pwRoom.id" v-model="roomId" @change="getEnterList" class="required">
                        <option value="">-请选择-</option>
                        <option v-for="item in rooms" :key="item.id" :value="item.id">{{item.name}}</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">已入驻列表：</label>
                <div class="controls">
                    <table id="assignedTable"
                           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap table-assigned">
                        <thead>
                        <tr>
                            <td>入驻编号</td>
                            <td>团队</td>
                            <td>企业</td>
                            <td>项目</td>
                            <td>负责人</td>
                            <td>入驻有效期</td>
                        </tr>
                        </thead>
                        <tbody>
                        <tr v-for="(item, index) in enterList">
                            <td>{{item.no}}</td>
                            <td>{{item.eteam ? item.eteam.team.name : '-'}}</td>
                            <td>{{item.ecompany ? item.ecompany.pwCompany.name : '-'}}</td>
                            <td>{{item.eproject ? item.eproject.project.name : '-'}}</td>
                            <td>{{item.applicant ? item.applicant.name : '无负责人'}}</td>
                            <td>{{item.endDate ? item.endDate : '-'}}</td>
                        </tr>
                        <tr v-if="!enterList.length">
                            <td colspan="6">没有已入驻的信息</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="form-actions">
                <shiro:hasPermission name="pw:pwFassets:edit">
                    <button type="submit" class="btn btn-primary">分配</button>
                </shiro:hasPermission>
                <button type="button" class="btn btn-default" onclick="history.go(-1)">返 回</button>
            </div>
        </form:form>
    </div>
</div>
<script>
    +function ($) {
        var roomDefined = new Vue({
            el: '#roomDefined',
            data: function () {
                return {
                    treeObj: {},
                    tree: [],
                    campuses: [],
                    bases: [],
                    buildings: [],
                    floors: [],
                    campusesClone: [],
                    basesClone: [],
                    buildingsClone: [],
                    campusId: '',
                    baseId: '',
                    buildingId: '',
                    floorId: '${pwRoom.pwSpace.id}',
                    roomType: '${pwRoom.pwSpace.type}',
                    hasCampus: false,
                    hasBase: false,
                    floorName: [],
                    isLoad: false,
                    rooms: [],
                    roomId: '',
                    enterList: [],

                }
            },
            computed: {
                floorNameStr: function () {
                    return this.floorName.reverse().join(' / ')
                }
            },
            methods: {
                changeCampus: function () {
                    if (!this.campusId) {
                        this.bases = this.basesClone.slice(0);
                        this.buildings = this.buildingsClone.slice(0);
                    } else {
                        this.bases = this.getChildrenByParentId(this.campusId, '2');
                        this.buildings = this.getChildrenByParentId(this.campusId, '3');
                    }
                    this.floors.length = 0;
                    this.baseId = '';
                    this.buildingId = '';
                    this.floorId = '';
                    this.roomId = '';
                    this.rooms.length = 0;
                },
                changeBase: function () {
                    var parentId, campus;
                    if (!this.baseId) {
                        this.buildings = this.buildingsClone.slice(0);
                    } else {
                        this.buildings = this.getChildrenByParentId(this.baseId, '3');
                        parentId = this.getObjById(this.baseId).parentId;
                        campus = this.getObjById(parentId);
                        this.campusId = campus.id || '';
                    }
                    this.floors.length = 0;
                    this.rooms.length = 0;
                    this.buildingId = '';
                    this.floorId = '';
                    this.roomId = '';
                },

                changeBuilding: function () {
                    var parentId, base, campus;
                    this.floors = this.getChildrenByParentId(this.buildingId, '4');
                    this.floorId = '';
                    this.rooms.length = 0;
                    this.roomId = '';
                    if (this.buildingId) {
                        parentId = this.getObjById(this.buildingId).parentId;
                        base = this.getObjById(parentId);
                        if(base.type === '1'){
                            this.campusId = parentId || '';
                            this.baseId = '';
                        }else if(base.type === '2'){
                            this.baseId = parentId || '';
                            if (!this.baseId) {
                                this.campusId = '';
                                return false;
                            }
                            parentId = this.getObjById(this.baseId).parentId;
                            campus = this.getObjById(parentId);
                            this.campusId = campus.id || '';
                        }
                    }else {

                    }
                },

                getEnterList: function () {
                    var self = this;
                    var xhr;
                    if (!this.roomId) {
                        this.enterList.length = 0;
                        return
                    }
                    xhr = $.post('${ctx}/pw/pwRoom/roomEnters?id=' + this.roomId);
                    xhr.success(function (data) {
                        self.enterList = data.enters;
                    })

                },

                changeFloor: function () {
                    var self = this;
                    var xhr;
                    this.roomId = '';
                    if (!this.floorId) {
                        this.rooms.length = 0;
                        return false;
                    }
                    xhr = $.get('${ctx}/pw/pwRoom/jsonList?isAssign=1&pwSpace.id=' + this.floorId);
                    xhr.success(function (data) {
                        self.rooms = data;
                    })
                },

                getTree: function () {
                    var self = this;
                    var xhr = $.get('${ctx}/pw/pwSpace/allSpaces');
                    xhr.success(function (data) {
                        self.campuses = data.campuses;
                        self.bases = data.bases;
                        self.buildings = data.buildings;
                        self.floors = data.floors;
                        self.hasCampus = self.campuses.length > 0;
                        self.hasBase = self.bases.length > 0;
                        self.tree = self.campuses.concat(self.bases, self.buildings, self.floors).slice(0);
                        self.treeObj = data;
                        self.campusesClone = self.campuses.slice(0);
                        self.buildingsClone = self.buildings.slice(0);
                        self.basesClone = self.bases.slice(0)
                    });
                    return xhr;
                },
                getObjById: function (id) {
                    var floor = {};
                    $.each(this.tree, function (i, t) {
                        if (t.id === id) {
                            floor = t;
                            return false;
                        }
                    });
                    return floor;
                },
                getChildrenByParentId: function (id, type) {
                    var arr = [];
                    if (!id) {
                        return arr;
                    }
                    $.each(this.tree, function (i, t) {
                        if (t.parentId === id && t.type === type) {
                            arr.push(t);
                        }
                    });
                    return arr;
                }
            },
            beforeMount: function () {
                var self = this;
                this.getTree().then(function () {
                    self.floors.length = 0;
                });
            },
            mounted: function () {

            }
        })
    }(jQuery)
</script>
</body>
</html>