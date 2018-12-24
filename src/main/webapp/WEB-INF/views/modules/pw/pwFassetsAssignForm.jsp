<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
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

<div id="assetsAssignForm" class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>固定资产</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
        <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <div class="content_panel">
        <ul class="nav nav-tabs">
            <li><a href="${ctx}/pw/pwFassets/">固定资产列表</a></li>
            <li class="active"><a href="">固定资产分配</a></li>
        </ul>
        <sys:message content="${message}"/>
        <form:form id="inputForm" modelAttribute="pwFassetsAssign" action="${ctx}/pw/pwFassets/assign" method="post"
                   class="form-horizontal">
            <input type="hidden" id="secondName" name="secondName"value="${secondName}"/>
            <form:hidden path="fassetsIds" value="${fassetsIds}"/>
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
                    <select name="roomId" v-model="roomId" @change="getEnterList" class="required">
                        <option value="">-请选择-</option>
                        <option v-for="item in rooms" :key="item.id" :value="item.id">{{item.name}}</option>
                    </select>
                </div>
            </div>
            <%--<div class="control-group">--%>
                <%--<label class="control-label"><i>*</i>房间：</label>--%>
                <%--<div class="controls">--%>
                    <%--<sys:treeselectFloor id="parent" name="roomId" value="${pwRoom.pwSpace.id}" labelName="pwSpace.name"--%>
                                         <%--labelValue="${pwRoom.pwSpace.name}"--%>
                                         <%--title="房间" url="/pw/pwRoom/roomTreeData" extId="${pwRoom.pwSpace.id}"--%>
                                         <%--cssClass="required" isAll="true"--%>
                                         <%--allowClear="true" notAllowSelectRoot="true" notAllowSelectParent="true"--%>
                                         <%--cssStyle="width: 175px;"/>--%>
                <%--</div>--%>
            <%--</div>--%>
            <div class="control-group">
                <label class="control-label"><i>*</i>使用人：</label>
                <div class="controls">
                    <form:input path="respName" class="required"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">手机号：</label>
                <div class="controls">
                    <form:input path="respMobile" class="phone_number"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">资产列表</label>
                <div class="controls">
                    <table class="table table-bordered table-condensed table-hover table-center table-orange table-sort table-nowrap table-subscribe">
                        <thead>
                        <tr>
                            <th>序号</th>
                            <th>编号</th>
                            <th>资产类型</th>
                            <th>资产名称</th>
                            <th>品牌型号</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${list}" var="pwFassets" varStatus="status">
                            <tr>
                                <td>
                                        ${ status.index + 1}
                                </td>
                                <td>
                                        ${pwFassets.name}
                                </td>
                                <td>
                                        ${pwFassets.pwCategory.parent.name}
                                </td>
                                <td>
                                        ${pwFassets.pwCategory.name}
                                </td>
                                <td>
                                        ${pwFassets.brand}
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="form-actions">
                <shiro:hasPermission name="pw:pwFassets:edit">
                    <button type="submit" class="btn btn-primary">保 存</button>
                </shiro:hasPermission>
                <button type="button" class="btn btn-default" onclick="history.go(-1)">返 回</button>
            </div>

        </form:form>
    </div>
</div>
<script>
    +function ($) {
        var assetsAssignForm = new Vue({
            el: '#assetsAssignForm',
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
                    roomId: '${pwRoom.pwSpace.id}',
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
                    xhr = $.get('${ctx}/pw/pwRoom/jsonList?pwSpace.id=' + this.floorId);
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