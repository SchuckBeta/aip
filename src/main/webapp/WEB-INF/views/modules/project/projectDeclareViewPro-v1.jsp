<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${frontTitle}</title>
    <meta name="decorator" content="creative"/>
    <script src="/js/components/eColItem/eColItem.js"></script>
</head>
<body>


<div id="doubleProject" class="space-container space-project">

    <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item><a href="${ctxFront}"><i class="iconfont icon-ai-home" style="font-size: 12px;"></i>首页</a></el-breadcrumb-item>
        <el-breadcrumb-item><a href="${ctxFront}/page-innovation">双创项目</a></el-breadcrumb-item>
        <el-breadcrumb-item><a href="${ctxFront}/project/projectDeclare/curProject">我的项目</a></el-breadcrumb-item>
        <el-breadcrumb-item><a href="${ctxFront}/project/projectDeclare/list">项目列表</a></el-breadcrumb-item>
        <el-breadcrumb-item>项目详情</el-breadcrumb-item>
    </el-breadcrumb>
    <div class="mySpace-content">
        <div class="mySpace-center">
            <div class="mySpace-project">
                <p class="mySpace-project-header"><span>我的项目</span></p>
                <div class="mySpace-project-list">
                    <div class="project-list-padding">
                        <div class="mySpace-top">
                            <div class="top-padding">
                                <div class="spaceTop-intro">
                                    <img src="/img/u4130.png" alt="" align="left" hspace="5" vspace="5">
                                    <ul>
                                        <li>${projectDeclare.name}</li>
                                        <c:if test="${projectDeclare.id!=null}">
                                            <li>项目编号：${projectDeclare.number}</li>
                                        </c:if>
                                        <li>项目类别：
                                            <c:forEach var="proType" items="${project_type}">
                                                <c:if test="${proType.value eq projectDeclare.type }">${proType.label}</c:if>
                                            </c:forEach>
                                            <c:forEach var="gcType" items="${competition_type}">
                                                <c:if test="${gcType.value eq projectDeclare.type }">${gcType.label}</c:if>
                                            </c:forEach>
                                        </li>
                                        <li>所属学院：${leader.office.name}</li>
                                        <li>申报日期：${sysdate}</li>
                                        <%--<li>申请人：${creater.name}</li>--%>
                                    </ul>
                                </div>
                                <ul class="spaceTop-tab">
                                    <li><span class="tab-acitve">项目信息</span></li>
                                    <li><span>团队成员</span></li>
                                    <c:if test="${projectDeclare.status!=null&&projectDeclare.status!='0'&&(not empty projectDeclareVo.auditInfo.level_d||not empty projectDeclareVo.auditInfo.mid_d||not empty projectDeclareVo.auditInfo.final_d)}">
                                        <li><span>审核记录</span></li>
                                    </c:if>
                                </ul>
                            </div>
                        </div>

                        <div class="tab-content tab-content1">
                            <div class="project-introdu">
                                <p class="introdu-title">负责人信息 </p>
                                <div class="introdu-content">
                                    <el-row :gutter="20">
                                        <el-col :span="8">
                                            <e-col-item label="项目负责人：" align="right">${leader.name}</e-col-item>
                                        </el-col>
                                        <el-col :span="8">
                                            <e-col-item label="学院：" align="right">${leader.office.name}</e-col-item>
                                        </el-col>
                                        <el-col :span="8">
                                            <e-col-item label="学号：" align="right">{{leader.no}}</e-col-item>
                                        </el-col>
                                    </el-row>

                                    <el-row :gutter="20">
                                        <el-col :span="8">
                                            <e-col-item label="专业年级："
                                                        align="right">${fns:getProfessional(leader.professional)}</e-col-item>
                                        </el-col>
                                        <el-col :span="8">
                                            <e-col-item label="联系电话：" align="right">${leader.mobile}</e-col-item>
                                        </el-col>
                                        <el-col :span="8">
                                            <e-col-item label="E-mail：" align="right">${leader.email}</e-col-item>
                                        </el-col>
                                    </el-row>
                                </div>
                            </div>
                            <div class="project-introdu">
                                <p class="introdu-title">项目基本信息 </p>
                                <div class="introdu-content">
                                    <el-row :gutter="20">
                                        <el-col :span="8">
                                            <e-col-item label="项目名称：" align="right">${projectDeclare.name}</e-col-item>
                                        </el-col>
                                        <el-col :span="8">
                                            <e-col-item label="项目类别：" align="right">{{projectType |
                                                projectFilter(projectTypesEntries)}}
                                            </e-col-item>
                                        </el-col>
                                        <el-col :span="8">
                                            <e-col-item label="项目来源：" align="right">{{projectSource |
                                                projectFilter(projectSourcesEntries)}}
                                            </e-col-item>
                                        </el-col>
                                    </el-row>
                                    <el-row :gutter="20">
                                        <el-col :span="8">
                                            <e-col-item label="项目拓展及传承：" align="right">{{projectExtend |
                                                projectFilter(projectExtendsEntries)}}
                                            </e-col-item>
                                        </el-col>
                                    </el-row>
                                </div>
                            </div>
                            <div class="project-introdu">
                                <p class="introdu-title">项目介绍 </p>
                                <div class="introdu-content">
                                    <el-row :gutter="20">
                                        <el-col :span="24" class="hidden-block">
                                            <div>项目介绍：</div>
                                            <div>${projectDeclare.introduction}</div>
                                        </el-col>
                                    </el-row>

                                    <el-row :gutter="20">
                                        <el-col :span="24" class="hidden-block">
                                            <div>前期调研准备：</div>
                                            <div>${projectDeclare.innovation}</div>
                                        </el-col>
                                    </el-row>

                                    <el-row :gutter="20">
                                        <el-col :span="24" class="hidden-block">
                                            <div>项目预案：</div>
                                            <div>
                                                <table class="table table-bordered table-team yuantb table-hover">
                                                    <thead>
                                                    <tr>
                                                        <th>实施预案</th>
                                                        <th width="300">时间安排</th>
                                                        <th>保障措施</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody>
                                                    <tr>
                                                        <td data-line-feed="textarea">${projectDeclare.planContent}</td>
                                                        <td style="vertical-align: middle"><fmt:formatDate
                                                                value="${projectDeclare.planStartDate }"
                                                                pattern="yyyy-MM-dd"/>至<fmt:formatDate
                                                                value="${projectDeclare.planEndDate }"
                                                                pattern="yyyy-MM-dd"/>
                                                        </td>
                                                        <td data-line-feed="textarea">${projectDeclare.planStep}</td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </el-col>
                                    </el-row>

                                    <el-row :gutter="20">
                                        <el-col :span="24" class="hidden-block">
                                            <div>任务分工：</div>
                                            <div>
                                                <table class="table table-bordered table-team task table-hover">
                                                    <thead>
                                                    <tr>
                                                        <th width="48">序号</th>
                                                        <th>工作任务</th>
                                                        <th>任务描述</th>
                                                        <th>时间安排</th>
                                                        <th>成本（元）</th>
                                                        <th>质量评价</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody>
                                                    <c:if
                                                            test="${projectDeclareVo.plans!=null&&projectDeclareVo.plans.size() >0}">
                                                        <c:forEach items="${projectDeclareVo.plans}" var="item"
                                                                   varStatus="status">
                                                            <tr>
                                                                <td>${status.index+1}</td>
                                                                <td data-line-feed="textarea">${projectDeclareVo.plans[status.index].content }</td>
                                                                <td data-line-feed="textarea">${projectDeclareVo.plans[status.index].description }</td>
                                                                <td style="vertical-align: middle">
                                                                    <div class="time-input-inline">
                                                                        <fmt:formatDate
                                                                                value="${projectDeclareVo.plans[status.index].startDate }"
                                                                                pattern="yyyy-MM-dd"/>
                                                                        至
                                                                        <fmt:formatDate
                                                                                value="${projectDeclareVo.plans[status.index].endDate }"
                                                                                pattern="yyyy-MM-dd"/>
                                                                    </div>
                                                                </td>
                                                                <td style="vertical-align: middle">${projectDeclareVo.plans[status.index].cost }</td>
                                                                <td data-line-feed="textarea">${projectDeclareVo.plans[status.index].quality }</td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:if>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </el-col>
                                    </el-row>

                                </div>
                            </div>

                            <div class="project-introdu">
                                <p class="introdu-title">预期成果 </p>
                                <div class="introdu-content">

                                    <el-row :gutter="20">
                                        <el-col :span="24" class="hidden-block">
                                            <div>成果形式：</div>
                                            <div>{{projectResultType | checkboxValueFilter(projectResultTypesEntries)}}</div>
                                        </el-col>
                                    </el-row>

                                    <el-row :gutter="20">
                                        <el-col :span="24" class="hidden-block">
                                            <div>成果说明：</div>
                                            <div>${projectDeclare.resultContent}</div>
                                        </el-col>
                                    </el-row>

                                </div>
                            </div>


                            <c:if test="${projectDeclare.budget!= null && projectDeclare.budget != '' && projectDeclare.budget != undefined}">
                                <div class="project-introdu">
                                    <p class="introdu-title">经费预算 </p>
                                    <div class="introdu-content">
                                        <div class="introdu-word">${projectDeclare.budget}</div>
                                    </div>
                                </div>
                            </c:if>

                            <div class="project-introdu project-paper"
                                 v-show="projectDeclareVoFileInfo != null && projectDeclareVoFileInfo != '' && projectDeclareVoFileInfo != undefined">
                                <p class="introdu-title">项目材料<a href="/f/project/projectDeclare/curProject">提交材料</a></p>
                                <div class="introdu-content">
                                    <ul id='timeline'>
                                        <li class="work" v-for="file in projectDeclareVoFileInfo">
                                            <img src="/images/time-line.png" alt="">
                                            <div class="relative">
                                                <e-file-item :file="file" size="mini" :show="false"></e-file-item>
                                                <span class='date'>{{file.createDate | formatDateFilter('YYYY-MM-DD HH:mm')}}</span>
                                            </div>
                                        </li>
                                    </ul>
                                    <%--<sys:frontFileUploadNew fileitems="${projectDeclareVo.fileInfo}" className="accessories-h34" readonly="true"></sys:frontFileUploadNew>--%>
                                </div>
                                <%--<div class="introdu-content" v-else>--%>
                                <%--<div style="text-align: center;margin-top:28px;">暂无附件材料</div>--%>
                                <%--</div>--%>
                            </div>

                        </div>

                        <div class="tab-content tab-content2 tab-p">
                            <div class="project-introdu">
                                <p class="introdu-title">团队成员</p>
                                <ul class="tab-team-info">
                                    <li v-for="student in teamStudent"
                                        v-if="teamStudent != null && teamStudent.length > 0 && teamStudent != undefined">
                                        <img src="/images/cxf.jpg" alt="" align="left" hspace="5" vspace="5">
                                        <p class="name"><span>{{student.name}}
                                        	<span v-show="leader.id == student.userId">（项目负责人）</span>
                                        </span></p>
                                        <p>学号：{{student.no}} &nbsp;&nbsp;&nbsp;&nbsp;{{student.instudy}}</p>
                                        <p>{{student.org_name}}/{{student.professional}} &nbsp;&nbsp;&nbsp;&nbsp;
                                            <span v-show="checkMenuByNum && student.weightVal">学分配比：{{student.weightVal}}</span>
                                        </p>
                                        <p>联系方式：{{student.mobile}}</p>
                                        <p>技术领域：{{student.domain}}</p>

                                    </li>
                                    <div v-else style="text-align: center;margin:30px 0">目前没有学生加入到团队中，快去邀请吧...</div>
                                </ul>
                                <ul class="tab-team-info tab-team-teacher">
                                    <li v-for="teacher in teamTeacher"
                                        v-if="teamTeacher != null && teamTeacher.length > 0 && teamTeacher != undefined">
                                        <img src="/images/cxf.jpg" alt="" align="left" hspace="5" vspace="5">
                                        <p class="name"><span>{{teacher.name}}（{{teacher.teacherType}}）</span></p>
                                        <p>工号：{{teacher.no}}</p>
                                        <p>{{teacher.org_name}} &nbsp;&nbsp;&nbsp;&nbsp;{{teacher.technical_title}}</p>
                                        <p>联系方式：{{teacher.mobile}}</p>
                                        <p>技术领域：{{teacher.domain}}</p>
                                    </li>
                                    <div v-else style="text-align: center;margin:30px 0">暂无导师</div>
                                </ul>
                            </div>
                        </div>

                        <c:if test="${projectDeclare.status !=null && projectDeclare.status !='0' && (not empty projectDeclareVo.auditInfo.level_d || not empty projectDeclareVo.auditInfo.mid_d || not empty projectDeclareVo.auditInfo.final_d)}">
                            <div class="tab-content tab-content3">
                                <div class="project-introdu">
                                    <p class="introdu-title">审核记录</p>
                                    <div class="introdu-content">
                                        <table class="table table-bordered table-condensed table-orange table-center table-nowrap table-hover">
                                            <thead>
                                            <tr>
                                                <th colspan="3">立项审核</th>
                                            </tr>
                                            <tr>
                                                <th>评级结果</th>
                                                <th>建议及意见</th>
                                                <th>评审时间</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:if test="${not empty projectDeclareVo.auditInfo.level_d}">
                                                <tr>
                                                    <td>${projectDeclareVo.auditInfo.level }</td>
                                                    <td>${projectDeclareVo.auditInfo.level_s }</td>
                                                    <td>${projectDeclareVo.auditInfo.level_d }</td>
                                                </tr>
                                            </c:if>
                                            <c:if test="${empty projectDeclareVo.auditInfo.level_d}">
                                                <tr>
                                                    <td colspan="3">暂无数据</td>
                                                </tr>
                                            </c:if>
                                            </tbody>
                                            <thead>
                                            <tr>
                                                <th colspan="3">中期审核</th>
                                            </tr>
                                            <tr>
                                                <th>评级结果</th>
                                                <th>建议及意见</th>
                                                <th>评审时间</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:if test="${not empty projectDeclareVo.auditInfo.mid_d}">
                                                <tr>
                                                    <td>${projectDeclareVo.auditInfo.mid_result }</td>
                                                    <td>${projectDeclareVo.auditInfo.mid_s }</td>
                                                    <td>${projectDeclareVo.auditInfo.mid_d }</td>
                                                </tr>
                                            </c:if>
                                            <c:if test="${empty projectDeclareVo.auditInfo.mid_d}">
                                                <tr>
                                                    <td colspan="3">暂无数据</td>
                                                </tr>
                                            </c:if>
                                            </tbody>
                                            <thead>
                                            <tr>
                                                <th colspan="3">结项审核</th>
                                            </tr>
                                            <tr>
                                                <th>评级结果</th>
                                                <th>建议及意见</th>
                                                <th>评审时间</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:if test="${not empty projectDeclareVo.auditInfo.final_d}">
                                                <tr>
                                                    <td>${projectDeclareVo.auditInfo.final_result }</td>
                                                    <td>${projectDeclareVo.auditInfo.final_s }</td>
                                                    <td>${projectDeclareVo.auditInfo.final_d }</td>
                                                </tr>
                                            </c:if>
                                            <c:if test="${empty projectDeclareVo.auditInfo.final_d}">
                                                <tr>
                                                    <td colspan="3">暂无数据</td>
                                                </tr>
                                            </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>

            </div>

        </div>
    </div>
