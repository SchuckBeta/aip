<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script src="${ctxStatic}/vue/vue.min.js"></script>
    <script src="${ctxStatic}/fullcalendar/moment.min.js"></script>
    <script src="/other/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
<style>
    .form-actions {
        border: none;
    }
    .checkbox-border{
        display: inline-block;
        border: 1px solid #ccc;
        border-radius:5px;
        padding-left: 12px;
    }
    .checkbox-border-add{
        display: inline-block;
        width: 33px;
        height: 30px;
        text-align: center;
        border-left: 1px solid #ccc;
        margin-left: 8px;
    }
</style>

<div id="actYwForm" class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
    <%--<div class="edit-bar-left">--%>
    <%--<span><c:if test="${not empty actYw.group.flowType}">${flowProjectTypes[0].name }</c:if><c:if--%>
    <%--test="${empty actYw.group.flowType}">项目流程</c:if></span>--%>
    <%--<i class="line weight-line"></i>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <%--<ul class="nav nav-tabs">--%>
    <%--<li><a href="${ctx}/actyw/actYw/list?group.flowType=${actYw.group.flowType}"><c:if--%>
    <%--test="${not empty actYw.group.flowType}">${flowProjectTypes[0].name }</c:if><c:if--%>
    <%--test="${empty actYw.group.flowType}">项目流程</c:if>列表</a></li>--%>
    <%--<li class="active"><a href="${ctx}/actyw/actYw/form?id=${actYw.id}&group.flowType=${actYw.group.flowType}"><c:if--%>
    <%--test="${not empty actYw.group.flowType}">${flowProjectTypes[0].name }</c:if><c:if--%>
    <%--test="${empty actYw.group.flowType}">项目流程</c:if> <shiro:hasPermission--%>
    <%--name="actyw:actYw:edit">${not empty actYw.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission--%>
    <%--name="actyw:actYw:edit">查看</shiro:lacksPermission></a></li>--%>
    <%--</ul>--%>
    <div v-show="isMounted" style="display: none">
        <form:form id="inputForm" modelAttribute="actYw" v-validate="{form: 'actYwForm'}"
                   action="${ctx}/actyw/actYw/save?group.flowType=${actYw.group.flowType}&isUpdateYw=false"
                   method="post"
                   class="form-horizontal">
            <form:hidden path="id"/>
            <form:hidden path="isPreRelease"/>
            <form:hidden path="proProject.id"/>
            <form:hidden path="proProject.menu.id"/>
            <form:hidden path="proProject.category.id"/>
            <input type="hidden" id="secondName" name="secondName" value="${secondName}"/>
            <input type="hidden" name="proProject.projectName" v-model="proProject.projectName">
            <sys:message content="${message}"/>
            <div class="edit-bar edit-bar-sm clearfix" style="margin-left: 10px;">
                <div class="edit-bar-left">
                    <span>项目属性</span>
                    <i class="line"></i>
                </div>
            </div>

            <c:if test="${not empty actYw.id }">
                <div class="control-group">
                    <label class="control-label"><i>*</i>功能类型：</label>
                    <div class="controls">
                        <c:forEach var="projectType" items="${flowProjectTypes }" varStatus="idx">
                            ${projectType.name }
                            <c:if test="${(idx.index+1) ne fn:length(flowProjectTypes)}">/</c:if>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
            <div class="control-group">
                <label class="control-label"><i>*</i> 关联流程：</label>
                <div class="controls">
                    <select ref="linkGroupId" name="groupId" class="required" @change="linkFlow($event)">
                        <option value="" label="--请选择--">--请选择--</option>
                        <c:forEach var="actYwGroup" items="${actYwGroups }">
                            <c:if test="${(actYw.id eq projectActYw.id) || (actYw.id  eq gcontestActYw.id)}">
                                <c:if test="${actYw.groupId eq actYwGroup.id}">
                                    <option value="${actYwGroup.id}" data-type="${actYwGroup.flowType}"
                                            selected="selected">${actYwGroup.name}</option>
                                </c:if>
                                <c:if test="${actYw.groupId ne actYwGroup.id}">
                                    <option value="${actYwGroup.id}"
                                            data-type="${actYwGroup.flowType}">${actYwGroup.name}</option>
                                </c:if>
                            </c:if>
                            <c:if test="${(actYw.id ne projectActYw.id) && (actYw.id  ne gcontestActYw.id)}">
                                <c:if test="${(actYwGroup.id ne projectActYw.group.id) && (actYwGroup.id  ne gcontestActYw.group.id) && (actYwGroup.id  ne promdActYw.group.id)}">
                                    <c:if test="${actYw.groupId eq actYwGroup.id}">
                                        <option value="${actYwGroup.id}" data-type="${actYwGroup.flowType}"
                                                selected="selected">${actYwGroup.name}</option>
                                    </c:if>
                                    <c:if test="${actYw.groupId ne actYwGroup.id}">
                                        <option value="${actYwGroup.id}"
                                                data-type="${actYwGroup.flowType}">${actYwGroup.name}</option>
                                    </c:if>
                                </c:if>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>
            </div>


            <%--<div class="control-group">
                <label class="control-label"><font color="red">*&nbsp;</font> 名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称：</label>
                <div class="controls">
                    &lt;%&ndash;<form:input id="proProjectProjectName" path="proProject.projectName" htmlEscape="false" maxlength="64" class="input-xlarge "/>&ndash;%&gt;
                    <span id="yazheng"></span>
                </div>
            </div>--%>

            <%--<c:if test="${actYw.group.flowType eq '1'}">--%>
            <template v-if="flowType == 1">
                <div class="control-group">
                    <label class="control-label"><i>*</i>大赛类型：</label>
                    <div class="controls">
                        <div class="input-append">
                            <select name="proProject.type" v-model="proProject.type" @change="changeCompetitionName"
                                    class="required">
                                <option value="">-请选择-</option>
                                <option v-for="(item, index) in competitionTypes" :key="item.id" :value="item.value">
                                    {{item.label}}
                                </option>
                            </select>
                            <button type="button" class="btn btn-default" @click.stop="openModal('competitionType')">+
                            </button>
                        </div>
                            <%--<c:forEach items="${fns:getDictList('competition_type')}" var="types">--%>
                            <%--<label class="radio inline">--%>
                            <%--<input type="radio" name="proProject.type" value="${types.value}" class="required"--%>
                            <%--v-model="proProject.type"--%>
                            <%--@change="changeProjectName('${types.label}')">${types.label}--%>
                            <%--</label>--%>
                            <%--</c:forEach>--%>


                            <%--<form:radiobuttons id="proProjectType" path="proProject.type"--%>
                            <%--items="${fns:getDictList('competition_type')}" itemLabel="label"--%>
                            <%--itemValue="value" htmlEscape="false" class="required"--%>
                            <%--onchange="updateProjectName(this)"/>--%>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label"><i>*</i>大赛类别：</label>
                    <div class="controls controls-checkbox">

                        <label class="checkbox inline" v-for="competitionCategory in competitionCategories">
                            <input type="checkbox" v-model="proProject.proCategorys" name="proProject.proCategorys"
                                   :value="competitionCategory.value" class="required">{{competitionCategory.label}}
                        </label>
                        <button type="button" class="btn btn-default" @click.stop="openCategoryModal('competition')">+
                        </button>

                            <%-- <form:radiobuttons path="proProject.proCategory"
                                items="${fns:getDictList('project_type')}" itemLabel="label"
                                itemValue="value" htmlEscape="false" class="required" /> --%>
                    </div>
                </div>
                    <%--<div class="control-group">--%>
                    <%--<label class="control-label"><i>*</i>大赛级别：</label>--%>
                    <%--<div class="controls controls-checkbox">--%>
                    <%--<form:checkboxes path="proProject.levels" items="${fns:getDictList('competition_format')}"--%>
                    <%--itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>--%>
                    <%--<span class="help-inline gray-color">项目属于哪一级别</span>--%>
                    <%--</div>--%>
                    <%--</div>--%>
                    <%--<div class="control-group">--%>
                    <%--<label class="control-label"><i>*</i>结果状态：</label>--%>
                    <%--<div class="controls controls-checkbox">--%>
                    <%--<form:checkboxes path="proProject.finalStatuss"--%>
                    <%--items="${fns:getDictList('competition_college_prise')}" itemLabel="label"--%>
                    <%--itemValue="value" htmlEscape="false" class="required"/>--%>
                    <%--<span class="help-inline gray-color">项目有哪几项审核结果状态</span>--%>
                    <%--</div>--%>
                    <%--</div>--%>
            </template>
            <%--</c:if>--%>
            <%--<c:if test="${actYw.group.flowType eq '13'}">--%>
            <template v-if="flowType == '13'">
                <div class="control-group">
                    <label class="control-label"><i>*</i>项目类型：</label>
                    <div class="controls">

                            <%--<c:forEach items="${fns:getDictList('project_style')}" var="types">--%>
                            <%--<label class="radio inline">--%>
                            <%--<input type="radio" name="proProject.type" value="${types.value}" class="required"--%>
                            <%--v-model="proProject.type"--%>
                            <%--@change="changeProjectName('${types.label}')">${types.label}--%>
                            <%--</label>--%>
                            <%--</c:forEach>--%>
                        <div class="input-append">
                            <select name="proProject.type" v-model="proProject.type" @change="changeProjectName"
                                    class="required">
                                <option value="">-请选择-</option>
                                <option v-for="(item, index) in project_styles" :key="item.id" :value="item.value">
                                    {{item.label}}
                                </option>
                            </select>
                            <button type="button" class="btn btn-default" @click.stop="openModal('project')">+</button>
                        </div>
                            <%--<form:select path="proProject.type" v-model="proProject.type" @change="changeProjectName('${types.label}')">--%>
                            <%--<form:option value="">-请选择-</form:option>--%>
                            <%--<c:forEach items="${fns:getDictList('project_style')}" var="types">--%>
                            <%--<form:option value="${types.value}">${types.label}</form:option>--%>
                            <%--<label class="radio inline">--%>
                            <%--<input type="radio" name="proProject.type" value="${types.value}" class="required"--%>
                            <%--v-model="proProject.type"--%>
                            <%--@change="changeProjectName('${types.label}')">${types.label}--%>
                            <%--</label>--%>
                            <%--</c:forEach>--%>
                            <%--</form:select>--%>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label"><i>*</i>项目类别：</label>
                    <div class="controls">
                        <div class="controls-checkbox">

                            <div class="checkbox-border">
                                <label class="checkbox inline" v-for="proCategory in proCategories" style="padding-top: 0;">
                                    <input type="checkbox" v-model="proProject.proCategorys" name="proProject.proCategorys"
                                           :value="proCategory.value" class="required">{{proCategory.label}}
                                </label>

                                <div class="checkbox-border-add" @click.stop="openCategoryModal('project')">
                                    <button type="button" class="btn btn-default" style="border: none;border-top-left-radius: 0;border-bottom-left-radius: 0;padding: 4px 12px 6px 13px;">+</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div v-show="isShowTime" class="control-group">
                    <label class="control-label">项目级别：</label>
                    <div class="controls controls-checkbox">
                        <form:checkboxes path="proProject.levels" items="${fns:getDictList('project_degree')}"
                                         itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
                            <%-- <form:radiobuttons path="proProject.level"
                                items="${fns:getDictList('project_degree')}" itemLabel="label"
                                itemValue="value" htmlEscape="false" class="required" /> --%>
                        <span class="help-inline gray-color">项目属于哪一级别</span>
                    </div>
                </div>
                <div v-show="isShowTime" class="control-group">
                    <label class="control-label">结果状态：</label>
                    <div class="controls controls-checkbox">
                        <form:checkboxes path="proProject.finalStatuss" items="${fns:getDictList('project_result')}"
                                         itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
                        <span class="help-inline gray-color">项目有哪几项审核结果状态</span>
                    </div>
                </div>
            </template>
            <div v-show="isShowTime" class="control-group">
                <label class="control-label">显示时间：</label>
                <div class="controls">
                    <c:forEach items="${fns:getDictList('yes_no')}" var="showTimes">
                        <label class="radio inline">
                            <input type="radio" name="showTime" value="${showTimes.value}" class="required"
                                   v-model="proProject.showTime"
                                   @change="changeShowTime">${showTimes.label}
                        </label>
                    </c:forEach>

                        <%--<form:radiobuttons path="showTime" items="${fns:getDictList('yes_no')}" itemLabel="label"--%>
                        <%--itemValue="value" class="required" v-model="proProject.showTime" />--%>
                </div>
            </div>
            <div v-show="isShowTime" class="control-group">
                <label class="control-label">申报时间：</label>
                <div class="controls">
                    <c:forEach items="${fns:getDictList('yes_no')}" var="nodeStates">
                        <label class="inline radio">
                            <input type="radio" name="proProject.nodeState" v-model="proProject.nodeState"
                                   class="required" value="${nodeStates.value}">${nodeStates.label}
                        </label>
                    </c:forEach>
                        <%--<form:radiobuttons path="proProject.nodeState"--%>
                        <%--items="${fns:getDictList('yes_no')}" itemLabel="label"--%>
                        <%--v-model="proProject.nodeState"--%>
                        <%--itemValue="value" htmlEscape="false" class="required"/>--%>
                    <span class="help-inline gray-color">申报是否加申请时间控制</span>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><i>*</i>开始时间：</label>
                <div class="controls">
                    <input name="proProject.startDate" type="text" readonly
                           @click="showStartDatePicker($event)" v-model="proProject.startDate"
                           class="Wdate required"
                           value="<fmt:formatDate value="${actYw.proProject.startDate}" pattern="yyyy-MM-dd"/>"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><i>*</i>结束时间：</label>
                <div class="controls">
                    <input name="proProject.endDate" type="text" class="Wdate required" readonly
                           @click="showEndDatePicker($event)" v-model="proProject.endDate"
                           value="<fmt:formatDate value="${actYw.proProject.endDate}" pattern="yyyy-MM-dd"/>"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><i>*</i>项目年份：</label>
                <div class="controls">
                    <input name="proProject.year" type="text" class="Wdate required" readonly
                           v-model="proProject.year"
                           @click.stop.prevent="showProjectYear($event)"/>
                </div>
            </div>
            <div class="control-group" style="display: none;">
                <label class="control-label">重置栏目：</label>
                <div class="controls controls-radio">
                    <form:radiobuttons path="proProject.restCategory"
                                       items="${fns:getDictList('yes_no')}" itemLabel="label"
                                       itemValue="value" htmlEscape="false" class="required"/>
                    <span class="help-inline gray-color">该前台栏目子栏目是否恢复到初始状态</span>
                </div>
            </div>
            <div class="control-group" style="display: none;">
                <label class="control-label">重置菜单：</label>
                <div class="controls controls-radio">
                    <form:radiobuttons path="proProject.restMenu"
                                       items="${fns:getDictList('yes_no')}" itemLabel="label"
                                       itemValue="value" htmlEscape="false" class="required"/>
                    <span class="help-inline gray-color">该后台菜单子菜单是否恢复到初始状态</span>
                </div>
            </div>
            <input type="hidden" name="proProject.imgUrl" value="/images/upload.png"/>
            <div class="edit-bar edit-bar-sm clearfix" style="margin-left: 10px;">
                <div class="edit-bar-left">
                    <span>审核时间</span>
                    <i class="line"></i>
                </div>
            </div>
            <table class="table table-bordered table-condensed table-hover table-orange table-center table-actYwForm">
                <thead>
                <tr>
                    <td>流程节点</td>
                    <td>有效期</td>
                    <td></td>
                </tr>
                </thead>
                <tbody>
                <tr v-show="proProject.nodeState == '1'">
                    <td>申报</td>
                    <td ref="nodeTimePicker0">
                        <div class="control-times">
                            <input name="nodeStartDate" type="text" class="Wdate input-medium"
                                   :class="{required: proProject.nodeState == '1'}"
                                   readonly
                                   @click="showNodeStartDatePicker($event)"
                                   v-model="proProject.nodeStartDate"
                                   value="<fmt:formatDate value='${actYw.proProject.nodeStartDate}' pattern='yyyy-MM-dd'/>"
                            >
                            <span class="zhi">至</span>
                            <input name="nodeEndDate" type="text" class="Wdate input-medium"
                                   readonly
                                   :class="{required: proProject.nodeState == '1'}"
                                   @click="showNodeEndDatePicker($event)"
                                   v-model="proProject.nodeEndDate"
                                   value="<fmt:formatDate value='${actYw.proProject.nodeEndDate}' pattern='yyyy-MM-dd'/>">
                            <div style="width: 120px; display: none; vertical-align: middle">
                            </div>
                            <div class="error-box">
                                <div class="error-first"></div>
                                <div class="error-last"></div>
                            </div>
                        </div>

                    </td>
                    <td>
                    </td>
                </tr>
                <tr v-show="proProject.showTime == 1" v-for="(item, index) in actYwGTimes">
                    <td>{{item.name}}<input type="hidden" name="nodeId" :value="item.gnodeId"></td>
                    <td>
                        <div class="control-times">
                            <input :name="'beginDate'+index" type="text" class="Wdate input-medium"
                                   :class="{required: actYwGTimes[index].status == '1'}" readonly
                                   v-model="actYwGTimes[index].beginDate"
                                   value=""
                                   @click.stop.prevent="showNodeGTimeStartDatePicker(item, index, $event)">
                            <span class="zhi">至</span>
                            <input :name="'endDate'+index" type="text" class="Wdate input-medium"
                                   :class="{required: actYwGTimes[index].status == '1'}" readonly
                                   v-model="actYwGTimes[index].endDate"
                                   value=""
                                   @click="showNodeGTimeEndDatePicker(item, index, $event)">
                                <%--<div style="width: 120px; display: none; vertical-align: middle">--%>
                                <%--<label class="radio inline"><input type="radio" :name="'status'+index" value="1"--%>
                                <%--v-model="actYwGTimes[index].status">是 </label>--%>
                                <%--<label class="radio inline"> <input type="radio" :name="'status'+index" value="0"--%>
                                <%--v-model="actYwGTimes[index].status">否</label>--%>
                                <%--</div>--%>
                            <div class="error-box">
                                <div class="error-first"></div>
                                <div class="error-last"></div>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="control-rate">
                            <label class="radio inline">
                                <input type="radio"  :name="'hasTpl'+index" value="1" v-model="actYwGTimes[index].hasTpl">是
                            </label>
                            <label class="radio inline">
                                <input type="radio" :name="'hasTpl'+index"  value="0" v-model="actYwGTimes[index].hasTpl">否
                            </label>
                                <%--<input type="hidden" :name="'hasTpl'+index" :value="actYwGTimes[index].hasTpl">--%>
                            <input type="hidden" :name="'excelTplClazz'+index" :value="actYwGTimes[index].excelTplClazz">
                            <select :disabled="actYwGTimes[index].hasTpl != '1'"  size="small" :name="'excelTplPath'+index">
                                <option value="exp_approval_template.xlsx">民大申报导入导出审核模板</option>
                                <option value="exp_mid_template.xlsx">民大中期导入导出审核模板</option>
                                <option value="exp_close_template.xlsx">民大结项导入导出审核模板</option>
                            </select>
                            <div class="error-box"></div>
                        </div>
                    </td>
                    <td style="display: none">
                        <div class="control-rate">
                            <input type="text" :name="'rate'+index" value="100" min="0" max="100" class="input-mini"
                                   :class="{required: actYwGTimes[index].rateStatus == '1'}"/>
                            <div class="help-inline">（<span class="red">默认为空，不限制</span>）</div>
                            <label class="radio inline">
                                <input type="radio" :name="'rateStatus'+index" value="1"
                                       v-model="actYwGTimes[index].rateStatus">是 </label>
                            <label class="radio inline"> <input type="radio" :name="'rateStatus'+index" value="0"
                                                                v-model="actYwGTimes[index].rateStatus">否 </label>
                            <div class="error-box"></div>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
            <div class="form-actions">
                <shiro:hasPermission name="actyw:actYw:edit">
                    <button class="btn btn-primary" type="submit">保存</button>
                </shiro:hasPermission>
                <button class="btn btn-default" type="button"
                        onclick="location.href='${ctx}/actyw/actYw/list?group.flowType=${actYw.group.flowType}'">返回
                </button>
            </div>
        </form:form>
    </div>
    <div v-show="modalAddProjectTypeShow"
         style="position: fixed;width: 100%;height: 100%;top: 0;left: 0;display: none;z-index: 100">
        <div v-drag class="modal" data-backdrop="static">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true"
                        @click="modalAddProjectTypeShow = false">
                    &times;
                </button>
                <h3 class="modal-title">添加{{projectStyleName}}</h3>
            </div>
            <div class="modal-body">
                <form ref="addDictForm" class="form-horizontal" v-validate2="{form: 'projectStyleValid'}"
                      autocomplete="off">
                    <div class="control-group" v-show="false">
                        <label class="control-label">字典类型：</label>
                        <div class="controls">
                            <p class="control-static">{{projectStyleName}}</p>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label"><i>*</i>名称：</label>
                        <div class="controls">
                            <input name="name" type="text" class="required" maxlength="10"
                                   v-model="projectStyleForm.name" autocomplete="off">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">排序编号：</label>
                        <div class="controls">
                            <input name="sort" type="number" min="0" class="number digits" maxlength="9"
                                   v-model="projectStyleForm.sort" autocomplete="off">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-default btn" @click="modalAddProjectTypeShow = false">取消</button>
                <button type="button"
                        :disabled="projectTypeSaving"
                        class="btn-primary btn" @click="saveProjectStyle">
                    {{projectTypeSaving? '保存中...' : '保存'}}
                </button>
            </div>
        </div>
    </div>


    <div v-show="modalCategoryShow"
         style="position: fixed;width: 100%;height: 100%;top: 0;left: 0;display: none;z-index: 100">
        <div v-drag class="modal" data-backdrop="static">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true"
                        @click="modalCategoryShow = false">
                    &times;
                </button>
                <h3 class="modal-title">添加{{categoryName}}</h3>
            </div>
            <div class="modal-body">
                <form ref="modalCategoryForm" class="form-horizontal" v-validate2="{form: 'modalCategoryValid'}"
                      autocomplete="off">
                    <div class="control-group">
                        <label class="control-label"><i>*</i>名称：</label>
                        <div class="controls">
                            <input name="name" type="text" class="required" maxlength="10"
                                   v-model="modalCategoryForm.name" autocomplete="off">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">排序编号：</label>
                        <div class="controls">
                            <input name="sort" type="number" min="0" class="number digits" maxlength="9"
                                   v-model="modalCategoryForm.sort" autocomplete="off">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-default btn" @click="modalCategoryShow = false">取消</button>
                <button type="button"
                        :disabled="categorySaving"
                        class="btn-primary btn" @click="saveCategory">
                    {{categorySaving? '保存中...' : '保存'}}
                </button>
            </div>
        </div>
    </div>
</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>
<script type="text/javascript">

    +function ($, Vue) {
        var actYwForm = new Vue({
            el: '#actYwForm',
            data: function () {
                return {
                    proProject: {
                        startDate: '',
                        endDate: '',
                        <%--showTime: '${actYw.showTime}',--%>
                        showTime: '1',
                        nodeState: '1',
                        nodeStartDate: '',
                        nodeEndDate: '',
                        type: '${actYw.proProject.type}',
                        projectName: '',
                        proCategorys: JSON.parse('${fns: toJson(actYw.proProject.proCategorys)}') || [],
                        year: '<fmt:formatDate value="${actYw.proProject.year}" pattern="yyyy-MM-dd"/>'
                    },


                    dictPtypeJson: JSON.parse('${fns:toJson(dictPtype)}'),
                    dictPctypeJson: JSON.parse('${fns:toJson(dictPctype)}'),
                    curDate: new Date(),
                    gapDay: 1,
                    nodeGayDay: 0,
                    nodeState: '${actYw.proProject.nodeState}',
                    actYwGtimeList: [],
                    nodeTimes: [],
                    isMounted: false,
                    flowType: '${actYw.group.flowType}',
                    competitionTypes: [],
                    project_styles: [],

                    proCategories: [],
                    competitionCategories: [],

                    actYwGTimes: [],
                    actYwForm: '',
                    beforeTime: '',
                    actYwAllGTimes: [],
                    gDateKey: '',
                    currentIndex: '',
                    projectStyleForm: {
                        typeid: '',
                        name: '',
                        sort: ''
                    },
                    projectStyleValid: '',
                    projectStyleName: '',
                    modalAddProjectTypeShow: false,
                    projectTypeSaving: false,


                    modalCategoryForm: {
                        name: '',
                        sort: '',
                        typeid: ''
                    },
                    modalCategoryValid: '',
                    modalCategoryShow: false,
                    categoryName: '',
                    categorySaving: false
                }
            },
            computed: {
                isShowTime: function () {
                    return this.flowType !== '1' && this.flowType !== '13';
                }
            },
            watch: {
                modalAddProjectTypeShow: function (value) {
                    if (!value) {
                        this.projectStyleValid.resetForm();
                        this.$refs.addDictForm.reset();
                        this.projectStyleForm.name = '';
                        this.projectStyleForm.sort = '';
                    }
                }
            },
            directives: {
                validate: {
                    inserted: function (element, binding, vnode) {
                        vnode.context[binding.value.form] = $(element).validate({
                            submitHandler: function (form) {
                                var dateArr = vnode.context.getDateArr();
                                var $form = $(form);
                                var $submit = $form.find('button[type="submit"]');
                                var isValidate;
                                var validateAllTimes;
                                var flowType = "${actYw.group.flowType}";
                                isValidate = vnode.context.validateTimes(dateArr);
//                                validateAllTimes = vnode.context.validateAllTimes(dateArr)
                                if (!isValidate.valid) {
                                    dialogCyjd.createDialog(0, isValidate.item.gnode.name + '时间大于后面节点时间');
                                    return false;
                                }
//                                if (!validateAllTimes.valid) {
//                                    dialogCyjd.createDialog(0, '设置的时间段有问题， 请检查');
//                                    return false;
//                                }
                                $submit.prop('disabled', true);

                                $.ajax({
                                    type: 'POST',
                                    url: "${ctx}/actyw/actYw/ajaxUserDefinedSave?group.flowType=${actYw.group.flowType}&isUpdateYw=false",
                                    data: $form.serialize(),
                                    dataType: 'JSON',
                                    success: function (data) {
                                        if (data.status) {
                                            dialogCyjd.createDialog(1, data.msg, {
                                                buttons: [{
//                                                    text: '发布'+ (flowType == 1 ? '大赛' : '项目'),
                                                    text: '设置编号规则',
                                                    'class': 'btn btn-small btn-primary',
                                                    'click': function () {
                                                        <%--location.href = '${ctx}/actyw/actYw/list?group.flowType='+flowType+'&proProject.projectName='+vnode.context.proProject.projectName--%>
                                                        location.href = '${ctx}/sys/sysNumberRule';

                                                    }
                                                }, {
                                                    text: '返回',
                                                    'class': 'btn btn-small btn-default',
                                                    'click': function () {
                                                        location.href = '${ctx}/actyw/actYw/list?group.flowType=${actYw.group.flowType}'
                                                    }
                                                }]
                                            });
                                        } else {
                                            dialogCyjd.createDialog(0, data.msg);
                                        }
                                        $submit.prop('disabled', false);
                                    },
                                    error: function (error) {
                                        dialogCyjd.createDialog(0, '网络连接失败,错误代码' + error.status);
                                        $submit.prop('disabled', false);
                                    }
                                })
                                return false;
//                                form.submit();
                            },
                            errorPlacement: function (error, element) {
                                if (element.is(":checkbox") || element.is(":radio") || element.parent().hasClass('input-append')) {
                                    error.appendTo(element.parent().parent());
                                } else if (element.parent().hasClass('control-times')) {
                                    var name = element.attr('name');
                                    var $errorBox = element.parent().parent().find('.error-box');
                                    if (/nodeStartDate|beginDate/.test(name)) {
                                        error.appendTo($errorBox.find('.error-first'));
                                    } else {
                                        error.appendTo($errorBox.find('.error-last'));
                                    }
                                } else if (element.parent().hasClass('control-rate')) {
                                    var $errorRateBox = element.parent().parent().find('.error-box');
                                    error.appendTo($errorRateBox);
                                } else {
                                    error.insertAfter(element);
                                }
                            }
                        })
                    }
                },
                validate2: {
                    inserted: function (element, binding, vnode) {
                        vnode.context[binding.value.form] = $(element).validate({
                            submitHandler: function () {
                                vnode.context.saveProjectStyle();
                                return false;
                            }
                        })
                    }
                },
                drag: {
                    inserted: function (element, binding, vnode) {
                        $(element).draggable({
                            handle: ".modal-header",
                            containment: "body"
                        })
                    },
                }
            },
            methods: {
                changeProjectName: function (label) {
                    var project_styles = this.project_styles;
                    var len = project_styles.length;
                    for (var i = 0; i < len; i++) {
                        if (this.proProject.type === project_styles[i].value) {
                            this.proProject.projectName = project_styles[i].label;
                            break;
                        }
                    }
                },

                changeCompetitionName: function () {
                    var competitionTypes = this.competitionTypes;
                    var len = competitionTypes.length;
                    for (var i = 0; i < len; i++) {
                        if (this.proProject.type === competitionTypes[i].value) {
                            this.proProject.projectName = competitionTypes[i].label;
                            break;
                        }
                    }
                },

                saveProjectStyle: function () {
                    var self = this;
                    if (!this.projectStyleValid.form()) {
                        return false;
                    }
                    this.projectTypeSaving = true;
                    this.projectStyleForm.typeid = this.dictPtypeJson.id;
                    $.ajax({
                        type: 'POST',
                        url: '${ctx}/sys/dict/addDict',
                        data: this.projectStyleForm,
                        dataType: 'JSON',
                        success: function (data) {
                            self.modalAddProjectTypeShow = false;
                            dialogCyjd.createDialog(data.ret, data.msg);
                            self.projectTypeSaving = false;
                            if (data.ret == 1) {
                                self.projectStyleValid.resetForm();
                                self.$refs.addDictForm.reset();
                                self.projectStyleForm.name = '';
                                self.projectStyleForm.sort = '';
                                self[(self.flowType == 13 ? 'getProjectStyles' : 'getCompetitionTypes')]();
                            }
                        },
                        error: function (error) {
                            dialogCyjd.createDialog(0, '网络连接错误，错误代码' + error.status);
                            self.projectTypeSaving = false;
                        }
                    })
                },

                openModal: function (type) {
                    this.modalAddProjectTypeShow = true;
                    this.projectStyleName = type == 'project' ? '项目类型' : '大赛类型';
                },

                openCategoryModal: function (type) {
                    this.modalCategoryShow = true;
                    this.categoryName = type == 'project' ? '项目类别' : '大赛类别';
                },

                saveCategory: function () {
                    var self = this;
                    if (!this.modalCategoryValid.form()) {
                        return false;
                    }
                    this.categorySaving = true;
                    this.modalCategoryForm.typeid = this.dictPctypeJson.id;
                    console.info(this.modalCategoryForm);
                    $.ajax({
                        type: 'POST',
                        url: '${ctx}/sys/dict/addDict',
                        data: this.modalCategoryForm,
                        dataType: 'JSON',
                        success: function (data) {
                            self.modalCategoryShow = false;
                            dialogCyjd.createDialog(data.ret, data.msg);
                            self.categorySaving = false;
                            if (data.ret == 1) {
                                self.modalCategoryValid.resetForm();
                                self.$refs.modalCategoryForm.reset();
                                self.modalCategoryForm.name = '';
                                self.modalCategoryForm.sort = '';
                                self['getPctype'](self.dictPctypeJson.value);
                            }
                        },
                        error: function (error) {
                            dialogCyjd.createDialog(0, '网络连接错误，错误代码' + error.status);
                            self.projectTypeSaving = false;
                        }
                    })
                },

                changeShowTime: function () {
                    var groupId = this.$refs.linkGroupId.value;
                    if (this.proProject.showTime == 0 || !groupId) {
                        this.actYwGtimeList = [];
                        this.actYwGTimes = [];
                        return;
                    }
                    this.getNodeTimes(groupId);
                },

                linkFlow: function ($event) {
                    var groupId = $event.target.value;
                    this.flowType = $($event.target).find('option:selected').attr('data-type');
                    if (this.proProject.showTime == 0 || !groupId) {
                        this.actYwGtimeList = [];
                        this.actYwGTimes = [];
                        return;
                    }
                    this[(this.flowType == 13 ? 'getProjectStyles' : 'getCompetitionTypes')]();

                    this.getNodeTimes(groupId);
                },

                showProjectYear: function ($event) {
                    var self = this;
                    WdatePicker({
                        el: $event.target,
                        isShowToday: false,
                        dateFmt: 'yyyy',
                        isShowClear: true,
                        onpicked: function () {
                            self.proProject.year = $event.target.value
                        },
                        oncleared: function () {
                            self.proProject.year = ''
                        }
                    });
                },


                getNodeTimes: function (groupId) {
                    var self = this;
                    $.ajax({
                        type: 'GET',
                        url: 'changeModel',
                        data: {
                            id: groupId
                        },
                        dataType: 'json',
                        success: function (data) {
                            self.actYwGTimes = [];
                            self.actYwGtimeList = data;
                            self.actYwGtimeList.forEach(function (item) {
                                self.actYwGTimes.push({
                                    id: item.id,
                                    beginDate: '',
                                    endDate: '',
                                    status: '1',
                                    level: item.level,
                                    name: item.name,
                                    hasTpl: '0',
                                    gnodeId: item.id,
                                    rateStatus: '0'
                                })
                            })
                        },
                        error: function (error) {

                        }
                    })
                },


                //获取结束时间
                getEndDate: function (item, key) {
                    var endDate = this.proProject.endDate;
                    if (endDate) {
                        endDate = new Date(endDate);
                        endDate = endDate.setDate(endDate.getDate() - this.nodeGayDay);
                        endDate = moment(endDate).format('YYYY-MM-DD');
                    }
                    if (key === 'endDate') {

                    }
                    if (key === 'beginDate') {
                        endDate = item.endDate || endDate;
                    }
                    return endDate;
                },

                //获取最小时间
                getStartDate: function (item, key) {
                    var minDate = this.proProject.startDate;
                    if (minDate) {
                        minDate = new Date(minDate);
                        minDate = minDate.setDate(minDate.getDate() + this.nodeGayDay);
                        minDate = moment(minDate).format('YYYY-MM-DD');
                    }
                    if (key === 'endDate') {
                        minDate = item.beginDate || minDate;
                    }
                    if (key === 'beginDate') {
                        minDate = this.getBeforeDate(item);
                    }
                    return minDate;
                },

                //获取前一个节点的最小值
                getBeforeDate: function (item) {
                    var dateArr = this.getDateArr();
                    var beforeDates = this.getBeginDateBefore(dateArr, item.id);
                    return this.getBeforeSingleDate(beforeDates)
                },

                getBeforeSingleDate: function (beforeDates) {
                    var date;
                    for (var i = beforeDates.length - 1; i > -1; i--) {
                        var itemDate = beforeDates[i];
                        if ($.type(itemDate) === 'array') {
                            date = this.getBeforeSingleDate(itemDate);
                            if (date) {
                                break;
                            }
                        } else {
                            if (itemDate.endDate) {
                                date = itemDate.endDate;
                                break;
                            }
                            if (itemDate.beginDate) {
                                date = itemDate.beginDate;
                                break;
                            }
                        }
                    }
                    return date;
                },

                getBeginDateBefore: function (arr, id) {
                    var index;
                    for (var i = 0; i < arr.length; i++) {
                        var itemDate = arr[i];
                        if ($.type(itemDate) === 'array') {
                            var hasId = itemDate.some(function (item) {
                                return item.id === id;
                            });
                            if (hasId) {
                                index = i;
                                break;
                            }
                        } else {
                            if (itemDate.id === id) {
                                index = i;
                                break;
                            }
                        }
                    }
                    return arr.slice(0, index);
                },


                //获取去重后的 levles
                getLevels: function () {
                    var levels = [];
                    var levelObj = {};

                    this.actYwGTimes.forEach(function (item) {
                        var level = item.level;
                        if (level) {
                            if (!levelObj[level]) {
                                levels.push(level);
                            }
                            levelObj[level] = true;
                        }
                    });
                    levels = levels.sort(function (a, b) {
                        return a - b > 0;
                    });
                    return levels;
                },

                //网关数据
                getDateArr: function () {
                    var dates = [];
                    var levelDates;
                    var self = this;
                    var levels = this.getLevels();
                    levels.forEach(function (level) {
                        levelDates = self.getDateByLevel(level);
                        dates.push(levelDates)
                    });
                    dates.unshift({
                        beginDate: this.proProject.nodeStartDate,
                        endDate: this.proProject.nodeEndDate,
                        gnode: {
                            name: '申报'
                        }
                    });
                    return dates;
                },

                //获取同level时间段
                getDateByLevel: function (level) {
                    var dateArr = [];
                    if (!level) {
                        return dateArr
                    }
                    this.actYwGTimes.forEach(function (item) {
                        var itemLevel = item.level;
                        if (itemLevel === level) {
                            dateArr.push(item);
                        }
                    });
                    return dateArr.length > 1 ? dateArr : dateArr[0];
                },

                //验证时间
                validateTimes: function (dateArr) {
                    var allValid = false;
                    var res;
                    for (var i = 0; i < dateArr.length; i++) {
                        var item = dateArr[i];
                        if ($.type(item) === 'array') {
                            res = this.validateTimes(item);
                            allValid = res.valid;
                        } else {
                            allValid = this.validateSingleDate(item.beginDate, item.endDate);
                            res = {
                                valid: allValid,
                                item: item
                            };
                        }
                        if (!allValid) {
                            break;
                        }
                    }
                    return res;
                },

                //验证单个时间
                validateSingleDate: function (startDate, endDate) {
                    var startTimes, endTimes;
                    if (!startDate || !endDate) {
                        return true;
                    }
                    startTimes = new Date(startDate).getTime();
                    endTimes = new Date(endDate).getTime();
                    return endTimes - startTimes >= this.nodeGayDay * 24 * 60 * 60 * 1000;
                },

                //validateAllTimes;
                validateAllTimes: function (dateArr) {
                    var res = {
                        valid: true
                    };
                    var times, copyTimes;
                    this.getAllTimes(dateArr);
                    this.addOtherTimes();
                    times = this.allTimes;
                    copyTimes = times.slice(0);
                    copyTimes = copyTimes.sort(function (a, b) {
                        return new Date(a).getTime() - new Date(b).getTime() > 0;
                    });
                    for (var i = 0; i < times.length; i++) {
                        if (times[i] != copyTimes[i]) {
                            res = {
                                valid: false,
                                time: times[i]
                            };
                            break;
                        }
                    }
                    return res;
                },

                //获取所有的时间
                getAllTimes: function (dateArr) {
                    var self = this;
                    self.allTimes = [];
                    dateArr.forEach(function (item) {
                        var beginDate, endDate, maxMin;
                        if ($.type(item) === 'array') {
                            maxMin = self.getArrMaxMinTime(item);
                            if (maxMin.min) {
                                self.allTimes.push(moment(new Date(maxMin.min)).format('YYYY-MM-DD'))
                            }
                            if (maxMin.max) {
                                self.allTimes.push(moment(new Date(maxMin.max)).format('YYYY-MM-DD'))
                            }
                        } else {
                            beginDate = item.beginDate;
                            endDate = item.endDate;
                            if (beginDate) {
                                self.allTimes.push(beginDate)
                            }
                            if (endDate) {
                                self.allTimes.push(endDate)
                            }
                        }
                    })

                },

                getArrMaxMinTime: function (arr) {
                    var bTimes = [], eTimes = [];
                    arr.forEach(function (item) {
                        if (item.beginDate) {
                            bTimes.push(new Date(item.beginDate).getTime())
                        }
                        if (item.endDate) {
                            eTimes.push(new Date(item.endDate).getTime())
                        }
                    });
                    return {
                        max: Math.max.apply(null, bTimes),
                        min: Math.min.apply(null, eTimes)
                    }
                },

                //添加申报时间
                addOtherTimes: function () {
//                    var nodeStartDate = this.proProject.nodeStartDate;
//                    var nodeEndDate = this.proProject.nodeEndDate;
                    var startDate = this.proProject.startDate;
                    var endDate = this.proProject.endDate;
//                    if (nodeEndDate) {
//                        this.allTimes.unshift(nodeEndDate)
//                    }
//                    if (nodeStartDate) {
//                        this.allTimes.unshift(nodeStartDate)
//                    }
                    if (startDate) {
                        this.allTimes.unshift(startDate)
                    }
                    if (endDate) {
                        this.allTimes.push(endDate)
                    }
                },

                getPctype: function (pctype) {
                    var self = this;
                    $.ajax({
                        url: '${ctx}/actyw/actYw/ajaxPctype?pctype=' + pctype,
                        type: 'GET',
                        contentType: 'application/json;charset=utf-8',
                        dataType: 'JSON',
                        success: function (data) {
                            if (data.status) {
                                self.proCategories = data.datas;
                                self.competitionCategories = data.datas
                            }
                        },
                        error: function () {

                        }
                    })
                },
                getProjectStyles: function () {
                    var self = this;
                    $.ajax({
                        url: '${ctx}/actyw/actYw/ajaxProjectStyle',
                        type: 'GET',
                        contentType: 'application/json;charset=utf-8',
                        dataType: 'JSON',
                        success: function (data) {
                            if (data.status) {
                                self.project_styles = data.datas
                            }
                        },
                        error: function () {

                        }
                    })
                },

                getCompetitionTypes: function () {
                    var self = this;
                    $.ajax({
                        url: '${ctx}/actyw/actYw/ajaxCompetitionTypes',
                        type: 'GET',
                        contentType: 'application/json;charset=utf-8',
                        dataType: 'JSON',
                        success: function (data) {
                            if (data.status) {
                                self.competitionTypes = data.datas
                            }
                        },
                        error: function () {

                        }
                    })
                },


                showNodeGTimeStartDatePicker: function (item, index, $event) {
                    var minDate;
                    var self = this;
                    var maxDate = this.getEndDate(item, 'beginDate');
                    minDate = this.getStartDate(item, 'beginDate');

                    WdatePicker({
                        el: $event.target,
                        minDate: minDate,
                        maxDate: maxDate,
                        onpicked: function () {
                            self.actYwGTimes[index].beginDate = $event.target.value;
                        },
                        oncleared: function () {
                            self.actYwGTimes[index].beginDate = ''
                        }
                    })

                },

                showNodeGTimeEndDatePicker: function (item, index, $event) {
                    var minDate;
                    var self = this;
                    var maxDate = this.getEndDate(item, 'endDate');
                    minDate = this.getStartDate(item, 'endDate');
                    WdatePicker({
                        el: $event.target,
                        minDate: minDate,
                        maxDate: maxDate,
                        onpicked: function () {
                            self.actYwGTimes[index].endDate = $event.target.value;
                        },
                        oncleared: function () {
                            self.actYwGTimes[index].endDate = ''
                        }
                    })
                },

                emptyTableDate: function () {
                    this.actYwGTimes.forEach(function (item) {
                        item.beginDate = '';
                        item.endDate = '';
                    })
                    this.proProject.nodeStartDate = '';
                    this.proProject.nodeEndDate = '';
                },

                showStartDatePicker: function ($event) {
                    var endDate = this.proProject.endDate;
                    var self = this;


                    WdatePicker({
                        el: $event.target,
//                        minDate: moment(this.curDate).format('YYYY-MM-DD'),
                        maxDate: endDate,
                        onpicked: function () {
                            self.proProject.startDate = $event.target.value;
                            self.emptyTableDate();
                        },
                        oncleared: function () {
                            self.proProject.startDate = '';
                            self.emptyTableDate()
                        }
                    })
                },

                showEndDatePicker: function ($event) {
                    var self = this;
                    WdatePicker({
                        el: $event.target,
                        minDate: this.proProject.startDate,
                        onpicked: function () {
                            self.proProject.endDate = $event.target.value;
                            self.emptyTableDate();
                        },
                        oncleared: function () {
                            self.proProject.endDate = '';
                            self.emptyTableDate();
                        }
                    })
                },


                showNodeStartDatePicker: function ($event) {
                    var self = this;
                    WdatePicker({
                        el: $event.target,
                        minDate: this.proProject.startDate,
                        maxDate: this.proProject.endDate,
                        onpicked: function () {
                            self.proProject.nodeStartDate = $event.target.value;
                        },
                        oncleared: function () {
                            self.proProject.nodeStartDate = ''
                        }
                    })
                },

                showNodeEndDatePicker: function ($event) {
                    var self = this;

                    WdatePicker({
                        el: $event.target,
                        minDate: this.proProject.nodeStartDate,
                        maxDate: this.proProject.endDate,
                        onpicked: function () {
                            self.proProject.nodeEndDate = $event.target.value;
                        },
                        oncleared: function () {
                            self.proProject.nodeEndDate = ''
                        }
                    })
                },
            },
            beforeMount: function () {
                this[(this.flowType == 13 ? 'getProjectStyles' : 'getCompetitionTypes')]();

                this['getPctype'](this.dictPctypeJson.value);

                this.getNodeTimes('${actYw.groupId}')

            },
            mounted: function () {
                this.isMounted = true;
            }
        })
    }(jQuery, Vue);

</script>
</body>
</html>