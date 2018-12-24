<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>

<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="decorator" content="site-decorator"/>
    <link rel="stylesheet" type="text/css" href="/css/stu_tec_edit_check.css?v=1">
    <link rel="stylesheet" type="text/css" href="/css/seers.css">
    <title>${frontTitle}</title>
    <style>
        .ui-dialog-buttonset button{
            padding: 6px 12px;
            line-height: 20px;
        }
        .info-card .user-label-control{
            width: 100px;
        }
        .info-card .user-val{
            margin-left: 100px;
        }

        .breadcrumb > li + li:before {
          content: "\003e";
          padding: 0 5px 0 3px;
          color: #ccc; }

        .breadcrumb .icon-home:before {
          content: "\f015";
          margin-right: 7px; }
    </style>
</head>

<body>
<div class="container" style="width: 1270px; padding-top: 50px;">
    <ol class="breadcrumb" style="padding-left: 0;margin-top: 10px;">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li class="active">人才库</li>
        <li><a href="${ctxFront}/sys/frontTeacherExpansion">导师库</a></li>
        <li class="active">导师信息查看</li>
    </ol>

    <div class="row">
        <div class="col-md-10">
            <div class="edit-bar clearfix">
                <div class="edit-bar-left">
                    <span>基本信息</span>
                    <i class="line"></i>
                </div>
                <sys:likes foreignid="${backTeacherExpansion.user.id}" btnname="点赞" disable="${fns:checkIsLikeForUserInfo(backTeacherExpansion.user.id)}" likestagid="likespan"></sys:likes>
            </div>
            <div class="user-base-info">
                <div class="user-pic-box">
                    <c:choose>
                        <c:when test="${backTeacherExpansion.user.photo!=null && backTeacherExpansion.user.photo!='' }">
                            <img class="user-pic img-responsive" src="${fns:ftpImgUrl(backTeacherExpansion.user.photo) }">
                        </c:when>
                        <c:otherwise>
                            <img class="user-pic img-responsive" src="/img/u4110.png">
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="user-info-box">
                    <div class="row">
                        <div class="col-md-6">
                            <label class="user-label-control">姓名：</label>
                            <div class="user-val">${backTeacherExpansion.user.name}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="user-label-control">性别：</label>
                            <div class="user-val">
                                ${fns:getDictLabel(backTeacherExpansion.user.sex,"sex" , "")}
                            </div>
                        </div>
                        <%--<div class="col-md-6">--%>
                            <%--<label class="user-label-control">年龄：</label>--%>
                            <%--<div class="user-val">${backTeacherExpansion.user.age}岁</div>--%>
                        <%--</div>--%>
                        <div class="col-md-6">
                            <label class="user-label-control">导师来源：</label>
                            <div class="user-val">
                                ${fns:getDictLabel(backTeacherExpansion.teachertype, "master_type", "")}

                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="user-label-control">院系名称：</label>
                            <div class="user-val">${backTeacherExpansion.user.office.name }</div>
                        </div>
                        <div class="col-md-6">
                            <label class="user-label-control">电子邮箱：</label>
                            <div class="user-val">${email}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="user-label-control">手机号：</label>
                            <div class="user-val">${mobile}</div>
                        </div>
                        <div class="col-md-6">
                            <label class="user-label-control">技术领域：</label>
                            <div class="user-val">${backTeacherExpansion.user.domainlt}</div>
                        </div>

                        <div class="col-md-12">
                            <label class="user-label-control">工作简历：</label>
                            <div class="user-val">
                                ${backTeacherExpansion.mainExp}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="user-detail-info">
                <div class="edit-bar clearfix">
                    <div class="edit-bar-left">
                        <span>详细信息</span>
                        <i class="line"></i>
                    </div>
                </div>
                <div class="user-detail-group">
                    <div class="ud-inner">
                        <p class="ud-title">指导项目</p>
                        <div class="info-cards">
                            <c:forEach items="${projectExpVo}" var="projectExp">
                                <div class="info-card">
                                    <p class="info-card-title"><c:if test="${projectExp.finish==0 }"><span style="color: #e9432d;">【进行中】</span></c:if>${projectExp.proName}</p>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <label class="user-label-control">项目周期：</label>
                                            <div class="user-val"><fmt:formatDate value="${projectExp.startDate }" pattern="yyyy/MM/dd"/>-
                                                <fmt:formatDate value="${projectExp.endDate }"
                                                                pattern="yyyy/MM/dd"/>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="user-label-control">项目名称：</label>
                                            <div class="user-val">${projectExp.name }</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="user-label-control">担任角色：</label>
                                            <div class="user-val"><c:if test="${cuser==projectExp.leaderId}">项目负责人</c:if>
                                               	<c:if test="${cuser!=projectExp.leaderId&&projectExp.userType=='1'}">组成员</c:if>
                                               	<c:if test="${cuser!=projectExp.leaderId&&projectExp.userType=='2'}">导师</c:if>
                                                </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="user-label-control">项目评级：</label>
                                            <div class="user-val">${projectExp.level }</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="user-label-control">项目结果：</label>
                                            <div class="user-val">${projectExp.result }</div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <p class="ud-title">指导大赛</p>
                        <div class="info-cards">
                            <c:forEach items="${gContestExpVo}" var="gContest">
                                <div class="info-card">
                                    <p class="info-card-title"><c:if test="${gContest.finish==0 }"><span style="color: #e9432d;">【进行中】</span></c:if>${gContest.type}</p>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <label class="user-label-control">参赛项目名称：</label>
                                            <div class="user-val">${gContest.pName}
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="user-label-control">参赛时间：</label>
                                            <div class="user-val"><fmt:formatDate value="${gContest.createDate }"
                                                                                  pattern="yyyy-MM-dd"/></div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="user-label-control">担任角色：</label>
                                            <div class="user-val"><c:if test="${cuser==gContest.leaderId}">项目负责人</c:if>
	                                            <c:if test="${cuser!=gContest.leaderId&&gContest.userType=='1'}">组成员</c:if>
	                                           	<c:if test="${cuser!=gContest.leaderId&&gContest.userType=='2'}">导师</c:if></div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="user-label-control">获奖情况：</label>
                                            <div class="user-val">${gContest.award}</div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-2">
            <div class="edit-bar-left">
                <c:if test="${backTeacherExpansion.user.id==fns:getUser()}">
	            	<span>谁看过我</span>
	                <i class="line"></i>
	            </c:if>
	            <c:if test="${backTeacherExpansion.user.id!=fns:getUser()}">
	                <span>谁看过${backTeacherExpansion.user.sex=='0'?'她':'他'}</span>
	                <i class="line"></i>
	            </c:if>
            </div>
            <ul class="seers">
                <c:forEach items="${visitors}" var="vi">
            		<c:if test="${vi.user_type=='1'}">
		            	<li class="seer">
            			 	<a  href="/f/sys/frontStudentExpansion/form?id=${vi.st_id}">
		                        <img class="seer-pic" src="${empty vi.photo ? '/img/u4110.png':fns:ftpImgUrl(vi.photo)}">
		                        <span class="seer-name">${vi.name}</span>
	                    	</a>
	                    	<p class="see-date"><fmt:formatDate value='${vi.create_date}' pattern='yyyy-MM-dd'/></p>
		                </li>
            		</c:if>
            		<c:if test="${vi.user_type=='2'}">
		            	<li class="seer">
            			 	<a  href="/f/sys/frontTeacherExpansion/view?id=${vi.te_id}">
		                        <img class="seer-pic" src="${empty vi.photo ? '/img/u4110.png':fns:ftpImgUrl(vi.photo)}">
		                        <span class="seer-name">${vi.name}</span>
	                    	</a>
	                    	<p class="see-date"><fmt:formatDate value='${vi.create_date}' pattern='yyyy-MM-dd'/></p>
		                </li>
            		</c:if>
            	</c:forEach>
            </ul>
            <div class="see-count">
                <div class="see-item">
                    <span>浏览量</span>
                    <span>${backTeacherExpansion.user.views}</span>
                </div>
                <div class="see-item">
                    <span>点赞数</span>
                    <span id="likespan">${backTeacherExpansion.user.likes}</span>
                </div>
            </div>
        </div>
    </div>
    <div class="text-center" style="margin-bottom: 30px">

        <button type="button" class="btn btn-primary-oe" onclick="history.go(-1)">返回</button>
    </div>
</div>
</body>
</html>