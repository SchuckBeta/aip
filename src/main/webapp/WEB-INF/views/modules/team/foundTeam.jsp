<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";%>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>${frontTitle}</title>
    <meta charset="UTF-8">
    <meta name="decorator" content="creative"/>
</head>

<body>

<div id="app" v-show="pageLoad" class="container page-container pdt-60" style="display: none">
    <%--<el-breadcrumb class="mgb-20" separator="/">--%>
        <%--<el-breadcrumb-item><a href="${ctxFront}">首页</a></el-breadcrumb-item>--%>
        <%--<el-breadcrumb-item><a href="${ctxFront}/team/indexMyTeamList">团队建设</a></el-breadcrumb-item>--%>
        <%--<el-breadcrumb-item>邀请成员</el-breadcrumb-item>--%>
    <%--</el-breadcrumb>--%>
    <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item><a href="${ctxFront}"><i class="iconfont icon-ai-home" style="font-size: 12px;"></i>首页</a></el-breadcrumb-item>
        <el-breadcrumb-item>人才库</el-breadcrumb-item>
        <el-breadcrumb-item><a href="${ctxFront}/team/indexMyTeamList">团队建设</a></el-breadcrumb-item>
        <el-breadcrumb-item>邀请成员</el-breadcrumb-item>
    </el-breadcrumb>
    <div class="member_joined-container">
        <div class="member-student-row">
            <div class="text-right mgb-20">
                <el-button type="primary" size="mini" @click.stop.prevent="inviteStudent">邀请组员</el-button>
            </div>
            <el-table :data="studentList" class="custom-box-shadow" size="mini">
                <el-table-column align="center" width="230" label="团队成员">
                    <template slot-scope="scope">
                        <e-student-profile-member :user="scope.row" :name="scope.row.uName" :profession="getProfessionName(scope.row.professional)"></e-student-profile-member>
                    </template>

                </el-table-column>
                <el-table-column align="center" prop="no" label="学号"></el-table-column>
                <el-table-column align="center" label="学院">
                    <template slot-scope="scope">{{scope.row.officeId}}</template>
                </el-table-column>
                <%--<el-table-column align="center" label="专业">--%>
                    <%--<template slot-scope="scope">{{getProfessionName(scope.row.professional)}}</template>--%>
                <%--</el-table-column>--%>
                <el-table-column align="center" label="现状" width="62">
                    <template slot-scope="scope">{{getCurStateLabel(scope.row.currState)}}</template>
                </el-table-column>
                <el-table-column align="center" label="技术领域">
                    <template slot-scope="scope">{{scope.row.domainlt}}</template>
                </el-table-column>
                <%--<el-table-column align="center" label="联系电话" width="98">--%>
                    <%--<template slot-scope="scope">{{scope.row.mobile}}</template>--%>
                <%--</el-table-column>--%>
                <%--<el-table-column align="center" label="当前在研">--%>
                    <%--<template slot-scope="scope">{{scope.row.curJoin}}</template>--%>
                <%--</el-table-column>--%>
                <el-table-column align="center" prop="state" label="状态" width="106">
                    <template slot-scope="scope">{{scope.row.state | studentState}}</template>
                </el-table-column>
                <el-table-column align="center" label="操作" width="142">
                    <template slot-scope="scope">
                        <div class="table-btns-action">
                            <el-button type="text" :disabled="scope.row.state != 1" size="mini"
                                       @click.stop.prevent="acceptUserInvitation(scope)">同意
                            </el-button>
                            <el-button type="text" :disabled="scope.row.state != '1'" size="mini"
                                       @click.stop.prevent="refuseUserInvitation(scope, 'studentList')">拒绝
                            </el-button>
                            <el-button type="text" :disabled="scope.row.sponsor == scope.row.userId" size="mini"
                                       @click.stop.prevent="delTeamMember(scope.row, scope.$index, 'studentList')">删除
                            </el-button>
                        </div>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <div class="member-teacher-row">
            <div class="text-right mgb-20">
                <el-button type="primary" size="mini" @click.stop.prevent="inviteTeacher">邀请导师</el-button>
            </div>
            <el-table :data="teacherList" class="custom-box-shadow" size="mini">
                <el-table-column align="center" width="230" label="导师">
                    <template slot-scope="scope">
                        <e-teacher-profile-member :user="scope.row" :name="scope.row.uName" :college="scope.row.officeId" :source="getTeacherSourceLabel(scope.row.teacherType)"></e-teacher-profile-member>
                    </template>
                </el-table-column>
                <el-table-column align="center" label="工号">
                    <template slot-scope="scope">{{scope.row.no}}</template>
                </el-table-column>
                <%--<el-table-column align="center" label="学院或企业、机构">--%>
                    <%--<template slot-scope="scope">{{scope.row.officeId}}</template>--%>
                <%--</el-table-column>--%>
                <%--<el-table-column align="center" label="导师来源" width="86">--%>
                    <%--<template slot-scope="scope">{{getTeacherSourceLabel(scope.row.teacherType)}}</template>--%>
                <%--</el-table-column>--%>
                <el-table-column align="center" label="技术领域" width="190">
                    <template slot-scope="scope">{{scope.row.domainlt}}</template>
                </el-table-column>
                <%--<el-table-column align="center" label="当前指导">--%>
                    <%--<template slot-scope="scope">{{scope.row.curJoin}}</template>--%>
                <%--</el-table-column>--%>
                <el-table-column align="center" label="状态" width="106">
                    <template slot-scope="scope">{{scope.row.state | studentState}}</template>
                </el-table-column>
                <el-table-column align="center" label="操作" width="142">
                    <template slot-scope="scope">
                        <div class="table-btns-action">
                        <el-button type="text" :disabled="scope.row.state != 1" size="mini"
                                   @click.stop.prevent="acceptUserInvitation(scope)">同意
                        </el-button>
                        <el-button type="text" :disabled="scope.row.state != '1'" size="mini"
                                   @click.stop.prevent="refuseUserInvitation(scope, 'teacherList')">拒绝
                        </el-button>
                        <el-button type="text" :disabled="scope.row.sponsor == scope.row.userId" size="mini"
                                   @click.stop.prevent="delTeamMember(scope.row, scope.$index, 'teacherList')">删除
                        </el-button>
                            </div>
                    </template>
                </el-table-column>
            </el-table>
        </div>
    </div>
    <div class="team-member-container" v-show="userListParams.userType" ref="listenScroll">
        <el-form size="mini" autocomplete="off" class="user-list-params-from">
            <input type="hidden" name="id" :value="teamId">
            <div class="conditions">
                <div v-show="userListParams.userType === '1'">
                    <e-condition type="radio" v-model="userListParams.currState" label="现状" :options="currentStates"
                                 name="currState"></e-condition>
                </div>
                <e-condition type="checkbox" :label="curJoinLabel" :options="curJoinProjects"
                             v-model="userListParams.curJoinStr"
                             name="curJoinStr"></e-condition>
            </div>
            <div class="search-block_bar clearfix">
                <div class="search-btns">
                    <el-button v-show="opType === '1'" type="primary" size="mini">确定发布</el-button>
                    <el-button v-show="opType === '2'" type="primary"
                               :disabled="userListTeacherMultipleTable.length < 1 && userListStudentMultipleTable.length < 1"
                               size="mini" @click.stop.prevent="sendInvite">发送邀请
                    </el-button>
                </div>
                <div class="search-input">
                    <el-input
                            name="userName"
                            :placeholder="searchInputPlaceholder"
                            v-model="userListParams.userName"
                            size="mini"
                            style="width: 270px;">
                        <el-button type="button" slot="append" icon="el-icon-search"
                                   @click.stop.prevent="getUserList"></el-button>
                    </el-input>
                </div>
            </div>
        </el-form>
        <el-row>
            <el-col v-show="!isFullUserList" :span="5">
                <div class="college_selected_tree">
                    <div v-show="userListParams.userType === '2'" class="user-teacher_qy">
                        <a class="el-tree-node__label" href="javascript: void(0);"
                           @click.stop.prevent="getCompanyTeacherList">企业导师</a>
                    </div>
                    <el-tree :data="collegesTree" :props="defaultProps"
                             :highlight-current="highlightTree"
                             default-expand-all
                             :expand-on-click-node="false"
                             @node-click="handleNodeClick"></el-tree>
                </div>
            </el-col>
            <el-col :span="isFullUserList?24:19">
                <div class="control-table_user-width" @click="isFullUserList = !isFullUserList">
                    <i v-show="!isFullUserList" class="iconfont icon-triangle-arrow-l"></i>
                    <i v-show="isFullUserList" class="iconfont icon-triangle-arrow-r"></i>
                </div>
                <div class="table_user-list-container">
                    <div v-loading="dataLoading"
                         class="table_user_wrapper">
                        <el-table v-show="userListParams.userType === '1'" :data="userListStudent"
                                  ref="userListStudentMultipleTable"
                                  class="mgb-20"
                                  @selection-change="handleSelectionStudentChange" size="mini">
                            <el-table-column
                                    type="selection"
                                    :selectable="selectableStudent"
                                    width="60">
                            </el-table-column>
                            <el-table-column align="center" label="姓名">
                                <template slot-scope="scope">{{scope.row.name}}</template>
                            </el-table-column>
                            <el-table-column align="center" label="学号">
                                <template slot-scope="scope">{{scope.row.no}}</template>
                            </el-table-column>
                            <el-table-column align="center" label="现状" width="62">
                                <template slot-scope="scope">{{scope.row.currStateStr}}</template>
                            </el-table-column>
                            <%--<el-table-column align="center" label="当前在研">--%>
                                <%--<template slot-scope="scope">{{scope.row.curJoin}}</template>--%>
                            <%--</el-table-column>--%>
                            <el-table-column align="center" label="技术领域" width="180">
                                <template slot-scope="scope">{{scope.row.domainlt}}</template>
                            </el-table-column>
                        </el-table>
                        <el-table v-show="userListParams.userType === '2'" :data="userListTeacher"
                                  ref="userListTeacherMultipleTable"
                                  class="mgb-20"
                                  @selection-change="handleSelectionTeacherChange" size="mini">
                            <el-table-column
                                    type="selection"
                                    :selectable="selectableTeacher"
                                    width="60">
                            </el-table-column>
                            <el-table-column align="center" label="姓名">
                                <template slot-scope="scope">{{scope.row.name}}</template>
                            </el-table-column>
                            <el-table-column align="center" label="工号">
                                <template slot-scope="scope">{{scope.row.no}}</template>
                            </el-table-column>
                            <%--<el-table-column align="center" label="当前在研">--%>
                                <%--<template slot-scope="scope">{{scope.row.curJoin}}</template>--%>
                            <%--</el-table-column>--%>
                            <el-table-column align="center" label="技术领域">
                                <template slot-scope="scope">{{scope.row.domainlt}}</template>
                            </el-table-column>
                            <el-table-column align="center" label="导师来源" width="86">
                                <template slot-scope="scope">{{getTeacherSourceLabel(scope.row.teacherType)}}</template>
                            </el-table-column>
                        </el-table>
                    </div>


                    <div class="text-right">
                        <el-pagination
                                size="small"
                                @size-change="handlePaginationSizeChange"
                                background
                                @current-change="handlePaginationPageChange"
                                :current-page.sync="userListParams.pageNo"
                                :page-sizes="[5,10,20,50,100]"
                                :page-size="userListParams.pageSize"
                                layout="prev, pager, next, sizes"
                                :total="userListParams.total">
                        </el-pagination>
                    </div>

                </div>
            </el-col>
        </el-row>
    </div>

