<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script src="${ctxStatic}/vue/vue.min.js"></script>
    <script src="/js/cert/colorPicker.js?v=101"></script>
    <!---公用楼层设计颜色-->
    <style>
        html, body {
            height: 100%;
        }

        body {
            -webkit-user-select: none;
            -moz-user-select: -moz-none;
            user-select: none;
        }

    </style>
</head>
<body>
<div id="certDesign" class="cert-container">
    <%--<div class="edit-bar clearfix" style="margin: 0 15px;">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>证书设计</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <input type="hidden" name="secondName" id="secondName" value="${secondName}"/>
    <div class="cert-header" ref="certHeader" style="display: none;"
         v-show="isLoad">
        <div class="cth-addable-elements cth-col">
            <div class="addable-element addable-element-image"
                 @mousedown.stop.prevent="dragAddableElement('image',$event)">
                <img data-toggle="tooltip" data-title="拖入画布，双击上传图片" src="/images/cert-image-default.png">
                <span>图片</span>
            </div>
            <%--<div class="addable-element" @mousedown.stop.prevent="dragAddableElement('textTitle',$event)">--%>
            <%--<p class="heading">我的标题</p>--%>
            <%--<span>标题</span>--%>
            <%--</div>--%>
            <div class="addable-element" @mousedown.stop.prevent="dragAddableElement('textLabel',$event)">
                <div class="cert-label-pic" style="width: 48px; margin: 5px auto 4px">
                    <img data-toggle="tooltip" data-title="拖入画布，双击改变文字" src="/images/md/cert-label.png">
                </div>
                <span>标签</span>
            </div>
            <%--<div class="addable-element" @mousedown.stop.prevent="dragAddableElement('textParagraph',$event)">--%>
            <%--<p class="element-paragraph">我的段落我的段落我的段落我的段落</p>--%>
            <%--<span>段落</span>--%>
            <%--</div>--%>
            <p class="text-center">添加元素</p>
        </div>
        <div class="cth-paper-attributes cth-col">
            <div class="paper-attributes-box" style="width: 144px;">
                <div class="attr-group">
                    <label>宽：</label>
                    <div class="attr-control">
                        <input type="text" class="input-mini" readonly v-model="pageWidth">
                        <span class="unit">px</span>
                    </div>
                </div>
                <div class="attr-group">
                    <label>高：</label>
                    <div class="attr-control">
                        <input type="text" class="input-mini" readonly v-model="pageHeight">
                        <span class="unit">px</span>
                    </div>
                </div>
                <%--<div class="attr-group attr-group-range">--%>
                <%--<label>缩放：</label>--%>
                <%--<div class="attr-control">--%>
                <%--<input type="range" step="10" min="20" max="200" class="input-range">--%>
                <%--<output>100</output>--%>
                <%--<span class="unit">%</span>--%>
                <%--</div>--%>
                <%--</div>--%>
            </div>
            <p class="text-center">画布</p>
        </div>
        <div v-show="!isImage && elementShow" class="cth-element-attributes cth-col" style="display: none">
            <div class="text-attributes">

                <div class="attr-group attr-group-type">
                    <label>类型：</label>
                    <div class="attr-control">

                        <select class="input-small" v-model="currentText.varCol" style="width: 110px;"
                                @change.stop.prevent="changeVarCol">
                            <option value="">--请选择--</option>
                            <option v-for="varCol in varCols" :value="varCol.value">{{varCol.name}}</option>
                        </select>

                        <%--<div class="input-append">--%>
                        <%--<select class="input-small" v-model="currentText.varCol"--%>
                        <%--@change.stop.prevent="changeVarCol">--%>
                        <%--<option value="">--请选择--</option>--%>
                        <%--<option v-for="varCol in varCols" :value="varCol.value">{{varCol.name}}</option>--%>
                        <%--</select>--%>
                        <%--<div class="btn-group">--%>
                        <%--<button type="button" class="btn btn-default">+</button>--%>
                        <%--</div>--%>
                        <%--</div>--%>
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

                <div class="attr-group attr-group-zindex" style="width: 90px;">
                    <label>层级：</label>
                    <div class="attr-control">
                        <input type="number" title="层级" class="input-mini" style="width: 40px;"
                               v-model="currentText.sort">
                    </div>
                </div>

                <div class="attr-group">
                    <select class="input-small" title="字体" v-model="currentText.fontFamily">
                        <option v-for="fontFamily in fontFamilies" :value="fontFamily.value">{{fontFamily.label}}
                        </option>
                    </select>
                </div>
                <div class="attr-group" style="margin-left: 8px;">
                    <select name="fontSize" title="字体大小" class="input-small" v-model="currentText.fontSize">
                        <option v-for="fs in fontSizes" :value="fs.value">{{fs.label}}</option>
                    </select>
                </div>
                <div class="attr-group attr-style-group">
                    <div class="style-font_item" :class="{'style-font_item-selected': currentText.fontWeight}"
                         @click.stop="changeFontWeight">
                        <img title="加粗" src="/images/md/cert-bold.png">
                    </div>
                    <div class="style-font_item" :class="{'style-font_item-selected': currentText.fontStyle}"
                         @click.stop="changeFontStyle">
                        <img title="斜体" src="/images/md/cert-itailc.png">
                    </div>
                    <div class="style-font_item" :class="{'style-font_item-selected': currentText.textDecoration}"
                         @click.stop="changeTextUnderline">
                        <img title="下划线" src="/images/md/cert-underline.png">
                    </div>
                </div>
                <%--<div class="attr-group">--%>
                <%--<label>行高：</label>--%>
                <%--<div class="attr-control">--%>
                <%--<select name="fontSize" class="input-mini" v-model="currentText.lineHeight"--%>
                <%--style="padding-left: 3px;">--%>
                <%--<option v-for="lh in lineHeights" :value="lh.value">{{lh.label}}</option>--%>
                <%--</select>--%>
                <%--</div>--%>
                <%--</div>--%>


                <div class="attr-group attr-group-color">
                    <!-- 色彩块 -->
                    <div class="attr-color">
                        <div class="attr-text-a">
                            <img src="/images/md/cert-color.png">
                        </div>
                        <div ref="selectBgSelection" class="select-bg-selection">
                            <div class="select-bg-option-content"
                                 :style="{backgroundColor: currentText.color}">
                                <img v-show="currentText.color === 'transparent'" src="/images/transparent-icon.png"
                                     class="select-box-option-icon">
                            </div>
                        </div>
                    </div>
                    <div class="attr-trigger" @click="changePaperBgColor($event)"></div>
                </div>
            </div>
            <p class="text-center">文字属性</p>
        </div>
        <div v-show="isImage && elementShow" class="cth-element-attributes cth-col" style="display: none">
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
                    <div class="attr-control">
                        <input type="number" class="input-mini" v-model="currentImage.sort">
                    </div>
                </div>
                <%--<div class="attr-group">--%>
                <%--<label>旋转：</label>--%>
                <%--<div class="attr-control">--%>
                <%--<a href="javascript: void(0)" :title="currentImage.angle"--%>
                <%--@click.stop.prevent="changeAngle($event)"><i class="iconfont">&#xe62c;</i></a>--%>
                <%--</div>--%>
                <%--</div>--%>
            </div>
            <p class="text-center">图片属性</p>
        </div>
        <div class="pull-right text-right">
            <div style="margin-bottom: 10px; padding-top: 17px;">
                <%--<button type="button" class="btn btn-primary" v-show="isLoad" style="display: none" :disabled="saveIng"--%>
                        <%--@click.stop.prevent="modalCertNameShow=true">--%>
                    <%--证书名称--%>
                <%--</button>--%>
                <button type="button" class="btn btn-primary" v-show="isLoad" style="display: none" :disabled="saveIng"
                        @click.stop.prevent="viewCert">
                    {{saveIng? '生成中...': '预览'}}
                </button>
                <button type="button" class="btn btn-primary" v-show="isLoad" style="display: none" :disabled="saveIng"
                        @click.stop.prevent="saveCert">
                    {{saveIng? '提交中...': '提交'}}
                </button>
            </div>
            <div>
                <button type="button" class="btn btn-default" :disabled="saveIng" @click.stop.prevent="clearCert">清空
                </button>
                <a href="${ctx}/cert/allList" class="btn btn-default">返回</a>
            </div>
        </div>
        <%--<div class="cth-collapse">--%>
        <%--<a href="javascript: void (0);"></a>--%>
        <%--</div>--%>
    </div>
    <div style="height: 10px; background-color: #ccc"></div>
    <color-picker v-model="colorPickerShow" value="false" :arrow-style="arrowStyle" :style="colorStyle"
                  @change-color="changeColor" @color-hide="colorPickerShow = false"
                  :color="color"></color-picker>
    <div class="cert-body" v-show="isLoad" style="display: none">
        <div class="cert-paper-scroller" data-cursor="grab" ref="certPaperScroller" @mousedown.stop.prevent="panning">
            <div class="cert-paper-scroller-background"
                 :style="{width: (pageWidth + 20)+'px', height: (pageHeight + 20)+'px'}">
                <div class="cert-viewport" :style="{width: pageWidth+'px', height: pageHeight + 'px'}">
                    <div class="cert-design-paper">
                        <div class="cert-scale">
                            <div class="cert-element"
                                 :class="{'cert-element-selected': ctrlSelectedElementIds.indexOf(element.id) > -1}"
                                 v-for="(element, index) in elements" tabindex="-1"
                                 :key="element.id"
                                 :ref="element.id"
                                 :data-id="element.id"
                                 @mousedown.stop.prevent="elementMousedown(element,$event)"
                                 @dblclick.stop.prevent="elementDoubleClick(element, $event)"
                                 @keyup.delete.stop.prevent="elementDelete(element, $event)"
                                 :style="{ left: element.x + 'px', top: element.y + 'px',  opacity: element.fillOpacity, zIndex: element.sort}">

                                <div v-if="element.url"
                                     :style="{width: element.width + 'px',transform: 'rotate('+element.angle+'deg)'}">
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
                                    <%--lineHeight: element.lineHeight,--%>
                                     color: element.color,
                                    fontFamily: element.fontFamily}">{{element.text}}
                                    </div>
                                </div>
                            </div>
                            <!--<div class="cert-element">-->
                            <!--<img src="timg.jpg">-->
                            <!--</div>-->
                            <!--<div class="cert-element">-->
                            <!--<p>我的段落我的段落<br>是是是是是是是是是</p>-->
                            <!--</div>-->
                        </div>
                    </div>
                    <div class="cert-control control-paper-size"
                         @mousedown.stop.prevent="controlPaperSize($event)"></div>
                    <div class="fake-paper" :class="{show: fakePaperShow}"
                         :style="{width: fakePaper.width + 'px', height: fakePaper.height + 'px'}">

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
                    <div class="cert-control-sizes"
                         :class="{show: controlSize}"
                         :style="controlSizesStyle">
                        <div draggable="false" class="cert-delete-element"
                             @mousedown.stop
                             @click.stop.prevent="elementDelete(currentRefId, $event)">&times;</div>
                    </div>
                    <div class="cert-write-font" :class="{show: elementTextShow}" :style="elementTextStyle">
                        <!--<textarea :style="elementTextAreaFontStyle" v-model="elementText" ref="elementTextarea"-->
                        <!--@mousedown.stop @change="changeElementText"></textarea>-->
                        <input class="contenteditable-area" :style="elementTextAreaFontStyle" v-model="elementText"
                               ref="elementTextarea" @change="changeElementText" @mousedown.stop>
                        <!--<div class="contenteditable-area" contenteditable="true" :style="elementTextAreaFontStyle" v-html="elementText" ref="elementTextarea" @mousedown.stop @blur="changeElementText">-->

                        <!--</div>-->
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div v-show="draggableElementShow" class="cert-drag-element"
         :style="{left: draggableElement.x + 'px', top: draggableElement.y + 'px', width: draggableElement.width + 'px'}">
        <template v-if="draggableKey == 'image'">
            <img :src="draggableElements.image.url" :style="{opacity: draggableElements.image.fillOpacity}">
        </template>
        <template v-if="draggableKey == 'textTitle'">
            <p :style="{fontSize: draggableElements.textTitle.fontSize+'px', fontWeight: draggableElements.textTitle.fontWeight}">
                {{draggableElements.textTitle.text}}</p>
        </template>
        <template v-if="draggableKey == 'textLabel'">
            <p :style="{fontSize: draggableElements.textLabel.fontSize+'px', fontWeight: draggableElements.textLabel.fontWeight}">
                {{draggableElements.textLabel.text}}</p>
        </template>
        <template v-if="draggableKey == 'textParagraph'">
            <p :style="{fontSize: draggableElements.textParagraph.fontSize+'px', fontWeight: draggableElements.textParagraph.fontWeight}"
               v-html="draggableElements.textParagraph.text">
            </p>
        </template>
    </div>
    <div class="hide">
        <input type="file" name="file" ref="uploadFile" @change.stop.prevent="uploadFile($event)"
               accept="image/jpeg,image/x-png">
    </div>
    <div v-show="modalCertNameShow"
         style="position: fixed;width: 100%;height: 100%;top: 0;left: 0;display: none;z-index: 1000">
        <div v-drag style="z-index: 1000" class="modal modal-large">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true"
                        @click="modalCertNameShow=false">&times;
                </button>
                <span>证书信息</span>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" v-validate="{form: 'certForm'}" autocomplete="off">
                    <div class="control-group">
                        <label class="control-label"><i>*</i>证书名称：</label>
                        <div class="controls">
                            <input type="text" name="certname" v-model="certname" class="required" autocomplete="off">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label"><i>*</i>证书内页名称：</label>
                        <div class="controls">
                            <input type="text" name="certpagename" v-model="certpagename" class="required"
                                   autocomplete="false">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-save btn-primary" :disabled="saveIng"
                        @click="saveCert">{{saveIng ? '保存中...': '提交并保存'}}
                </button>
                <button type="button" data-dismiss="modal" class="btn btn-default" @click="modalCertNameShow=false"
                        aria-hidden="true">取消
                </button>
            </div>
        </div>
        <div class="modal-backdrop in" style="z-index: 998"></div>
    </div>
    <form ref="previewForm" style="display: none;" action="${ctx}/cert/preview" method="POST" target="_blank">
        <input type="text" ref="previewData" name="data">
    </form>
