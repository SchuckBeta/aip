<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script src="${ctxStatic}/vue/vue.min.js"></script>
    <script src="/js/components/radio/radio.js"></script>
    <script src="/js/components/radio/radioGroup.js"></script>
    <%--<script src="/js/components/radio/PWSPACELIST.js"></script>--%>
    <style>
        .e-checkbox, .e-radio{
            display: inline-block;
            vertical-align: top;
            margin: 0;
        }
    </style>
</head>
<body>


<div id="pwIndex" class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>基地全局图预览</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <div class="edit-bar edit-bar-tag edit-bar_new clearfix">
        <div class="edit-bar-left">
            <span>基地全局图预览</span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <div v-show="isLoad" style="display:none;overflow: hidden;">
        <div class="base-common">基地</div>
        <div class="base-distance">
            <e-radio-group v-model="radio1" @change="handleRadioChange">
                <e-radio name="base" v-for="base in baseList" :label="base.id" :key="base.id">{{base.name}}</e-radio>
            </e-radio-group>
        </div>
    </div>

    <div v-show="isLoad" style="display:none;overflow: hidden;">
        <div class="base-common">楼栋</div>
        <div class="base-distance">
            <e-radio-group v-model="radio2" @change="handleRadio2Change">
                <e-radio name="build" v-for="build in buildList" :label="build.id" :key="build.id"
                         :is-gray="notBuildBorthers.indexOf(build.id) > -1">{{build.name}}
                </e-radio>
            </e-radio-group>
        </div>
    </div>

    <div v-show="isLoad" style="display:none;overflow: hidden;">
        <div class="base-common">楼层</div>
        <div class="base-distance">
            <e-radio-group v-model="radio3" @change="handleRadio3Change">
                <e-radio name="floor" v-for="floor in floorList" :label="floor.id" :key="floor.id">{{floor.name}}
                </e-radio>
            </e-radio-group>
        </div>
    </div>
    <hr v-show="baseList.length > 0 || buildList.length > 0" style="display: none"/>
    <div class="base-designer-box">
        <img v-show="load" class="base-imgLoad" src="/images/imgLoading.gif">
        <a href="javascript:void(0);"><img v-show="!floorImage.show" class="designer-image" :src="imgUrl | imgFtp"></a>
        <div v-show="floorImage.show" class="floor-image-box" style="display:none"
             :style="{backgroundColor: floorImage.backgroundColor, backgroundImage: floorDetails.backgroundImage}">
            <img :src="floorDetails.imageUrl">
        </div>
    </div>

</div>


