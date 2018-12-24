<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script src="${ctxStatic}/vue/vue.min.js"></script>
    <style>
        .gary-color {
            color: #c5c5c5;
        }

        .floor-image-box {
            background-position: center;
            background-size: cover;
        }
    </style>
</head>
<body>
<div id="pwDesinger" class="container-fluid">
    <div class="edit-bar clearfix">
        <div class="edit-bar-left">
            <span>基地全局图预览</span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <div class="form-inline form-appointment">
        <div class="cate-attrs" v-show="bases.length > 0" style="display: none;">
            <div class="cate-attr-key"><span>基地</span></div>
            <div class="cate-attr-value">
                <ul class="av-collapse" style="padding-left: 0">
                    <%--<li class="av-item av-item-all">--%>
                    <%--<div class="ac-item-box"><input type="radio" name="base" value="" v-model="baseId"--%>
                    <%--@change="changeBase({}, $event)">--%>
                    <%--<label class="avi-label">不限</label></div>--%>
                    <%--</li>--%>
                    <li class="av-item" v-for="item in bases" :key="item.id">
                        <div class="ac-item-box"><input type="radio" name="base" v-model="baseId" :value="item.id"
                                                        @change="changeBase(item, $event)">
                            <label class="avi-label">{{item.name}}</label></div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="cate-attrs" v-show="buildings.length > 0" style="display: none;">
            <div class="cate-attr-key"><span>楼栋</span></div>
            <div class="cate-attr-value">
                <ul class="av-collapse" style="padding-left: 0">
                    <%--<li class="av-item av-item-all">--%>
                    <%--<div class="ac-item-box"><input type="radio" name="building" value="" v-model="buildingId"--%>
                    <%--@change="changeBuilding({}, $event)">--%>
                    <%--<label class="avi-label">不限</label></div>--%>
                    <%--</li>--%>
                    <li class="av-item" v-for="item in buildings" :key="item.id">
                        <div class="ac-item-box"><input type="radio" name="building" v-model="buildingId"
                                                        :value="item.id" @change="changeBuilding(item, $event)">
                            <label class="avi-label"
                                   :class="{'gary-color': !(new RegExp(item.id).test(baseContainBuild))}">{{item.name}}</label>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="cate-attrs" v-show="buildings.length > 0" style="display: none;">
            <div class="cate-attr-key"><span>楼层</span></div>
            <div class="cate-attr-value" style="min-height: 32px;">
                <ul class="av-collapse" style="padding-left: 0">
                    <%--<li class="av-item av-item-all">--%>
                    <%--<div class="ac-item-box"><input type="radio" name="floor" v-model="floorId" value=""--%>
                    <%--@change="changeFloor(item, $event)">--%>
                    <%--<label class="avi-label">不限</label></div>--%>
                    <%--</li>--%>
                    <li class="av-item" v-for="item in floors" :key="item.id">
                        <div class="ac-item-box"><input type="radio" name="floor" v-model="floorId" :value="item.id"
                                                        @change="changeFloor(item, $event)">
                            <label class="avi-label">{{item.name}}</label></div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <hr v-show="buildings.length > 0 || bases.length > 0" style="display: none"/>
    <%--<h3 class="text-center">{{title}}</h3>--%>
    <div class="designer-box" style="max-width: 1000px; margin: 0 auto 40px;">
        <a href="javascript:void(0);" @click="choosePic"><img v-show="!floorImage.show" class="designer-image"
                                                              :src="imgUrl | imgFtp"></a>
        <div v-show="floorImage.show" class="floor-image-box" style="display: none"
             :style="{backgroundColor: floorImage.backgroundColor, backgroundImage: 'url('+floorImage.backgroundUrl+')'}">
            <img :src="floorImage.imageUrl">
        </div>
    </div>
