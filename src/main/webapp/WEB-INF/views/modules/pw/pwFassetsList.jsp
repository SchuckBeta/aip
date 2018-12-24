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
            <%--<span>固定资产管理</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>

    <form:form id="searchForm" class="form-horizontal clearfix form-search-block" modelAttribute="pwFassets"
               action="${ctx}/pw/pwFassets/" method="post">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <input type="hidden" id="orderBy" name="orderBy" value="${page.orderBy}"/>
        <input type="hidden" id="orderByType" name="orderByType" value="${page.orderByType}"/>
        <div class="col-control-group">
            <div class="control-group">
                <label class="control-label">资产类别 </label>
                <div class="controls">
                    <form:select path="pwCategory.parent.id" class="input-medium form-control" id="category1"
                                 cssStyle="width: 164px;">
                        <form:option value="" label="---请选择---"/>
                        <form:options items="${fns:findChildrenCategorys(null)}" itemLabel="name" itemValue="id"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">资产名称 </label>
                <div class="controls">
                    <form:select path="pwCategory.id" class="input-medium form-control" id="category2"
                                 cssStyle="width: 164px;">
                        <form:option value="" label="---请选择---"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">状态 </label>
                <div class="controls">
                    <form:select id="status" path="status" class="input-medium form-control" cssStyle="width: 164px;">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('0000000226')}" itemLabel="label"
                                      itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <%--<label class="control-label">房间 </label>--%>
                <%--<div class="controls">--%>
                    <%--<sys:treeselectFloor id="parent" name="pwRoom.id" value="${pwFassets.pwRoom.id}"--%>
                                         <%--labelName="pwRoom.name"--%>
                                         <%--labelValue="${pwFassets.pwRoom.name}"--%>
                                         <%--title="房间" url="/pw/pwRoom/roomTreeData" extId="${pwRoom.pwSpace.id}"--%>
                                         <%--cssStyle="width:119px;" isAll="true"--%>
                                         <%--allowClear="true" notAllowSelectRoot="true" notAllowSelectParent="true"/>--%>
                <%--</div>--%>
                    <label class="control-label">房间名称</label>
                    <div class="controls">
                        <form:input class="input-medium" path="pwRoom.name" htmlEscape="false" maxlength="100" autocomplete="off"
                                placeholder="房间名称模糊搜索"/>
                    </div>
            </div>
        </div>
        <div class="search-btn-box">
            <button id="searchBtn" type="submit" class="btn btn-primary">查询</button>
        </div>
        <div class="text-right mgb15">
            <shiro:hasPermission name="pw:pwFassets:edit">
                <a class="btn btn-primary" href="${ctx}/pw/pwFassets/form?secondName=添加资产">添加资产</a>
                <a class="btn btn-primary" href="${ctx}/pw/pwFassets/batchForm?secondName=批量添加资产">批量添加资产</a>
                <a class="btn btn-primary" id="batchAssign">批量分配资产</a>
            </shiro:hasPermission>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-sort table-nowrap table-subscribe">
        <thead>
        <tr>
            <th width="32"><input type="checkbox" class="all-checkbox"></th>
            <th width="130" data-name="a.name"><a class="btn-sort" href="javascript:void(0);">资产编号<i
                    class="icon-sort"></i></a>
            </th>
            <th width="90" data-name="c.name"><a class="btn-sort" href="javascript:void(0);">资产名称<i
                    class="icon-sort"></i></a>
            </th>
            <th width="90" data-name="cc.name"><a class="btn-sort" href="javascript:void(0);">资产类别<i
                    class="icon-sort"></i></a>
            </th>
            <th>使用人</th>
            <th>开始使用时间</th>
            <th>使用场地</th>
            <th>联系方式</th>
            <th width="80" data-name="a.status"><a class="btn-sort" href="javascript:void(0);">状态<i
                    class="icon-sort"></i></a>
            </th>
            <shiro:hasPermission name="pw:pwFassets:edit">
                <th>操作</th>
            </shiro:hasPermission>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="pwFassets">
            <tr>
                <td>
                    <input type="checkbox" class="checkbox-item" value="${pwFassets.id}">
                </td>
                <td hidden="hidden">${pwFassets.id}</td>
                <td>
                    <a href="${ctx}/pw/pwFassets/details?id=${pwFassets.id}">${pwFassets.name}</a>
                </td>
                <td>
                        ${pwFassets.pwCategory.name}
                </td>
                <td>
                        ${pwFassets.pwCategory.parent.name}
                </td>

                <td>
                        ${pwFassets.respName}
                </td>
                <td>
                    <fmt:formatDate value="${pwFassets.startDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                </td>
                <td>
                    <c:if test="${pwFassets.status == '1'}">
                        ${pwFassets.pwRoom.pwSpace.parent.parent.name}-${pwFassets.pwRoom.pwSpace.parent.name}-${pwFassets.pwRoom.pwSpace.name}-${pwFassets.pwRoom.name}
                    </c:if>
                </td>
                <td>
                        ${pwFassets.respMobile}
                </td>
                <td>
                        ${fns:getDictLabel(pwFassets.status, '0000000226', '')}
                </td>
                <shiro:hasPermission name="pw:pwFassets:edit">
                    <td class="judge-td" style="width:170px;text-align: right;">
                        <a class="btn btn-small btn-primary"
                           href="${ctx}/pw/pwFassets/form?id=${pwFassets.id}&secondName=修改">修改</a>
                        <c:choose>
                            <c:when test="${pwFassets.status == '0'}">
                                <a class="btn btn-small btn-primary"
                                   href="${ctx}/pw/pwFassets/assignForm?fassetsIds=${pwFassets.id}&secondName=分配">分配</a>
                                <a class="btn btn-small btn-primary"
                                   href="${ctx}/pw/pwFassets/changeBroken?id=${pwFassets.id}"
                                   onclick="return confirmx('确认标记损坏吗？', this.href)"
                                >标记损坏</a>
                                <a class="btn btn-small btn-default"
                                   href="${ctx}/pw/pwFassets/delete?id=${pwFassets.id}"
                                   onclick="return confirmx('确认要删除该固定资产吗？', this.href)">删除</a>
                            </c:when>
                            <c:when test="${pwFassets.status == '1'}">
                                <a class="btn btn-small btn-primary"
                                   href="${ctx}/pw/pwFassets/unassign?id=${pwFassets.id}"
                                   onclick="return confirmx('确认取消分配吗？', this.href)">取消分配</a>
                            </c:when>
                            <c:when test="${pwFassets.status == '2'}">
                                <a class="btn btn-small btn-primary"
                                   href="${ctx}/pw/pwFassets/changeUnused?id=${pwFassets.id}">标记闲置</a>
                                <a class="btn btn-small btn-default"
                                   href="${ctx}/pw/pwFassets/delete?id=${pwFassets.id}"
                                   onclick="return confirmx('确认要删除该固定资产吗？', this.href)">删除</a>
                            </c:when>
                        </c:choose>
                    </td>
                </shiro:hasPermission>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    ${page.footer}
