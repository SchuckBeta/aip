<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <!-- <meta name="decorator" content="default"/> -->
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <link rel="stylesheet" href="${ctxStatic}/cropper/cropper.min.css">
    <script src="${ctxStatic}/cropper/cropper.min.js"></script>

    <script src="${ctxStatic}/vue/vue.min.js"></script>
    <script src="${ctxStatic}/snap/snap.svg-min.js"></script>
    <%--<script src="/js/actyw/flowDesign/node.js?v=1"></script>--%>

    <script src="/js/actyw/flowDesign/groupNode.js?v=122"></script>
    <script src="/js/actyw/flowDesign/v-panning.js?v=11"></script>
    <script src="/js/actyw/flowDesign/generate-node-shape.js?v=15011111"></script>
    <script src="/js/actyw/flowDesign/selectMultiple.component.js?v=1111111111110"></script>
    <script src="/js/actyw/flowDesign/selectMultipleStatus.component.js?v=2011111"></script>
    <script src="/js/actyw/flowDesign/selectStatusAdd.component.js?v=210211"></script>
    <script src="/js/actyw/flowDesign/uploaderIcon.component.js"></script>
    <script src="/js/actyw/flowDesign/path.component.js?v=2211111111"></script>
    <script src="/js/actyw/flowDesign/startNoneEvent.component.js?v=12"></script>
    <script src="/js/actyw/flowDesign/endNoneEvent.component.js?v=12"></script>
    <%--<script src="/js/actyw/flowDesign/endErrorEvent.component.js?v=101"></script>--%>

    <script src="/js/actyw/flowDesign/endTerminateEvent.component.js"></script>
    <script src="/js/actyw/flowDesign/userTask.component.js?v=1211"></script>
    <script src="/js/actyw/flowDesign/subProcess.component.js?v=2111"></script>
    <script src="/js/actyw/flowDesign/exclusiveGateway.component.js?v=121111111111111"></script>
    <script src="/js/actyw/flowDesign/eventGateway.component.js?v=29"></script>
    <script src="/js/actyw/flowDesign/flowDesign.js?v=10110212"></script>
    <style>
        @font-face {
            font-family: 'iconfont';  /* project id 482029 */
            src: url('//at.alicdn.com/t/font_482029_zrcpe9kb3a98uxr.eot');
            src: url('//at.alicdn.com/t/font_482029_zrcpe9kb3a98uxr.eot?#iefix') format('embedded-opentype'),
            url('//at.alicdn.com/t/font_482029_zrcpe9kb3a98uxr.woff') format('woff'),
            url('//at.alicdn.com/t/font_482029_zrcpe9kb3a98uxr.ttf') format('truetype'),
            url('//at.alicdn.com/t/font_482029_zrcpe9kb3a98uxr.svg#iconfont') format('svg');
        }

        html, body, .rd-app {
            position: relative;
            width: 100%;
            height: 100%;
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            -webkit-user-select: none;
            -moz-user-select: -moz-none;
            user-select: none;
        }

        .rd-stencil .rds-content .shape-elements {
            padding-left: 18px;
        }

        .tooltip.show {
            opacity: 1;
            filter: alpha(opacity=100);
        }

        .tooltip.left {
        }


    </style>
</head>
<body>
<div id="flowDesign" class="rd-app flow-rd-app">
    <div class="rd-header">
        <div class="rd-title" style="width: 275px; padding-left: 15px;">
            <h3 v-show="groupName" style="display: none;text-align:left;">{{groupName}}</h3>
        </div>
        <div class="toolbar-container">
            <div class="rd-toolbar-group">
                <%--${ctx}/actyw/actYwGnode/${group.id}/view--%>
                <%--<a href="javascript:void (0)" @click="downFlowPic">下载流程图</a>--%>
                <%--<button class="btn btn-primary" @click="saveNodeList(true,false)">预览</button>--%>
                <%--<a href="javascript:void (0)">导出PNG</a>--%>
            </div>
            <%--<div class="rd-toolbar-group">--%>
            <%--<a href="javascript: void (0)" @click="fullScreen" data-toggle="tooltip" data-placement="bottom"--%>
            <%--title="全屏显示" data-original-title="切换全屏显示"><i--%>
            <%--class="iconfont">&#xe676;</i></a>--%>
            <%--</div>--%>
            <div class="rd-toolbar-group" style="display: none">
                <a href="javascript: void (0)" data-toggle="tooltip" data-placement="bottom"
                   title="" data-original-title="适应屏幕"><i
                        class="iconfont">&#xe600;</i></a>
            </div>
            <div class="rd-toolbar-group" style="display: none">
                <span class="label-zoom">缩放</span>
                <input class="zoom" v-model="zoom" type="range" max="300" min="20" step="20" @change="changeZoom">
                <output>{{zoom}}</output>
                <span>%</span>
            </div>
            <div class="rd-toolbar-group" style="display: none">
                <span class="label-zoom">网格大小</span>
                <input class="zoom" v-model="grid" type="range" max="20" min="1" step="1">
                <output>{{grid}}</output>
            </div>
        </div>
        <div class="btn-group btn-group-small pull-right">
            <button type="button" class="btn btn-default" :disabled="saveIng" @click="clearPaper">清空画布</button>
            <%--<button  type="button" class="btn btn-primary flow-preview" @click.stop="saveNodeList(true,false)">预览</button>--%>
            <button type="button" class="btn btn-primary" :disabled="saveIng"
                    @click="saveNodeList(true,true)">保存
            </button>
            <button type="button" :disabled="saveIng"
                    @click="saveNodeList()"
                    class="btn btn-primary">提交
            </button>
            <button type="button" class="btn btn-default" :disabled="saveIng" @click="history.go(-1)">返回</button>
        </div>
        <%--<div class="btn-group pull-right">--%>
        <%--<button type="button" class="btn btn-default" @click="location.reload()">刷新</button>--%>
        <%--</div>--%>
    </div>
    <div class="rd-body">
        <div class="stencil-container">
            <div class="rd-stencil rd-stencil-iconLess">
                <div class="rds-content">
                    <group-node v-if="taskNodes.length > 0" title="任务节点" e-height="267px">
                        <svg slot="svg" v-generate-node="{nodeList: taskNodes, hasUser: false}" version="1.1"
                             width="100%" height="100%" xmlns="http://www.w3.org/2000/svg"
                             xmlns:xlink="http://www.w3.org/1999/xlink">
                        </svg>
                    </group-node>
                    <group-node title="子流程" v-if="processNodes.length > 0" e-height="102px">
                        <svg slot="svg" v-generate-node="{nodeList: processNodes}" version="1.1" width="100%"
                             height="100%" xmlns="http://www.w3.org/2000/svg"
                             xmlns:xlink="http://www.w3.org/1999/xlink">
                        </svg>
                    </group-node>
                    <group-node title="网关" v-if="gatewayNodes.length > 0" e-height="100px">
                        <svg slot="svg" v-generate-node="{nodeList: gatewayNodes}" version="1.1" width="100%"
                             height="100%" xmlns="http://www.w3.org/2000/svg"
                             xmlns:xlink="http://www.w3.org/1999/xlink">
                        </svg>
                    </group-node>
                </div>
            </div>
        </div>
        <div class="paper-container" style="background-color: #ccc;right: 250px;left: 190px;">
            <div class="paper-scroller" v-panning="{left: panningLeft, top: panningTop}" data-cursor="grab">
                <div class="paper-scroller-background"
                     :style="{width: viewportBack.width+'px', height: viewportBack.height+'px'}">
                    <div class="rd-viewport"
                         :style="{width: viewport.width+'px', height: viewport.height+'px', left: viewport.left + 'px', top: viewport.top + 'px'}">
                        <div class="rd-paper-background"></div>
                        <div class="rd-paper-grid"></div>
                        <svg id="flowDesignSvg" v-design-paper version="1.1" width="100%" height="100%"
                             xmlns="http://www.w3.org/2000/svg"
                             xmlns:xlink="http://www.w3.org/1999/xlink"></svg>
                        <div>
                            <div tabindex="0" class="rd-free-transform" :class="{show: rdFreeShow}"
                                 @keyup.delete="deleteLinkNode($event)" ref="rdFreeEle" :style="rdFreeStyle">
                                <div draggable="false" class="resize nw" data-position="top-left"
                                     @mousedown="stretchNode($event)"></div>
                                <div draggable="false" class="resize n" data-position="top"
                                     @mousedown="stretchNode($event)"></div>
                                <div draggable="false" class="resize ne" data-position="top-right"
                                     @mousedown="stretchNode($event)"></div>
                                <div draggable="false" class="resize e" data-position="right"
                                     @mousedown="stretchNode($event)"></div>
                                <div draggable="false" class="resize se" data-position="bottom-right"
                                     @mousedown="stretchNode($event)"></div>
                                <div draggable="false" class="resize s" data-position="bottom"
                                     @mousedown="stretchNode($event)"></div>
                                <div draggable="false" class="resize sw" data-position="bottom-left"
                                     @mousedown="stretchNode($event)"></div>
                                <div draggable="false" class="resize w" data-position="left"
                                     @mousedown="stretchNode($event)"></div>
                                <!--<div draggable="false" class="rotate"></div>-->
                            </div>
                            <div class="rd-halo surrounding type-element animate" :class="{show: rdHaloShow}"
                                 :style="rdHaloStyle">
                                <div class="handles">
                                    <%--<div class="handle rotate ne" data-action="clone" draggable="false"--%>
                                    <%--data-toggle="tooltip" data-placement="right" title="旋转"--%>
                                    <%--data-original-title="Tooltip on bottom">--%>
                                    <%--<i class="iconfont">&#xe62c;</i></div>--%>
                                    <div class="handle fork ne" data-action="fork" draggable="false"
                                         data-toggle="tooltip" data-placement="right" title="删除"
                                         data-original-title="Tooltip on bottom" @mousedown.stop.prevent
                                         @click="deleteLinkNode($event)">
                                        <i class="iconfont">&#xe625;</i>
                                    </div>
                                    <div class="handle link e" data-action="link" draggable="false"
                                         data-tooltip-class-name="small"
                                         data-tooltip="Click and drag to connect the object"
                                         data-tooltip-position="left" data-tooltip-padding="15"
                                         title="连接节点"
                                         @mousedown="connect($event)"></div>
                                </div>
                            </div>
                            <div class="rd-addable" :class="{show: addableShow}" :style="addableStyle">
                                <span class="addable nw" :class="{disabled: addable}"><i class="iconfont"></i></span>
                                <span class="addable ne" :class="{disabled: addable}"><i class="iconfont"></i></span>
                                <span class="addable se" :class="{disabled: addable}"><i class="iconfont"></i></span>
                                <span class="addable sw" :class="{disabled: addable}"><i class="iconfont"></i></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div ref="rdInspector" class="inspector-container inspector-container-iconLess" style="width: 250px;">
            <div class="rd-inspector">
                <start-none-event v-show="startNoneEventShow" ref="startNoneEvent" v-model="startNoneEvent"
                                  @change-node-name="changeNodeName"></start-none-event>
                <end-none-event v-show="endNoneEventShow" ref="endNoneEvent" v-model="endNoneEvent"
                                @change-node-name="changeNodeName"></end-none-event>

                <end-terminate-event v-show="endTerminateEventShow" ref="endTerminateEvent" v-model="endTerminateEvent"
                                     @change-node-name="changeNodeName"></end-terminate-event>

                <user-task v-show="userTaskShow" ref="userTask" v-model="userTask"
                           :roles="taskRoles"
                           :users="users"
                           :reg-types="regTypes"
                           :list-form="isListForm"
                           :has-users="false"
                           :task-types="taskTypes"
                           :student-id="studentId"
                           @filter-reg-type="changeRegType"
                           @parse-label="parseLabel"
                           @leave-label="leaveLable"
                <%--:has-condition="userTask."--%>
                           @change-node-name="changeNodeName"
                           @open-modal="openNodeIconModal">
                    <%--<div slot="listForm">--%>
                        <%--<select-multiple :list="taskListForm" :selected-list="userTask.formListIds"--%>
                                         <%--@select="selectListForms"--%>
                                         <%--:filter-able="!roleGroup"--%>
                                         <%--:is-many="false" placeholder="添加表单"></select-multiple>--%>
                    <%--</div>--%>
                    <div slot="form">
                        <select-multiple :list="taskForms" :reg-type="userTask.regType"
                                         :selected-list="userTask.formNlistIds" @select="selectNlistForms"
                                         :filter-able="!roleGroup || !userTask.regType"
                                         :is-many="false" placeholder="请先选择审核类型和角色"></select-multiple>
                    </div>
                    <div slot="roles">
                        <select-multiple :list="taskRoles" :selected-list="userTask.roleIds"
                                         @select="selectRoles" placeholder="请选择用户角色"></select-multiple>
                    </div>
                    <div slot="users">
                        <select-multiple :list="users" :selected-list="userTask.userIds" @select="selectUsers"
                                         :is-many="false"
                                         placeholder="添加角色"></select-multiple>
                    </div>
                    <%--<div slot="condition">--%>
                    <%--<select-multiple-status--%>
                    <%--:list="gStatus"--%>
                    <%--:is-many="false"--%>
                    <%--:has-un-list="false"--%>
                    <%--:selected-list="exclusiveGateway.statusIds"--%>
                    <%--@select="selectStatus" placeholder="选择条件名">--%>
                    <%--</select-multiple-status>--%>
                    <%--</div>--%>
                </user-task>
                <sub-process v-show="subProcessShow" ref="subProcess" v-model="subProcess"
                             @change-node-name="changeNodeName"
                             @open-modal="openNodeIconModal"
                             @parse-label="parseLabel"
                             @leave-label="leaveLable">
                    <div slot="form">
                        <select-multiple :list="groupForms" :selected-list="subProcess.formIds" @select="selectForms"
                                         :is-many="false" placeholder="请输入表单名搜索"></select-multiple>
                    </div>
                </sub-process>
                <exclusive-gateway v-show="exclusiveGatewayShow" ref="exclusiveGateway" v-model="exclusiveGateway"
                                   :node-status-types="nodeStatusTypes"
                                   :reg-type-name="prevRegTypeName"
                                   :node-name="prevNodeName"
                                   :prev-model-key="prevModelKey"
                                   :reg-type-value="prevRegTypeValue"
                                   @parse-label="parseLabel"
                                   @leave-label="leaveLable"
                                   @change-node-name="changeNodeName"
                                   @open-judge-modal="openJudgeModal"
                                   @change-g-status-type="changeGStatusType"
                                   @open-modal="openNodeIconModal">
                    <%--<div slot="form">--%>
                    <%--<select-multiple :list="forms" :selected-list="exclusiveGateway.formIds" @select="selectForms"--%>
                    <%--:is-many="false" placeholder="请输入表单名搜索"></select-multiple>--%>
                    <%--</div>--%>
                    <div slot="otherType">
                        <select-multiple :list="clazzIds" :selected-list="exclusiveGateway.clazzIds"
                                         placeholder="选择条件类型"
                                         @select="selectOtherType"></select-multiple>
                    </div>
                    <div slot="gStatus">
                        <select-status-add
                                :list="gStatus"
                                :is-many="false"
                                :reg-type="conditionType"
                                :selected-list="exclusiveGateway.statusIds"
                                @select="selectStatus"
                                @un-select="deleteStatus"
                                @open-condition="openConditionModel">
                        </select-status-add>
                    </div>
                </exclusive-gateway>
                <event-gateway v-show="eventGatewayShow" ref="eventGateway" v-model="eventGateway"
                               :node-status-types="nodeStatusTypes"

                               @change-node-name="changeNodeName"
                               @change-g-status-type="changeGStatusType"
                               @open-modal="openNodeIconModal">
                    <%--<div slot="form">--%>
                    <%--<select-multiple :list="forms" :selected-list="eventGateway.formIds" @select="selectForms"--%>
                    <%--:is-many="false" placeholder="请输入表单名搜索"></select-multiple>--%>
                    <%--</div>--%>
                    <div slot="gStatus">
                        <select-multiple-status
                                :list="gStatus"
                                :is-many="false"
                                :has-un-list="false"
                                :selected-list="eventGateway.statusIds"
                                @select="selectStatus" placeholder="选择条件名">
                        </select-multiple-status>
                    </div>
                </event-gateway>
                <sequence-flow v-show="sequenceFlowShow" ref="sequenceFlow" v-model="sequenceFlow"
                               :has-condition="showSelectedCondition"
                               :conditions="conditions">
                    <div slot="condition">
                        <select-multiple-status
                                :list="conditions"
                                :selected-list="sequenceFlow.statusIds"
                                @select="selectSequence" placeholder="选择条件名">
                        </select-multiple-status>
                    </div>
                </sequence-flow>
            </div>
        </div>
    </div>
    <div class="stencil-paper-drag" v-show="toPaperData.show" :style="toPaperData.style">
        <svg id="movePaper" version="1.1" width="100%" height="100%" xmlns="http://www.w3.org/2000/svg"
             xmlns:xlink="http://www.w3.org/1999/xlink"></svg>
    </div>
    <div v-show="modalShow" style="position: fixed;width: 100%;height: 100%;top: 0;left: 0;display: none;z-index: 100">
        <div v-drag class="modal modal-upload-icon" data-backdrop="static">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true" @click="modalShow = false">
                    &times;
                </button>
                <h3 class="modal-title">更换图标</h3>
            </div>
            <div class="modal-body">
                <ul class="nav nav-tabs">
                    <li :class="{active: tabActive}"><a href="javascript:void(0);" @click="tabActive = true">默认图片</a>
                    </li>
                    <li :class="{active: !tabActive}"><a href="javascript:void(0);" @click="tabActive = false">本地图片</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane" :class="{active: tabActive}">
                        <div class="node-icons-container">
                            <ul v-show="iconLoad" class="node-icons">
                                <li v-for="(item, index) in nodeIcons" class="node-icon-item">
                                    <a href="javascript: void(0);" @click="selectNodeIcon(item)"><img
                                            :src="item.ftpUrl"> </a>
                                </li>
                            </ul>
                            <p v-show="!iconLoad" style="margin: 60px 0" class="text-center">图标加载中...</p>
                        </div>

                    </div>
                    <div class="tab-pane" :class="{active: !tabActive}">
                        <div class="tab-pane-copper">
                            <img v-cropper class="copper-icon" :src="copperIcon">
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <!--<div class="upload-image-box" v-show="!tabActive">-->
                <!--<input title="" type="file">-->
                <!--<button type="button" class="btn btn-primary" v-show="!tabActive">本地图片</button>-->
                <!--</div>-->
                <uploader-icon :active="!tabActive" @local-image="changeNodeIcon"></uploader-icon>
                <button type="button"
                        :disabled="copperIcon == copperDefault" class="btn btn-primary"
                        v-show="!tabActive" @click="uploadIcon($event)">上传
                </button>
                <button type="button" class="btn btn-default" v-show="tabActive" @click="modalShow = false">取消</button>
            </div>
        </div>
        <div class="modal-backdrop" v-show="modalShow" style="display: none;opacity: 0"></div>
    </div>
    <div v-show="modelConditionShow"
         style="position: fixed;width: 100%;height: 100%;top: 0;left: 0;display: none;z-index: 100">
        <div v-drag class="modal model-condition" data-backdrop="static">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true"
                        @click="modelConditionShow = false">
                    &times;
                </button>
                <h3 class="modal-title">添加条件状态</h3>
            </div>
            <div class="modal-body">
                <form v-validate="{form: 'conditionValidateForm'}" class="form-horizontal" autocomplete="off">
                    <div class="control-group">
                        <label class="control-label">条件类型：</label>
                        <div class="controls">
                            <p class="control-static">{{conditionForm.gtypeName}}</p>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label"><i>*</i>名称：</label>
                        <div class="controls">
                            <input type="text" v-model="conditionForm.state" autocomplete="off" name="state"
                                   class="required" maxlength="10">
                        </div>
                    </div>
                    <div class="control-group" v-if="conditionForm.regtype == 2">
                        <label class="control-label"><i>*</i>范围 ：</label>
                        <div class="controls condition-range">
                            <div v-show="conditionForm.startNum < 100" style="width: 220px;">
                                <input type="range" :min="conditionForm.startNum" max="100" step="1"
                                       v-model="conditionValue" name="conditionVal" class="ignore hidden">
                                <p class="control-static">{{conditionForm.startNum}}-{{conditionValue}}</p>
                            </div>
                            <div class="control-static gray-color" v-show="conditionForm.startNum == 100">
                                没有可添加的范围，请删除最大值为100的条件
                            </div>
                            <%--<div>--%>
                            <%--<input type="text" v-model="conditionForm.startNum" name="startNum" maxlength="3"--%>
                            <%--autocomplete="off"--%>
                            <%--class="input-mini required number digits firstNoZero"> ---%>
                            <%--<input type="text" v-model="conditionForm.endNum" name="endNum" maxlength="3"--%>
                            <%--autocomplete="off"--%>
                            <%--class="input-mini required number digits firstNoZero">--%>
                            <%--</div>--%>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">备注：</label>
                        <div class="controls">
                            <textarea name="remarks" v-model="conditionForm.remarks"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-default btn" @click="modelConditionShow = false">取消</button>
                <button type="button"
                        :disabled="isConditionSave || conditionForm.startNum >= 100 || conditionForm.startNum == conditionValue"
                        class="btn-primary btn" @click="saveCondition">
                    {{isConditionSave? '保存中...' : '保存'}}
                </button>
            </div>
        </div>
        <div class="modal-backdrop" v-show="modelConditionShow" style="display: none;opacity: 0"></div>
    </div>
    <div v-show="modelJudgeShow"
         style="position: fixed;width: 100%;height: 100%;top: 0;left: 0;display: none;z-index: 100">
        <div v-drag class="modal model-condition" data-backdrop="static">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true"
                        @click="modelJudgeShow = false">
                    &times;
                </button>
                <h3 class="modal-title">添加判定类型</h3>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" v-validate="{form: 'judgeFormValid'}" autocomplete="off">
                    <div class="control-group">
                        <label class="control-label"><i>*</i>判定类型名称：</label>
                        <div class="controls">
                            <input type="text" name="name" v-model="judgeForm.name" class="required">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label"><i>*</i>网关类型：</label>
                        <div class="controls">
                            <select name="regType" v-model="judgeForm.regType" class="required">
                                <option value="">-请选择-</option>
                                <option v-for="(item, index) in regTypes" :key="item.id" :value="item.id">
                                    {{item.name}}
                                </option>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-default btn" @click="modelJudgeShow = false">取消</button>
                <button type="button"
                        :disabled="judgeSaveing"
                        class="btn-primary btn" @click="saveRegTypes">
                    {{judgeSaveing? '保存中...' : '保存'}}
                </button>
            </div>

        </div>
        <div class="modal-backdrop" v-show="modelJudgeShow" style="display: none;opacity: 0"></div>
    </div>

    <div ref="tooltip" class="tooltip hide" :class="tooltip.className" role="tooltip" :style="tooltip.style">
        <div class="tooltip-arrow"></div>
        <div class="tooltip-inner">
            {{tooltip.text}}
        </div>
    </div>

