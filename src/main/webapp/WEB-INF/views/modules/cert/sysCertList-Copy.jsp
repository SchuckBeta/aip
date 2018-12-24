<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <style>
        .ui-dialog .ui-dialog-titlebar {
            margin: -2.5px -3px 0 -2.5px;
            border: none;
            border-radius: 0;
        }

        .ui-dialog .ui-dialog-titlebar-close {
            border: none;
            width: 16px;
            height: 16px;
            right: 8px;
        }

        .dialog-look .ui-button .ui-icon, .dialog-together .ui-button .ui-icon {
            display: none;
        }

        .cert .cert-content {
            padding: 5px;
            box-sizing: border-box;
        }

        .cert .cert-content > div {
            height: 100%;
            overflow: hidden;
        }

        .cert-ul .dbl-edit-a {
            padding: 3px 6px;
            font-size: 12px;
            max-width: 45px;
            text-overflow: ellipsis;
            overflow: hidden;
        }

        .cert-ul .dbl-edit {
            padding: 0 6px;
        }

        .cert .cert-one {
            width: 33.333%;
            box-sizing: border-box;
            padding: 0 15px 0;
            margin: 0 0 30px;
            border: none;
        }

        .cert .cert-shade {
            width: 100%;
            box-sizing: border-box;
        }

        .cert .cert-right {
            width: auto;
        }

        .cert .certs {
            padding: 0 15px;
        }

        .cert .cert-middle {
            margin: 0 -15px;
            padding-left: 0;
        }

        .cert .cto-inner {
            padding: 10px 10px 0;
            border-radius: 5px;
            border: 1px solid #eee;
        }

        .cert .cert-shade {
            font-weight: normal;
            font-size: 18px;
            opacity: 1;
            background: rgba(0, 0, 0, .3);
        }
    </style>
</head>
<body>


<div class="cert container-fluid">
    <%--<div class="edit-bar clearfix">--%>
        <%--<div class="edit-bar-left">--%>
            <%--<span>证书管理</span>--%>
            <%--<i class="line weight-line"></i>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%@ include file="/WEB-INF/views/layouts/navigation.jsp" %>
    <div class="text-right mgb-20">
        <a class="btn btn-mid btn-primary cert-create" href="/a/cert/form?secondName=添加证书模板">添加证书模板</a>
        <button type="button" class="btn btn-default cert-dele cert-del" onclick="deleteAll()">删除模板</button>
    </div>
    <c:if test="${fn:length(list)>0}">
        <div class="certs">
            <div class="cert-middle">
                <c:forEach items="${list}" var="cert">
                    <div class="cert-one">
                            <%--<input type="checkbox" class="cert-check" style="margin-left:8px;" value="${cert.id }">--%>
                        <div class="cto-inner">
                            <div class="cert-check">
                                <label class="demo--label">
                                    <input class="demo--radio cert-checkbox" type="checkbox" name="demo-checkbox1"
                                           value="${cert.id }" releases="${cert.releases}">
                                    <span class="demo--checkbox demo--radioInput"></span>
                                </label>
                                <span class="cert-name">${cert.name }</span>
                            </div>
                            <div class="cert-right">
                                <div class="drop-content" style="margin:5px 0 -30px 0;" certid="${cert.id }">
                                    <div class="dropdown right">
                                        <button class="btn btn-primary dropdown-toggle btn-small" type="button"
                                                id="dropdownMenu1"
                                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            操作
                                            <span class="caret"></span>
                                        </button>
                                        <ul class="dropdown-menu pull-right" aria-labelledby="dropdownMenu1">
                                            <li><a class="cert-add" href="/a/cert/form?certid=${cert.id }">添加证书</a></li>
                                            <li><a class="cert-add" href="javascript:;"
                                                   onclick="editPage(this)">修改证书</a>
                                            </li>
                                            <li><a class="cert-together" href="javascript:;">关联项目</a></li>
                                            <li>
                                                <c:if test="${cert.releases==0}">
                                                    <a href="javascript:;" onclick="release(this)">发布</a>
                                                </c:if>
                                            </li>
                                            <li>
                                                <c:if test="${cert.releases==1}">
                                                    <a href="javascript:;" onclick="unrelease(this)">取消发布</a>
                                                </c:if>
                                            </li>
                                        </ul>
                                    </div>
                                </div>

                                <ul class="nav nav-tabs cert-ul" certid="${cert.id }">
                                    <c:forEach items="${cert.scp}" var="scp" varStatus="vs">
                                        <c:if test="${vs.index==0}">
                                            <li pageid="${scp.id}" class="active">
                                                <a href="javascript:;" class="dbl-edit-a" data-toggle="tooltip"
                                                   data-placement="bottom" title="${scp.certpagename} (双击可修改)">
                                                    <input type="text" class="dbl-edit" readonly
                                                           value="${scp.certpagename}">
                                                    <div class="dbl-hidden">${scp.certpagename}</div>
                                                </a>
                                                    <%--<button type="button" class="btn btn-default" data-toggle="tooltip" data-placement="left" title="Tooltip on left">Tooltip on left</button>--%>
                                            </li>
                                        </c:if>
                                        <c:if test="${vs.index!=0}">
                                            <li pageid="${scp.id}">
                                                <a href="javascript:;" class="dbl-edit-a" data-toggle="tooltip"
                                                   data-placement="bottom" title="${scp.certpagename} (双击可修改)">
                                                    <input type="text" class="dbl-edit" readonly
                                                           value="${scp.certpagename}">
                                                    <div class="dbl-hidden">${scp.certpagename}</div>
                                                </a>

                                            </li>
                                        </c:if>
                                    </c:forEach>
                                </ul>
                                <div class="cert-imgs">
                                    <div class="cert-content">
                                        <c:forEach items="${cert.scp}" var="scp">
                                            <div class="cert-page-item"><img class="cert-content-img"
                                                                             src="${scp.imgUrl}" alt=""></div>
                                        </c:forEach>
                                    </div>

                                    <div class="cert-shade"><span>预 览 证 书</span></div>

                                    <img releases="${cert.releases}" class="cert-delete"
                                         src="/images/testCert/unchecked.gif"
                                         alt="">

                                </div>
                                <div class="cert-handlebar">
                                    <div class="pull-right text-right">
                                        <a class="btn btn-small btn-primary cert-deleteModel" href="javascript:;"
                                           onclick="delCertFlow(this)">取消关联</a>
                                    </div>
                                    <span class="link-label_pro">关联项目：</span>
                                    <div class="link-controls_pro">
                                        <div class="dropdown">
                                            <button scfid="" class="btn btn-default btn-small dropdown-toggle"
                                                    type="button"
                                                    data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                                                --请选择--
                                                <span class="caret"></span>
                                            </button>
                                            <ul class="dropdown-menu drop-together" aria-labelledby="dropdownMenu1">
                                                <c:forEach items="${cert.scf}" var="scf">
                                                    <li scfid="${scf.id }"><a
                                                            href="javascript:;">${scf.flowName }&nbsp;&nbsp;${scf.nodeName }</a>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <p class="release-date gray-color text-right">发布时间：<fmt:formatDate
                                    value="${cert.releaseDate }"
                                    pattern="yyyy-MM-dd"/></p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
    <c:if test="${empty list}">
        <p class="text-center gray-color none-certs">没有可用证书，请<a style="font-weight: bold;text-decoration: underline" href="${ctx}/cert/form">添加证书模板</a></p>
    </c:if>