</div>
<div id="dialog-message" title="信息">
    <p id="dialog-content"></p>
</div>
</body>
<script>

    /**
     * 根据资产类型查询资产名称
     */
    $("#category1").change(function () {
        var categoryId = $(this).children('option:selected').val();
        if (!categoryId) {
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
                        if (item.id == "${pwFassets.pwCategory.id}") {
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

    /*
     * 复选框全选
     */

    $(function () {
        var $allCheckBox = $(".all-checkbox");
        var $checkboxItem = $('.checkbox-item');
        $allCheckBox.on('change', function () {
            var isChecked = $(this).prop('checked')
            $checkboxItem.prop('checked', isChecked)
        })
        $checkboxItem.on('change', function () {
            var isAllChecked = false;
            $checkboxItem.each(function (t) {
                isAllChecked = true;
                if (!$(this).prop('checked')) {
                    isAllChecked = false;
                    return false;
                }
            })
            $allCheckBox.prop('checked', isAllChecked)
        })
    })


    /**
     * 批量分配资产js
     */
    $("#batchAssign").click(function () {
        var ids = '', me = this, isExit = true;

        //判断选中的全部是闲置
        $(":checkbox:checked").not(".all-checkbox").parents("tr").find("td:eq(9)").each(function (i, item) {
            if (item.innerText !== "闲置") {
                isExit = false;
                return false;
            }
        });

        $(":checkbox:checked").not(".all-checkbox").parents("tr").find("td:eq(1)").each(function (i, item) {
            ids += "," + item.innerHTML;
        });
        if (!ids) {
            alertx("请选择资产");
            return false;
        }
        ;

        if (isExit) {
            $(me).attr("href", "${ctx}/pw/pwFassets/assignForm?fassetsIds=" + ids);
        } else {
            alertx("存在资产不是闲置状态");
        }
        ;


    });


    $(function () {
        var arr = [];
        var $judgetd = $('.judge-td');
        $judgetd.each(function () {
            var a = $(this).children().length;
            arr.push(a);
        });
        var max = Math.max.apply(null, arr);
        var maxIndex;
        //jquery 遍历数组或者对象的方法 第一个参数 索引值
//        $.each(arr, function (i, val) {
//            if(val == max){
//                maxIndex = i;
//                return false;
//            }
//        })

        for (var i = 0, len = arr.length; i < len; i++) {
            if (arr[i] == max) {
                maxIndex = i;
                break;
            }
        }

        var buttons = $judgetd.eq(maxIndex).find('.btn');
        var width = 0;
        buttons.each(function (i, btn) {
            var $btn = $(btn);
            width += $btn.innerWidth() + 2;
        })

        for (var i = 0; i < $judgetd.length; i++) {
            var btn = $judgetd.eq(i).find('.btn');
            for (var j = 0; j < btn.length; j++) {
                var $btn = $(btn).eq(j);
                $(btn).eq(0).css('marginLeft', '4px');
                $btn.css('marginRight', '4px');
            }
        }

        $judgetd.width(width + (buttons.length + 1) * 4).css('fontSize', '0');

//        if(max==4){
//            $judgetd.width(219);
//        }else if(max==3){
//            $judgetd.css({width: '169px'});
//        }else{
//            $judgetd.css({width: '120px'});
//        }

    })


</script>
</html>