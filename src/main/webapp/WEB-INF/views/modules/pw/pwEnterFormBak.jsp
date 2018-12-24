<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script src="${ctxStatic}/fullcalendar/moment.min.js"></script>
</head>
<body>
<div class="container-fluid container-fluid-audit">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>入驻审核</span> <i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="inputForm" modelAttribute="pwEnter" action=""
               method="post" class="form-horizontal form-container">
        <form:hidden path="id"/>
        <form:hidden path="applicant.id"/>
        <input type="hidden" id="secondName" name="secondName"value="${secondName}"/>
        <div class="edit-bar edit-bar-sm clearfix">
            <div class="edit-bar-left">
                <span>入驻基本信息</span> <i class="line"></i>
                <a data-toggle="collapse" href="#projectPeopleInfo">
                    <i class="icon-collaspe icon-double-angle-up"></i>
                </a>
            </div>
        </div>
        <div id="projectPeopleInfo" class="panel-body collapse in">
            <div class="row-fluid row-info-fluid">
                <div class="span6">
                    <span class="item-label">入驻编号：</span>
                    <div class="items-box">
                            ${pwEnter.no}
                    </div>
                </div>
                <div class="span6">
                    <span class="item-label">申请时间：</span>
                    <div class="items-box">
                        <fmt:formatDate value="${pwEnter.createDate}"
                                        pattern="yyyy-MM-dd"/>
                    </div>

                </div>
            </div>
            <div class="row-fluid row-info-fluid">
                <div class="span6">
                    <span class="item-label">负责人：</span>
                    <div class="items-box">
                            ${pwEnter.applicant.name}
                    </div>
                </div>
                <div class="span6">
                    <span class="item-label">专业：</span>
                    <div class="items-box">
                            ${pwEnter.applicant.office.name}
                    </div>
                </div>
            </div>
            <div class="row-fluid row-info-fluid">
                <div class="span6">
                    <span class="item-label">学院：</span>
                    <div class="items-box">
                            ${pwEnter.applicant.office.name}
                    </div>
                </div>
                <div class="span6">
                    <span class="item-label">学号：</span>
                    <div class="items-box">
                            ${pwEnter.applicant.no}
                    </div>
                </div>
            </div>
            <div class="row-fluid row-info-fluid">
                <div class="span6">
                    <span class="item-label">联系方式：</span>
                    <div class="items-box">
                            ${pwEnter.applicant.mobile}
                    </div>
                </div>
                <div class="span6">
                    <span class="item-label">邮件：</span>
                    <div class="items-box">
                            ${pwEnter.applicant.email}
                    </div>
                </div>
            </div>
        </div>
        <c:if test="${not empty pwEnter.eprojects}">
            <input id="paramsProjectTeamId" type="hidden"
                   value="${pwEnter.eprojects[0].project.teamId}">
            <input id="paramsProjectProId" type="hidden"
                   value="${pwEnter.eprojects[0].project.id}">
            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>入驻项目基本信息</span> <i class="line"></i> <a
                        data-toggle="collapse" href="#projectInfo"><i
                        class="icon-collaspe icon-double-angle-up"></i></a>
                </div>
            </div>
            <div id="projectInfo" class="panel-body collapse in">
                <div class="panel-inner">
                    <div class="row-fluid row-info-fluid">
                        <div class="span12">
                            <span class="item-label">项目名称：</span>
                            <div class="items-box">
                                    ${pwEnter.eprojects[0].project.name}
                            </div>
                        </div>
                    </div>
                    <div class="row-fluid row-info-fluid">
                        <div class="span12">
                            <span class="item-label">项目类型：</span>
                            <div class="items-box">
                                    ${fns:getDictLabel(pwEnter.eprojects[0].project.proTyped, 'act_project_type', '')}
                            </div>
                        </div>
                    </div>
                    <div class="row-fluid row-info-fluid">
                        <div class="span6">
                            <span class="item-label">项目編号：</span>
                            <div class="items-box">
                                    ${pwEnter.eprojects[0].project.number}
                            </div>
                        </div>
                        <div class="span6">
                            <span class="item-label">项目类别：</span>
                            <div class="items-box">
                                <c:if test="${fn:contains(pwEnter.eprojects[0].project.proType, '1,')}">
                                    ${fns:getDictLabel(pwEnter.eprojects[0].project.type, 'project_style', '')}
                                </c:if>
                                <c:if test="${fn:contains(pwEnter.eprojects[0].project.proType, '7,')}">
                                    ${fns:getDictLabel(pwEnter.eprojects[0].project.type, 'competition_type', '')}
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="row-fluid row-info-fluid">
                        <div class="span12">
                            <span class="item-label">项目简介：</span>
                            <div class="items-box">${pwEnter.eprojects[0].project.introduction}</div>
                        </div>
                    </div>
                    <div class="row-fluid row-info-fluid">
                        <div class="span12">
                            <span class="item-label">项目入驻说明：</span>
                            <div class="items-box">${pwEnter.eproject.remarks}</div>
                        </div>
                    </div>
                </div>
                <div class="panel-inner">
                    <div class="table-caption">学生团队</div>
                    <table
                            class="table table-bordered table-condensed table-orange table-center table-nowrap table-hover">
                        <thead>
                        <tr>
                            <th>序号</th>
                            <th>姓名</th>
                            <th>学号</th>
                            <th>学院</th>
                            <th>专业</th>
                            <th>联系电话</th>
                        </tr>
                        </thead>
                        <tbody id="projectTableStudent">

                        </tbody>
                    </table>
                    <div class="table-caption">指导老师</div>
                    <table
                            class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
                        <thead>
                        <tr>
                            <th>序号</th>
                            <th>姓名</th>
                            <th>工号</th>
                            <th>导师类型</th>
                            <th>联系电话</th>
                            <th>E-mail</th>
                            <th>单位（学院或企业、机构）</th>
                        </tr>
                        </thead>
                        <tbody id="projectTableTeacher">

                        </tbody>
                    </table>
                </div>
                <div class="edit-bar edit-bar-sm clearfix hide">
                    <div class="edit-bar-left">
                        <span>附件</span> <i class="line"></i>
                    </div>
                </div>
                <div class="accessories">
                    <div class="accessory" id="projectFiles">
                            <%--<div class="accessory-info">--%>
                            <%--<a><img src="/img/filetype/rar.png">--%>
                            <%--<span class="accessory-name">fhjd.rar</span>--%>
                            <%--</a><i class="btn-delete-accessory"><img src="/img/remove-accessory.png"></i>--%>
                            <%--</div>--%>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${not empty pwEnter.eteam}">
            <input id="paramsTeamId" type="hidden"
                   value="${pwEnter.eteam.team.id}">
            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>入驻团队信息</span> <i class="line"></i> <a data-toggle="collapse"
                                                                href="#teamInfo"><i
                        class="icon-collaspe icon-double-angle-up"></i></a>
                </div>
            </div>
            <div id="teamInfo" class="panel-body collapse in">
                <div class="panel-inner">
                        <%--<p>项目团队：${pwEnter.eteam.team.name}</p>--%>
                    <div class="row-fluid row-info-fluid">
                        <div class="span12">
                            <span class="item-label">项目团队：</span>
                            <div class="items-box">
                                    ${pwEnter.eteam.team.name}
                            </div>
                        </div>
                    </div>
                    <div class="row-fluid row-info-fluid">
                        <div class="span12">
                            <span class="item-label">团队入驻说明：</span>
                            <div class="items-box">${pwEnter.eteam.remarks}</div>
                        </div>
                    </div>


                    <div class="table-caption">学生团队</div>
                    <table
                            class="table table-bordered table-condensed table-orange table-center table-nowrap table-hover">
                        <thead>
                        <tr>
                            <th>序号</th>
                            <th>姓名</th>
                            <th>学号</th>
                            <th>学院</th>
                            <th>专业</th>
                            <th>联系电话</th>
                        </tr>
                        </thead>
                        <tbody id="teamTableStudent">

                        </tbody>
                    </table>
                    <div class="table-caption">指导老师</div>
                    <table
                            class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
                        <thead>
                        <tr>
                            <th>序号</th>
                            <th>姓名</th>
                            <th>工号</th>
                            <th>导师类型</th>
                            <th>联系电话</th>
                            <th>E-mail</th>
                            <th>单位（学院或企业、机构）</th>
                        </tr>
                        </thead>
                        <tbody id="teamTableTeacher">

                        </tbody>
                    </table>
                    <div class="edit-bar edit-bar-sm clearfix hide">
                        <div class="edit-bar-left">
                            <span>附件</span> <i class="line"></i>
                        </div>
                    </div>
                    <div class="accessories">
                        <div class="accessory" id="teamFiles"></div>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${not empty pwEnter.ecompany}">
            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>入驻企业基本信息</span> <i class="line"></i> <a
                        data-toggle="collapse" href="#companyDetail"><i
                        class="icon-collaspe icon-double-angle-up"></i></a>
                </div>
            </div>
            <div id="companyDetail" class="panel-body collapse in">
                <div class="panel-inner">
                    <div class="row-fluid row-info-fluid">
                        <div class="span6">
                            <span class="item-label">企业名称：</span>
                            <div class="items-box">
                                    ${pwEnter.ecompany.pwCompany.name}
                            </div>
                        </div>
                        <div class="span6">
                            <span class="item-label">企业法人：</span>
                            <div class="items-box">
                                    ${pwEnter.ecompany.pwCompany.regPerson}
                            </div>
                        </div>
                    </div>
                    <div class="row-fluid row-info-fluid">
                        <div class="span6">
                            <span class="item-label">企业资金：</span>
                            <div class="items-box">
                                    ${pwEnter.ecompany.pwCompany.regMoney}万元
                            </div>
                        </div>
                        <div class="span6">
                            <span class="item-label">联系电话：</span>
                            <div class="items-box">
                                    ${pwEnter.ecompany.pwCompany.mobile}
                            </div>
                        </div>
                    </div>
                    <div class="row-fluid row-info-fluid">
                        <div class="span12">
                            <span class="item-label">公司执照：</span>
                            <div class="items-box">
                                    ${pwEnter.ecompany.pwCompany.no}
                            </div>
                        </div>
                    </div>
                    <div class="row-fluid row-info-fluid">
                        <div class="span12">
                            <span class="item-label">企业地址：</span>
                            <div class="items-box">
                                    ${pwEnter.ecompany.pwCompany.address}
                            </div>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" style="width: 120px;">资金来源：</label>
                        <div class="controls controls-checkbox"
                             style="margin-left: 140px;">
                            <form:checkboxes path="ecompany.pwCompany.regMtypes"
                                             items="${fns:getDictList('pw_reg_mtype')}" itemLabel="label"
                                             itemValue="value" htmlEscape="false" class="required" disabled="true"/>
                        </div>
                    </div>
                    <div class="row-fluid row-info-fluid">
                        <div class="span12">
                            <span class="item-label">企业入驻说明：</span>
                            <div class="items-box">${pwEnter.ecompany.remarks}</div>
                        </div>
                    </div>
                    <div class="edit-bar edit-bar-sm clearfix hide">
                        <div class="edit-bar-left">
                            <span>附件</span> <i class="line"></i>
                        </div>
                    </div>
                    <div class="accessories-container">
                        <div class="accessories">
                            <div class="accessory" id="companyFiles">
                                    <%--<div class="accessory-info">--%>
                                    <%--<a><img src="/img/filetype/rar.png">--%>
                                    <%--<span class="accessory-name">fhjd.rar</span>--%>
                                    <%--</a><i class="btn-delete-accessory"><img src="/img/remove-accessory.png"></i>--%>
                                    <%--</div>--%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${(not empty pwEnter.eroom) && (not empty pwEnter.eroom.pwRoom)}">
            <input id="paramsRoomId" type="hidden" value="${pwEnter.eroom.pwRoom.id}">
            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>分配房间信息</span> <i class="line"></i> <a data-toggle="collapse" href="#roomAssetInfo"><i
                        class="icon-collaspe icon-double-angle-up"></i></a>
                </div>
            </div>
            <div id="roomAssetInfo" class="panel-body collapse in">
                <div class="row-fluid row-info-fluid">
                    <div class="span6">
                        <span class="item-label">房间名：</span>
                        <div class="items-box">
                                ${pwEnter.eroom.pwRoom.name}
                        </div>
                    </div>
                    <c:if test="${not empty pwEnter.eroom.pwRoom.alias}">
                        <div class="span6">
                            <span class="item-label">别名：</span>
                            <div class="items-box">
                                    ${pwEnter.eroom.pwRoom.alias}
                            </div>
                        </div>
                    </c:if>
                </div>
                <div class="row-fluid row-info-fluid">
                    <div class="span6">
                        <span class="item-label">房间类型：</span>
                        <div class="items-box">
                                ${fns:getDictLabel(pwEnter.eroom.pwRoom.type, 'pw_room_type', '')}
                        </div>
                    </div>
                    <div class="span6">
                        <span class="item-label">容纳人数：</span>
                        <div class="items-box">
                                ${pwEnter.eroom.pwRoom.num}
                        </div>
                    </div>
                </div>
                <div class="row-fluid row-info-fluid">
                    <div class="span6">
                        <span class="item-label">负责人：</span>
                        <div class="items-box">
                                ${pwEnter.eroom.pwRoom.person}
                        </div>
                    </div>
                    <div class="span6">
                        <span class="item-label">手机：</span>
                        <div class="items-box">
                                ${pwEnter.eroom.pwRoom.mobile}
                        </div>
                    </div>
                </div>
                <div class="row-fluid row-info-fluid">
                    <div class="span6">
                        <span class="item-label">楼/层：</span>
                        <div class="items-box">
                            <c:if test="${(not empty pwEnter.eroom.pwRoom.pwSpace.parent) && (pwEnter.eroom.pwRoom.pwSpace.parent.id ne root)}">
                                <c:if test="${(not empty pwEnter.eroom.pwRoom.pwSpace.parent.parent) && (pwEnter.eroom.pwRoom.pwSpace.parent.parent.id ne root)}">
                                    <c:if test="${(not empty pwEnter.eroom.pwRoom.pwSpace.parent.parent.parent) && (pwEnter.eroom.pwRoom.pwSpace.parent.parent.parent.id ne root)}">
                                        <c:if test="${(not empty pwEnter.eroom.pwRoom.pwSpace.parent.parent.parent.parent) && (pwEnter.eroom.pwRoom.pwSpace.parent.parent.parent.parent.id ne root)}">
                                            ${pwEnter.eroom.pwRoom.pwSpace.parent.parent.parent.parent.name}/
                                        </c:if>${pwEnter.eroom.pwRoom.pwSpace.parent.parent.parent.name}/
                                    </c:if>${pwEnter.eroom.pwRoom.pwSpace.parent.parent.name}/
                                </c:if>${pwEnter.eroom.pwRoom.pwSpace.parent.name}/
                            </c:if>${pwEnter.eroom.pwRoom.pwSpace.name}
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${!pwEnter.isView}">
            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>入驻审核</span> <i class="line"></i> <a
                        data-toggle="collapse" href="#rzDetail"><i
                        class="icon-collaspe icon-double-angle-up"></i></a>
                </div>
            </div>
            <div id="rzDetail" class="panel-body collapse in">
                <div class="control-group">
                    <label class="control-label"><i>*</i>入驻有效期：</label>
                    <div class="controls">
                            <%--<select name="term" class="required">--%>
                            <%--<option value="">-请选择-</option>--%>
                            <%--<option value="183">半年</option>--%>
                            <%--<option value="365">一年</option>--%>
                            <%--</select>--%>
                        <label class="radio inline" style="vertical-align: top">
                            <input type="radio" name="term" class="required radio-year" value="183">半年（<span></span>）
                        </label>
                        <label class="radio inline" style="vertical-align: top">
                            <input type="radio" name="term" class="required radio-year" value="365">一年（<span></span>）
                        </label>
                        <label class="radio inline" style="vertical-align: top">
                            <input for="otherTime" id="otherTimeRadio" type="radio" name="term" class="required"
                                   value="">其它时间
                        </label>
                        <input id="otherTime" name="otherTime" class="Wdate input-medium" type="text"
                               style="vertical-align: top">
                            <%--<div class="controls-expire">--%>
                            <%--<input name="term" class="Wdate input-medium required" type="text">--%>
                            <%--&lt;%&ndash;<span>至</span>&ndash;%&gt;--%>
                            <%--&lt;%&ndash;<input class="Wdate input-medium required" type="text" readonly>&ndash;%&gt;--%>
                            <%--</div>--%>
                    </div>
                        <%--<div class="control-expire-time">--%>
                        <%--<label class="control-label-time radio inline">--%>
                        <%--<input type="radio" name="term" class="required" value="">其它时间--%>
                        <%--</label>--%>
                        <%--<div class="controls-expire">--%>
                        <%--<input name="term" class="Wdate input-medium required" type="text">--%>
                        <%--&lt;%&ndash;<span>至</span>&ndash;%&gt;--%>
                        <%--&lt;%&ndash;<input class="Wdate input-medium required" type="text" readonly>&ndash;%&gt;--%>
                        <%--</div>--%>
                        <%--</div>--%>
                </div>
                <div class="control-group">
                    <label class="control-label"><i>*</i>审核：</label>
                    <div class="controls">
                        <select name="sec-opt" id="sec-idea" class="accpet">
                            <option value="1">同意</option>
                            <option value="0">拒绝</option>
                        </select>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label"><i style="display:none;">*</i>意见和建议：</label>
                    <div class="controls">
							<textarea id="auditRemarks" class="input-xxlarge"
                                      rows="3" placeholder="同意">${pwEnter.remarks}</textarea>
                    </div>
                </div>
            </div>
        </c:if>
        <div class="text-center">
                <%--有效期天数小于 ${maxDayExpire} 天，确认提交么？--%>
            <c:if test="${!pwEnter.isView}">
                <c:if test="${pwEnter.status eq '0'}">
                    <button class="btn btn-primary submit" id="btnSumbit" type="submit">确定</button>
                    <%--<button class="btn btn-primary submit" type="button" style="display:inline-block;"--%>
                    <%--onclick="ajaxAudit('${pwEnter.id}', '', '1')">同意</button>--%>
                    <%--<button class="btn btn-default button" type="button" style="display:none;"--%>
                    <%--onclick="ajaxAudit('${pwEnter.id}', '', '0')">拒绝</button>--%>
                </c:if>
            </c:if>
            <c:if test="${(empty pwEnter.eroom) || (empty pwEnter.eroom.pwRoom)}">
                <c:if test="${pwEnter.status eq '1'}">
                    <a class="btn btn-default" href="${ctx}/pw/pwRoom/treeFPCD">前往分配场地</a>
                </c:if>
            </c:if>
                <%--<a class="btn btn-default" href="${ctx}/pw/pwEnter/list" >返回</a>--%>
            <a class="btn btn-default" id="btnBack" href="javascript:history.go(-1)">返回</a>
        </div>
    </form:form>