</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>

<script>


    ;
    +function ($, Vue) {
        var certDesign = new Vue({
            el: '#certDesign',
            data: function () {
                return {
                    certpageid: '${certpageid}',
                    certpagename: '${certpagename}',
                    certname: '${certname}',
                    certid: '${certid}',
                    imgPath: '',
                    pageWidth: '',
                    pageHeight: '',
                    elements: [],
                    currentText: {
                        fontSize: 12
                    },
                    currentImage: {},
                    elementShow: false,
                    isImage: false,
                    currentRefId: '',
                    elementText: '',
                    elementTextShow: false,
                    elementTextStyle: {},
                    elementTextAreaFontStyle: {},
                    currentChangeTextId: '',
                    //所有可关联的变量
                    varCols: JSON.parse('${colsJson}'),
                    draggableElement: {
                        x: 0,
                        y: 0,
                        width: 0
                    },
                    fakePaper: {
                        width: '',
                        height: ''
                    },
                    fakePaperShow: false,
                    certForm: '',

                    colorPickerShow: false,
                    arrowStyle: {},
                    colorStyle: {},
                    color: 'rgb(51,51,51)',

                    ctrlSelectedElementIds: [],

                    saveIng: false,
                    modalCertNameShow: false,
                    controlSizesStyle: {
                        left: '',
                        top: '',
                        width: '',
                        height: '',
                        transform: ''
                    },
                    controlSize: false,
                    uuids: [],
                    //static
                    fontFamilies: [
                        {
                            label: '微软雅黑',
                            value: '微软雅黑'
                        },
                        {
                            label: '宋体',
                            value: '宋体'
                        }, {
                            label: '幼圆',
                            value: '幼圆'
                        }, {
                            label: '新宋体',
                            value: '新宋体'
                        }, {
                            label: '方正姚体',
                            value: '方正姚体'
                        }, {
                            label: '方正舒体',
                            value: '方正舒体'
                        }, {
                            label: '楷体',
                            value: '楷体'
                        }, {
                            label: '隶书',
                            value: '隶书'
                        }, {
                            label: '黑体',
                            value: '黑体'
                        }],

                    fontSizes: [{
                        label: '12px',
                        value: 12
                    }, {
                        label: '14px',
                        value: 14
                    }, {
                        label: '16px',
                        value: 16
                    }, {
                        label: '20px',
                        value: 20
                    }, {
                        label: '24px',
                        value: 24
                    }, {
                        label: '36px',
                        value: 36
                    }],
                    lineHeights: [{
                        label: 1.2,
                        value: 1.2
                    }, {
                        label: 1.4,
                        value: 1.4
                    }, {
                        label: 1.6,
                        value: 1.6
                    }],
                    elementTypeEnum: {
                        '1': 'image',
                        '2': 'text',
                        '3': 'text'
                    },
                    draggableElements: {
                        image: {
                            fillOpacity: 1,
                            url: '/images/cert-image-default.png',
                            width: 100,
                            height: 81,
                            elementType: '1'
                        },
                        textLabel: {
                            fillOpacity: 1,
                            text: '我的文本',
                            width: 100,
                            height: 20,
                            fontSize: 14,
//                            fontWeight: 'normal',
                            elementType: '2'
                        }
                    },
                    draggableElementShow: false,
                    draggableKey: '',
                    certHeaderHeight: 0,
                    certContainerPadding: 0,
                    angleClasses: {
                        0: ['nw', 'n', 'ne', 'e', 'se', 's', 'sw', 'w'],
                        90: ['ne', 'e', 'se', 's', 'sw', 'w', 'nw', 'n'],
                        180: ['se', 's', 'sw', 'w', 'nw', 'n', 'ne', 'e'],
                        270: ['sw', 'w', 'nw', 'n', 'ne', 'e', 'se', 's']
                    },
                    isLoad: true
                }
            },
            watch: {
                'controlSizesStyle': {
                    deep: true,
                    handler: function (value) {
                        var left = (parseInt(value.left) + 2);
                        var top = (parseInt(value.top) + 2);
                        var width = (parseInt(value.width) - 2);
                        var height = (parseInt(value.height) - 2);
                        this.elementTextStyle.left = left + 'px';
                        this.elementTextStyle.top = top + 'px';
                        this.elementTextStyle.width = width + 'px';
                        this.elementTextStyle.height = height + 'px';

                    }
                },
                'uuids': {
                    deep: true,
                    handler: function (value) {
                        if (value.length < 10) {
                            this.getUUIds(10);
                        }
                    }
                }

            },

            computed: {
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
                }
            },


            filters: {
                ftpHttp: function (src) {
                    if (src && !(/cert-image-default/.test(src))) {
                        return ftpHttp + src.replace('/tool', '')
                    }
                    return src;

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
                drag: function (element, binding, vnode) {
                    $(element).draggable({
                        handle: ".modal-header",
                        containment: "body"
                    })
                }
            },
            methods: {


                panning: function () {
                    this.elementTextShow = false;
                    this.controlSize = false;
                    this.elementShow = false;
                    this.emptySelectedElementIds();
                },

                dragAddableElement: function (key, $event) {
                    var startX, startY;
                    var self = this;
                    startX = $event.clientX;
                    startY = $event.clientY;
                    this.elementTextShow = false;
                    this.draggableKey = key;
                    this.draggableElement.width = this.draggableElements[key].width;
                    $(document).on('mousemove.addable.element', function move(e) {
                        self.addableElementMove.call(self, startX, startY, e)
                    });
                    $(document).on('mouseup.addable.element', function move(e) {
                        $(document).off('mousemove.addable.element');
                        $(document).off('mouseup.addable.element');
                        self.addableElementUp.call(self, e)
                    })
                },

                addableElementMove: function (startX, startY, $event) {
                    var moveX = $event.clientX;
                    var moveY = $event.clientY;


                    this.draggableElementShow = moveY > this.certHeaderHeight;

                    this.draggableElement.x = moveX;
                    this.draggableElement.y = moveY;
                },

                addableElementUp: function ($event) {
                    if (this.draggableElementShow) {
                        var element = this.pushElement();
                        this.selectedElement(element);
                        this.$nextTick(function () {
                            this.$refs[element.id][0].focus();
                        })
                    }

                    this.draggableElementShow = false;
                },


                //获取元素
                selectedElement: function (element) {
                    var elementType = this.elementTypeEnum[element.elementType];
                    this['current' + this.upperCaseKey(elementType)] = element;
                    this.elementShow = true;
                    this.isImage = elementType === 'image';
                    this.setCurrentRefId(element.id);
                    this.setControlSizesStyle(element);
                    this.setControlSize(1);
                    this.setCertControlChildrenClass(element.angle);
                    this.setControlSizeTransform(element.angle);

                },

                //设置元素
                setControlSizesStyle: function (element) {
                    this.controlSizesStyle.left = (element.x - 2) + 'px';
                    this.controlSizesStyle.top = (element.y - 2) + 'px';
                    this.controlSizesStyle.width = (element.width + 2) + 'px';
                    this.controlSizesStyle.height = (element.height + 2) + 'px';
                },

                setControlSizeTransform: function (angle) {
                    this.controlSizesStyle.transform = 'rotate(' + angle + 'deg)'
                },


                setControlSize: function (isShow) {
                    this.controlSize = !!isShow;
                },

                //设置当前ID;
                setCurrentRefId: function (id) {
                    this.currentRefId = id;
                },


                changeAngle: function ($event) {
                    var element = this.getCurrentElementById(this.currentRefId);
                    var angle = element.angle;
                    angle += 90;
                    element.angle = (angle >= 360 ? 0 : angle);
                    this.setCertControlChildrenClass(element.angle);
                    this.setControlSizeTransform(element.angle);
                },

                setCertControlChildrenClass: function (angle) {
                    var resizes, angleClasses = this.angleClasses[angle.toString()];
                    resizes = $(this.$refs.certControlSizes).children();
                    resizes.each(function (i, item) {
                        $(item).attr('class', 'resize ' + angleClasses[i])
                    })
                },

                changeVarCol: function () {
                    var element = this.getCurrentElementById(this.currentRefId);
                    element.elementType = this.currentText.varCol ? '3' : '1';
                },

                //删除元素
                elementDelete: function (element, $event) {
                    var elements = this.elements;
                    var id = $.type(element) === 'string' ? element : element.id;
                    for (var i = 0, len = elements.length; i < len; i++) {
                        var item = elements[i];
                        if (item.id === id) {
                            elements.splice(i, 1);
                            break;
                        }
                    }
                    this.controlSize = false;
                },

                //移动元素
                elementMousedown: function (element, $event) {
                    var startX = $event.clientX;
                    var startY = $event.clientY;
                    var $target = $(this.$refs[element.id][0]);
                    var left = parseInt($target.css('left'));
                    var top = parseInt($target.css('top'));
                    var self = this;
                    var ctrlKey = $event.ctrlKey;
                    var ctrlSelectedElementIndex;
                    var currentElementIndex;
                    var currentRefId = this.currentRefId;
                    var isMultiple; //多选为true 单个false
                    var multipleElementPos = [];
                    var isClick = true;
                    isMultiple = ctrlKey;
                    if (ctrlKey) {
                        //多选操作
                        this.setControlSize(!ctrlKey);
                        this.elementShow = false;
                        ctrlSelectedElementIndex = this.ctrlSelectedElementIds.indexOf(element.id);
                        currentElementIndex = this.ctrlSelectedElementIds.indexOf(currentRefId);
                        if (ctrlSelectedElementIndex > -1) {
                            this.removeCtrlSelectedElementId(ctrlSelectedElementIndex);
                        } else {
                            this.addCtrlSelectedElementId(element.id);
                        }
                        if (currentElementIndex < 0) {
                            this.addCtrlSelectedElementId(currentRefId)
                        }
                        isClick = false;
                    } else {
                        isMultiple = this.ctrlSelectedElementIds.length > 1;
                    }
                    isMultiple = !(!ctrlKey && !this.ctrlSelectedElementIds.length);

                    if (!isMultiple) {
                        self.elementTextShow = false;
                        self.selectedElement(element);
                        self.emptySelectedElementIds();
                        $target.focus();
                    }

                    multipleElementPos = this.getMultipleElementPost();

                    $(document).on('mousemove.element.move', function (e) {
                        if (!isMultiple) {
                            self.elementMousemove.call(self, left, top, startX, startY, $target, element, e)
                        } else {
                            self.elementsMousemove.call(self, left, top, startX, startY, $target, multipleElementPos, e)
                        }
                        isClick = false;
                    });

                    $(document).on('mouseup.element.up', function (e) {
                        $(document).off('mousemove.element.move');
                        $(document).off('mouseup.element.up');
                        if (isClick) {
                            self.elementTextShow = false;
                            self.selectedElement(element);
                            self.emptySelectedElementIds();
                            $target.focus();
                        }
                    })
                },

                //改变颜色
                changeColor: function (color) {
                    var element = this.getCurrentElementById(this.currentRefId);
                    element.color = this.colorRgb(color);
                    this.color = element.color;
                    this.colorPickerShow = false;
                },

                colorRgb: function (value) {
                    var sColor = value.toLowerCase();
                    //十六进制颜色值的正则表达式
                    var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
                    // 如果是16进制颜色
                    if (sColor && reg.test(sColor)) {
                        if (sColor.length === 4) {
                            var sColorNew = "#";
                            for (var i = 1; i < 4; i += 1) {
                                sColorNew += sColor.slice(i, i + 1).concat(sColor.slice(i, i + 1));
                            }
                            sColor = sColorNew;
                        }
                        //处理六位的颜色值
                        var sColorChange = [];
                        for (var i = 1; i < 7; i += 2) {
                            sColorChange.push(parseInt("0x" + sColor.slice(i, i + 2)));
                        }
                        return "rgb(" + sColorChange.join(",") + ")";
                    }
                    return sColor;
                },

                changeFontStyle: function () {
                    var element = this.getCurrentElementById(this.currentRefId);
                    element.fontStyle = !element.fontStyle ? 'italic' : '';
                },
                changeTextUnderline: function () {
                    var element = this.getCurrentElementById(this.currentRefId);
                    element.textDecoration = !element.textDecoration ? 'underline' : '';
                },
                changeFontWeight: function () {
                    var element = this.getCurrentElementById(this.currentRefId);
                    element.fontWeight = !element.fontWeight ? 'bold' : '';
                },


                changePaperBgColor: function () {
                    var $selection = $(this.$refs.selectBgSelection);
                    var left = $selection.offset().left;
                    var top = $selection.offset().top + 30;
                    var element = this.getCurrentElementById(this.currentRefId);
                    this.colorStyle = {
                        left: left + 'px',
                        top: top + 'px'
                    };
                    this.arrowStyle = {
                        left: '6px'
                    };

                    this.color = element.color;
                    this.colorPickerShow = true;
                },

                //获取最大高度最大宽度
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

                //添加多选
                addCtrlSelectedElementId: function (id) {
                    this.ctrlSelectedElementIds.push(id)
                },
                //移除多选
                removeCtrlSelectedElementId: function (index) {
                    this.ctrlSelectedElementIds.splice(index, 1)
                },

                //清空多选
                emptySelectedElementIds: function () {
                    this.ctrlSelectedElementIds = [];
                },

                //获取所有元素的初始位置
                getMultipleElementPost: function () {
                    var ctrlSelectedElementIds = this.ctrlSelectedElementIds;
                    var len = ctrlSelectedElementIds.length;
                    var obj = {};

                    for (var i = 0; i < len; i++) {
                        var id = ctrlSelectedElementIds[i];
                        var itemElement = this.getCurrentElementById(id);
                        obj[id] = {
                            left: itemElement.x,
                            top: itemElement.y
                        }
                    }
                    return obj;
                },


                //移动单个元素
                elementMousemove: function (x, y, startX, startY, $target, element, $event) {
                    var moveX = $event.clientX;
                    var moveY = $event.clientY;
                    var left = moveX - startX + x;
                    var top = moveY - startY + y;
                    var maxSize = this.getMaxSize();
                    var maxWidth = maxSize.maxWidth;
                    var maxHeight = maxSize.maxHeight;
                    var ableWidth = left + element.width + 40;
                    var ableHeight = top + element.height + 40;
                    maxWidth = this.pageWidth < maxWidth ? maxWidth : this.pageWidth;
                    maxHeight = this.pageHeight < maxHeight ? maxHeight : this.pageHeight;

                    if (ableWidth >= maxWidth && moveX - startX > 5) {
                        this.pageWidth += 500
                    }
                    if (ableHeight >= maxHeight && moveY - startY > 5) {
                        this.pageHeight += 500
                    }


                    if (left < 0) {
                        left = 0;
                    }
                    if (top < 0) {
                        top = 0;
                    }

                    element.x = left;
                    element.y = top;

                    this.controlSizesStyle.left = (left - 2) + 'px';
                    this.controlSizesStyle.top = (top - 2) + 'px';
                },

                //移动多个元素
                elementsMousemove: function (x, y, startX, startY, $target, elementsPos, $event) {
                    var ctrlSelectedElementIds = this.ctrlSelectedElementIds;
                    var len = ctrlSelectedElementIds.length;
                    var moveX = $event.clientX;
                    var moveY = $event.clientY;
                    for (var i = 0; i < len; i++) {
                        var id = ctrlSelectedElementIds[i];
                        var itemElement = this.getCurrentElementById(id);
                        var left = moveX - startX + elementsPos[id].left;
                        var top = moveY - startY + elementsPos[id].top;
                        itemElement.x = left;
                        itemElement.y = top;
                    }
                },

                //双击元素
                elementDoubleClick: function (element, $event) {
                    var self = this;
                    var elementType = this.elementTypeEnum[element.elementType];
                    if (elementType === 'image') {
                        this.$refs.uploadFile.click();
                    }
                    this.elementTextShow = elementType !== 'image';
                    if (this.elementTextShow) {
                        this.elementText = element.text;
                        this.setElementTextAreaFontStyle(element);
                        this.currentChangeTextId = element.id;
                        this.$nextTick(function () {
                            self.$refs.elementTextarea.focus();
                        })
                    }
                },

                setElementTextAreaFontStyle: function (element) {
//                    this.elementTextAreaFontStyle.lineHeight = element.lineHeight;
                    this.elementTextAreaFontStyle.fontStyle = element.fontStyle;
                    this.elementTextAreaFontStyle.fontWeight = element.fontWeight;
                    this.elementTextAreaFontStyle.textDecoration = element.textDecoration;
                    this.elementTextAreaFontStyle.fontSize = element.fontSize;
                    this.elementTextAreaFontStyle.fontFamily = element.fontFamily;
                    this.elementTextAreaFontStyle.color = element.color;
                },


                changeElementText: function () {
                    var element = this.getCurrentElementById(this.currentChangeTextId);
                    element.text = this.elementText;
//
//                    html2canvas(document.querySelector(".cert-design-paper")).then(function (canvas) {
//                        document.body.appendChild(canvas)
//                    });
                    this.elementTextShow = false;
                },


                //上传图片
                uploadFile: function ($event) {
                    var files = $event.target.files;
                    var file, fd, self = this;
                    if (files.length < 1) {
                        $event.target.files = null;
                        return false;
                    }
                    file = files[0];

                    if (!file.size) {
                        dialogCyjd.createDialog(0, '图片大小为OKB，请重新上传');
                        return false;
                    }

                    fd = new FormData();
                    fd.append('upfile', file);

                    $.ajax({
                        type: 'POST',
                        url: $frontOrAdmin+'/ftp/ueditorUpload/uploadTempFtp',
                        data: fd,
                        processData: false,
                        contentType: false,
                        success: function (data) {
                            self.setElementImgSrc(data)
                        }
                    })
                },

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
                    if (!len) {
                        dialogCyjd.createDialog(0, '请上传图片或者写入文字');
                        return false;
                    }
                    isValid = this.validateElements();
                    if (!isValid) {
                        dialogCyjd.createDialog(0, '存在默认图片，请双击上传图片');
                        return false;
                    }


                    var fitSize = this.getFitElements;
                    data.width = fitSize.width;
                    data.height = fitSize.height;
                    data.list = fitSize.elements;
                    this.$refs.previewData.value = JSON.stringify(data)
                    this.$refs.previewForm.submit();
                },

                saveCert: function () {
                    var self = this;
                    var isValid;
                    var data = {
                        certid: this.certid,
                        certname: this.certname,
                        certpageid: this.certpageid,
                        certpagename: this.certpagename,
                        uiHtml: '1',
                        uiJson: '1'
                    };

//                    if (this.modalCertNameShow) {
//                        if (!this.certForm.form()) {
//                            return false;
//                        }
//                    } else {
//                        if (!this.certname || !this.certpagename) {
//                            this.modalCertNameShow = true;
//                            return false;
//                        }
//                    }
                        if (!this.elements.length) {
                            dialogCyjd.createDialog(0, '请上传图片或者写入文字');
                            return false;
                        }

                        isValid = this.validateElements();
                        if (!isValid) {
                            dialogCyjd.createDialog(0, '存在默认图片，请双击上传图片');
                            return false;
                        }

                    var fitSize = this.getFitElements;
                    data.width = fitSize.width;
                    data.height = fitSize.height;
                    data.list = fitSize.elements;

                    this.saveIng = true;
                    $.ajax({
                        type: 'POST',
                        url: '${ctx}/cert/save',
                        data: JSON.stringify(data),
                        contentType: 'application/json;charset=UTF-8',
                        dataType: 'json',
                        success: function (data) {
                            self.saveIng = false;
                            if (data.ret == '1') {
                                self.modalCertNameShow = false;
                                self.certpageid = data.certpageid || '';
                                self.certid = data.certid || '';
                                dialogCyjd.createDialog(data.ret, data.msg, {
                                    dialogClass: 'dialog-cyjd-container none-close',
                                    buttons: [{
                                        text: '确定',
                                        'class': 'btn btn-sm btn-primary',
                                        click: function () {
                                            $(this).dialog('close');
                                            window.location.href = '/a/cert/allList'
                                        }
                                    }]
                                });
                                self.controlSize = false;
                                self.getCertPage();
                            }
                        },
                        error: function (error) {
                            self.saveIng = false;
                            dialogCyjd.createDialog(0, '网络连接错误，请重试');
                        }
                    })
                },

                clearCert: function () {
                    this.elements = [];
                    this.setDefaultCertContainerSize();
                },

                getCertPage: function () {
                    var self = this;
                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/cert/getCertPage',
                        dataType: 'json',
                        data: {
                            pageid: this.certpageid
                        },
                        contentType: 'application/json;charset=UTF-8',
                        success: function (data) {
                            if (data) {
//                                self.certpagename = data.certpagename;
                                self.certname = data.certname;
                                self.certid = data.certid;
                                if (data.list) {
                                    self.clearCert();
                                    self.imgPath = data.imgPath;
                                    self.pageWidth = parseInt(data.width);
                                    self.pageHeight = parseInt(data.height);
                                    self.elements = data.list;
                                    self.elements.forEach(function (item) {
                                        item.width = parseInt(item.width)
                                        item.height = parseInt(item.height)
                                        item.angle = parseInt(item.angle)
                                    })
                                }

                            }
                        },
                        error: function (error) {

                        }
                    })
                },

                //设置图片
                setElementImgSrc: function (data) {
                    var element = this.getCurrentElementById(this.currentRefId);
                    element.url = data.url;
                    this.$nextTick(function () {
                        this.setImageWidth(element)
                    })
                },

                //设置图片宽高
                setImageWidth: function (element) {
                    var id = element.id;
                    var imageBox = this.$refs[id][0];
                    var image = imageBox.querySelector('img');
                    var self = this;
                    var maxSize, maxWidth, maxHeight;
                    $(image).on('load', function () {
                        var img = this;
                        element.width = img.naturalWidth;
                        element.height = img.naturalHeight;
                        self.setControlSizesStyle(element);
                        maxSize = self.getMaxSize();
                        maxWidth = maxSize.maxWidth + 20;
                        maxHeight = maxSize.maxHeight + 20;
                        if (self.pageWidth < maxWidth) {
                            self.pageWidth = maxWidth;
                        }
                        if (self.pageHeight < maxHeight) {
                            self.pageHeight = maxHeight;
                        }

                        $(img).off('load');
                    })
                },

                //拉伸区域
                stretchNode: function ($event) {
                    var startX = $event.clientX;
                    var startY = $event.clientY;
                    var $target = $($event.target);
                    var direction = $target.attr('class');
                    var element = this.getCurrentElementById(this.currentRefId);
                    var angle = element.angle;
                    var byAngle = angle == 0 || angle == 180;
                    var startElement = {
                        width: element.width,
                        height: element.height,
                        left: element.x,
                        top: element.y
                    };
                    var self = this;
                    var downShiftKey = $event.shiftKey;

                    $(document).on('mousemove.resize.node', function (e) {
                        var moveX = e.clientX;
                        var moveY = e.clientY;
                        var dx = moveX - startX;
                        var dy = moveY - startY;
                        var fnKey = ('stretchNode' + direction.replace('resize ', '').toUpperCase());
                        self[fnKey] && self[fnKey].call(self, dx, dy, startElement, element, byAngle)
                    });

                    $(document).on('mouseup.resize.node', function (e) {
                        $(document).off('mousemove.resize.node');
                        $(document).off('mouseup.resize.node');
                    })
                },

                stretchNodeN: function (dx, dy, mousedownElement, element, byAngle, group) {
                    if (byAngle) {
                        element.height = mousedownElement.height - dy;
                        element.y = mousedownElement.top + dy;
                    } else {
                        if (group == 'nw') {

                            element.width = mousedownElement.width - dy;
                            element.x = mousedownElement.left + dx / 2 + dy / 2;
                            element.y = mousedownElement.top + dx / 2 + dy / 2;


                        } else if (group == 'ne') {
                            element.width = mousedownElement.width - dy;
                            element.x = mousedownElement.left + dx / 2 + dy / 2;
                            element.y = mousedownElement.top - dx / 2 + dy / 2;
                        } else {
                            element.width = mousedownElement.width - dy;
                            element.x = mousedownElement.left + dx / 2 + dy / 2;
                            element.y = mousedownElement.top - dx / 2 + dy / 2;
                        }

                    }
                    this.setControlSizesStyle(element);
                },

                stretchNodeE: function (dx, dy, mousedownElement, element, byAngle, group) {
                    if (byAngle) {
                        element.width = mousedownElement.width + dx;
                    } else {
                        if (group) {
                            element.height = mousedownElement.height + dx;
                        } else {
                            element.height = mousedownElement.height + dx;
                            element.x = mousedownElement.left + dx / 2 + dy / 2;
                            element.y = mousedownElement.top - dx / 2 + dy / 2;
                        }
                    }
                    this.setControlSizesStyle(element);
                },

                stretchNodeS: function (dx, dy, mousedownElement, element, byAngle, group) {
                    if (byAngle) {
                        element.height = mousedownElement.height + dy;
                    } else {
                        if (group == 'se') {

                            element.width = mousedownElement.width + dy;
                            element.x = mousedownElement.left + dx / 2 - dy / 2;
                            element.y = mousedownElement.top - dx / 2 + dy / 2;

                        } else if (group == 'sw') {
                            element.width = mousedownElement.width + dy;
                            element.x = mousedownElement.left + dx / 2 - dy / 2;
                            element.y = mousedownElement.top + dy / 2 + dx / 2;

                        } else {
                            element.width = mousedownElement.width + dy;
                            element.x = mousedownElement.left + dx / 2 - dy / 2;
                            element.y = mousedownElement.top + dx / 2 + dy / 2;
                        }

                    }

                    this.setControlSizesStyle(element);
                },

                stretchNodeW: function (dx, dy, mousedownElement, element, byAngle, group) {
                    if (byAngle) {
                        element.width = mousedownElement.width - dx;
                        element.x = mousedownElement.left + dx;
                    } else {
                        if (group) {
                            element.height = mousedownElement.height - dx;
                        } else {
                            element.height = mousedownElement.height - dx;
                            element.x = mousedownElement.left + dx / 2 - dy / 2;
                            element.y = mousedownElement.top + dx / 2 + dy / 2;
                        }
                    }

                    this.setControlSizesStyle(element);
                },

                stretchNodeNE: function (dx, dy, mousedownElement, element, byAngle) {
                    this.stretchNodeN(dx, dy, mousedownElement, element, byAngle, 'ne')
                    this.stretchNodeE(dx, dy, mousedownElement, element, byAngle, 'ne')
                },

                stretchNodeSE: function (dx, dy, mousedownElement, element, byAngle) {
                    this.stretchNodeS(dx, dy, mousedownElement, element, byAngle, 'se')
                    this.stretchNodeE(dx, dy, mousedownElement, element, byAngle, 'se')
                },

                stretchNodeSW: function (dx, dy, mousedownElement, element, byAngle) {
                    this.stretchNodeS(dx, dy, mousedownElement, element, byAngle, 'sw')
                    this.stretchNodeW(dx, dy, mousedownElement, element, byAngle, 'sw')
                },

                stretchNodeNW: function (dx, dy, mousedownElement, element, byAngle) {
                    this.stretchNodeN(dx, dy, mousedownElement, element, byAngle, 'nw')
                    this.stretchNodeW(dx, dy, mousedownElement, element, byAngle, 'nw')
                },

                //通过ID找到当前selected的元素
                getCurrentElementById: function (id) {
                    var elements = this.elements;
                    var curElement;
                    for (var i = 0, len = elements.length; i < len; i++) {
                        var element = elements[i];
                        if (element.id === id) {
                            curElement = element;
                            break;
                        }
                    }
                    return curElement;
                },

                upperCaseKey: function (key) {
                    return key.replace(/^\w{1}/, function ($1) {
                        return $1.toUpperCase()
                    })
                },

                //获取最大的index;
                getMaxZIndex: function () {
                    var sorts = [0];
                    this.elements.forEach(function (t) {
                        sorts.push(t.sort);
                    });
                    return Math.max.apply(Math, sorts)
                },

                //添加一个元素
                pushElement: function () {
                    var elementDefault = this.getElementDefault();
                    var dynamicParams = this.getDynamicParams();
                    elementDefault = $.extend(elementDefault, this.draggableElements[this.draggableKey], dynamicParams);
                    this.elements.push(elementDefault)
                    return elementDefault;
                },

                //动态参数
                getDynamicParams: function () {
                    var id = this.getElementId();
                    var maxZIndex = this.getMaxZIndex();
                    var scroll = this.getCertPaperScroll();
                    maxZIndex += 1;
                    return {
                        id: id,
                        x: this.draggableElement.x - this.certContainerPadding + scroll.scrollLeft,
                        y: this.draggableElement.y - 168 + scroll.scrollTop,
                        sort: maxZIndex
                    }
                },

                //获取paper的scroll
                getCertPaperScroll: function () {
                    var $certPaperScroller = $(this.$refs.certPaperScroller);
                    return {
                        scrollLeft: $certPaperScroller.scrollLeft(),
                        scrollTop: $certPaperScroller.scrollTop()
                    }
                },

                getElementId: function () {
                    var id = this.uuids[0];
                    this.uuids.splice(0, 1);
                    return id;
                },
                getUUIds: function (num) {
                    var self = this;
                    this.uuids = [];
                    for (var i = 0, len = num; i < len; i++) {
                        this.uuids.push('UU' + (Math.ceil(Math.random() * 10000) + new Date().getTime()))
                    }
                    return false;
                    <%--return $.ajax({--%>
                    <%--url: '${ctx}/sys/uuids/' + num,--%>
                    <%--type: 'GET',--%>
                    <%--success: function (data) {--%>
                    <%--if (data.status) {--%>
                    <%--self.uuids = self.uuids.concat(JSON.parse(data.id));--%>
                    <%--}--%>
                    <%--}--%>
                    <%--});--%>
                },

                //默认元素
                getElementDefault: function () {
                    return {
                        id: '',
                        x: '',
                        y: '',
                        width: '',
                        height: '',
                        angle: 0,
                        matrix: 'transform(1,0,0,1,0,0)',
                        elementType: '',
                        fillOpacity: '',
                        sort: '',
                        text: '',
                        url: '',
                        varCol: '',
                        repeat: '',
                        color: 'rgb(51,51,51)',
                        fontSize: '',
                        fontStyle: '',
                        fontWeight: '',
                        textDecoration: '',
//                        lineHeight: 1.4,
                        fontFamily: "微软雅黑"
                    }
                },

                controlPaperSize: function ($event) {
                    var pageWidth = this.pageWidth;
                    var pageHeight = this.pageHeight;
                    var startX = $event.clientX;
                    var startY = $event.clientY;
                    var self = this;
                    var maxSize = this.getMaxSize();
                    var maxWidth = maxSize.maxWidth;
                    var maxHeight = maxSize.maxHeight;
                    this.fakePaper.width = pageWidth;
                    this.fakePaper.height = pageHeight;
                    this.fakePaperShow = true;
                    $(document).on('mousemove.control.page', function (e) {
                        var x = e.clientX;
                        var y = e.clientY;
                        self.fakePaper.width = Math.max(pageWidth + (x - startX), maxWidth);
                        self.fakePaper.height = Math.max(pageHeight + (y - startY), maxHeight);
                    })

                    $(document).on('mouseup.control.page', function (e) {
                        $(document).off('mousemove.control.page')
                        $(document).off('mouseup.control.page')
                        self.fakePaperShow = false;
                        self.pageWidth = self.fakePaper.width;
                        self.pageHeight = self.fakePaper.height;
                    })
                },


                setCertHeaderHeight: function () {
                    this.certHeaderHeight = this.$refs.certHeader.offsetHeight
                },

                setCertContainerPadding: function () {
                    this.certContainerPadding = window.getComputedStyle(this.$el).paddingLeft.replace('px', '') * 1;
                },
                //设置背景板默认高度
                setDefaultCertContainerSize: function () {
                    var element = this.$refs.certPaperScroller;
                    var width = $(element).width();
                    var height = $(element).height();
                    this.setPaperSize(width, height);
                },

                setPaperSize: function (width, height) {
                    this.pageWidth = width - 40;
                    this.pageHeight = height - 40;
                }


            },
            beforeMount: function () {
                this.getUUIds(10);
                this.certpageid && this.getCertPage();
            },
            mounted: function () {
                this.setCertHeaderHeight();
                this.setCertContainerPadding();
                this.setDefaultCertContainerSize();
                $('[data-toggle="tooltip"]').tooltip({
                    placement: 'bottom',
                    container: 'body'
                })


            }
        })

    }(jQuery, Vue)

</script>

</body>
</html>