<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>${frontTitle}</title>
    <meta name="decorator" content="cyjd-site-default"/>
    <script src="/other/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>
    <link rel="stylesheet" type="text/css" href="/static/webuploader/webuploader.css">
    <script type="text/javascript" src="/static/webuploader/webuploader.min.js"></script>
    <script type="text/javascript"  src="/js/frontCyjd/uploaderFile.js?v=101"></script>
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
    .form-control[readonly]{
        background-color: white;
    }



    body,input,textarea,.btn,.form-control,.upload-content .webuploader-pick{
        font-size:12px;
    }

    .row-apply .titlebar,.edit-bar-sm .edit-bar-left > span{
        font-size:13px;
    }

</style>

<div class="container container-ct">
    <ol class="breadcrumb" style="margin-top: 0">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li><a href="${ctxFront}/cms/page-innovation">双创项目</a></li>
        <li class="active">申报</li>
    </ol>

    <div class="main-wrap">
        <div class="row-step-cyjd" style="height: 30px; margin-bottom: 15px;">
            <div class="step-indicator" style="margin-right: -20px;">
                <a class="step">第一步（填写项目基本信息）</a>
                <a class="step">第二步（填写团队基本信息）</a>
                <a class="step completed">第三步（提交项目申报附件）</a>
            </div>
        </div>



        <div class="row-apply">
            <h4 class="titlebar">${proModelType}申报</h4>
            <form:form id="form1" modelAttribute="proModelTlxy" action="#" method="post" class="form-horizontal"
                       enctype="multipart/form-data">
                <input type="hidden" name="proModel.declareId" id="declareId" value="${cuser.id}"/>
                <input type="hidden" name="id" id="id" value="${proModelTlxy.id}"/>
                <input type="hidden" name="actYwId" id="actYwId" value="${proModelTlxy.proModel.actYwId}"/>
                <input type="hidden" name="proModel.proType" id="id" value="${proModelTlxy.proModel.proType}"/>
                <div class="row row-user-info" style="margin-top:28px;">
                    <div class="col-xs-8">
                        <label class="application-one">填报日期：</label>
                        <input id="declareDate" class="Wdate form-control date-input" type="text"
                               name="proModel.subTime" readonly="readonly"
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
                        <span>项目附件</span>
                        <i class="line"></i>
                    </div>
                </div>

                <div class="form-group" style="position:relative;left:115px;margin-top:30px;">
                    <label class="control-label col-xs-1" style="width: 170px;">下载项目申报模板：</label>
                    <div id="projectInfo" class="panel-body collapse in" style="margin-left:180px;">
                        <div class="accessories">
                            <div class="accessory" id="projectFiles" style="overflow: hidden;">
                                <div class="accessory-info one-line" style="margin:5px 20px 20px 0;">
                                    <a href="/f/proproject/downTemplate?type=tlxy_cxxl">
                                        <img src="/images/word.png">
                                        <span class="accessory-name">创新训练项目申请表</span>
                                    </a>
                                </div>
                                <div class="accessory-info one-line" style="margin:5px 20px 20px 0;">
                                    <a href="/f/proproject/downTemplate?type=tlxy_cyxl">
                                        <img src="/images/word.png">
                                        <span class="accessory-name">创业训练项目申请表</span>
                                    </a>
                                </div>
                                <div class="accessory-info one-line" style="margin:5px 20px 20px 0;">
                                    <a href="/f/proproject/downTemplate?type=tlxy_cysj">
                                        <img src="/images/word.png">
                                        <span class="accessory-name">创业实践项目申请表</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
                <div class="form-horizontal form-enter-apply" style="margin-left:95px;">
                    <div class="form-group">
                        <label class="control-label col-xs-2"><i>*</i>附件：</label>
                        <div class="col-xs-8">
                            <c:if test="${proModelTlxy.proModel.subStatus=='1'}">
                                <sys:frontFileUpload className="accessories-h34" readonly="true" fileitems="${proModelTlxy.proModel.fileInfo}" filepath="project" tip1="支持上传word、pdf、excel、txt、rar、ppt图片类型等文件" tip2="（上传项目申报表单、商业计划书等项目文件）"></sys:frontFileUpload>
                            </c:if>
                            <c:if test="${proModelTlxy.proModel.subStatus!='1'}">
                                <sys:frontFileUpload className="accessories-h34"  fileitems="${proModelTlxy.proModel.fileInfo}" filepath="project" tip1="支持上传word、pdf、excel、txt、rar、ppt图片类型等文件" tip2="（上传项目申报表单、商业计划书等项目文件）"></sys:frontFileUpload>
                            </c:if>

                                <%--<sys:frontFileUpload className="accessories-h34" fileitems="${proModel.fileInfo}" filepath="projectgt" tip2="（上传项目申报表单、商业计划书等项目文件）"></sys:frontFileUpload>--%>
                        </div>
                    </div>
                </div>
            </form:form>

            <div class="form-actions-cyjd text-center">
                <a id="prevbtn" class="btn btn-primary" data-control="uploader" href="javascript:void(0)" onclick="prevStep()" style="margin-right: 10px;">上一步</a>
                <button id="savebtn" type="button" data-control="uploader" class="btn btn-primary btn-save" onclick="saveStep3(this)"
                        style="margin-right: 10px;">保存
                </button>
                <button id="subbtn" data-control="uploader" type="button" class="btn btn-primary" onclick="submitStep3(this)">提交</button>
            </div>

        </div>


    </div>

