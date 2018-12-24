<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${frontTitle}</title>
    <meta name="decorator" content="creative"/>

</head>
<body>

<style>
    .team-teamName:hover{
        cursor: pointer;
    }
</style>

<div id="app" v-show="pageLoad" style="display: none;" class="page-container pdb-60 team-build">

    <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item><a href="${ctxFront}"><i class="iconfont icon-ai-home"></i>首页</a></el-breadcrumb-item>
        <el-breadcrumb-item>人才库</el-breadcrumb-item>
        <el-breadcrumb-item>团队建设</el-breadcrumb-item>
    </el-breadcrumb>

    <div class="team-build-process" v-show="userType == 1">
        <div class="process-label">团建步骤：</div>
        <ul>
            <li>第一步：创建团队</li>
            <li>第二步：待审核通过</li>
            <li>第三步：发布/邀请组员</li>
        </ul>
    </div>
    <el-form ref="createTeam" method="post" size="mini"
             label-width="130px" class="demo-ruleForm" :model="createTeam" :rules="rules" :disabled="formDisabled">
        <input id="id" name="id" type="hidden" :value="createTeam.id">
        <input id="state" name="state" type="hidden" :value="createTeam.state">
        <input id="number" name="number" type="hidden">
        <input id="proType" name="proType" type="hidden" value="${proType}">
        <div class="create-box" :class="{'box-border':isBorder}">
            <el-collapse-transition>
                <div class="box-form" v-show="createBox">
                    <el-row :gutter="20">
                        <el-col :span="6">
                            <el-form-item label="团队名称" prop="name" label-width="72px">
                                <el-input id="name" name="name" :old="oldList.name"
                                          v-model="createTeam.name"></el-input>
                            </el-form-item>

                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="所需组员人数(含项目负责人)" prop="memberNum" label-width="174px">
                                <el-tooltip class="item" :disabled="!studentMax" effect="dark" popper-class="white" :content="'人数不能超过'+studentMax+'人'" placement="top">
                                    <el-input-number id="memberNum" name="memberNum" :min="1" :max="parseInt(studentMax)" v-model.number="createTeam.memberNum"></el-input-number>
                                </el-tooltip>
                            </el-form-item>
                        </el-col>
                        <el-col :span="5">
                            <el-form-item label="所需校内导师数" prop="schoolTeacherNum">
                                <el-tooltip class="item" :disabled="!teacherMax" effect="dark" popper-class="white" :content="'人数不能超过'+teacherMax+'人'" placement="top">
                                    <el-input-number id="schoolTeacherNum" name="schoolTeacherNum" :min="parseInt(teacherMin)" :max="parseInt(teacherMax)" v-model.number="createTeam.schoolTeacherNum"></el-input-number>
                                </el-tooltip>
                            </el-form-item>
                        </el-col>
                        <el-col :span="6">
                            <el-form-item label="所需企业导师数" prop="enterpriseTeacherNum">
                                <el-input-number id="enterpriseTeacherNum" name="enterpriseTeacherNum" :min="0" v-model.number="createTeam.enterpriseTeacherNum"></el-input-number>
                            </el-form-item>
                        </el-col>
                    </el-row>
                    <el-row :gutter="20" class="member-top">
                        <el-col :span="12">
                            <el-form-item label="组员要求" prop="membership" label-width="72px">
                                <el-input id="membership" name="membership" :old="oldList.membership"
                                          type="textarea"
                                          v-model="createTeam.membership" :rows="4"
                                          placeholder="200字以内"></el-input>
                            </el-form-item>
                        </el-col>
                        <el-col :span="12">
                            <el-form-item label="团队介绍" prop="summary">
                                <el-input id="summary" name="summary" :old="oldList.summary"
                                          type="textarea"
                                          v-model="createTeam.summary" :rows="4"
                                          placeholder="500字以内"></el-input>
                            </el-form-item>
                        </el-col>
                    </el-row>
                </div>
            </el-collapse-transition>


            <div class="text-right" v-show="userType == 1">
                <el-button class="create-btn" v-show="createBox" type="primary" :disabled="formDisabled" @click="submitCreateForm('createTeam')"
                           size="mini">
                    保存
                </el-button>
                <el-button @click.stop="resetCreateForm" size="mini" v-show="createBox">取消</el-button>
            </div>

        </div>

    </el-form>

    <el-form class="clearfix">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>

        <div class="search-input">

            <el-input placeholder="请输入内容" v-model="searchText" :name="searchName" :id="searchName"
                      class="input-with-select"
                      style="width: 360px;margin-right:10px;" size="mini">
                <el-select v-model="selectOption" slot="prepend" placeholder="选择查询条件" style="width: 120px;"
                           @change="selectOption == 'nameSch' ? searchName = 'nameSch' : searchName = 'creator'">
                    <el-option v-for="option in options" :label="option.label" :value="option.value"
                               :key="option.value"></el-option>
                </el-select>
                <el-button slot="append" icon="el-icon-search"
                           @click.stop.prevent="searchCondition()"></el-button>
            </el-input>

            <el-button style="vertical-align: top;" type="primary" size="mini" class="search-create" v-show="userType == 1" :disabled="!isCanCreate" @click.stop.prevent="showForm" style="margin-left: 10px;">创建团队
            </el-button>
            <el-button style="vertical-align: top;" class="dele-btn" type="primary" size="mini"
                       :disabled="multipleSelectedId==null || multipleSelectedId==''"
                       @click.stop.prevent="deleteTeam(multipleSelectedId)">删除团队
            </el-button>
        </div>

        <div class="conditions mgb-20">
            <e-condition label="团队状态：" type="checkbox" :options="teamStates" v-model="teamState" name="stateSch" @change="searchCondition"></e-condition>
        </div>
    </el-form>


    <div class="table-container">
        <el-table ref="multipleTable" :data="teamList" size="small" style="width: 100%;"
                  class="team-table"
                  @selection-change="handleSelectionChange">
            <el-table-column type="selection" width="60" :selectable="selectable">
            </el-table-column>

            <el-table-column label="团队信息" align="center" width="300">
                <template slot-scope="scope">
                    <p class="team-name">
                        <span v-show="curUserId != scope.row.sponsorId && scope.row.state == 3">信息审核中</span>
                        <span v-show="curUserId != scope.row.sponsorId && scope.row.state == 4">信息审核未通过</span>
                        <span v-show="curUserId == scope.row.sponsorId || (scope.row.state != 3 && scope.row.state != 4)" class="team-teamName"
                              @click.stop.prevent="goName(scope.row.id)">{{scope.row.name}}</span>
                    </p>
                    <p>所属学院：{{scope.row.localCollege}}</p>
                    <p>创建日期：{{scope.row.createDate}}</p>
                </template>
            </el-table-column>

            <el-table-column prop="sponsor" label="团队负责人" align="center"></el-table-column>

            <el-table-column label="团队成员（已组建/共需）" align="center">
                <template slot-scope="scope">
                    <span :class="{red:isRed(scope.row.userCount,scope.row.memberNum)}">{{scope.row.userCount}}</span>/<span>{{scope.row.memberNum}}</span>
                    <p>{{scope.row.userName}}</p>
                </template>
            </el-table-column>

            <el-table-column label="团队导师（已组建/共需）" align="center">
                <template slot-scope="scope">
                    <span :class="{red:isRed(scope.row.schoolNum,scope.row.schoolTeacherNum)}">{{scope.row.schoolNum}}</span>/<span>{{scope.row.schoolTeacherNum}}</span>
                    <p>校内导师：{{scope.row.schName}}</p>
                    <span :class="{red:isRed(scope.row.enterpriseNum,scope.row.enterpriseTeacherNum)}">{{scope.row.enterpriseNum}}</span>/<span>{{scope.row.enterpriseTeacherNum}}</span>
                    <p>企业导师：{{scope.row.entName}}</p>
                </template>
            </el-table-column>

            <el-table-column prop="state" label="团队状态" align="center">
                <template slot-scope="scope">
                    <span>{{teamStatesEntries[scope.row.state]}}</span>
                </template>
            </el-table-column>

            <el-table-column  label="操作" align="center">
                <template slot-scope="scope">
                    <div class="do-p"
                         v-show="curUserId!=null && curUserId!='' && scope.row.sponsorId!=null && scope.row.sponsorId!='' && curUserId==scope.row.sponsorId && scope.row.state!=2">
                        <p>
                            <el-button type="text" size="small" :disabled="!isDisabled(scope.row.state == 0)"
                                       @click="releaseTeam(scope.row.id)">发布团队
                            </el-button>
                        </p>
                        <p>
                            <el-button type="text" size="small" :disabled="!isDisabled(scope.row.state == 0)"
                                       @click="goInvite(scope.row.id)">邀请组员
                            </el-button>
                        </p>
                        <p>
                            <el-button type="text" size="small"
                                       :disabled="!isDisabled(scope.row.state == 0 || scope.row.state == 1 || scope.row.state == 4)"
                                       @click="editTeam(scope.row)">编辑团队
                            </el-button>
                        </p>
                        <p>
                            <el-button type="text" size="small"
                                       :disabled="!isDisabled(scope.row.state !=2 && scope.row.state !=3)"
                                       @click="toDisTeam(scope.row.id)">解散团队
                            </el-button>
                        </p>
                    </div>
                    <div class="do-p">
                        <p>
                            <el-button type="text" size="small" :disabled="!isCanCreate"
                                       v-show="!scope.row.checkJoinTUR && userType!=2 && scope.row.state==0"
                                       @click="checkIfLogin(scope.row.id)">加入团队
                            </el-button>
                        </p>
                        <p>
                            <el-button type="text" size="small" v-show="!scope.row.checkJoinTUR || scope.row.state == 2"
                                       @click="deleteTeam(scope.row.id)">删除
                            </el-button>
                        </p>
                    </div>
                </template>
            </el-table-column>

        </el-table>
        <div class="text-right mgb-20" v-show="searchTeamList != 0">
            <el-pagination background
                    @size-change="handleSizeChange"
                    @current-change="handleCurrentChange"
                    :current-page="currentPage"
                    :page-sizes="[5,10,20,50,100]"
                    :page-size="eachLength"
                    layout="total, prev, pager, next, sizes"
                    :total="teamListLength">
            </el-pagination>
        </div>
    </div>




    <el-dialog title="团队发布" :visible.sync="dialogFormVisible" width="50%">
        <div class="team-publi">
            <div class="publi-list">
                <ul>
                    <li v-for="professional in professionals" v-if="professional.id == 1"
                        :class="{active:professional.id==currentProfessionalId,'table-first':professional.id==1}">
                        <span @click.stop.prevent="changeMajorTable(professional)"><span @click.stop.prevent="majorCollapse" class="add">{{isAdd}}</span> {{professional.name}}</span>
                    </li>
                    <el-collapse-transition>
                        <div v-show="isMajorShow">
                            <li v-for="(professional,index) in professionals" v-if="professional.parentId == 1"
                                :class="{active:professional.id==currentProfessionalId,'dashed-line':true}">
                                <span @click.stop.prevent="changeMajorTable(professional)">{{professional.name}}</span>
                            </li>
                        </div>
                    </el-collapse-transition>
                </ul>
            </div>
            <div class="publi-form">
                <el-table ref="multipleMajorTable" :data="clickedMajorList" size="small" style="width: 100%;"
                          @selection-change="handleSelectionMajor">
                    <el-table-column type="selection" width="60">
                    </el-table-column>

                    <el-table-column prop="name" label="专业" align="center">
                    </el-table-column>

                </el-table>
            </div>
        </div>
        <div slot="footer" class="dialog-footer">
            <el-button size="small" @click="dialogFormVisible = false">关闭</el-button>
            <el-button size="small" type="primary" :disabled="!isAble" class="confirm-release" @click="confirmRelease">
                {{releaseText}}
            </el-button>
        </div>
    </el-dialog>



