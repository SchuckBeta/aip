<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%--<%@ page errorPage="/WEB-INF/views/error/formMiss.jsp"%>--%>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript" src="/js/backTable/sort.js"></script><!--排序js-->
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
    <%--<div class="edit-bar-left">--%>
    <%--<span>${menuName}</span>--%>
    <%--<i class="line weight-line"></i>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>

    <form:form id="searchForm" modelAttribute="proModelGzsmxx" action="${actionUrl}" method="post"
               class="form-horizontal clearfix form-search-block">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <input type="hidden" id="orderBy" name="orderBy" value="${page.orderBy}"/>
        <input type="hidden" id="orderByType" name="orderByType" value="${page.orderByType}"/>
        <input id="actywId" name="actywId" type="hidden" value="${actywId}"/>
        <input id="gnodeId" name="gnodeId" type="hidden" value="${gnodeId}"/>

        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">领域分组</label>
                <div class="controls">
                    <form:select path="regionGroup" class="input-medium">
                        <form:option value="" label="所有类别"/>
                        <form:options items="${fns:getDictList('project_region')}" itemLabel="label" itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group" style="margin-right: 410px;">
                <label class="control-label">所属学院</label>
                <div class="controls">
                    <form:select id="officeId" path="proModel.deuser.office.id" class="input-medium form-control">
                        <form:option value="" label="所有学院"/>
                        <form:options items="${fns:findColleges()}" itemLabel="name" itemValue="id"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
        </div>
        <div class="search-btn-box">
            <form:input class="input-xlarge" path="proModel.queryStr" htmlEscape="false" maxlength="100" autocomplete="off"
                        placeholder="项目编号/项目名称/负责人模糊搜索"/>
            <button id="searchBtn" type="submit" class="btn btn-primary">查询</button>
            <%--<button type="button" class="btn btn-primary" onclick="projectExport()">导出</button>--%>
        </div>

    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap table-sort">
        <thead>
        <tr>
            <th width="140" >编号</th>
            <th width="25%" >作品名称</th>
            <th>领域分组</th>
            <th>负责人</th>
            <th >学院</th>
            <th>组人数</th>
            <th>指导老师</th>
            <th>报名日期</th>
            <th>${menuName}结果</th>
            <c:if test="${isScore!=null && isScore=='1'}">
            <th>评分</th>
            </c:if>
            <th>年份</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="item">
            <c:set var="map" value="${fns:getActByPromodelId(item.proModel.id)}"/>
            <tr>
                <td>${item.proModel.competitionNumber}</td>
                <td>
                    <a href="${ctx}/promodel/proModel/viewForm?id=${item.proModel.id}&taskName=${map.taskName}">${item.proModel.pName}</a>
                </td>
                <td>${item.regionGroupName}</td>
                <td>${fns:getUserById(item.proModel.declareId).name}</td>
                <td>${item.proModel.deuser.office.name}</td>
                <td>${item.proModel.team.memberNum}</td>
                <td>
                        ${item.proModel.team.uName}
                </td>
                <td><fmt:formatDate value="${item.createDate}" pattern="yyyy-MM-dd"/></td>
                <td>
                        ${item.proModel.finalResult}
                </td>
                <c:if test="${item.proModel.gScore!=null && item.proModel.gScore!=''}">
                    <td>${item.proModel.gScore}</td>
                </c:if>
                <td>${item.proModel.year}</td>
                <td>
                    <a href="${ctx}/actyw/actYwGnode/designView?groupId=${item.proModel.actYw.groupId}&proInsId=${item.proModel.procInsId}"
                       target="_blank">
                        <c:choose>
                            <c:when test="${item.proModel.state eq '1'}">
                                项目已结项
                            </c:when>
                            <c:otherwise>待${map.taskName}</c:otherwise>
                        </c:choose>
                    </a>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${item.proModel.state =='1'}">
                            <button type="button" class="btn btn-primary btn-small" disabled>审核</button>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${map.status =='todo'}">
                                    <a class="btn btn-small btn-primary"
                                       href="${ctx}/act/task/auditform?gnodeId=${map.gnodeId}&proModelId=${item.proModel.id}
                                &pathUrl=${actionUrl}&taskName=${map.taskName}">审核</a>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="btn btn-primary btn-small" disabled>审核</button>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
<script>

    $(document).ready(function () {
        window.parent.sideNavModule.changeUnreadTag('${actywId}');
        $("#ps").val($("#pageSize").val());
    });

    function page(n, s) {
        $("#pageNo").val(n);
        $("#pageSize").val(s);
        $("#searchForm").submit();
        return false;
    }

    function projectExport() {
        var actywId = '${actywId}';
        var proCategory = $("#proCategory").val();
        var officeId = $("#officeId").val();
        var queryStr = $("#queryStr").val();
        location.href = "${ctx}/exp/expData/" + actywId + "?proCategory=" + proCategory
            + "&officeId=" + officeId + "&queryStr=" + queryStr + "&gnodeId=" + '${gnodeId}';

    }


</script>
</body>
</html>