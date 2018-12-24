<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <link rel="stylesheet" href="/css/cyjd/tree.css?v=2">

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
        <%--<shiro:hasPermission name="pw:pwCategory:edit">--%>
        <%--<li><a href="${ctx}/pw/pwCategory/form">资产类别添加</a></li>--%>
        <%--</shiro:hasPermission>--%>
    </ul>
    <div class="tab-content-default">
        <form:form id="searchForm" modelAttribute="pwCategory" action="${ctx}/pw/pwCategory/" method="post"
                   class="form-horizontal form-search-block">
            <div class="col-control-group">
                <div class="control-group">
                    <div class="controls">
                        <form:input class="input-medium" path="name" htmlEscape="false" maxlength="100"
                                    placeholder="资产类别模糊搜索"/>
                        <i class="icon icon-search"></i>
                    </div>
                </div>
            </div>
            <div class="search-btn-box">
                <input type="checkbox" id="all-hide"><span class="all-down">只显示父类别</span>
                <a class="btn btn-primary" href="${ctx}/pw/pwCategory/form?parent.id=1">添加父类别</a>
            </div>
        </form:form>
        <sys:message content="${message}"/>


        <div class="tree-head root-div root-border-bottom">
            <span class="root-name">名称</span>
            <span class="root-time">更新时间</span>
            <span class="root-example">编码规则示例</span>
            <span class="root-button">操作</span>
        </div>

        <div id="tree" style="margin-bottom: 0px;">

        </div>
    </div>
    <div id="dialog-message" title="信息">
        <p id="dialog-content"></p>
    </div>
</div>
<script>
    $(function () {

        var $tree = $('#tree');
        var spaceList = '${fns:toJson(list)}';
        var hasRoot = false;
        spaceList = JSON.parse(spaceList);
        hasRoot = hasRootId();
        console.log(spaceList)
        function hasRootId() {
            var list = spaceList.filter(function (t) {
                        return t.parentId == '1'
                    }) || []
            return list.length > 0
        }

        function treeFormat(rootId) {
            var id, parentId, children = {}, item;
            var tree = [];

            for (var i = 0, len = spaceList.length; i < len; i++) {
                item = spaceList[i];
                id = item.id;
                parentId = item.parentId || rootId;
                children[id] = children[id] || [];
                item.children = children[id];
                item.hasChildren = item['children'].length > 0;
                if (parentId != rootId) {
                    if(hasParentId( spaceList[i].parentId)){
                        children[parentId] = children[parentId] || [];
                        children[parentId].push(item)
                    }else {
                        tree.push(spaceList[i])
                    }

                } else {
                        tree.push(item)
                }
            }
            return tree;
        }

        function hasParentId(parentId){
            var list = spaceList.filter(function(t){
                return t.id === parentId;
            }) || [];
            return list.length > 0
        }


        function genTree(space, id) {
            var ul = '<ul data-id="' + id + '" class="tree-school-root"">';
            space.forEach(function (item) {
                var parentIds = item.parentIds;
                var span = '';
                var parentId = item.parentId;
                var alabel = '';
                parentIds = parentIds.replace(/\,$/, '');
                parentIds = parentIds.split(',');
                parentIds.forEach(function (t, i) {
                    if (i > 1 && t) {
                        span += '<span style="display:inline-block;width:40px;height:20px;padding-top:2px;"></span>'
                    }
                })

//
                if (item.hasChildren) {
                    span += '<a href="#" class="solid-img-a"><img class="solid-down-img" style="width:20px;margin-top:-6px;" src="/images/solid-down.png" alt=""></a>'
                }
                if (parentId == 1) {
                    alabel = '<a class="root-alabel-add btn btn-small btn-primary" style="margin-right:10px;" href="' + ctx + '/pw/pwCategory/form?parent.id=' + item.id + '">添加子类别</a>';
                }

                var prefixZeroStr = parentId != 1 ? prefixZero(item.pwFassetsnoRule.startNumber * 1, item.pwFassetsnoRule.numberLen * 1) : '';
                ul += '<li><div class="root-div root-center root-hover root-border-bottom"><span class="root-name">' + span + '<a class="school-topic" href="' + ctx + '/pw/pwCategory/details?id=' + item.id + '">' + item.name + '</a></span>' +
                        '<span class="root-time">' + item.updateDate + '</span>' +
                        '<span class="root-example">' + (parentId != 1 ? (item.parentPrefix || '') : '') + (parentId != 1 ? (item.pwFassetsnoRule.prefix || '') : '') + prefixZeroStr + '</span>' +
                        '<span class="root-button">' + alabel + '<a class="root-alabel-change btn btn-small btn-primary" href="' + ctx + '/pw/pwCategory/form?id=' + item.id + '">修改</a>' +
                        '<a class="root-alabel-delete btn btn-small btn-default"  href="' + ctx + '/pw/pwCategory/delete?id=' + item.id + '">删除</a></span></div>';
                if (item.children && item.children.length > 0) {
                    ul += genTree(item.children, item.parentId) + '</li>';
                }
            })
            ul += '</ul>';
            return ul;
        }

        function prefixZero(num, length) {
            if (!length || !num) {
                return '';
            }
            return (Array(length).join('0') + num).slice(-length);
        }

        initTree();

        function initTree() {
            var treeList = hasRoot ? treeFormat('1') : spaceList;
            var treeHtml = genTree(treeList, '0');

            $('#tree').html(treeHtml)
        }


//            $tree.find('ul[data-id="1"]').slideUp();
//           $tree.on('click', '.school-topic', function (e) {
//                e.preventDefault(); //阻止默认事件
//                var $this = $(this); //当前的element jquery对象
//                var $childUl = $this.parent().parent().next();
//                $childUl.slideToggle();
//                // sildeUp slideDown
//            })
        $('.root-alabel-delete').click(function (e) {
            e.preventDefault()
            var href = $(this).attr('href');
            confirmx('确认要删除该资产类别及所有子资产类别吗？', href);
            return false;
        });


//        $('.tab-content-default').on('click', '.all-hide', function (e) {
//                e.preventDefault();
//                $tree.find('ul[data-id="1"]').slideUp();
//                $('.solid-down-img').addClass('img-close').attr('src', '/images/solid-right.png')
//        })

//        $('.tab-content-default').on('click', '#all-hide', function (e) {
//            if($('.solid-down-img').attr('src')=='/images/solid-down.png'){
//                e.preventDefault();
//                $tree.find('ul[data-id="1"]').slideUp();
//                $('.solid-down-img').addClass('img-close').attr('src', '/images/solid-right.png')
//            }else{
//                e.preventDefault();
//                $tree.find('ul[data-id="1"]').slideDown();
//                $('.solid-down-img').removeClass('img-close').attr('src', '/images/solid-down.png')
//            }
//
//        })

        $('#all-hide').on('change', function () {
            if ($(this).prop('checked')) {
                $tree.find('ul[data-id="1"]').slideUp();
                $('.solid-down-img').addClass('img-close').attr('src', '/images/solid-right.png')
            } else {
                $tree.find('ul[data-id="1"]').slideDown();
                $('.solid-down-img').removeClass('img-close').attr('src', '/images/solid-down.png')
            }
        })


        $tree.on('click', '.solid-down-img', function (e) {
            e.preventDefault(); //阻止默认事件
            var $this = $(this); //当前的element jquery对象
            var $childUl = $this.parent().parent().parent().next();
            $childUl.slideToggle();
            // sildeUp slideDown
        })


        $('.solid-down-img').click(function () {

            $(this).toggleClass('img-close')
            $(this).attr('src', $(this).hasClass('img-close') ? '/images/solid-right.png' : '/images/solid-down.png')

        });


    });
