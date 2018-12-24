<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#ps").val($("#pageSize").val());
            //增加学院下拉框change事件
            $("#collegeId").change(function () {
                var parentId = $(this).val();
                //根据当前学院id 更改
                $("#professionalSelect").empty();
                $("#professionalSelect").append('<option value="">--所有专业--</option>');
                $.ajax({
                    type: "post",
                    url: "/a/sys/office/findProfessionals",
                    data: {"parentId": parentId},
                    async: true,
                    success: function (data) {
                        $.each(data, function (i, val) {
                            if (val.id == "${vo.profession}") {
                                $("#professionalSelect").append('<option selected="selected" value="' + val.id + '">' + val.name + '</option>')
                            } else {
                                $("#professionalSelect").append('<option value="' + val.id + '">' + val.name + '</option>')
                            }

                        })
                    }
                });

            })
            $("#collegeId").trigger('change');
        });
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }
        function selectAll(ob) {
            if ($(ob).attr("checked")) {
                $("input[name='subck']:checkbox").attr("checked", true);
            } else {
                $("input[name='subck']:checkbox").attr("checked", false);
            }
        }
        function resall() {
            var temarr = [];
            $("input[name='subck']:checked").each(function (i, v) {
                temarr.push($(v).attr("data-fid"));
            });
            if (temarr.length == 0) {
                alertx("请选择要发布的项目");
                return;
            }
            confirmx("确定发布所选项目到门户网站？", function () {
                resetTip();
                $.ajax({
                    type: 'post',
                    url: '/a/excellent/resall',
                    dataType: "json",
                    data: {
                        fids: temarr.join(",")
                    },
                    success: function (data) {
                        resetTip();
                        alertx(data.msg, function () {
                            location.href = location;
                        });
                        if (data.ret == "2") {

                        } else {

                        }
                    }
                });
            });
        }
        function unresall() {
            var temarr = [];
            resetTip();
            $("input[name='subck']:checked").each(function (i, v) {
                temarr.push($(v).val());
            });
            if (temarr.length == 0) {
                alertx("请选择要取消发布的项目");
                return;
            }
            confirmx("确定取消发布所选项目？", function () {
                resetTip();
                location.href = "${ctx}/cms/excellent/unrelease?from=projectList&ids=" + temarr.join(",");
            });
        }
        function deleteall() {
            var temarr = [];
            resetTip();
            $("input[name='subck']:checked").each(function (i, v) {
                temarr.push($(v).val());
            });
            if (temarr.length == 0) {
                alertx("请选择要删除的项目");
                return;
            }
            confirmx("确定删除所选项目？", function () {
                resetTip();
                location.href = "${ctx}/cms/excellent/delete?from=projectList&ids=" + temarr.join(",");
            });
        }
        function subckchange(ob) {
            if (!$(ob).attr("checked")) {
                $("#selectAllbtn").attr("checked", false);
            }
        }

        function resetPul(id) {
            resetTip();
            location.href='${ctx}/cms/excellent/unrelease?ids='+id+'&from=projectList'
        }
    </script>
    <style>
        .col-control-group .control-group {
            margin-right: 8px;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>优秀项目</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" modelAttribute="vo" action="${ctx}/cms/excellent/projectList" method="post"
               class="form-horizontal clearfix form-search-block" autocomplete="off">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">项目类型</label>
                <div class="controls">
                    <form:select path="type" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('project_style')}"
                                      itemValue="value" itemLabel="label" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">项目类别</label>
                <div class="controls">
                    <form:select path="subtype" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('project_type')}"
                                      itemValue="value" itemLabel="label" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">项目级别</label>
                <div class="controls">
                    <form:select path="level" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('project_degree')}" itemLabel="label"
                                      itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">学院</label>
                <div class="controls">
                    <form:select path="office" class="input-medium" id="collegeId">
                        <form:option value="" label="--所有学院--"/>
                        <form:options items="${fns:findColleges()}" itemLabel="name" itemValue="id"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">专业</label>
                <div class="controls">
                    <form:select path="profession" class="input-medium"
                                 id="professionalSelect">
                        <form:option value="" label="--所有专业--"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group" style="margin-right: 221px;">
                <label class="control-label">状态分类</label>
                <div class="controls">
                    <select name="state" class="input-medium">
                        <option value="">--请选择--</option>
                        <option value="1"
                                <c:if test="${vo.state=='1' }">selected</c:if> >已发布
                        </option>
                        <option value="0"
                                <c:if test="${vo.state=='0' }">selected</c:if> >待发布
                        </option>
                    </select>
                </div>
            </div>
        </div>

        <div class="search-btn-box">
            <form:input path="name" htmlEscape="false" maxlength="200" class="input-medium"
                        placeholder='项目名称/组成员'/>
            <button class="btn btn-primary" type="submit">查询</button>
        </div>
    </form:form>
    <div class="text-right mgb-20">
        <shiro:hasPermission name="excellent:projectShow:edit">
            <button class="btn btn-primary" id="resallbtn" onclick="resall()" type="button">一键发布</button>
            <button class="btn btn-primary" onclick="unresall()" type="button">取消发布</button>
            <button class="btn btn-primary" onclick="deleteall()" type="button">批量删除</button>
        </shiro:hasPermission>
    </div>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th><input type="checkbox" id="selectAllbtn" onclick="selectAll(this)"></th>
            <th>项目编号</th>
            <th width="30%">项目名称</th>
            <th>项目类型</th>
            <th>负责人</th>
            <th>项目组成员</th>
            <th>项目级别</th>
            <th>项目结果</th>
            <th>状态</th>
            <th width="160">操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="es">
            <tr>
                <td><input type="checkbox" name="subck" onclick="subckchange(this)" data-fid="${es.foreignId}"
                           value="${es.id}"></td>
                <td>${es.number}
                </td>
                <td>${es.name}
                </td>
                <td>${es.typeStr }
                </td>
                <td>${es.leader }
                </td>
                <td>${es.members }
                </td>
                <td>${es.levelStr }
                </td>
                <td>${es.resultStr }
                </td>
                <td>
                        ${es.stateStr}
                </td>
                <td>
                    <shiro:hasPermission name="excellent:projectShow:edit">
                        <c:if test="${es.state=='0' }">
                            <a href="${ctx}/cms/excellent/projectShowForm?projectId=${es.foreignId}"
                               class="btn btn-primary btn-small">审核</a>
                        </c:if>
                        <c:if test="${es.state=='1' }">
                            <a href="javascript:void (0);" onclick="resetPul('${es.id}')"
                               class="btn btn-default btn-small">取消发布</a>
                        </c:if>
                        <a href="${ctx}/cms/excellent/delete?ids=${es.id}&from=projectList"
                           onclick="return confirmx('确认要删除吗？', this.href)" class="btn btn-default btn-small">删除</a>
                    </shiro:hasPermission>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
</body>
</html>