<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ page errorPage="/WEB-INF/views/error/formMiss.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>${fns:getConfig('frontTitle')}</title>
    <meta name="decorator" content="cyjd-site-default"/>
</head>
<body>
<div class="container container-ct">
    <ol class="breadcrumb" style="margin-top: 0">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li class="active">创业基地</li>
        <li class="active">入驻申请</li>
    </ol>
    <div class="row-step-cyjd" style="width: 540px;">
        <div class="step-indicator" style=" margin-right: -20px;">
            <a class="step completed">第一步（完善基本信息）</a>
            <a class="step">第二步（输入申报信息）</a>
        </div>
    </div>
    <c:if test="${(not empty pwEnters) && (fn:length(pwEnters) > 0)}">
        <div class="row-apply">
            <table class="table table-bordered table-condensed table-coffee table-nowrap table-center">
                <c:if test="${isMax}">
                    <caption>你的未完成入驻申请数已经达到系统上限(${maxNum})，无法创建新的申请，请选择上次修改，或删除历史修改后再添加</caption>
                </c:if>
                <c:if test="${!isMax}">
                    <caption>你有未完成的申请，请继续上次修改</caption>
                </c:if>
                <thead>
                <tr>
                    <th>入驻编号</th>
                    <th>申请时间</th>
                    <!-- <th>备注</th> -->
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pwEnters}" var="pwer">
                    <tr>
                        <td>${pwer.no}</td>
                        <td>
                            <fmt:formatDate value="${pwer.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                        <%-- <td>${pwer.remarks}</td> --%>
                        <td>
                            <a class="btn btn-primary btn-sm" href="${ctxFront}/pw/pwEnter/formStep2?id=${pwer.id}">继续申报</a>
                            <a class="btn btn-default btn-sm"
                               href="${ctxFront}/pw/pwEnter/ajaxDelete?id=${pwer.id}">删除</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
    <c:if test="${!isMax}">
        <div class="row-apply">
                <%--<div class="topbar clearfix"><a href="javascript:void (0)" class="pull-right btn-print">打印申请表</a>--%>
                <%--<span>填报日期：</span></div>--%>
            <h4 class="titlebar">第一步：<span class="step-title">创业人基本信息</span></h4>
            <form:form id="enterApplyForm" modelAttribute="pwEnter" action="${ctxFront}/pw/pwEnter/save" method="post"
                       class="form-horizontal form-horizontal-apply">
                <form:hidden path="id"/>
                <form:hidden path="applicant.id"/>
                <c:if test="${empty pwEnter.id}">
                    <input id="term" type="hidden" name="pwEnter.term" value="0"/>
                </c:if>
                <c:if test="${not empty pwEnter.id}">
                    <form:hidden path="term"/>
                </c:if>
                <div class="row row-user-info">
                    <div class="col-xs-4">
                        <label class="label-static">负责人：</label>
                        <p class="form-control-static">${pwEnter.applicant.name}</p>
                    </div>
                    <div class="col-xs-4">
                        <label class="label-static">学院：</label>
                        <p class="form-control-static">${pwEnter.applicant.office.name}</p>
                    </div>
                    <div class="col-xs-4">
                        <label class="label-static">学号：</label>
                        <p class="form-control-static">${pwEnter.applicant.no}</p>
                    </div>
                </div>
                <div class="row row-user-info">
                    <div class="col-xs-4">
                        <label class="label-static">联系方式：</label>
                        <p class="form-control-static" id="mobile">
                                ${pwEnter.applicant.mobile}</p>
                            <%--<c:if test="${not empty pwEnter.applicant.mobile}">${pwEnter.applicant.mobile}</c:if>--%>
                            <%--<c:if test="${empty pwEnter.applicant.mobile}">-</c:if>/--%>
                            <%--<c:if test="${not empty pwEnter.applicant.phone}">${pwEnter.applicant.phone}</c:if>--%>
                            <%--<c:if test="${empty pwEnter.applicant.phone}">-</c:if></p>--%>
                    </div>
                    <div class="col-xs-8">
                        <label class="label-static">邮件：</label>
                        <p class="form-control-static" id="email">${pwEnter.applicant.email}</p>
                    </div>
                </div>
                <div class="row row-user-info">
                    <div class="col-xs-4">
                        <label class="label-static">证件类型：</label>
                        <p class="form-control-static" id="idType">${fns:getDictLabel(pwEnter.applicant.idType, 'id_type', '')}</p>
                    </div>
                    <div class="col-xs-8">
                        <label class="label-static">证件号码：</label>
                        <p class="form-control-static"id="idNumber">${pwEnter.applicant.idNumber}</p>
                    </div>
                </div>
                <%--<div class="form-group">
                    <label class="control-label col-xs-2" style="width: 190px;"><i>*</i>到期年月日：</label>
                    <div class="col-xs-10 form-radios">
                        <form:radiobuttons path="term" items="${fns:getDictList('pw_enter_term')}" itemLabel="label"
                                           cssClass="required"
                                           itemValue="value" htmlEscape="false"></form:radiobuttons>
                    </div>
                </div>--%>
            </form:form>
            <div class="form-actions-cyjd text-center">
                    <%--&lt;%&ndash;<c:if test="${not empty pwEnter.id}">&ndash;%&gt;--%>
                    <%--<a class="btn btn-primary <c:if test="${empty pwEnter.id}"> disabled </c:if>"--%>
                    <%--<c:if test="${not empty pwEnter.id}">--%>
                    <%--href="${ctxFront}/pw/pwEnter/formStep2?id=${pwEnter.id}"--%>
                    <%--</c:if>--%>
                    <%--<c:if test="${empty pwEnter.id}">--%>
                    <%--href="javascript:void(0);"--%>
                    <%--</c:if>--%>
                    <%-->下一步</a>--%>
                    <%--&lt;%&ndash;</c:if>&ndash;%&gt;--%>
                    <%--<c:if test="${!pwEnter.isAudited}">--%>
                    <%--<button type="button" class="btn btn-primary btn-save">保存</button>--%>
                    <%--</c:if>--%>
                <button type="button" class="btn btn-primary btn-save">下一步</button>
            </div>
        </div>
    </c:if>
