<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理</title>
    <%@include file="/WEB-INF/views/include/backCommon.jsp" %>
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
            window.location = "${ctx}/sys/user/form";
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
        function sendTestMsg(uid){
        	$.ajax({
                url: '${ctx}/oa/oaNotify/sendTestMsg',
                type: 'GET',
                dataType: 'json',
                data:{uid:uid},
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
<div class="container-fluid container-fluid-oe" role="main">
    <div class="edit-bar clearfix">
        <div class="edit-bar-left">
            <span>用户管理</span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <form:form id="searchForm" modelAttribute="user"
               action="${ctx}/sys/user/list" method="post"
               class="form-top-search">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="search-form-wrap form-inline">
            <input id="btnSubmit" class="btn btn-back-oe btn-primaryBack-oe btn-search" type="submit" value="查询"
                   onclick="return page();"/>
            <input class="btn btn-back-oe btn-primaryBack-oe" type="submit" value="导出用户"/>
            <input id="createUser" class="btn btn-back-oe btn-primaryBack-oe" type="button" value="创建用户" onclick="create();"/>
            <!-- <input class="btn btn-back-oe btn-primaryBack-oe" type="button" value="修复学生角色数据" onclick="repaireStudentRole();"/> -->
        </div>
        <div class="condition-main form-horizontal">
            <div class="condition-row">
                <div class="condition-item">
                    <div class="control-group">
                        <label for="loginName" class="control-label">登录名</label>
                        <div class="controls">
                            <form:input path="loginName" htmlEscape="false" class="form-control input-medium"/>
                        </div>
                    </div>
                </div>
                <div class="condition-item">
                    <div class="control-group">
                        <label for="roleId" class="control-label">用户角色</label>
                        <div class="controls">
                            <form:select path="roleId" class="form-control input-medium">
                                <form:option value="" label="所有角色"/>
                                <c:forEach items="${roleList}" var="role">
                                    <form:option value="${role.id}" label="${role.name}"/>
                                </c:forEach>
                            </form:select>
                        </div>
                    </div>
                </div>
                <div class="condition-item">
                    <div class="control-group">
                        <label for="userType" class="control-label">用户类型</label>
                        <div class="controls">
                            <form:select path="userType" class="form-control input-medium">
                                <form:option value="" label="所有用户"/>
                                <form:options items="${fns:getDictList('sys_user_type')}" itemLabel="label"
                                              itemValue="value" htmlEscape="false"/>
                            </form:select>
                        </div>
                    </div>
                </div>
                <div class="condition-item">
                    <div class="control-group">
                        <label for="name" class="control-label">姓名</label>
                        <div class="controls">
                            <form:input path="name" type="text" htmlEscape="false" class="form-control input-medium"/>
                        </div>
                    </div>
                </div>
                <div class="condition-item condition-item-tree">
                    <div class="control-group">
                        <label for="office" class="control-label">学院/专业</label>
                        <div class="controls" style="height: 34px;overflow: hidden;">
                            <sys:treeselect
                                    id="office" name="office.id" value="${user.office.id}"
                                    labelName="office.name" labelValue="${user.office.name}"
                                    title="" url="/sys/office/treeData"
                                    cssClass="input-medium form-control form-control-tree" allowClear="true"
                                    allowInput="true"
                                    cssStyle="width:150px;"/>
                        </div>
                    </div>
                </div>
                <div class="condition-item">
                    <div class="control-group">
                        <label for="name" class="control-label">工号/学号</label>
                        <div class="controls">
                            <form:input path="no" type="text" htmlEscape="false" class="form-control input-medium"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table class="table table-hover table-bordered table-condensed table-center table-theme-default">
        <thead>
        <tr>
            <th style="white-space: nowrap">登录名</th>
            <th style="white-space: nowrap;">用户角色</th>
            <th style="white-space: nowrap">用户类型</th>
            <th>姓名</th>
            <th style="white-space: nowrap">工号/学号</th>
            <th>手机号</th>
            <th style="white-space: nowrap">学院/专业</th>
            <th style="white-space: nowrap">擅长技术领域</th>
            <shiro:hasPermission name="sys:user:edit">
                <th>操作</th>
            </shiro:hasPermission>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="user">
            <tr>
                <td>${user.loginName}</td>
                <td><span style="display: inline-block;max-width: 240px;">${user.roleNames}</span></td>
                    <%-- <td>${user.userType}</td> --%>
                <td>${fns:getDictLabel(user.userType, 'sys_user_type', '无')}</td>

                <td style="white-space: nowrap">${user.name}</td>
                <td>${user.no}</td>
                <td>${user.mobile}</td>
                <td>${user.office.name}/${fns:getOffice(user.professional).name}</td>
                    <%-- <td>${user.domain}</td> --%>
                <td>${user.domainlt}</td>

                <shiro:hasPermission name="sys:user:edit">
                    <td style="white-space: nowrap">
                    <%-- <a href="javascript:void(0)" onclick="sendTestMsg('${user.id}')"
                           class="btn btn-back-oe btn-primaryBack-oe btn-small">发送</a> --%>
                        <a href="${ctx}/sys/user/form?id=${user.id}"
                           class="btn btn-back-oe btn-primaryBack-oe btn-small">修改</a>
                        <a href="${ctx}/sys/user/delete?id=${user.id}" class="btn btn-small"
                           onclick="return confirmJBox('确认要删除该用户吗？', this.href)">删除</a>
                    </td>
                </shiro:hasPermission>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
<sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="page();"/>
</body>
<script>

    function confirmJBox(mess, href, closed) {
        top.$.jBox.confirm(mess, '系统提示', function (v, h, f) {
            if (v == 'ok') {
                if (typeof href == 'function') {
                    href();
                } else if (typeof href == 'string') {
                    resetTip();
                    location = href;
                }
            }
            if (v == 'cancel') {
                if (typeof closed == 'function') {
                    closed();
                } else if (typeof closed == 'string') {
                    resetTip(); //loading();
                    location = closed;
                }
            }
        }, {
            top: 240
        });
        top.$('.jbox-body .jbox-icon').css('top', '55px');
        return false;
    }

</script>
</html>