</div>


<div id="dialog-together" title="关联证书">
    <form id="inputForm">
        <div class="form-horizontal" style="margin:30px 0 0 -15px;">
            <div class="control-group">
                <label class="control-label"><i>*</i>下发证书项目：</label>
                <div class="controls">
                    <select id="flow" name="flow" onchange="flowChange()" class="required">
                        <option value="">--请选择--</option>
                        <c:forEach items="${fns:getActListData('')}" var="proItem">
                        	<c:if test="${proItem.proProject.proType=='1,' and proItem.proProject.type!='1'}">
                            <option value="${proItem.id }">${proItem.proProject.projectName }</option>
                        	</c:if>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="control-group" v-if="!isEdit">
                <label class="control-label"><i>*</i>下发证书节点：</label>
                <div class="controls">
                    <select id="node" name="node" class="required">
                        <option value="">--请选择--</option>
                    </select>
                </div>
            </div>
        </div>
        <p class="together-p">
            <button class="btn btn-primary" type="button" onclick="saveFlowNode()">确认</button>
        </p>
    </form>


</div>


<div id="dialog-look" title="预览">
    <div class="dialog-look-banner">
        <a href="javascript:;"><span class="pre"><</span></a>
        <a href="javascript:;"><span class="next">></span></a>
    </div>
</div>
<script type="text/javascript" src="/js/cert/sysCertList.js?v=212111311"></script>

<script>
    $('.cert .cert-one').each(function () {
        $(this).find('.cert-page-item').eq(0).siblings().hide()
    })

    setNoneCertsCenter();
    function setNoneCertsCenter() {
        var winH = $(window).height();
        var $noneCerts = $('.none-certs');
        var cHeight;
        var defHeight = 120;
        if ($noneCerts.size() < 1) {
            return
        }
        cHeight = $noneCerts.height();
        $noneCerts.css('marginTop', function () {
            return (winH - defHeight - cHeight)/2 + 'px'
        })
    }


    $('.cert .cert-content').hover(function () {
        var visiableImage = $(this).find(">div>img");
        var image = new Image();
        var $certRight = $(this).parents('.cert-right');
        var $lis = $certRight.find('.nav-tabs li.active');
        var tabIndex = $lis.index();
        var src = visiableImage.eq(tabIndex).attr('src');
        var $curImage = visiableImage.eq(tabIndex);
        var errorTmp = '<span class="invalid-view" style="font-size: 18px;">请点击【<i style="color: red;font-style: normal;">操作</i>】->【<i style="color: red;font-style: normal">修改证书</i>】 </span>'
        var normalTmp = '<span class="normal-view">预览证书</span>'
        if ($curImage.hasClass('error')) {
            $(this).next().html(errorTmp);
            return false;
        }
        $(this).next().html(normalTmp)
        image.onerror = function () {
            image.onerror = null;
            $curImage.eq(tabIndex).addClass('error')
        }
        image.src = src;


    })
</script>

</body>
</html>