</div>
<script type="text/javascript">
    +function ($) {
        var pwDesigner = new Vue({
            el: '#pwDesinger',
            data: function () {
                return {
                    bases: (JSON.parse('${fns:toJson(bases)}') || []),
                    buildings: (JSON.parse('${fns:toJson(buildings)}') || []),
                    floors: [],
                    title: '什么什么预览图',
                    baseId: '',
                    buildingId: '',
                    floorId: '',
                    imgUrl: '',
                    ftpHttp: ftpHttp,
                    baseContainBuild: '',
                    floorImage: {
                        backgroundUrl: '',
                        backgroundColor: '',
                        imageUrl: '',
                        show: false
                    }
                }
            },
            filters: {
                imgFtp: function (val) {
                    if (val) {
                        return this.ftpHttp + val.replace('/tool', '')
                    }
                    //默认图片
                    return '/images/floorViewDefault2.jpg';
                }
            },
            methods: {
                choosePic: function () {
                    var baseContainBuild = this.baseContainBuild;
                    if (this.floorId) {
                        return false;
                    }
                    if (this.buildingId) {
                        if (this.floors.length > 0) {
                            this.floorId = this.floors[0].id;
                            this.changeFloor(this.floors[0])
                        }
                        return false;
                    }
                    if (this.baseId) {
                        baseContainBuild = baseContainBuild ? baseContainBuild.split(',') : [];
                        if (baseContainBuild.length > 0) {
                            this.buildingId = baseContainBuild[0];
                            this.changeBuilding({id: baseContainBuild[0]});
                        }
                        return false;
                    }
                },

                //改变基地
                changeBase: function (base, $event) {
                    var xhr, self = this;
                    if (!base.id) {
                        this.buildingId = '';
                        this.floorId = '';
                        this.floors.length = 0;
                        this.imgUrl = '';
                        this.floorImage.show = false;
                        return false;
                    }
                    xhr = $.get('${ctx}/pw/pwDesignerCanvas/parentAndChildren?id=' + (base.id || ''));
                    xhr.success(function (data) {
                        var buildingIds = [];
                        self.buildingId = '';
                        self.floors = data.children ? data.children.floors : [];
                        self.imgUrl = data.self.imageUrl;
                        self.buildingId = '';
                        self.floorId = '';
                        self.floorImage.show = false;
                        if (data.children.buildings) {
                            data.children.buildings.forEach(function (t) {
                                buildingIds.push(t.id)
                            })
                        }
                        self.baseContainBuild = buildingIds.join(',') || '';
                    })
                },

                //改变校区
                changeBuilding: function (base, $event) {
                    var xhr, self = this;
                    if (!base.id) {
                        this.buildingId = '';
                        this.floorId = '';
                        this.floors.length = 0;
                        this.imgUrl = '';
                        this.floorImage.show = false;
                        return false;
                    }
                    xhr = $.get('${ctx}/pw/pwDesignerCanvas/parentAndChildren?id=' + (base.id || ''));
                    xhr.success(function (data) {
                        var buildingIds = [];
                        self.baseId = data.parents.base ? data.parents.base.id : '';
                        self.floors = data.children ? data.children.floors : [];
                        self.floorId = '';
                        self.floorImage.show = false;
                        self.imgUrl = data.self.imageUrl;
                        if (data.brothers.length > 0) {
                            data.brothers.forEach(function (t) {
                                buildingIds.push(t.id)
                            })
                        }
                        buildingIds.push(base.id);
                        self.baseContainBuild = buildingIds.join(',') || '';
                    })
                },
                //改变楼层
                changeFloor: function (base, $event) {
                    var xhr, self = this, pwDesignerCanvas;
                    if (!base.id) {
                        this.floorId = '';
                        this.floors.length = 0;
                        this.imgUrl = '';
                        this.floorImage.show = false;
                        return false;
                    }
                    xhr = $.get('${ctx}/pw/pwDesignerCanvas/parentAndChildren?id=' + (base.id || ''));
                    xhr.success(function (data) {
                        self.baseId = data.parents.base ? data.parents.base.id : '';
                        self.buildingId = data.parents.building ? data.parents.building.id : '';
//                        self.imgUrl = data.self.imageUrl;
                        pwDesignerCanvas = data.self.pwDesignerCanvas;
                        if (!pwDesignerCanvas) {
                            self.floorImage.show = false;
                            return false;
                        }
                        self.floorImage = {
                            backgroundUrl: pwDesignerCanvas.href,
                            backgroundColor: pwDesignerCanvas.fill,
                            imageUrl: pwDesignerCanvas.picUrl,
                            show: true
                        }
                    })
                },
                initBase: function () {
                    if (this.bases.length > 0) {
                        this.baseId = this.bases[0].id;
                        this.changeBase(this.bases[0]);
                        return false;
                    }
                    if (this.buildings.length > 0) {
                        this.buildingId = this.buildings[0].id;
                        this.changeBuilding(this.buildings[0]);
                        return false;
                    }
                }

            },
            beforeMount: function () {
                this.initBase();
            },
            mounted: function () {

            }
        })
    }(jQuery)
</script>
</body>
</html>