</div>

<script>

    ;+function (Vue) {

        var eStudentProfileMember = Vue.component('e-student-profile-member',{
            template: '<div class="e-user-profile_member">' +
            '<div class="user-pic"><img :src="user.avatar | ftpHttpFilter(ftpHttp) | studentPicFilter"></div>' +
            '<div class="user-intro"><div class="user-name">{{name}}</div><div class="user-profession">{{profession}}</div><div class="user-mobile">{{user.mobile}}</div></div></div>',
            props: {
                user: Object,
                type: String,
                name: String,
                profession: String
            }
        })

        var eTeacherProfileMember = Vue.component('e-teacher-profile-member',{
            template: '<div class="e-user-profile_member">' +
            '<div class="user-pic"><img :src="user.avatar | ftpHttpFilter(ftpHttp) | studentPicFilter"></div>' +
            '<div class="user-intro"><div class="user-name">{{name}}</div><div class="user-college">{{college}}</div><div class="user-source">{{source}}</div></div></div>',
            props: {
                user: Object,
                type: String,
                college: String,
                name: String,
                source: String
            }
        })


        var app = new Vue({
            el: '#app',
            mixins: [Vue.collegesMixin],
            data: function () {
                var currentStates = JSON.parse('${fns: getDictListJson("current_sate")}') || [];
                var professionals = JSON.parse('${fns: getOfficeListJson()}') || [];
                var teacherTypes = JSON.parse('${fns: getDictListJson('master_type')}') || [];
                var curJoinProjects = JSON.parse('${fns:toJson(fns: getPublishDictList())}') || [];

                return {
                    teamId: '${teamId}',
                    opType: '2',
                    studentList: [],
                    teacherList: [],
                    colleges: professionals,
                    currentStates: currentStates,
                    teacherTypes: teacherTypes,
                    curJoinProjects: curJoinProjects,
                    defaultProps: {
                        label: 'name',
                        children: 'children'
                    },
                    userListStudent: [],
                    userListTeacher: [],
                    userListTeacherMultipleTable: [],
                    userListStudentMultipleTable: [],
                    userListParams: {
                        userName: '',
                        userType: '',
                        curJoinStr: [],
                        currState: '',
                        pageSize: 10,
                        total: 0,
                        pageNo: 1,
                    },
                    collegesTreeOriginName: '',
                    highlightCurrentCollege: false,
                    highlightTree: false,
                    paginationDisabled: true,
                    isFullUserList: false,
                    dataLoading: false,
                    inviteOffsetTop:0
                }
            },
            filters: {
                studentState: function (state) {
                    switch (state) {
                        case '0':
                            return '已加入';
                            break;
                        case '1':
                            return '申请加入';
                            break;
                        case '2':
                            return '已发出邀请';
                            break;
                    }
                }
            },
            computed: {
                searchInputPlaceholder: {
                  get: function () {
                      var text;
                     text = this.userListParams.userType === '1' ? '学号' : '教工号';
                      return '姓名 / 技术领域 / '+ text;
                  }
                },

                teacherListIds: function () {
                    var ids = [];
                    this.teacherList.forEach(function (item) {
                        ids.push(item.userId);
                    })
                    return ids;
                },
                studentListIds: function () {
                    var ids = [];
                    this.studentList.forEach(function (item) {
                        ids.push(item.userId);
                    })
                    return ids;
                },
                currentStateEntries: function () {
                    var entries = {};
                    this.currentStates.forEach(function (item) {
                        entries[item.value] = item.label;
                    });
                    return entries;
                },
                teacherTypeEntries: function () {
                    var entries = {};
                    this.teacherTypes.forEach(function (item) {
                        entries[item.value] = item.label;
                    });
                    return entries;
                },
                inviteType: function () {
                    return this.opType === '1' ? '1' : '3'
                },
                curJoinLabel: function () {
                    var userType = this.userListParams.userType;
                    switch (userType) {
                        case "1":
                            return "当前在研";
                            break;
                        case "2":
                            return "当前指导";
                            break;
                    }
                }
            },
            methods: {

                selectableStudent: function (row) {
                    return this.studentListIds.indexOf(row.id) === -1;
                },
                selectableTeacher: function (row) {
                    return this.teacherListIds.indexOf(row.id) === -1;
                },

                //获取用户ID；
                getUserIds: function (users) {
                    var ids = [];
                    users.forEach(function (item) {
                        ids.push(item.id)
                    });
                    return ids;
                },

                //同意申请
                acceptUserInvitation: function (scope) {
                    var self = this;
                    this.$axios.put('/team/acceptUserInvitation/' + this.teamId + '?userId=' + scope.row.userId).then(function (response) {
                        var data = response.data;
                        if (data.status) {
                            scope.row.state = '0'
                        }
                        self.show$message(data);
                    })
                },

                //拒绝
                refuseUserInvitation: function (scope, dataKey) {
                    var self = this;
                    this.$confirm("确认拒绝" + scope.row.uName + "的加入团队请求吗？", "提示", {
                        confirmButtonText: '确定',
                        cancelButtonText: '取消',
                        type: 'info'
                    }).then(function () {
                        self.$axios.delete('/team/refuseUserInvitation/' + self.teamId + '?userId=' + scope.row.userId + '&turId=' + scope.row.turId).then(function (response) {
                            var data = response.data;
                            if (data.status) {
                                self[dataKey].splice(scope.$index, 1)
                            }
                            self.show$message(data);
                        })
                    }).catch(function () {

                    })

                },

                //发送申请
                sendInvite: function () {
                    var userType = this.userListParams.userType;
                    var self = this;
                    var userStr = userType === '2' ? '导师' : '学生';

                    this.$axios({
                        method: 'POST',
                        url: '/team/teamUserRelation/toInvite?'+Object.toURLSearchParams({
                            'userIds': userType == '2' ? this.getUserIds(this.userListTeacherMultipleTable) : this.getUserIds(this.userListStudentMultipleTable),
                            'teamId': this.teamId,
                            'userType': userType
                        }),
                    }).then(function (response) {
                        var data = response.data;
                        if (data.success) {
                            self.getTeamMember(userType);
                            self.$message({
                                type: 'success',
                                message: '成功邀请' + data.ret + '位' + userStr
                            });
                            self.$refs.userListTeacherMultipleTable.clearSelection();
                            self.$refs.userListStudentMultipleTable.clearSelection();
                            return
                        }
                        self.$message({
                            type: 'error',
                            message: data.msg || "邀请失败，邀请的人数超过，团队人数上限"
                        })

                    }).catch(function (error) {
                        self.$message({
                            type: 'error',
                            message: self.xhrErrorMsg
                        })
                    })

                },

                handleSelectionStudentChange: function (val) {
                    this.userListStudentMultipleTable = val;
                },
                handleSelectionTeacherChange: function (val) {
                    this.userListTeacherMultipleTable = val;
                },
                //重置pagination
                resetPagination: function () {
                    this.userListParams.pageNo = 1;
                    this.userListParams.pageSize = 10;
                },

                //重置officeId
                resetCollegeId: function () {
                    this.userListParams.professionId = '';
                    this.userListParams['office.id'] = '';
                },
                resetHighlightTree: function () {
                    this.highlightTree = false;
                },

                //邀请学生
                inviteStudent: function () {
                    if(this.userListParams.userType == '1'){
                        window.scrollTo(0, this.inviteOffsetTop);
                        return;
                    }
                    this.userListParams.userType = '1';
                    this.userListParams.teacherType = '';
                    this.resetPagination();
                    this.resetCollegeId();
                    this.resetHighlightTree();
                    this.resetUserListParams();
                    this.collegesTreeOriginName = this.getCollegesTreeOriginName(this.collegesTree[0].id);
                    this.collegesTree[0].name = this.collegesTreeOriginName;
                    this.getUserList();
                    this.$nextTick(function(){
                        this.inviteOffsetTop = this.$refs.listenScroll.offsetTop;
                        window.scrollTo(0, this.inviteOffsetTop)
                    });
                },


                //邀请导师
                inviteTeacher: function () {
                    if(this.userListParams.userType == '2'){
                        window.scrollTo(0, this.inviteOffsetTop);
                        return;
                    }
                    this.userListParams.userType = '2';
                    this.userListParams.teacherType = '';
                    this.resetPagination();
                    this.resetCollegeId();
                    this.resetHighlightTree();
                    this.resetUserListParams();
                    this.collegesTree[0].name = '校园导师';
                    this.getUserList()
                    this.$nextTick(function(){
                        this.inviteOffsetTop = this.$refs.listenScroll.offsetTop;
                        window.scrollTo(0, this.inviteOffsetTop)
                    });
                },

                getCollegesTreeOriginName: function (id) {
                    var name;
                    if (!this.collegesTreeOriginName) {
                        var collegesTranscript = this.collegesTranscript;
                        for (var i = 0; i < collegesTranscript.length; i++) {
                            if (collegesTranscript[i].id === id) {
                                name = collegesTranscript[i].name;
                                break;
                            }
                        }
                        return name;
                    }
                    return this.collegesTreeOriginName;
                },


                getCurStateLabel: function (state) {
                    if (!state) return '';
                    return this.currentStateEntries[state];
                },

                getProfessionName: function (id) {
                    if (!id) return '';
                    return this.collegeEntries[id] ? this.collegeEntries[id].name : '';
                },

                getTeacherSourceLabel: function (value) {
                    if (!value) return '';
                    return this.teacherTypeEntries[value];
                },

                //删除
                delTeamMember: function (row, index, key) {
                    var self = this;
                    return this.$axios.delete('/team/ajaxDeleteTeamMember/' + this.teamId + "?turId=" + row.turId + "&userId=" + row.userId).then(function (response) {
                        var data = response.data;
                        if (data.status) {
                            self[key].splice(index, 1)
                        }
                        self.$message({
                            type: data.status ? 'success':'error',
                            message: data.msg
                        })
                    }).catch(function (error) {
                        self.$message({
                            type: 'error',
                            message: self.xhrErrorMsg
                        })
                    })
                },

                //获取企业导师
                getCompanyTeacherList: function () {
                    this.userListParams.teacherType = '2';
                    this.userListParams['office.id'] = '';
                    this.userListParams.professionId = '';
                    this.getUserList();
                },

                //查找用户
                handleNodeClick: function (data) {
                    var grade = data.grade;
                    this.highlightTree = true;
                    switch (grade) {
                        case "2":
                            this.userListParams['office.id'] = data.id;
                            this.userListParams.professionId = '';
                            break;
                        case "3":
                        case "4":
                            this.userListParams['office.id'] = '';
                            this.userListParams.professionId = data.id;
                            break;
                        default:
                            this.userListParams['office.id'] = '';
                            this.userListParams.professionId = '';
                    }

                    this.userListParams.grade = (data.grade === '2' || data.grade === '3') ? data.grade : '';
                    this.userListParams.teacherType = '1';
                    this.userListParams.pageNo = 1;
                    this.getUserList();
                },


                //获取查找用户参数
                getUserListParams: function () {
                    var userListParamsCopy = JSON.parse(JSON.stringify(this.userListParams));
                    userListParamsCopy.curJoinStr = userListParamsCopy.curJoinStr.join(',');
                    return userListParamsCopy;
                },

                //重置查找用户参数
                resetUserListParams: function () {
                    this.userListParams.curJoinStr = [];
                    this.userListParams.currState = '';
                    this.userListParams.userName = '';
                },

                //获取成员树
                getUserList: function () {
                    var self = this;
                    var teamMemberXhr;
                    this.paginationDisabled = true;
                    this.dataLoading = true;
                    teamMemberXhr = this.$axios({
                        method: 'GET',
                        url: '/sys/user/ajaxUserListTree',
                        params: this.getUserListParams()
                    });
                    teamMemberXhr.then(function (response) {
                        var data = response.data;
                        if (data.status) {
                            data = data.datas;
                            self[self.userListParams.userType === '1' ? 'userListStudent' : 'userListTeacher'] = data.list;
                            self.userListParams.pageSize = data.pageSize;
                            self.userListParams.total = data.total;
                            self.userListParams.pageNo = data.pageNo;
                            self.paginationDisabled = false;
                        }
                        self.dataLoading = false;

                    }).catch(function (error) {
                        self.dataLoading = false;
                        self.show$message({
                            status: false,
                            msg: error.response ? error.response.data : error
                        })
                    })
                },

                handlePaginationSizeChange: function (value) {
                    this.userListParams.pageSize = value;
                    this.userListParams.pageNo = 1;
                    this.getUserList()
                },


                handlePaginationPageChange: function (value) {
                    this.userListParams.pageNo = value;
                    this.getUserList()
                },

                //获取成员
                getTeamMember: function (type) {
                    var self = this;
                    return this.$axios.get('/team/ajaxTeamMember/' + this.teamId + '?userType=' + type).then(function (response) {
                        var data = response.data;
                        if (data.status) {
                            data = data.datas;
                            var arr = [];
                            var listKey = type === '1' ? 'studentList' : 'teacherList';
                            if (!type) {
                                arr.push('studentList', 'teacherList')
                            } else {
                                arr.push(listKey)
                            }
                            arr.forEach(function (item) {
                                self[item] = data[item]
                            })
                        }
                    })
                }


            },
            beforeMount: function () {
                this.getTeamMember();
//                this.getUserList();
//                console.log(this.curJoinProjects)
//                console.log(this.userListParams.curJoinStr)
            },
            mounted: function () {

            }
        })
    }(Vue);


</script>
</body>
</html>