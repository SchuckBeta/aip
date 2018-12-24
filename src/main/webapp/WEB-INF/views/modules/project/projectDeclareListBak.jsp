<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<html>
<head>
    <meta name="decorator" content="site-decorator"/>
    <title>${frontTitle}</title>
    <%--<link rel="stylesheet" type="text/css" href="/common/common-css/Gctable.css">--%>
    <script src="/static/common/initiate.js?v=1"></script>
    <script src="/js/Projectlist.js"></script> 
    <script type="text/javascript">
        $(document).ready(function () {
            $("#ps").val($("#pageSize").val());
            $('#content').css('min-height', function () {
                return $(window).height() - $('.header').height() - $('.footerBox').height()
            });
            $('.pagination_num').removeClass('row');
        });
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }
    </script>
    <style type="text/css">

        .table > tbody > tr > td, .table > tbody > tr > th, .table > tfoot > tr > td, .table > tfoot > tr > th, .table > thead > tr > td, .table > thead > tr > th {
            vertical-align: middle;
        }

        .table > tbody > tr > td, .table > tbody > tr > th, .table > tfoot > tr > td, .table > tfoot > tr > th, .table > thead > tr > td, .table > thead > tr > th {
            text-align: center;
        }
        .btn-current-project{
            color: #4b4b4b;
            background-color: #bebebe;
        }
        .project-name{
            display: block;
            max-width: 300px;
            margin: 0 auto;
            overflow: hidden;
        }
    </style>
</head>
<body>
<form:form id="searchForm" modelAttribute="projectDeclare"
           action="${ctx}/project/projectDeclare/list" method="post">
    <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
    <input id="pageSize" name="pageSize" type="hidden"
           value="${page.pageSize}"/>
</form:form>
<div class="container-fluid container-fluid-oe">
    <div class="text-right mgb15">
        <a href="curProject" class="btn btn-current-project">当前项目</a>
        <a href="list" class="btn btn-primary-oe">我的项目列表</a>
    </div>
    <div class="project-list-row">
        <h4 class="front-table-title">我的项目列表</h4>
        <div class="front-table-wrap">
            <%--<div class="table-responsive-big">--%>
            <table class="table table-bordered table-front-default-thead text-center table-vertical-middle table-condensed">
                <thead>
                <tr>
                    <th>项目编号</th>
                    <th style="width:20%;">项目名称</th>
                    <th>项目类型</th>
                    <th>项目类别</th>
                    <th>负责人</th>
                    <th>组人数</th>
                    <th>项目导师</th>
                    <th>申报时间</th>
                    <th>项目状态</th>
                    <th>立项结果</th>
                    <th>项目结果</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${page.list}" var="projectDeclare">
                    <tr>
                        <td>${projectDeclare.number }</td>
                        <td style="word-break: break-all">
                            <c:choose>
                                <c:when test="${projectDeclare.ftb==0}">
                                    <a class="project-name" href="${ctx}/project/projectDeclare/viewForm?id=${projectDeclare.id}">${projectDeclare.project_name }</a>
                                </c:when>
                                <c:otherwise>
                                    <a class="project-name" href="${ctx}/promodel/proModel/viewForm?id=${projectDeclare.id}">${projectDeclare.project_name }</a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${projectDeclare.proTypeStr }</td>
                        <td>${projectDeclare.type }</td>
                        <td>${projectDeclare.leader }</td>
                        <td class="renshu">${projectDeclare.snames }</td>
                            <%--组人数--%>
                        <td>${projectDeclare.tnames }</td>
                        <td>${projectDeclare.apply_time }</td>
                        <td>
                        	<c:if test="${projectDeclare.proc_ins_id==null||projectDeclare.proc_ins_id==''}">
                        		${projectDeclare.status }
                        	</c:if>
	                        <c:if test="${projectDeclare.proc_ins_id!=null&&projectDeclare.proc_ins_id!=''}">
	                                <c:choose>
	                                    <c:when test="${projectDeclare.status_code eq '-999'}">
	                                        <c:choose>
	                                            <c:when test="${projectDeclare.state!=null && projectDeclare.state eq '1'}">
	                                                <a href="${ctx}/actyw/actYwGnode/designView?groupId=${projectDeclare.groupId}&proInsId=${projectDeclare.proc_ins_id}&grade=1"
	                                                    target="_blank">${projectDeclare.status }</a>
	                                            </c:when>
	                                            <c:otherwise>
	                                                <a href="${ctx}/actyw/actYwGnode/designView?groupId=${projectDeclare.groupId}&proInsId=${projectDeclare.proc_ins_id}"
	                                                                                                   target="_blank">${projectDeclare.status }</a>
	                                            </c:otherwise>
	                                        </c:choose>
	                                    </c:when>
	                                    <c:otherwise>
	                                        <a href="${ctx}/actyw/actYwGnode/designView/${projectDeclare.status_code}?groupId=${projectDeclare.groupId}"
	                                            target="_blank">${projectDeclare.status }</a>
	                                    </c:otherwise>
	                                </c:choose>
	                            </c:if>
                        </td>
                        <td>${fns:getDictLabel(projectDeclare.setResult, "0000000151", "")}</td>
                        <td>${projectDeclare.final_result }</td>
                        <td style="white-space: nowrap">
                            <c:if test="${projectDeclare.leaderId==user.id}">
                                <c:if test="${projectDeclare.status_code==null||projectDeclare.status_code==0}">
                                    <c:choose>
                                        <c:when test="${projectDeclare.ftb==0}">
                                            <a class="btn btn-primary-oe btn-sm"
                                               href="${ctx}/project/projectDeclare/form?id=${projectDeclare.id}">继续完善</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="btn btn-primary-oe btn-sm"
                                               href="${ctx}/promodel/proModel/form?id=${projectDeclare.id}">继续完善</a>
                                        </c:otherwise>
                                    </c:choose>
                                    <a class="btn btn-default-oe btn-sm"
                                       href="javascript:void(0);"
                                       onclick="delPro('${projectDeclare.id}','${projectDeclare.ftb}')">删除</a>
                                </c:if>
                            </c:if>
                            <a class="btn btn-primary-oe btn-sm"
                               href="${ctx}/excellent/projectShowForm?projectId=${projectDeclare.id}&ftb=${projectDeclare.ftb}">展示</a>
                                <%--<c:if test="${projectDeclare.hasConfig == 'true' }">
                                    <a  class="buttom btn" href="/f/project/projectDeclare/scoreConfig?projectId=${projectDeclare.id}" >学分配比</a>
                                </c:if>--%>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <%--</div>--%>
            ${page.footer}
        </div>
    </div>
</div>
<script>
    $(function () {
        $('.renshu').each(function (i, item) {
            var texts = $(item).text();
            if (texts) {
                var num = texts.split('/')
                $(item).text(num.length)
            }
        })
    })
</script>
</body>
</html>