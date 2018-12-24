<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <link rel="stylesheet" href="/css/cyjd/tree.css">
    <!-- <meta name="decorator" content="default"/> -->
    <%--<%@include file="/WEB-INF/views/include/backtable.jsp" %>--%>
    <script src="${ctxStatic}/common/mustache.min.js" type="text/javascript"></script>
    <script src="${ctxStatic}/common/initiate.js" type="text/javascript"></script>
    <%@include file="/WEB-INF/views/include/treetable.jsp" %>
    <script type="text/javascript">
        console.log('${fns:toJson(list)}')
        $(document).ready(function () {
            var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
            var data = ${fns:toJson(list)}, ids = [], rootIds = [];
            for (var i = 0; i < data.length; i++) {
                ids.push(data[i].id);
            }
            ids = ',' + ids.join(',') + ',';
            for (var i = 0; i < data.length; i++) {
                if (ids.indexOf(',' + data[i].parentId + ',') == -1) {
                    if ((',' + rootIds.join(',') + ',').indexOf(',' + data[i].parentId + ',') == -1) {
                        rootIds.push(data[i].parentId);
                    }
                }
            }
            for (var i = 0; i < rootIds.length; i++) {
                addRow("#treeTableList", tpl, data, rootIds[i], true);
            }
            $("#treeTable").treeTable({expandLevel: 5});
        });

        function addRow(list, tpl, data, pid, root) {
            for (var i = 0; i < data.length; i++) {
                var row = data[i];
                if ((${fns:jsGetVal('row.parentId')}) == pid) {
                    $(list).append(Mustache.render(tpl, {
                        dict: {
                            isRoot: row.id == '1',
                            notRoot: !(row.id == '1'),
                            canAdd: row.parentIds.split(",").length < 4,
                            rule: example(row),
                            blank123: 0
                        }, pid: (root ? 0 : pid), row: row
                    }));
                    addRow(list, tpl, data, row.id);
                }
            }
        }

        function prefixZero(num, length) {
            return (Array(length).join('0') + num).slice(-length);
        }

        function example(row) {
            if(row.parentIds.split(",").length >= 4){
                var parentPrefix = row.parentPrefix;
                var prefix = row.pwFassetsnoRule.prefix;
                var startNumber = row.pwFassetsnoRule.startNumber;
                var numberLen = row.pwFassetsnoRule.numberLen;
                if(parentPrefix && startNumber && numberLen){
//                    var parentPrefix = row.parent.pwFassetsnoRule.prefix;
                    return parentPrefix + prefix + prefixZero(parseInt(startNumber), parseInt(numberLen));
                }
            }
            return '';
        }
    </script>
</head>
<body>
<div class="container-fluid">
    <div class="edit-bar clearfix">
        <div class="edit-bar-left">
            <span>资产类别</span>
            <i class="line weight-line"></i>
        </div>
    </div>
    <ul class="nav nav-tabs nav-tabs-default">
        <li class="active"><a href="${ctx}/pw/pwCategory/">资产类别列表</a></li>
        <shiro:hasPermission name="pw:pwCategory:edit">
            <li><a href="${ctx}/pw/pwCategory/form">资产类别添加</a></li>
        </shiro:hasPermission>
    </ul>
    <div class="tab-content-default">
        <form:form id="searchForm" modelAttribute="pwCategory" action="${ctx}/pw/pwCategory/" method="post"
                   class="form-horizontal form-search-block">
            <div class="col-control-group">
                <div class="control-group">
                    <label class="control-label">名称</label>
                    <div class="controls">
                        <form:input class="input-medium" path="name" htmlEscape="false" maxlength="100"/>
                    </div>
                </div>
            </div>
            <div class="search-btn-box">
                <button type="submit" class="btn btn-primary">查询</button>
            </div>
        </form:form>
        <sys:message content="${message}"/>
        <table id="treeTable"
               class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
            <thead>
            <tr>
                <th width="260">名称</th>
                <th width="180">最后更新时间</th>
                <th>编号规则示例</th>
                <shiro:hasPermission name="pw:pwCategory:edit">
                    <th width="250">操作</th>
                </shiro:hasPermission>
            </tr>
            </thead>
            <tbody id="treeTableList"></tbody>
        </table>
    </div>
    <div id="dialog-message" title="信息">
        <p id="dialog-content"></p>
    </div>
</div>
<script type="text/template" id="treeTableTpl">
    <tr id="{{row.id}}" pId="{{pid}}">
        <td>
            {{#dict.notRoot}} <a href="${ctx}/pw/pwCategory/details?id={{row.id}}">{{/dict.notRoot}}
            {{row.name}}</a>
        <td>
            {{row.updateDate}}
        </td>
        <td>
                {{dict.rule}}
        </td>
        <shiro:hasPermission name="pw:pwCategory:edit">
            <td>
                {{#dict.canAdd}}
                <a class="btn btn-small btn-primary" href="${ctx}/pw/pwCategory/form?parent.id={{row.id}}">添加子类别</a>
                {{/dict.canAdd}}
                {{#dict.notRoot}}
                <a class="btn btn-small btn-primary" href="${ctx}/pw/pwCategory/form?id={{row.id}}">修改</a>
                <a class="btn btn-small btn-default" href="${ctx}/pw/pwCategory/delete?id={{row.id}}"
                   onclick="return confirmx('确认要删除该资产类别及所有子资产类别吗？', this.href)">删除</a>
                {{/dict.notRoot}}
            </td>
        </shiro:hasPermission>
    </tr>
</script>
</body>
</html>