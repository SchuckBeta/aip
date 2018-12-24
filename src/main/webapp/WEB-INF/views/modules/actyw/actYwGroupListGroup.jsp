<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroudTitle}</title>
    <%--<%@include file="/WEB-INF/views/include/backCommon.jsp" %>--%>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript" src="/js/backTable/sort.js"></script><!--排序js-->
    <style>
        .modal{
            width:660px;
            margin-left:-330px;
        }
        .time-horizontal {
            list-style-type: none;
            max-width: 618px;
            overflow: hidden;
            padding-top: 35px;
            margin:0 0 20px 18px;
        }

        .time-horizontal li {
            float: left;
            position: relative;
            text-align: center;
            width: 16%;
        }

        .time-horizontal li b {
            color: #9E9E9E;
            position: absolute;
            top: 6px;
            left: 38%;
            width: 20px;
            height: 20px;
            border: 2px solid #F4E6D4;
            border-radius: 50%;
            background: #F4E6D4;
        }

        .step-line:after {
            content: "";
            background: #9E9E9E;
            height: 1px;
            position: absolute;
            top: 50%;
            width: 90px;
            left: 21px;
        }

        .time-horizontal span {
            color: rgb(255, 255, 255);
            text-align: center;
            background: #E9432D;
            padding: 4px 0px;
            text-decoration: none;
            border-radius: 4px;
            font-size: 12px;
            display: block;
            position: relative;
            margin: 44px auto 0;
            width: 80px;
        }

        .container .time-horizontal span:after {
            content: "";
            left: 50%;
            margin-left: -5px;
            border-bottom-color: #E9432D;
            border-width: 0 5px 5px;
            position: absolute;
            top: -5px;
            width: 0;
            height: 0;
            border-style: solid;
        }

        .time-horizontal span:after {
            border-color: transparent;
        }

        input[type="radio"], input[type="checkbox"] {
            margin: -2px 4px 0 0;
        }

        .flow-li3 {
            border: 2px solid #E4E4E4;
            border-bottom: none;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            width: 196px;
            height: 20px;
            margin: 0 48px;
            position: relative;
            float: left;
            text-align: center;
        }

        .flow-li3 label {
            margin-top: -35px;
            font-size: 14px;
        }

        .flow-li2 {
            float: right;
            border: 2px solid #E4E4E4;
            border-bottom: none;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            width: 97px;
            height: 20px;
            margin-right: 49px;
            position: relative;
            text-align: center;
        }

        .flow-li2 label {
            margin: -35px 0 0 -17px;
            font-size: 14px;
            width: 130px;
        }

        .flow-li3:after {
            content: '';
            height: 2px;
            background: #E4E4E4;
            width: 25px;
            position: absolute;
            top: 6px;
            left: 85px;
            transform: rotate(90deg);
        }

        .unknown-help {
            width: 20px;
            position: absolute;
            top: 26px;
            right: 20px;
            background: white;
        }

        .unknown-help:hover {
            cursor: pointer;
        }


    </style>
</head>


