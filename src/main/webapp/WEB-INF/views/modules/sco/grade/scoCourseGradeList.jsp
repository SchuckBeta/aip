<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>

    <script type="text/javascript">
        $(document).ready(function () {
            window.parent.sideNavModule.changeStaticUnreadTag("/a/scoapply/getCountToAudit");
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


        $(function () {
            $("#ps").val($("#pageSize").val());
        })

        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchCourseForm").submit();
        }
        
        $(function () {

            var url="/a/scoapply/ajaxAuditForm";
            var pageList = JSON.parse('${fns: toJson(page.list)}') || [];

            var $batchPass = $('#btnSubmit1');
            $batchPass.click(function () {
                confirmx('确定批量审核通过吗？',function () {
                    batchPass(url);
                })
            })
        })
        
    </script>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>课程学分认定</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
<%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form id="searchCourseForm" modelAttribute="scoCourseVo" action="/a/sco/scoreGrade/courseList"
          class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">学号</label>
                <div class="controls">
                    <form:input type="text" class="input-medium" path="scoCourseVo.user.no"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">所属学院</label>
                <div class="controls">
                    <form:select path="scoCourseVo.office.id" class="input-medium" id="collegeId">
                        <form:option value="" label="所有学院"/>
                        <form:options items="${fns:findColleges()}" itemLabel="name" itemValue="id"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">所属专业</label>
                <div class="controls">
                    <form:select path="scoCourseVo.user.professional" class="input-medium"
                                 id="professionalSelect">
                        <form:option value="" label="所有专业"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">课程代码</label>
                <div class="controls">
                    <form:input type="text" class="input-medium" path="scoCourseVo.scoCourse.code"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">课程类型</label>
                <div class="controls">
                    <form:select id="type" path="scoCourseVo.scoCourse.type" class="input-medium">
                        <form:option value="" label="请选择"/>
                        <form:options items="${fns:getDictList('0000000102')}" itemLabel="label"
                                      itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group" style="margin-right: 400px;">
                <label class="control-label">审核状态</label>
                <div class="controls">
                    <form:select path="scoCourseVo.scoApply.auditStatus" class="input-medium">
                        <form:option value="" label="请选择"/>
                        <form:option value="1" label="待提交认定"/>
                        <form:option value="2" label="待审核"/>
                        <form:option value="3" label="未通过"/>
                        <form:option value="4" label="通过"/>
                    </form:select>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <form:input type="text" cssClass="input-medium" path="scoCourseVo.keyWord" placeholder="关键字"/>
            <button type="submit" class="btn btn-primary">查询</button>
            <button type="button" id="btnSubmit1" class="btn btn-primary">批量通过</button>
        </div>
    </form>
    <sys:message content="${message}"/>
    <table class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap table-sort">
        <thead>
        <tr>
            <th><input type="checkbox" id="check_all" data-flag="false"></th>
            <th>学号</th>
            <th>姓名</th>
            <th>课程代码</th>
            <th>课程名</th>
            <th>课程性质</th>
            <th>课程类型</th>
            <th>完成课时</th>
            <th>成绩</th>
            <th>计划学分</th>
            <th>认定学分</th>
            <%--  <th>课程状态</th>--%>
            <th>审核状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="scoCourseVo">
            <tr>
                <td class="checkone"><input type="checkbox" value="${scoCourseVo.scoApply.id}" name="boxTd"></td>
                <td>${scoCourseVo.user.no}</td>
                <td>${scoCourseVo.user.name}</td>
                <td>${scoCourseVo.scoCourse.code}</td>
                <td width="20%"><a
                        href="/a/scoapply/view?id=${scoCourseVo.scoApply.id}">${scoCourseVo.scoCourse.name}</a></td>
                    <%--<td>${scoCourseVo.scoCourse.nature}</td>
                    <td>${scoCourseVo.scoCourse.type}</td>
                    --%>
                <td>${fns:getDictLabel(scoCourseVo.scoCourse.nature, '0000000108', '')}</td>
                <td>${fns:getDictLabel(scoCourseVo.scoCourse.type, '0000000102', '')}</td>

                <td>${fns:deleteZero(scoCourseVo.scoApply.realTime)}</td>
                <td>${fns:deleteZero(scoCourseVo.scoApply.realScore)}</td>
                <td>${fns:deleteZero(scoCourseVo.scoCourse.planScore)}</td>
                <td>
                    <c:choose>
                        <c:when test="${scoCourseVo.scoApply.auditStatus eq '1' ||scoCourseVo.scoApply.auditStatus eq '2' }">

                        </c:when>
                        <c:otherwise>
                            ${fns:deleteZero(scoCourseVo.scoApply.score)}
                        </c:otherwise>
                    </c:choose>
                        <%--${fns:deleteZero(scoCourseVo.scoApply.score)}--%>
                </td>
                    <%--<td>
                        <c:if test="${scoCourseVo.scoApply.courseStatus eq '1'}">
                            <span class="danger-color">课程未达标</span>
                        </c:if>
                        <c:if test="${scoCourseVo.scoApply.courseStatus eq '2'}">
                            <span class="success-color">课程已达标</span>
                        </c:if>
                    </td>--%>
                <td>
                    <c:if test="${scoCourseVo.scoApply.auditStatus eq '1'}">
                    <span class="primary-color">待提交认定</span>
                    </c:if>
                    <c:if test="${scoCourseVo.scoApply.auditStatus eq '2'}">
                    <span class="primary-color">
                                待审核
                               <%-- <a target="_blank" href="${ctx}/act/task/processActMap?proInstId=${scoCourseVo.scoApply.procInsId}">
                                    待审核
                                </a>--%>

                            </span>
                    </c:if>
                    <c:if test="${scoCourseVo.scoApply.auditStatus eq '3'}">
                    <span class="fail-color">未通过</span>
                    </c:if>
                    <c:if test="${scoCourseVo.scoApply.auditStatus eq '4'}">
                    <span class="info-color">通过</span>
                    </c:if>
                <td>
                    <c:if test="${scoCourseVo.scoApply.auditStatus ne '2'}">
                        <button class="btn btn-primary btn-small" disabled>审核
                        </button>
                    </c:if>
                    <c:if test="${scoCourseVo.scoApply.auditStatus eq '2'}">
                        <button class="btn btn-primary btn-small"
                                onclick="location.href='/a/scoapply/auditView?id=${scoCourseVo.scoApply.id}'">审核
                        </button>
                    </c:if>
                </td>
            </tr>
        </c:forEach>

        </tbody>
    </table>
    ${page.footer}
</div>
<script src="/js/student/checkboxChoose.js"></script>  <!--checkbox 全选js -->
</body>
</html>