<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroudTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script src="/js/impdata/impdataList.js"></script>
    <script src="/common/common-js/ajaxfileupload.js"></script>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar edit-bar-tag clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>数据导入</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" action="${ctx}/impdata/list" method="post"
               class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden"
               value="${page.pageSize}"/>
        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">模板类型</label>
                <div class="controls">
                    <select id="tempType" class="input-medium">
                        <option value="">--请选择--</option>
                        <option value="1">学生信息模板</option>
                        <option value="2">导师信息模板</option>
                        <option value="3">后台用户信息模板</option>
                        <option value="4">机构信息模板</option>
                        <option value="5">项目信息模板</option>
                        <!-- <option value="9">项目信息模板（HS）</option> -->
                        <option value="10">互联网+大赛信息模板</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <button id="loadTemp" class="btn btn-primary" type="button"
                    onclick="downTemplate()">下载模板
            </button>
            <button id="import" class="btn btn-primary" type="button">导入</button>
            <input type="file" style="display: none" id="fileToUpload" name="fileName"
                   accept=".xls,.xlsx"/>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <%--<div class="table-responsive">--%>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-sort table-nowrap">
        <thead>
        <tr>
            <th>导入数据类型</th>
            <th>开始导入时间</th>
            <th>数据总数</th>
            <th>导入成功数</th>
            <th>导入失败数</th>
            <th>状态</th>
            <th width="160">操作</th>
        </tr>
        </thead>
        <tbody id="dataTb">
        <c:forEach items="${page.list}" var="data">
            <c:if test="${data.is_complete!=1}">
                <tr uncomplete="${data.id}">
            </c:if>
            <c:if test="${data.is_complete==1}">
                <tr>
            </c:if>
            <td>
                <c:if test="${data.imp_tpye==1}">学生信息</c:if>
                <c:if test="${data.imp_tpye==2}">导师信息</c:if>
                <c:if test="${data.imp_tpye==3}">后台用户信息</c:if>
                <c:if test="${data.imp_tpye==4}">机构信息</c:if>
                <c:if test="${data.imp_tpye==5}">项目信息</c:if>
                <c:if test="${data.imp_tpye==9}">项目信息（HS）</c:if>
                <c:if test="${data.imp_tpye==10}">互联网+大赛信息</c:if>
            </td>
            <td>${data.create_date}</td>
            <td>${data.total}</td>
            <td>${data.success}</td>
            <td>${data.fail}</td>
            <td>
                <c:if test="${data.is_complete==0}">导入中</c:if>
                <c:if test="${data.is_complete==1}">导入完毕</c:if>
            </td>
            <shiro:hasPermission name="sys:user:import">
                <td style="white-space: nowrap">
                    <c:if test="${data.is_complete!=1}">
                        <a style="display: none" href="${ctx}/impdata/expData?id=${data.id}&type=${data.imp_tpye}"
                           class="btn isComplete btn-primary btn-small">下载错误数据</a>
                        <a style="display: none" href="${ctx}/impdata/delete?id=${data.id}"
                           class="btn isComplete btn-default btn-small"
                           onclick="return confirmx('确认要删除吗？', this.href)">删除</a>
                    </c:if>
                    <c:if test="${data.is_complete==1}">
                        <a href="${ctx}/impdata/expData?id=${data.id}&type=${data.imp_tpye}"
                           class="btn btn-primary btn-small">下载错误数据</a>
                        <a href="${ctx}/impdata/delete?id=${data.id}" class="btn btn-default btn-small"
                           onclick="return confirmx('确认要删除吗？', this.href)">删除</a>
                    </c:if>
                </td>
            </shiro:hasPermission>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
    <%--</div>--%>
</div>
<div id="dialog-message" title="信息" style="display: none;">
    <p id="dialog-content"></p>
</div>
</body>
</html>