</script>
</body>
</html>


<%--<%@ page contentType="text/html;charset=UTF-8" %>--%>
<%--<%@ include file="/WEB-INF/views/include/taglib.jsp" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html>--%>
<%--<head>--%>
<%--<title>${backgroundTitle}</title>--%>
<%--<%@include file="/WEB-INF/views/include/backcyjd.jsp" %>--%>
<%--<link rel="stylesheet" href="/css/cyjd/tree.css">--%>
<%--<!-- <meta name="decorator" content="default"/> -->--%>
<%--&lt;%&ndash;<%@include file="/WEB-INF/views/include/backtable.jsp" %>&ndash;%&gt;--%>
<%--<script src="${ctxStatic}/common/mustache.min.js" type="text/javascript"></script>--%>
<%--<script src="${ctxStatic}/common/initiate.js" type="text/javascript"></script>--%>
<%--<%@include file="/WEB-INF/views/include/treetable.jsp" %>--%>
<%--<script type="text/javascript">--%>
<%--console.log('${fns:toJson(list)}')--%>
<%--$(document).ready(function () {--%>
<%--var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");--%>
<%--var data = ${fns:toJson(list)}, ids = [], rootIds = [];--%>
<%--for (var i = 0; i < data.length; i++) {--%>
<%--ids.push(data[i].id);--%>
<%--}--%>
<%--ids = ',' + ids.join(',') + ',';--%>
<%--for (var i = 0; i < data.length; i++) {--%>
<%--if (ids.indexOf(',' + data[i].parentId + ',') == -1) {--%>
<%--if ((',' + rootIds.join(',') + ',').indexOf(',' + data[i].parentId + ',') == -1) {--%>
<%--rootIds.push(data[i].parentId);--%>
<%--}--%>
<%--}--%>
<%--}--%>
<%--for (var i = 0; i < rootIds.length; i++) {--%>
<%--addRow("#treeTableList", tpl, data, rootIds[i], true);--%>
<%--}--%>
<%--$("#treeTable").treeTable({expandLevel: 5});--%>
<%--});--%>

<%--function addRow(list, tpl, data, pid, root) {--%>
<%--for (var i = 0; i < data.length; i++) {--%>
<%--var row = data[i];--%>
<%--if ((${fns:jsGetVal('row.parentId')}) == pid) {--%>
<%--$(list).append(Mustache.render(tpl, {--%>
<%--dict: {--%>
<%--isRoot: row.id == '1',--%>
<%--notRoot: !(row.id == '1'),--%>
<%--canAdd: row.parentIds.split(",").length < 4,--%>
<%--rule: example(row),--%>
<%--blank123: 0--%>
<%--}, pid: (root ? 0 : pid), row: row--%>
<%--}));--%>
<%--addRow(list, tpl, data, row.id);--%>
<%--}--%>
<%--}--%>
<%--}--%>

