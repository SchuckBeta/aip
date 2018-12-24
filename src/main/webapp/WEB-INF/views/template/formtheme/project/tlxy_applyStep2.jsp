<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>${frontTitle}</title>
    <meta name="decorator" content="cyjd-site-default"/>
    <script src="/other/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>
    <link href="${ctxStatic}/cropper/cropper.min.css" rel="stylesheet"/>
    <script src="${ctxStatic}/cropper/cropper.min.js" type="text/javascript"></script>
    <script src="/js/tlxy_new.js?v=1" type="text/javascript" charset="utf-8"></script>
    <script src="/other/datepicker/My97DatePicker/WdatePicker.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>

<style>
    .date-input{
        font-size:12px;
        width: 106px;
        height: 30px;
        padding: 6px 11px;
        line-height: 1.42857143;
        color: #555;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-shadow: inset 0 1px 1px rgba(0,0,0,0.075);
        transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
    }
    .date-input:hover{
        cursor: pointer;
    }

    .minus{
        display: inline-block;
        width: 19px;
        height: 19px;
        background: url(/img/minuse.png) no-repeat;
    }
    .minus:hover {
        background: url(/img/minus2.png) no-repeat;
        cursor: pointer;
    }
    .plus{
        display: inline-block;
        width: 19px;
        height: 19px;
        background: url(/img/plus.png) no-repeat;
    }
    .plus:hover {
        background: url(/img/plus2.png) no-repeat;
        cursor: pointer;
    }

    .form-span-checkbox .input-box span{
        position: relative;
        display: inline-block;
        padding-right: 20px;
        margin-bottom: 0;
        font-weight: 400;
        vertical-align: middle;
        cursor: pointer;
    }

    .form-span-checkbox .input-box span label{
        font-weight: normal;
        margin-left: 4px;
        margin-bottom: 0;
    }


    body,input,textarea,.btn,.form-control{
        font-size:12px;
    }


    .row-apply .titlebar,.edit-bar-sm .edit-bar-left > span{
        font-size:13px;
    }




</style>





