<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${backgroundTitle}</title>
    <%@ include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <!--新增-->
    <script type="text/javascript" src="/js/creditSetting.js"></script>
    <style type="text/css">

        .form-period-point-box + div {
            margin-top: 8px;
        }

        .form-period-point .form-period {
            width: 36px;
            margin: 0 4px;
            text-align: center;
        }

        .form-period-point-box .pull-right {
            line-height: 30px;
        }


    </style>
    <script type="text/javascript">
        $(document).on('blur', '.ckNumber,.ckCouse,.ckScore', function (event) {
            $(this).removeClass("my-error-input");
        });
        $(document).on('keypress', '.ckNumber,.ckCouse', function (event) {
            if (event.keyCode != 37 && event.keyCode != 39 && event.which != 8 && (event.which < 48 || event.which > 57)) {
                return false;
            }
        });
        $(document).on('keypress', '.ckScore', function (event) {
            if (event.keyCode != 37 && event.keyCode != 39 && event.which != 8 && event.which != 46 && (event.which < 48 || event.which > 57)) {
                return false;
            }
        });
        var scoreReg = /^(\d{1,2}(\.\d{0,1})?|100|100.0)$/;
        var numReg = /^(([0-9])|([1-9][0-9])|100)$/;
        function checkData() {
            var list = $(".ckNumber,.ckCouse,.ckScore");
            for (var i = 0; i < list.length; i++) {
                var v = list[i];
                if ($(v).val() == "") {
                    alertx("必填信息", function () {
                        $(v).focus();
                        $(v).addClass("my-error-input");
                    });
                    return false;
                }
                if ($(v).hasClass("ckNumber")) {
                    if (!numReg.test($(v).val())) {
                        alertx("分数只能输入0到100整数", function () {
                            $(v).focus();
                            $(v).addClass("my-error-input");
                        });
                        return false;
                    }
                }
                if ($(v).hasClass("ckCouse")) {
                    if (!numReg.test($(v).val())) {
                        alertx("课时只能输入0到100整数", function () {
                            $(v).focus();
                            $(v).addClass("my-error-input");
                        });
                        return false;
                    }
                }
                if ($(v).hasClass("ckScore")) {
                    if (!scoreReg.test($(v).val())) {
                        alertx("学分只能输入0到100的数，可含一位小数", function () {
                            $(v).focus();
                            $(v).addClass("my-error-input");
                        });
                        return false;
                    }
                }
            }
            return true;
        }
        /* jQuery.validator.addMethod("ckScore", function (value, element) {
         return this.optional(element) || scoreReg.test(value);
         }, "学分0到100最多一位小数");
         jQuery.validator.addMethod("ckNumber", function (value, element) {
         return this.optional(element) || numReg.test(value);
         }, "分数0到100整数");
         jQuery.validator.addMethod("ckCouse", function (value, element) {
         return this.optional(element) || numReg.test(value);
         }, "课时0到100整数"); */
        $(document).ready(function () {
            $("#inputForm").validate({
                submitHandler: function (form) {
                    if (!checkData()) {
                        return;
                    }
                    var dataJson = [];
                    $("#dataTb").find("tr").each(function (i, v) {
                        var data = {};
                        var couse = {};
                        couse.start = $(v).find("td").eq(0).find("input").eq(0).val();
                        couse.end = $(v).find("td").eq(0).find("input").eq(1).val();
                        data.couse = couse;
                        var scores = [];
                        var scoresin = $(v).find("td").eq(1).find("input");
                        for (var h = 0; h + 2 < scoresin.length; h = h + 3) {
                            var score = {};
                            score.start = $(scoresin[h]).val();
                            score.end = $(scoresin[h + 1]).val();
                            score.score = $(scoresin[h + 2]).val();
                            scores.push(score);
                        }
                        data.scores = scores;
                        dataJson.push(data);
                    });
                    $("#dataJson").val(JSON.stringify(dataJson));
                    resetTip();
                    form.submit();
                },
                success: function (label) {
                    label.remove();
                },
                errorPlacement: function (error, element) {
                    if (element.parent().parent().find("label.error").not("[style='display: none;']").length == 0) {
                        error.appendTo(element.parent().parent());
                    }
                }
            });

        });
    </script>
