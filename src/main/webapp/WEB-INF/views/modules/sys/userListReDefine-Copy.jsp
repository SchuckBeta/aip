<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
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
            window.location = "${ctx}/sys/user/form?secondName=创建用户";
        }
        function ajaxSubmit() {


            $("#searchForm").submit();
        }

        function repaireStudentRole() {
            $.ajax({
                url: '${ctx}/sys/user/repaireStudentRole/13757518f4da45ecaa32a3b582e8396a',
                type: 'GET',
                dataType: 'json',
                success: function (data) {
                    if (data.status) {
                        window.location = "${ctx}/sys/user/list";
                    }
                }
            });
        }
        function sendTestMsg(uid) {
            $.ajax({
                url: '${ctx}/oa/oaNotify/sendTestMsg',
                type: 'GET',
                dataType: 'json',
                data: {uid: uid},
                success: function (data) {
                    if (data) {
                        alertx(data.msg);
                    }
                }
            });
        }
    </script>
</head>
<body>






<div class="container-fluid" role="main">
    <%--<div class="edit-bar clearfix">--%>
    <%--<div class="edit-bar-left">--%>
    <%--<span>用户管理</span>--%>
    <%--<i class="line weight-line"></i>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" modelAttribute="user" action="${ctx}/sys/user/list" method="post" autocomplete="off"
               class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>

        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">登录名</label>
                <div class="controls">
                    <form:input path="loginName" htmlEscape="false" class="form-control input-medium"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">用户角色</label>
                <div class="controls">
                    <form:select path="roleId" cssStyle="width: 164px;">
                        <form:option value="" label="所有角色"/>
                        <c:forEach items="${roleList}" var="role">
                            <form:option value="${role.id}" label="${role.name}"/>
                        </c:forEach>
                    </form:select>
                </div>
            </div>
                <%--             <div class="control-group">
                                <label class="control-label">用户类型</label>
                                <div class="controls">
                                    <form:select path="userType"  cssStyle="width: 164px;">
                                        <form:option value="" label="所有用户"/>
                                        <form:options items="${fns:getDictList('sys_user_type')}" itemLabel="label"
                                                      itemValue="value" htmlEscape="false"/>
                                    </form:select>
                                </div>
                            </div> --%>
            <div class="control-group">
                <label class="control-label">姓名</label>
                <div class="controls">
                    <form:input path="name" type="text" htmlEscape="false" class="form-control input-medium"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">学院/专业</label>
                <div class="controls">
                    <sys:treeselect
                            id="office" name="office.id" value="${user.office.id}"
                            labelName="office.name" labelValue="${user.office.name}"
                            title="" url="/sys/office/treeData" allowClear="true"
                            allowInput="false"
                            cssStyle="width:120px;"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">手机</label>
                <div class="controls">
                    <form:input path="mobile" type="text" htmlEscape="false" class="form-control input-medium"/>
                </div>
            </div>
            <div class="control-group" style="margin-right: 160px;">
                <label class="control-label">工号/学号</label>
                <div class="controls">
                    <form:input path="no" type="text" htmlEscape="false" class="input-medium"/>
                </div>
            </div>
        </div>

        <div class="search-btn-box">
            <button type="button" class="btn btn-primary" onclick="ajaxSubmit();">查询</button>
            <button type="button" class="btn btn-primary" onclick="create();">创建用户</button>
                <%--<input id="btnSubmit" class="btn btn-back-oe btn-primaryBack-oe btn-search" type="submit" value="查询"--%>
                <%--onclick="return page();"/>--%>
                <%--<input class="btn btn-back-oe btn-primaryBack-oe" type="submit" value="导出用户"/>--%>
                <%--<input id="createUser" class="btn btn-back-oe btn-primaryBack-oe" type="button" value=""--%>
                <%--/>--%>
            <!-- <input class="btn btn-back-oe btn-primaryBack-oe" type="button" value="修复学生角色数据" onclick="repaireStudentRole();"/> -->
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th>登录名</th>
            <th>用户角色</th>
            <!-- <th>用户类型</th> -->
            <th>姓名</th>
            <th>工号/学号</th>
            <th>手机号</th>
            <th>学院/专业</th>
            <th>擅长技术领域</th>
            <shiro:hasPermission name="sys:user:edit">
                <th width="200">操作</th>
            </shiro:hasPermission>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="user">
            <tr>
                <td>${user.loginName}</td>
                <td>${user.roleNames}</td>
                    <%-- <td>${user.userType}</td> --%>
                    <%-- <td>${fns:getDictLabel(user.userType, 'sys_user_type', '无')}</td> --%>

                <td>${user.name}</td>
                <td>${user.no}</td>
                <td>${user.mobile}</td>
                <td>${user.office.name}/${fns:getProfessional(user.professional)}</td>
                    <%-- <td>${user.domain}</td> --%>
                <td>${user.domainlt}</td>

                <shiro:hasPermission name="sys:user:edit">
                    <td>
                        <a href="${ctx}/sys/user/resetpwd?id=${user.id}" class="btn btn-primary btn-small"
                           onclick="return confirmx('确认要重置密码吗？', this.href)">重置密码</a>
                        <a href="${ctx}/sys/user/form?id=${user.id}&secondName=修改"
                           class="btn btn-primary btn-small">修改</a>
                        <a href="${ctx}/sys/user/delete?id=${user.id}" class="btn btn-default btn-small"
                           onclick="return confirmx('确认要删除该用户吗？', this.href)">删除</a>
                    </td>
                </shiro:hasPermission>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
</body>

</html>