<script type="text/javascript">
    +function ($, Vue) {
        var pwIndex = new Vue({
            el: '#pwIndex',
            data: function () {
                return {
                    radio1: '',
                    radio2: '',
                    radio3: '',
                    ftpHttp: ftpHttp,
                    imgUrl: '',
                    baseList: JSON.parse('${fns: toJson(bases)}'),
                    buildList: JSON.parse('${fns: toJson(buildings)}'),
                    floorList: [],
                    selectedBuildChild: [],
                    selectedFloorChild: [],
                    selectedBaseParents: [],
                    selectedBuildFloor: [],
                    notBuildBorthers: [],
                    selectedFloorBuildParent: '',
                    floorImage: {
                        backgroundUrl: '',
                        backgroundColor: '',
                        imageUrl: '',
                        show: false
                    },
                    load: false,
                    isLoad: false
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
            computed: {
                //所有楼层数据
                allFloorList: function () {
                    return JSON.parse('${fns: toJson(floorList)}');
                },
                floorDetails: {
                    get: function () {
                        var floorImage = this.floorImage;
                        var backgroundImage = floorImage.backgroundUrl;
                        var imageUrl = floorImage.imageUrl;
                        if(backgroundImage){
                            backgroundImage = 'url('+this.ftpHttp + backgroundImage.replace('/tool', '')+')';
                        }
                        if(imageUrl){
                            imageUrl = this.ftpHttp + imageUrl.replace('/tool', '')
                        }
                        return {
                            backgroundImage: backgroundImage,
                            backgroundColor: floorImage.backgroundColor,
                            imageUrl: imageUrl,
                        }
                    }
                }
            },
            methods: {
                //某基地下某楼栋所对应的楼层
                getFloorList: function (baseId, buildList) {
                    var floorList = [];
                    for (var i = 0; i < buildList.length; i++) {
                        var build = buildList[i];
                        if (build.parentId == baseId) {
                            floorList = floorList.concat(this.allFloorList.filter(function (item) {
                                return item.parentId === build.id;
                            }))
                        }
                    }
                    return floorList;
                },
                //某基地下对应的所有楼栋
                getBuildBorthers: function (id) {
                    var buildBorthers = [];
                    this.buildList.forEach(function (item) {
                        if (item.parentId === id) {
                            buildBorthers.push(item);
                        }
                    });
                    return buildBorthers;
                },
                //基地点击事件
                handleRadioChange: function () {
                    this.radio2 = '';
                    this.radio3 = '';
                    var base = this.getSpace(this.radio1, 'baseList');
                    var baseId = base.id;
                    var self = this;

                    this.selectedBuildFloor = [];
                    this.notBuildBorthers = this.getNotBuildBorthers(baseId);
                    //缓存数据
                    if (base.buildChild || base.floorChild || base.imgUrl) {
                        this.floorList = base.floorChild;
                        this.selectedBuildChild = base.buildChild;
                        this.imgUrl = base.imgUrl;
                        this.floorImage.show = false;
                        return false;
                    }

                    base.buildChild = [];
                    base.floorChild = [];
                    base.imgUrl = '';

                    base.buildChild = this.getBuildBorthers(baseId);
                    this.floorList = this.getFloorList(baseId,base.buildChild);
                    base.floorChild = this.floorList;
                    this.selectedBuildChild = base.buildChild;

                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/pw/pwDesignerCanvas/parentAndChildren?id=' + this.radio1,
                        beforeSend:function(){
                            self.load = true
                        },
                        success: function(data){
                            self.load = false;
                            self.floorImage.show = false;
                            self.imgUrl = data.self.imageUrl;
                            base.imgUrl = self.imgUrl;
                        }
                    })
                },
                //得到某id的对象
                getSpace: function (id, key) {
                    var space;
                    for (var i = 0; i < this[key].length; i++) {
                        if (id === this[key][i].id) {
                            space = this[key][i];
                            break;
                        }
                    }
                    return space;
                },
                //不属于某基地的楼栋数据
                getNotBuildBorthers: function (id) {
                    var notBuildBorthers = [];
                    this.buildList.forEach(function (item) {
                        if (item.parentId !== id) {
                            notBuildBorthers.push(item.id)
                        }
                    });
                    return notBuildBorthers;
                },
                //某楼栋下对应的楼层
                getBuildFloorList: function (id) {
                    var floorList = [];
                    floorList = floorList.concat(this.allFloorList.filter(function (item) {
                        return item.parentIds.indexOf(id) > -1;
                    }))
                    return floorList;
                },
                //楼栋点击事件
                handleRadio2Change: function () {
                    this.selectedBuildChild = [];
                    this.radio1 = '';
                    this.radio3 = '';

                    var build = this.getSpace(this.radio2, 'buildList');
                    var buildParentId = build.parentId;
                    var buildId = build.id;
                    var self = this;
                    this.notBuildBorthers = this.getNotBuildBorthers(buildParentId);

                    if (build.baseParents || build.floorChild || build.imgUrl) {
                        this.selectedBaseParents = build.baseParents;
                        this.floorList = build.floorChild;
                        this.radio1 = this.selectedBaseParents;
                        this.imgUrl = build.imgUrl;
                        this.floorImage.show = false;
                        return false;
                    }

                    build.baseParents = [];
                    build.floorChild = [];
                    build.imgUrl = '';

                    build.baseParents = buildParentId;
                    this.floorList = this.getBuildFloorList(buildId);
                    this.selectedBaseParents = build.baseParents;
                    build.floorChild = this.floorList;
                    this.radio1 = this.selectedBaseParents;

                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/pw/pwDesignerCanvas/parentAndChildren?id=' + this.radio2,
                        beforeSend:function(){
                            self.load = true
                        },
                        success: function(data){
                            self.load = false;
                            self.floorImage.show = false;
                            self.imgUrl = data.self.imageUrl;
                            build.imgUrl = self.imgUrl
                        }
                    })
                },
                //得到楼层父楼栋对象数据
                getBuildParents: function (ids) {
                    var floorBuildParent = [];
                    this.buildList.forEach(function (item) {
                        if (ids.indexOf(item.id) > -1) {
                            floorBuildParent = item;
                        }
                    });
                    return floorBuildParent
                },
                //楼层点击事件
                handleRadio3Change: function () {
                    var floor = this.getSpace(this.radio3, 'floorList');
                    var self = this, pwDesignerCanvas;
                    var floorParentIds = floor.parentIds;

                    if (floor.buildParent || floor.floorImg) {
                        this.selectedFloorBuildParent = floor.buildParent.id;
                        this.floorImage = floor.floorImg;
                        this.radio2 = floor.buildParent.id;
                        this.floorImage.show = true;
                        return false
                    }

                    floor.buildParent = [];
                    floor.floorImg = '';

                    floor.buildParent = this.getBuildParents(floorParentIds);
                    this.selectedFloorBuildParent = floor.buildParent.id;
                    this.radio2 = floor.buildParent.id;

                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/pw/pwDesignerCanvas/parentAndChildren?id=' + this.radio3,
                        beforeSend:function(){
                            self.load = true
                        },
                        success: function(data){
                            self.load = false;
                            pwDesignerCanvas = data.self.pwDesignerCanvas;
                            if (!pwDesignerCanvas) {
                                self.floorImage.show = false;
                                return false;
                            }
                            self.floorImage = {
                                backgroundUrl: pwDesignerCanvas.backgroundImage,
                                backgroundColor: pwDesignerCanvas.backgroundColor,
                                imageUrl: pwDesignerCanvas.picUrl,
                                show: true
                            }
                            floor.floorImg = self.floorImage
                        }
                    })
                }
            },
            beforeMount: function () {
                var xhr,self = this;
                //一开始得到不是兄弟的楼栋id 使之字体变灰
                this.buildList.forEach(function (item) {
                    self.notBuildBorthers.push(item.id);
                });
                //开始默认显示第一个基地数据
                this.radio1 = this.baseList[0].id;
                xhr = $.get('${ctx}/pw/pwDesignerCanvas/parentAndChildren?id=' + this.radio1);
                xhr.success(function (data) {
                    self.imgUrl = data.self.imageUrl;
                    self.floorImage.show = false;
                })
            },

            mounted: function () {
                this.isLoad = true;
            }
        })

    }(jQuery, Vue)
</script>
</body>
</html>