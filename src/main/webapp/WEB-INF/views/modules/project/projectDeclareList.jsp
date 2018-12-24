<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<html>
<head>
    <meta name="decorator" content="cyjd-site-default"/>
    <title>${frontTitle}</title>
    <%--<link rel="stylesheet" type="text/css" href="/common/common-css/Gctable.css">--%>
    <%--<script src="/js/Projectlist.js"></script>--%>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#ps").val($("#pageSize").val());
            $('#content').css('min-height', function () {
                return $(window).height() - $('.header').height() - $('.footerBox').height()
            });
        });
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }


        function delPro(id, ftb) {
            dialogCyjd.createDialog(0, '确认要删除该项目申报吗？', {
                buttons: [{
                    text: '确定',
                    'class': 'btn btn-sm btn-primary',
                    'click': function () {
                        top.location = "${ctxFront}/project/projectDeclare/delete?id=" + id + "&ftb=" + ftb;
                    }
                }, {
                    text: '取消',
                    'class': 'btn btn-sm btn-default',
                    'click': function () {
                        $(this).dialog("close");
                    }
                }]
            })

        }
    </script>
</head>
<body>
<style>
    .ui-dialog .ui-dialog-titlebar {
        /*margin: -2.5px -3px 0 -2.5px;*/
        border: none;
        border-radius: 0;
    }

    .ui-dialog .ui-dialog-titlebar-close {
        border: none;
        width: 16px;
        height: 16px;
        right: 8px;
    }

    .ui-dialog .ui-dialog-content {
        margin-top: 0;
    }

    .dialog-look-banner {
        margin: 15px auto;
        width: 856px;
        height: 512px;
        position: relative;
        overflow: hidden;
    }

    .dialog-look-banner img {
        z-index: 100;
        display: block;
        width: 100%;
        position: absolute;
        left: 100%;
        top: 0;
    }

    .dialog-look-banner .first {
        left: 0;
    }

    .dialog-look-banner .pre, .next {
        cursor: pointer;
        text-align: center;
        display: block;
        background: #eee;
        text-decoration: none;
        z-index: 200;
        opacity: 0.6;
        display: block;
        width: 40px;
        height: 60px;
        line-height: 60px;
        font-size: 40px;
        position: absolute;
        color: #ccc;
    }

    .dialog-look-banner .pre {
        left: 0px;
    }

    .dialog-look-banner .next {
        right: 0px;
    }

    .pre:hover, .next:hover {
        color: red;
    }


</style>
<form:form id="searchForm" modelAttribute="projectDeclare"
           action="${ctx}/project/projectDeclare/list" method="post">
    <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
    <input id="pageSize" name="pageSize" type="hidden"
           value="${page.pageSize}"/>
</form:form>

