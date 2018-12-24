<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="decorator" content="cyjd-site-default"/>
    <title>${frontTitle}</title>
    <link rel="stylesheet" type="text/css" href="/css/team_setUp.css?v=1">
    <link rel="stylesheet" href="/css/frontCyjd/creatives.css">
    <style>
        .row-step-cyjd {
            margin-left: 0;
        }

        .many-words {
            margin-top: 15px;
        }

        .many-words .icon-fail-msg {
            float: left;
            margin-left: 5px;
        }

        .many-words > span {
            display: block;
            line-height: 20px;
            margin-left: 50px;
        }

        .red {
            color: red;
        }


    </style>
    <script type="text/javascript">
        function subForm(form) {
            var f = $('#inputForm');
            var nameSch = $("#nameSch").val();
            var creator = $("#creator").val();
            var stateSch = $("#stateSch").val();
            var n = $("#pageNo").val();
            var s = $("#pageSize").val();

            f.attr("action", f.attr("action") + "?nameSch=" + nameSch +
                    "&creator=" + creator + "&stateSch=" + stateSch + "&pageNo=" + n + "&pageSize=" + s);
            form.submit();
        }
        $(document).ready(function () {
            var $memberNum = $('#memberNum')
            var $btnCancel = $('#btnCancel');
            var $inputForm = $('#inputForm');
            var $btnSubmit = $('#btnSubmit');
            var $btnSubmitCreate = $('#btnSubmitCreate');
            var $hideForm = $('.hideForm');
            var inputFormValidate;

            $("#ps").val($("#pageSize").val());
            $('.hideForm').click(function () {
                $("#formDiv").collapse('hide');
                $inputForm[0].reset();
                inputFormValidate.resetForm();
                $inputForm.find('input,textarea').val('')
            });


            $btnSubmitCreate.click(function () {
                $("#formDiv").collapse('show');
                $btnSubmit.show();
            })


            inputFormValidate = $inputForm.validate({
                rules: {
                    validDateStart: {
                        required: true
                    },
                    validDateEnd: {
                        required: true
                    },
                    memberNum: {
                        number: true,
                        required: true,
                        maxlength: 2
                    },
                    schoolTeacherNum: {
                        number: true,
                        required: true,
                        maxlength: 2
                    },
                    name: { //验证团队名称
                        required: true,
                        remote: {
                            url: "${ctxFront}/sys/user/ifTeamNameExist",
                            type: "post",
                            datatype: "json",
                            contenttype: "application/x-www-form-urlencoded; charset=utf-8",
                            data: {
                                "teamId": function () {
                                    return $("#id").val();
                                }
                            }
                        }
                    }
                },
                messages: {
                    validDateStart: {
                        required: "必填信息"
                    },
                    validDateEnd: {
                        required: "必填信息"
                    },
                    memberNum: {
                        number: '请填写数字',
                        required: "必填信息",
                        maxlength: "人数最多2位数"
                    },
                    schoolTeacherNum: {
                        number: '请填写数字',
                        required: "必填信息",
                        maxlength: "人数最多2位数"
                    },
                    name: {
                        required: "必填信息",
                        remote: "团队名已经存在！"
                    }
                },
                errorPlacement: function (error, element) {
                    if (element.attr('id') === 'memberNum') {
                        element.parents('.form-group').find('.member-tip').hide();
                    }
                    error.insertAfter(element)
                },
                submitHandler: function (form) {
                    var ck = "0";
                    if ($("#state").val() != "4" && $("#id").val() && $("#teamCheckOnOff").html() == "1") {
                        $(".checkinfo").each(function (i, v) {
                            if ($(v).attr("old") != $(v).val()) {
                                ck = "1";
                            }
                        });
                    }
                    if (ck == "1") {
                        var $dialogMessage = $('#dialog-message');
                        $dialogMessage.html('<div class="many-words"><i class="icon-fail-msg"></i><span>修改团队名称、组员要求、团队介绍需要审核，确定保存？</span></div>');
                        $dialogMessage.dialog({
                            modal: true,
                            buttons: [{
                                'text': '确定',
                                'click': function () {
                                    subForm(form);
                                    $(this).dialog('close')
                                }
                            }, {
                                'text': '取消',
                                'click': function () {
                                    $(this).dialog('close')
                                }
                            }]
                        });
                    } else {
                        $("#btnSubmit").attr("disabled", "disabled");
                        subForm(form);
                    }

                },
                onkeyup: function (element) {
                    if (($(element).attr("id") == 'name') && $(element).valid()) {
                        $("#name-error").html("");
                    }
                    return true;
                }
            });


            $memberNum.on('change', function (e) {
                var $this = $(this);
                setTimeout(function () {
                    if ($this.hasClass('valid')) {
                        $('.member-tip').show()
                    }
                }, 10)
            });
            $btnCancel.on('click', function (e) {
                $inputForm.find('input,textarea').val('');
                inputFormValidate.resetForm();
            });

            verticalMiddle();


            function verticalMiddle() {
                var status = $('#msg').html();
                if (status) {
                    showCenter();
                }
            }

            var messageInfo = $("#message").html();
            var opType = $("#opType").html();
            var msgState;

            if (opType != 2) {
                $btnCancel.trigger('click');
            }

            if (messageInfo) {
                msgState = messageInfo.indexOf('成功') > -1 ? '1' : '0';
                dialogCyjd.createDialog(msgState, messageInfo)

                $("#message").html("");
            }

            var $teamInfoTable = $('#teamInfoTable');
            //编辑team信息
            $teamInfoTable.on('click', '.edit-team', function (e) {
                var id = $(this).attr('data-id');
                var teamXhr = $.post('${pageContext.request.contextPath}/f/team/findById', {id: id});
                //清空信息
                $btnCancel.trigger('click');
                var subbtn = $('#btnSubmit');
                subbtn.text('保存');
                subbtn.removeAttr("onclick");
                $("#formDiv").collapse('show');

                teamXhr.success(function (res) {
                    $.each(res, function (k, v) {
                        $('#' + k).val(v);
                        $('#' + k).attr("old", v);
                    })
                });
                teamXhr.error(function (error) {
                    console.log(error)
                })
                return false;
            });
            //删除团队信息
            $teamInfoTable.on('click', '.delete-team', function (e) {
                var ob = $(this);
                dialogCyjd.createDialog(0, "确认删除吗？", {
                    buttons: [{
                        text: '确定',
                        'class': 'btn btn-primary',
                        'click': function () {
                            var id = ob.attr('data-id');
                            var teamXhr = $.get('${ctxFront}/team/hiddenDelete?teamId=' + id);
                            teamXhr.success(function (res) {
                                if (res != '1') {
                                    top.$.jBox.tip(data, 'info');
                                } else {
                                    window.location.href = "${pageContext.request.contextPath}/f/team/indexMyTeamList";
                                }
                            });
                            teamXhr.error(function (error) {
                                dialogCyjd.createDialog(0, '操作异常')
                            })
                        }
                    }, {
                        text: '取消',
                        'class': 'btn btn-default',
                        click: function () {
                            $(this).dialog("close");
                        }
                    }],
                });
                return false;
            });


            $("#formDiv").on('show.bs.collapse', function () {
                $('.top-content').toggleClass('top-content-bordered');
                $hideForm.show();
                $btnSubmitCreate.hide();
                $btnSubmit.text('保存');
            })


            $("#formDiv").on('hidden.bs.collapse', function () {
                $('.top-content').toggleClass('top-content-bordered')
                $hideForm.hide();
                $btnSubmitCreate.show();
                $btnSubmit.text('创建团队');
            })

            $btnSubmit.on('click', function (event) {
                if ($("#formDiv").is(':hidden')) {
                    event.preventDefault();
                    $("#formDiv").collapse('show')
                }
            })

        });


        //加入团队
        function checkIfLogin(teamId) {
            $.ajax({
                type: "get",
                url: "${ctxFront}/team/applyJoin?teamId=" + teamId,
                //data: {'teamId':teamId},
                //dataType: "json",
                success: function (data) {
                    dialogCyjd.createDialog((data.indexOf("失败") != -1 ? 0 : 1), data)
                },
                error: function () {
                    dialogCyjd.createDialog(0, '操作异常')

                }
            });
            return false;
        }


        function page(n, s) {
            var nameSch = $("#nameSch").val();
            var creator = $("#creator").val();
            var stateSch = $("#stateSch").val();

            $("#pageNo").val(n);
            $("#pageSize").val(s);

            window.location.href = "${pageContext.request.contextPath}/f/team/indexMyTeamList?nameSch=" + nameSch +
                    "&creator=" + creator + "&stateSch=" + stateSch + "&pageNo=" + n + "&pageSize=" + s + "&msg=1";

        }


        function showForm() {
            var checkUserInfoData;
            $.ajax({
                type: 'post',
                async: false,
                url: '/f/team/checkTeamCreateCdn',
                success: function (data) {
                    checkUserInfoData = data;
                }
            });
            if (checkUserInfoData.ret == 1) {
                var subbtn = $('#btnSubmit');
                subbtn.text('保存');
                subbtn.removeAttr("onclick");
                $("#formDiv").collapse('show');
            } else {
                if (checkUserInfoData.ret == 2) {
                    dialogCyjd.createDialog(0, checkUserInfoData.msg, {
                        buttons: [{
                            text: '确定',
                            'class': 'btn btn-primary',
                            click: function () {
                                top.location = "/f/sys/frontStudentExpansion/findUserInfoById?custRedict=1&isEdit=1";
                            }
                        }, {
                            text: '取消',
                            'class': 'btn btn-default',
                            click: function () {
                                $(this).dialog("close");
                            }
                        }]
                    })
                } else {
                    dialogCyjd.createDialog(0, checkUserInfoData.msg)
                }
            }
            return false;
        }


        function toDisTeam(teamid) {

            dialogCyjd.createDialog(0, "确认要解散该团队吗？", {
                buttons: [{
                    text: '确定',
                    'class': 'btn btn-primary',
                    click: function () {
                        top.location = "/f/team/disTeam?id=" + teamid;
                    }
                }, {
                    text: '取消',
                    'class': 'btn btn-default',
                    click: function () {
                        $(this).dialog("close");
                    }
                }]
            })
        }
    </script>
    <style type="text/css">
        label.error {
            background-position: left 3px;
            color: #ea5200
        }

        .modal {
            right: 50px;
            top: 50px;
        }

        .modal-body {
            height: 500px;
            width: 100%;
        }

        .modal-open .modal {
            overflow-y: hidden;
        }

        .dropdown-menu {
            left: -103px;
        }

        .member-tip {
            font-size: 12px;
            color: red;
            padding: 0 15px;
        }

        .form-group-build-team .control-label {
            float: left;
            width: 115px;
            padding-left: 15px;
            padding-right: 15px;
        }

        .form-group-build-team .control-label i {
            line-height: 20px;
            color: red;
            font-style: normal;
            margin-right: 4px;
        }

        .form-group-build-team .form-controls {
            float: left;
            padding: 0 15px;
            width: 1127px;
        }

        .col-xs-6 .form-group-build-team .form-controls {
            width: 505px;
        }

        .btn-primary {
            color: #fff;
            background-color: #e9432d;
            border-color: #e53018;
        }

        .btn-primary:focus, .btn-primary.focus {
            color: #fff;
            background-color: #cd2b16;
            border-color: #71180c;
        }

        .btn-primary:hover {
            color: #fff;
            background-color: #cd2b16;
            border-color: #ad2412;
        }

        .btn-primary.active.focus, .btn-primary.active:focus, .btn-primary.active:hover,
        .btn-primary:active.focus, .btn-primary:active:focus, .btn-primary:active:hover,
        .open > .dropdown-toggle.btn-primary.focus, .open > .dropdown-toggle.btn-primary:focus,
        .open > .dropdown-toggle.btn-primary:hover {
            color: #fff;
            background-color: #cd2b16;
            border-color: #ad2412;
        }

        .form-search-block {
            margin-bottom: 20px;
        }

        .form-search-block .form-group {
            margin-right: 15px;
        }

        textarea {
            resize: none;
        }

        .table > thead > tr > th {
            white-space: nowrap;
        }

        .team-member {
            max-width: 200px;
            margin: 0 auto;
            overflow: hidden;
        }









        .container-ct{
            /*padding-bottom:0;*/
        }

        table th{
            background-color: white !important;
        }
    </style>
