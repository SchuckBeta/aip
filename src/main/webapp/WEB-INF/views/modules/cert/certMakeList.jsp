<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script src="/js/cert/certMakeList.js"></script>
    <script src="/common/common-js/ajaxfileupload.js"></script>
</head>
<body>

<style>
    .add-cert-href{
        margin-left:20px;
        color:#ccc;
    }
</style>

<div class="container-fluid">
    <div class="edit-bar edit-bar-tag clearfix">
        <div class="edit-bar-left">
            <span>证书下发</span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <sys:message content="${message}"/>
    <form:form id="searchForm" action="${ctx}/certMake/list" method="post"
               class="form-horizontal clearfix form-search-block">
        <input type="hidden" id="referrer" name="referrer" value="${referrer}">
        <input type="hidden" id="actywId" name="actywId" value="${actywId}">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">证书</label>
                <div class="controls">
                    <select id="certid" name="certid">
                        <option value="">--请选择--</option>
                        <c:forEach items="${certList}" var="cert">
                            <option value="${cert.id }">${cert.name }</option>
                        </c:forEach>
                    </select>
                    <c:if test="${empty certList}">
                        <span class="add-cert-href">请添加相关证书</span>
                    </c:if>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <button class="btn btn-default" onclick="goback();" type="button">返回</button>
            <button class="btn btn-primary" type="button" onclick="certMake(this);">下发证书</button>
        </div>
    </form:form>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th>证书</th>
            <th>开始下发时间</th>
            <th>总数</th>
            <th>成功数</th>
            <th>失败数</th>
            <th>状态</th>
            <th>错误信息</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody id="dataTb">
        <c:forEach items="${page.list}" var="data">
            <c:if test="${data.isComplete!=1}">
                <tr uncomplete="${data.id}">
            </c:if>
            <c:if test="${data.isComplete==1}">
                <tr>
            </c:if>
            <td>${data.certname}</td>
            <td><fmt:formatDate value="${data.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            <td>${data.total}</td>
            <td>${data.success}</td>
            <td>${data.fail}</td>
            <td>
                <c:if test="${data.isComplete==0}">下发中</c:if>
                <c:if test="${data.isComplete==1 and empty data.errmsg}">下发完毕</c:if>
                <c:if test="${data.isComplete==1 and not empty data.errmsg}">下发失败</c:if>
            </td>
            <td>${data.errmsg}</td>
            <shiro:hasPermission name="cert:sysCert:edit">
                <td>
                    <c:if test="${data.isComplete!=1}">
                        <a href="${ctx}/certMake/delete?id=${data.id}&referrer=${encodereferrer}"
                           class="btn isComplete btn-default btn-small"
                           onclick="return confirmx('确认要删除吗？', this.href)">删除</a>
                    </c:if>
                    <c:if test="${data.isComplete==1}">
                        <a href="${ctx}/certMake/delete?id=${data.id}&referrer=${encodereferrer}" class="btn btn-default btn-small"
                           onclick="return confirmx('确认要删除吗？', this.href)">删除</a>
                    </c:if>
                </td>
            </shiro:hasPermission>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
</div>
<div id="dialog-message" title="信息" style="display: none;">
    <p id="dialog-content"></p>
</div>
</body>
</html>