<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>自定义流程</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>

    <form:form id="searchForm" modelAttribute="actYwGroup" action="${ctx}/actyw/actYwGroup/" method="post"
               class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <input type="hidden" id="orderBy" name="orderBy" value="${page.orderBy}"/>
        <input type="hidden" id="orderByType" name="orderByType" value="${page.orderByType}"/>

        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">流程名称</label>
                <div class="controls">
                    <form:input path="name" htmlEscape="false" maxlength="50" class="input-medium"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">发布状态</label>
                <div class="controls">
                    <form:select path="status" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">表单组</label>
                <div class="controls">
                    <form:select id="theme" path="theme" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${formThemes}" itemLabel="name" itemValue="idx" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">流程类型</label>
                <div class="controls">
                    <form:select id="flowType" path="flowType" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${flowTypes}" itemLabel="name" itemValue="key" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group" style="margin-right: 120px;">
                <label class="control-label">项目类型</label>
                <div class="controls">
                    <form:select path="type" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('act_project_type')}" itemLabel="label"
                                      itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <button type="submit" class="btn btn-primary">查询</button>
            <a class="btn btn-primary" href="${ctx}/actyw/actYwGroup/form?secondName=添加">添加</a>
        </div>

    </form:form>
    <sys:message content="${message}"/>
    <table id="flowGroupListTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-sort table-nowrap table-subscribe">
        <thead>
        <tr id="contentTable">
            <th data-name="a.theme"><a class="btn-sort" href="javascript:void(0);">表单组<i class="icon-sort"></i></a></th>
            <th data-name="a.name"><a class="btn-sort" href="javascript:void(0);">流程名称<i class="icon-sort"></i></a></th>
            <th data-name="a.flow_type"><a class="btn-sort" href="javascript:void(0);">流程/表单类型<i class="icon-sort"></i></a></th>
            <th>关联项目类型</th>
            <th data-name="a.status"><a class="btn-sort" href="javascript:void(0);">发布状态<i class="icon-sort"></i></a></th>
            <th data-name="a.temp"><a class="btn-sort" href="javascript:void(0);">临时数据<i class="icon-sort"></i></a></th>
            <th width="10%">备注</th>
            <th width="120" data-name="a.update_date"><a class="btn-sort" href="javascript:void(0);">最后更新时间<i class="icon-sort"></i></a></th>
            <shiro:hasPermission name="actyw:actYwGroup:edit">
                <th width="270">操作</th>
            </shiro:hasPermission>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="actYwGroup">
            <tr>
                <td>
                    <%--<a href="${ctx}/actyw/actYwGroup/form?id=${actYwGroup.id}">--%>
                        <c:set var="hasName" value="false"/>
                        <c:forEach var="item" items="${formThemes}">
                            <c:if test="${actYwGroup.theme eq item.idx}">
                                <c:if test="${not empty item.name}">${item.name}<c:set var="hasName"
                                                                                       value="true"/></c:if>
                            </c:if>
                        </c:forEach>
                        <c:if test="${!hasName}">-</c:if>
                    <%--</a>--%>
                </td>
                <td title="${actYwGroup.keyss}">
                    <a href="${ctx}/actyw/actYwGnode/${actYwGroup.id}/view">
                            ${actYwGroup.name}
                        <c:if test="${not empty actYwGroup.flowId}">
                            <a href="${ctx}/act/process/resource/read?procDefId=${actYwGroup.flowId}&resType=xml"
                               target="_blank"><i class="icon-eye-open" title="Xml"/></a>
                            <a href="${ctx}/act/process/resource/read?procDefId=${actYwGroup.flowId}&resType=image"
                               target="_blank"><i class="icon-picture" title="Image"/></a>
                        </c:if>
                    </a>
                </td>
                    <%-- <td>${fns:getDictLabel(actYwGroup.flowType, 'act_category', '')}</td> --%>
                <td>
                    <c:forEach var="item" items="${flowTypes}">
                        <c:if test="${actYwGroup.flowType eq item.key}">${item.name }</c:if>
                    </c:forEach>
                </td>
                <td>
                    <c:forEach var="item" items="${actYwGroup.types}" varStatus="idx">
                        ${fns:getDictLabel(item, 'act_project_type', '')}
                        <c:if test="${(idx.index + 1) ne fn:length(actYwGroup.types)}">/</c:if>
                    </c:forEach>
                </td>
                <td>${fns:getDictLabel(actYwGroup.status, 'yes_no', '')}</td>
                <td>${fns:getDictLabel(actYwGroup.temp, 'true_false', '')}</td>
                <td>${fns:abbr(actYwGroup.remarks, 60)}</td>
                <td><fmt:formatDate value="${actYwGroup.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                <shiro:hasPermission name="actyw:actYwGroup:edit">
                    <td>
                        <input type="hidden" class="group-id" value="${actYwGroup.id}">
                        <input type="hidden" class="flowType" value="${actYwGroup.flowType}">
                        <a class="btn btn-small btn-primary"
                           href="${ctx}/actyw/actYwGroup/form?id=${actYwGroup.id}&secondName=添加">修改</a>
                        <c:if test="${actYwGroup.status eq '0'}">
                            <a class="btn btn-small btn-primary"
                               href="${ctx}/actyw/actYwGnode/designNew?group.id=${actYwGroup.id}&groupId=${actYwGroup.id}">设计</a>
                            <a class="btn btn-small btn-primary btn-release"
                               href="${ctx}/actyw/actYwGroup/ajaxRelease?id=${actYwGroup.id}&status=1&isUpdateYw=true">发布</a>
                            <c:if test="${actYwGroup.ywsize le 1}">
                                <a href="${ctx}/actyw/actYwGroup/delete?id=${actYwGroup.id}"
                                   onclick="return confirmx('确认要删除该自定义流程吗？', this.href)"
                                   class="btn btn-small btn-default">删除</a>
                            </c:if>
                        </c:if>
                        <c:if test="${actYwGroup.status eq '1'}">
                            <a class="btn btn-small btn-default"
                               href="${ctx}/actyw/actYwGroup/ajaxDeploy?id=${actYwGroup.id}&status=0&isUpdateYw=true"
                               onclick="return confirmx('确认要取消发布方案[${actYwGroup.name}]吗？', this.href)">取消发布</a>
                        </c:if>
                    </td>
                </shiro:hasPermission>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>

<div id="dialogCyjd" class="dialog-cyjd"></div>

<div class="tip-defined_flow" style="height:auto;padding: 5px 5px;right: 0;margin-top: -78px; width: 20px; text-align: center">
    <a href="javascript: void(0);" class="handler" style="font-size: 12px; line-height: 18px; width: auto"  data-toggle="modal" data-target="#myModal">自定义流程指南</a>
    <a href="javascript: void(0);" style="display: none;">查看流程设计步骤</a>
    <%--<img class="unknown-help" src="/images/unknown.png" alt="">--%>
</div>


