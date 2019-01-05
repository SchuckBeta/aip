<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<!--导航部分-->

<ul class="nav-menu">
    <c:forEach var="pitem" items="${fns:getWebCurrMenus()}" varStatus="idx">
       <c:if test="${fns:checkCategory(pitem.id) }">
            <c:if test="${idx.index < 6 }">
                <li class="nav-menu-item">
                    <c:if test="${empty pitem.href}">
                    	<a href="javascript:void(0);" target="${pitem.target}">${pitem.name}</a>
                    </c:if>
                    <c:if test="${not empty pitem.href}">
						<a href="${ctx}${pitem.href}" target="${pitem.target}">${pitem.name}</a>
                    </c:if>
                    <c:if test="${not empty pitem.children}">
                        <ul class="nav-second-menu">
                            <c:forEach var="sitem" items="${pitem.children}" varStatus="idxs">
                                <c:if test="${fns:checkCategory(sitem.id) }">
                                <li class="nav-second-menu-item">
                                	<c:if test="${empty sitem.href}">
                        	<a href="javascript:void(0);" target="${pitem.target}">
                        		<c:if test="${not empty sitem.children}">
                                             <i class="el-icon-d-arrow-right"></i>
                                         </c:if>${sitem.name}</a>
                        </c:if>
                        <c:if test="${not empty sitem.href}">
							<a href="${ctx}${sitem.href}" target="${pitem.target}">
                        		<c:if test="${not empty sitem.children}">
                                             <i class="el-icon-d-arrow-right"></i>
                                         </c:if>${sitem.name}</a>
                        </c:if>
                                    <c:if test="${not empty sitem.children}">
                                        <ul class="nav-three-menu">
                                            <c:forEach var="titem" items="${sitem.children}" varStatus="idxt">
                                                <li class="nav-three-menu-item">
                                                	<c:if test="${empty titem.href}">
				                        	<a href="javascript:void(0);" target="${pitem.target}">${titem.name}</a>
				                        </c:if>
				                        <c:if test="${not empty titem.href}">
											<a href="${ctx}${titem.href}" target="${pitem.target}">${titem.name}</a>
				                        </c:if>
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