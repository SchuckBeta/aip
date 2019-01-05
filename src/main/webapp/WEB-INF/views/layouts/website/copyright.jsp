<%@ page contentType="text/html;charset=UTF-8"%>
<div class="footerBox" style="text-align:center; font-size: 12px; background-color: white; position: fixed; bottom: 0; left: 0; right: 0; border-top: 1px solid #ddd; z-index: 120;">
	<p class="copyright" style="margin:0">
		<%-- <c:choose>
			<c:when test="${fnc:getAutoSite().copyright != null && fnc:getAutoSite().copyright != ''}">
				${fnc:getAutoSite().copyright}<br>
				技术支持:武汉中骏龙新能源科技有限公司 <a style="font-size: 12px; color: rgb(0,0,199);text-decoration: underline" href="${fns:getSysFrontIp()}/f">进入门户网站</a>
			</c:when>
			<c:otherwise> --%>
				Copyright © 2015-2018 :武汉中骏龙新能源科技有限公司 <br>
				<a style="font-size: 12px; color: rgb(0,0,199);text-decoration: underline" href="${fns:getSysFrontIp()}/f">进入门户网站</a>
			<%-- </c:otherwise>
		</c:choose> --%>
	</p>
</div>