<div class="container container-ct">
    <ol class="breadcrumb" style="margin-top: 0">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li><a href="${ctxFront}/page-innovation">双创项目</a></li>
        <li class="active">申报</li>
    </ol>
    <div class="main-wrap">
        <div class="row-step-cyjd" style="height: 30px; margin-bottom: 15px;">
            <div class="step-indicator" style="margin-right: -20px;">
                <a class="step">第一步（填写项目基本信息）</a>
                <a class="step completed">第二步（填写团队基本信息）</a>
                <a class="step">第三步（提交项目申报附件）</a>
            </div>
        </div>
        <div class="row-apply">
            <h4 class="titlebar">${proModelType}申报</h4>
            <form:form id="form1" modelAttribute="proModelTlxy" action="#" method="post" class="form-horizontal"
                       cssstyle="margin-left:20px;"
                       enctype="multipart/form-data">
                <input type="hidden" name="proModel.declareId" id="declareId" value="${cuser.id}"/>
                <input type="hidden" name="id" id="id" value="${proModelTlxy.id}"/>
                <input type="hidden" name="actYwId" id="actYwId" value="${actYwId}"/>
                <input type="hidden" name="year" id="year" value="${year}"/>
                <input type="hidden" name="proModel.year" id="proModel.year" value="${proModelTlxy.proModel.year}"/>
                <input type="hidden" name="proModel.id" id="proModel.id" value="${proModelTlxy.proModel.id}"/>
                <div class="row row-user-info" style="margin-top:28px;">
                    <div class="col-xs-8">
                        <label class="control-label application-one"><i>*</i>填报日期：</label>
                        <input id="declareDate" class="Wdate form-control date-input required declareDate" readonly="readonly" type="text"
                               name="proModel.subTime" style="display: inline-block;background-color: white;"
                               value='<fmt:formatDate value="${proModelTlxy.proModel.subTime}" pattern="yyyy-MM-dd"/>'
                               onfocus="WdatePicker(getStartDatepicker())"/>
                    </div>
                    <%--<div class="col-xs-4">--%>
                        <%--<label class="application-one">项目编号：</label>--%>
                        <%--<p class="application-p">${proModelTlxy.proModel.competitionNumber}</p>--%>
                    <%--</div>--%>
                </div>


                <div class="edit-bar edit-bar-sm clearfix">
                    <div class="edit-bar-left">
                        <span>团队信息</span>
                        <i class="line"></i>
                    </div>
                </div>
                <div class="form-group" style="position:relative;left:45px;margin-top:30px;">
                    <label class="control-label col-xs-1" style="width: 150px;"><i>*</i>选择团队：</label>
                    <div class="col-xs-3">
                        <form:select required="required" onchange="findTeamPerson();" path="proModel.teamId" class="input-medium form-control fill" oldv="${proModelTlxy.proModel.teamId }">
                            <form:option value="" label="--请选择--"/>
                            <form:options items="${teams}" itemValue="id" itemLabel="name"
                                          htmlEscape="false"/></form:select>
                    </div>
                    <c:if test="${fn:length(teams)==0}">
                        <label class="control-label col-xs-2 build-team">没有可用团队请<a
                                href="/f/team/indexMyTeamList">创建团队</a></label>
                    </c:if>
                </div>
                <div class="tab-pane">
                    <div class="form-group" style="position:relative;left:45px;margin-top:36px;">
                        <label class="control-label col-xs-1" style="width: 150px;">学生团队：</label>
                        <div class="col-xs-9">
                            <table class="studenttb table table-bordered table-condensed table-orange table-center table-nowrap table-hover">
                                <thead>
                                <tr>
                                    <th>序号</th>
                                    <th>姓名</th>
                                    <th>学号</th>
                                    <th>学院</th>
                                    <th>专业</th>
                                    <th>手机号</th>
                                    <th>现状</th>
                                    <th>当前在研</th>
                                    <th>技术领域</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:if test="${teamStu == null || teamStu.size() <= 0}">
                                    <tr>
                                        <td colspan="9">暂无数据</td>
                                    </tr>
                                </c:if>
                                <c:if test="${teamStu!=null&&teamStu.size() > 0}">
                                    <c:forEach items="${teamStu}" var="item" varStatus="status">
                                        <tr>
                                            <td>${status.index+1 }<input type="hidden"
                                                                         name="proModel.studentList[${status.index}].userId"
                                                                         value="${item.userId}"></td>
                                            <td>${item.name }</td>
                                            <td>${item.no }</td>
                                            <td>${item.org_name }</td>
                                            <td>${item.professional}</td>
                                            <td>
                                                    ${item.mobile }
                                            </td>
                                            <td>${fns:getDictLabel(item.currState, 'current_sate', '')}</td>
                                            <td>${item.curJoin }</td>
                                            <td>${item.domain }</td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="form-group" style="position:relative;left:45px;">
                        <label class="control-label col-xs-1" style="width: 150px;">指导教师：</label>
                        <div class="col-xs-9">
                            <table class="teachertb table table-bordered table-condensed table-orange table-center table-nowrap table-hover">
                                <thead>
                                <tr>
                                <tr>
                                    <th>序号</th>
                                    <th>姓名</th>
                                    <th>工号</th>
                                    <th>单位(学院或企业、机构)</th>
                                    <th>导师来源</th>
                                    <th>当前指导</th>
                                    <th>技术领域</th>
                                </tr>
                                </tr>
                                </thead>
                                <tbody>
                                <c:if test="${teamTea == null || teamTea.size() <= 0}">
                                    <tr>
                                        <td colspan="7">暂无数据</td>
                                    </tr>
                                </c:if>
                                <c:if test="${teamTea!=null&&teamTea.size() > 0}">
                                    <c:forEach items="${teamTea}" var="item" varStatus="status">
                                        <tr>
                                            <td>${status.index+1}
                                                <input type="hidden" name="proModel.teacherList[${status.index}].userId"
                                                                        value="${item.userId}">
                                            </td>
                                            <td>${item.name }</td>
                                            <td>${item.no }</td>
                                            <td>${item.org_name }</td>
                                            <td>${item.teacherType}</td>
                                            <td>${item.curJoin }</td>
                                            <td>${item.domain }</td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <input id="logoSysAttId" type="hidden" value="${proModel.logo.id}">
            </form:form>
            <div class="form-actions-cyjd text-center">
                <a id="prevbtn" class="btn btn-primary" href="javascript:void(0)" onclick="prevStep()"
                   style="margin-right: 10px;">上一步</a>
                <a id="savebtn" class="btn btn-primary" href="javascript:void(0)" onclick="saveStep2UnCheck()"
                   style="margin-right: 10px;">保存</a>
                <button id="nextbtn" type="button" class="btn btn-primary btn-save" onclick="saveStep2(this)">下一步
                </button>
            </div>

        </div>
    </div>
