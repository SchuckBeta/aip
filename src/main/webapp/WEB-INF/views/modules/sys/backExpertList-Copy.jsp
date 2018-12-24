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
        <%--function create() {--%>
            <%--window.location = "${ctx}/sys/backTeacherExpansion/form?operateType=1";--%>
        <%--}--%>
        function create() {
            window.location = "${ctx}/sys/expert/form";
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
    <form:form id="searchForm" modelAttribute="user" action="${ctx}/sys/expert/"
               method="post" class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <input type="hidden" id="orderBy" name="orderBy" value="${page.orderBy}"/>
        <input type="hidden" id="orderByType" name="orderByType" value="${page.orderByType}"/>
        <div class="col-control-group">
            <%--<div class="control-group">--%>
                <%--<label class="control-label">学历</label>--%>
                <%--<div class="controls">--%>
                    <%--<form:select path="education" class="input-medium form-control">--%>
                        <%--<form:option value="" label="--请选择--"/>--%>
                        <%--<form:options items="${fns:getDictList('enducation_level')}" itemLabel="label"--%>
                                      <%--itemValue="value"--%>
                                      <%--htmlEscape="false"/>--%>
                    <%--</form:select>--%>
                <%--</div>--%>
            <%--</div>--%>

            <%--<div class="control-group">--%>
                <%--<label class="control-label">学位</label>--%>
                <%--<div class="controls">--%>
                    <%--<form:select path="degree" class="input-medium form-control">--%>
                        <%--<form:option value="" label="--请选择--"/>--%>
                        <%--<form:options items="${fns:getDictList('degree_type')}" itemLabel="label"--%>
                                      <%--itemValue="value"--%>
                                      <%--htmlEscape="false"/>--%>
                    <%--</form:select>--%>
                <%--</div>--%>
            <%--</div>--%>
                <div class="control-group">
                    <label class="control-label">姓名</label>
                    <div class="controls">
                        <form:input path="name" type="text" htmlEscape="false" class="form-control input-medium"/>
                    </div>
                </div>
                <%--<div class="control-group">--%>
                    <%--<label class="control-label">学院/专业</label>--%>
                    <%--<div class="controls">--%>
                        <%--<sys:treeselect--%>
                                <%--id="office" name="office.id" value="${user.office.id}"--%>
                                <%--labelName="office.name" labelValue="${user.office.name}"--%>
                                <%--title="" url="/sys/office/treeData" allowClear="true"--%>
                                <%--allowInput="false"--%>
                                <%--cssStyle="width:120px;"/>--%>
                    <%--</div>--%>
                <%--</div>--%>
                <div class="control-group" style="margin-right: 160px;">
                    <label class="control-label">工号/学号</label>
                    <div class="controls">
                        <form:input path="no" type="text" htmlEscape="false" class="input-medium"/>
                    </div>
                </div>
        </div>
        <div class="search-btn-box">
            <%--<form:input class="search-input input-medium" type="text" path="keyWords" htmlEscape="false"--%>
                        <%--placeholder="职工号/姓名/职务/职称"/>--%>
            <button type="submit" class="btn btn-primary">查询</button>
        </div>
        <div class="text-right mgb-20">
            <button type="button" class="btn btn-primary" onclick="create();">添加</button>
                <%--<button id="btnSubmit1" type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">批量删除</button>--%>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th><input type="checkbox" id="check_all" data-flag="false"></th>
            <th data-name="a.no">
                <a class="btn-sort" href="javascript:void(0)"><span>职工号</span><i class="icon-sort"></i></a>
            </th>
            <th>姓名</th>
            <%--<th>性别</th>--%>
            <th>登录名</th>
            <th>领域</th>
            <th>手机号</th>
            <th>邮箱</th>
            <%--<th>学位</th>--%>
            <%--<th>学历</th>--%>
            <th width="120">操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="user">
            <tr>
                <td class="checkone"><input type="checkbox" value="${user.id}" name="boxTd"></td>
                <td>
                    ${user.no}
                </td>
                <td>
                    ${user.name }
                </td>
                <%--<td>--%>
                    <%--${fns:getDictLabel(user.sex, 'sex', '')}--%>
                <%--</td>--%>
                <td>
                    ${user.loginName }
                </td>
                <td>
                    ${user.domainlt}
                </td>
                <td>
                   ${user.mobile }
                </td>
                <td>
                   ${user.email}
                </td>
                <%--<td>--%>
                    <%--${fns:getDictLabel(user.degree, 'degree_type', '')}--%>
                <%--</td>--%>
                <%--<td>--%>
                    <%--${fns:getDictLabel(user.education, 'enducation_level', '')}--%>
                <%--</td>--%>
                <td>
                    <a href="${ctx}/sys/expert/form?id=${user.id}"
                       class="btn btn-primary btn-small">编辑</a>
                    <a href="${ctx}/sys/expert/delete?id=${user.id}"
                       class="btn btn-default btn-small"
                       onclick="return confirmx('确认要删除该专家信息吗？', this.href)">删除</a>
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