</div>


<script>
    +function (Vue) {

        Vue.filter('projectFilter', function (value, projectTypes, key) {
            if (!value) {
                return ''
            }
            ;
            return projectTypes[value];
        })

        Vue.filter('checkboxValueFilter', function (value, projectTypes, key) {
            if (!value) {
                return ''
            }
            ;
            var valueArr = value.split(',');
            var arr = [];
            valueArr.forEach(function (item) {
                arr.push(projectTypes[item])
            })
            return arr.join('、');
        })

        var doubleProject = new Vue({
            el: '#doubleProject',
            data: function () {
                var checkMenuByNum = '${fns:checkMenuByNum(5)}';
                var projectDeclareVo = JSON.parse('${fns:toJson(projectDeclareVo)}');
//                var projectDeclareVo = {};
                var projectTypes = JSON.parse('${fns:toJson(project_type)}');
                var projectExtends = JSON.parse('${fns:toJson(project_extend)}');
                var projectResultTypes = JSON.parse('${fns:toJson(resultTypeList)}');
                var projectSources = JSON.parse('${fns:toJson(project_source)}');
                var projectDeclareVoFileInfo = JSON.parse('${fns:toJson(projectDeclareVo.fileInfo)}');
//                var projectDeclareVoFileInfo = [];
                return {
                    leader: JSON.parse('${fns:toJson(leader)}'),
                    teamStudent: projectDeclareVo.teamStudent,
                    teamTeacher: projectDeclareVo.teamTeacher,
                    checkMenuByNum: checkMenuByNum,
                    projectTypes: projectTypes,
                    projectExtends: projectExtends,
                    projectSources: projectSources,
                    projectResultTypes: projectResultTypes,
                    projectType: '${projectDeclare.type}',
                    projectSource: '${projectDeclare.source}',
                    projectExtend: '${projectDeclare.development}',
                    projectResultType: '${projectDeclare.resultType}',
                    projectDeclareVoFileInfo: projectDeclareVoFileInfo
                }
            },
            computed: {
                projectTypesEntries: {
                    get: function () {
                        var i = 0;
                        var entries = {};
                        for (var i = 0; i < this.projectTypes.length; i++) {
                            entries[this.projectTypes[i].value] = this.projectTypes[i].label;
                        }
                        return entries
                    }
                },
                projectExtendsEntries: {
                    get: function () {
                        var i = 0;
                        var entries = {};
                        for (var i = 0; i < this.projectExtends.length; i++) {
                            entries[this.projectExtends[i].value] = this.projectExtends[i].label;
                        }
                        return entries
                    }
                },
                projectResultTypesEntries: {
                    get: function () {
                        var i = 0;
                        var entries = {};
                        for (var i = 0; i < this.projectResultTypes.length; i++) {
                            entries[this.projectResultTypes[i].value] = this.projectResultTypes[i].label;
                        }
                        return entries
                    }
                },
                projectSourcesEntries: {
                    get: function () {
                        var i = 0;
                        var entries = {};
                        for (var i = 0; i < this.projectSources.length; i++) {
                            entries[this.projectSources[i].value] = this.projectSources[i].label;
                        }
                        return entries
                    }
                }
            },
            methods: {},
            created: function () {
//                console.log(this.projectDeclareVo);
            },
            mounted: function () {

            }
        })
    }(Vue)
</script>


<script>
    $(function () {
        $('.spaceTop-tab li span').click(function () {
            $('.tab-content').hide();
            $('.spaceTop-tab li span').removeClass('tab-acitve');
            var clicked = $(this).parent().index();
            var len = $('.tab-content').length;
            $('.tab-content').eq(clicked).show();
            $(this).addClass('tab-acitve')
        })
    })

</script>


</body>
</html>
