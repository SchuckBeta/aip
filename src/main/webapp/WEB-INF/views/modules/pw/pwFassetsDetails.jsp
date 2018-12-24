<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script src="/other/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#inputForm").validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        switch (element[0].id) {
                            case "category1":
                            case "category2":
                                error.appendTo(element[0].offsetParent);
                                break;
                            case "price":
                                error.appendTo(element[0].offsetParent);
                                break;
                            default:
                                error.insertAfter(element);
                                return false;
                        }
                    }
                }
            });
            // 前缀字母验证
            jQuery.validator.addMethod("isLetter", function (value, element) {
                var reg = /^[a-z,0-9]+$/i;
                return this.optional(element) || (reg.test(value));
            }, "只能输入数字或者字母");



        });
    </script>
    <style>
        .modal-backdrop, .modal-backdrop.fade.in{
            opacity: 0;
            z-index: -1;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="edit-bar clearfix">
        <div class="edit-bar-left">
            <span>固定资产</span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <div class="content_panel">
        <ul class="nav nav-tabs">
            <li><a href="${ctx}/pw/pwFassets/">固定资产列表</a></li>
            <li class="active"><a href="${ctx}/pw/pwFassets/form?id=${pwFassets.id}">固定资产查看</a></li>
        </ul>
        <sys:message content="${message}"/>
        <form:form id="inputForm" modelAttribute="pwFassets" action="${ctx}/pw/pwFassets/save" method="post"
                   class="form-horizontal">
            <form:hidden path="id"/>

            <form:hidden path="isNewRecord" value="${isNewRecord}"/>


            <div class="control-group">
                <label class="control-label">资产类别：</label>
                <div class="controls">
                    <p class="control-static">${pwFassets.pwCategory.parent.name}</p>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">资产名称：</label>
                <div class="controls">
                     <p class="control-static">${pwFassets.pwCategory.name}</p>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">品牌：</label>
                <div class="controls">
                    <p class="control-static">${pwFassets.brand}</p>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">规格：</label>
                <div class="controls">
                    <p class="control-static">${pwFassets.specification}</p>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">购买人：</label>
                <div class="controls">
                    <p class="control-static">${pwFassets.prname}</p>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">手机号码：</label>
                <div class="controls">
                    <p class="control-static">${pwFassets.phone}</p>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">购买时间：</label>
                <div class="controls">
                    <p class="control-static"><fmt:formatDate value="${pwFassets.time}" pattern="yyyy-MM-dd"/></p>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">价格：</label>
                <div class="controls">
                    <p class="control-static">${pwFassets.price}元（人民币）</p>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注：</label>
                <div class="controls">
                    <p class="control-static">${pwFassets.remarks}</p>
                </div>
            </div>
            <div class="form-actions">
                <input class="btn btn-default" type="button" value="返 回" onclick="history.go(-1)"/>
            </div>
        </form:form>

    </div>
</div>



<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>

</body>
</html>