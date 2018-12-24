<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <meta charset="UTF-8">
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>
    <style>
        .addable-element img {
            display: block;
            width: 100%;
        }

        html, body {
            width: 100%;
            height: 100%;
            overflow: hidden;
        }

        .cert-container {
            width: 100%;
            height: 100%;
        }

        .cert-container .cert-body {
            height: calc(100% - 150px);
            overflow: hidden;
        }
    </style>
</head>
<body>
<div id="app" v-show="pageLoad" style="display: none;padding: 0" class="container-fluid cert-container">
    <edit-bar second-name="设计" style="margin: 0 0;"></edit-bar>
    <div class="cert-header" style="border-bottom: 1px solid #ccc;box-sizing: border-box">
        <div style="float: right">
            <el-button type="primary" size="mini" @click.stop.prevent="viewCert">预览</el-button>
            <el-button type="primary" size="mini">提交</el-button>
            <el-button size="mini">清空</el-button>
            <el-button size="mini">返回</el-button>
        </div>
        <div class="cth-addable-elements cth-col" style="padding: 13px 8px; width: 126px;">
            <div class="addable-element addable-element-image" style="height: 64px;">
                <el-tooltip class="item" effect="dark" popper-class="white" content="拖入画布，双击上传图片" placement="bottom">
                    <div style="margin-top: 6px;">
                        <img @mousedown.stop.prevent="draggleElement" src="/images/cert-image-default.png">
                    </div>
                </el-tooltip>
                <span>图片</span>
            </div>
            <div class="addable-element addable-element-image" style="height: 64px;">
                <el-tooltip class="item" effect="dark" popper-class="white" content="拖入画布，双击改变文字" placement="bottom">
                    <div style="margin-top: 13px;">
                        <img src="/images/md/cert-label.png">
                    </div>
                </el-tooltip>
                <span>标签</span>
            </div>
        </div>
        <div class="cth-paper-attributes cth-col">
            <div class="paper-attributes-box">
                <div class="paper-size-item">画布宽：{{pageWidth}}px</div>
                <div class="paper-size-item">画布高：{{pageHeight}}px</div>
            </div>
        </div>
        <div class="cth-element-attributes cth-col">
            <div class="image-attributes">
                <div class="attr-group">
                    <label>透明度：</label>
                    <div class="attr-control">
                        <input type="range" step="0.1" min="0.1" max="1" class="input-range" style="width: 160px;"
                               v-model="currentImage.fillOpacity">
                        <output>{{currentImage.fillOpacity * 100}}</output>
                        <span class="unit">%</span>
                    </div>
                </div>
                <div class="attr-group">
                    <label>层级：</label>
                    <div class="attr-control" style="width: 52px;">
                        <el-input type="number" size="mini" v-model="currentImage.sort"></el-input>
                    </div>
                </div>
            </div>
        </div>
        <div class="cth-element-attributes cth-col">
            <div class="text-attributes">
                <div class="attr-group attr-group-type">
                    <label>类型：</label>
                    <div class="attr-control" style="width: 116px;">
                        <el-select size="mini" placeholder="请选择" clearable filterable v-model="currentText.varCol">
                            <el-option v-for="varCol in varCols" :key="varCol.value" :label="varCol.name"
                                       :value="varCol.value"></el-option>
                        </el-select>
                    </div>
                </div>
                <div class="attr-group attr-group-range" style="width: 244px;">
                    <div class="attr-control">
                        <!-- 色彩块 -->
                        <label>透明度：</label>
                        <input type="range" title="透明度" step="0.1" min="0.1" style="width: 157px;" max="1"
                               class="input-range"
                               v-model="currentText.fillOpacity">
                        <output>{{currentText.fillOpacity * 100}}</output>
                        <span class="unit">%</span>
                    </div>
                </div>
                <div class="attr-group attr-group-zindex" style="width: 88px;">
                    <label>层级：</label>
                    <div class="attr-control" style="width: 52px;">
                        <el-input type="number" size="mini" v-model="currentText.sort"></el-input>
                    </div>
                </div>
                <div class="attr-group" style="width: 100px;">
                    <el-tooltip class="item" effect="dark" content="字体" popper-class="white" placement="top">
                        <el-select size="mini" placeholder="请选择" clearable filterable v-model="currentText.fontFamily">
                            <el-option v-for="fontFamily in fontFamilies" :key="fontFamily" :label="fontFamily"
                                       :value="fontFamily"></el-option>
                        </el-select>
                    </el-tooltip>
                </div>
                <div class="attr-group" style="margin-left: 8px;">
                    <el-tooltip class="item" effect="dark" content="字体" popper-class="white" placement="top">
                        <el-select size="mini" placeholder="请选择" clearable filterable v-model="currentText.fontSize">
                            <el-option v-for="fontSize in fontSizes" :key="fontSize" :label="fontSize+'px'"
                                       :value="fontSize"></el-option>
                        </el-select>
                    </el-tooltip>
                </div>
                <div class="attr-group attr-style-group">
                    <div class="style-font_item" :class="{'style-font_item-selected': currentText.fontWeight}">
                        <el-tooltip class="item" effect="dark" content="加粗" popper-class="white" placement="top">
                            <img src="/images/md/cert-bold.png">
                        </el-tooltip>
                    </div>
                    <div class="style-font_item" :class="{'style-font_item-selected': currentText.fontStyle}">
                        <el-tooltip class="item" effect="dark" content="斜体" popper-class="white" placement="top">
                            <img src="/images/md/cert-itailc.png">
                        </el-tooltip>
                    </div>
                    <div class="style-font_item" :class="{'style-font_item-selected': currentText.textDecoration}">
                        <el-tooltip class="item" effect="dark" content="下划线" popper-class="white" placement="top">
                            <img src="/images/md/cert-underline.png">
                        </el-tooltip>
                    </div>
                </div>
                <div class="color-picker-attr">
                    <el-tooltip class="item" effect="dark" content="字体颜色" popper-class="white" placement="top">
                        <el-color-picker v-model="currentText.color" size="mini"></el-color-picker>
                    </el-tooltip>
                </div>
            </div>
        </div>
    </div>
    <div class="cert-body">
        <div class="cert-paper-scroller" data-cursor="grab" ref="certPaperScroller">
            <div class="cert-paper-scroller-background"
                 :style="pageStyle">
                <div class="cert-viewport" :style="pageStyle">
                    <div class="cert-design-paper">
                        <div class="cert-element"
                             v-for="(element, index) in elements" tabindex="-1"
                             :key="element.id"
                             :ref="element.id"
                             :data-id="element.id"
                             @mousedown.stop.prevent="elementMousedown(element,$event)"
                             :style="{ left: element.x + 'px', top: element.y + 'px',  opacity: element.fillOpacity, zIndex: element.sort}">
                            <div v-if="element.url"
                                 :style="{width: element.width + 'px'}">
                                <img :src="element.url"
                                     :style="{width: element.width + 'px', height: element.height + 'px'}">
                            </div>
                            <div v-if="element.text"
                                 :style="{width: element.width + 'px', height: element.height+'px'}"
                            >
                                <div class="cert-text"
                                     :style="{fontSize: element.fontSize+'px',
                                    fontWeight: element.fontWeight,
                                    fontStyle: element.fontStyle,
                                    textDecoration: element.textDecoration,
                                     color: element.color,
                                    fontFamily: element.fontFamily}">{{element.text}}
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="cert-control-sizes"
                         :class="{show: controlSize}"
                         ref="certControlSizes"
                         style="z-index:999;"
                         :style="controlSizesStyle">
                        <div draggable="false" class="resize nw" data-position="top-left"
                             @mousedown.stop.prevent="stretchNode($event)"></div>
                        <div draggable="false" class="resize n" data-position="top"
                             @mousedown.stop.prevent="stretchNode($event)"></div>
                        <div draggable="false" class="resize ne" data-position="top-right"
                             @mousedown.stop.prevent="stretchNode($event)"></div>
                        <div draggable="false" class="resize e" data-position="right"
                             @mousedown.stop.prevent="stretchNode($event)"></div>
                        <div draggable="false" class="resize se" data-position="bottom-right"
                             @mousedown.stop.prevent="stretchNode($event)"></div>
                        <div draggable="false" class="resize s" data-position="bottom"
                             @mousedown.stop.prevent="stretchNode($event)"></div>
                        <div draggable="false" class="resize sw" data-position="bottom-left"
                             @mousedown.stop.prevent="stretchNode($event)"></div>
                        <div draggable="false" class="resize w" data-position="left"
                             @mousedown.stop.prevent="stretchNode($event)"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <form ref="previewForm" style="display: none;" action="${ctx}/cert/preview" method="POST" target="_blank">
        <input type="text" ref="previewData" name="data">
    </form>
