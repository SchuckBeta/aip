<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
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
    </script>
</head>
<body>
<div class="container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>资产使用明细</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <%--<ul class="nav nav-tabs">--%>
        <%--<li class="active"><a href="${ctx}/pw/pwFassetsUhistory/">固定资产使用记录列表</a></li>--%>
        <%--<shiro:hasPermission name="pw:pwFassetsUhistory:edit">--%>
            <%--<li><a href="${ctx}/pw/pwFassetsUhistory/form">固定资产使用记录添加</a></li>--%>
        <%--</shiro:hasPermission>--%>
        <%--<li><a href="${ctx}/pw/pwFassetsUhistory/">耗材使用记录列表</a></li>--%>
        <%--<shiro:hasPermission name="pw:pwFassetsUhistory:edit">--%>
            <%--<li><a href="${ctx}/pw/pwFassetsUhistory/form">耗材使用记录添加</a></li>--%>
        <%--</shiro:hasPermission>--%>
   <%--</ul>--%>
    <sys:message content="${message}"/>
    <div class="content_panel">
        <form:form id="searchForm" modelAttribute="pwFassetsUhistory" action="${ctx}/pw/pwFassetsUhistory/" method="post"
                   class="form-horizontal clearfix form-search-block">
            <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
            <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
            <input type="hidden" id="orderBy" name="orderBy" value="${page.orderBy}"/>
            <input type="hidden" id="orderByType" name="orderByType" value="${page.orderByType}"/>
            <div class="col-control-group">
                <div class="control-group">
                    <label class="control-label">编号 </label>
                    <div class="controls">
                        <form:input path="pwFassets.name" class="input-medium" />
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">资产类型 </label>
                    <div class="controls">
                            <form:select path="pwFassets.pwCategory.parent.id" class="input-medium form-control" id="category1" cssStyle="width: 164px;">
                            <form:option value="" label="---请选择---"/>
                            <form:options items="${fns:findChildrenCategorys(null)}" itemLabel="name" itemValue="id"
                            htmlEscape="false"/>
                            </form:select>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">资产名称 </label>
                    <div class="controls">
                        <form:select path="pwFassets.pwCategory.id" class="input-medium form-control" id="category2" cssStyle="width: 164px;">
                            <form:option value="" label="---请选择---"/>
                        </form:select>
                    </div>
                </div>
                <div class="control-group">
                    <%--<label class="control-label">房间 </label>--%>
                    <%--<div class="controls">--%>
                        <%--<sys:treeselectFloor id="parent" name="pwRoom.id" value="${pwFassetsUhistory.pwRoom.id}" labelName="pwRoom.name"--%>
                                             <%--labelValue="${pwFassetsUhistory.pwRoom.name}"--%>
                                             <%--title="房间" url="/pw/pwRoom/roomTreeData" extId="${pwRoom.pwSpace.id}" cssClass=""--%>
                                             <%--cssStyle="width:119px;" isAll="true"--%>
                                             <%--allowClear="true" notAllowSelectRoot="true" notAllowSelectParent="true"/>--%>
                    <%--</div>--%>
                        <label class="control-label">房间名称</label>
                        <div class="controls">
                            <form:input class="input-medium" path="pwRoom.name" htmlEscape="false" maxlength="100" autocomplete="off"
                                    placeholder="房间名称模糊搜索"/>
                        </div>
                </div>
                <div class="control-group">
                    <label class="control-label">使用人</label>
                    <div class="controls">
                        <form:input path="respName" class="input-medium required" placeholder="使用人模糊搜索"/>
                    </div>
                </div>
            </div>
            <div class="search-btn-box">
                <button id="searchBtn" type="submit" class="btn btn-primary">查询</button>
            </div>
    </div>
    </form:form>
        <table id="contentTable" class="table table-bordered table-condensed table-hover table-center table-orange table-sort table-nowrap table-subscribe">
            <thead>
                <tr>
                    <th data-name="f.name"><a class="btn-sort" href="javascript:void(0);">资产编号<i class="icon-sort"></i></a></th>
                    <th data-name="c.name"><a class="btn-sort" href="javascript:void(0);">资产名称<i class="icon-sort"></i></a></th>
                    <th data-name="cc.name"><a class="btn-sort" href="javascript:void(0);">资产类别<i class="icon-sort"></i></a></th>
                    <th>使用场地</th>
                    <th data-name="a.resp_name"><a class="btn-sort" href="javascript:void(0);">使用人<i class="icon-sort"></i></a></th>
                    <th>领用时间</th>
                    <th>归还时间</th>
                    <th>联系方式</th>
                    <%--<th>备注</th>--%>
                    <%--<shiro:hasPermission name="pw:pwFassetsUhistory:edit"><th>操作</th></shiro:hasPermission>--%>
                </tr>
            </thead>
            <tbody>
            <c:forEach items="${page.list}" var="pwFassetsUhistory">
                <tr>
                    <td>
                            <%--<a href="${ctx}/pw/pwFassetsUhistory/form?id=${pwFassetsUhistory.id}"></a>--%>
                            ${pwFassetsUhistory.pwFassets.name}
                    </td>
                    <td>
                            ${pwFassetsUhistory.pwFassets.pwCategory.name}
                    </td>
                    <td>
                            ${pwFassetsUhistory.pwFassets.pwCategory.parent.name}
                    </td>
                    <td>
                            ${pwFassetsUhistory.pwRoom.pwSpace.parent.parent.name}-${pwFassetsUhistory.pwRoom.pwSpace.parent.name}-${pwFassetsUhistory.pwRoom.pwSpace.name}-${pwFassetsUhistory.pwRoom.name}
                    </td>
                    <td>
                            ${pwFassetsUhistory.respName}
                    </td>
                    <td>
                        <fmt:formatDate value="${pwFassetsUhistory.startDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </td>
                    <td>
                        <fmt:formatDate value="${pwFassetsUhistory.endDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </td>
                    <td>
                            ${pwFassetsUhistory.respMobile}
                    </td>
                        <%--<td>--%>
                        <%--${pwFassetsUhistory.remarks}--%>
                        <%--</td>--%>
                        <%--<shiro:hasPermission name="pw:pwFassetsUhistory:edit">--%>
                        <%--<td>--%>
                        <%--<a class="check_btn btn-pray btn-lx-primary"--%>
                        <%--href="${ctx}/pw/pwFassetsUhistory/delete?id=${pwFassetsUhistory.id}"--%>
                        <%--onclick="return confirmx('确认要删除该固定资产使用记录吗？', this.href)">删除</a>--%>
                        <%--</td>--%>
                        <%--</shiro:hasPermission>--%>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        ${page.footer}
    </div>
    <div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>
</div>
</body>
<script>
    /**
     * 根据资产类型查询资产名称
     */
    $("#category1").change(function () {
        var categoryId = $(this).children('option:selected').val();
        if(!categoryId){
            return;
        }
        $.ajax({
            url: '${ctx}/pw/pwCategory/childrenCategory',
            type: 'GET',
            dataType: 'json',
            data: {
                categoryId: categoryId
            },
            complete: function (data) {
                if (data) {
                    var r = jQuery.parseJSON(data.responseText);
                    $category2 = $("#category2");
                    $category2.empty();
                    $category2.append("<option value='' selected='selected'>---请选择---</option>");
                    $.each(r, function (i, item) {
                        if (item.id == "${pwFassetsUhistory.pwFassets.pwCategory.id}") {
                            $category2.append("<option value='" + item.id + "' selected='selected'>" + item.name + "</option>");
                        } else {
                            $category2.append("<option value='" + item.id + "'>" + item.name + "</option>");
                        }
                    })
                }
            }
        })
    });
    $("#category1").trigger('change');
</script>
</html>