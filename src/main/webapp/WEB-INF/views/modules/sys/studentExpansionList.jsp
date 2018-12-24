<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>

</head>
<body>
<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60">
    <edit-bar></edit-bar>
    <el-form :model="searchListForm" ref="searchListForm" size="mini">
        <div class="conditions">
            <e-condition type="radio" v-model="searchListForm['user.office.id']" label="学院"
                         :options="collegeList"
                         :default-props="{label: 'name', value: 'id'}" @change="getStudentList"
                         name="proModel.deuser.office.id"></e-condition>
            <e-condition type="radio" label="学生现状" :options="currentStates" name="currState"
                         v-model="searchListForm['currState']" @change="getStudentList"></e-condition>
            <e-condition type="radio" label="学历" :options="educationLevels" name="user.education"
                         v-model="searchListForm['user.education']" @change="getStudentList"></e-condition>
            <e-condition type="radio" label="学位" :options="degreeTypes" name="user.degree"
                         v-model="searchListForm['user.degree']" @change="getStudentList"></e-condition>
            <e-condition type="radio" label="当前在研" :options="curJoins" name="curJoinStr"
                         v-model="searchListForm['curJoinStr']" @change="getStudentList"></e-condition>
        </div>
        <div class="search-block_bar clearfix">
            <div class="search-btns">
                <el-button type="primary" size="mini" @click.stop.prevent="goToAddStudent"><i
                        class="iconfont icon-tianjia"></i>添加
                </el-button>
                <el-button type="primary" :disabled="multipleSelectionStudent.length < 1" size="mini"
                           @click.stop.prevent="confirmDelStudents"><i class="iconfont icon-delete"></i>批量删除
                </el-button>
            </div>
            <div class="search-input">
                <input type="text" style="display: none">
                <el-input size="mini" name="myFind" v-model="searchListForm.myFind" placeholder="关键字"
                          class="w300" @keyup.enter.native="getStudentList">
                    <el-button slot="append" icon="el-icon-search"
                               @click.stop.prevent="getStudentList"></el-button>
                </el-input>
            </div>
        </div>
    </el-form>
    <div v-loading="tableLoading" class="table-container">
        <el-table :data="studentList" size="small" class="table" @selection-change="handleSelectionStudents"
                  @sort-change="handleSortStudent">
            <el-table-column
                    type="selection"
                    width="60">
            </el-table-column>
            <el-table-column align="center" width="300" label="学生信息">
                <template slot-scope="scope">
                    <e-student-profile-member :user="scope.row.user" :name="scope.row.user.name"
                                              :profession="scope.row.user.professional | collegeFilter(collegeEntries)"></e-student-profile-member>
                </template>
            </el-table-column>
            <el-table-column label="学号" prop="u.no" sortable="u.no" align="center">
                <template slot-scope="scope">
                    {{scope.row.user.no}}
                </template>
            </el-table-column>
            <el-table-column label="性别" align="center" width="64">
                <template slot-scope="scope">
                    {{scope.row.user.sex | selectedFilter(sexEntries)}}
                </template>
            </el-table-column>
            <el-table-column label="学院" align="center">
                <template slot-scope="scope">
                    {{scope.row.user.officeName}}
                </template>
            </el-table-column>
            <el-table-column label="当前在研" align="center">
                <template slot-scope="scope">
                    {{scope.row.curJoin}}
                </template>
            </el-table-column>
            <el-table-column label="现状" align="center" width="64">
                <template slot-scope="scope">
                    {{scope.row.currState | selectedFilter(currentStateEntries)}}
                </template>
            </el-table-column>
            <el-table-column label="学历" align="center" width="64">
                <template slot-scope="scope">
                    {{scope.row.user.education | selectedFilter(educationEntries)}}
                </template>
            </el-table-column>
            <el-table-column label="学位" align="center" width="64">
                <template slot-scope="scope">
                    {{scope.row.user.degree | selectedFilter(degreeEntries)}}
                </template>
            </el-table-column>
            <el-table-column label="毕业时间" align="center">
                <template slot-scope="scope">
                    {{scope.row.graduationStr}}
                </template>
            </el-table-column>
            <el-table-column label="休学时间" align="center">
                <template slot-scope="scope">
                    {{scope.row.temporaryDateStr}}
                </template>
            </el-table-column>
            <el-table-column label="操作" align="center">
                <template slot-scope="scope">
                    <div class="table-btns-action">
                        <el-button type="text" size="mini" @click.stop.prevent="changeStudent(scope.row.id)">编辑
                        </el-button>
                        <el-button type="text" size="mini" @click.stop.prevent="confirmDelStu(scope.row.id)">删除
                        </el-button>
                    </div>
                </template>
            </el-table-column>
        </el-table>
        <div class="text-right mgb-20">
            <el-pagination
                    size="small"
                    @size-change="handlePSizeChange"
                    background
                    @current-change="handlePCPChange"
                    :current-page.sync="searchListForm.pageNo"
                    :page-sizes="[5,10,20,50,100]"
                    :page-size="searchListForm.pageSize"
                    layout="total,prev, pager, next, sizes"
                    :total="pageCount">
            </el-pagination>
        </div>
    </div>
</div>