</head>
<body>

<div style="display: none" id="opType">${opType}</div>
<div style="display: none" id="message">${message}</div>
<div style="display: none" id="teamCheckOnOff">${teamCheckOnOff}</div>
<div id="msg" style="display: none;">${msg }</div>
<!--页面点击保存是跳转到列表显示 -->
<div id="curUserId" style="display: none">${curUserId}</div>
<div id="curteamId" style="display: none"></div>

<div class="container container-ct teamBuild">

    <div class="main-wrap">
        <div class="mybreadcrumbs">
            <i class="icon-home" aria-hidden="true"></i>&nbsp;&nbsp;首页&gt;&nbsp;人才库&nbsp;&gt;&nbsp;团队建设
        </div>
        <c:if test="${userType ==1  }">
            <%--<div class="row-step-cyjd" style="height: 30px; margin-bottom: 15px;">--%>
                <%--<div class="step-indicator" style="margin-right: -20px;">--%>
                    <%--<a class="step completed">第一步：创建团队</a> <a class="step completed">第二步：待审核通过</a>--%>
                    <%--<a class="step completed">第三步：发布/邀请组成员</a>--%>
                <%--</div>--%>
            <%--</div>--%>
            <div class="teamBuild-process">
                <div>团建步骤：</div>
                <ul>
                    <li>第一步：创建团队</li>
                    <li>第二步：待审核通过</li>
                    <li>第三步：发布/邀请组员</li>
                </ul>
            </div>
        </c:if>
        <form:form id="inputForm" modelAttribute="team"
                   action="${ctxFront}/team/indexSave" method="post"
                   autocomplete="off"
                   class="form-horizontal">
            <form:hidden path="id" id="id"/>
            <form:hidden path="state" id="state"/>
            <form:hidden path="number" id="number"/>
            <input type="hidden" name="proType" id="proType" value="${proType}"/>
            <div class="top-content">
                <div id="formDiv"
                     class="collapse <c:if test="${opType=='2'}">in</c:if>">
                    <div class="row rowDiv">
                        <div class="col-xs-3">
                            <div class="form-group form-group-build-team">
                                <label class="control-label"><i>*</i>团队名称：</label>
                                <div class="form-controls" style="width: 194px;">
                                    <form:input old="${team.name}" path="name" maxlength="64"
                                                cssClass="form-control checkinfo"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-3">
                            <div class="form-group form-group-build-team">
                                <label class="control-label" style="width: 140px;"><i>*</i>所需组员人数：</label>
                                <div class="form-controls"
                                     style="width: 172px; float: none; margin-left: 140px;">
                                    <form:input path="memberNum" htmlEscape="false"
                                                cssStyle="width: 96px" class="number-count form-control"
                                                maxlength="2"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-3">
                            <div class="form-group form-group-build-team">
                                <label class="control-label" style="width: 156px;"><i>*</i>所需校内导师数：</label>
                                <div class="form-controls" style="width: 154px;">
                                    <form:input path="schoolTeacherNum" htmlEscape="false"
                                                cssStyle="width: 96px" class="number-count form-control"
                                                maxlength="2"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-3">
                            <div class="form-group form-group-build-team">
                                <label class="control-label" style="width: 156px;">所需企业导师数：</label>
                                <div class="form-controls" style="width: 154px;">
                                    <form:input path="enterpriseTeacherNum" htmlEscape="false"
                                                cssStyle="width: 96px" class="number-count form-control"
                                                maxlength="2"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" style="margin-top:0px;">
                        <div class="col-xs-6" style="">
                            <div class="form-group form-group-build-team">
                                <label class="control-label"><i>*</i>组员要求：</label>
                                <div class="form-controls">
                                    <form:textarea old="${team.membership}" path="membership"
                                                   htmlEscape="false" rows="4" maxlength="200" id="membership"
                                                   class="members-ablity form-control checkinfo"
                                                   required="required" placeholder="200字以内"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-6" style="">
                            <div class="form-group form-group-build-team">
                                <label class="control-label"><i>*</i>团队介绍：</label>
                                <div class="form-controls">
                                    <form:textarea old="${team.summary}" path="summary"
                                                   htmlEscape="false" rows="4" maxlength="500"
                                                   class="team-introduce form-control checkinfo"
                                                   required="required" id="summary" placeholder="500字以内"/>
                                </div>

                            </div>
                        </div>
                    </div>
                    <div class="form-group form-group-build-team" style="display: none">
                        <label class="control-label"><i>*</i>项目简介：</label>
                        <div class="form-controls">
                            <form:textarea old="${team.projectIntroduction}"
                                           path="projectIntroduction" htmlEscape="false" rows="4"
                                           maxlength="200" class="prj-summary form-control checkinfo"
                                           required="required" id="projectIntroduction"
                                           placeholder="200汉字以内"/>
                        </div>
                    </div>
                </div>
                <c:if test="${userType ==1  }">
                    <div class="form-group" style="margin-bottom: -20px;margin-top:-10px;position:relative;top:5px;">
                        <div class="col-xs-12  text-right">
                            <button style="margin-bottom: 10px;" id="btnSubmit" class="btn btn-primary-oe" type="submit"
                                    <c:if test="${opType!='2'}"> onclick="return showForm();" </c:if>>
                                <c:choose>
                                    <c:when test="${opType=='2'}">保存</c:when>
                                    <c:otherwise>创建团队</c:otherwise>
                                </c:choose>
                            </button>

                                <%--<button style="margin-bottom: 10px;" id="btnSubmitCreate" class="btn btn-primary-oe"--%>
                                <%--type="button">--%>
                                <%--创建团队--%>
                                <%--</button>--%>

                                <%--<button style="margin-bottom: 10px;display:none" id="btnSubmit" class="btn btn-primary-oe"--%>
                                <%--type="button" onclick="return showForm();">保存--%>
                                <%--</button>--%>

                            <button class="btn btn-default hideForm" type="button"
                                    style="display: none;margin-bottom: 10px;">取消
                            </button>


                            <button id="btnCancel" class="btn btn-default" type="button"
                                    style="display: none">清空
                            </button>
                        </div>
                    </div>
                </c:if>
            </div>
        </form:form>

        <div class="" style="margin-top:-22px;height:30px;margin-bottom:20px;">
            <div class="team-lsit-desc">
                <span style="margin-top:-10px;">团队列表</span>
                <p class="yw-line" style="margin-top:-10px;"></p>
            </div>
        </div>

        <div class="form-search-block clearfix">
            <input id="pageNo" name="pageNo" type="hidden"
                   value="${page.pageNo}"/> <input id="pageSize" name="pageSize"
                                                   type="hidden" value="${page.pageSize}"/>
            <div class="pull-right">
                <button style="margin-right:13px;" type="button" class="btn btn-default remove-team disabled"
                        >删除团队
                </button>
            </div>
            <div class="pull-right">
                <button style="margin-right:13px;" type="button" class="btn btn-primary"
                        onclick="page(${page.pageNo},${page.pageSize});">查询
                </button>
            </div>
            <div class="form-inline">
                <div class="form-group">
                    <label class="control-label">团队名称：</label> <input
                        class="form-control" type="text" id="nameSch"
                        value="${qryForm.nameSch}"/>
                </div>
                <div class="form-group">
                    <label class="control-label">团队负责人：</label> <input type="text"
                                                                       id="creator" class="form-control"
                                                                       value="${qryForm.creator}"/>
                </div>
                <div class="form-group">
                    <label class="control-label">团队状态：</label> <select id="stateSch"
                                                                       class="form-control">
                    <option value="">-请选择-</option>
                    <option value="0"
                            <c:if test="${qryForm.stateSch=='0'}">selected</c:if>>
                        建设中
                    </option>
                    <option value="1"
                            <c:if test="${qryForm.stateSch=='1'}">selected</c:if>>
                        建设完毕
                    </option>
                    <option value="2"
                            <c:if test="${qryForm.stateSch=='2'}">selected</c:if>>
                        解散
                    </option>
                    <option value="3"
                            <c:if test="${qryForm.stateSch=='3'}">selected</c:if>>
                        待审核
                    </option>
                    <option value="4"
                            <c:if test="${qryForm.stateSch=='4'}">selected</c:if>>
                        未通过
                    </option>
                </select>
                </div>
            </div>
        </div>

        <table id="teamInfoTable" class="team-table table table-condensed table-center table-nowrap table-hover">
            <thead>
                <tr>
                    <th><input type="checkbox"></th>
                    <th style="width: 20%;">团队信息</th>
                    <th style="width: 10%">团队负责人</th>
                    <th style="width: 25%">团队成员<br>（已组建/共需）</th>
                    <th style="width: 15%">团队导师<br>（已组建/共需）</th>
                    <th style="width: 10%">团队状态</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>

            <c:forEach items="${page.list}" var="team" varStatus="status">
                <tr>
                    <td><input type="checkbox"></td>
                    <td>
                        <c:if
                            test="${curUserId != team.sponsorId&&team.state==3}">信息审核中</c:if>
                        <c:if test="${curUserId != team.sponsorId&&team.state==4}">信息审核未通过</c:if>
                        <c:if test="${curUserId == team.sponsorId||(team.state!=3&&team.state!=4)}">
                            <p class="team-name">
                                <a href="${ctxFront}/team/findByTeamId?id=${team.id}">
                                    ${team.name}
                                </a>
                            </p>
                            <p>所属学院：${team.localCollege}</p>
                            <p>创建日期：2017-11-13</p>
                        </c:if>
                        <%--<p class="team-name">Yehops之光团队</p>--%>
                        <%--<p>所属学院：计算机学院</p>--%>
                        <%--<p>创建日期：2017-11-13</p>--%>
                    </td>
                    <td>${team.sponsor}</td>
                    <td>
                        <span class="<c:if test="${team.userCount!=team.memberNum}" >red</c:if>">${team.userCount}</span>/<span>${team.memberNum}</span>
                                                <p>${team.userName}</p>
                        <%--<span class="red">3</span>/<span>4</span>--%>
                        <%--<p>张弛/袁丰卉/黄诗凡/张弛</p>--%>
                    </td>
                    <td>
                        <span class="<c:if test="${team.schoolNum!=team.schoolTeacherNum}" >red</c:if>">
                                                    ${team.schoolNum} </span>/${team.schoolTeacherNum}
                                                <p>校内导师：${team.schName }</p>
                        <span class="<c:if test="${team.enterpriseNum!=team.enterpriseTeacherNum}">red</c:if>">
                                                    ${team.enterpriseNum} </span>/ <c:choose>
                                                <c:when
                                                        test="${team.enterpriseTeacherNum!=null || team.enterpriseTeacherNum !=''}">
                                                    ${team.enterpriseTeacherNum}
                                                </c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>
                                                <p>企业导师：${team.entName }</p>
                        <%--<span class="red">1</span>/<span>1</span>--%>
                        <%--<p>校内导师：李涛</p>--%>
                        <%--<span class="red">1</span>/<span>1</span>--%>
                        <%--<p>企业导师：王海平</p>--%>
                    </td>
                    <td><c:if test="${team.state==1}">建设完毕</c:if> <c:if
                                                test="${team.state==0}">建设中</c:if> <c:if
                                                test="${team.state==2}">解散</c:if> <c:if test="${team.state==3}">待审核</c:if>
                                            <c:if test="${team.state==4}">未通过</c:if></td>
                    <td class="operate-team">
                        <a href="#" class="btn btn-small btn-primary">邀请组员</a>
                        <a href="#" class="btn btn-small btn-primary">发布团队</a>
                        <a href="#" class="btn btn-small btn-primary">编辑团队</a>
                        <a href="#" class="btn btn-small btn-primary disabled">解散团队</a>
                    </td>
                </tr>
            </c:forEach>
                <%--<tr>--%>
                    <%--<td><input type="checkbox"></td>--%>
                    <%--<td>--%>
                        <%--<p class="team-name">Yehops之光团队</p>--%>
                        <%--<p>所属学院：计算机学院</p>--%>
                        <%--<p>创建日期：2017-11-13</p>--%>
                    <%--</td>--%>
                    <%--<td>李思缔</td>--%>
                    <%--<td>--%>
                        <%--<span class="red">3</span>/<span>4</span>--%>
                        <%--<p>张弛/袁丰卉/黄诗凡/张弛</p>--%>
                    <%--</td>--%>
                    <%--<td>--%>
                        <%--<span>0</span>/<span>1</span>--%>
                        <%--<p>校内导师：李涛</p>--%>
                    <%--</td>--%>
                    <%--<td>组员建设中</td>--%>
                    <%--<td class="operate-team">--%>
                        <%--<a href="#" class="btn btn-small btn-primary">邀请组员</a>--%>
                        <%--<a href="#" class="btn btn-small btn-primary">发布团队</a>--%>
                        <%--<a href="#" class="btn btn-small btn-primary">编辑团队</a>--%>
                        <%--<a href="#" class="btn btn-small btn-primary disabled">解散团队</a>--%>
                    <%--</td>--%>
                <%--</tr>--%>
                <%--<tr>--%>
                    <%--<td><input type="checkbox"></td>--%>
                    <%--<td>--%>
                        <%--<p class="team-name">Yehops之光团队</p>--%>
                        <%--<p>所属学院：计算机学院</p>--%>
                        <%--<p>创建日期：2017-11-13</p>--%>
                    <%--</td>--%>
                    <%--<td>李思缔</td>--%>
                    <%--<td>--%>
                        <%--<span>0</span>/<span>4</span>--%>
                        <%--<p>张弛/袁丰卉/黄诗凡/张弛</p>--%>
                    <%--</td>--%>
                    <%--<td>--%>
                        <%--<span>0</span>/<span>1</span>--%>
                        <%--<p>校内导师：李涛</p>--%>
                    <%--</td>--%>
                    <%--<td>团队待审核</td>--%>
                    <%--<td class="operate-team">--%>
                        <%--<a href="#" class="btn btn-small btn-primary disabled">邀请组员</a>--%>
                        <%--<a href="#" class="btn btn-small btn-primary disabled">发布团队</a>--%>
                        <%--<a href="#" class="btn btn-small btn-primary disabled">编辑团队</a>--%>
                        <%--<a href="#" class="btn btn-small btn-primary disabled">解散团队</a>--%>
                    <%--</td>--%>
                <%--</tr>--%>
            </tbody>
        </table>

        ${page.footer}
    </div>
