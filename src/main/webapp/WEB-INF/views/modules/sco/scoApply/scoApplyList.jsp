<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>${fns:getConfig('productName')}</title>
    <meta charset="UTF-8">
    <meta name="decorator" content="cyjd-site-default"/>
    <link rel="stylesheet" type="text/css" href="/css/sco/frontCreditModule.css?v=1">
    <script type="text/javascript" src="/static/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
        //查看详情
        function view(url) {
            window.location.href = url;
        }

        //删除
        function del(url) {
            window.location.href = url;
        }
        //申请
        function apply(url) {
            window.location.href = url;
        }

        $(function () {
            if ('${message}' != '') {
                showModalMessage(1, '${message}');
            }
            $("#ps").val($("#pageSize").val());
        })

        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
        }

        $(function () {
            $('#content').css('min-height', function () {
                return $(window).height() - $('.header').height() - $('.footerBox').height()
            })
            $('.pagination_num').removeClass('row')
        })



    </script>
</head>
<body>
<div class="container">
    <ol class="breadcrumb" style="margin-top: 60px">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li class="active">学分认定</li>
        <li class="active">课程学分认定</li>
    </ol>
    <div class="credit-title-bar clearfix">
        <c:if test="${isStu!=null &&isStu eq '1'}">
            <a class="btn btn-primary-oe btn-sm" href="/f/scoapply/scoApplyAdd">添加认定课程</a>
        </c:if>
        <h4 class="title">课程学分认定</h4>
    </div>
    <div class="row-form-table">
        <form:form class="form-block" id="searchForm" modelAttribute="scoApply" action="/f/scoapply/scoApplyList" autocomplete="off">
            <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
            <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
            <div class="pull-right text-right form-inline form-inline-right-w240">
                <div class="form-group">
                    <form:input path="keyword" class="form-control input-sm" placeholder="课程代码或者课程名称"/>
                    <button type="submit" class="btn btn-primary-oe btn-sm">查询</button>
                </div>
            </div>
            <div class="form-inline form-inline-left form-inline-left-mr240">
                <div class="form-group">
                    <label class="control-label">开始日期</label>
                    <input type="text" class="form-control w-date-picker input-sm" name="beginDate" id="beginDate"
                           onClick="WdatePicker({maxDate:'#F{$dp.$D(\'endDate\')}'})"
                           value='<fmt:formatDate value="${scoApply.beginDate}" pattern="yyyy-MM-dd"/>'
                    />
                </div>
                <div class="form-group">
                    <label class="control-label">结束日期</label>
                    <input type="text" class="form-control w-date-picker input-sm" name="endDate" id="endDate"
                           onClick="WdatePicker({minDate:'#F{$dp.$D(\'beginDate\')}'})"
                           value='<fmt:formatDate value="${scoApply.endDate}" pattern="yyyy-MM-dd"/>'
                    />
                </div>
                <div class="form-group">
                    <label class="control-label">课程性质</label>
                    <form:select path="scoCourse.nature" class="form-control input-sm">
                        <form:option value="" label="--请选择--"/>
                        <form:options items="${fns:getDictList('0000000108')}" itemLabel="label" itemValue="value"/>
                    </form:select>
                </div>
            </div>
        </form:form>
        <table class="table table-bordered table-hover table-vertical-middle table-theme-default table-text-center">
            <thead>
            <tr>
                <th class="none-wrap">序号</th>
                <th class="none-wrap">课程代码</th>
                <th class="none-wrap">课程名</th>
                <th class="none-wrap">课程性质</th>
                <th class="none-wrap">课程类型</th>
                <th class="none-wrap">计划课时</th>
                <th class="none-wrap">计划学分</th>
                <th class="none-wrap">合格成绩</th>
                <th class="none-wrap">实际学时</th>
                <th class="none-wrap">实际成绩</th>
                <th class="none-wrap">认定学分</th>
                <%--	<th class="none-wrap">课程情况</th>--%>
                <th class="none-wrap">申请日期</th>
                <th class="none-wrap">审核状态</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>

            <c:forEach items="${page.list}" var="scoApply" varStatus="status">
                <tr>
                    <td>${status.count}</td>
                    <td>${scoApply.scoCourse.code}</td>
                    <td>${scoApply.scoCourse.name}</td>
                    <td>${fns:getDictLabel(scoApply.scoCourse.nature, '0000000108', '')}</td>
                    <td>${fns:getDictLabel(scoApply.scoCourse.type, '0000000102', '')}</td>
                    <td>${scoApply.scoCourse.planTime}</td>
                    <td>${fns:deleteZero(scoApply.scoCourse.planScore)}</td>
                    <td>${fns:deleteZero(scoApply.scoCourse.overScore)}分及以上</td>
                    <td>${fns:deleteZero(scoApply.realTime)}</td>
                    <td>${fns:deleteZero(scoApply.realScore)}</td>
                    <td>
                        <c:choose>
                        <c:when test="${scoApply.auditStatus eq '1' ||scoApply.auditStatus eq '2' }">

                        </c:when>
                        <c:otherwise>
                            ${fns:deleteZero(scoApply.score)}
                        </c:otherwise>
                        </c:choose>
                    </td>
                        <%--<td class="none-wrap">
                            <c:if test="${scoApply.courseStatus eq '1'}">
                                <span class="danger-color">课程未达标</span>
                            </c:if>
                            <c:if test="${scoApply.courseStatus eq '2'}">
                                <span class="success-color">课程已达标</span>
                            </c:if>
                        </td>--%>
                    <td><fmt:formatDate value='${scoApply.applyDate}' pattern='yyyy-MM-dd'/></td>
                    <td>
                        <c:if test="${scoApply.auditStatus eq '1'}">
                            <span class="primary-color">待提交认定</span>
                        </c:if>
                        <c:if test="${scoApply.auditStatus eq '2'}">
                            <span class="primary-color">待审核</span>
                        </c:if>
                        <c:if test="${scoApply.auditStatus eq '3'}">
                            <span class="fail-color">未通过</span>
                        </c:if>
                        <c:if test="${scoApply.auditStatus eq '4'}">
                            <span>通过</span>
                        </c:if>
                    </td>
                    <td class="none-wrap">
                        <c:if test="${scoApply.auditStatus eq '1'}">
                            <button type="button" class="btn btn-primary-oe btn-sm"
                                    onclick="apply('/f/scoapply/scoApplyForm?id=${scoApply.id}')">申请学分认定
                            </button>
                            <button type="button" class="btn btn-sm  btn-default"
                                    onclick="del('/f/scoapply/delete?id=${scoApply.id}')">删除
                            </button>
                        </c:if>
                        <c:if test="${scoApply.auditStatus eq '2' || scoApply.auditStatus eq '3' || scoApply.auditStatus eq '4' }">
                            <button type="button" class="btn btn-primary-oe btn-sm"
                                    onclick="view('/f/scoapply/view?id=${scoApply.id}')">查看
                            </button>
                        </c:if>
                        <c:if test="${scoApply.auditStatus eq '3'}">
                            <button type="button" class="btn btn-primary-oe btn-sm"
                                    onclick="apply('/f/scoapply/scoApplyForm?id=${scoApply.id}')">编辑
                            </button>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        ${page.footer}
    </div>
</div>
</body>
</html>