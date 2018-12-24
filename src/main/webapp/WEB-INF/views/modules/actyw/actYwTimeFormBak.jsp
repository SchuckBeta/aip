<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/views/include/backtable.jsp" %>
    <script src="/other/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>
    <style>
        .model-module .form-control {
            height: 20px;
            width: 186px;
        }

        .model-module .model {
            margin-bottom: 15px;
        }

        .ui-dialog-buttonset button {
            width: auto;
            height: auto;
        }

        .ui-dialog .ui-dialog-titlebar-close {
            background: none;
        }

        .controls-datetime input[type="radio"], .controls-rate input[type="radio"] {
            margin: 3px 3px;
        }

        .controls-datetime .zhi {
            margin: 0 4px;
        }

        .radio.inline + .radio.inline, .checkbox.inline + .checkbox.inline {
            margin-left: 0;
            padding-left: 10px;
        }

        .controls-rate label.error {
            display: block;
            width: 364px;
            margin: 0 auto;
            text-align: left;
        }

        .control-static {
            line-height: 30px;
            margin-bottom: 0;
        }

        .form-horizontal .control-label {
            padding-top: 5px;
        }

        .checkbox-static {
            margin-right: 20px;
        }

    </style>
</head>
<body>
<div class="mybreadcrumbs">
    <span><c:if test="${not empty actYw.group.flowType}">${fpType.name}</c:if><c:if
            test="${empty actYw.group.flowType}">项目流程</c:if></span>
