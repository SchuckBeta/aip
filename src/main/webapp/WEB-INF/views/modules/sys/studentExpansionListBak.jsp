<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript" src="/js/backTable/sort.js"></script><!--排序js-->
    <script type="text/javascript">
        $(document).ready(function () {
            $("#ps").val($("#pageSize").val());
            $('.pagination_num').removeClass('row')
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
                            if (val.id == "${studentExpansion.user.professional}") {
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

        function create() {
            window.location = "${ctx}/sys/studentExpansion/form";
        }
    </script>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>学生库</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" modelAttribute="studentExpansion" action="${ctx}/sys/studentExpansion/" method="post"
               class="form-horizontal clearfix form-search-block" autocomplete="off">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <input type="hidden" id="orderBy" name="orderBy" value="${page.orderBy}"/>
        <input type="hidden" id="orderByType" name="orderByType" value="${page.orderByType}"/>
        <div class="col-control-group">
            <div class="control-group">
                <label for="collegeId" class="control-label">学院</label>
                <div class="controls">
                    <form:select path="user.office.id" class="input-medium" id="collegeId">
                        <form:option value="" label="所有学院"/>
                        <form:options items="${fns:findColleges()}" itemLabel="name" itemValue="id"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label for="professionalSelect" class="control-label">专业</label>
                <div class="controls">
                    <form:select path="user.professional" class="input-medium"
                                 id="professionalSelect">
                        <form:option value="" label="所有专业"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label for="currState" class="control-label">学生现状</label>
                <div class="controls">
                    <form:select id="currState" path="currState" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('current_sate')}" itemLabel="label"
                                      itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label for="nowProject" class="control-label">在研项目</label>
                <div class="controls">
                    <form:select id="nowProject" path="nowProject" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('yes_no')}" itemLabel="label"
                                      itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label for="userEducation" class="control-label">学历</label>
                <div class="controls">
                    <form:select id="userEducation" path="user.education"
                                 class="input-medium">
                        <form:option value="" label="所有学历"/>
                        <form:options items="${fns:getDictList('enducation_level')}" itemLabel="label"
                                      itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label for="userDegree" class="control-label">学位</label>
                <div class="controls">
                    <form:select id="userDegree" path="user.degree" class="input-medium">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('degree_type')}" itemLabel="label"
                                      itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group" style="margin-right: 230px;">
                <label for="curJoinStr" class="control-label">当前在研</label>
                <div class="controls controls-checkbox">
                    <form:checkboxes path="curJoinStr" items="${fns:getPublishDictList()}"
                                     itemValue="value"
                                     itemLabel="label" htmlEscape="false"/>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <form:input id="myFind" class="search-input input-medium" type="text" path="myFind"
                        htmlEscape="false" placeholder="关键字"/>
            <button type="submit" class="btn btn-primary">查询</button>
        </div>
        <div class="text-right mgb-20">
            <button type="button" class="btn btn-primary" onclick="create();">添加</button>
            <button id="btnSubmit1" type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">批量删除</button>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th><input type="checkbox" id="check_all" data-flag="false"></th>
            <th data-name="u.no"><a class="btn-sort" href="javascript:void(0)"><span>学号</span><i class="icon-sort"></i></a>
            </th>
            <th>姓名</th>
            <th>性别</th>
            <th>当前在研</th>
            <th>现状</th>
            <th>学院</th>
            <th>专业</th>
            <th>学历</th>
            <th>学位</th>
            <th>毕业时间</th>
            <th>休学时间</th>
            <%--<th>是否公开</th>--%>
            <th width="120">操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="studentExpansion">
            <tr>
                <td class="checkone"><input type="checkbox" value="${studentExpansion.id}" name="boxTd"></td>
                <td>
                        ${studentExpansion.user.no}
                </td>
                <td>
                        ${studentExpansion.user.name}
                </td>
                <td>
                        ${fns:getDictLabel(studentExpansion.user.sex,"sex" , "")}
                </td>
                <td>
                        ${studentExpansion.curJoin}
                </td>
                <td>
                        ${fns:getDictLabel(studentExpansion.currState,"current_sate" , "")}
                </td>
                <td>
                        ${studentExpansion.user.office.name}
                </td>
                <td>
                        ${fns:getOffice(studentExpansion.user.professional).name}
                </td>
                <td>
                        ${fns:getDictLabel(studentExpansion.user.education, 'enducation_level', '')}
                </td>
                <td>
                        ${fns:getDictLabel(studentExpansion.user.degree, 'degree_type', '')}
                </td>
                <td>
                        ${studentExpansion.graduationStr}
                </td>
                <td>
                        ${studentExpansion.temporaryDateStr}
                </td>
                <%--<td>--%>
                        <%--${fns:getDictLabel(studentExpansion.isOpen,"yes_no" , "")}--%>
                <%--</td>--%>
                <td>
                    <a href="${ctx}/sys/studentExpansion/form?id=${studentExpansion.id}"
                       class="btn btn-primary btn-small">编辑</a>
                    <a href="${ctx}/sys/studentExpansion/delete?id=${studentExpansion.id}"
                       class="btn btn-default btn-small"
                       onclick="return confirmx('确认要删除该学生信息吗？', this.href)">删除</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>

<!-- Modal  批量删除弹窗 -->
<div id="myModal" class="modal hide" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">批量删除</h4>
            </div>
            <div class="modal-body">
                <p class="text-center" style="font-size: 14px" id="selectArea">确认要删除所选学生信息吗？</p>
                <div class="buffer_gif" style="text-align:center;padding:20px 0px;display:none;" id="bufferImg">
                    <img src="/img/jbox-loading1.gif" alt="缓冲图片">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" aria-hidden="true" id="confirmBtn"
                        onclick="doBatch('/a/sys/studentExpansion/deleteBatch');">确定
                </button>
                <button class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<script src="/js/student/checkboxChoose.js"></script>  <!--checkbox 全选js -->

</body>
</html>