</div>

<script>
    $(function () {

        $('#content').css('minHeight', function () {
            return $(window).height() - 100 - 308
        });

        var $enterApplyForm = $('#enterApplyForm');
        var $btnSave = $('.form-actions-cyjd .btn-save');
        var enterApplyFrom = $enterApplyForm.validate({
            submitHandler: function (form) {
                var val = $('#term').val();
                var xhr = $.post('${ctxFront}/pw/pwEnter/ajaxSave/${pwEnter.applicant.id}?term=' + val + '&id=${pwEnter.id}');
                xhr.success(function (data) {
                    if (data.status) {
                        location.href = "${ctxFront}/pw/pwEnter/formStep2?id=" + data.datas.id;
                        enterApplyFrom.resetForm()
                    }
                });
                return false;
            },
            errorPlacement: function (error, element) {
                if (element.is(":checkbox") || element.is(":radio")) {
                    error.appendTo(element.parent().parent());
                } else {
                    error.insertAfter(element);
                }
            }
        })

        $btnSave.on('click', function (e) {
            var isStep=checkOnInit();
            if(isStep){
                $enterApplyForm.submit();
            }
        })
    })
    function checkOnInit(){
    	var idType=$.trim($("#idType").html());
    	var idNumber=$.trim($("#idNumber").html());
    	var user_mobile=$.trim($("#mobile").html());
    	var user_email=$.trim($("#email").html());

    	if(!((idType != "") && (idNumber != "") && (user_mobile != "") && (user_email != ""))){
    	    
    	    dialogCyjd.createDialog(0, '个人信息未完善，立即完善个人信息？', {
    	        dialogClass: 'dialog-cyjd-container none-close',
    	        buttons: [{
    	            'text': '确定',
                    'class': 'btn btn-primary btn-small btn-sm',
                    'click': function () {
                        location.href = '/f/sys/frontStudentExpansion/findUserInfoById?custRedict=1&isEdit=1'
                    }
                }]
            })
    		return false;
    	}
        return true;
    }
</script>

</body>
</html>
