<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>课程详情</title>
    <%@ include file="/WEB-INF/views/include/backtable.jsp" %>
    <link rel="stylesheet" type="text/css" href="/css/credit-module.css?v=1">
    <link rel="stylesheet" type="text/css" href="/static/baguetteBox/css/baguetteBox.min.css">
    <link rel="stylesheet" type="text/css" href="/other/jquery-ui-1.12.1/jquery-ui.css">
    <script src="/other/jquery-ui-1.12.1/jquery-ui.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="/static/baguetteBox/js/baguetteBox.min.js"></script>
    <script type="text/javascript" src="/js/common.js"></script>
    <style type="text/css">
        .credit-apply .nav {
            margin: 0;
        }

        .control-group {
            border-bottom: none;
        }

        label.error {
            display: block;
        }
    </style>
    <style type="text/css">
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
    </style>
    <script type="text/javascript">
        //        function downFile(obj){
        //            var url=$(obj).attr("data-ftp-url");
        //            var fileName=$(obj).attr("data-original")+"."+$(obj).attr('data-type');
        //            location.href=$frontOrAdmin+"/ftp/ueditorUpload/downFile?url="+url+"&fileName="+encodeURI(encodeURI(fileName));
        //        }
        $(function () {
            $('#accessories').on('click', 'a', function (e) {
                e.preventDefault();
                var obj = this;
                var ftpUrl = $(obj).attr("data-ftp-url");
                var fileName = $(obj).attr("data-original") + "." + $(obj).attr('data-type');
                var type = $(obj).attr('data-type');
                var url = $(obj).attr('data-url');
                if (type == 'pdf') {
                    window.open('/a/ftp/pagePdfView?url=' + url + '&fileName=' + encodeURI(fileName) + '&ftpUrl=' + ftpUrl);
                }
            });
            baguetteBox.run('.tz-gallery', {
                filter: /.+\.(gif|jpe?g|png|webp|bmp)/i
            });
        })
    </script>
</head>
<body>

