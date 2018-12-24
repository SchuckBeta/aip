<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>${fns:getConfig('productName')}</title>
    <meta charset="UTF-8">
    <meta name="decorator" content="cyjd-site-default"/>
    <link rel="stylesheet" type="text/css" href="/css/sco/frontCreditModule.css?v=1">
    <link rel="stylesheet" type="text/css" href="/static/baguetteBox/css/baguetteBox.min.css">
    <script type="text/javascript" src="/static/webuploader/webuploader.min.js"></script>
    <script type="text/javascript" src="/js/sco/upload-accessoryStep.js"></script>
    <script type="text/javascript" src="/static/baguetteBox/js/baguetteBox.min.js"></script>

    <style>
        .file-list-img {
            overflow: hidden;
        }

        .file-item-img {
            float: left;
            margin-right: 15px;
            list-style: none;
            overflow: hidden;
        }

        .file-list-img .loading {
            line-height: 100px;
        }

        .file-list .file-item-img .file-info {
            position: relative;
            width: 102px;
            height: 102px;
            padding: 0;
            margin-bottom: 15px;
            background-color: transparent;
            border: 1px solid #ddd;
            overflow: hidden;
        }

        .file-item-img .file-name {
            position: absolute;
            left: 0;
            bottom: 0;
            right: 0;
            padding: 0 5px;
            text-overflow: ellipsis;
            overflow: hidden;
            white-space: nowrap;
            margin-bottom: 0;
            background-color: rgba(0, 0, 0, .3);
            color: #fff;
            font-size: 12px;
            line-height: 20px;
            text-align: center;
        }

        .file-item-img .icon {
            position: absolute;
            right: 0;
            top: 0;
        }

        .breadcrumb {
          margin-top: 30px;
          padding-left: 0;
          background-color: #fff; }

        .breadcrumb a {
          text-decoration: none; }

        .breadcrumb > li > a {
          color: #333; }

        .breadcrumb > li {
          color: #777; }

        .breadcrumb > li + li:before {
          content: "\003e";
          padding: 0 5px 0 3px;
          color: #ccc; }

        .breadcrumb .icon-home:before {
          content: "\f015";
          margin-right: 7px; }
    </style>
    <script type="text/javascript">

        var oneFloatReg = /^[0-9]+([.]{1}[0-9]{1,1})?$/;
        var validator;
        $(function () {
            var planTime=$("#planTime").val();
            validator = $("#inputForm").validate({
                rules: {
                    "realTime": {
                        digits: true,
                        max: parseFloat(planTime)
                    },
                    "realScore": {
                        oneFloat: true,
                        max: 100
                    }
                },
                errorPlacement: function (error, element) {
                    if (element.attr("id") == "score") {
                        error.insertAfter(element.next());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });
            jQuery.validator.addMethod("oneFloat", function (value, element) {
                var length = value.length;
                return this.optional(element) || oneFloatReg.test(value);
            }, "只能输入一位正小数");

            jQuery.validator.addMethod("removeZero", function (value, element) {
                var length = value.length;
                return this.optional(element) || (!(/^0\d+/.test(value)));
            }, "输入整数");

            $('input[name="realScore"], input[name="realTime"]').on('focus', function () {
                var val = $(this).val();
                if(val == 0){
                    $(this).val('')
                }
            }).blur(function () {
                var val = $(this).val();
                if(!val){
                    $(this).val('0');
                    validator.element($(this))
                }
            });

            $('#accessories').on('click', 'a', function (e) {
                e.preventDefault();
                var obj = this;
                var ftpUrl = $(obj).attr("data-ftp-url");
                var fileName = $(obj).attr("data-original") + "." + $(obj).attr('data-type');
                var type = $(obj).attr('data-type');
                var url = $(obj).attr('data-url');
                if (type == 'pdf') {
                    window.open('/f/ftp/pagePdfView?url=' + url + '&fileName=' + encodeURI(fileName) + '&ftpUrl=' + ftpUrl);
                }
            })

        });
        function saveForm() {
            if (validator.form()) {
                if ($("#accessories").find("a").length == 0) {
                    showModalMessage(0, "请上传成绩单");
                    return false;
                }

                var formData = $("#inputForm").serialize();

                //增加附件数据
                $("#accessories a").each(function (i, a) {
                    var $a = $(a);
                    var attachmentList = "attachmentList[" + i + "]";
                    var url = $a.attr('data-ftp-url');
                    var name = $a.attr('data-original');
                    var size = $a.attr('data-size');
                    var suffix = $a.attr('data-type');
                    formData = formData + "&" + attachmentList + ".url=" + url
                            + "&" + attachmentList + ".name=" + name
                            + "&" + attachmentList + ".size=" + size
                            + "&" + attachmentList + ".suffix=" + suffix;
                });

                $("#btnSubmit,#btnUpload").prop("disabled", true);

                $.ajax({
                    type: 'post',
                    url: '/f/scoapply/saveForm',
//					dataType:'json',
                    data: formData,
                    success: function (data) {
                        if (data) {
                            showModalMessage(1, "申请学分认定成功", {
                                '确定': function () {
                                    top.location = "/f/scoapply/scoApplyList";
                                }
                            });
                        }
                        $("#btnSubmit,#btnUpload").prop("disabled", false);
                    },
                    error: function() {
                        showModalMessage(0,"后台课程学分流程错误,请通知管理员");
                        $("#btnSubmit,#btnUpload").prop("disabled", false);
                    }
                });
            }
            return false;
        }


    </script>
</head>
<body>
<div class="container">
    <ol class="breadcrumb" style="margin-top: 60px">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li><a href="${ctxFront}/scoapply/scoApplyList">学分认定</a></li>
        <li><a href="${ctxFront}/scoapply/scoApplyList">课程学分认定</a></li>
        <li class="active">申请学分认定</li>
    </ol>
    <form action="/f/scoapply/saveForm" id="inputForm" autocomplete="off" style="margin-bottom: 60px">
        <input type="hidden" name="id" id="id" value="${scoApply.id}"/>
        <div class="credit-apply">
            <div class="credit-title-bar">
                <h3 class="title">创新创业课程学分认定申请</h3>
                <span class="time">申请日期：<fmt:formatDate value='${date}' pattern='yyyy-MM-dd'/></span>
            </div>
            <ul class="credit-user-profiles">
                <li>姓名：${user.name}</li>
                <li>性别：${fns:getDictLabel(user.sex, 'sex', '')}</li>
                <li>学号：${user.no}</li>
                <li>学院：${fns:getOffice(user.office.id).name}</li>
                <li>专业：${fns:getOffice(user.professional).name}</li>
                <li>班级：${studentExpansion.tClass}</li>
            </ul>
            <div class="credit-title-bar">
                <div class="lesson-info-wrap">
                    <span>课程名称：${scoCourse.name}</span>
                    <span>课程代码：${scoCourse.code}</span>
                    <span>课程性质：${fns:getDictLabel(scoCourse.nature, '0000000108', '')}</span>
                </div>
                <h4 class="title-sen">教学计划</h4>
            </div>
            <input type="hidden" id="planTime" value="${scoCourse.planTime}">
            <ul class="nav nav-cell-box">
                <li>计划课时：${scoCourse.planTime}</li>
                <li>合格成绩：${fns:deleteZero(scoCourse.overScore)}分及以上</li>
                <li>计划学分：${fns:deleteZero(scoCourse.planScore)}</li>
            </ul>
            <div class="credit-title-bar">
                <h4 class="title-sen">已经修读并获得学分</h4>
            </div>
            <ul class="nav nav-block-box">
                <li><span><span style="color: red;margin-right: 4px;">*</span>实际学时：</span>
                    <input type="text" name="realTime" id="realTime" class="form-control input-sm required removeZero"  value="${fns:deleteZero(scoApply.realTime)}"/>
                </li>
                <li><span><span style="color: red;margin-right: 4px;">*</span>实际成绩：</span>
                    <input type="text" name="realScore" id="score" class="form-control input-sm required removeZero" value="${fns:deleteZero(scoApply.realScore)}">
                    <span>分</span>
                </li>
            </ul>
            <div class="form-horizontal">
                <div class="form-group">
                    <label class="control-label col-md-2" style="width: 195px;"><span
                            style="color: red;margin-right: 4px;">*</span>申请课程学分认定理由：</label>
                    <div class="col-md-8" style="width: 600px; padding-left: 0">
                        <textarea class="form-control required" name="remarks" maxlength="2000" rows="5">${scoApply.remarks}</textarea>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-md-2" style="width: 188px;"><span
                            style="color: red;margin-right: 4px;">*</span>上传成绩单：</label>
                    <div id="accessories" class="col-md-10" style="padding-left: 0">
                        <ul id="accessoryList" class="file-list file-list-img tz-gallery">
                            <c:forEach items="${scoApply.attachmentList}" var="attachment">
                                <c:if test="${attachment.suffix ne 'pdf'}">
                                    <li class="file-item file-item-img">
                                        <div class="file-info" style="background: url('${attachment.ftpUrl}') no-repeat center/cover;">
                                            <!--图片-->
                                            <a href="${attachment.ftpUrl}" data-url="${attachment.ftpUrl}"
                                               data-original="${attachment.name}" data-size="${attachment.size}"
                                               data-title="${attachment.name}.${attachment.suffix}"
                                               data-type="${attachment.suffix}"
                                               data-ftp-url="${attachment.url}">
                                                <img src="${attachment.ftpUrl}" style="opacity: 0">
                                                <p class="file-name">${attachment.name}.${attachment.suffix}</p>
                                            </a>
                                            <i class="icon icon-remove-sign"></i>
                                        </div>
                                    </li>
                                </c:if>
                           </c:forEach>
                        </ul>
                        <ul id="accessoryListPdf" class="file-list">
                            <c:forEach items="${scoApply.attachmentList}" var="attachment">
                                <c:if test="${attachment.suffix eq 'pdf'}">
                                    <li class="file-item">
                                        <div class="file-info">
                                            <img src="/img/filetype/${fns:getSuffixValue(attachment.suffix)}.png">
                                            <a href="javascript:void(0);" data-url="${attachment.ftpUrl}"
                                               data-original="${attachment.name}" data-size="${attachment.size}"
                                               data-title="${attachment.name}.${attachment.suffix}"
                                               data-type="${attachment.suffix}"
                                               data-ftp-url="${attachment.url}">${attachment.name}.${attachment.suffix}</a>
                                            <i class="icon icon-remove-sign"></i>
                                        </div>
                                    </li>
                                </c:if>
                            </c:forEach>
                        </ul>
                        <p class="form-control-static" style="color: #ccc">注：请上传图片或者PDF</p>
                    </div>
                </div>
            </div>

            <c:if test="${scoApply.auditStatus eq '3' || scoApply.auditStatus eq '4'}">
                <div class="credit-title-bar">
                    <h4 class="title-sen">审核记录</h4>
                </div>
                <div class="audit-result">
                    <table class="table table-hover table-vertical table-bordered table-theme-yellow">
                        <thead>
                        <tr style="background-color: #f4e6d4">
                            <th>审核人</th>
                            <th>准予认定学分</th>
                                <%--	<th>审核结果</th>--%>
                            <th>建议及意见</th>
                            <th>审核时间</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${scoAuditingList}" var="scoAuditing">
                            <tr>
                                <td>${fns:getUserById(scoAuditing.user.id).name}</td>
                                <td>${fns:deleteZero(scoAuditing.scoreVal)}</td>
                                    <%--<td>未通过</td>--%>
                                <td>${scoAuditing.suggest}</td>
                                <td><fmt:formatDate value='${scoAuditing.updateDate}' pattern='yyyy-MM-dd'/></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
            <div class="text-center btn-box">
                <div id="btnUpload" class="btn btn-primary-oe">上传成绩单</div>
                <button id="btnSubmit" type="button" class="btn btn-primary-oe" onclick="saveForm();">提交申请</button>
                <button type="button" class="btn btn-default" onclick="history.go(-1)">返回</button>
            </div>
        </div>
    </form>
</div>
<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>
<script type="text/javascript">
    $(function () {
        var $btnUpload = $('#btnUpload');
        $btnUpload.uploadAccessory({
            isPreView: true,
            accept: {
                title: '图片或者PDF',
                extensions: 'gif,jpg,jpeg,bmp,png,pdf',
                mimeTypes: ''
            },
            acceptErrorMsg: '请上传图片或者PDF'
        });
    })
</script>

</body>
</html>