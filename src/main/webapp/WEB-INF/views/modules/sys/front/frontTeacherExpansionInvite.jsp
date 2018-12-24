<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp"%>
<html>
<head>
<meta charset="utf-8" />
<meta name="decorator" content="site-decorator" />
<title>${frontTitle}</title>
<link rel="stylesheet" type="text/css"
	href="/common/common-css/bootstrap.min.css" />
<style type="text/css">
.carousel {
	/*width: 600px;*/
	/*background: #000;*/
	opacity: .6;
}

.carousel-inner {
	/*padding:10px 20%;*/
	width:949px;
	margin: 0px auto;
	height: 40px;
	
	font-size: 14px;
}

.carousel-inner>.item {
	-webkit-transition: -webkit-transform 1.4s ease-in-out;
	-o-transition: -o-transform 1.5s ease-in-out;
	transition: transform 1.5s ease-in-out;
}

.carousel-indicators {
	bottom: -10px;
}
</style>
<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<form action="/f/sys/frontTeacherExpansion/invite" method="post">
		<div align="center">
			<table>
				<tr>
					<td>邀请用户</td>
					<td>${backTeacherExpansion.user.name } <input type="hidden"
						name="id" value="${backTeacherExpansion.id}">
					</td>
				</tr>
				<tr>
					<td>选择团队</td>
					<td><select name="team.id">
							<c:forEach items="${teams }" var="team">
								<option value="${team.id }">${team.name }</option>
							</c:forEach>
					</select></td>
				</tr>
				<tr>
					<td>邀请内容</td>
					<td><input type="text" name="oaNotify.content"></td>
				</tr>
				<tr>
					<td><input type="submit" value="邀请"></td>
				</tr>
			</table>
		</div>
	</form>
</body>
</html>