</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>


</body>

<script>
    +function ($) {


        var flowDesignPaper = new FlowDesignPaper();
        var flowDesign = new Vue({
            el: '#flowDesign',
            data: function () {
                return {
                    studentId: '${frontUid}',
                    isStudent: false,
                    rootId: '${root}',
                    nodeEtypes: '',
                    proType: '${group.type}', //项目类型
                    groupName: '${group.name}',
                    groupId: '${group.id}',
                    isListForm: true,
                    listForm: [],
                    saveIng: false,
                    taskNodes: [],
                    processNodes: [],
                    gatewayNodes: [],
                    groupNodeTaskStyle: {
                        height: '300px'
                    },
                    toPaperData: {
                        show: false,
                        style: {}
                    },
                    movePaper: '',
                    moveClone: '',
                    panningLeft: 0,
                    panningTop: 0,
                    designPaper: '',
                    overallGroup: '',
                    viewport: {
                        width: '',
                        height: '',
                        left: 0,
                        top: 0
                    },
                    viewportMin: {
                        width: '',
                        height: ''
                    },
                    viewportBack: {
                        width: '',
                        height: ''
                    },
                    stencilWidth: 190,
                    headerTop: 60,
                    flowDesignPaper: flowDesignPaper,
                    zoom: 100,
                    grid: 1,
                    addDistance: 500,
                    $paperScroll: null,
                    paper: {
                        width: '',
                        height: ''
                    },
                    paperContainer: {
                        minWidth: '',
                        minHeight: ''
                    },
                    rdFreeShow: false,
                    rdFreeStyle: {
                        width: '',
                        height: '',
                        left: '',
                        top: ''
                    },
                    rdHaloShow: false,
                    rdHaloStyle: {
                        width: '',
                        height: '',
                        left: '',
                        top: ''
                    },
                    addableShow: false,
                    addable: false,
                    addableStyle: {
                        width: '',
                        height: '',
                        left: '',
                        top: ''
                    },
                    clazzIds: [],
                    //默认的matrix
                    overallMatrix: new Snap.matrix(),
                    lineDefaultData: {},
                    currentNodeEle: '',
                    startNoneEvent: {},
                    startNoneEventShow: false,
                    endNoneEvent: {},
                    endNoneEventShow: false,
                    endTerminateEvent: {},
                    endTerminateEventShow: false,
                    userTask: {},
                    userTaskShow: false,
                    subProcess: {},//子流程数据
                    subProcessShow: false,
                    exclusiveGateway: {},
                    exclusiveGatewayShow: false,
                    eventGatewayShow: false,
                    eventGateway: {},
                    sequenceFlow: {},
                    sequenceFlowShow: false,
                    modelKeys: [],
                    roles: [],
                    users: [],
                    forms: [],
                    conditions: [],
                    nodeStatusTypes: [],
                    groupForms: [],
                    modalShow: false,
                    tabActive: true,
                    nodeIcons: [],
                    iconLoad: false,
                    dataKey: '',
                    copperIcon: '/images/upload-default-image100X100.png',
                    copperDefault: '/images/upload-default-image100X100.png',
                    cropper: null,
                    iconFile: '',
                    fileUrl: $frontOrAdmin + '/ftp/ueditorUpload/cutImg?folder=ueditor&x={{x}}&y={{y}}&width={{width}}&height={{height}}', //图片上传地址
                    uuid: '',
                    currentUUid: '',
                    uuids: [],  //获取的uuids数组
                    flowNodes: [],
                    nodeModelType: '',
                    taskTypes: [],
                    gStatus: [],
                    statusIds: [],
                    gNodeTypes: [],
                    connections: [], //移动的时候所有线的集合
                    removeNodes: [], //删除节点的数组
                    startNoneEventTypes: '110, 210', //开始节点节点类型
                    typeRules: {  //控制线能连接哪些节点规则
                        '110': [150, 190],
                        '130': [],
                        '140': [130, 150, 140, 190],
                        '150': [130, 150, 140, 190],
                        '190': [130, 150, 140, 190],
                        '210': [250, 290],
                        '230': [],
                        '240': [230, 250, 240, 290],
                        '250': [230, 250, 240, 290],
                        '290': [230, 250, 240, 290]
                    },
                    modelConditionShow: false,
                    conditionForm: {
                        state: '',
                        startNum: 0,
                        endNum: '',
                        alias: '',
                        remarks: '',
                        gtypeName: '',
                        regtype: '',
                        gtype: '' //
                    },
                    conditionValue: 60,
                    conditionValidateForm: '',
                    isConditionSave: false,
                    allNodeTypes: {},
                    regValidFlow: /^110{1}.120{1}.(([(^110)|(120)|(150)|(190)|(130)|(140)]+(120|130|.))*.?)(130|120)$/,
                    regValidSubFlow: /^210{1}.220{1}.(([(^210)|(220)|(250)|(290)|(230)|(240)]+(220|230|.))*.?)(220|230)$/,
                    parentIdList: [],
                    allNodesLen: 0,
                    allIdsLen: 0,
                    conditionType: '',
                    nextNodes: [],
                    showSelectedCondition: false,
                    gatewayErrorMegs: {
                        noneOut: '条件没有被使用，或者存在未被使用的条件，请检查',
                        noneComplete: '后面最少需要有两条线'
                    },
                    judgeForm: {
                        regType: '',
                        name: '',
                    },
                    modelJudgeShow: false,
                    judgeFormValid: '',
                    regTypes: [],
                    judgeSaveing: false,
                    prevRegTypeName: '',
                    prevNodeName: '',
                    prevModelKey: '',
                    prevRegTypeValue: '',
                    tooltip: {
                        show: false,
                        text: '123',
                        className: '',
                        style: {
                            left: '',
                            top: ''
                        }
                    },
                    labelMsges: {
                        userTaskType: '并行：同时进行；签收：指定受理人',
                        userTaskListForm: '发布项目的后台审核的列表页面',
                        userTaskRegType: '用于过滤审核表单（如.秘书审核）和评分（如.专家打分）',
                        userTaskForm: '根据筛选表单类型，该列表只显示单一类型的表单',
                        exclusiveGatewayOtherType: '某一审核处需要使用之前的某一审核结果自动去判断处理审核业务',
                        exclusiveGatewayGStatus: '表示审核结果的具体项（如：立项审核结果有,通过、不通过）',
                        exclusiveGatewayRegTypeName: '流程审核时，有那几种审核结果分类（如：立项审核结果有,审核通过-即通过，审核不通过-即不通过）',
                        exclusiveGatewayRegType: '根据筛选表单类型，该列表只显示单一类型的表单',
                        subProcessForm: '根据筛选表单类型，该列表只显示单一类型的表单'
                    },
                    roleGroup: '',
                    nodeDataUserTask: {}
                }
            },
            computed: {
                taskRoles: {
                    get: function () {
                        var roleGroup = this.roleGroup;
                        if (!roleGroup) {
                            return this.roles;
                        }
                        return this.roles.filter(function (item) {
                            return item.roleGroup === roleGroup;
                        })
                    }
                },
                taskListForm: {
                    get: function () {
                        var roleGroup = this.roleGroup;
                        if (!this.roleGroup) {
                            return this.listForm;
                        }
                        return this.listForm.filter(function (item) {
                            return item.clientType === roleGroup;
                        })
                    }
                },
                taskForms: {
                    get: function () {
                        var roleGroup = this.roleGroup;
                        var self = this;
                        if (!this.roleGroup) {
                            return this.forms;
                        }
                        return this.forms.filter(function (item) {
                            return self.nodeDataUserTask.regType == item.sgtype;
                        })
                    }
                }

            },

            directives: {
                drag: {
                    inserted: function (element, binding, vnode) {
                        $(element).draggable({
                            handle: ".modal-header",
                            containment: "body"
                        })
                    }
                },
                cropper: {
                    inserted: function (element, binding, vnode) {
                        vnode.context.cropper = $(element).cropper({
                            aspectRatio: 1,
                            viewMode: 1,
                            minWidth: 100,
                            minHeight: 100,
                            minCropBoxHeight: 100,
                            minCropBoxWidth: 100,
                            zoomOnWheel: false
                        })
                    }
                },
                validate: {
                    inserted: function (element, binding, vnode) {
                        vnode.context[binding.value.form] = $(element).validate({
                            rules: {
                                conditionVal: {
                                    required: false,
                                    max: 101,
                                    min: -1,
                                    range: [-1, 101]
                                }
                            },
                            ignore: '.ignore',
                            errorPlacement: function (error, element) {
                                if ((/startNum|endNum/).test(element.attr('name'))) {
                                    error.appendTo(element.parent().parent());
                                } else {
                                    error.insertAfter(element);
                                }
                            },
                            submitHandler: function (form) {
                                if (binding.value.form === 'conditionValidateForm') {
                                    vnode.context.saveCondition();
                                } else {
                                    vnode.context.saveRegTypes();
                                }
                                return false;
                            }
                        })
                    }
                }
            },
            watch: {
                'viewport': {
                    deep: true,
                    handler: function (value) {
                        this.viewportBack = {
                            width: value.width + value.left * 2,
                            height: value.height
                        }

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
            methods: {
                fullScreen: function () {

                },
                selectOtherType: function () {

                },

                parseLabel: function (obj) {
                    var type = obj.type;
                    var $target = obj.$target;
                    var self = this;
                    var $rdInspector = $(this.$refs.rdInspector)
                    var left = $rdInspector.offset().left;
                    var $tooltip = $(this.$refs.tooltip)
                    var top = $target.offset().top;
                    this.tooltip.text = this.labelMsges[type];
                    this.tooltip.className = "left show";
//                    this.tooltip.style.top = $target.offset().top + 'px'
                    this.$nextTick(function () {
                        // DOM 更新了
                        this.tooltip.style.top = top - (($tooltip.height() - $target.parent().height()) / 2) + 'px'
                        self.tooltip.style.left = (left - $tooltip.width()) + 'px';
                    })
                },
                leaveLable: function () {
                    this.tooltip.className = "";
                    this.tooltip.text = "";
                },
                changeRegType: function (regType) {
                    var overallGroup = this.overallGroup;
                    var nodeData = this.getNodeData(this.currentUUid);
                    var path = overallGroup.select('g[source-id="' + this.currentUUid + '"]');
                    var targetElement, targetId, pathGroup;
                    var self = this;
                    nodeData.formNlistIds = [];
                    nodeData.isAssign = '0';
                    if (!path) {
                        return;
                    }
                    targetId = path.attr('target-id');
                    targetElement = this.getNodeData(targetId);
                    targetElement.gstatusTtype = '';
                    pathGroup = overallGroup.selectAll('g[source-id="' + targetId + '"]');
                    pathGroup.forEach(function (item) {
                        var text = item.select('text')
                        var id = item.attr('model-id');
                        var pathData = self.getNodeData(id);
                        pathData.statusIds = [];
                        text && text.remove();
                    })

                },
                //生成blob对象
                base64Img2Blob: function (code) {
                    var byteString = window.atob(code.split(',')[1]);
                    var mimeString = code.split(',')[0].split(':')[1].split(';')[0];
                    var buffer = new ArrayBuffer(byteString.length);
                    var intArray = new Uint8Array(buffer);
                    for (var i = 0; i < byteString.length; i++) {
                        intArray[i] = byteString.charCodeAt(i);
                    }
                    return new Blob([buffer], {type: mimeString});
                },

                //下载图片
                downFlowPic: function () {
                    var self = this;
                    this.generateCanvas(function (content) {
                        var aLink = document.createElement('a');
                        var url = content.toDataURL("image/png");
                        var blob = self.base64Img2Blob(url);
                        $('body').append(aLink)
                        aLink.onclick = function () {
                            requestAnimationFrame(function () {
                                URL.revokeObjectURL(url);
                            })
                        };
                        aLink.download = self.groupName;
                        aLink.href = URL.createObjectURL(blob);
                        aLink.click()
                        $(aLink).remove();
                    });
                },

                //生成下载流程图canvas
                generateCanvas: function (cb) {
                    var canvas = document.createElement('canvas');
                    var ctx = canvas.getContext('2d');
                    var image = new Image();
                    var width = this.viewport.width;
                    var height = this.viewport.height;
                    canvas.width = width;
                    canvas.height = height;
                    image.onload = function () {
                        ctx.drawImage(image, 0, 0, width, height);
                        image.onload = null;
                        image = null;
                        cb(canvas)
                    }
                    image.src = this.designPaper.toDataURL();
                    return canvas;
                },
                //计算放到画布坐标
                calculateCoordinate: function (ele, isOverallGroup, toTarget) {
                    var panningLeft = this.$paperScroll.scrollLeft();
                    var panningTop = this.$paperScroll.scrollTop();
                    var viewportLeft = this.viewport.left;
                    var toPaperDataPos = this.toPaperData.style;
                    var toPaperLeft = parseInt(toPaperDataPos.left);
                    var toPaperTop = parseInt(toPaperDataPos.top);
                    var x, y;
                    var zoom = this.zoom / 100;
                    var overallGroupTranslateX = this.overallGroup.matrix.e;
                    var grid = this.grid;
                    var toTargetBBox = toTarget.getBBox();
                    x = toPaperLeft - this.stencilWidth - viewportLeft + panningLeft;
                    y = toPaperTop - this.headerTop + panningTop;
                    if (!isOverallGroup) {
                        x = x - toTargetBBox.x;
                        y = y - toTargetBBox.y;
                    }
                    return {
                        x: Math.round((x / zoom - overallGroupTranslateX) / grid) * grid,
                        y: Math.round(y / zoom / grid) * grid
                    }

                },


                //添加到画布
                toDesignPaper: function (ele, node, toTarget, isOverallGroup) {
                    var overallGroup = this.overallGroup;
                    var vPaths = overallGroup.selectAll('.v-path-group');
                    var nodeModelType = node.type;
                    var pos;
                    var vChildShapes;
                    var parentId;
                    var modelId;
                    if (!toTarget) {
                        return false;
                    }
                    if (node.nodeKey && node.nodeKey === toTarget.attr('model-key')) {
                        return false;
                    }

                    if (node.nodeKey == 'SubProcess') {
//                        console.log(ele.select('.v-scale'));
                        ele.select('.v-scale').attr('transform', 'matrix(1.5,0,0,1.5,0,0)');
                        ele.select('.v-title-scale').attr('transform', 'matrix(1.5,0,0,0.5,0,0)');
                        ele.select('text').attr('transform', 'matrix(1,0,0,1,230,20)');
                    }

                    pos = this.calculateCoordinate(ele, isOverallGroup, toTarget);
                    ele.attr('transform', 'matrix(1,0,0,1,' + pos.x + ',' + pos.y + ')');
//                    ele.data('node-type', node.nodeType);
                    if (toTarget.hasClass('v-overall-group')) {
                        if (node.nodeKey !== 'EndErrorEvent') {
                            if (vPaths.length > 0) {
                                ele.insertBefore(vPaths[0])
                            } else {
                                toTarget.append(ele);
                            }
                            parentId = this.rootId;
                            ele.attr('parent-id', parentId)
                        }
                    } else {
                        if (node.nodeKey !== 'SubProcess' && toTarget.attr('model-key') === 'SubProcess') {
                            vChildShapes = toTarget.select('.v-childShapes');
                            if (vChildShapes) {
                                vChildShapes.append(ele);
                            } else {
                                var group = this.designPaper.group();
                                group.addClass('v-childShapes');
                                group.append(ele);
                                toTarget.add(group)
                            }
                            parentId = toTarget.attr('model-id');
                            ele.attr('parent-id', parentId)
                        }
                    }
                    modelId = this.getAddUUid();
                    ele.attr('model-id', modelId);
                    ele.attr('model-type', nodeModelType);
                    ele.attr('model-key', node.nodeKey);
                    this.currentUUid = modelId;
                    if (this['add' + node.nodeKey]) {
                        this['add' + node.nodeKey](node, parentId);
                    }
                    this.addModelKey(this.toLowerFirst(node.nodeKey));
                    this.dragNode(ele, node);
                    var isOverLimit = this.overLimit(overallGroup.selectAll('g.v-translate'), ele.getBBox().x, ele.getBBox().y, this.viewport, this.addDistance, 10);
                    var verticalFn = isOverLimit.vertical;
                    var horizontalFn = isOverLimit.horizontal;
                    verticalFn && this[verticalFn + 'VerticalPaper']();
                    horizontalFn && this[horizontalFn + 'HorizontalPaper']();
//                    this.getUUId();
                },

                //修改缩放
                changeZoom: function () {
                    var zoom = this.zoom / 100;
                    var paperSize = this.paper;
                    var paperWidth = paperSize.width;
                    var paperHeight = paperSize.height;
                    var overallGroup = this.overallGroup;
                    var matrix = overallGroup.matrix;
                    var BBox;
                    matrix.a = zoom;
                    matrix.d = zoom;
                    matrix.e = this.overallMatrix.e * zoom;
                    matrix.f = this.overallMatrix.f * zoom;
                    this.viewport.width = (paperWidth + matrix.e) * zoom;
                    this.viewport.height = (paperHeight + matrix.f) * zoom;
                    overallGroup.attr('transform', matrix.toTransformString());
                    if (this.rdFreeShow && this.currentNodeEle) {
                        BBox = this.currentNodeEle.getBBox();
                        this.showOrMoveRdFree(BBox, BBox.x, BBox.y, zoom)
                    }
                },

                //移动节点
                dragNode: function (ele) {
                    var self = this, overallGroup = this.overallGroup;
                    var startX, startY, zoom, scale, grid, addDistance = this.addDistance;
                    var isSubProcessGroup, isSubProcessChildren, hasChildShapes, subProcessGroup, connections, viewport, vTranslateGroups;

                    ele.drag(function move(dx, dy) {
                        var position = self._generatePosition(dx, dy);
                        var translateX = (position.dx / zoom + startX);
                        var translateY = (position.dy / zoom + startY);
                        var element = this;
                        var matrix = element.matrix;
                        var elementBox = element.getBBox();
                        var subProcessGroupBBox;
                        var isOverLimit = self.overLimit(vTranslateGroups, dx, dy, viewport, addDistance, 10);
                        var verticalFn = isOverLimit.vertical;
                        var horizontalFn = isOverLimit.horizontal;
//                        console.log(isOverLimit)
                        if (isSubProcessChildren) {
                            subProcessGroupBBox = subProcessGroup.getBBox();
                            translateX = Math.min(Math.max(10, translateX), subProcessGroupBBox.width - elementBox.width - 10);
                            translateY = Math.min(Math.max(40, translateY), subProcessGroupBBox.height - elementBox.height - 10);
                        }
                        verticalFn && self[verticalFn + 'VerticalPaper']();
                        horizontalFn && self[horizontalFn + 'HorizontalPaper']();


                        matrix.e = Math.max(0, translateX);
                        matrix.f = Math.max(0, translateY);
                        element.attr('transform', matrix.toTransformString());
                        elementBox = element.getBBox();
                        self.showOrMoveRdFree(elementBox, elementBox.x, elementBox.y, zoom, isSubProcessChildren);
                        //走线
                        if (connections.length > 0) {
                            connections.forEach(function (item) {
                                var parentX = (isSubProcessGroup && item.connectionType === 'sub') ? elementBox.x : ( isSubProcessChildren ? subProcessGroupBBox.x : 0);
                                var parentY = (isSubProcessGroup && item.connectionType === 'sub') ? elementBox.y : ( isSubProcessChildren ? subProcessGroupBBox.y : 0);
                                var position = self.getAllPosition(item.source.getBBox(), item.target.getBBox(), parentX, parentY);
                                var quadrant = self.quadrant(position);
                                var dLine = self.generateLinkPos(position, quadrant);
                                self.changePath(item.path.select('.v-path'), dLine);
                                self.changePath(item.path.select('.v-path-wrap'), dLine);
                                self.changePathTriangle(item.path.select('.v-triangle'), dLine, quadrant.tAngle)
                                self.changePathText(item.path, item.path.select('text'))
                            })
                        }

                    }, function start(x, y, event) {
                        event.stopPropagation();
                        var elementBBox, modelId, modelKey, sourceConnections, targetConnections, nodeData;
                        var element = this;
                        var parentId = this.attr('parent-id');
                        elementBBox = element.getBBox();
                        grid = self.grid;
                        startX = elementBBox.x;
                        startY = elementBBox.y;
                        scale = zoom = self.zoom / 100;
                        modelId = element.attr('model-id');
                        modelKey = element.attr('model-key');
                        viewport = self.viewport;
                        vTranslateGroups = overallGroup.selectAll('g.v-translate');
                        sourceConnections = overallGroup.selectAll('g[source-id="' + modelId + '"]');
                        targetConnections = overallGroup.selectAll('g[target-id="' + modelId + '"]');
                        isSubProcessChildren = self.isSubProcessChildren(element);
                        subProcessGroup = self.getSubProcess(element, isSubProcessChildren);
                        self.setCurrentNodeEle(element);
                        self.showOrMoveRdFree(elementBBox, elementBBox.x, elementBBox.y, zoom, isSubProcessChildren);
                        self.setCurrentUUid(modelId);
                        nodeData = self.getNodeComponent(modelId, modelKey);

                        isSubProcessGroup = self.isSubProcessGroup(element);
                        self.emptyConnections();
                        self.addDefaultConnector(element, sourceConnections, targetConnections);
                        hasChildShapes = self.hasChildShapes(element);
                        self.isListForm = parentId === self.rootId;
                        if (modelKey === 'UserTask') {
                            if (nodeData.roleIds.length > 0) {
                                self.roleGroup = nodeData.roleIds[0].roleGroup;
                            } else {
                                self.roleGroup = ''
                            }
                            self.nodeDataUserTask = nodeData
                        } else {
                            self.roleGroup = ''
                            self.nodeDataUserTask = {}
                        }

                        if (hasChildShapes) {
                            self.addSubProcessConnector(hasChildShapes.children());
                        }
                        connections = self.connections;
                        self.getPrevNodeName(modelKey, targetConnections)
                        self.resetPathColor();
//                        self.getStatusIds();
                        setTimeout(function () {
                            self.$refs['rdFreeEle'].focus();
                        }, 0)
                    })
                },


                getPrevNodeName: function (modelKey, targetConnections) {
                    if (targetConnections.length < 1) {
                        this.prevRegTypeValue = '';
                        this.prevNodeName = '';
                        this.prevRegTypeName = '';
                        this.prevModelKey = '';
                        return;
                    }
                    var path = targetConnections[0];
                    var sourceId = path.attr('source-id');
                    var prevNode = this.getNodeData(sourceId);
                    if (modelKey !== 'ExclusiveGateway') {
                        this.prevRegTypeValue = '';
                        this.prevNodeName = '';
                        this.prevRegTypeName = '';
                        this.prevModelKey = prevNode.nodeKey;
                        return false;
                    }


                    this.prevNodeName = prevNode.name;
                    this.prevRegTypeValue = prevNode.regType;
                    this.prevModelKey = prevNode.nodeKey;
                    if (!prevNode.regType) {
                        this.prevRegTypeName = '';
                        return;
                    }


                    for (var i = 0; i < this.regTypes.length; i++) {
                        var item = this.regTypes[i];
                        if (item.id == prevNode.regType) {
                            this.prevRegTypeName = item.name;
                            break;
                        }
                    }
                },

                //线按下事件
                pathMousedown: function (ele) {
                    var self = this;
                    ele.mousedown(function (event) {
                        var modelId = this.attr('model-id');
                        var modelKey = this.attr('model-key');
                        var sourceId = this.attr('source-id');
                        var sourceData = self.getNodeData(sourceId);
                        self.getNodeComponent(modelId, modelKey);
                        self.setCurrentUUid(modelId);
                        self.setConditions(sourceData);
                        self.setShowSelectedCondition((sourceData.type == 140 || sourceData.type == 240))
                        self.resetPathColor();
                        ele.select('.v-path').attr('stroke', '#39f');
                        ele.select('.v-triangle').attr('fill', '#39f');
                        self.rdFreeShow = false;
                        self.rdHaloShow = false;
                    })
                },


                resetPathColor: function () {
                    var overallGroup = this.overallGroup;
                    var paths = overallGroup.selectAll('.v-path-group');
                    paths.forEach(function (path) {
                        path.select('.v-path').attr('stroke', '#ddcebb');
                        path.select('.v-triangle').attr('fill', '#ddcebb');
                    })
                },

                //判断点击是否是子流程
                isSubProcessGroup: function (element) {
                    return element.attr('model-key') === 'SubProcess';
                },

                //判断是否有childShapes，有返回，没有返回null
                hasChildShapes: function (element) {
                    return element.select('.v-childShapes')
                },

                //是否是子流程的元素
                isSubProcessChildren: function (element) {
                    return element.parent().hasClass('v-childShapes');
                },

                //获取子流程
                getSubProcess: function (element, isSubProcessChildren) {
                    return isSubProcessChildren ? element.parent().parent() : null;
                },

                //清空connection
                emptyConnections: function () {
                    this.connections = [];
                },

                //非子流程添加到Connections
                addDefaultConnector: function (ele, source, target) {
                    var connections = this.connections;
                    var overallGroup = this.overallGroup;
                    source.forEach(function (item) {
                        var targetId = item.attr('target-id');
                        connections.push({
                            path: item,
                            connectionType: 'base',
                            source: ele,
                            target: overallGroup.select('g[model-id="' + targetId + '"]')
                        })
                    });
                    target.forEach(function (item) {
                        var sourceId = item.attr('source-id');
                        connections.push({
                            path: item,
                            connectionType: 'base',
                            source: overallGroup.select('g[model-id="' + sourceId + '"]'),
                            target: ele
                        })
                    })
                },

                //子流程添加到Connections
                addSubProcessConnector: function (elements) {
                    var overallGroup = this.overallGroup;
                    var connections = this.connections;
                    if (!elements) return;
                    elements.forEach(function (item) {
                        var paths = overallGroup.selectAll('g[source-id="' + item.attr('model-id') + '"]');
                        if (paths) {
                            paths.forEach(function (path) {
                                var targetEle = overallGroup.select('g[model-id="' + path.attr('target-id') + '"]');
                                if (targetEle) {
                                    connections.push({
                                        path: path,
                                        source: item,
                                        connectionType: 'sub',
                                        target: targetEle
                                    })
                                }
                            })
                        }
                    })
                },

                //获取组件显示 并返回当前数据对象
                getNodeComponent: function (id, key) {
                    var self = this;
                    var nodeKey = this.toLowerFirst(key);
                    this.setDataKey(nodeKey);
                    this.addModelKey(nodeKey);
                    this[nodeKey] = this.getNodeData(id);
                    if (nodeKey === 'exclusiveGateway') {
                        this.getStatusIds(this[nodeKey].gstatusTtype, key);
                    }


                    $(this.$refs[nodeKey].$el).find('select,input,textarea').blur();
                    this.modelKeys.forEach(function (t) {
                        self[t + 'Show'] = t === nodeKey;
                    });

                    return this[nodeKey];
                },

                //设置dataKey
                setDataKey: function (key) {
                    this.dataKey = key;
                },

                //设置当前uuid
                setCurrentUUid: function (id) {
                    this.currentUUid = id;
                },

                //设置当前节点元素
                setCurrentNodeEle: function (element) {
                    this.currentNodeEle = element;
                },

                //设置conditions
                setConditions: function (data) {
                    var overallGroup, paths, existedCons, conditions, self, unexistedConditions;
                    if (!data) {
                        this.conditions = data ? data.statusIds : [];
                        return;
                    }
                    self = this;
                    overallGroup = this.overallGroup;
                    if (data.id) {
                        paths = overallGroup.selectAll('g[source-id="' + data.id + '"]');
                        existedCons = [];
                        unexistedConditions = [];
                        conditions = data.statusIds || [];

                        paths.forEach(function (path) {
                            var obj = self.getNodeData(path.attr('model-id'));
                            existedCons = existedCons.concat(obj.statusIds)
                        })

                        conditions.forEach(function (item) {
                            var id = item.id;
                            var existed = existedCons.some(function (c) {
                                return id === c.id;
                            })
                            if (!existed) {
                                unexistedConditions.push(item);
                            }
                        })
                        this.conditions = unexistedConditions;

                    } else {
                        this.conditions = []
                    }

                },

                setShowSelectedCondition: function (isShow) {
                    this.showSelectedCondition = isShow
                },
                //判断右侧和下侧是否有节点超出, 并返回超过元素，索引，水平或者垂直
                overLimit: function (elements, dx, dy, viewport, distance, snap) {
                    var xArr = [], yArr = [], xyMap = {}, maxX, maxY, res = {
                        vertical: false,
                        horizontal: false
                    };
                    var width = viewport.width;
                    var height = viewport.height;
                    var dSnap = snap || 0;
                    elements.forEach(function (element, i) {
                        var BBox = element.getBBox();
                        var x = BBox.width + BBox.x;
                        var y = BBox.height + BBox.y;
                        xArr.push(x);
                        yArr.push(y);
                        xyMap[(x + 'horizontal')] = i;
                        xyMap[(y + 'vertical')] = i;
                    });
                    maxX = Math.max.apply(Math, xArr);
                    maxY = Math.max.apply(Math, yArr);
                    if (maxX + dSnap >= width && dx > 0) {
                        res.vertical = 'add';
                        res.vXIndex = xyMap[maxX];
                        res.xElement = elements[maxX]
                    }
                    if (maxY + dSnap >= height && dy > 0) {
                        res.horizontal = 'add';
                        res.vYIndex = xyMap[maxY];
                        res.yElement = elements[maxY]
                    }
                    if (width - maxX - dSnap >= distance && dx < 0) {
                        res.vertical = 'remove';
                        res.vXIndex = xyMap[maxX];
                        res.xElement = elements[maxX]
                    }
                    if (height - maxY - dSnap >= distance && dy < 0) {
                        res.horizontal = 'remove';
                        res.vYIndex = xyMap[maxY];
                        res.yElement = elements[maxY]
                    }

                    return res;
                },

                //增加画布长度
                addVerticalPaper: function () {
                    var viewport = this.viewport;
                    viewport.width += this.addDistance;
                },

                addHorizontalPaper: function () {
                    var viewport = this.viewport;
                    viewport.height += this.addDistance;
                },

                //减少画布长度
                removeVerticalPaper: function () {
                    var viewport = this.viewport;
                    var width = viewport.width;
                    var minWidth = this.viewportMin.width;
                    viewport.width = Math.max(minWidth, width - this.addDistance);
                },

                removeHorizontalPaper: function () {
                    var viewport = this.viewport;
                    var height = viewport.height;
                    var minHeight = this.viewportMin.height;
                    viewport.height = Math.max(minHeight, height - this.addDistance);
                },

                //出现放大节点
                showOrMoveRdFree: function (BBox, left, top, zoom, isOverallGroup) {
                    var width = BBox.width * zoom;
                    var height = BBox.height * zoom;
                    var vLeft = left * zoom;
                    var vTop = top * zoom;
                    var vTranslateGroup = this.currentNodeEle.parent().parent();
                    var vTranslateGroupBBox = vTranslateGroup.getBBox();
                    var x = vTranslateGroupBBox.x;
                    var y = vTranslateGroupBBox.y;
                    if (isOverallGroup) {
                        vLeft = vLeft + x;
                        vTop = vTop + y;
                    }
                    this.rdFreeStyle = {
                        width: width + 'px',
                        height: height + 'px',
                        left: vLeft + 'px',
                        top: vTop + 'px'
                    };
                    this.rdFreeShow = true;
                    this.rdHaloShow = true;
                    this.rdHaloStyle = this.rdFreeStyle;
                },

                //移动grid的坐标
                _generatePosition: function (dx, dy) {
                    var grid = this.grid;
                    return {
                        dx: Math.round(dx / grid) * grid,
                        dy: Math.round(dy / grid) * grid
                    }
                },

                //坐标点事件
                stretchNode: function (event) {
                    var startX = event.clientX;
                    var startY = event.clientY;
                    var currentNodeEle = this.currentNodeEle;
                    var currentNodeMatrix = currentNodeEle.matrix;
                    var BBox = currentNodeEle.getBBox();
                    var zoom = this.zoom / 100;
                    var grid = this.grid;
                    var vScale = currentNodeEle.select('.v-scale');
                    var hasRect = vScale.select('rect');
                    var vScaleTitle = currentNodeEle.select('.v-title-scale');
                    var vShape = currentNodeEle.select('.v-scale').select('.v-shape');
                    var hasIcon = currentNodeEle.select('image');
                    var textArea;
                    var currentNodeText;
                    var vTitleText;
                    var vTitleShape;
                    var self = this;
                    var scaleMatrix, titleScaleMatrix;
                    var originalScaleWidth, originalScaleTitleWidth, isOverallGroup, originalScaleHeight, originScaleTitleHeight;
                    var shapeBox;
                    var $target = $(event.target);
                    var directions = {
                        se: $target.hasClass('se'),
                        sw: $target.hasClass('sw'),
                        nw: $target.hasClass('nw'),
                        ne: $target.hasClass('ne'),
                        n: $target.hasClass('n'),
                        e: $target.hasClass('e'),
                        s: $target.hasClass('s'),
                        w: $target.hasClass('w')
                    };


                    this.addMatrix(vScale);
                    this.addMatrix(vScaleTitle);
                    if (vScaleTitle) {
                        vTitleShape = vScaleTitle.select('.v-shape');
                        vTitleText = currentNodeEle.select('.v-title').select('text');
                    }

                    if (!hasRect) {
                        currentNodeText = currentNodeEle.select('.v-rotate').select('text');
                    }
                    scaleMatrix = vScale && vScale.matrix;
                    titleScaleMatrix = vScaleTitle && vScaleTitle.matrix;
                    if (hasIcon && currentNodeEle.attr('model-key') != 'SubProcess') {
                        var textAreaMatrix;
                        if (currentNodeEle.select('.v-audit-role-container')) {
                            textArea = currentNodeEle.select('.v-audit-role-container')
                        } else {
                            textArea = currentNodeEle.select('text');
                        }
                        if (!textArea.matrix) {
                            self.addMatrix(textArea)
                        }
                        textArea.me = textArea.matrix.e;
                        textArea.mf = textArea.matrix.f;
                        textArea.rateX = textArea.me / BBox.width / scaleMatrix.a;
                        textArea.rateY = textArea.mf / BBox.height / scaleMatrix.d;
                    }
                    shapeBox = vShape.getBBox();
                    originalScaleWidth = shapeBox.width;
                    originalScaleHeight = shapeBox.height;
                    originalScaleTitleWidth = originalScaleWidth;
                    isOverallGroup = self.currentNodeEle.parent().hasClass('v-childShapes')
                    $(document).on('mousemove.node', function (event) {
                        var dx = event.clientX - startX;
                        var dy = event.clientY - startY;
                        var width, height;
                        var moveBBox;


                        dx = dx / zoom;
                        dy = dy / zoom;


                        dx = Math.round(dx / grid) * grid;
                        dy = Math.round(dy / grid) * grid;


                        if (directions.se) {
                            width = Math.max(originalScaleWidth / 2, BBox.width + dx);
                            height = Math.max(originalScaleHeight / 2, BBox.height + dy);
                        }

                        if (directions.sw) {
                            width = Math.max(originalScaleWidth / 2, BBox.width - dx);
                            height = Math.max(originalScaleHeight / 2, BBox.height + dy);
                            currentNodeMatrix.e = BBox.x + dx;
                            currentNodeEle.attr('transform', currentNodeMatrix.toTransformString())
                        }
                        if (directions.nw) {
                            width = Math.max(originalScaleWidth / 2, BBox.width - dx);
                            height = Math.max(originalScaleHeight / 2, BBox.height - dy);
                            currentNodeMatrix.e = BBox.x + dx;
                            currentNodeMatrix.f = BBox.y + dy;
                            currentNodeEle.attr('transform', currentNodeMatrix.toTransformString())
                        }

                        if (directions.ne) {
                            width = Math.max(originalScaleWidth / 2, BBox.width + dx);
                            height = Math.max(originalScaleHeight / 2, BBox.height - dy);
                            currentNodeMatrix.f = BBox.y + dy;
                            currentNodeEle.attr('transform', currentNodeMatrix.toTransformString())
                        }

                        if (directions.n) {
                            width = BBox.width;
                            height = Math.max(originalScaleHeight / 2, BBox.height - dy);
                            currentNodeMatrix.f = BBox.y + dy;
                            currentNodeEle.attr('transform', currentNodeMatrix.toTransformString())
                        }

                        if (directions.e) {
                            width = Math.max(originalScaleWidth / 2, BBox.width + dx);
                            height = BBox.height;

                        }

                        if (directions.s) {
                            height = Math.max(originalScaleHeight / 2, BBox.height + dy);
                            width = BBox.width;
                        }

                        if (directions.w) {
                            width = Math.max(originalScaleWidth / 2, BBox.width - dx);
                            height = BBox.height;
                            currentNodeMatrix.e = BBox.x + dx;
                            currentNodeEle.attr('transform', currentNodeMatrix.toTransformString())
                        }


                        scaleMatrix.a = width / originalScaleWidth;
                        scaleMatrix.d = height / originalScaleHeight;
                        vScale.attr('transform', scaleMatrix.toTransformString());


                        moveBBox = currentNodeEle.getBBox();


                        if (vTitleShape) {
                            titleScaleMatrix.a = width / originalScaleTitleWidth;
                            vScaleTitle.attr('transform', titleScaleMatrix.toTransformString());
                            self.centerVTitle(vTitleText, moveBBox)
                        }

                        if (hasIcon && textArea) {
                            var textAreaMatrix = textArea.matrix;
                            textAreaMatrix.e = textArea.rateX * BBox.width * scaleMatrix.a;
                            textAreaMatrix.f = textArea.rateY * BBox.height * scaleMatrix.d;
                            textArea.attr('transform', textAreaMatrix.toTransformString())
                        }

                        self.centerVTitle(currentNodeText, moveBBox, true);
                        self.showOrMoveRdFree(moveBBox, moveBBox.x, moveBBox.y, zoom, isOverallGroup)

                    });

                    $(document).on('mouseup.node', function (event) {
                        $(document).off('mousemove.node');
                        $(document).off('mouseup.node');
                    })
                },

                //初始化matrix
                addMatrix: function (ele) {
                    var matrix;
                    if (!ele) return false;
                    matrix = ele.matrix;
                    if (!matrix) {
                        ele.attr('transform', ele.attr('transform'));
                        return true;
                    }
                    return false;
                },

                //设置title标题居中
                centerVTitle: function (titleEle, BBox, hasHeight) {
                    var matrix;
                    if (titleEle) {
                        if (!matrix) {
                            titleEle.attr('transform', titleEle.attr('transform'));
                        }
                        matrix = titleEle.matrix;
                        matrix.e = (BBox.width) / 2;
                        if (hasHeight) {
                            matrix.f = (BBox.height + parseInt(titleEle.attr('fontSize'))) / 2;
                        }
                        titleEle.attr('transform', matrix.toTransformString())
                    }
                },

                stopProMouseDown: function ($event) {
                    $event.preventDefault();
                    $event.stopPropagation();
                },

                //获取父级元素
                getTranslateEle: function (ele) {
                    var translate;
                    if (ele.type === 'svg') {
                        return null;
                    }
                    while (ele) {
                        var hasTranslate = ele.hasClass('v-translate');
                        if (ele.hasClass('v-overall-group')) {
                            translate = null;
                            break;
                        }
                        if (hasTranslate) {
                            translate = ele;
                            break;
                        }
                        ele = ele.parent();
                    }
                    return ele;
                },

                //连接线处理
                connect: function ($event) {
                    $event.stopPropagation();
                    $event.preventDefault();
                    var moveCenterPoint;
                    var self = this;
                    var $startEvent = $event;
                    var startX = $event.clientX, startY = $event.clientY;
                    var currentNodeEle = this.currentNodeEle;
                    var overallGroup = this.overallGroup;
                    var lineDefaultData = this.lineDefaultData;
                    var BBox = currentNodeEle.getBBox();
                    var rootId = this.rootId;
                    var parentId = currentNodeEle.attr('parent-id');
                    var startCenterPoint = [BBox.x + BBox.width / 2, BBox.y + BBox.height / 2]; //中心点
                    var parentElementPos = this.getParentElementPos(currentNodeEle);
                    var parentX = parentElementPos.x;
                    var parentY = parentElementPos.y;
                    var sourceId = currentNodeEle.attr('model-id');

                    var connectingPath = this.generateConnectingPath();
                    var path = connectingPath.path;
                    var pathGroup = connectingPath.pathGroup;

                    $(document).on('mousemove.connect', function ($event) {
                        var moveX = $event.clientX, moveY = $event.clientY;
                        var dx = moveX - startX, dy = moveY - startY;
                        var moveAngle;
                        var startPoint, endPoint;
                        moveCenterPoint = self.getMoveCenterPoint(moveX, moveY, dx, dy, BBox, parentElementPos, parentId != rootId);
                        moveAngle = self.getConnectingPathAngle(startCenterPoint, moveCenterPoint);
                        startPoint = self.moveLinkPos(path, moveAngle, BBox, parentX, parentY);
                        endPoint = [moveCenterPoint[0] - 5, moveCenterPoint[1] - 5];
//                        endPoint = [(x + width) + dx + parentX, dy + (y + height / 2) + parentY];
                        path.attr('d', 'M ' + startPoint.join(' ') + ' ' + endPoint.join(' '));
                    });

                    $(document).on('mouseup.connect', function ($event) {
                        var $target = $event.target;
                        var position, translateEle, targetId, targetBBox, direction, generatePos, currentUUid;
                        var connectAbleRes;
                        pathGroup.remove();
                        $(document).off('mousemove.connect');
                        $(document).off('mouseup.connect');

                        connectAbleRes = self.addableConnect($target, $startEvent.target, moveCenterPoint, sourceId);

                        if (!connectAbleRes.connectAble) {
                            return false;
                        }
                        translateEle = connectAbleRes.element;
                        targetId = connectAbleRes.targetId;
                        targetBBox = translateEle.getBBox();
                        position = self.getAllPosition(BBox, targetBBox, parentX, parentY);
                        direction = self.quadrant(position)
                        generatePos = self.generateLinkPos(position, direction);
                        self.addPath(lineDefaultData, sourceId, parentId);
                        currentUUid = self.currentUUid;
                        self.generatePath(generatePos, overallGroup, currentUUid, sourceId, targetId, parentId, direction.tAngle, lineDefaultData.nodeKey);
//                            console.log(endAngle)

                    })
                },


                //生成拉的时候的链接线 并返回path 对象
                generateConnectingPath: function () {
                    var designPaper = this.designPaper;
                    var pathGroup = designPaper.group().addClass('v-path-group');
                    var path = designPaper.path();
                    var overallGroup = this.overallGroup;
                    path.attr({
                        'stroke': '#ddcebb',
                        'strokeWidth': '2',
                        'fill': 'none'
                    })
                    pathGroup.add(path);
                    overallGroup.add(pathGroup);
                    return {
                        path: path,
                        pathGroup: pathGroup
                    };
                },

                //获取父元素的距离 并返回距离想想x,y对象
                getParentElementPos: function (element) {
                    var parentId = element.attr('parent-id');
                    var isRootNode = parentId === this.rootId;
                    var parentElement, parentElementBBox;
                    var res = {
                        x: 0,
                        y: 0
                    };
                    if (isRootNode) {
                        return res;
                    }
                    parentElement = element.parent().parent();
                    parentElementBBox = parentElement.getBBox();
                    res = parentElementBBox;
                    return res;
                },

                //获取endCenterPoint 返回数组
                getMoveCenterPoint: function (x, y, dx, dy, BBox, parentElementPos, isSubProcess) {
                    var stencilWidth = this.stencilWidth;
                    var $paperScroll = this.$paperScroll;
                    var scrollLeft = $paperScroll.scrollLeft();
                    var scrollTop = $paperScroll.scrollTop();
                    var headerTop = this.headerTop;
                    var pointX = x - stencilWidth + (scrollLeft - this.viewport.left);
                    var pointY = y - headerTop + scrollTop;
                    if (isSubProcess) {
                        pointX = (BBox.x + BBox.width) + dx + parentElementPos.x;
                        pointY = dy + (BBox.y + BBox.height / 2) + parentElementPos.y;
                    }
                    return [pointX, pointY]
                },

                //获取移动时候的角度
                getConnectingPathAngle: function (startCenterPoint, endCenterPoint) {
                    return Snap.angle(startCenterPoint[0], startCenterPoint[1], endCenterPoint[0], endCenterPoint[1]);
                },

                //是否可连接线 并返回目标ID， 和原元素的group
                addableConnect: function (target, $startTarget, endPoint, sourceId) {
                    var $target = $(target);
                    var snapTarget;
                    var viewport = this.viewport;
                    var sourceTypeRules, targetType;
                    var translateEle, targetId, startNodeData, endNodeData;
                    var parent = $target;
                    var res = {
                        connectAble: false,
                        element: null,
                        targetId: ''
                    };
                    while (parent) {
                        if (parent[0].tagName === 'path') {

                            return res;
                        }
                        if (parent.attr('id') === 'flowDesignSvg') {
                            return res;
                        }
                        if (parent.attr('class') && parent.attr('class').indexOf('v-translate') > -1) {
                            translateEle = Snap(parent[0]);
                            break;
                        }
                        parent = parent.parent();
                    }


                    //事件对象一样， 线不可加 //超出区域不可添加
//                    if ($target === $startTarget || !endPoint) {
//                        return res;
//                    }
//
//                    //超出区域不可添加
//                    if (endPoint[0] < 0 || endPoint[1] < 0 || endPoint[0] > viewport.width || endPoint[1] > viewport.height) {
//                        return res;
//                    }
//                    //没有节点不可添加
//                    if ($target.nodeName === 'svg') {
//                        return res;
//                    }
//                    snapTarget = Snap(target);
//                    translateEle = this.getTranslateEle(snapTarget);
                    //过滤所有的非节点元素
                    if (!translateEle) {
                        return res;
                    }
                    targetId = translateEle.attr('model-id');
                    if (sourceId === targetId) {
                        return res;
                    }
                    startNodeData = this.getNodeData(sourceId);
                    endNodeData = this.getNodeData(targetId);
                    //根据源节点类型和目标节点类型判断是否可以连线
                    if (!startNodeData.type) {
                        return res
                    }
                    sourceTypeRules = this.typeRules[startNodeData.type];
                    if (!endNodeData) {
                        return res
                    }
                    if (this.hasConnectedPath(sourceId, targetId)) {
                        return res;
                    }
                    targetType = endNodeData.type;
                    res.connectAble = new RegExp(targetType).test(sourceTypeRules.join(','));
                    res.element = translateEle;
                    res.targetId = targetId;
                    return res;
                },

                hasConnectedPath: function (sourceId, targetId) {
                    var overallGroup = this.overallGroup;
                    var sourceGroup = overallGroup.select('g[source-id="' + sourceId + '"]')
                    var targetGroup = overallGroup.select('g[target-id="' + targetId + '"]')
                    if (!sourceGroup || !targetGroup) {
                        return false;
                    }
                    var sourceModelId = sourceGroup.attr('model-id');
                    var targetModelId = targetGroup.attr('model-id');
                    return (sourceModelId === targetModelId);
                },

                //判断象限
                quadrant: function (p) {
                    if (p[7].x < p[0].x && p[7].y < p[0].y) {
                        return {
                            d: 'topCenter-leftCenter',
                            tAngle: 0
                        };
                    } else if (p[7].x >= p[0].x && p[6].x < p[3].x && p[7].y < p[0].y) {
                        return {
                            d: 'topCenter-bottomCenter',
                            tAngle: 90
                        };
                    } else if (p[6].x >= p[3].x && p[5].y < p[0].y) {
                        return {
                            d: 'topCenter-rightCenter',
                            tAngle: 180
                        };
                    } else if (p[5].y >= p[0].y && p[3].x < p[6].x && p[4].y < p[1].y) {
                        return {
                            d: 'rightCenter-leftCenter',
                            tAngle: 180
                        };
                    } else if (p[4].y >= p[1].y && p[3].x < p[6].x) {
                        return {
                            d: 'rightCenter-topCenter',
                            tAngle: 270
                        };
                    } else if (p[4].y > p[1].y && p[7].x >= p[2].x && p[6].x < p[3].x) {
                        return {
                            d: 'bottomCenter-topCenter',
                            tAngle: 270
                        };
                    } else if (p[4].y > p[1].y && p[7].x < p[2].x) {
                        return {
                            d: 'leftCenter-topCenter',
                            tAngle: 270
                        };
                    } else {
                        return {
                            d: 'leftCenter-rightCenter',
                            tAngle: 0
                        };
                    }
                },

                //所有方向的坐标
                getAllPosition: function (BBox, targetBBox, parentX, parentY) {
                    return [{
                        x: BBox.x + parentX + BBox.width / 2, y: BBox.y + parentY  //中心点source topCenter
                    }, {
                        x: BBox.x + parentX + BBox.width / 2, y: BBox.y + parentY + BBox.height //bottomCenter
                    }, {
                        x: BBox.x + parentX, y: BBox.y + parentY + BBox.height / 2  //leftCenter
                    }, {
                        x: BBox.x + parentX + BBox.width, y: BBox.y + parentY + BBox.height / 2 //rightCenter
                    }, {
                        x: targetBBox.x + parentX + targetBBox.width / 2, y: targetBBox.y + parentY
                    }, {
                        x: targetBBox.x + parentX + targetBBox.width / 2, y: targetBBox.y + parentY + targetBBox.height
                    }, {
                        x: targetBBox.x + parentX, y: targetBBox.y + parentY + targetBBox.height / 2
                    }, {
                        x: targetBBox.x + parentX + targetBBox.width, y: targetBBox.y + parentY + targetBBox.height / 2
                    }]
                },

                //生成连接线的坐标
                generateLinkPos: function (p, direction) {
                    if (direction.d === 'bottomCenter-topCenter') {
                        return ['M', p[1].x, p[1].y, p[1].x, p[1].y + (p[4].y - p[1].y) / 2, p[4].x, p[1].y + (p[4].y - p[1].y) / 2, p[4].x, p[4].y]
                    } else if (direction.d === 'rightCenter-leftCenter') {
                        return ['M', p[3].x, p[3].y, p[3].x + (p[6].x - p[3].x) / 2, p[3].y, p[3].x + (p[6].x - p[3].x) / 2, p[6].y, p[6].x, p[6].y]
                    } else if (direction.d === 'leftCenter-rightCenter') {
                        return ['M', p[2].x, p[2].y, p[2].x - (p[2].x - p[7].x) / 2, p[2].y, p[2].x - (p[2].x - p[7].x) / 2, p[7].y, p[7].x, p[7].y]
                    } else if (direction.d === 'topCenter-bottomCenter') {
                        return ['M', p[0].x, p[0].y, p[0].x, p[0].y - (p[0].y - p[5].y) / 2, p[5].x, p[0].y - (p[0].y - p[5].y) / 2, p[5].x, p[5].y]
                    } else if (direction.d === 'rightCenter-topCenter') {
                        return ['M', p[3].x, p[3].y, p[5].x, p[3].y, p[4].x, p[4].y]
                    } else if (direction.d === 'topCenter-leftCenter') {
                        return ['M', p[0].x, p[0].y, p[0].x, p[7].y, p[7].x, p[7].y]
                    } else if (direction.d === 'leftCenter-topCenter') {
                        return ['M', p[2].x, p[2].y, p[4].x, p[2].y, p[4].x, p[4].y]
                    } else if (direction.d === 'topCenter-rightCenter') {
                        return ['M', p[0].x, p[0].y, p[0].x, p[6].y, p[6].x, p[6].y]
                    }
                },

                //移动时候找到坐标
                moveLinkPos: function (element, angle, BBox, parentX, parentY) {
                    var pos = {};
                    if (angle > 215 && angle < 305) {
                        pos.x = BBox.x + BBox.width / 2 + parentX;
                        pos.y = BBox.y + BBox.height + parentY;
                    } else if (angle > 45 && angle <= 135) {
                        pos.x = BBox.x + BBox.width / 2 + parentX;
                        pos.y = BBox.y + parentY;
                    } else if (angle > 125 && angle < 215) {
                        pos.x = BBox.x + BBox.width + parentX;
                        pos.y = BBox.y + BBox.height / 2 + parentY;
                    } else {
                        pos.x = BBox.x + parentX + parentX;
                        pos.y = BBox.y + BBox.height / 2 + parentY;
                    }
                    return [pos.x, pos.y];

                },

                //toLowModelKey
                toLowerFirst: function (modelKey) {
                    return modelKey.replace(/^\w{1}/i, function ($1) {
                        return $1.toLowerCase()
                    });
                },

                //control modelKey
                addModelKey: function (key) {
                    if (!(this.modelKeys.indexOf(key) > -1)) {
                        this.modelKeys.push(key)
                    }
                },

                //生成线group
                generatePath: function (dLine, parentGroup, id, sourceId, targetId, parentId, tAngle, key) {
                    var designPaper = this.designPaper;
                    var group = designPaper.group();
                    var path = designPaper.path();
                    var pathTarget = designPaper.path();
                    var targetData = this.getNodeData(targetId);
                    var pathWrapper = designPaper.path();
                    group.addClass('v-path-group');
                    this.changePath(path, dLine)
                    path.attr({
                        'strokeWidth': 2,
                        'stroke': '#ddcebb',
                        'fill': 'none'
                    }).addClass('v-path');
                    this.changePath(pathWrapper, dLine);
                    pathWrapper.attr({
                        'strokeWidth': 10,
                        'stroke': 'transparent',
                        'fill': 'none'
                    });
                    pathWrapper.addClass('v-path-wrap');
                    pathTarget.attr({
                        'd': 'M 10 0 L 0 5 L 10 10 z',
                        'stroke': 'transparent',
                        'fill': '#ddcebb',
                    }).addClass('v-triangle');
                    this.changePathTriangle(pathTarget, dLine, tAngle)
                    group.attr({
                        'model-id': id,
                        'target-id': targetId,
                        'source-id': sourceId,
                        'parent-id': parentId,
                        'model-key': key
                    });
                    targetData.preIds.push({
                        resourceId: id
                    });
                    targetData.preFunId = sourceId;
                    group.add(path);
                    group.add(pathTarget);
                    group.add(pathWrapper);
                    if (targetData.nodeKey == 'EndNoneEvent') {
                        var vPathGroups = parentGroup.selectAll('.v-path-group');
                        if (vPathGroups.length > 0) {
                            group.insertBefore(vPathGroups[0])
                        } else {
                            parentGroup.append(group);
                        }

                    } else {
                        parentGroup.append(group);
                    }

                    this.pathMousedown(group)

                },

                changePath: function (ele, dLine) {
                    ele.attr('d', dLine.join(' '))
                },

                changePathTriangle: function (ele, dLine, tAngle) {
                    var pathTargetX, pathTargetY, pathTargetMatrix;
                    if (tAngle == 270) {
                        pathTargetX = (dLine[dLine.length - 2] * 1 - 5);
                        pathTargetY = (dLine[dLine.length - 1] * 1 - 9);
                    } else if (tAngle == 180) {
                        pathTargetX = (dLine[dLine.length - 2] * 1 - 9);
                        pathTargetY = (dLine[dLine.length - 1] * 1 - 5)
                    } else if (tAngle == 0) {
                        pathTargetX = (dLine[dLine.length - 2]);
                        pathTargetY = (dLine[dLine.length - 1] * 1 - 5)
                    } else if (tAngle == 90) {
                        pathTargetX = (dLine[dLine.length - 2] * 1 - 5);
                        pathTargetY = (dLine[dLine.length - 1] * 1 - 9)
                    }
                    ele.attr({
                        'transform': 'matrix(1,0,0,1,' + pathTargetX + ',' + pathTargetY + ')'
                    })
                    pathTargetMatrix = ele.matrix;
                    pathTargetMatrix.rotate(tAngle, 5, 5);
                    ele.attr('transform', pathTargetMatrix.toTransformString());
                },

                changePathText: function (pathGroup, textElement) {
                    if (!textElement) return;
                    var BBox = pathGroup.getBBox();
                    var translateX = BBox.x + BBox.width / 2;
                    var translateY = BBox.y + BBox.height / 2;
                    textElement.attr({
                        'transform': 'matrix(1,0,0,1,' + translateX + ',' + translateY + ')'
                    })
                },

                addPath: function (node, sourceId, parentId) {
                    var type = this.getTypeId(node.type, parentId);
                    this.currentUUid = this.getAddUUid();
                    this.flowNodes.push({
                        preIds: [{resourceId: sourceId}],
                        preFunId: sourceId,
                        formIds: [],
                        type: type,
                        parentId: parentId,
                        isShow: false,
                        taskType: '',
                        roleIds: [],
                        userIds: [],
                        nodeKey: 'SequenceFlow',
                        name: node.name,
                        typeName: node.name,
                        iconUrl: '',
                        id: this.currentUUid,
                        remarks: node.remarks,
                        statusIds: [],
                        nodeId: node.id
                    })
                },

                //新增开始节点
                addStartNoneEvent: function (node, parentId) {
                    var type = this.getTypeId(node.type, parentId);
                    this.flowNodes.push({
                        id: this.currentUUid,
                        name: node.name,
                        typeName: node.name,
                        parentId: parentId,
                        nodeId: node.id,
                        nodeKey: node.nodeKey,
                        type: type,
                        remarks: node.remarks,
                        preIds: [],
                        outgoing: []
                    });
                },

                //新增开始节点
                addEndNoneEvent: function (node, parentId) {
                    var type = this.getTypeId(node.type, parentId)
                    this.flowNodes.push({
                        id: this.currentUUid,
                        name: node.name,
                        nodeId: node.id,
                        typeName: node.name,
                        nodeKey: node.nodeKey,
                        parentId: parentId,
                        type: type,
                        preIds: [],
                        remarks: node.remarks,
                        outgoing: []
                    });
                },

                //新增开始节点
                addEndErrorEvent: function (node, parentId) {
                    var type = this.getTypeId(node.type, parentId)
                    this.flowNodes.push({
                        id: this.currentUUid,
                        name: node.name,
                        nodeId: node.id,
                        typeName: node.name,
                        nodeKey: node.nodeKey,
                        parentId: parentId,
                        type: type,
                        preIds: [],
                        remarks: node.remarks,
                        outgoing: []
                    });
                },
                //新增开始节点
                addEndTerminateEvent: function (node, parentId) {
                    var type = this.getTypeId(node.type, parentId)
                    this.flowNodes.push({
                        id: this.currentUUid,
                        name: node.name,
                        nodeId: node.id,
                        typeName: node.name,
                        nodeKey: node.nodeKey,
                        parentId: parentId,
                        type: type,
                        preIds: [],
                        remarks: node.remarks,
                        outgoing: []
                    });
                },

                //新增流程组节点
                addSubProcess: function (node, parentId) {
                    var type = this.getTypeId(node.type, parentId);
                    this.flowNodes.push({
                        id: this.currentUUid,
                        name: node.name,
                        isShow: 1,
                        formIds: [],
                        preIds: [],
                        iconUrl: '',
                        nodeId: node.id,
                        parentId: parentId,
                        nodeKey: node.nodeKey,
                        type: type,
                        statusIds: [],
                        typeName: node.name,
                        remarks: node.remarks,
                        childShapes: [],
                        outgoing: []
                    });
                },

                addExclusiveGateway: function (node, parentId) {
                    var type = this.getTypeId(node.type, parentId)
                    this.flowNodes.push({
                        id: this.currentUUid,
                        name: node.name,
                        preIds: [],
                        isShow: 1,
                        formIds: [],
                        iconUrl: '',
                        nodeKey: node.nodeKey,
                        parentId: parentId,
                        statusIds: this.statusIds,
                        type: type,
                        nodeId: node.id,
                        typeName: node.name,
                        gstatusTtype: '',
                        remarks: node.remarks,
                        clazzIds: [],
                        childShapes: [],
                        outgoing: []
                    });
                },

                addEventGateway: function (node, parentId) {
                    var type = this.getTypeId(node.type, parentId)
                    this.flowNodes.push({
                        id: this.currentUUid,
                        name: node.name,
                        preIds: [],
                        isShow: 1,
                        formIds: [],
                        iconUrl: '',
                        statusIds: this.statusIds,
                        nodeId: node.id,
                        nodeKey: node.nodeKey,
                        parentId: parentId,
                        gstatusTtype: this.nodeStatusTypes[0].value,
                        type: type,
                        typeName: node.name,
                        remarks: node.remarks,
                        childShapes: [],
                        outgoing: []
                    });
                },

                //新增任务节点
                addUserTask: function (node, parentId) {
                    var type = this.getTypeId(node.type, parentId)
                    this.flowNodes.push({
                        id: this.currentUUid,
                        name: node.name,
                        isShow: 1,
                        formIds: [],
                        formListIds: [],
                        formNlistIds: [],
                        preIds: [],
                        iconUrl: '',
                        nodeKey: node.nodeKey,
                        nodeId: node.id,
                        type: type,
                        regType: '',
                        isAssign: 0,
                        parentId: parentId,
                        statusIds: [],
                        taskType: 'Parallel',
                        typeName: node.name,
                        remarks: node.remarks,
                        roleIds: [],
                        userIds: [],
                        outgoing: [],
                        childShapes: []
                    });
                },

                emptyAllNodeTypes: function () {
                    this.allNodeTypes = {}
                },
                //获取所有开始节点
                getAllStartNoneNode: function () {
                    var startNoneNodes = [];
                    var startNoneEventTypes = this.startNoneEventTypes;
                    var self = this;
                    this.emptyAllNodeTypes();
                    this.nextNodes = {};
                    this.parentIdList.length = 0;
                    this.flowNodes.forEach(function (item) {
                        if (new RegExp(item.type).test(startNoneEventTypes)) {
                            var parentId = item.parentId;
                            item.level = 1;
                            self.nextNodes[item.id] = true;
                            if (!(self.parentIdList.indexOf(parentId) > -1)) {
                                self.parentIdList.push(parentId)
                            }
                            startNoneNodes.push(item);
                            self.allNodeTypes[parentId] = [];
                        }
                    });
                    return startNoneNodes;
                },


                getNextNode: function (item, level, id) {
                    var overallGroup = this.overallGroup;
                    var pathGroups = overallGroup.selectAll('g[source-id="' + item.id + '"]');
                    var asTargetPath = overallGroup.select('g[target-id="' + item.id + '"]');
                    var asTSourceId;
                    var targetId, targetItem, sourceId;
                    var self = this;
                    self.nextNodes[item.id] = true;
                    item.level = level;
                    this.allNodeTypes[item.parentId].push(item.type);
//                    overallGroup.select('g[model-id="' + item.id + '"]').attr('level', level)
                    if (!pathGroups) {
                        return;
                    }
                    if (asTargetPath) {
                        asTSourceId = asTargetPath.attr('source-id')
                    }
                    pathGroups.forEach(function (path) {
//                        path.attr('level', (level+1));
                        var pathData = self.getNodeData(path.attr('model-id'))
                        pathData.level = level + 1;
                        self.allNodeTypes[pathData.parentId].push(pathData.type);
                        targetId = path.attr('target-id');
                        targetItem = self.getNodeData(targetId)
                        if (asTSourceId != targetId && !self.nextNodes[targetId]) {
                            self.getNextNode(targetItem, (level + 2))
                        }
                    });
                },

                //从开始处理level
                controlNodeLevel: function () {
                    var startNoneNodes = this.getAllStartNoneNode();
                    var self = this;
                    startNoneNodes.forEach(function (item) {
                        self.getNextNode(item, 1, item.id)
                    })
                },


                //验证流程合法性 返回布尔值;
                isValidateFlow: function () {
                    var allNodeTypes = this.allNodeTypes;
                    var parentIdList = this.parentIdList;
                    var regValidFlow = this.regValidFlow;
                    var regValidSubFlow = this.regValidSubFlow;
                    var rootId = this.rootId;
                    var valid = true;
                    var self = this;
                    this.allIdsLen = 0;
                    $.each(parentIdList, function (i, id) {
                        var nodeTypes = allNodeTypes[id]
                        var ids = nodeTypes.join(',');
                        var reg = id == rootId ? regValidFlow : regValidSubFlow;
                        self.allIdsLen += nodeTypes.length;
                        if (!reg.test(ids)) {
                            valid = false;
                            return false;
                        }
                    })
                    return valid;
                },

                validGateway: function () {
                    var gateways, len, gateway, statusIds, pathSources, id, statusIdsLen, pathStatusIdTotal;
                    var res = {valid: true};
                    var overallGroup = this.overallGroup;
                    var self = this;
                    gateways = this.flowNodes.filter(function (item) {
                        var statusIds = item.statusIds;
                        return item.type == 140 || item.type == 240
                    });
                    len = gateways.length;

                    if (!len) {
                        return res;
                    }
                    for (var i = 0; i < len; i++) {
                        pathStatusIdTotal = 0;
                        gateway = gateways[i];
                        statusIds = gateway.statusIds;
                        id = gateway.id;
                        statusIdsLen = statusIds.length;
                        pathSources = overallGroup.selectAll('g[source-id="' + id + '"]');
                        if (pathSources.length < 2) {
                            res.valid = false;
                            res.node = gateway;
                            res.type = 'noneComplete';
                            break;
                        }
//                        pathSources.forEach(function (path) {
//                            var pathId = path.attr('model-id');
//                            var nodeData = self.getNodeData(pathId);
//                            pathStatusIdTotal += nodeData.statusIds.length
//                        });
//                        if (statusIdsLen !== pathStatusIdTotal) {
//                            res.valid = false;
//                            res.node = gateway;
//                            res.type = 'noneComplete';
//                            break;
//                        }
                    }

                    return res;
                },

                //保存节点
                saveNodeList: function (isSave, isSaveButton) {
                    var flowNodes = this.flowNodes.slice(0);
                    var isValidate;
                    var uiJson = {};
                    var self = this;
                    var isValidateFlow, validGateway;
                    var groupName = this.groupName;
                    uiJson.width = this.viewport.width;
                    uiJson.height = this.viewport.height;
                    this.resetPathColor();
                    if (!isSave) {
                        if (!flowNodes.length) {
                            dialogCyjd.createDialog(0, '还未设计流程，请不要提交');
                            return false;
                        }
                        validGateway = this.validGateway();
                        if (!validGateway.valid) {
                            dialogCyjd.createDialog(0, validGateway.node.name + '网关' + this.gatewayErrorMegs[validGateway.type]);
                            return false;
                        }
                        isValidate = this.$validateNodes(this.flowNodes, this.overallGroup);
                        if (isValidate.id) {
                            dialogCyjd.createDialog(0, isValidate.msg);
                            return;
                        }
                        this.controlNodeLevel();
                        isValidateFlow = this.isValidateFlow();

                        if (!isValidateFlow) {
                            dialogCyjd.createDialog(0, '流程不合格，请检查');
                            return;
                        }
                        if (this.allIdsLen != this.flowNodes.length) {
                            dialogCyjd.createDialog(0, '流程不合格，请检查');
                            return;
                        }
                    }
                    this.saveIng = true;

                    $.ajax({
                        type: 'POST',
                        url: '${ctx}/actyw/gnode/saveAll',
                        contentType: "application/json",
                        data: JSON.stringify({
                            groupId: this.groupId,
                            uiJson: uiJson,
                            temp: isSave || false,
                            uiHtml: this.overallGroup.node.innerHTML,
                            list: flowNodes
                        }),
                        success: function (data) {

                            if (!isSave) {
                                dialogCyjd.createDialog(data.status ? 1 : 0, '流程提交成功，请去流程页面发布列表流程', {
                                    buttons: [{
                                        'text': '发布流程',
                                        'class': 'btn btn-small btn-primary',
                                        'click': function () {
                                            $(this).dialog('close')
                                            location.href = '${ctx}/actyw/actYwGroup/list?name=' + groupName;
                                        }
                                    }]
                                });
                            } else {
                                if (isSaveButton) {
                                    dialogCyjd.createDialog(data.status ? 1 : 0, '保存成功');
                                } else {
                                    window.location.href = "${ctx}/actyw/actYwGnode/${group.id}/view"
                                }
                            }


                            //dialogCyjd.createDialog(data.status ? 1 : 0, self.groupName + data.msg);
                            self.saveIng = false;
                        },
                        error: function (error) {
                            dialogCyjd.createDialog(0, '网络连接失败，错误代码' + error.status);
                            self.saveIng = false;
                        }
                    })

                },

                //删除
                deleteLinkNode: function ($event) {
                    $event.stopPropagation();
                    var overallGroup = this.overallGroup;
                    var uuid = this.currentUUid;
                    var self = this;
                    var pathSources = overallGroup.selectAll('g[source-id="' + uuid + '"]');
                    var pathTargets = overallGroup.selectAll('g[target-id="' + uuid + '"]');
                    this.removePaths(pathSources);
                    this.removePaths(pathTargets);
                    this.removeCurrentNode();
                    this.removeNodes.forEach(function (item) {
                        $.each(self.flowNodes, function (i, node) {
                            if (node.id === item) {
                                overallGroup.select('g[model-id="' + node.id + '"]').remove();
                                self.flowNodes.splice(i, 1);
                                return false;
                            }
                        })
                    });
                    this.rdFreeShow = false;
                    this.rdHaloShow = false;
                },

                //移除当前节点
                removeCurrentNode: function () {
                    var uuid = this.currentUUid;
                    var currentEle = this.currentNodeEle;
                    var vChildShape = currentEle.select('.v-childShapes');
                    var self = this;
                    var overallGroup = this.overallGroup;
                    if (currentEle.attr('model-key') === 'SubProcess') {
                        if (vChildShape) {
                            vChildShape.children().forEach(function (item) {
                                var modelId = item.attr('model-id');
                                var pathSources = overallGroup.selectAll('g[source-id="' + modelId + '"]');
                                var pathTargets = overallGroup.selectAll('g[target-id="' + modelId + '"]');
                                self.removePaths(pathSources);
                                self.removePaths(pathTargets);
                                self.removeNodes.push(modelId);
                            })
                        }
                    }
                    this.removeNodes.push(uuid)
                },

                //移除线
                removePaths: function (path) {
                    var self = this;
                    if (!path.length) {
                        return;
                    }
                    path.forEach(function (item) {
                        var pathModelId = item.attr('model-id');
                        var targetId = item.attr('target-id');
                        var nodeData = self.getNodeData(targetId);
                        nodeData.preFunId = '';
                        $.each(nodeData.preIds, function (i, item) {
                            if (item && item.resourceId === pathModelId) {
                                nodeData.preIds.splice(i, 1)
                            }
                        })
                        self.removeNodes.push(pathModelId)
                    })
                },

                //清空画布
                clearPaper: function () {
                    var self = this;
                    this.flowNodes = [];
                    this.overallGroup.clear();
                    this.modelKeys.forEach(function (item) {
                        self[item + 'Show'] = false;
                    });
                    this.rdFreeShow = false;
                    this.rdHaloShow = false;

                },


                getConditionExistMaxValue: function (nodeData) {
                    var arr = [];
                    var statusIds = nodeData.statusIds;
                    if (!statusIds.length) {
                        return 0
                    }
                    statusIds.forEach(function (item) {
                        arr = arr.concat(item.alias.split('-'));
                    })

                    return Math.max.apply(Math, arr)
                },

                openJudgeModal: function () {
                    this.judgeFormValid.resetForm();
                    this.judgeForm.regType = '';
                    this.judgeForm.name = '';
                    this.modelJudgeShow = true;
                },

                saveRegTypes: function () {
                    var self = this;
                    if (!this.judgeFormValid.form()) {
                        return false;
                    }
                    this.judgeSaveing = true;
                    $.ajax({
                        type: 'POST',
                        url: '${ctx}/actyw/actYwSgtype/ajaxSave',
                        data: this.judgeForm,
                        success: function (data) {
                            self.judgeSaveing = false;
                            self.getGStates();
                            self.modelJudgeShow = false;
                            showTip(data.msg, data.ret == 1 ? 'success' : 'error', 1200)
                        },
                        error: function () {
                            self.judgeSaveing = false;
                        },
                    })
                },

                //打开添加条件状态
                openConditionModel: function () {
                    var id = this.currentNodeEle.attr('model-id');
                    var nodeData = this.getNodeData(id);
                    var gtype = nodeData.gstatusTtype;
                    var gTypeData;
                    if (!gtype) {
                        dialogCyjd.createDialog(0, '请先选择判断类型');
                        return false;
                    }
                    gTypeData = this.getGType(gtype);
                    this.conditionValidateForm.resetForm();
                    this.conditionForm.alias = '';
                    this.conditionForm.remarks = '';
                    this.conditionForm.state = '';
                    this.conditionForm.startNum = 0;
                    this.conditionForm.endNum = '';
                    this.conditionForm.gtype = gtype;
                    this.conditionForm.regtype = gTypeData.regType;
                    if (this.conditionForm.regtype == 2) {
                        this.conditionForm.startNum = this.getConditionExistMaxValue(nodeData);
                        this.conditionValue = Math.floor(this.conditionForm.startNum + (100 - this.conditionForm.startNum) / 2)
                    }
                    this.conditionForm.gtypeName = gTypeData.name;
                    this.modelConditionShow = true;
                },

                setConditionPostData: function () {
                    var postData = {
                        state: this.conditionForm.state,
                        alias: [this.conditionForm.startNum, this.conditionValue].join('-'),
                        remarks: this.conditionForm.remarks,
                        regtype: this.conditionForm.regtype,
                        gtype: this.conditionForm.gtype //
                    }
                    postData['alias'] = this.conditionForm.regtype == 2 ? [this.conditionForm.startNum, this.conditionValue].join('-') : '';
                    return postData
                },

                //保存条件状态
                saveCondition: function () {
                    var isValid = this.conditionValidateForm.form();
                    var nodeKey = this.currentNodeEle.attr('model-key');
                    var id = this.currentNodeEle.attr('model-id');
                    var nodeData = this.getNodeData(id);
                    var self = this;
                    var postData;
                    if (!isValid) {
                        return;
                    }
                    this.isConditionSave = true;
                    postData = this.setConditionPostData();
                    $.ajax({
                        type: 'POST',
                        url: '${ctx}/actyw/actYwStatus/saveCondition',
                        data: postData,
                        success: function (data) {
                            if (data.res) {
                                self.changeGStatusType(nodeData.gstatusTtype);
                                self.getStatusIds(nodeData.gstatusTtype);
                                self.modelConditionShow = false;
                            }
                            showTip(data.msg, data.res == 1 ? 'success' : 'error', 1200)
                        },
                        error: function (error) {
                            dialogCyjd.createDialog(0, '网络连接失败，错误代码' + error.status);
                        }
                    }).done(function () {
                        self.isConditionSave = false;
                    })
                },

                deleteStatus: function (list) {
                    var nodeData = this.getNodeData(this.currentNodeEle.attr('model-id'));
                    var self = this;
                    $.ajax({
                        type: 'POST',
                        url: '${ctx}/actyw/actYwStatus/deleteStatus',
                        data: {
                            gnodeId: this.currentUUid,
                            statusId: list[0].id
                        },
                        success: function (data) {
                            if (data.res == '1') {
                                self.changeGStatusType(nodeData.gstatusTtype);
                                self.getStatusIds(nodeData.gstatusTtype);
                            }
//                            dialogCyjd.createDialog(data.res, data.msg);
                            showTip(data.msg, data.res == 1 ? 'success' : 'error', 1200)
                        },
                        error: function (error) {
                            dialogCyjd.createDialog(0, '网络连接失败，错误代码' + error.status)
                        }
                    })
                },

                getGType: function (type) {
                    var nodeStatusTypes = this.nodeStatusTypes
                    var gType;
                    for (var i = 0; i < nodeStatusTypes.length; i++) {
                        var item = nodeStatusTypes[i]
                        if (type == item.id) {
                            gType = item;
                            break;
                        }
                    }
                    return gType;
                },

                getClazz: function () {
                    var self = this;
                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/actyw/gnode/ajaxQueryClazz?theme=${group.theme}',
                        dataType: 'JSON',
                        contentType: 'application/json',
                        success: function (data) {
                            if (data.status) {
                                self.clazzIds = data.datas;
                            }

                        }
                    })
                },

                //接口部分调用
                getAddUUid: function () {
                    var id = this.uuids[0];
                    this.uuids.splice(0, 1);
                    return id;
                },

                //获取节点type
                getTypeId: function (id, parentId) {
                    var typeValue;
                    var level = parentId == this.rootId ? 1 : 2;
                    $.each(this.gNodeTypes, function (i, item) {
                        if (item.ntype.id == id && level == item.level) {
                            typeValue = item.id;
                            return false;
                        }
                    })
                    return typeValue;
                },

                //获取节点数据
                getNodeData: function (id) {
                    var node;
                    $.each(this.flowNodes, function (i, item) {
                        if (item.id == id) {
                            node = item;
                            return false;
                        }
                    })
                    return node
                },

                //节点选择图标
                openNodeIconModal: function (key) {
                    var iconUrl = this[key].iconUrl;
                    this.dataKey = key;
                    if (iconUrl) {
                        this.cropper.cropper('replace', ftpHttp + iconUrl.replace('/tool', ''));
                    }
                    if (this.nodeIcons.length < 1) {
                        this.getIconList();
                    }
                    this.modalShow = true;
                },

                //选择角色
                selectRoles: function (list) {
                    var currentNodeEle = this.currentNodeEle;
                    var vRoles = currentNodeEle.select('.v-audit-roles');
                    var vText = vRoles.select('text');
                    var vTextAttr = vText.attr();
                    var modelId = currentNodeEle.attr('model-id');
                    var nodeData = this.getNodeData(modelId)
                    var nameLen = 0;
                    var nameWidth = 1;
                    var name = (function () {
                        var names = [];
                        list.forEach(function (t) {
                            names.push(t.name);
                            nameLen += t.name.length;
                        });
                        return names;
                    })();
                    nameLen += name.length;
                    nameWidth *= 12 * nameLen;
//                    var vScale = currentNodeEle.select('.v-scale')
//                    var vShape = vScale.select('.v-shape');
//                    var boxWidth = vShape.getBBox().width;
//                    var originWidth = Math.ceil(boxWidth*0.5);
//                    var widthValue = (originWidth + nameWidth - 88);   //88固定值
//                    widthValue =  widthValue > originWidth ? widthValue : originWidth;
//                    widthValue = Math.ceil(widthValue);
//                    var scaleValue = widthValue / boxWidth;
//
//                    if(widthValue !=  originWidth){
//                        this.addMatrix(vScale);
//                        vScale.matrix.a = scaleValue;
//                        vScale.matrix.d = scaleValue;
//                        vScale.attr('transform', vScale.matrix.toTransformString())
//                    }
//                    console.log(nameWidth)

                    if (list.length > 0) {
                        this.roleGroup = list[0].roleGroup;
                    } else {
                        this.roleGroup = '';
                    }

                    vText.remove();
                    vRoles.append(this.designPaper.text(0, 0, name.join('，')).attr(vTextAttr))
                    nodeData.regType = '';
                    for (var i = 0; i < list.length; i++) {
                        if (list[i].id === this.studentId) {
                            nodeData.regType = '999'
                            break;
                        }
                    }
                    this.nodeDataUserTask = nodeData
                },

                //选择用户
                selectUsers: function (list) {
                },

                //选择表单
                selectForms: function (list) {
                },

                selectStatus: function () {

                },

                selectSequence: function (obj) {
                    var overallGroup = this.overallGroup;
                    var pathGroup = overallGroup.select('g[model-id="' + this.currentUUid + '"]');
                    var designPaper = this.designPaper;
                    var reTextElement = pathGroup.select('text')
                    var list = [];
                    var attr = {
                        fill: '#333333',
                        fontSize: 12
                    };
                    list = obj.selectedList || [];
//                    if (obj.rItem) {
//                        this.conditions.unshift(obj.rItem[0])
//                    }
                    if (reTextElement) {
                        reTextElement.remove();
                    }
                    if (list.length > 0) {
                        var textes = [];
                        var path = pathGroup.select('.v-path');
                        list.forEach(function (item) {
                            textes.push(item.state)
                        })
                        var textElement = designPaper.text(0, 0, textes);
                        this.changePathText(pathGroup, textElement)
                        textElement.attr(attr);
                        textElement.selectAll('tspan').forEach(function (tspan, i) {
                            if (i > 0) {
                                tspan.attr({
                                    'x': 0,
                                    'dy': '1em'
                                })
                            }
                        })
                        pathGroup.add(textElement)
                    }
                },

                //一级节点选择列表表单
                selectListForms: function (list) {
                    var nodeData = this.getNodeData(this.currentUUid);
                    nodeData.formIds = [];
                    nodeData.formIds = [].concat(list, nodeData.formNlistIds)
                },

                //一级节点选择审核表单
                selectNlistForms: function (list) {
                    var nodeData = this.getNodeData(this.currentUUid);
                    nodeData.formListIds = [];
                    for(var i = 0; i < list.length; i++){
                        list[i].listId && nodeData.formListIds.push({
                            id: list[i].listId
                        })
                    }
                    nodeData.formIds = [];
                    nodeData.formIds = [].concat(list, nodeData.formListIds)
                },


                //选择图标
                selectNodeIcon: function (item) {
                    this[this.dataKey].iconUrl = item.url;
                    this.modalShow = false;
                },

                //改变节点名称
                changeNodeName: function (name) {
                    var currentNodeEle = this.currentNodeEle;
                    var modelType = currentNodeEle.attr('model-type');
                    var vTitle;
                    var attr, text, group;
                    if (modelType == 40) {
                        vTitle = currentNodeEle.select('.v-title-sub-process');
                        text = vTitle.select('text');
                        group = vTitle;
                    } else if (modelType == 30) {
                        vTitle = currentNodeEle.select('.v-title');
                        text = vTitle.select('text');
                        group = vTitle;
                    } else {
                        vTitle = currentNodeEle.select('text');
                        text = vTitle;
                        group = currentNodeEle.select('.v-rotate')
                    }
                    attr = text.attr();
                    text.remove();
                    group.append(this.designPaper.text(0, 0, name).attr(attr))
                },

                //改变图标
                changeNodeIcon: function (file) {
                    this.copperIcon = file[0];
                    this.cropper.cropper('replace', file[0]);
                    this.iconFile = file[1];
                },

                //上传
                uploadIcon: function () {
                    var rUrl;
                    var copyUrl = this.fileUrl;
                    var formData = new FormData();
                    var braceReg = /\{\{(.)+?\}\}/g;
                    var mValueResults = copyUrl.match(braceReg);
                    var imgData = this.cropper.cropper('getData');
                    var self = this;
                    if (imgData.width <= 100 || imgData.height <= 100) {
                        dialogCyjd.createDialog(0, '请裁剪图片区域不小于100X100像素');
                        return
                    }

                    for (var i = 0; i < mValueResults.length; i++) {
                        var key = mValueResults[i].replace('{{', '');
                        key = key.replace('}}', '');
                        rUrl = copyUrl.replace(mValueResults[i], Math.floor(imgData[key]));
                        copyUrl = rUrl;
                    }

                    formData.append('upfile', this.iconFile);

                    $.ajax({
                        url: rUrl,
                        type: 'POST',
                        cache: false,
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function (data) {
                            self[self.dataKey].iconUrl = data.ftpUrl;
                            self.modalShow = false;
                        },
                        error: function (error) {

                        }
                    })

                },

                parseNodeList: function (list) {
                    var elements = this.overallGroup.selectAll('.v-translate');
                    var self = this;
                    elements.forEach(function (element) {
                        self.dragNode(element)
                    })
                },

                getAllNodes: function () {
                    var self = this;
                    var overallGroup = this.overallGroup;

                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/actyw/gnode/queryByGroup/' + this.groupId,
                        dataType: 'json',
                        success: function (data) {
                            if (data.status) {
                                var paper = JSON.parse(data.datas.group.uiJson);
                                var html = data.datas.group.uiHtml;
                                self.flowNodes = paper.list;
                                self.paper.width = paper.width;
                                self.paper.height = paper.height;
                                self.viewport.width = paper.width;
                                self.viewport.height = paper.height;
                                overallGroup.node.innerHTML = html;
                                self.parseNodeList(self.flowNodes);
                                overallGroup.selectAll('.v-path-group').forEach(function (group) {
                                    self.pathMousedown(group)
                                })
                            }

                        },
                        error: function () {

                        }
                    })
                },

                //获取所有的判定类型
                getRegTypes: function () {
                    var self = this;
                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/actyw/gnode/ajaxRegTypes?isAll=true',
                        dataType: 'JSON',
                        success: function (data) {
                            if (data.status) {
                                self.regTypes = JSON.parse(data.datas);
                            }
                        }
                    })
                },

                //新增
                //获取节点类型数据
                getActYwNodes: function () {
                    var list, self = this;
                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/actyw/actYwNode/query?isVisible=true',
                        dataType: 'json',
                        success: function (data) {
                            if (data.status) {
                                list = data.datas;
                                list.forEach(function (t) {
                                    if (t.uiJson) {
                                        switch (parseInt(t.type)) {
                                            case 10:
                                            case 20:
                                            case 30:
//                                                if (t.nodeKey == 'StartNoneEvent') {
//                                                    var addT = JSON.parse(JSON.stringify(t));
//                                                    addT.uiJson = JSON.stringify(self.getNewStartNode());
//                                                    self.taskNodes.push(addT);
//                                                }
                                                self.taskNodes.push(t);
                                                break;
                                            case 40:
                                                self.processNodes.push(t);
                                                break;
                                            case 50:
                                                self.gatewayNodes.push(t);
                                                break;
                                        }
                                    }
                                    if (t.nodeType === 'edge') {
                                        self.lineDefaultData = t;
                                    }

                                })
                            }
//                            console.log(self.lineDefaultData)
                        }
                    })
                },

                getNewStartNode: function () {
                    return {
                        "type": "g",
                        "translate": "matrix(1,0,0,1,0,235)",
                        "rotate": "matrix(1,0,0,1,0,0)",
                        "scale": "matrix(0.5,0,0,0.5,0,0)",
                        "children": [{
                            "type": "rect",
                            "controlSize": true,
                            "translate": "matrix(1,0,0,1,0,0)",
                            "attr": {
                                "width": 305,
                                "height": 60,
                                "fill": "#e6e6e6",
                                "style": "stroke-width: 1px; stroke: #b8b1b0; fill-opacity: 1"
                            }
                        }, {
                            "type": "image",
                            "translate": "matrix(1,0,0,1,10,9)",
                            "attr": {
                                "width": 40,
                                "height": 40,
                                "fill": "transparent",
                                "href": "/images/flow-start-arrow.png",
                                "style": "stroke-width: 1px; stroke: #b8b1b0; fill-opacity: 1"
                            }
                        }, {
                            "type": "text",
                            "text": "开始",
                            "translate": "matrix(1,0,0,1,78,20)",
                            "attr": {
                                "fill": "#333333",
                                "style": "font-size: 12px; font-family: Microsoft Yahei; text-anchor: middle;"
                            }
                        }]
                    }
                },
                //获取所有的角色
                getRoles: function () {
                    var self = this;
                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/actyw/gnode/ajaxGnodeRole',
                        success: function (data) {
                            if (data) {
                                for (var i = 0; i < data.length; i++) {
                                    if (data[i].name == '学生/导师') {
                                        data[i].name = '学生';
                                        break;
                                    }
                                }
                                self.roles = data;
                            }
                        }
                    })
                },

                //获取列表
                getForms: function () {
                    var self = this;
                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/actyw/gnode/ajaxGnodeForm/${group.flowType}?theme=${group.theme}&hasList=false&proType=' + this.proType,
                        dataType: 'json',
                        success: function (data) {
                            data.forEach(function (t) {
                                t.name = t.name.replace(/项目流程\/|大赛流程\//, '');
                            });
                            self.forms = data;
                        }
                    })
                },

                getUUIds: function (num) {
                    var self = this;
                    return $.ajax({
                        url: '${ctx}/sys/uuids/' + num,
                        type: 'GET',
                        success: function (data) {
                            if (data.status) {
                                self.uuids = self.uuids.concat(JSON.parse(data.id));
                            }
                        }
                    });
                },

                //获取图标list
                getIconList: function () {
                    var self = this;
                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/attachment/sysAttachment/ajaxIcons/gnode',
                        dataType: 'json',
                        success: function (data) {
                            self.nodeIcons = data;
                            self.iconLoad = true;
                        }
                    })
                },

                //获取NodeEtypes
                getNodeEtypes: function () {
                    var self = this;
                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/actyw/gnode/ajaxNodeEtypes',
                        dataType: 'json',
                        success: function (data) {
                            self.nodeEtypes = data;
                        }
                    })
                },

                getTaskTypes: function () {
                    var self = this;
                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/actyw/gnode/ajaxGnodeTaskTypes',
                        dataType: 'json',
                        success: function (data) {
                            if (data.status) {
                                self.taskTypes = JSON.parse(data.datas)
                            }
                        }
                    })
                },

                //根据流程类型查询所有表单(列表) 流程组列表
                getGroupFormList: function () {
                    var self = this;
                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/actyw/gnode/ajaxGnodeForm/${group.flowType}?theme=${group.theme}&hasList=true&proType=' + this.proType,
                        dataType: 'json',
                        success: function (data) {
                            data.forEach(function (t) {
                                t.name = t.name.replace(/项目流程\/|大赛流程\//, '');
                            });
                            self.groupForms = data;
                            self.listForm = data;
                        }
                    })
                },

                //
                getGStates: function () {
                    var self = this;
                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/actyw/gnode/ajaxDictStatusType',
                        dataType: 'json',
                        success: function (data) {
                            if (data.status) {
                                self.nodeStatusTypes = data.datas || [];
                            }
                        }
                    })
                },

                //get 默认 statusIds
                getStatusIds: function (type, nodeKey) {
                    var self = this;
                    if (!type) {
                        if (nodeKey) {
                            self[self.toLowerFirst(nodeKey)].statusIds = [];
                        } else {
                            self.statusIds = [];
                        }
                        return;
                    }
                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/actyw/gnode/ajaxQueryStates?gtype=' + type,
                        dataType: 'json',
                        success: function (data) {
                            if (nodeKey) {
                                self[self.toLowerFirst(nodeKey)].statusIds = data;
                            } else {
                                self.statusIds = data;
                            }
                        }
                    })
                },

                changeGStatusType: function (type) {
                    var self = this;
                    var gTypeData = this.getGType(type);
                    if (type) {
                        this.conditionType = gTypeData.regType;

                    }
                    if (!type) {
                        this[this.dataKey].statusIds = [];
                        return false;
                    }
                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/actyw/gnode/ajaxQueryStates?gtype=' + type || '',
                        dataType: 'json',
                        success: function (data) {
                            self[self.dataKey].statusIds = data;
                        }
                    })
                },

                //获取所有节点类别
                getAllGnodeTypes: function () {
                    var self = this;
                    $.ajax({
                        type: 'GET',
                        url: '${ctx}/actyw/gnode/ajaxGnodeTypes',
                        dataType: 'json',
                        success: function (data) {
                            if (data.status) {
                                self.gNodeTypes = JSON.parse(data.datas);
                            }
                        }
                    })
                },


            },
            beforeMount: function () {
                var self = this;
                this.getUUIds(10).done(function () {
                    self.getActYwNodes();
                    self.getAllNodes();
                    self.getRoles();
                    self.getForms();
                    self.getTaskTypes();
                    self.getGroupFormList();
                    self.getGStates();
                    self.getAllGnodeTypes();
                    self.getClazz();
                    self.getRegTypes();
                });
//                var groupId = $('input[type="hidden"].group-id').val();
//                console.log(groupId);


//                this.getNodeEtypes();
            },

            mounted: function () {
                var $win = $(window);
                var self = this;
                this.movePaper = Snap('#movePaper');
                //默认值为屏幕宽高;
                this.$paperScroll = $('.paper-scroller');
                var $paperContainer = $('.paper-container');
                var paperContainerWidth = this.paper.width || this.$paperScroll.width()
                var paperContainerHeight = this.paper.height || this.$paperScroll.height()
                this.viewport.width = paperContainerWidth - this.viewport.left * 2 - 30;
                this.viewport.height = paperContainerHeight - 15;
                this.paper.width = this.viewport.width;
                this.paper.height = this.viewport.height;

                this.paperContainer = {
                    minWidth: paperContainerWidth,
                    minHeight: paperContainerHeight
                }


                this.viewportMin.width = this.$paperScroll.width() - this.viewport.left * 2 - 30;
                this.viewportMin.height = this.$paperScroll.height() - 15;

                var overallGroup = this.overallGroup;
                $(document).on('keyup', function (event) {
                    if (event.keyCode === 46) {
                        if (self.sequenceFlowShow) {
                            self.removePaths(self.overallGroup.selectAll('g[model-id="' + self.sequenceFlow.id + '"]'))
                            self.removeNodes.forEach(function (item) {
                                $.each(self.flowNodes, function (i, node) {
                                    if (node.id === item) {
                                        overallGroup.select('g[model-id="' + node.id + '"]').remove();
                                        self.flowNodes.splice(i, 1);
                                        return false;
                                    }
                                })
                            });
                            self.sequenceFlowShow = false;
                        }

                    }
                })
            }
        })

    }(jQuery);
</script>


</html>