<div class="container-fluid">
    <form action="/a/scoapply/auditForm" id="inputForm" modelAttribute="scoApply">
        <input type="hidden" name="id" id="id" value="${scoApply.id}"/>
        <input type="hidden" name="auditStatus" id="auditStatus"/>
        <div class="edit-bar clearfix">
            <div class="edit-bar-left">
                <span>课程学分认定详情</span>
                <i class="line weight-line"></i>
            </div>
        </div>
        <div class="credit-apply">
            <div class="credit-title-bar">
                <h3 class="title">创新创业课程学分认定详情</h3>
                <span class="time">申请日期：<fmt:formatDate value='${scoApply.applyDate}' pattern='yyyy-MM-dd'/></span>
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
            <ul class="nav nav-cell-box">
                <li>计划课时：${scoCourse.planTime}</li>
                <li>合格成绩：${fns:deleteZero(scoCourse.overScore)}分及以上</li>
                <li>计划学分：${fns:deleteZero(scoCourse.planScore)}</li>
            </ul>
            <div class="credit-title-bar">
                <h4 class="title-sen">已经修读并获得学分</h4>
            </div>
            <ul class="nav nav-cell-box">
                <li>实际学时：${fns:deleteZero(scoApply.realTime)} </li>
                <li>实际成绩：${fns:deleteZero(scoApply.realScore)}分</li>
                <c:if test="${scoApply.auditStatus eq '3' || scoApply.auditStatus eq '4'}">
                    <li>认定学分：${fns:deleteZero(scoApply.score)}</li>
                </c:if>
            </ul>
            <div class="form-horizontal">
                <div class="form-group" style="overflow:hidden;margin-bottom: 10px;">
                    <label class="control-label">申请课程学分认定理由：</label>
                    <div class="col-md-8">
                        <p class="control-static white-space-pre">${scoApply.remarks}</p>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label" style="width: 153px;">附件：</label>
                    <div id="accessories" class="col-md-10" style="padding-left: 0">
                        <ul id="accessoryList" class="file-list file-list-img tz-gallery">
                            <c:forEach items="${scoApply.attachmentList}" var="attachment">
                                <c:if test="${attachment.suffix ne 'pdf'}">
                                    <li class="file-item file-item-img">
                                        <div class="file-info"
                                             style="background: url('${attachment.ftpUrl}') no-repeat center/cover;">
                                            <!--图片-->
                                            <a href="${attachment.ftpUrl}" data-url="${attachment.ftpUrl}"
                                               data-original="${attachment.name}" data-size="${attachment.size}"
                                               data-title="${attachment.name}.${attachment.suffix}"
                                               data-type="${attachment.suffix}"
                                               data-ftp-url="${attachment.url}">
                                                <img src="${attachment.ftpUrl}" style="opacity: 0">
                                                <p class="file-name">${attachment.name}.${attachment.suffix}</p>
                                            </a>
                                                <%--<i class="icon icon-remove-sign"></i>--%>
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
                                                <%--<i class="icon icon-remove-sign"></i>--%>
                                        </div>
                                    </li>
                                </c:if>
                            </c:forEach>
                        </ul>
                        <%--<p class="form-control-static" style="color: #ccc">注：请上传图片或者PDF</p>--%>
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
                        <tr>
                            <th width="120">审核人</th>
                            <th width="180">准予认定学分</th>
                                <%--	<th>审核结果</th>--%>
                            <th>建议及意见</th>
                            <th width="200">审核时间</th>
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
            <div class="credit-title-bar">
                <h4 class="title-sen">审核信息</h4>
            </div>
            <div class="form-horizontal">
                <div class="control-group">
                    <label class="control-label" style="width: 153px;">准予认定学分：</label>
                    <div class="controls">
                        <input type="text" name="score" class="required number form-control maxFs" placeholder=""
                               style="width:60px;"
                        <c:if test="${autoScore!=null&& autoScore!=''}">
                               value="${autoScore}" readonly="readonly"
                        </c:if>
                        <c:if test="${autoScore==null || autoScore==''}">
                               value="0"
                        </c:if>
                        >
                        <label class="warning">自动从课程认定标准中获取</label>
                    </div>
                </div>

                <div class="control-group control-textarea hide">
                    <label class="control-label" style="width: 153px;">
                        <font color="red">*</font>审核建议及意见：</label>
                    <div class="controls">
                        <textarea name="suggest" rows="5" maxlength="300" disabled class="required"></textarea>
                    </div>
                </div>
                <div class="text-center">
                    <button type="button" class="btn-oe btn-primary-oe btn-pass">通过</button>
                    <button type="button" class="btn-oe btn-primary-oe btn-passOut">不通过</button>
                    <button type="button" class="btn btn-cancel-oe" onclick="history.go(-1)">返回</button>
                </div>
            </div>
        </div>
    </form>
</div>
<script type="text/javascript">
    $(function () {
        var $inputForm = $('#inputForm');
        $inputForm.validate({
            rules: {
                suggest: {
                    maxlength: 300
                }
            },
            messages: {
                suggest: {
                    maxlength: "最多输入300个字"
                }
            },
            errorPlacement: function (error, element) {
                if ($(element).is('textarea')) {
                    error.insertAfter(element);
                } else {
                    error.insertAfter(element.next());
                }
            },
            submitHandler: function (form) {
                if (form) {
                    form.submit();
                }
            }
        });

        /*jQuery.validator.addMethod("maxFs", function (value, element) {
         return this.optional(element) || (value >= 0 && value <= 100 && /^[0-9]+([.]{1}[0-9])?$/.test(value.toString()));
         }, "填写正确评分数");*/

        var $controlTextarea = $('.control-textarea');
        var $textArea = $controlTextarea.find('textarea');
        $('.btn-passOut').on('click', function () {
            $controlTextarea.addClass('show').removeClass('hide');
            $textArea.prop('disabled', false);
            $textArea.rules('add', {required: true});
            if ($controlTextarea.is(':visible') && $textArea.val()) {
                subPass(3);
            } else {
                alertx('请完善审核意见');
            }
        });

        $('.btn-pass').on('click', function () {
            $textArea.rules('remove');
//            $controlTextarea.removeClass('show').addClass('hide');
            if ($inputForm.form()) {
                subPass(4);
            }

        });

        function subPass(state) {
            var score = $('.maxFs').val();
            if (score != null && score != "") {
                $("#auditStatus").val(state);
                $("#inputForm").submit();
            } else {
                alertx('请完善该课程评分标准');
            }
        }
    })

</script>

</body>
</html>