<div class="container container-ct">
    <ol class="breadcrumb" style="margin-top: 0">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li><a href="${ctxFront}/page-innovation">双创项目</a></li>
        <li><a href="${ctxFront}/project/projectDeclare/curProject">我的项目</a></li>
        <li class="active">项目列表</li>
    </ol>
    <div class="cate-table-module">
        <div class="text-right mgb15">
            <a href="curProject" class="btn btn-default btn-sm">当前项目</a>
            <a href="list" class="btn btn-primary btn-sm">项目列表</a>
        </div>
        <h4 class="title">我的项目列表</h4>
        <div class="table-block">
            <table class="table table-bordered table-condensed table-coffee table-nowrap table-center">
                <thead>
                <tr>
                    <th>项目编号</th>
                    <th style="width:15%;">项目名称</th>
                    <th>项目类型</th>
                    <th>项目类别</th>

                    <th>负责人</th>
                    <th>组人数</th>
                    <th>项目导师</th>
                    <th>申报时间</th>
                    <th>项目结果</th>
                    <th>证书</th>
                    <th>项目状态</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${page.list}" var="projectDeclare">
                    <tr>
                        <td>
                        ${projectDeclare.number }
                            <%--<c:choose>--%>
                                <%--<c:when test="${proModelTlxy.proModel.finalStatus == '0000000264'}">--%>
                                    <%--${proModelTlxy.proModel.competitionNumber}--%>
                                <%--</c:when>--%>
                                <%--<c:otherwise>--%>
                                        <%--<c:choose>--%>
                                            <%--<c:when test="${proModelTlxy.proModel.finalStatus == '0000000265'}">--%>
                                                <%--${proModelTlxy.gCompetitionNumber}--%>
                                            <%--</c:when>--%>
                                            <%--<c:otherwise>${proModelTlxy.pCompetitionNumber}</c:otherwise>--%>
                                        <%--</c:choose>--%>
                                <%--</c:otherwise>--%>
                            <%--</c:choose>--%>
                        </td>
                        <td style="word-break: break-all">
                            <c:choose>
                                <c:when test="${projectDeclare.ftb==0}">
                                    <a class="project-name"
                                       href="${ctx}/project/projectDeclare/viewPro?id=${projectDeclare.id}">${projectDeclare.project_name }</a>
                                </c:when>
                                <c:otherwise>
                                    <a class="project-name"
                                       href="${ctx}/promodel/proModel/viewForm?id=${projectDeclare.id}">${projectDeclare.project_name }</a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${projectDeclare.proTypeStr }</td>
                        <td>${projectDeclare.type }</td>

                        <td>${projectDeclare.leader }</td>
                            <%--<td data-toggle="pNum">${projectDeclare.snames }</td>--%>
                        <td>${projectDeclare.num }</td>
                            <%--组人数--%>
                        <td>${projectDeclare.tnames }</td>
                        <td>${projectDeclare.apply_time }</td>
                        <td>${projectDeclare.result}</td>

                        <td>
                            <c:forEach items="${projectDeclare.scis}" var="sci">
                                <%--<span class="over-flow-tooltip project-office-tooltip">--%>
                                    <%--<span class="red" v-show="scope.row.posid == 1">【推荐首页】</span>--%>
                                    <%--{{scope.row.title | textEllipsis}}--%>
                                <%--</span>--%>
                                <a href="javascript:void(0)" title="${sci.name}" class="look-type over-flow-tooltip project-office-tooltip" sciid="${sci.id}"
                                   style="color:#53BEFF;">${sci.name}</a>
                                <br>
                            </c:forEach>
                        </td>
                        <td>
                            <c:if test="${projectDeclare.proc_ins_id==null||projectDeclare.proc_ins_id==''}">
                                ${projectDeclare.status }
                            </c:if>
                            <c:if test="${projectDeclare.proc_ins_id!=null && projectDeclare.proc_ins_id!='' }">
                                <c:choose>
                                    <c:when test="${projectDeclare.status_code eq '-999'}">
                                        <c:choose>
                                            <c:when test="${ projectDeclare.subStatus=='1'}">
                                                <c:set var="map" value="${fns:getActByPromodelId(projectDeclare.id)}"/>
                                                    <a href="${ctx}/actyw/actYwGnode/designView?groupId=${projectDeclare.groupId}&proInsId=${projectDeclare.proc_ins_id}"
                                                        target="_blank">
                                                        <c:choose>
                                                            <c:when test="${projectDeclare.state =='1'}">
                                                               项目已结项
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:if test="${not empty projectDeclare.proc_ins_id}">
                                                                   待${map.taskName}
                                                                </c:if>
                                                            </c:otherwise>
                                                        </c:choose>
                                                   </a>
                                            </c:when>
                                            <c:otherwise>
                                                <%--未提交的数据--%>
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
                            <%--<td>${fns:getDictLabel(projectDeclare.setResult, "0000000151", "")}</td>--%>
                            <%--<td>${projectDeclare.final_result }</td>--%>
                        <td style="white-space: nowrap">
                            <c:if test="${projectDeclare.leaderId==user.id}">
                                <c:if test="${projectDeclare.status_code==null||projectDeclare.status_code==0}">
                                    <c:choose>
                                        <c:when test="${projectDeclare.ftb==0}">
                                            <a class="btn btn-primary btn-sm"
                                               href="${ctx}/project/projectDeclare/form?id=${projectDeclare.id}">继续完善</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="btn btn-primary btn-sm"
                                               href="${ctx}/promodel/proModel/form?id=${projectDeclare.id}">继续完善</a>
                                        </c:otherwise>
                                    </c:choose>
                                    <a class="btn btn-default btn-sm"
                                       href="javascript:void(0);"
                                       onclick="delPro('${projectDeclare.id}','${projectDeclare.ftb}')">删除</a>
                                </c:if>
                            </c:if>
                            <%--<a class="btn btn-primary btn-sm"--%>
                               <%--href="${ctx}/excellent/projectShowForm?projectId=${projectDeclare.id}&ftb=${projectDeclare.ftb}">展示</a>--%>
                                <%--<c:if test="${projectDeclare.hasConfig == 'true' }">
                                    <a  class="buttom btn" href="/f/project/projectDeclare/scoreConfig?projectId=${projectDeclare.id}" >学分配比</a>
                                </c:if>--%>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            ${page.footer}
        </div>
    </div>