<script>

    'use strict';

    new Vue({
        el: '#app',
        mixins: [Vue.collegesMixin],
        data: function () {
            var professionals = JSON.parse('${fns: getOfficeListJson()}') || [];
            var currentStates = JSON.parse('${fns: toJson(fns:getDictList('current_sate'))}');
            var isUnderStudy = JSON.parse('${fns: toJson(fns:getDictList('yes_no'))}');
            var educationLevels = JSON.parse('${fns: toJson(fns:getDictList('enducation_level'))}');
            var degreeTypes = JSON.parse('${fns: toJson(fns:getDictList('degree_type'))}');
            var curJoins = JSON.parse('${fns: toJson(fns:getPublishDictList())}');
            var sexes = JSON.parse('${fns: toJson(fns: getDictList('sex'))}');
            return {
                searchListForm: {
                    pageNo: 1,
                    pageSize: 10,
                    'orderBy': '',
                    'orderByType': '',
                    'user.office.id': '',
                    'user.education': '',
                    'user.degree': '',
                    'curJoinStr': '',
                    'currState': '',
                    'myFind': ''
                },
                colleges: professionals,
                currentStates: currentStates,
                isUnderStudy: isUnderStudy,
                educationLevels: educationLevels,
                degreeTypes: degreeTypes,
                curJoins: curJoins,
                sexes: sexes,
                multipleSelectionStudent: [],
                studentList: [],
                pageCount: 0,
                tableLoading: true,
                messageTip: '${message}'
            }
        },
        computed: {
            collegeList: {
                get: function () {
                    return this.colleges.filter(function (item) {
                        return item.grade === '2';
                    });
                }
            },
            currentStateEntries: function () {
                return this.getEntries(this.currentStates)
            },
            educationEntries: function () {
                return this.getEntries(this.educationLevels)
            },
            degreeEntries: function () {
                return this.getEntries(this.degreeTypes)
            },
            sexEntries: function () {
                return this.getEntries(this.sexes)
            }
        },
        methods: {

            handlePSizeChange: function (value) {
                this.searchListForm.pageSize = value;
                this.getStudentList();
            },
            handlePCPChange: function () {
                this.getStudentList();
            },
            //全选学生
            handleSelectionStudents: function (value) {
                this.multipleSelectionStudent = value
            },

            //排序学生
            handleSortStudent: function (obj) {
                this.searchListForm.orderBy = obj.prop;
                this.searchListForm.orderByType =obj.order ? (obj.order.indexOf('asc') ? 'asc' : 'desc') : '';
                this.getStudentList();
            },

            changeStudent: function (id) {
                location.href = this.frontOrAdmin + '/sys/studentExpansion/form?id=' + id;
            },

            goToAddStudent: function () {
                location.href = this.frontOrAdmin + '/sys/studentExpansion/form';
            },

            //确认批量删除学生
            confirmDelStudents: function () {
                var self = this;
                this.$confirm('此操作将删除被选中的学生，是否继续？', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.delStues()
                }).catch(function () {

                })
            },
            delStues: function () {
                var self = this;
                var ids = this.multipleSelectionStudent.map(function (item) {
                    return item.id;
                })
                this.$axios.get('/sys/studentExpansion/deleteBatch?ids=' + ids.join(',')).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    var isResponseSuccess = self.isResponseSuccess(data.code);
                    if (checkResponseCode) {
                        self.getStudentList()
                    }
                    self.$message({
                        message: data.msg,
                        type: 'success'
                    })
                }).catch(function (error) {
                    self.$message({
                        message: error.response.data,
                        type: 'error'
                    })
                })
            },

            confirmDelStu: function (id) {
                var self = this;
                this.$confirm('此操作将删除该学生，是否继续？', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.delStu(id)
                }).catch(function () {

                })
            },

            delStu: function (id) {
                var self = this;
                this.$axios.get('/sys/studentExpansion/deleteStu?id=' + id).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    var isResponseSuccess = self.isResponseSuccess(data.code);
                    if (checkResponseCode) {
                        self.getStudentList()
                    }
                    if (isResponseSuccess) {
                        self.$message({
                            message: '操作成功',
                            type: 'success'
                        })
                    }
                }).catch(function (error) {
                    self.$message({
                        message: error.response.data,
                        type: 'error'
                    })
                })
            },

            //获取学生列表
            getStudentList: function () {
                var self = this;
                this.$axios({
                    method: 'GET',
                    url: '/sys/studentExpansion/getStudentList?' + Object.toURLSearchParams(this.searchListForm),
                }).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    if (checkResponseCode) {
                        var pageData = data.data;
                        if (pageData) {
                            self.studentList = pageData.list || [];
                            self.pageCount = pageData.count;
                            self.searchListForm.pageSize = pageData.pageSize || 10;
                            self.searchListForm.pageNo = pageData.pageNo || 1;
                        }
                    }
                    self.tableLoading = false;
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: error.response.data
                    });
                    self.tableLoading = false;
                })
            }
        },
        beforeMount: function () {
            this.getStudentList();
        },
        mounted: function () {
            if(this.messageTip){
                this.$msgbox({
                    title: '提示',
                    message: this.messageTip,
                    type: this.messageTip.indexOf('成功') >-1 ? 'success' : 'error'
                });
                this.messageTip = '';
            }
        }
    })

</script>
</body>
</html>