</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>


<script>
    function saveStep3(obj) {
        var onclickFn = $(obj).attr("onclick");
        $(obj).removeAttr("onclick");
        $("#form1").attr("action", "/f/proModelTlxy/ajaxSave3");
        $(obj).prop('disabled', true);
        $("#form1").ajaxSubmit(function (data) {
            if (checkIsToLogin(data)) {
                dialogCyjd.createDialog(data.ret, "未登录或登录超时。请重新登录，谢谢！", {
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
                $(obj).prop('disabled', false);
            } else {
                if (data.ret == 1) {
                    $(".fileparamspan").html("");
                    $(obj).attr("onclick", onclickFn);
                    dialogCyjd.createDialog(data.ret, '保存成功，跟踪当前项目？', {
                    	dialogClass: 'dialog-cyjd-container none-close',
                        buttons: [{
                            text: '确定',
                            'class': 'btn btn-sm btn-primary',
                            click: function () {
                                $(this).dialog('close');
                                top.location = "/f/project/projectDeclare/curProject";
                            }
                        },{
                            text: '取消',
                            'class': 'btn btn-sm btn-primary',
                            click: function () {
                                $(this).dialog('close');
                                top.location = top.location;
                            }
                        }]
                    });
                    $(obj).prop('disabled', false);
                } else {
                    dialogCyjd.createDialog(data.ret, data.msg);
                    $(obj).prop('disabled', false);
                }
            }

        });
    }

    function submitStep3(obj) {
        if (ckeckFiles()) {

            dialogCyjd.createDialog(0, '提交后不可修改，是否继续？', {
                dialogClass: 'dialog-cyjd-container',
                buttons: [
                    {
                        text: '继续',
                        'class': 'btn btn-sm btn-primary',
                        click: function () {
                            $(this).dialog('close');

                            var onclickFn = $(obj).attr("onclick");
                            $(obj).removeAttr("onclick");
                            $("#form1").attr("action", "/f/proModelTlxy/submit");
                            $(obj).prop('disabled', true);
                            $("#form1").ajaxSubmit(function (data) {
                                if (checkIsToLogin(data)) {
                                    dialogCyjd.createDialog(data.ret, "未登录或登录超时。请重新登录，谢谢！", {
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
                                    $(obj).prop('disabled', false);
                                } else {
                                    if (data.ret == 1) {
                                        $(".fileparamspan").html("");
                                        dialogCyjd.createDialog(data.ret, '保存成功，跟踪当前项目？', {
                                            dialogClass: 'dialog-cyjd-container none-close',
                                            buttons: [{
                                                text: '确定',
                                                'class': 'btn btn-sm btn-primary',
                                                click: function () {
                                                    $(this).dialog('close');
                                                    top.location = "${ctxFront}/project/projectDeclare/curProject";
                                                }
                                            }]
                                        });

                                    } else {
                                        $(obj).attr("onclick", onclickFn);
                                        dialogCyjd.createDialog(data.ret, data.msg);
                                        $(obj).prop('disabled', false);
                                    }
                                }
//                                $(obj).prop('disabled', false);
                            });
                        }
                    },
                    {
                        text: '取消',
                        'class': 'btn btn-sm btn-primary',
                        click: function () {
                            $(this).dialog('close');
                        }
                    }
                ]
            });
        } else {
            dialogCyjd.createDialog(0, "请上传附件");
        }
    }
    function ckeckFiles() {
        var newfiles = $("input[name='attachMentEntity.fielFtpUrl']");
        if (newfiles.length > 0) {
            return true;
        } else {
            var oldfiles = $("a[class='accessory-file']");
           return oldfiles.length > 0
        }
    }
    function prevStep(){
        var newfiles = $("input[name='attachMentEntity.fielFtpUrl']");
        if (newfiles.length > 0) {
            saveStep3UnCheck();
        }else{
            var id=$("#id").val();
            toPrevStep(id);
        }
    }
    function toPrevStep(id){
        top.location="/f/proModelTlxy/applyStep2?id="+id;
    }
    function saveStep3UnCheck(){
        var preFn=$("#prevbtn").attr("onclick");
        $("#prevbtn").removeAttr("onclick");
        var saveFn=$("#savebtn").attr("onclick");
        $("#savebtn").removeAttr("onclick");
        var subFn=$("#subbtn").attr("onclick");
        $("#subbtn").removeAttr("onclick");
        $("#form1").attr("action","/f/proModelTlxy/saveStep3");
        $("#form1").ajaxSubmit(function (data) {
            if(checkIsToLogin(data)){
                dialogCyjd.createDialog(data.ret, "未登录或登录超时。请重新登录，谢谢！", {
                    dialogClass: 'dialog-cyjd-container',
                    buttons: [{
                        text: '确定',
                        'class': 'btn btn-sm btn-primary',
                        click: function () {
                            $(this).dialog('close');
                            top.location = top.location;
                        }
                    }]
                });
            }else{
                if(data.ret==1){
                    toPrevStep($("#id").val());
                }else{
                    $("#prevbtn").attr("onclick",preFn);
                    $("#savebtn").attr("onclick",saveFn);
                    $("#subbtn").attr("onclick",subFn);
                    dialogCyjd.createDialog(data.ret, data.msg, {
                        dialogClass: 'dialog-cyjd-container',
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
            }
        });
    }
</script>
</body>
</html>