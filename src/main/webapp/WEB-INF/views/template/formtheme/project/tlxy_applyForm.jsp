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
    .delete-image{
        left: 106px;
        border:none;
    }

    .delete-image img{
        width: 18px;
        height: 18px;
        margin: -3px 0 0 0px;
    }

    .delete-image img:hover{
        cursor: pointer;
    }





    body,input,textarea,.btn,.form-control{
        font-size:12px;
    }

    .row-apply .titlebar,.edit-bar-sm .edit-bar-left > span{
        font-size:13px;
    }







</style>

<script>
    $(function () {
        var $modalAvatar = $('#modalAvatar');
        var $backImg = $('.backimg');
        var $upImg = $('.upImg');
        var $upImgFile = $('.upImgFile');
        var $cropperImg = $('.cropperImg');
        var $upLoadImg = $('.upLoadImg');
        var deleteImg = $('.delete-image');
        var $hideImg = $('.hide-img');
        var $shadeWord = $('.shade-word');
        var $uploadProjectImg = $('.upload-project-img');

        var flag = false;

        $uploadProjectImg.on('click', function () {
            if (flag) {
                $cropperImg.cropper('replace', $backImg.attr('src'));
            } else {
                $cropperImg.attr('src', $backImg.attr('src'));
            }
        });
        $upImg.on('click', function () {
            $upImgFile.trigger('click');
        });

        $upImgFile.change(function () {
            var obj = $upImgFile[0].files[0];
            var fr = new FileReader();
            fr.onload = function () {

                if (!flag) {
                    flag = true;
                    $cropperImg.attr('src', this.result);
                    $cropperImg.cropper({
                        aspectRatio: 1,
                        viewMode: 1,
                        crop: function (e) {
                        }
                    });
                } else {
                    $cropperImg.cropper("reset", true).cropper('replace', this.result);
                }
            };
            fr.readAsDataURL(obj);
        });


        $upLoadImg.on('click', function () {

            var formData = new FormData();
            formData.append('upfile', $upImgFile[0].files[0]);
            var inputName = "proModel.logoUrl";
            /*获取上传的图片对象*/
            var filepath = 'projectlogo'
            var imgData = $cropperImg.cropper('getData');
            var x = parseInt(imgData.x);
            var y = parseInt(imgData.y);
            var width = parseInt(imgData.width);
            var height = parseInt(imgData.height);
            $hideImg.attr('name', inputName);

            $.ajax({
                url: $frontOrAdmin+'/ftp/ueditorUpload/cutImgToTempDir?folder=' + filepath + '&x=' + x + '&y=' + y + '&width=' + width + '&height=' + height,
                type: 'POST',
                data: formData,
                contentType: false,
                processData: false,
                success: function (args) {
                    /*服务器端的图片地址*/
                    $backImg.attr('src', args.url);
                    $hideImg.val(args.ftpUrl);
                    $modalAvatar.modal('hide');
                }
            })

        });


        deleteImg.click(function () {
            var url = $backImg.attr("src");
            if (url == null || url == "" || url == '/images/default-pic.png') {
                return;
            }

            dialogCyjd.createDialog(0, "确定删除?", {
                dialogClass: 'dialog-cyjd-container none-close',
                buttons: [{
                    text: '确定',
                    'class': 'btn btn-sm btn-primary',
                    click: function () {
                        //向服务器发出请求，删除文件
                        var inputUrl = $hideImg.val();
                        var id = $("#logoSysAttId").val();
                        $.ajax({
                            type: 'post',
                            url: $frontOrAdmin+'/ftp/ueditorUpload/delFile',
                            data: {
                                url: inputUrl,
                                id: id
                            },
                            success: function (data) {
                                $backImg.attr('src', '/images/upload-default-image1.png');
                                $hideImg.val('');
                                $upImgFile[0].files = null;
                            }
                        });
                        $(this).dialog('close');
                    }
                }, {
                    text: '取消',
                    'class': 'btn btn-sm btn-default',
                    click: function () {
                        $(this).dialog('close');
                    }
                }]
            });


        });


    });

</script>