</div>
<div class="content_panel">
    <ul class="nav nav-tabs">
        <li><a href="${ctx}/actyw/actYw/list?group.flowType=${actYw.group.flowType}">${fpType.name}列表</a></li>
        <li class="active"><a href="${ctx}/actyw/actYw/formGtime?id=${actYw.id}">${fpType.name}
            <shiro:hasPermission
                    name="actyw:actYw:edit">${not empty actYw.id?'修改时间':'添加时间'}</shiro:hasPermission>
            <shiro:lacksPermission
                    name="actyw:actYw:edit">查看</shiro:lacksPermission></a></li>
    </ul>
    <br/>
    <input type="hidden" id="groupId" value="${actYw.groupId}">
    <form:form id="inputForm" modelAttribute="actYw" action="${ctx}/actyw/actYw/ajaxGtime" method="post"
               class="form-horizontal">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>
        <legend><h5>项目属性</h5></legend>
        <div class="control-group">
            <label class="control-label"> 功能类型：</label>
            <div class="controls"><p class="control-static">${fpType.name}</p></div>
        </div>
        <div class="control-group">
            <label class="control-label">名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称：</label>
            <div class="controls">
                <p class="control-static">${actYw.proProject.projectName }</p>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">关联流程：</label>
            <div class="controls"><p class="control-static">${actYwGroup.name}</p></div>
        </div>
        <div class="control-group">
            <label class="control-label"><font color="red">*&nbsp;</font> 开始时间：</label>
            <div class="controls">
                <input id="projectStartDate" name="proProject.startDate" type="text" maxlength="20" readonly
                       class="input-xlarge required" class="input-medium Wdate "
                       value="<fmt:formatDate value="${actYw.proProject.startDate}" pattern="yyyy-MM-dd"/>"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label"><font color="red">*&nbsp;</font> 结束时间：</label>
            <div class="controls">
                <input id="projectEndDate" name="proProject.endDate" type="text" maxlength="20" readonly
                       class="input-xlarge required" class="input-medium Wdate "
                       value="<fmt:formatDate value="${actYw.proProject.endDate}" pattern="yyyy-MM-dd"/>"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">显示时间：</label>
            <div class="controls">
                <form:radiobuttons path="showTime" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" class="required"/>
                <span class="help-inline"></span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">申报时间：</label>
            <div class="controls">
                <form:radiobuttons path="proProject.nodeState"
                                   items="${fns:getDictList('yes_no')}" itemLabel="label"
                                   itemValue="value" htmlEscape="false" class="required"/>
                <span class="help-inline">申报是否加申请时间控制</span>
            </div>
        </div>

        <fieldset id="shDate">
            <legend><h5>审核时间</h5></legend>
            <div class="control-group" style="border:none;">

                <table id="tableDate" class="table table-bordered table-condensed">
                    <thead>
                    <tr style="background-color: #f4e6d4">
                        <td>流程节点</td>
                        <td>有效期</td>
                        <td>通过率（用于限制专家）</td>
                    </tr>
                    </thead>
                    <tbody>


                    <tr class="tr-date tr-shenbao"
                            <c:if test="${ !actYw.proProject.nodeState}">
                                style="display: none"
                            </c:if>>
                        <td>申报</td>
                        <td class="controls-datetime">
                            <input name="proProject.nodeStartDate" type="text" class="Wdate input-medium node-time" readonly
                                   value="<fmt:formatDate value='${actYw.proProject.nodeStartDate}' pattern='yyyy-MM-dd'/>"
                            >
                            <span class="zhi">至</span>
                            <input name="proProject.nodeEndDate" type="text" class="Wdate input-medium node-time" readonly
                                   value="<fmt:formatDate value='${actYw.proProject.nodeEndDate}' pattern='yyyy-MM-dd'/>"
                            >
                            <span style="display: inline-block;width: 95px;"></span>
                            <div class="error-box"></div>
                        </td>
                        <td class="controls-rate">
                            <input type="hidden" class="input-mini">
                            <input type="hidden" class="input-mini">
                            <span style="display: inline-block; width: 95px;"></span>
                        </td>
                    </tr>

                    <c:if test="${actYw.showTime eq '1'}">
                        <c:forEach items="${actYwGtimeList}" var="actYwGtime" varStatus="status">
                            <tr class="tr-date"
                                    <%--<c:if test="${actYwGtimeList==null}">--%>
                                        <%--style="display: none; "--%>
                                    <%--</c:if>--%>
                            >
                                <td><input name="nodeId" type="hidden"
                                           value="${actYwGtime.gnodeId}">${actYwGtime.gnode.name}</td>
                                <td class="controls-datetime">
                                    <input name="beginDate${status.index}" type="text" readonly
                                           class="Wdate input-medium node-time"
                                           value="<fmt:formatDate value='${actYwGtime.beginDate}' pattern='yyyy-MM-dd'/>">
                                    <span class="zhi">至</span>
                                    <input name="endDate${status.index}" type="text" readonly
                                           class="Wdate input-medium node-time"
                                           value="<fmt:formatDate value='${actYwGtime.endDate}' pattern='yyyy-MM-dd'/>">
                                    <label class="radio inline"><input type="radio" name="status${status.index}"
                                    <c:if test="${actYwGtime.status==1}"> checked</c:if> value="1">是 </label>
                                    <label class="radio inline"><input type="radio" name="status${status.index}"
                                    <c:if test="${actYwGtime.status==0}"> checked</c:if> value="0">否 </label>
                                    <div class="error-box"></div>
                                </td>
                                <td class="controls-rate">
                                    <input type="text" name="rate${status.index}" value="${actYwGtime.rate}"
                                           class="form-control input-mini max100"/>
                                    <div class="help-inline"></div>
                                    <label class="radio inline"><input type="radio" name="rateStatus${status.index}"
                                    <c:if test="${actYwGtime.rateStatus eq 1}"> checked</c:if> value="1">是 </label>
                                    <label class="radio inline"> <input type="radio" name="rateStatus${status.index}"
                                    <c:if test="${actYwGtime.rateStatus eq 0}"> checked</c:if> value="0">否 </label>
                                    <div class="error-box"></div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>

                    </tbody>
                </table>
            </div>
        </fieldset>
        <div class="form-actions">
                <%--<c:forEach items="${actYwGtimeList}" var="actYwGtime">--%>
                <%--<input type="hidden" disabled  value="${actYwGtime.beginDate}">--%>
                <%--</c:forEach>--%>
            <shiro:hasPermission name="actyw:actYw:edit">
                <input id="btnSubmit" class="btn btn-primary" type="button" value="保 存"/>&nbsp;</shiro:hasPermission>
            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>

    </form:form>
    <%--<sys:testCut width="220" height="220" btnid="btnUploadAvatar" imgId="proProjectImgUrl" column="proProject.imgUrl"  filepath="menu"  className="modal-avatar"></sys:testCut>--%>
    <input id="projectEndDateX" type="hidden"
           value="<fmt:formatDate value="${actYw.proProject.nodeEndDate}" pattern="yyyy-MM-dd"/>"/>
    <input id="projectStartDateX" type="hidden"
           value="<fmt:formatDate value="${actYw.proProject.nodeStartDate}" pattern="yyyy-MM-dd"/>"/>