</head>
<body>
<div class="container-fluid">
    <div class="edit-bar clearfix">
        <div class="edit-bar-left">
            <span>课程学分认定标准</span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <form:form id="inputForm"
               modelAttribute="scoAffirmCriterionCouse" action="save" method="post">
        <input type="hidden" id="foreignId" name="foreignId" value="${foreignId}"/>
        <input type="hidden" id="fromPage" name="fromPage" value="${scoAffirmCriterionCouse.fromPage}"/>
        <input type="hidden" id="dataJson" name="dataJson"/>
        <div class="table-credit-setting-container">
            <table class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
                <caption>${cname }</caption>
                <thead>
                <tr>
                    <th width="30%"><i style="color: red;margin: 0 8px;">*</i>课时</th>
                    <th width="70%"><i style="color: red;margin: 0 8px;">*</i>成绩及学分标准</th>
                </tr>
                </thead>
                <tbody id="dataTb">
                <c:if test="${empty  map}">
                    <tr>
                        <td>
                            <div class=" form-period-point-box">
                                <div class="pull-right">
                                    <a title="添加课时" class="btn-add-row" href="javascript:void (0)"><img
                                            src="/img/plus2.png"> </a>
                                    <a title="删除课时" class="btn-delete-row hide" href="javascript:void (0)"><img
                                            src="/img/minuse.png"></a>
                                </div>
                                <div class="text-left">
                                    <div class="form-period-point">
                                        <input name="${fns:getUuid() }" type="text" class="form-period ckCouse "
                                               value="">
                                        <span>-</span>
                                        <input name="${fns:getUuid() }" type="text" class="form-period ckCouse "
                                               value="">
                                        <span>课时</span>
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class=" form-period-point-box">
                                <div class="pull-right">
                                    <a title="添加成绩及学分标准" class="add-td" href="javascript:void (0);"><img
                                            src="/img/plus2.png"> </a>
                                    <a title="删除成绩及学分标准" class="hide delete-td" href="javascript:void (0);"><img
                                            src="/img/minuse.png">
                                    </a>
                                </div>
                                <div class="text-left">
                                    <div class="form-period-point">
                                        <input name="${fns:getUuid() }" type="text" class="form-period ckNumber "
                                               value="">
                                        <span>-</span>
                                        <input name="${fns:getUuid() }" type="text" class="form-period ckNumber "
                                               value="">
                                        <span style="margin-right: 15px;">分</span>
                                        <span>认定</span>
                                        <input name="${fns:getUuid() }" type="text" class="form-period ckScore "
                                               value="">
                                        <span>学分</span>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </c:if>
                <c:if test="${not empty  map}">
                    <c:forEach items="${map}" var="item">
                        <tr>
                            <td>
                                <div class=" form-period-point-box">
                                    <div class="pull-right">
                                        <a title="添加课时" class="btn-add-row" href="javascript:void (0)">
                                            <img src="/img/plus2.png">
                                        </a>
                                        <a title="删除课时" class="btn-delete-row hide" href="javascript:void (0)">
                                            <img src="/img/minuse.png">
                                        </a>
                                    </div>
                                    <div class="text-left">
                                        <div class="form-period-point">
                                            <input name="${fns:getUuid() }" type="text"
                                                   class="form-period ckCouse "
                                                   value="${item.value.couse.start }">
                                            <span>-</span>
                                            <input name="${fns:getUuid() }" type="text"
                                                   class="form-period ckCouse " value="${item.value.couse.end }">
                                            <span>课时</span>
                                        </div>
                                    </div>
                                </div>

                            </td>
                            <td>
                                <c:forEach items="${item.value.scores}" var="score">
                                    <div class=" form-period-point-box">
                                        <div class="pull-right">
                                            <a title="添加成绩及学分标准" class="add-td" href="javascript:void (0);"><img
                                                    src="/img/plus2.png">
                                            </a>
                                            <a title="删除成绩及学分标准" class="hide delete-td hide"
                                               href="javascript:void (0);"><img
                                                    src="/img/minuse.png"> </a>
                                        </div>
                                        <div class="text-left">
                                            <div class="form-period-point">
                                                <input name="${fns:getUuid() }" type="text"
                                                       class="form-period ckNumber "
                                                       value="${score.start }">
                                                <span>-</span>
                                                <input name="${fns:getUuid() }" type="text"
                                                       class="form-period ckNumber "
                                                       value="${score.end }">
                                                <span style="margin-right: 15px;">分</span>
                                                <span>认定</span>
                                                <input name="${fns:getUuid() }" type="text"
                                                       class="form-period ckScore"
                                                       value="${score.score }">
                                                <span>学分</span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                </tbody>
            </table>
        </div>
        <div class="text-center">
            <button type="submit" class="btn btn-primary">保存</button>
            <button type="button" class="btn btn-default"
                    onclick="javascript:location.href='${ctx}/sco/${scoAffirmCriterionCouse.fromPage}'">返回
            </button>
        </div>
    </form:form>
</div>
</body>
</html>