</div>

<div id="dialogCyjd" class="dialog-cyjd"></div>
<div id="dialog-look" title="预览">
    <div class="dialog-look-banner">
        <a href="javascript:;"><span class="pre"><</span></a>
        <a href="javascript:;"><span class="next">></span></a>

        <div class="cert-content">

        </div>

    </div>
</div>


<script>

    $(function () {
        var pageList = ${fns:toJson(page.list)};
        console.log(pageList);

        var wWidth = $(window).width();
        var lookWidth = wWidth * 0.65;
        var lookHeight = lookWidth * 0.63;
        var bannerWidth = lookWidth * 0.91;
        var bannerHeight = lookHeight * 0.86;
        var dialogLook = $("#dialog-look");
        dialogLook.dialog({
            autoOpen: false,
            width: lookWidth,
            modal: true,
            containment: 'document'
        });
        var startIndex = 0;
        var $index;
        var $exdex;
        var len;
        var lookImg;

        $(".dialog-look-banner .cert-content .cert-content-img").css({
            width: '',
            height: ''
        });
        dialogLook.on('dialogclose', function () {
            $(".dialog-look-banner .cert-content .cert-content-img").css({
                left: '',
                width: '',
                height: ''
            });
            startIndex = 0;
        })
        $('.dialog-look-banner').css({
            width: bannerWidth,
            height: bannerHeight
        });
        $(".look-type").on("click", function () {
            getCertPage($(this).attr("sciid"));
            dialogLook.dialog("open");
            lookImg = $('.dialog-look-banner .cert-content-img');
            len = lookImg.length;
            lookImg.css('visibility', 'hidden');
            lookImg.on('load', function () {
                var lm = $(this);
                var lw = parseInt(lm.css('width').replace("px", ""));
                var lh = parseInt(lm.css('height').replace("px", ""));
                var scaleW = (lw / lh) * bannerHeight;
                var scaleH = (lh / lw) * bannerWidth;
                if (lh < bannerHeight) {
                    lm.css({
                        width: bannerWidth,
                        height: 'auto',
                        marginTop: (bannerHeight - scaleH) / 2
                    });
                } else {
                    lm.css({
                        width: 'auto',
                        height: bannerHeight,
                        marginLeft: (bannerWidth - scaleW) / 2
                    });
                }
                lm.css('visibility', 'visible')
            })
//            lookImg.eq(0).addClass('first');
        });
        $(".next").click(function () {
            //手动轮播
            var nextLen = lookImg.length;
            $index = startIndex;
            $exdex = startIndex;
            $index++;
            if (nextLen > 1) {
                if ($index > len - 1) {
                    $index = 0;
                }
                startIndex = $index;
                next();
            }
        });
        //上一页的点击事件
        $(".pre").click(function () {
            var preLen = lookImg.length;
            $index = startIndex;
            $exdex = startIndex;
            $index--;
            if (preLen > 1) {
                if ($index < 0) {
                    $index = len - 1;
                };
                startIndex = $index;
                pre();
            }
        });
        //这里为右移和左移的事件函数。
        //右移基本原理就是先让exdex定位的left左移百分百，而选中的当前页从屏幕右边移入,left变为0
        function next() {
            lookImg.eq($index).stop(true, true).css("left", "100%").animate({"left": "0"});
            lookImg.eq($exdex).stop(true, true).css("left", "0").animate({"left": "-100%"});
        }
        function pre() {
            lookImg.eq($index).stop(true, true).css("left", "-100%").animate({"left": "0"});
            lookImg.eq($exdex).stop(true, true).css("left", "0").animate({"left": "100%"});
        }
        $('.dialog-look-banner .pre, .next').css('top', bannerHeight / 2 - 30);
    });

    function getCertPage(id) {
        $(".cert-content").html("");
        $.ajax({
            type: 'post',
            url: '/f/cert/getCertIns',
            async: false,
            dataType: "json",
            data: {
                certinsid: id
            },
            success: function (data) {
                if (data) {
                    var indx = 0;
                    var html = "";
                    $.each(data, function (i, v) {
                        if (indx == 0) {
                            html = html + '<div><img class="cert-content-img first" src="' + v.imgUrl + '"></div>';
                        } else {
                            html = html + '<div><img class="cert-content-img" src="' + v.imgUrl + '"></div>';
                        }
                        indx++;
                    });
                    $(".cert-content").html(html);
                }
            }
        });
    }
</script>

</body>
</html>