</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>

<div id="modalAvatar" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <p style="margin-bottom: 0">更改图片</p>
            </div>
            <div class="modal-body">
                <input class="upImgFile" type="file" style="display: none" accept="image/jpeg,image/png">
                <button type="button" class="btn btn-primary upImg">上传图片</button>
                <div class="cropper-area cropper-area-logo">
                    <img class="cropperImg" src="">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal" aria-hidden="true">取消</button>
                <button type="button" class="btn btn-primary upLoadImg">上传</button>
            </div>
        </div>
    </div>
</div>


<script src="/js/tlxyValidate.js" type="text/javascript" charset="utf-8"></script>


<script type="text/javascript">
//    var tlxyValidate = $("#form1").validate({
//        errorPlacement: function (error, element) {
//            if (element.is(":checkbox")|| element.is(":radio")) {
//                error.appendTo(element.parent().parent());
//            }else if(element.is(".budget-dollar")){
//                error.appendTo(element.parent());
//            } else {
//                error.insertAfter(element);
//            }
//        }
//    });
    $(function () {
        $('.img-see').click(function () {
            $('.img-up').css('display', 'block');
        });

        $('.img-dele').click(function () {
            $(this).parent().parent().parent().css('display', 'none');
        });
//        $.each($("#resultTypeStr").val().split(","), function (i, item) {
//            $("input[name='resultType'][ value='" + item + "']").attr("checked", true);
//        });
    });

    function saveStep2(obj) {
        if (tlxyValidate.form()) {
            var onclickFn = $(obj).attr("onclick");
            $(obj).removeAttr("onclick");
            $("#form1").attr("action", "/f/proModelTlxy/ajaxSave2");
            $(obj).prop('disabled', true);
            $("#form1").ajaxSubmit(function (data) {
                if (checkIsToLogin(data)) {
                    dialogCyjd.createDialog(0, "未登录或登录超时。请重新登录，谢谢！", {
                        dialogClass: 'dialog-cyjd-container none-close',
                        buttons: [{
                            text: '确定',
                            'class': 'btn btn-sm btn-primary',
                            click: function () {
                                $(this).dialog('close');
                                top.location = top.location;
                            }
                        }]
                    });
                } else {
                    if (data.ret == 1) {
                        top.location = "/f/proModelTlxy/applyStep3?id=" + data.id;
                    } else {
                        $(obj).attr("onclick", onclickFn);
                        dialogCyjd.createDialog(0, data.msg, {
                            dialogClass: 'dialog-cyjd-container none-close',
                            buttons: [{
                                text: '确定',
                                'class': 'btn btn-sm btn-primary',
                                click: function () {
                                    $(this).dialog('close');
                                }
                            }]
                        });
                    }
                }
                $(obj).prop('disabled', false);
            });
        }
    }
    function prevStep() {
        if (checkIsFill()) {
            saveStep2UnCheck("1");
        } else {
            var id = $("#id").val();
            toPrevStep(id);
        }
    }
    function toPrevStep(id) {
        top.location = "/f/proModelTlxy/applyStep1?actywId=" + $("#actYwId").val() + (id == "" ? "" : "&id=" + id);
    }
    function saveStep2UnCheck(type) {
        var preFn = $("#prevbtn").attr("onclick");
        $("#prevbtn").removeAttr("onclick");
        var saveFn = $("#savebtn").attr("onclick");
        $("#savebtn").removeAttr("onclick");
        var nextFn = $("#nextbtn").attr("onclick");
        $("#nextbtn").removeAttr("onclick");
        $("#form1").attr("action", "/f/proModelTlxy/ajaxUncheckSave2");
        $("#form1").ajaxSubmit(function (data) {
            if (checkIsToLogin(data)) {
                dialogCyjd.createDialog(0, "未登录或登录超时。请重新登录，谢谢！", {
                    dialogClass: 'dialog-cyjd-container none-close',
                    buttons: [{
                        text: '确定',
                        'class': 'btn btn-sm btn-primary',
                        click: function () {
                            $(this).dialog('close');
                            top.location = top.location;
                        }
                    }]
                });
            } else {
                $("#prevbtn").attr("onclick", preFn);
                $("#savebtn").attr("onclick", saveFn);
                $("#nextbtn").attr("onclick", nextFn);
                if (data.ret == 1) {
                    if ($("#id").val() == "") {
                        $("#id").val(data.id);
                    }
                    $(".fill").each(function (i, v) {
                        $(v).attr("oldv", $(v).val());
                    });
                    if (typeof($("[name='logoUrl']").val()) != "undefined" && $("[name='logoUrl']").val() != "") {
                        $("[name='logoUrl']").val("");
                    }
                    if (type == "1") {
                        toPrevStep(data.id);
                    } else {
                        dialogCyjd.createDialog(1, data.msg, {
                            dialogClass: 'dialog-cyjd-container none-close',
                            buttons: [{
                                text: '确定',
                                'class': 'btn btn-sm btn-primary',
                                click: function () {
                                    $(this).dialog('close');
                                }
                            }]
                        });
                    }

                } else {
                    dialogCyjd.createDialog(0, data.msg, {
                        dialogClass: 'dialog-cyjd-container none-close',
                        buttons: [{
                            text: '确定',
                            'class': 'btn btn-sm btn-primary',
                            click: function () {
                                $(this).dialog('close');
                            }
                        }]
                    });
                }
            }
        });
    }
    function checkIsFill() {
        var tag = false;
        $(".fill").each(function (i, v) {
            if ($(v).val() != "" && $(v).attr("oldv") != $(v).val()) {
                tag = true;
                return false;
            }
        });
        if (typeof($("[name='logoUrl']").val()) != "undefined" && $("[name='logoUrl']").val() != "") {
            tag = true;
        }
        return tag;
    }

    function findTeamPerson() {
          var teamId = $("[id='proModel.teamId']").val();
          if (!teamId) {
              $(".studenttb thead").nextAll().remove();
              $(".teachertb thead").nextAll().remove();
              return false;
          }

          var type = $("[id='proModel.proCategory']").val();
          if (type == "") {
              dialogCyjd.createDialog(0, "请先选择项目类别", {
                  dialogClass: 'dialog-cyjd-container none-close',
                  buttons: [{
                      text: '确定',
                      'class': 'btn btn-sm btn-primary',
                      click: function () {
                          $(this).dialog('close');
                      }
                  }]
              });
              $("[id='proModel.teamId']").val("");
              $(".studenttb thead").nextAll().remove();
              $(".teachertb thead").nextAll().remove();
              return false;
          }

          $.ajax({
              type: "GET",
              url: "/f/project/projectDeclare/findTeamPerson",
              data: "id=" + teamId,
              contentType: "application/json; charset=utf-8",
              dataType: "json",
              success: function (data) {
                  $(".studenttb thead").nextAll().remove();
                  $(".teachertb thead").nextAll().remove();
                  if (data) {
                      var shtml = "";
                      var scount = 1;
                      var thtml = "";
                      var tcount = 1;
                      $.each(data, function (i, v) {
                          if (v.user_type == '1') {
                              shtml = shtml + "<tr>"
                                      + "<td>" + scount + "<input type='hidden' name='proModel.studentList[" + (scount - 1) + "].userId' value='" + v.userId + "' /></td>"
                                      + "<td>" + (v.name || "") + "</td>"
                                      + "<td>" + (v.no || "") + "</td>"
                                      + "<td>" + (v.org_name || "") + "</td>"
                                      + "<td>" + (v.professional || "") + "</td>"
                                      + "<td>" + (v.mobile || "") + "</td>"
                                      + "<td>" + (v.currState || "") + "</td>"
                                      + "<td>" + (v.curJoin || "") + "</td>"
                                      + "<td>" + (v.domain || "") + "</td>"


                                      + "</tr>";
                              scount++;
                          }
                          if (v.user_type == '2') {
                              thtml = thtml + "<tr>"
                                      + "<td>" + tcount + "<input type='hidden' name='proModel.teacherList[" + (tcount - 1) + "].userId' value='" + v.userId + "' /></td>"
                                      + "<td>" + (v.name || "") + "</td>"
                                      + "<td>" + (v.no || "") + "</td>"
                                      + "<td>" + (v.org_name || "") + "</td>"
                                      + "<td>" + (v.teacherType || "") + "</td>"
                                      + "<td>" + (v.curJoin || "") + "</td>"
                                      + "<td>" + (v.domain || "") + "</td>"
                                      + "</tr>";
                              tcount++;
                          }
                      });
                      $(".studenttb").append(shtml);
                      $(".teachertb").append(thtml);
                      snumber = scount - 1;
                      //checkProjectTeam();
                  }
              },
              error: function (msg) {
                  dialogCyjd.createDialog(0, "未登录或登录超时。请重新登录，谢谢！", {
                      dialogClass: 'dialog-cyjd-container none-close',
                      buttons: [{
                          text: '确定',
                          'class': 'btn btn-sm btn-primary',
                          click: function () {
                              $(this).dialog('close');
                              top.location = top.location;
                          }
                      }]
                  });
              }
          });
      }

    function checkProjectTeam() {
        if (!$("[id='teamId']").val()) {
            return;
        }
        $.ajax({
            type: 'post',
            url: '/f/project/projectDeclare/checkProjectTeam',
            data: {
                proid: $("[id='id']").val(),
                actywId: $("[id='actYwId']").val(),
                lowType: $("[id='proCategory']").val(),
                teamid: $("[id='teamId']").val()
            },
        success: function (data) {
            if (checkIsToLogin(data)) {
                dialogCyjd.createDialog(0, "未登录或登录超时。请重新登录，谢谢！", {
                    dialogClass: 'dialog-cyjd-container none-close',
                    buttons: [{
                      text: '确定',
                      'class': 'btn btn-sm btn-primary',
                      click: function () {
                          $(this).dialog('close');
                          top.location = top.location;
                      }
                    }]
                });
            } else {
                if (data.ret == '0') {
                    dialogCyjd.createDialog(0, data.msg, {
                        dialogClass: 'dialog-cyjd-container none-close',
                            buttons: [{
                                text: '确定',
                                'class': 'btn btn-sm btn-primary',
                                click: function () {
                                    $(this).dialog('close');
                                }
                            }]
                        });
                    }
                }
            }
        });
    }
</script>
</body>
</html>