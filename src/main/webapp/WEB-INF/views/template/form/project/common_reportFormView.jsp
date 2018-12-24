<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ page errorPage="/WEB-INF/views/error/formMiss.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <%--<meta name="decorator" content="site-decorator"/>--%>
    <meta name="decorator" content="cyjd-site-default"/>
    <script src="/js/frontCyjd/uploaderFile.js"></script>
    <title>${frontTitle}</title>
</head>
<body>

<div class="container container-ct">
    <ol class="breadcrumb" style="margin-top: 0">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li><a href="${ctxFront}/page-innovation">双创项目</a></li>
        <li><a href="${ctxFront}/project/projectDeclare/curProject">我的项目</a></li>
        <li class="active">${gnode.name}</li>
    </ol>

    <h4 class="main-title">${gnode.name}</h4>
    <div class="row-apply">
        <div class="row row-top-bar">
            <%--<span>项目编号：${proModel.competitionNumber}</span>--%>
            <%--<span style="margin-left: 15px;">填报日期:</span>--%>
            <%--<i>${sysdate}</i>--%>
            <%--<span style="margin-left: 15px">申请人:</span>--%>
            <%--<i>${sse.name}</i>--%>
            <div class="col-xs-4">
                <p class="text-center topbar-item">项目编号：${proModel.competitionNumber}</p>
            </div>
            <div class="col-xs-4">
                <p class="text-center topbar-item">填报日期：${sysdate}</p>
            </div>
            <div class="col-xs-4">
                <p class="text-center topbar-item"> 申请人：${sse.name}</p>
            </div>
        </div>
        <h4 class="titlebar">项目申报表</h4>
        <div class="contest-wrap form-horizontal form-horizontal-apply">
            <div class="row row-user-info">
                <div class="col-xs-6">
                    <label class="label-static">项目负责人：</label>
                    <p class="form-control-static">${sse.name}</p>
                </div>
                <div class="col-xs-6">
                    <label class="label-static">学号：</label>
                    <p class="form-control-static">${sse.no}</p>
                </div>
            </div>
            <div class="row row-user-info">
                <div class="col-xs-6">
                    <label class="label-static">性别：</label>
                    <p class="form-control-static">${fns:getDictLabel(sse.sex, 'sex', '')}</p>
                </div>
                <div class="col-xs-6">
                    <label class="label-static">学院：</label>
                    <p class="form-control-static">${sse.office.name}</p>
                </div>
            </div>
            <div class="row row-user-info">
                <div class="col-xs-6">
                    <label class="label-static">专业年级：</label>
                    <p class="form-control-static">${fns:getProfessional(sse.professional)}</p>
                </div>
                <div class="col-xs-6">
                    <label class="label-static">联系电话：</label>
                    <p class="form-control-static">${sse.mobile}</p>
                </div>
            </div>
            <div class="row row-user-info">
                <div class="col-xs-6">
                    <label class="label-static">E-mail：</label>
                    <p class="form-control-static">${sse.email}</p>
                </div>
                <div class="col-xs-6">
                    <label class="label-static">身份证号：</label>
                    <p class="form-control-static">${sse.idNumber}</p>
                </div>
            </div>
            <div class="edit-bar edit-bar-sm clearfix">
                <div class="edit-bar-left">
                    <span>项目基本信息</span>
                    <i class="line"></i>
                    <a data-toggle="collapse" href="#applicatioinDetail"><i
                            class="icon-collaspe icon-double-angle-up"></i></a>
                </div>
            </div>
            <div class="form-horizontal form-horizontal-apply mgb40">
                <div id="applicatioinDetail" class="panel-body collapse in">
                    <div class="row row-user-info">
                        <div class="col-xs-6">
                            <label class="label-static">项目名称：</label>
                            <p class="form-control-static" style="word-break: break-all">${proModel.pName}</p>
                        </div>
                        <div class="col-xs-6">
                            <label class="label-static">项目类别：</label>
                            <p class="form-control-static">${fns:getDictLabel(proModel.proCategory, "project_type","" )}</p>
                        </div>
                        <div class="col-xs-12">
                            <label class="label-static">项目简介：</label>
                            <p class="form-control-static">${proModel.introduction}</p>
                        </div>
                        <div class="col-xs-12">
                            <label class="label-static">项目logo：</label>
                            <div class="form-control-static">
                                <div class="project-logo-box">
                                    <img class="img-responsive"
                                         src="${empty proModel.logo.url ? '/images/upload-default-image1.png':fns:ftpImgUrl(proModel.logo.url)}">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="edit-bar edit-bar-sm clearfix">
                    <div class="edit-bar-left">
                        <span>项目申报资料</span>
                        <i class="line"></i>
                    </div>
                </div>
                <div class="row row-user-info">
                    <div class="col-xs-12">
                        <label class="label-static">申报资料：</label>
                        <div class="form-control-static" style="padding: 0">
                            <sys:frontFileUpload className="accessories-h34" fileitems="${applyFiles}"
                                                 readonly="true"></sys:frontFileUpload>
                        </div>
                    </div>
                </div>
                <div class="edit-bar edit-bar-sm clearfix">
                    <div class="edit-bar-left">
                        <span>团队信息</span>
                        <i class="line"></i>
                        <a data-toggle="collapse" href="#projectDetail"><i
                                class="icon-collaspe icon-double-angle-up"></i></a>
                    </div>
                </div>
                <div class="table-condition form-horizontal form-horizontal-apply">
                    <div id="projectDetail" class="panel-body collapse in">
                        <div class="row row-user-info">
                            <div class="col-xs-8">
                                <label class="label-static">团队名称：</label>
                                <p class="form-control-static">${team.name}</p>
                            </div>
                        </div>
                        <div class="table-title">
                            <span>学生团队</span>
                            <span class="ratio" id="ratio"></span>
                        </div>
                        <table class="table table-bordered table-condensed table-orange table-center table-nowrap table-hover">
                            <thead>
                            <tr id="studentTr">
                                <th>序号</th>
                                <th>姓名</th>
                                <th>工号</th>
                                <th>学院</th>
                                <th>专业</th>
                                <th>手机号</th>
                                <th>现状</th>
                                <th>当前在研</th>
                                <th>技术领域</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:if test="${teamStu!=null&&teamStu.size() > 0}">
                                <c:forEach items="${teamStu}" var="item" varStatus="status">
                                    <tr>
                                        <td>${status.index+1 }</td>
                                        <td>${item.name }</td>
                                        <td>${item.no }</td>
                                        <td>${item.org_name }</td>
                                        <td>${item.professional}</td>
                                        <td>${item.mobile }</td>
                                        <td>${fns:getDictLabel(item.currState, 'current_sate', '')}</td>
                                        <td>${item.curJoin }</td>
                                        <td>${item.domain }</td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            </tbody>
                        </table>
                        <div class="table-title">
                            <span>指导教师</span>
                        </div>
                        <table class="table table-bordered table-condensed table-orange table-center table-nowrap table-hover">
                            <thead>
                            <tr>
                                <th>序号</th>
                                <th>姓名</th>
                                <th>工号</th>
                                <th>单位(学院或企业、机构)</th>
                                <th>导师来源</th>
                                <th>当前指导</th>
                                <th>技术领域</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:if test="${teamTea!=null&&teamTea.size() > 0}">
                                <c:forEach items="${teamTea}" var="item" varStatus="status">
                                    <tr>
                                        <td>${status.index+1 }</td>
                                        <td>${item.name }</td>
                                        <td>${item.no }</td>
                                        <td>${item.org_name }</td>
                                        <td>${item.teacherType}</td>
                                        <td>${item.curJoin }</td>
                                        <td>${item.domain }</td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
                <form:form id="competitionfm" modelAttribute="proReport" action="/f/proproject/reportSubmit"
                           method="post"
                           enctype="multipart/form-data">
                    <input type="hidden" name="gnodeId" value="${gnodeId}"/>
                    <input type="hidden" name="proModelId" value="${proModel.id}"/>
                    <input type="hidden" name="id" value="${proReport.id}"/>

                    <div class="edit-bar edit-bar-sm clearfix">
                        <div class="edit-bar-left">
                            <span>已取得阶段性成果</span>
                            <i class="line"></i>
                        </div>
                    </div>
                    <div class="stage-result">
                            ${proReport.stageResult }
                    </div>
                    <div class="edit-bar edit-bar-sm clearfix">
                        <div class="edit-bar-left">
                            <span>附件</span>
                            <i class="line"></i>
                        </div>
                    </div>
                    <div class="row row-user-info">
                        <div class="col-xs-12">
                            <%--<label class="label-static">附件：</label>--%>
                            <div class="form-control-static" style="padding: 0">
                                <sys:frontFileUpload className="accessories-h34" fileitems="${proReport.files}"
                                                     readonly="true"></sys:frontFileUpload>
                            </div>
                        </div>
                    </div>
                </form:form>
                <div class="text-center">
                    <button type="button" onclick="history.go(-1)" class="btn btn-default">返回</button>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="dialogCyjd" class="dialog-cyjd"></div>

</body>
</html>