</div>

<script type="text/javascript">
    'use strict';

    new Vue({
        el: '#app',
        data: function () {
            return {
                certpageid: '${certpageid}',
                certpagename: '${certpagename}',
                certname: '${certname}',
                certid: '${certid}',
                varCols: JSON.parse('${colsJson}'),
                pageWidth: '',
                pageHeight: '',
                imgPath: '',
                currentImage: {
                    fillOpacity: 1,
                    sort: 0
                },
                currentText: {
                    fillOpacity: 1,
                    color: '#000000',
                    fontFamily: '微软雅黑',
                    fontSize: 12,
                    sort: 0
                },
                fontFamilies: ['微软雅黑', '宋体', '幼圆', '新宋体', '方正姚体', '方正舒体', '楷体', '隶书', '黑体'],
                fontSizes: [12, 14, 16, 20, 24, 36],
                elements: [],
                controlSizesStyle: {
                    left: '',
                    top: '',
                    width: '',
                    height: '',
                },
                controlSize: false
            }
        },
        computed: {
            pageStyle: function () {
                return {
                    width: this.pageWidth + 'px',
                    height: this.pageHeight + 'px',
                }
            }
        },
        methods: {
            elementMousedown: function (element, event) {
                var ctrlKey = event.ctrlKey;
                this.setControlSizesStyle(element);
                this.controlSize = true;
            },

            //拖拽元素
            draggleElement: function (event) {

            },

            //设置画布大小
            setControlSizesStyle: function (element) {
                this.controlSizesStyle = {
                    left: (element.x - 1) + 'px',
                    top: (element.y - 1) + 'px',
                    width: (element.width + 2) + 'px',
                    height: (element.height + 2) + 'px'
                }
            },

            //获取画布数据
            getCertPage: function () {
                var self = this;
                this.$axios.get('/cert/getCertPage?pageid=' + this.certpageid).then(function (response) {
                    var data = response.data;
                    if (data && data.list) {
                        self.clearCert();
                        self.imgPath = data.imgPath;
                        self.pageWidth = parseInt(data.width);
                        self.pageHeight = parseInt(data.height);
                        self.elements = data.list;
                        self.elements.forEach(function (item) {
                            item.width = parseInt(item.width)
                            item.height = parseInt(item.height)
                        })
                    }
                }).catch(function (error) {
                    self.$message.error(self.xhrErrorMsg);
                });
            },

            //清除画布
            clearCert: function () {
                this.elements = [];
                this.getCertPageSizeBase();
            },

            //获取画布基本大小
            getCertPageSizeBase: function () {
                var element = this.$refs.certPaperScroller;
                var width = $(element).width();
                var height = $(element).height();
                this.pageWidth = width;
                this.pageHeight = height;
            },

            //验证是否有默认图片
            validateElements: function () {
                var elements = this.elements;
                var len = elements.length;
                var valid = true;
                for (var i = 0; i < len; i++) {
                    var elementItem = elements[i];
                    if (/cert\-image\-default/.test(elementItem.url)) {
                        valid = false;
                        break;
                    }
                }
                return valid;
            },

            //预览
            viewCert: function () {
                var data = {
                    certid: this.certid,
                    certname: this.certname,
                    certpageid: this.certpageid,
                    certpagename: this.certpagename,
                    uiHtml: '1',
                    uiJson: '1'
                };
                var elements = this.elements;
                var len = elements.length;
                var isValid;
                if (len === 0) {
                    this.$message.error("请上传图片或者写入文字", "提示");
                    return false;
                }
                isValid = this.validateElements();
                if (!isValid) {
                    this.$message.error("存在默认图片，请双击上传图片", "提示");
                    return false;
                }
                var fitSize = this.getFitElements();
                data.width = fitSize.width;
                data.height = fitSize.height;
                data.list = fitSize.elements;
                this.$refs.previewData.value = JSON.stringify(data);
                this.$refs.previewForm.submit();
            },

            //获取铺满的元素数据
            getFitElements: function () {
                var elementCopy = [];
                var elements = JSON.parse(JSON.stringify(this.elements))
                var maxSize = this.getMaxSize();
                var maxWidth = maxSize.maxWidth;
                var maxHeight = maxSize.maxHeight;
                var minX = maxSize.minX;
                var minY = maxSize.minY;

                elements.forEach(function (item, i) {
                    elementCopy.push(item);
                    elementCopy[i].x = item.x - minX;
                    elementCopy[i].y = item.y - minY;
                });
                return {
                    elements: elementCopy,
                    width: maxWidth - minX,
                    height: maxHeight - minY
                }
            },

            //获取所有元素的最大高度最大宽度
            getMaxSize: function () {
                var widths = [];
                var heights = [];
                var elements = this.elements;
                var xes = [];
                var yes = [];
                for (var i = 0, len = elements.length; i < len; i++) {
                    var item = elements[i];
                    widths.push((item.x + item.width));
                    heights.push((item.height + item.y));
                    xes.push(item.x);
                    yes.push(item.y);
                }
                return {
                    maxWidth: Math.max.apply(null, widths),
                    maxHeight: Math.max.apply(null, heights),
                    minX: Math.min.apply(null, xes),
                    minY: Math.min.apply(null, yes)
                }
            },
        },

        created: function () {
            if (this.certpageid) {
                this.getCertPage();
            }
        },
        mounted: function () {
            this.getCertPageSizeBase();
        }
    })
</script>

</body>
</html>