</div>
<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>
<!-- 模态框（Modal） -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
     aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" style="width: 990px">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">团队发布</h4>
            </div>
            <div class="modal-body">

                <iframe id="iframe"
                        src="${ctxFront}/sys/user/index?teamId=${team.id}&&opType=1"
                        frameborder="0" style="width: 100%; height: 100%;"></iframe>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
</div>

<!-- /.modal -->
<script>
    $(function () {
        //模态框初始化，初始化时不显示(modal)对话框 ；show->false,backdrop->static 不能点击背景关闭对话框
        $('#myModal').modal({
            backdrop: "static",
            show: false
        }).draggable({
            handle: ".modal-header",
            containment: 'body'
        });


        $('.my-btn-group ul li').on('click', 'a',
                function () {
                    var id = $(this).attr('data-id');
                    if (!id) {
                        return
                    }
                    $('#iframe').attr('src', "${ctxFront}/sys/user/indexPublish?teamId=" + id + "&&opType=1")
                })


        var tbodyInput = $('tbody tr input');
        var theadInput = $('thead tr input');
//        console.log(tbodyInput)
        tbodyInput.change(function(){
            var tbodyInputLen = $('tbody tr input[type="checkbox"]:checked').length;
            if(tbodyInputLen > 0){
                $('.remove-team').removeClass('disabled');
            }else{
                $('.remove-team').addClass('disabled');
            }
            if(tbodyInputLen == tbodyInput.length){
                theadInput.eq(0).prop('checked',true);
            }
        })
        theadInput.change(function(){
            if($(this).prop('checked')){
                $('.remove-team').removeClass('disabled');
                tbodyInput.prop('checked',true);
            }else{
                $('.remove-team').addClass('disabled');
                tbodyInput.prop('checked',false);
            }
        })
    })
</script>
</body>
</html>