<div class="modal hide" data-backdrop="static" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">温馨提示</h4>
    </div>
    <div class="modal-body">
        <div class="container" style="width:643px;padding:50px 0">
            <ul class="time-horizontal">
                <div>
                    <div class="flow-li3"><label>自定义流程</label></div>
                    <div class="flow-li3"><label>自定义项目或大赛</label></div>
                </div>
                <li><b class="step-line">1</b><span>添加流程</span></li>
                <li><b class="step-line">2</b><span>设计流程</span></li>
                <li><b class="step-line">3</b><span>发布流程</span></li>
                <li><b class="step-line">4</b><span>添加项目</span></li>
                <li><b class="step-line">5</b><span>设置编号</span></li>
                <li><b>6</b><span>发布项目</span></li>
            </ul>
        </div>
    </div>
    <div class="modal-footer">
        <label style="margin: 0; display: inline-block;">
            <input type="checkbox" class="no-advice"><span style="margin-right: 5px;">不再提醒</span>
        </label>
        <%--<button type="button" class="btn btn-default close-advice" data-dismiss="modal">关闭</button>--%>
    </div>
</div>
<script src="/js/jquery.cookie.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $("#ps").val($("#pageSize").val());
        var $flowGroupListTable = $('#flowGroupListTable');


        $flowGroupListTable.on('click.release', '.btn-release', function (e) {
            e.stopPropagation();
            var url = $(this).attr('href');
            var groupId = $(this).parent().find('input[type="hidden"].group-id').val();
            var flowType = $(this).parent().find('input[type="hidden"].flowType').val();
            confirmx('流程发布后，将会允许被应用到项目。流程一旦被使用，有项目申报，就无法再修改流程，确认发布此流程吗？', function () {
                $.ajax({
                    type: 'GET',
                    url: url,
                    dataType: 'JSON',
                    success: function (data) {
                        if (data.status) {
                            confirmx(data.msg + '，请去自定义项目或者自定义大赛页面，添加项目', function () {
//                                http://localhost:8080/a/actyw/actYw/form?group.flowType=1.
                                window.parent.sideNavModule.changeLink('${ctx}/actyw/actYw/list?group.flowType=' + flowType);
                                location.href = '${ctx}/actyw/actYw/form?group.flowType=' + flowType + '&groupId=' + groupId;
                            }, function () {
                                location.href = location.href;
                            })
                        } else {
                            showTip(data.msg, 'fail');
                        }
                    },
                    error: function (error) {
                        showTip('网络连接失败，错误代码' + error.code + '，请重试', 'fail');
                    }
                })
            })
            return false;
        })
    });
    function page(n, s) {
        $("#pageNo").val(n);
        $("#pageSize").val(s);
        $("#searchForm").submit();
        return false;
    }

    $(function () {
        var $btnCloseAdvice = $('#myModal .close')
        var $noAdvice = $('#myModal .no-advice')
//        var expires;
        showStepModal();
        function showStepModal() {
            var isShowStepModal = $.cookie('isShowStepModal');
            var isShowOnce = $.cookie('isShowOnce');
            if (isShowStepModal) {
                $noAdvice.prop('checked', true)
            }
            if (isShowOnce || isShowStepModal) {
                return false;
            }
            $('#myModal').modal('show')
            $.cookie('isShowStepModal', 'noMore', {
                expires: 100
            })
        }

        $btnCloseAdvice.on('click', function () {
            if ($noAdvice.prop('checked')) {
                $.cookie('isShowStepModal', 'noMore', {
                    expires: 100
                })
            } else {
                $.removeCookie('isShowStepModal')
            }
            $.cookie('isShowOnce', 'one', {
                expires: 100,
                path: '/'
            })
        })


        var tipDefinedFlow = {
            $tipDefined_flow: $('.tip-defined_flow'),
            tfTop: '',
            tfLeft: '',
            tfWidth: '',
            tfQusWidth: '',
            init: function () {
                this.setTfTop();
                this.resetTfMarginTop();
                this.drag()
            },
            getTfTop: function () {
                return this.$tipDefined_flow.offset().top;
            },
            getTfWidth: function () {
                return this.$tipDefined_flow.width()
            },
            getTfQusWidth: function () {
                return this.$tipDefined_flow.find('.handler').width();
            },
            getTfLeft: function () {
                return this.$tipDefined_flow.offset().left;
            },

            setTfTop: function () {
                this.tfTop = this.getTfTop();
                this.$tipDefined_flow.css('top', this.tfTop);
            },
            setTfLeft: function () {
                this.tfLeft = this.getTfLeft();
                this.$tipDefined_flow.css('left', this.tfLeft);
            },
            resetTfMarginTop: function () {
                this.$tipDefined_flow.css('marginTop', 'auto');
            },
            resetTfLeft: function () {
                this.$tipDefined_flow.css('right', 'auto');
            },
            drag: function () {
                var tfLeft = this.tfLeft;
                this.$tipDefined_flow.draggable({
                    drag: function (event, ui) {
                        ui.position.left = tfLeft;
                    }
                });
            },
            hover: function () {
                var self = this;
                this.$tipDefined_flow.hover(function () {

                }, function () {

                })
            }


        }
//        tipDefinedFlow.init();


    })


</script>
</body>
</html>