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
    <link href="${ctxStatic}/jquery-treetable/css/jquery.treetable.css" rel="stylesheet" type="text/css"/>
    <script src="${ctxStatic}/jquery-treetable/jquery.treetable.js" type="text/javascript"></script>
    <%--<%@include file="/WEB-INF/views/include/treetable.jsp" %>--%>
    <style>
        .branch.expanded .indenter a {
            background: url(/images/treetableallbgs.gif) no-repeat 0 1px;;
        }

        .branch.expanded .indenter a:hover {
            background: url(/images/treetableallbgs.gif) no-repeat -32px 1px;
        }

        .branch.collapsed .indenter a {
            background: url(/images/treetableallbgs.gif) no-repeat -16px 1px;
        }

        .branch.collapsed .indenter a:hover {
            background: url(/images/treetableallbgs.gif) no-repeat -48px 1px;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {

            var data = ${fns:toJson(list)};
            var timer = null;
            var $treeTable = $("#treeTable");
            var $expandName = $('input[name="expand"]');
            var $treeTableList = $('#treeTableList');
            var treeTable;

            function genTreeTable(data) {
                var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                var ids = [], rootIds = []
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
                treeTable = $treeTable.treetable({
                    'expandable': true,
                    'initialState': 'expandAll'
                });
            }

            //生成html
            genTreeTable(data);

            $expandName.on('click', function () {
                treeTable.treetable($(this).prop('checked') ? 'collapseAll' : 'expandAll');
            });

            $('input[name="name"]').on('input propertychange', function () {
                var $this = $(this);
                timer && clearTimeout(timer);
                timer = setTimeout(function () {
                    var val = $this.val();
                    var regVal = new RegExp(val);
                    var list = data.filter(function (t) {
//                        console.log(t.name,  regVal.test(t.name))
                        return regVal.test(t.name);
                    });
//                    $.each(data, function (i, t) {
//                        if(regVal.test(t.name)){
////                            console.log(regVal.test(t.name), t)
//                            list.push(t)
//                        }
//                    })


                    $expandName.prop('checked', false);
                    $treeTableList.empty();
                    //destroy tree table
                    $treeTable.removeData('treetable').removeClass('treetable');
                    genTreeTable(list);
                }, 100)
            })

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
            if (row.parentIds.split(",").length >= 4) {
                var parentPrefix = row.parentPrefix;
                var prefix = row.pwFassetsnoRule.prefix;
                var startNumber = row.pwFassetsnoRule.startNumber;
                var numberLen = row.pwFassetsnoRule.numberLen;
                if (parentPrefix && startNumber && numberLen) {
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
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>资产类别管理</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <form:form id="searchForm" modelAttribute="pwCategory"
               class="form-horizontal form-search-block">
        <div class="col-control-group">
            <%--<div class="control-group">--%>
                <%--<label class="checkbox inline">--%>
                    <%--<input type="checkbox" name="expand">只显示父类别--%>
                <%--</label>--%>
            <%--</div>--%>
            <div class="control-group">
                <%--<label class="control-label"></label>--%>
                <div class="controls">
                    <form:input class="input-medium" path="name" htmlEscape="false" maxlength="100" autocomplete="off"
                                placeholder="资产类别模糊搜索"/>
                </div>
            </div>

            <div class="text-right mgb15">
                <shiro:hasPermission name="pw:pwCategory:edit">
                    <a class="btn btn-primary" href="${ctx}/pw/pwCategory/form?parent.id=1">添加父类别</a>
                </shiro:hasPermission>
            </div>
        </div>
    </form:form>
    <sys:message content="${message}"/>
    <table id="treeTable"
           class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">
        <thead>
        <tr>
            <th width="260">资产类别</th>
            <%--<th width="180">最后更新时间</th>--%>
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
<script type="text/template" id="treeTableTpl">
    <tr id="{{row.id}}" pId="{{pid}}" data-tt-id="{{row.id}}" data-tt-parent-id="{{pid}}">
        <td>
            {{#dict.notRoot}} <a href="${ctx}/pw/pwCategory/details?id={{row.id}}">{{/dict.notRoot}}
            {{row.name}}</a>
            <%--<td>--%>
            <%--{{row.updateDate}}--%>
            <%--</td>--%>
        <td>
            {{dict.rule}}
        </td>
        <shiro:hasPermission name="pw:pwCategory:edit">
            <td style="text-align:right;">
                {{#dict.canAdd}}
                <a class="btn btn-small btn-primary" href="${ctx}/pw/pwCategory/form?parent.id={{row.id}}&secondName=添加子类别">添加子类别</a>
                {{/dict.canAdd}}
                {{#dict.notRoot}}
                <a class="btn btn-small btn-primary" href="${ctx}/pw/pwCategory/form?id={{row.id}}&secondName=修改">修改</a>
                <a class="btn btn-small btn-default" style="margin-right: 35px;"
                   href="${ctx}/pw/pwCategory/delete?id={{row.id}}"
                   onclick="return confirmx('确认要删除该资产类别及所有子资产类别吗？', this.href)">删除</a>
                {{/dict.notRoot}}
            </td>
        </shiro:hasPermission>
    </tr>
</script>
</body>
</html>