<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<html>
<head>
    <title>${frontTitle}</title>
    <meta name="decorator" content="site-decorator"/>
    <link rel="stylesheet" href="/common/dialog/dialog.css">
    <script type="text/javascript" src="/js/frontCyjd/frontCommon.js"></script>
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
    <style>
        /*a.btn+a{*/
        /*margin-top: 4px;*/
        /*}*/


        .btn-current-project {
            color: #4b4b4b;
            background-color: #bebebe;
        }

        .project-name {
            display: block;
            max-width: 300px;
            margin: 0 auto;
            overflow: hidden;
        }

    </style>
</head>
<body>
<div id="dialogCyjd" class="dialog-cyjd"></div>
<div class="container-fluid container-fluid-oe">
    <div class="text-right mgb15">
        <a href="${ctx}/gcontest/gContest/viewList" class="btn btn-current-project">当前大赛</a>
        <a href="${ctx}/gcontest/gContest/" class="btn btn-primary-oe">我的大赛列表</a>
    </div>

    <div class="project-list-row">
        <h4 class="front-table-title">我的大赛列表</h4>
        <div class="front-table-wrap">
            <%--<div class="table-responsive">--%>
            <table id="matchTable"  class="table table-bordered table-front-default-thead table-hover text-center table-vertical-middle table-condensed">
                <thead>
                <tr>
                    <%--<th>序号</th>--%>
                    <th>大赛编号</th>
                    <th>大赛项目名称</th>
                    <th>大赛类型</th>
                    <th>大赛类别</th>
                    <th>负责人</th>
                    <%--<th>组成员</th>--%>
                    <th>指导老师</th>
                    <th>参赛组别</th>
                    <th>当前赛制</th>
                    <th>当前赛况</th>
                    <th>荣获奖项</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${page.list}" var="gContest" varStatus="state">
                    <tr>
                            <%--<td>${state.count}</td>--%>
                        <td>${gContest.competitionNumber}</td>
                        <td>
                            <c:choose>
                                <c:when test="${gContest.ftb==0}">
                                    <a class="project-name"
                                       href="${ctx}/gcontest/gContest/viewForm?id=${gContest.id}">${gContest.pName}</a>
                                </c:when>
                                <c:otherwise>
                                    <a class="project-name"
                                       href="${ctx}/promodel/proModel/viewForm?id=${gContest.id}">${gContest.pName}</a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${gContest.proTypeStr }</td>
                        <td>
                                ${fns:getDictLabel(gContest.type, "competition_net_type", "")}
                        </td>
                        <td>${gContest.declareName}</td>
                            <%--<td>${gContest.snames }</td>--%>
                        <td>${gContest.tnames }</td>
                        <td>

                            <c:choose>
                                <c:when test="${gContest.ftb==0}">
                                    ${fns:getDictLabel(gContest.level, "gcontest_level", "")}
                                </c:when>
                                <c:otherwise>
                                </c:otherwise>
                            </c:choose>

                        </td>
                        <td>

                            <c:choose>
                                <c:when test="${gContest.ftb==0}">
                                    ${gContest.currentSystem}
                                </c:when>
                                <c:otherwise>
                                    ${fns:getDictLabel(gContest.level, "competition_format", "")}
                                </c:otherwise>
                            </c:choose>


                        </td>
                        <td>
                                ${gContest.auditState}

                        </td>
                        <td>
                            <c:if test="${gContest.schoolendResult!=null}">
                                ${fns:getDictLabel(gContest.schoolendResult, "competition_college_prise", "")}
                            </c:if>
                        </td>
                        <td style="white-space: nowrap">

                            <c:if test="${gContest.declareId==user.id}">
                                <c:if test="${empty gContest.proc_ins_id}">
                                    <a class="btn btn-primary-oe btn-sm"
                                       href="${ctx}/gcontest/gContest/form?id=${gContest.id}">编辑</a>
                                    <a data-name="${gContest.pName}" class="btn btn-delete-match btn-default btn-sm"
                                       href="${ctx}/gcontest/gContest/delete?id=${gContest.id}">删除</a>
                                </c:if>

                            </c:if>

                            <c:if test="${not empty gContest.proc_ins_id}">
                                <c:choose>
                                    <c:when test="${gContest.auditCode eq '-999'}">


                                        <c:choose>
                                            <c:when test="${gContest.state !=null && gContest.state eq '1'}">
                                                <a href="${ctx}/actyw/actYwGnode/designView?groupId=${gContest.groupId}&proInsId=${gContest.proc_ins_id}&grade=1"
                                                   class="btn btn-primary-oe btn-sm" target="_blank">跟踪</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${ctx}/actyw/actYwGnode/designView?groupId=${gContest.groupId}&proInsId=${gContest.proc_ins_id}"
                                                   class="btn btn-primary-oe btn-sm" target="_blank">跟踪</a>
                                            </c:otherwise>
                                        </c:choose>
                                        <%-- <a href="${ctx}/actyw/actYwGnode/designView?groupId=${gContest.groupId}&proInsId=${gContest.proc_ins_id}"
                                            class="btn btn-primary-oe btn-sm" target="_blank">跟踪</a>--%>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${ctx}/actyw/actYwGnode/designView/${gContest.auditCode}?groupId=${gContest.groupId}"
                                           class="btn btn-primary-oe btn-sm" target="_blank">跟踪</a>
                                    </c:otherwise>
                                </c:choose>

                                <%--<a href="${ctx}/act/task/processMapByType?proInsId=${gContest.proc_ins_id}&type=ds&status=${gContest.auditCode}" target="_blank" class="btn btn-primary-oe btn-sm">跟踪</a>--%>
                                <%--a href="${ctx}/actyw/actYwGnode/designView/${gContest.auditCode}?groupId=${gContest.groupId}" class="btn btn-primary-oe btn-sm" target="_blank">跟踪</a>--%>
                            </c:if>
                            <a class="btn btn-primary-oe btn-sm"
                               href="${ctx}/excellent/gcontestShowForm?gcontestId=${gContest.id}">展示</a>
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
        $('#matchTable').on('click', 'a.btn-delete-match', function (e) {
            e.preventDefault();
            var name = $(this).data('name');
            var $this = $(this);
            var href = $this.attr('href');
            dialogCyjd.createDialog(0, '是否删除'+name+'大赛？', {
                buttons: [{
                    text: '确定',
                    class: 'btn btn-sm btn-primary-oe',
                    click: function () {
                        $(this).dialog('close')
                        location.href = href;
                    }
                },{
                    text: '取消',
                    class: 'btn btn-sm btn-default-oe',
                    click: function () {
                        $(this).dialog('close')
                    }
                }]
            })
        })
    })
</script>
</body>
</html>