</div>


<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>

<script type="text/javascript">

    $(document).ready(function () {
        //$("#name").focus();
        var flowType = {
            xmControl: 13, //双创项目流程
            dasaiControl: 1 //双创大赛流程
        };


        //是否显示时间
        var $proProjectNodeStates = $('input[name="proProject.nodeState"]');
        //时间
        var $nodeTime = $('.node-time');
        var $tableDate = $('#tableDate');
        var $tableDateTrs = $tableDate.find('tr.tr-date');
        var $projectStartDate = $('#projectStartDate');
        var $projectEndDate = $('#projectEndDate');
        var $btnSubmit = $('#btnSubmit');
        var $inputForm = $('#inputForm');
        var inputFormValidate = null;
        var $showTimes = $('input[name="showTime"]');
        var groupId = $('#groupId').val();
        var initTmp = $tableDate.find('tbody').find('tr:not(.tr-shenbao)');
        var $trDateFlow = $tableDate.find('tbody').find('tr:not(".tr-shenbao")');

        var $xdContent = $('#xdContent');
        var $dasaiEle = $('#dasaiEle');
        var $xmEle = $('#xmEle');
        var $controlTypes = $('#controlTypes');
        var $dasaiControl = $('.dasaiControl');
        var $xmControl = $('.xmControl');
        var templates = {};
        var xmDsTemp = {};
        var controlsTypesTemp = {};
        var inputKey;

        if(groupId){
            templates[groupId] = initTmp.size() > 0 ? initTmp : '';
        }


        xmDsTemp['dasaiEle'] = $dasaiEle.html();
        xmDsTemp['xmEle'] = $xmEle.html();
        controlsTypesTemp['dasaiControl'] = $dasaiControl.html();
        controlsTypesTemp['xmControl'] = $xmControl.html();
        $dasaiEle.remove();
        $xmEle.remove();
        $xmControl.remove();
        $dasaiControl.remove();


        $('#groupId').on('change', function (e) {
            var type = $('#groupId option:selected').attr('data-type');
            var currentTypeKey;
            var eleKey;
            var val = $(this).val();

            if ($('input[name="showTime"]:checked').val() != 0 && val) {
                if (templates[val]) {
                    $tableDate.find('tbody').find('tr:not(".tr-shenbao")').remove().end().append(templates[val])
                } else {
                    timeTemplate(val).then(function () {
                        $tableDate.find('tbody').find('tr:not(".tr-shenbao")').remove().end().append(templates[val])
                    })
                }
            }else{
                $tableDate.find('tbody').find('tr:not(".tr-shenbao")').remove();
            }

            for (var k in flowType) {
                if (flowType[k] == type) {
                    currentTypeKey = k;
                }
            }


            if(inputKey && inputKey == currentTypeKey){
                inputKey = currentTypeKey;
                return false;
            }

            $xdContent.empty();
            $controlTypes.empty();
            inputKey = currentTypeKey;
            if(currentTypeKey){
                eleKey = currentTypeKey.replace(/control/i, 'Ele');
                $controlTypes.append(controlsTypesTemp[currentTypeKey.replace(/control/i, 'Control')]);
                $xdContent.append(xmDsTemp[eleKey]);
            }
        }).change();



        $btnSubmit.on('click', function () {
            var xhr;
            if (inputFormValidate.form()) {
                loading('正在保存...');
                xhr = $.post('${ctx}/actyw/actYw/ajaxGtime', $inputForm.formSerialize());
                xhr.success(function (data) {
                    if (data.status) {
                        showTip('保存成功', 'success', 300)
                    } else {
                        showTip('保存失败', 'fail', 300)
                    }
                    closeLoading();
                })
                xhr.error(function (error) {
                    closeLoading();
                })
            }
            return false;
        });

        $proProjectNodeStates.on('change', function (e) {
            //申报是否显示
            var $trShenbao = $('.tr-shenbao');
            var val = $(this).val();
            if (val == 1) {
                $trShenbao.css('display', '').find('input').prop('disabled', false)
            } else {
                $trShenbao.css('display', 'none').find('input').prop('disabled', true)
            }
        });


        $projectStartDate.on('click', function (e) {
            var endTime = $projectEndDate.val();
            var wDateOption = {
                el: this,
                dateFmt: 'yyyy-MM-dd',
                isShowClear: true,
                onpicked: function(){
                }
            };
            if (endTime) {
                wDateOption['maxDate'] = endTime
            }
            WdatePicker(wDateOption);
        });
        $projectEndDate.on('click', function (e) {
            var startTime = $projectStartDate.val();
            var $this = $(this);
            var wDateOption = {
                el: this,
                dateFmt: 'yyyy-MM-dd',
                isShowClear: true,
                onpicked: function () {
                    var time = $this.val();
                    var isMax = true;
                    var noMaxIndex;
                    var maxTime = new Date(time).getTime();
                    $nodeTime = $('.node-time');
                    $nodeTime.each(function (i, input) {
                        var $input = $(input);
                        var val = $input.val();
                        var nodeTime;
                        if (val) {
                            nodeTime = new Date(val).getTime();
                            if (nodeTime > maxTime) {
                                isMax = false;
                                noMaxIndex = i;
                                return false;
                            }
                        }
                    });
                    if (!isMax) {
                        $nodeTime = $('.node-time');
                        var $leftNode = $nodeTime.slice(noMaxIndex);
                        $leftNode.val('');
                        $leftNode.parent().attr({
                            'data-end-date': '',
                            'data-next-start-date': ''
                        })
                    }
                }
            };
            if (startTime) {
                var ms = new Date(startTime).getTime();
                ms += (24 * 60 * 60 * 1000);
                var wStartTime = new Date(ms);
                wDateOption['minDate'] = (wStartTime.getFullYear()+'-'+(wStartTime.getMonth()+1)+'-'+wStartTime.getDate())
            }
            WdatePicker(wDateOption);
        });

        $tableDate.on('click', 'input.node-time', function (e) {
            $nodeTime = $('.node-time');
            $tableDateTrs = $tableDate.find('tr.tr-date');
            var index = $nodeTime.index($(this));
            var $this = $(this);
            var time;
            var $parentTd = $(this).parent();
            var $parentTr = $parentTd.parent();
            var parentTrIndex = $tableDateTrs.index($parentTr);
            var minDate;
            var isStartInput = index % 2 === 0;
            var pickerOption = {
                el: this,
                dateFmt: 'yyyy-MM-dd',
                isShowClear: true,
                onpicked: function () {
                    time = $this.val();

                    if (time) {
                        var nextTime;
                        if(isStartInput){
                            nextTime = $(this).next().next().val()
                        }else{
                            nextTime = $parentTr.next().find('.controls-datetime input[type="text"]').eq(1).val();
                        }
                        if (nextTime) {
                            nextTime = new Date(nextTime).getTime();
                            if (nextTime < new Date(time).getTime()) {
                                $(this).next().next().val('');
                                $parentTr.nextAll().find('.node-time').val('');
                            }
                        }
                    }
                }
            };
            var $prevNodeTime;

            if (parentTrIndex > 0) {
                if(isStartInput){
                    $prevNodeTime = $parentTr.prev().find('.node-time').eq(1)
                }else{
                    $prevNodeTime = $(this).prev().prev()
                }
                minDate = $prevNodeTime.val()
            } else {
                if(isStartInput){
                    minDate = $projectStartDate.val()
                }else {
                    minDate = $(this).prev().prev().val()
                }
            }

            if(minDate){
                if(minDate != $(this).val()){
                    var ms = new Date(minDate).getTime();
                    ms += (24 * 60 * 60 * 1000);
                    var wStartTime = new Date(ms);
                    pickerOption['minDate'] = (wStartTime.getFullYear()+'-'+(wStartTime.getMonth()+1)+'-'+wStartTime.getDate())
                }else {
                    pickerOption['minDate'] = minDate;
                }
            }


            pickerOption['maxDate'] = $projectEndDate.val() || '';

            WdatePicker(pickerOption);
        });

        $showTimes.on('change', function (e, isFirst) {
            $('#groupId').trigger('change')
        });


        inputFormValidate = $inputForm.validate({
            submitHandler: function (form) {
                loading('正在提交，请稍等...');
                form.submit();
            },
            errorContainer: "#messageBox",
            errorPlacement: function (error, element) {
                $("#messageBox").text("输入有误，请先更正。");
                var $elementParent = element.parent();
                if (element.parent().hasClass('controls-rate')) {
                    error.appendTo(element.parent())
                } else if ($elementParent.hasClass('controls-datetime')) {
                    $elementParent.find('.error-box').append(error);
                } else {
                    error.insertAfter(element);
                }
            }
        });

        $(document).on('change', '.controls-datetime input[type="radio"]', function (e) {
            var inputs = $(this).parent().prevAll('input[type="text"]');
            if ($(this).val() == 1) {
                inputs.each(function (i, item) {
                    $(item).rules('add', {required: true})
                })
            } else {
                inputs.each(function (i, item) {
                    $(item).rules('remove', 'required')
                })
            }
        });

        $('.controls-datetime input[type="radio"]:checked').trigger('change');

        jQuery.validator.addMethod("max100", function (value, element) {
            return this.optional(element) || value <= 100;
        }, "只能输入不大于100数值");

        function timeTemplate(id) {
            var trs = '';
            var xhr = $.get('changeModel', {id: id});
            xhr.success(function (data) {
                $.each(data, function (i, item) {
                    trs += '<tr class="tr-date"><td>' + item.name + '<input name="nodeId" type="hidden" value="' + item.id + '"></td><td class="controls-datetime">' +
                            '<input name="beginDate'+(i)+'" type="text" class="Wdate input-medium node-time" readonly value="">' +
                            ' <span class="zhi">至</span> ' +
                            '<input name="endDate'+(i)+'" type="text" readonly class="Wdate input-medium node-time">' +
                            '<label class="radio inline"><input type="radio" name="status' + i + '" value="1">是 </label> <label class="radio inline"> <input type="radio" name="status' + i + '" value="0" checked>否 </label><div class="error-box"></div> </td>' +
                            '<td class="controls-rate"><input type="text" name="rate' + i + '" value="100" class="form-control input-mini max100"/><div class="help-inline">（<span class="red">默认为空，不限制</span>）</div>' +
                            '<label class="radio inline"><input type="radio" name="rateStatus' + (i) + '" checked value="1">是 </label> <label class="radio inline"> <input type="radio" name="rateStatus' + (i) + '" value="0">否 </label><div class="error-box"></div> </td>' +
                            '</td></tr>'
                });
                templates[id] = trs;
            });
            xhr.error(function (error) {
                showModalMessage(0, res);
            });
            return xhr;
        }

        //递归查找前一个
        function dgLastInput(ele) {
            var $ele = $(ele);
            var index = $nodeTime.index($ele);
            var val = $ele.val();
            if (val && val != '') {
                return val;
            } else {
                $ele = $nodeTime.eq(index - 1);
                return dgLastInput($ele);
            }
        }

    });

</script>
</body>
</html>