<%--function prefixZero(num, length) {--%>
<%--return (Array(length).join('0') + num).slice(-length);--%>
<%--}--%>

<%--function example(row) {--%>
<%--if(row.parentIds.split(",").length >= 4){--%>
<%--var parentPrefix = row.parentPrefix;--%>
<%--var prefix = row.pwFassetsnoRule.prefix;--%>
<%--var startNumber = row.pwFassetsnoRule.startNumber;--%>
<%--var numberLen = row.pwFassetsnoRule.numberLen;--%>
<%--if(parentPrefix && startNumber && numberLen){--%>
<%--//                    var parentPrefix = row.parent.pwFassetsnoRule.prefix;--%>
<%--return parentPrefix + prefix + prefixZero(parseInt(startNumber), parseInt(numberLen));--%>
<%--}--%>
<%--}--%>
<%--return '';--%>
<%--}--%>
<%--</script>--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="container-fluid">--%>
<%--<div class="edit-bar clearfix">--%>
<%--<div class="edit-bar-left">--%>
<%--<span>资产类别</span>--%>
<%--<i class="line weight-line"></i>--%>
<%--</div>--%>
<%--</div>--%>
<%--<ul class="nav nav-tabs nav-tabs-default">--%>
<%--<li class="active"><a href="${ctx}/pw/pwCategory/">资产类别列表</a></li>--%>
<%--<shiro:hasPermission name="pw:pwCategory:edit">--%>
<%--<li><a href="${ctx}/pw/pwCategory/form">资产类别添加</a></li>--%>
<%--</shiro:hasPermission>--%>
<%--</ul>--%>
<%--<div class="tab-content-default">--%>
<%--<form:form id="searchForm" modelAttribute="pwCategory" action="${ctx}/pw/pwCategory/" method="post"--%>
<%--class="form-horizontal form-search-block">--%>
<%--<div class="col-control-group">--%>
<%--<div class="control-group">--%>
<%--<label class="control-label">名称</label>--%>
<%--<div class="controls">--%>
<%--<form:input class="input-medium" path="name" htmlEscape="false" maxlength="100"/>--%>
<%--</div>--%>
<%--</div>--%>
<%--</div>--%>
<%--<div class="search-btn-box">--%>
<%--<button type="submit" class="btn btn-primary">查询</button>--%>
<%--</div>--%>
<%--</form:form>--%>
<%--<sys:message content="${message}"/>--%>
<%--<table id="treeTable"--%>
<%--class="table table-bordered table-condensed table-hover table-center table-orange table-nowrap">--%>
<%--<thead>--%>
<%--<tr>--%>
<%--<th width="260">名称</th>--%>
<%--<th width="180">最后更新时间</th>--%>
<%--<th>编号规则示例</th>--%>
<%--<shiro:hasPermission name="pw:pwCategory:edit">--%>
<%--<th width="250">操作</th>--%>
<%--</shiro:hasPermission>--%>
<%--</tr>--%>
<%--</thead>--%>
<%--<tbody id="treeTableList"></tbody>--%>
<%--</table>--%>
<%--</div>--%>
<%--<div id="dialog-message" title="信息">--%>
<%--<p id="dialog-content"></p>--%>
<%--</div>--%>
<%--</div>--%>
<%--<script type="text/template" id="treeTableTpl">--%>
<%--<tr id="{{row.id}}" pId="{{pid}}">--%>
<%--<td>--%>
<%--{{#dict.notRoot}} <a href="${ctx}/pw/pwCategory/details?id={{row.id}}">{{/dict.notRoot}}--%>
<%--{{row.name}}</a>--%>
<%--<td>--%>
<%--{{row.updateDate}}--%>
<%--</td>--%>
<%--<td>--%>
<%--{{dict.rule}}--%>
<%--</td>--%>
<%--<shiro:hasPermission name="pw:pwCategory:edit">--%>
<%--<td>--%>
<%--{{#dict.canAdd}}--%>
<%--<a class="btn btn-small btn-primary" href="${ctx}/pw/pwCategory/form?parent.id={{row.id}}">添加子类别</a>--%>
<%--{{/dict.canAdd}}--%>
<%--{{#dict.notRoot}}--%>
<%--<a class="btn btn-small btn-primary" href="${ctx}/pw/pwCategory/form?id={{row.id}}">修改</a>--%>
<%--<a class="btn btn-small btn-default" href="${ctx}/pw/pwCategory/delete?id={{row.id}}"--%>
<%--onclick="return confirmx('确认要删除该资产类别及所有子资产类别吗？', this.href)">删除</a>--%>
<%--{{/dict.notRoot}}--%>
<%--</td>--%>
<%--</shiro:hasPermission>--%>
<%--</tr>--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>