</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>


<script>
	$(function(){
		$.ajax({
            type: "POST",
/*             url: "${ctx}/pw/pwEnter/ajaxAudit?id=1&eid=1&term=183&atype=" + $("#sec-idea").val() + "&remarks=" + $("#auditRemarks").val(), */
            url: "${ctx}/pw/pwEnter/ajaxAudit",
            data: {
            	"id":1,
            	"edid":1,
            	"atype":$("#sec-idea").val(),
            	"term":183,
            	"remarks":$("#auditRemarks").val()
           	},
            dataType: "json",
            success: function(data){
            	console.info(data.data);
            }
        });
	})

    $(function () {

        $('a[data-toggle="collapse"]').click(function () {
            $(this).find('i').toggleClass('icon-double-angle-up icon-double-angle-down')
        });


        var $accpet = $('.accpet');
        var $btnSumbit = $('#btnSumbit');
        var maxDayExpire = '${maxDayExpire}';
        var pwEnterId = '${pwEnter.id}';
        /*
         * 调用表单验证插件
         * */
        var formValidate = $('#inputForm').validate({
            //
            submitHandler: function (form) {
                var atype = $('#sec-idea').val();
                var auditRemarks = $("#auditRemarks").val();
                var xhr;
                var edid = '';
                term = atype === '0' ? '0' : term;
                /* if (term < maxDayExpire) {
                 dialogCyjd.createDialog(0, '有效天数小于' + maxDayExpire + '天，确认提交吗？', {
                 buttons: [{
                 text: '确认',
                 'class': 'btn-primary btn btn-sm',
                 click: function () {
                 var $btn = $(this).parents('.ui-dialog').find('.btn-primary');
                 $btn.prop('disabled', true);
                 $(this).dialog('close');
                 saveData(pwEnterId, atype, '', auditRemarks, term);
                 }
                 }, {
                 text: '取消',
                 'class': 'btn-default btn btn-sm',
                 click: function () {
                 $btnSumbit.prop('disabled', false).text('确定');
                 $(this).dialog('close');
                 }
                 }]
                 });
                 return false;
                 } */
                $btnSumbit.prop('disabled', true).text('保存中...');
                //saveData(pwEnterId, atype, '', auditRemarks, term);
                return false;
            },
            errorPlacement: function (error, element) {
                if (element.is(":checkbox") || element.is(":radio")) {
                    error.appendTo(element.parent().parent());
                } else {
                    error.insertAfter(element);
                }
            }
        });

        //初始化返回按钮的链接地址
        var referrer = document.referrer;
        if ((/pwEnter\/form/).test(referrer)) {
            $('#btnBack').attr('href', '${ctx}/pw/pwEnter/list')
        }

        function saveData(pwEnterId, atype, edid, auditRemarks, term) {
            var xhr = $.get('${ctx}/pw/pwEnter/ajaxAudit?id=' + pwEnterId
                    + '&atype=' + atype + '&edid=' + edid
                    + '&remarks=' + auditRemarks + '&term=' + term);
            xhr.success(function (data) {
            	window.parent.sideNavModule.changeStaticUnreadTag("/a/pw/pwEnter/getCountToAudit");
                if (data.status) {
                    if (data.datas.status == '2') {
                        location.href = '${ctx}/pw/pwEnter/list';
                    } else {
                        location.href = '${ctx}/pw/pwEnter/form?id=' + pwEnterId;
                    }
                } else {
                    location.href = '${ctx}/pw/pwEnter/list';
                }
                $btnSumbit.prop('disabled', false).text('确定');
            });
            xhr.error(function (error) {
                $btnSumbit.prop('disabled', false).text('确定');
                dialogCyjd.createDialog(0, '网络连接失败，错误代码：' + error.status + '，请重新保存');
            });
        }

        var $selectTerm = $('input[name="term"]');
        var $inputTerm = $('#otherTime');
        var $auditRemarks = $('#auditRemarks');
        var term;
        var enterDate = '<fmt:formatDate value="${sysDate}" pattern="yyyy-MM-dd"/>';
        //格式化距离服务器时间段
        $('.radio-year').each(function (i, radio) {
            var $radio = $(radio);
            var val = $radio.val();
            var date = new Date(enterDate);
            if (val == 183) {
                date.setMonth(date.getMonth() + 6)
            }
            if (val == 365) {
                date.setMonth(date.getMonth() + 12)
            }
            $radio.next().text(moment(date).format('YYYY-MM-DD'))
        });

        //控制选择哪个时间
        $selectTerm.on('change', function () {
            var val = $(this).val();
            if (val) {
                $inputTerm.removeClass('required').prop('disabled', true);
                formValidate.element('input[name="term"]');
                term = val;
            } else {
                $inputTerm.addClass('required').prop('disabled', false);
                if (formValidate.element('input[name="term"]')) {
                    term = Math.ceil((new Date($inputTerm.val()).getTime() - new Date(enterDate).getTime()) / 24 / 60 / 60 / 1000);
                }
            }
        });
        //弹出时间控件， 并计算通过选择的日期计算相隔天数
        $inputTerm.on('click', function () {
            var date = new Date(enterDate);
            date.setDate(date.getDate() + 1);
            WdatePicker({
                dateFmt: 'yyyy-MM-dd',
                minDate: moment(date).format('YYYY-MM-DD'),
                isShowClear: true,
                onpicked: function () {
//                    $selectTerm.removeClass('required').prop('disabled', true);
                    formValidate.element('input[name="term"]');
                    term = Math.ceil((new Date($inputTerm.val()).getTime() - new Date(enterDate).getTime()) / 24 / 60 / 60 / 1000)
                },
                oncleared: function () {
                    $selectTerm.addClass('required').prop('disabled', false);
                    term = ''
                }
            })
        });

        //切换表单是否必填
        $accpet.on('change', function () {
            var val = $(this).val();
            if (val == '1') {
                $auditRemarks.parents('.control-group').find('textarea').removeClass('required').end().find('.control-label i').hide();
                $selectTerm.parents('.control-group').find('input,select').addClass('required').end().find('.control-label i').show();
                formValidate.resetForm()
            } else {
                $selectTerm.parents('.control-group').find('input,select').removeClass('required').end().find('.control-label i').hide();
                $auditRemarks.parents('.control-group').find('textarea').addClass('required').end().find('.control-label i').show();
                formValidate.element('input[name="term"]');
                formValidate.element('input[name="term"]');
            }
        });


        var tableList = function () {
            var teamId = $("#paramsTeamId").val(),
                    paramsProjectTeamId = $("#paramsProjectTeamId").val(),
                    paramsProjectProId = $("#paramsProjectProId").val();

            if ((teamId != undefined)) {
                $.ajax({
                    type: 'GET',
                    url: '${ctx}/team/ajaxTeamStudent?teamid=' + teamId,
                    dataType: "json",
                    success: function (data) {
                        if (data && data.datas) {
                            var resp = data.datas, tableStudList = [];
                            resp.map(function (it, idx) {
                                tableStudList.push('<tr>' + '<td>' + (++idx)
                                        + '</td>' + '<td>' + it.name + '</td>'
                                        + '<td>' + it.no + '</td>' + '<td>'
                                        + it.orgName + '</td>' + '<td>'
                                        + it.professional + '</td>' + '<td>'
                                        + it.mobile + '</td>' + '</tr>');
                            });
                            $("#teamTableStudent").append(
                                    tableStudList.join(","));
                        } else {
                            $("#teamTableStudent").append(
                                    '<tr>' + '<td colspan="6">没有数据</td>'
                                    + '</tr>');
                        }
                        ;
                        //返回如果是undefined就不显示
                        $("table td").map(function (idx, it) {
                            if (it.innerHTML === "undefined") {
                                it.innerHTML = "";
                            }
                            ;
                        });
                    }
                });
            }

            if ((teamId != undefined)) {
                $.ajax({
                    type: 'GET',
                    url: '${ctx}/team/ajaxTeamTeacher?teamid=' + teamId,
                    dataType: "json",
                    success: function (data) {
                        if (data && data.datas) {
                            var resp = data.datas, tableTeaList = [];
                            resp.map(function (it, idx) {
                                tableTeaList.push('<tr>' + '<td>' + (++idx)
                                        + '</td>' + '<td>' + it.name + '</td>'
                                        + '<td>' + it.no + '</td>' + '<td>'
                                        + it.teacherType + '</td>' + '<td>'
                                        + it.mobile + '</td>' + '<td>'
                                        + it.email + '</td>' + '<td>'
                                        + it.orgName + '</td>' + '</tr>');
                            });
                            $("#teamTableTeacher").append(
                                    tableTeaList.join(","));
                        } else {
                            $("#teamTableTeacher").append(
                                    '<tr>' + '<td colspan="8">没有数据</td>'
                                    + '</tr>');
                        }
                        ;
                        //返回如果是undefined就不显示
                        $("table td").map(function (idx, it) {
                            if (it.innerHTML === "undefined") {
                                it.innerHTML = "";
                            }
                            ;
                        });
                    }
                });
            }

            if ((paramsProjectTeamId != undefined) || (paramsProjectProId != undefined)) {
                $.ajax({
                    type: 'GET',
                    url: '${ctx}/team/ajaxTeamStudent?teamid=' + paramsProjectTeamId + "&proId=" + paramsProjectProId,
                    dataType: "json",
                    success: function (data) {
                        if (data && data.datas) {
                            var resp = data.datas, tableStudList = [];
                            resp.map(function (it, idx) {
                                tableStudList.push('<tr>' + '<td>' + (++idx)
                                        + '</td>' + '<td>' + it.name + '</td>'
                                        + '<td>' + it.no + '</td>' + '<td>'
                                        + it.orgName + '</td>' + '<td>'
                                        + it.professional + '</td>' + '<td>'
                                        + it.mobile + '</td>' + '</tr>');
                            });
                            $("#projectTableStudent").append(
                                    tableStudList.join(","));
                        } else {
                            $("#projectTableStudent").append(
                                    '<tr>' + '<td colspan="6">没有数据</td>'
                                    + '</tr>');
                        }
                        ;
                        //返回如果是undefined就不显示
                        $("table td").map(function (idx, it) {
                            if (it.innerHTML === "undefined") {
                                it.innerHTML = "";
                            }
                            ;
                        });
                    }
                });
            }

            if ((paramsProjectTeamId != undefined) || (paramsProjectProId != undefined)) {
                $.ajax({
                    type: 'GET',
                    url: '${ctx}/team/ajaxTeamTeacher?teamid='
                    + paramsProjectTeamId + "&proId="
                    + paramsProjectProId,
                    dataType: "json",
                    success: function (data) {
                        if (data && data.datas) {
                            var resp = data.datas, tableTeaList = [];
                            resp.map(function (it, idx) {
                                tableTeaList.push('<tr>' + '<td>' + (++idx)
                                        + '</td>' + '<td>' + it.name + '</td>'
                                        + '<td>' + it.no + '</td>' + '<td>'
                                        + it.teacherType + '</td>' + '<td>'
                                        + it.mobile + '</td>' + '<td>'
                                        + it.email + '</td>' + '<td>'
                                        + it.orgName + '</td>' + '</tr>');
                            });
                            $("#projectTableTeacher").append(
                                    tableTeaList.join(","));
                        } else {
                            $("#projectTableTeacher").append(
                                    '<tr>' + '<td colspan="8">没有数据</td>'
                                    + '</tr>');
                        }
                        ;
                        //返回如果是undefined就不显示
                        $("table td").map(function (idx, it) {
                            if (it.innerHTML === "undefined") {
                                it.innerHTML = "";
                            }
                            ;
                        });
                    }
                });

            }
            ;
        }
        tableList();

    })

    $(function () {
        var S_ENTER_COMPANY = [];
        var S_ENTER_PROJECT = [];
        var S_ENTER_TEAM = [];
        var $teamFiles = $('#teamFiles');
        var $projectFiles = $('#projectFiles')
        var $companyFiles = $('#companyFiles')
        getFiles()
        function getFiles() {
            var xhr = $
                    .get('${ctx}/attachment/sysAttachment/ajaxFiles/${pwEnter.id}?type=30000')
            xhr.success(function (data) {
                if (data.status && !!data.datas) {
                    var temp1 = '';
                    var temp2 = '';
                    var temp3 = '';
                    S_ENTER_COMPANY.length = 0;
                    S_ENTER_PROJECT.length = 0;
                    S_ENTER_TEAM.length = 0;
                    data.datas.forEach(function (t) {
                        if (t.fileStep === 'S_ENTER_COMPANY') {
                            S_ENTER_COMPANY.push(t)
                        }
                        if (t.fileStep === 'S_ENTER_PROJECT') {
                            S_ENTER_PROJECT.push(t)
                        }
                        if (t.fileStep === 'S_ENTER_TEAM') {
                            S_ENTER_TEAM.push(t)
                        }
                    });
                    S_ENTER_COMPANY.forEach(function (t) {
                        temp1 += template(t)
                    });
                    S_ENTER_PROJECT.forEach(function (t) {
                        temp2 += template(t)
                    });
                    S_ENTER_TEAM.forEach(function (t) {
                        temp3 += template(t)
                    })

                    if (temp3) {
                        $teamFiles.append(temp3)
                        $teamFiles.parents('.accessories').prev().removeClass('hide')
                    }
                    if (temp2) {
                        $projectFiles.append(temp2)
                        $projectFiles.parents('.accessories').prev().removeClass('hide')
                    }
                    if ($companyFiles) {
                        $companyFiles.append(temp1)
                        $companyFiles.parents('.accessories').prev().removeClass('hide')
                    }
                }
            })
        }

        function template(t) {
            var temp = '';
            temp += '<div class="accessory-info"> <a data-ftp-url="' + t.ftpUrl + '" href="' + t.url + '">'
                    + '<img src="'
                    + getImgType(t.suffix)
                    + '"> <span class="accessory-name">'
                    + t.name
                    + '</span>' + ' </a> </div>';
            return temp
        }

        function getImgType(type) {
            var extname;
            switch (type) {
                case "xls":
                case "xlsx":
                    extname = "excel";
                    break;
                case "doc":
                case "docx":
                    extname = "word";
                    break;
                case "ppt":
                case "pptx":
                    extname = "ppt";
                    break;
                case "jpg":
                case "jpeg":
                case "gif":
                case "png":
                case "bmp":
                    extname = "image";
                    break;
                case 'txt':
                    extname = 'txt';
                    break;
                case 'zip':
                    extname = 'zip';
                    break;
                case 'rar':
                    extname = 'rar';
                    break;
                default:
                    extname = "unknow";
            }
            return '/img/filetype/' + extname + '.png';
        }

        $(document).on(
                'click',
                '.accessory-info a',
                function (e) {
                    e.preventDefault();
                    var url = $(this).attr('href')
                    var name = $(this).find('.accessory-name').text();
                    var ftpUrl = $(this).attr('data-ftp-url');
                    location.href = $frontOrAdmin+"/ftp/ueditorUpload/downFile?url="
                            + url + "&fileName="
                            + encodeURI(encodeURI(name));
                })
    })


</script>
</body>
</html>