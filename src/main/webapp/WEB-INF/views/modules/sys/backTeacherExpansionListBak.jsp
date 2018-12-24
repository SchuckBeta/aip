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
        });
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }
        function create() {
            window.location = "${ctx}/sys/backTeacherExpansion/form?operateType=1";
        }
    </script>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>导师库</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" modelAttribute="backTeacherExpansion" action="${ctx}/sys/backTeacherExpansion/"
               method="post" class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <input type="hidden" id="orderBy" name="orderBy" value="${page.orderBy}"/>
        <input type="hidden" id="orderByType" name="orderByType" value="${page.orderByType}"/>
        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">导师来源</label>
                <div class="controls">
                    <form:select path="teachertype" id="teachertype" class="input-medium form-control">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('master_type')}" itemLabel="label"
                                      itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>


            <div class="control-group">
                <label class="control-label">学历</label>
                <div class="controls">
                    <form:select path="user.education" class="input-medium form-control">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('enducation_level')}" itemLabel="label"
                                      itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">学位</label>
                <div class="controls">
                    <form:select path="user.degree" class="input-medium form-control">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('degree_type')}" itemLabel="label"
                                      itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">单位类别</label>
                <div class="controls">
                    <form:select path="workUnitType" id="workUnitType" class="input-medium form-control">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('0000000218')}" itemLabel="label"
                                      itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">服务意向</label>
                <div class="controls controls-checkbox">
                    <form:checkboxes path="serviceIntentionIds" items="${fns:getDictList('master_help')}"
                                     itemValue="value"
                                     itemLabel="label" htmlEscape="false"/>
                </div>
            </div>
            <div class="control-group" style="margin-right: 230px;">
                <label class="control-label">当前指导</label>
                <div class="controls controls-checkbox">
                    <form:checkboxes path="curJoinStr" items="${fns:getPublishDictList()}"
                                     itemValue="value"
                                     itemLabel="label" htmlEscape="false"/>
                </div>
            </div>

        </div>
        <div class="search-btn-box">
            <form:input class="search-input input-medium" type="text" path="keyWords" htmlEscape="false"
                        placeholder="职工号/姓名/职务/职称"/>
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
            <th data-name="u.no"><a class="btn-sort" href="javascript:void(0)"><span>职工号</span><i class="icon-sort"></i></a>
            </th>
            <th>姓名</th>
            <th>性别</th>
            <th>导师来源</th>
            <th>指导<br>项目/大赛</th>
            <th>服务意向</th>
            <th>职务</th>
            <th>职称</th>
            <th>学历</th>
            <th width="120">操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="backTeacherExpansion">
            <tr>
                <td class="checkone"><input type="checkbox" value="${backTeacherExpansion.id}" name="boxTd"></td>
                <td>
                        ${backTeacherExpansion.user.no}
                </td>
                <td>
                        ${backTeacherExpansion.user.name }
                </td>
                <td>
                        ${fns:getDictLabel(backTeacherExpansion.user.sex, 'sex', '')}
                </td>
                <td>
                        ${fns:getDictLabel(backTeacherExpansion.teachertype, 'master_type', '')}
                </td>
                <td>
                        ${backTeacherExpansion.curJoin}
                </td>
                <td>
                        ${backTeacherExpansion.serviceIntentionStr}
                </td>
                <td>
                        ${backTeacherExpansion.postTitle}
                </td>
                <td>
                        ${backTeacherExpansion.technicalTitle}
                </td>
                <td>
                        ${fns:getDictLabel(backTeacherExpansion.user.education, 'enducation_level', '')}
                </td>
                <td>
                    <a href="${ctx}/sys/backTeacherExpansion/form?id=${backTeacherExpansion.id}"
                       class="btn btn-primary btn-small">编辑</a>
                    <a href="${ctx}/sys/backTeacherExpansion/delete?id=${backTeacherExpansion.id}"
                       class="btn btn-default btn-small"
                       onclick="return confirmx('确认要删除该导师信息吗？', this.href)">删除</a>
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
                <p class="text-center" style="font-size: 14px">确认要删除所选导师信息吗？</p>
                <div class="buffer_gif" style="text-align:center;padding:20px 0px;display:none;" id="bufferImg">
                    <img src="/img/jbox-loading1.gif" alt="缓冲图片">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" aria-hidden="true" id="confirmBtn"
                        onclick="doBatch('/a/sys/backTeacherExpansion/deleteBatch');">确定
                </button>
                <button class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>
<script src="/js/student/checkboxChoose.js"></script>  <!--checkbox 全选js -->
</body>
</html>