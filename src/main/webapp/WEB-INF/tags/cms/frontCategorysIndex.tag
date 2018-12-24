<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<!--导航部分-->

<div class="nav-container">
    <ul class="nav-menu">
        <c:forEach var="pitem" items="${fns:getCategorysIndex()}" varStatus="idx">
            <c:if test="${fns:checkCategory(pitem.id) }">
                <c:if test="${idx.index < 7 }">
                    <li class="nav-menu-item">
                        <a href="${empty pitem.href ? 'javascript:void(0);' : fns: addCtxFront(ctxFront, pitem.href, pitem.id)}"
                           target="${pitem.isNewtab eq '1' ? '_blank' : '_self'}">
                                ${pitem.name}
                        </a>
                        <c:if test="${not empty pitem.childList}">
                            <ul class="nav-second-menu">
                                <c:forEach var="sitem" items="${pitem.childList}" varStatus="idxs">
                                    <c:if test="${fns:checkCategory(sitem.id) }">
                                    <li class="nav-second-menu-item">
                                        <a href="${empty sitem.href ? 'javascript:void(0);' :  fns: addCtxFront(ctxFront, sitem.href, sitem.id)}"
                                           target="${sitem.isNewtab eq '1' ? '_blank' : '_self'}">
                                                ${sitem.name}
                                            <c:if test="${not empty sitem.childList}">
                                                <i class="el-icon-d-arrow-right"></i>
                                            </c:if>
                                        </a>
                                        <c:if test="${not empty sitem.childList}">
                                            <ul class="nav-three-menu">
                                                <c:forEach var="titem" items="${sitem.childList}" varStatus="idxt">
                                                    <li class="nav-three-menu-item">
                                                        <a href="${empty titem.href ? 'javascript:void(0);' : fns: addCtxFront(ctxFront, titem.href, titem.id)}"
                                                           target="${titem.isNewtab eq '1' ? '_blank' : '_self'}">
                                                                ${titem.name}
                                                        </a>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </c:if>
                                    </li>
                                    </c:if>
                                </c:forEach>
                            </ul>
                        </c:if>
                    </li>
                </c:if>
            </c:if>
        </c:forEach>
    </ul>
</div>