<div class="container container-ct">

    <ol class="breadcrumb" style="margin-top: 0">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li><a href="${ctxFront}/cms/page-innovation">双创项目</a></li>
        <li class="active">申报</li>
    </ol>
    <div class="row-step-cyjd mgb40">
        <div class="step-indicator">
            <a class="step completed">第一步（填写项目基本信息）</a>
            <a class="step">第二步（填写团队基本信息）</a>
            <a class="step">第三步（提交项目申报附件）</a>
        </div>
    </div>


    <div class="row-apply">
        <h4 class="titlebar">${proModelType}申报</h4>
        <form:form id="form1" modelAttribute="proModelTlxy" action="#" method="post" class="form-horizontal"
                   enctype="multipart/form-data">
            <input type="hidden" name="proModel.declareId" id="declareId" value="${cuser.id}"/>
            <input type="hidden" name="proModel.actYwId" id="actYwId" value="${actYw.id}"/>
            <input type="hidden" name="proModel.id" id="proModelId" value="${proModelTlxy.proModel.id}"/>
            <input type="hidden" name="id" id="id" value="${proModelTlxy.id}"/>
            <div class="row row-user-info" style="margin-top:28px;">
                <div class="col-xs-8">
                    <label class="control-label application-one"><i>*</i>填报日期：</label>
                    <input id="declareDate" class="Wdate form-control date-input required declareDate" readonly="readonly" type="text"
                           name="proModel.subTime" style="display: inline-block;background-color: white;"
                           value='<fmt:formatDate value="${proModelTlxy.proModel.subTime}" pattern="yyyy-MM-dd"/>'
                           onfocus="WdatePicker()"/>
                </div>
                <%--<div class="col-xs-4">--%>
                    <%--<label class="application-one">项目编号：</label>--%>
                    <%--<p class="application-p">${proModelTlxy.proModel.competitionNumber}</p>--%>
                <%--</div>--%>
            </div>

            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>申报人基本信息</span>
                    <i class="line"></i>
                </div>
            </div>


            <div class="row row-user-info">
                <div class="col-xs-6">
                    <label class="label-static">项目负责人：</label>
                    <p class="form-control-static">${cuser.name}</p>
                </div>
                <div class="col-xs-6">
                    <label class="label-static">学号/毕业年份：</label>
                    <p class="form-control-static">${cuser.no}</p>
                </div>
            </div>
            <div class="row row-user-info">
                <div class="col-xs-6">
                    <label class="label-static">所属学院：</label>
                    <p class="form-control-static">${cuser.office.name}</p>
                </div>
                <div class="col-xs-6">
                    <label class="label-static">专业：</label>
                    <p class="form-control-static">${fns:getProfessional(cuser.professional)}</p>
                </div>
            </div>
            <div class="row row-user-info">
                <div class="col-xs-6">
                    <label class="label-static">联系电话：</label>
                    <p class="form-control-static">${cuser.mobile}</p>
                </div>
                <div class="col-xs-6">
                    <label class="label-static">Email：</label>
                    <p class="form-control-static">${cuser.email}</p>
                </div>
            </div>


            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>项目基本信息</span>
                    <i class="line"></i>
                </div>
            </div>
            <div class="form-group" style="position:relative;left:45px;">
                <label class="control-label col-xs-1" style="width: 150px;"><i>*</i>项目名称：</label>
                <div class="col-xs-4">
                    <input type="text" class="form-control required fill" oldv="${proModelTlxy.proModel.pName}"
                           maxlength="128" name="proModel.pName" value="${proModelTlxy.proModel.pName}"
                           placeholder="最多128个字符">
                </div>
            </div>
            <div class="form-group form-span-checkbox" style="position:relative;left:45px;margin-top:30px;">
                <label class="control-label col-xs-1" style="width: 150px;"><i>*</i>项目类别：</label>
                <div class="col-xs-9 input-box" style="margin-top:5px;">
                    <form:radiobuttons class="required" path="proModel.proCategory" items="${fns:getDictList('project_type')}"
                                     itemValue="value"
                                     itemLabel="label" htmlEscape="false"/>
                </div>
            </div>
            <div class="form-group" style="position:relative;left:45px;margin-top:30px;">
                <label class="control-label col-xs-1" style="width: 150px;">项目来源：</label>
                <div class="col-xs-3">

                    <form:select path="source" class="form-control required fill" >
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('project_source')}"
                            itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>

                </div>
            </div>

            <div class="form-group" style="position:relative;left:45px;margin-top:30px;">
                <label class="control-label col-xs-1" style="width: 152px;">项目拓展及传承：</label>
                <div class="col-xs-8" style="padding-top:7px;">
                        <span>1、项目能与其他大型比赛、活动对接 </span>
                        <span>2、可在低年级同学中传承 </span>
                        <span>3、结项后能继续开展 </span>
                </div>
            </div>
            <div class="form-horizontal form-enter-apply" style="margin:35px 0 30px -14px;">
                <div class="form-group">
                    <label class="control-label col-xs-2">项目logo：</label>
                    <div class="col-xs-6 col-size">

                        <div id="ground-img" style="position: relative;">
                            <div>
                                <input class="hide-img" type="hidden" value="${proModelTlxy.proModel.logo.url }">
                                <img class="backimg"
                                     src="${empty proModelTlxy.proModel.logo.url ? '/images/default-pic.png':fns:ftpImgUrl(proModelTlxy.proModel.logo.url)}">
                            </div>
                            <c:if test="${empty proModelTlxy.proModel.procInsId}">
                                <%--<div class="shade-img">--%>
                                    <%--<span></span>--%>
                                <%--</div>--%>
                                <%--<div class="shade-word" data-toggle="modal" data-target="#modalAvatar">更换项目logo--%>
                                <%--</div>--%>
                                <%--<button type="button" class="btn btn-primary" class="upload-project-img" data-toggle="modal" data-target="#modalAvatar" style="position:absolute;top: 76px;left: 155px;">上传项目图片</button>--%>
                                <div class="delete-image">
                                    <img src="/images/delete-pic.png">
                                </div>
                            </c:if>
                                <%--<div class="loadding"><img src="/images/loading.gif"></div>--%>
                        </div>
                            <%--<div class="click-img">--%>

                            <%--</div>--%>

                        <c:if test="${empty proModelTlxy.proModel.procInsId}">
                            <button type="button" class="btn btn-primary upload-project-img" data-toggle="modal" data-target="#modalAvatar" style="position:absolute;top: 76px;left: 155px;">上传图片</button>
                        </c:if>

                        <div class="help-inline">
                            <span>建议背景图片大小：200 × 200（像素）</span>
                        </div>

                    </div>
                </div>
            </div>
            <input id="logoSysAttId" type="hidden" value="${proModelTlxy.proModel.logo.id}">
            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>项目介绍</span>
                    <i class="line"></i>
                </div>
            </div>
            <div class="form-group" style="position:relative;left:45px;margin-top:30px;">
                <label class="control-label col-xs-1" style="width: 150px;"><i>*</i>项目简介：</label>
                <div class="col-xs-9">
                    <textarea class="form-control required fill" oldv="${proModel.introduction }"
                              name="proModel.introduction"
                              rows="3"
                              maxlength="2000" placeholder="1、请简要描述项目的立项背景、项目的主要内容及实施目标；
