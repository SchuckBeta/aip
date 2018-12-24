<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
        <script type="text/javascript">
    $frontOrAdmin="${frontOrAdmin_2ed8fe6ddd034cffa47a41e42a694948}";
    </script>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script type="text/javascript" src="/js/backTable/sort.js"></script><!--排序js-->

    <script type="text/javascript" src="/js/cyjd/checkall.js"></script>
    <script type="text/javascript" src="/js/cyjd/publishExPro.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#ps").val($("#pageSize").val());
            $('input[data-toggle="checkall"], input[data-toggle="checkitem"]').on('change', function () {
                $('.expbtn').prop('disabled', !window['checkAllInstance'].someChecked())
            })
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
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <a class="btn btn-small btn-default" href="${ctx}/state/projectDeleteAll"
                                  onclick="return confirmx('会删除所有项目相关信息,确认要删除吗？', this.href)">删除</a>
</div>
<script>
	$(document).ready(function () {
        getExpInfo();
    });

</script>
</body>
</html>