</div>

<script>
    +function (Vue) {


        var app = new Vue({
            el: '#app',
            data: function () {
                var self = this;
                var professionals = JSON.parse('${fns: toJson(fns: getOfficeList())}');
                var validateName = function (rule, value, callback) {
                    var nameXhr;
                    nameXhr = self.$axios({
                        method: 'POST',
                        url: '/sys/user/ifTeamNameExist?'+ Object.toURLSearchParams({"name": value, "teamId": self.createTeam.id})
                    });
                    return nameXhr.then(function (response) {
                        var data = response.data;
                        if (!data) {
                            callback(new Error('团队名称已经存在'));
                        }
                        callback();
                    }).catch(function () {
                        self.$alert('操作异常', '提示', {
                            confirmButtonText: '确定',
                            type: 'warning'
                        });
                    })


                };
                var validateNum = function (rule, value, callback) {
                    if (value > 99) {
                        return callback(new Error('人数最多2位数'));
                    } else {
                        callback();
                    }
                };

                return {
                    professionals: professionals,
                    userType: '${userType}',
                    isAble: true,
                    createBox: false,
                    messageInfo: '${message}',
                    curUserId: '${curUserId}',
                    opType: '${opType}',
                    teamId: '',
                    isBorder: false,
                    pageNo: '${page.pageNo}' || 1,
                    pageSize: '${page.pageSize}',
                    multipleSelection: [],
                    multipleSelectedId: [],
                    currentStateIndex: '',
                    dialogFormVisible: false,
                    isActive: false,
                    currentProfessionalId: '',
                    clickedMajorList: [],
                    oneLevelMajorList:[],
                    multipleMajor: [],
                    multipleMajorId: [],
                    multipleMajorTable: {},
                    currentPage: 1,
                    teamListLength: 0,
                    eachLength: 5,
                    createTeam: {
                        id: '',
                        state: '',
                        name: '',
                        memberNum: '',
                        schoolTeacherNum: '',
                        enterpriseTeacherNum: '',
                        membership: '',
                        summary: '',
                        proType:'${proType}'
                    },
                    teamCheckOnOff: '${teamCheckOnOff}',

                    rules: {
                        name: [
                            {required: true, message: '请输入团队名称', trigger: 'blur'},
                            {min: 1, max: 64, message: '请输入1-64个字符', trigger: 'blur'},
                            {validator: validateName, trigger: 'blur'}
                        ],
                        memberNum: [
                            {required: true, message: '请输入所属组员人数', trigger: 'blur'},
                            {type: 'number', message: '请输入数字', trigger: 'blur'},
                            {validator: validateNum, trigger: 'change'}
                        ],
                        schoolTeacherNum: [
                            {required: true, message: '请输入所需校内导师数', trigger: 'blur'},
                            {type: 'number', message: '请输入数字', trigger: 'blur'},
                            {validator: validateNum, trigger: 'change'}
                        ],
                        membership: [
                            {required: true, message: '请输入组员要求', trigger: 'blur'},
                            {min: 1, max: 200, message: '请输入1-200个字符', trigger: 'blur'}
                        ],
                        summary: [
                            {required: true, message: '请输入团队介绍', trigger: 'blur'},
                            {min: 1, max: 500, message: '请输入1-500个字符', trigger: 'blur'}
                        ]
                    },
                    teamStates: [
                        {label: '建设中', value: '0'},
                        {label: '建设完毕', value: '1'},
                        {label: '解散', value: '2'},
                        {label: '待审核', value: '3'},
                        {label: '未通过', value: '4'}
                    ],
                    teamStatesEntries: {
                        '0': '建设中',
                        '1': '建设完毕',
                        '2': '解散',
                        '3': '待审核',
                        '4': '未通过'
                    },
                    teamState: [],
                    searchText: '',
                    selectOption: '',
                    teamList: [],
                    options: [
                        {label: '团队名称', value: 'nameSch'},
                        {label: '团队负责人', value: 'creator'}
                    ],
                    option: [],
                    searchName: '',
                    editAble: false,
                    oldList: {
                        name: '${team.name}',
                        membership: '${team.membership}',
                        summary: '${team.summary}'
                    },
                    isMajorShow: true,
                    isAdd:'+',
                    searchTeamList:'',
                    isCanCreate:true,
                    releaseText:'确认发布',
                    teacherMin:'${teacherMin}',
                    teacherMax:'${teacherMax}',
                    studentMax:'${studentMax}',
                    formDisabled:false
                }
            },
            computed: {
                formAction: function () {
                    return '${ctxFront}/team/indexSave' + '?' + this.selectOption + '=' + this.searchText + "&stateSch=" + this.teamState + "&pageNo=" + this.pageNo + "&pageSize=" + this.pageSize
                }
            },
            methods: {
                majorCollapse:function(){
                    this.isMajorShow = !this.isMajorShow;
                    !this.isMajorShow ? this.isAdd = '-' : this.isAdd = '+';
                },
                handleSizeChange: function (val) {
                    this.eachLength = val;
                    this.searchCondition();
                },
                handleCurrentChange: function (val) {
                    this.currentPage = val;
                    this.searchCondition();
                },
                releaseTeam: function (id) {
                    this.multipleMajorId = [];
                    this.dialogFormVisible = true;
                    this.currentProfessionalId = '1';
                    this.clickedMajorList = [];
                    var collegeList = [];
                    for (var i = 0; i < this.professionals.length; i++) {
                        if (this.professionals[i].parentId == '1') {
                            collegeList.push(this.professionals[i]);
                        }
                    }
                    for(var j = 0; j < this.professionals.length; j++){
                        for(var m = 0; m < collegeList.length; m++){
                            if(this.professionals[j].parentId == collegeList[m].id){
                                this.clickedMajorList.push(this.professionals[j]);
                            }
                        }
                    }
                    this.oneLevelMajorList = this.clickedMajorList;
                    this.teamId = id;
                },
                confirmRelease: function () {
                    var self = this;
                    if (!self.currentProfessionalId) {
                        self.$alert('请至少选择学院', '提示', {
                            confirmButtonText: '确定',
                            type: 'warning'
                        });
                        return;
                    }
                    if (self.multipleMajorId == null || self.multipleMajorId == '' || self.multipleMajorId == undefined) {
                        self.$alert('请至少选择一个专业', '提示', {
                            confirmButtonText: '确定',
                            type: 'warning'
                        });
                        return;
                    }
                    self.isAble = false;
                    self.releaseText = '发布中...';
                    var releaseXhr = this.$axios({
                        method: 'POST',
                        url: '/team/teamUserRelation/batInTeamUser?'+Object.toURLSearchParams({"offices": self.currentProfessionalId, "userIds": self.multipleMajorId, 'teamId': self.teamId, 'userType': self.userType}),
                        timeout:60000
                    });
                    releaseXhr.then(function (response) {
                        var data = response.data;
                        if (data.success) {
                            self.isAble = true;
                            self.releaseText = '确认发布';
                            self.$alert('发布成功!', '提示', {
                                confirmButtonText: '确定',
                                type:'success'
                            }).then(function () {
                                self.dialogFormVisible = false;
                            })
                        }
                    }).catch(function () {
                        self.$alert('操作异常', '提示', {
                            confirmButtonText: '确定',
                            type: 'warning'
                        });
                        self.isAble = true;
                        self.releaseText = '确认发布';
                    })
                },
                changeMajorTable: function (obj) {
                    this.clickedMajorList = [];
                    this.currentProfessionalId = obj.id;
                    if(obj.id == '1'){
                        this.clickedMajorList = this.oneLevelMajorList;
                    }else{
                        for (var i = 0; i < this.professionals.length; i++) {
                            if (this.professionals[i].parentId == obj.id) {
                                this.clickedMajorList.push(this.professionals[i]);
                            }
                        }
                    }
                },
                showForm: function () {
                    var self = this;
                    this.editAble = false;
                    var checkXhr = this.$axios({
                        method: 'POST',
                        url: '/team/checkTeamCreateCdn'
                    });
                    checkXhr.then(function (response) {
                        var data = response.data;
                        if (data.ret == 1) {
                            self.createBox = true;
                            self.isBorder = true;
                            self.$nextTick(function () {
                                self.$refs.createTeam.resetFields();
                                self.createTeam.id = '';
                                self.createTeam.state = '';
                                console.log(self.createTeam);
                            });

                        } else if (!self.editAble) {
                            if(data.ret != 2){
                                self.$alert(data.msg, '提示', {
                                    confirmButtonText: '确定',
                                    type: 'warning'
                                });
                            }
                        }
                    }).catch(function () {
                        self.$alert('操作异常', '提示', {
                            confirmButtonText: '确定',
                            type: 'warning'
                        });
                    });
                    return false;
                },
                selectable: function (row) {
                    return row.state == 2 || !row.checkJoinTUR;
                },
                isDisabled: function (rule) {
                    return rule;
                },
                searchCondition: function () {
                    var self = this;
                    var datas = {stateSch: self.teamState};
                    if (this.selectOption) {
                        datas[this.selectOption] = self.searchText;
                    }
                    if(self.searchText != '' && self.selectOption == ''){
                        self.$alert('请选择查询条件', '提示', {
                            confirmButtonText: '确定',
                            type: 'warning'
                        });
                        return false;
                    }
                    datas['pageNo'] = self.currentPage;
                    datas['pageSize'] = self.eachLength;
                    var listXhr = this.$axios({
                        method: 'POST',
                        url: '/team/ajaxTeamList?'+Object.toURLSearchParams(datas)
                    });
                    listXhr.then(function (response) {
                        var data = response.data;
                        self.teamList = data.datas.list;
                        self.searchTeamList = self.teamList.length;
                        self.teamListLength = data.datas.total;
                    }).catch(function () {
                        self.$alert('操作异常', '提示', {
                            confirmButtonText: '确定',
                            type: 'warning'
                        });
                    })
                },
                checkIfLogin: function (id) {
                    var self = this;
                    var inXhr = this.$axios({
                        type: 'POST',
                        url: 'team/applyJoin?teamId=' + id
                    });
                    inXhr.then(function (response) {
                        var data = response.data;
                        self.$alert(data, '提示', {
                            confirmButtonText: '确定',
                            type: data.indexOf('成功') > -1 ? 'success' : 'error'
                        });
                    }).catch(function () {
                        self.$alert('操作异常', '提示', {
                            confirmButtonText: '确定',
                            type: 'warning'
                        });
                    });
                    return false;
                },
                deleteTeam: function (id) {
                    var self = this;
                    this.$confirm('确认删除吗？', '提示', {
                        confirmButtonText: '确定',
                        cancelButtonText: '取消',
                        type: 'warning'
                    }).then(function () {
                        var deleteXhr = self.$axios({
                            method: 'POST',
                            url: 'team/hiddenDelete?teamIds=' + id
                        });
                        deleteXhr.then(function (response) {
                            var data = response.data;
                            if (data.code == 0) {
                                self.searchCondition();
                            }
                        }).catch(function () {
                            self.$alert('操作异常', '提示', {
                                confirmButtonText: '确定',
                                type: 'warning'
                            });
                        })
                    });
                    return false;
                },
                toDisTeam: function (id) {
                    var self = this;
                    this.$confirm('确认要解散该团队吗？', '提示', {
                        confirmButtonText: '确定',
                        cancelButtonText: '取消',
                        type: 'warning',
                        customClass:'message-center'
                    }).then(function () {
                        var deleXhr = self.$axios({
                            method: 'POST',
                            url: '/team/disTeam?id=' + id
                        });
                        deleXhr.then(function (response) {
                            var data = response.data;
                            if (data.code == 0) {
                                self.searchCondition();
                            }else {
                                self.$alert(data.msg, '提示', {
                                    confirmButtonText: '确定',
                                    type: 'error',
                                    size:'mini'
                                });
                            }
                        }).catch(function () {
                            self.$alert('该团队正在进行项目、大赛或已入驻基地，不能解散', '提示', {
                                confirmButtonText: '确定',
                                type: 'error',
                                size:'mini'
                            });
                        })
                    });
                },
                editTeam: function (row) {
                    var self = this;
                    self.editAble = true;
                    var teamXhr = this.$axios({
                        method: 'POST',
                        url: '/team/findById',
                        params: {
                            "id": row.id
                        }
                    });
                    this.isBorder = true;
                    this.createBox = true;

                    teamXhr.then(function (response) {
                        var data = response.data;
                        $.each(data, function (k, v) {
                            $.each(self.oldList, function (m) {
                                if (k == m) {
                                    self.oldList[m] = v;
                                }
                            })
                        });
                        self.$nextTick(function () {
                            self.createTeam = {
                                id: row.id,
                                state: row.state,
                                name: data.name,
                                memberNum: data.memberNum,
                                schoolTeacherNum: data.schoolTeacherNum,
                                enterpriseTeacherNum: data.enterpriseTeacherNum,
                                membership: data.membership,
                                summary: data.summary
                            }
                        })
                    }).catch(function () {
                        self.$alert('操作异常', '提示', {
                            confirmButtonText: '确定',
                            type: 'warning'
                        });
                    });
                    return false;
                },
                goInvite: function (id) {
                    window.location.href = '${ctxFront}/team/teambuild?id=' + id;
                },
                goName: function (id) {
                    window.location.href = '${ctxFront}/team/findByTeamId?id=' + id;
                },
                isRed: function (son, all) {
                    return son != all;
                },
                submitCreateForm: function (formName) {
                    var self = this;
                    if (this.createBox == false) {
                        this.$refs[formName].resetFields();
                    } else{
                        self.$refs[formName].validate(function (valid) {
                            if (valid) {
                                var ck = "0";
                                if (self.createTeam.state != "4" && self.createTeam.id && self.teamCheckOnOff == "1") {
                                    $.each(self.oldList, function (k, v) {
                                        if(self.createTeam[k] != v){
                                            ck = "1";
                                        }
                                    })
                                }
                                if (ck == '1') {
                                    self.$confirm('修改团队名称、组员要求、团队介绍需要审核，确定保存？', '提示', {
                                        confirmButtonText: '确定',
                                        cancelButtonText: '取消',
                                        type: 'warning'
                                    }).then(function () {
//                                        self.$refs[formName].$el.submit();
                                        self.saveAjax();
                                    });
                                } else {
                                    self.saveAjax();
                                }


                            }
                        })
                    }
                    this.createBox = true;
                    this.isBorder = true;
                },
                saveAjax:function () {
                    var self = this;
                    this.formDisabled = true;
                    this.$axios({
                        method:'POST',
                        url:'/team/ajaxIndexSave',
                        params:self.createTeam
                    }).then(function (response) {
                        var data = response.data;
                        if(data.status == '1'){
                            self.searchCondition();
                            self.createBox = false;
                            self.isBorder = false;
                        }
                        self.formDisabled = false;
                        self.$message({
                            message: data.status == '1' ? data.data.message || '保存成功' : data.msg || '保存失败',
                            type: data.status == '1' ? 'success' : 'error'
                        })
                    }).catch(function () {
                        self.formDisabled = false;
                        self.$message({
                            message: '请求失败',
                            type:'error'
                        })
                    });
                },
                resetCreateForm: function () {
                    this.$refs.createTeam.resetFields();
                    this.createTeam.id = '';
                    this.createTeam.state = '';
                    this.$nextTick(function () {
                        this.createBox = false;
                        this.isBorder = false;
                    })
                },
                handleSelectionChange: function (val) {
                    this.multipleSelectedId = [];
                    for (var i = 0; i < val.length; i++) {
                        this.multipleSelectedId.push(val[i].id);
                    }
                },
                handleSelectionMajor: function (val) {
                    this.multipleMajorId = [];
                    for (var i = 0; i < val.length; i++) {
                        this.multipleMajorId.push(val[i].id);
                    }
                }
            },
            created: function () {
                if (this.messageInfo) {
                    this.$alert(this.messageInfo, '提示', {
                        confirmButtonText: '确定',
                        type: this.messageInfo.indexOf('成功') > -1 ? 'success' : 'error'
                    });
                    this.messageInfo = '';
                }
                var self = this;
                var checkMsgXhr = this.$axios({
                    method: 'POST',
                    url: '/team/checkTeamCreateCdn'
                });
                checkMsgXhr.then(function (response) {
                    var data = response.data;
                    if (data.ret == 1) {
                        self.isCanCreate = true;
                    } else if (data.ret == 2){
                        self.isCanCreate = false;
                        self.$confirm(data.msg, '提示', {
                            confirmButtonText: '确定',
                            cancelButtonText: '取消',
                            type: 'warning'
                        }).then(function () {
                            window.location.href = "/f/sys/frontStudentExpansion/findUserInfoById?custRedict=1&isEdit=1";
                        });
                    }
                });

                this.searchCondition();

                $('.el-message-box__content').wrap("<div class='message-parent'></div>");

            }

        })
    }(Vue)
</script>


</body>
</html>