2、项目的特色或创新点。(最多2000个字符)">${proModelTlxy.proModel.introduction }</textarea>
                </div>
            </div>
            <div class="form-group" style="position:relative;left:45px;margin-top:30px;">
                <label class="control-label col-xs-1" style="width: 150px;">前期调研准备：</label>
                <div class="col-xs-9">
                    <textarea class="form-control"
                              name="innovation"
                              rows="3"
                              maxlength="2000">${proModelTlxy.innovation}</textarea>
                </div>
            </div>
            <div class="form-group" style="position:relative;left:45px;margin-top:30px;">
                <label class="control-label col-xs-1" style="width: 150px;"><i>*</i>项目预案：</label>
                <div class="input-box col-xs-9">
                    <table class="table table-bordered table-condensed table-orange table-center table-nowrap table-hover table-team yuantb">
                        <thead>
                        <tr>
                            <th>实施预案</th>
                            <th width="300">时间安排</th>
                            <th>保障措施</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>
                                <textarea name="planContent" class="form-control required" rows="3" maxlength="2000">${proModelTlxy.planContent}</textarea>
                            </td>
                            <td style="vertical-align: middle">
                                <div class="time-input-inline">
                                    <input id="plan-start-date" class="Wdate date-input required" type="text" readonly="readonly"
                                           name="planStartDate" style="width: 120px;"
                                           value='<fmt:formatDate value="${proModelTlxy.planStartDate}" pattern="yyyy-MM-dd"/>'
                                           onfocus="WdatePicker()"/>
                                    <span>至</span>
                                    <input id="plan-end-date" class="Wdate date-input required" type="text" readonly="readonly"
                                           name="planEndDate" style="width: 120px;"
                                           value='<fmt:formatDate value="${proModelTlxy.planEndDate}" pattern="yyyy-MM-dd"/>'
                                           onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,minDate:$('#plan-start-date').val()})"/>
                                </div>
                            </td>
                            <td>
                                <textarea name="planStep" class="form-control required" rows="3" maxlength="2000">${proModelTlxy.planStep}</textarea>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="form-group" style="position:relative;left:45px;margin-top:30px;">
                <label class="control-label col-xs-1" style="width: 150px;"><i>*</i>任务分工：</label>
                <div class="input-box col-xs-9">
                    <table class="table table-bordered table-condensed table-orange table-center table-nowrap table-hover table-team task">
                        <thead>
                        <tr>
                            <th width="48">序号</th>
                            <th width="170">工作任务</th>
                            <th width="170">任务描述</th>
                            <th width="300">时间安排</th>
                            <th width="100">成本</th>
                            <th width="100">质量评价</th>
                            <th width="65px">操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${proModelTlxy.planList==null||proModelTlxy.planList.size() ==0}">
                            <tr>
                                <td>
                                    1
                                </td>
                                <td>
                                    <textarea name="planList[0].content" maxlength="2000" required rows="3"
                                              class="form-control"></textarea>
                                </td>
                                <td>
                                    <textarea name="planList[0].description" maxlength="2000" required rows="3"
                                              class="form-control"></textarea>
                                </td>
                                <td style="vertical-align: middle">
                                    <div class="time-input-inline">

                                        <input required id="plan-start-date-0" class="Wdate date-input required" readonly="readonly"
                                               style="width: 120px;"
                                               type="text"
                                               name="planList[0].startDate"
                                               onClick="WdatePicker()"/>
                                        <span>至</span>
                                        <input required id="plan-end-date-0" class="Wdate date-input required" type="text" readonly="readonly"
                                               style="width: 120px;"
                                               name="planList[0].endDate"
                                               onClick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,minDate:$('#plan-start-date-0').val()})"/>
                                    </div>
                                </td>
                                <td style="vertical-align: middle">
                                    <input type="number" class="number form-control required" maxlength="20"
                                           name="planList[0].cost"/>
                                </td>
                                <td>
                                    <textarea name="planList[0].quality" maxlength="2000" required rows="3"
                                              class="form-control"></textarea>
                                </td>
                                <td>
                                    <a class="minus"></a>
                                    <a class="plus"></a>
                                </td>
                            </tr>
                        </c:if>
                        <c:if test="${proModelTlxy.planList!=null&&proModelTlxy.planList.size() >0}">
                            <c:forEach items="${proModelTlxy.planList}" var="item" varStatus="status">
                                <tr>
                                    <td>
                                            ${status.index+1}
                                    </td>
                                    <td>
                                        <textarea required maxlength="2000" class="form-control required" rows="3"
                                                  name="planList[${status.index}].content">${proModelTlxy.planList[status.index].content }</textarea>
                                    </td>
                                    <td>
                                        <textarea required maxlength="2000" class="form-control required" rows="3"
                                                  name="planList[${status.index}].description">${proModelTlxy.planList[status.index].description }</textarea>
                                    </td>
                                    <td style="vertical-align: middle">
                                        <div class="time-input-inline">
                                            <input required id="plan-start-date-${status.index}"
                                                   class="Wdate date-input required"
                                                   type="text" readonly="readonly"
                                                   style="width: 120px;"
                                                   value='<fmt:formatDate value="${proModelTlxy.planList[status.index].startDate }" pattern="yyyy-MM-dd"/>'
                                                   name="planList[${status.index}].startDate"
                                                   onClick="WdatePicker()"/>
                                            <span>至</span>
                                            <input required id="plan-end-date-${status.index}"
                                                   class="Wdate date-input required" type="text"
                                                   style="width: 120px;" readonly="readonly"
                                                   value='<fmt:formatDate value="${proModelTlxy.planList[status.index].endDate }" pattern="yyyy-MM-dd"/>'
                                                   name="planList[${status.index}].endDate"
                                                   onClick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,minDate:$('#plan-end-date-${status.index}').val()})"/>
                                        </div>
                                    </td>
                                    <td style="vertical-align: middle">
                                        <input type="number" class="number form-control required" maxlength="20"
                                               name="planList[${status.index}].cost"
                                               value="${proModelTlxy.planList[status.index].cost }"/>
                                    </td>
                                    <td>
                                        <textarea required maxlength="2000"
                                                  name="planList[${status.index}].quality" rows="3"
                                                  class="form-control">${proModelTlxy.planList[status.index].quality }</textarea>
                                        <%--<input type="text" class="number form-control required" maxlength="20"--%>
                                               <%--name="planList[${status.index}].quality"--%>
                                               <%--value="${proModelTlxy.planList[status.index].quality }"/>--%>
                                    </td>
                                    <td>
                                        <a class="minus"></a>
                                        <a class="plus"></a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>



            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>预期成果</span>
                    <i class="line"></i>
                </div>
            </div>
            <div class="form-group form-span-checkbox" style="position:relative;left:45px;margin-top:30px;">
                <label class="control-label col-xs-1" style="width: 150px;"><i>*</i>成果形式：</label>
                <div class="col-xs-9 input-box" style="margin-top:5px;">
                    <%--<form:checkboxes class="required" path="projectDeclare.resultType" items="${resultTypeList}"--%>
                                     <%--itemValue="value"--%>
                                     <%--itemLabel="label" htmlEscape="false"/>--%>
                    <%--<form:hidden id="resultTypeStr" path="" value="${projectDeclare.resultType}"/>--%>
                        <form:checkboxes  path="resultType" items="${fns:getDictList('project_result_type')}"
                                         itemValue="value" class="required"
                                         itemLabel="label" htmlEscape="false"/>
                        <input type="hidden" id="resultTypeStr" value="${proModelTlxy.resultType}"/>
                </div>
            </div>
            <div class="form-group" style="position:relative;left:45px;margin-top:30px;">
                <label class="control-label col-xs-1" style="width: 150px;"><i>*</i>成果说明：</label>
                <div class="col-xs-9">
                    <textarea class="form-control required" rows="3"
                                                      name="resultContent"
                                                      maxlength="2000" >${proModelTlxy.resultContent}</textarea>

                </div>
            </div>



            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>经费预算</span>
                    <i class="line"></i>
                </div>
            </div>
            <div class="form-group" style="position:relative;left:45px;margin-top:30px;">
                <label class="control-label col-xs-1" style="width: 150px;"><i>*</i>项目经费预算：</label>
                <div class="col-xs-9">
                    <input type="number" class="form-control budget-dollar required" style="width: 150px;display: inline-block;margin-right:10px;" min="0"
                                                   maxlength="11" name="budgetDollar" value="${proModelTlxy.budgetDollar}">
                    <span>元（人民币）</span>

                </div>
            </div>
            <div class="form-group" style="position:relative;left:45px;margin-top:30px;">
                <label class="control-label col-xs-1" style="width: 150px;"><i>*</i>经费预算明细：</label>
                <div class="col-xs-9">
                    <textarea class="form-control required" rows="3" placeholder="简要描述在项目各个阶段产生的费用项目及明细，如：硬件采购、耗材费、差旅费等"
                                                      name="budget"
                                                      maxlength="2000">${proModelTlxy.budget}</textarea>

                </div>
            </div>



        </form:form>

        <div class="form-actions-cyjd text-center">
            <button type="button" class="btn btn-primary btn-save" onclick="saveStep1(this);">下一步</button>
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



    $(function () {

        onProjectApplyInit($("[id='actYwId']").val(), $("[id='id']").val(), null);

        $.each($("#resultTypeStr").val().split(","), function (i, item) {
            $("input[name='resultType'][ value='" + item + "']").attr("checked", true);
        });
    });
    function saveStep1(obj) {
        if(tlxyValidate.form()){
            var onclickFn = $(obj).attr("onclick");
            $(obj).removeAttr("onclick");
            $("#form1").attr("action", "/f/proModelTlxy/ajaxSave");
            $(obj).prop('disabled', true);
            $("#form1").ajaxSubmit(function (data) {
                if (checkIsToLogin(data)) {
                    dialogCyjd.createDialog(0, "未登录或登录超时。请重新登录，谢谢！", {
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
                } else {
                    if (data.ret == 1) {
                        top.location = "/f/proModelTlxy/applyStep2?actywId=" + $("#actYwId").val() + "&id=" +data.id;
                    } else {
                        $(obj).attr("onclick", onclickFn);
                        dialogCyjd.createDialog(data.ret, data.msg, {
                            dialogClass: 'dialog-cyjd-container',
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