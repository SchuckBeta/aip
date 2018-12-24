<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript">
        $(document).ready(function () {
            //增加学院下拉框change事件
            $("#collegeId").change(function () {
                var parentId = $(this).val();
                //根据当前学院id 更改
                $("#professionalSelect").empty();
                $("#professionalSelect").append('<option value="">所有专业</option>');
                $.ajax({
                    type: "post",
                    url: "/a/sys/office/findProfessionals",
                    data: {"parentId": parentId},
                    async: true,
                    success: function (data) {
                        $.each(data, function (i, val) {
                            if (val.id == "${scoCourseVo.user.professional}") {
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
        //查看详情

        $(function () {
            $("#ps").val($("#pageSize").val());
        })

        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchCreateForm").submit();
        }
    </script>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>创新学分认定</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form id="searchCreateForm" class="form-horizontal clearfix form-search-block" modelAttribute="scoProjectVo"
          action="${ctx}/sco/scoreGrade/createList">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">时间</label>
                <div class="controls">
                    <input type="text" class="input-medium Wdate" name="beginDate" id="beginDate"
                           onClick="WdatePicker({maxDate:'#F{$dp.$D(\'endDate\')}'})"
                           readonly
                           value='<fmt:formatDate value="${scoProjectVo.beginDate}" pattern="yyyy-MM-dd"/>'/>至<input
                        type="text" class="input-medium Wdate" name="endDate" id="endDate"
                        onClick="WdatePicker({minDate:'#F{$dp.$D(\'beginDate\')}'})"
                        readonly
                        value='<fmt:formatDate value="${scoProjectVo.endDate}" pattern="yyyy-MM-dd"/>'/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">所属学院</label>
                <div class="controls">
                    <form:select path="scoProjectVo.office.id" class="input-medium" id="collegeId">
                        <form:option value="" label="所有学院"/>
                        <form:options items="${fns:findColleges()}" itemLabel="name" itemValue="id"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">所属专业</label>
                <div class="controls">
                    <form:select path="scoProjectVo.user.professional" class="input-medium"
                                 id="professionalSelect">
                        <form:option value="" label="所有专业"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">项目编号</label>
                <div class="controls">
                    <form:input type="text" cssClass="input-medium" path="scoProjectVo.projectDeclare.number"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">项目类型</label>
                <div class="controls">
                    <form:select id="type" path="scoProjectVo.pType" class="input-medium">
                        <form:option value="" label="请选择"/>
                        <form:options items="${fns:getDictList('project_style')}" itemLabel="label"
                                      itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group" style="margin-right: 230px;">
                <label class="control-label">项目结果</label>
                <div class="controls">
                    <form:select id="type" path="scoProjectVo.projectDeclare.finalResult" class="input-medium">
                        <form:option value="" label="请选择"/>
                        <form:options items="${fns:getDictList('project_result')}" itemLabel="label"
                                      itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <form:input type="text" path="scoProjectVo.keyWord" cssClass="input-medium" placeholder="项目组成员/项目名称"/>
            <button type="submit" class="btn btn-primary">查询</button>
        </div>
    </form>
    <table class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap table-sort">
        <thead>
        <tr>
            <th>项目编号</th>
            <th width="25%">项目名称</th>
            <th>负责人</th>
            <th>组成员</th>
            <th>项目类型</th>
            <th>项目类别</th>
            <th>项目级别</th>
            <th>项目结果</th>
            <th>计划学分</th>
            <th>认定学分</th>
            <th>学分配比</th>
            <%--<th>操作</th>--%>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="scoProjectVo">
            <tr>
                <td>${scoProjectVo.projectDeclare.number}</td>
                <td><a href="${ctx}/sco/scoreGrade/createView?id=${scoProjectVo.scoAffirm.id}">${scoProjectVo.projectDeclare.name}</a></td>
                <td>${fns:getUserById(scoProjectVo.projectDeclare.leader).name}</td>
                <td>${scoProjectVo.teamUsers}</td>
                <td>${fns:getDictLabel(scoProjectVo.pType,"project_style" , "")}</td>
                <td>${scoProjectVo.projectDeclare.typeString}</td>
                <td>${scoProjectVo.projectDeclare.levelString}</td>
                <td>${scoProjectVo.projectDeclare.finalResultString}</td>
                <td>${fns:deleteZero(scoProjectVo.scoAffirm.scoreStandard)}</td>
                <td>
                        ${fns:deleteZero(scoProjectVo.score)}
                </td>
                <td> ${scoProjectVo.ratioResult}</td>
                <%--<td>--%>
                    <%--<a class="btn-oe btn-primary-oe btn-sm-oe" href="javascript:void (0)"--%>
                       <%--onclick="view('')">查看</a>--%>
                <%--</td>--%>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>

</body>
</html>