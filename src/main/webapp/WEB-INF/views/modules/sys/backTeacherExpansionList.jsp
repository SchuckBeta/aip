<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>

</head>
<body>
<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60">
    <edit-bar></edit-bar>
    <el-form :model="searchListForm" ref="searchListForm" size="mini">
        <div class="conditions">
            <e-condition type="radio" label="导师来源" :options="masterTypes" name="teachertype"
                         v-model="searchListForm['teachertype']" @change="searchTeacherList"></e-condition>
            <e-condition type="radio" label="学历" :options="enducationLevels" name="user.education"
                         v-model="searchListForm['user.education']" @change="searchTeacherList"></e-condition>
            <e-condition type="radio" label="学位" :options="degreeTypes" name="user.degree"
                         v-model="searchListForm['user.degree']" @change="searchTeacherList"></e-condition>
            <e-condition type="checkbox" label="服务意向" :options="masterHelps" name="serviceIntentionIds"
                         v-model="searchListForm['serviceIntentionIds']" @change="searchTeacherList"></e-condition>
        </div>
        <div class="search-block_bar clearfix">
            <div class="search-btns">
                <el-button type="primary" size="mini" @click.stop.prevent="goToAddTeacher"><i
                        class="iconfont icon-tianjia"></i>添加
                </el-button>
                <el-button type="primary" :disabled="multipleSelectionTeachers.length < 1" size="mini"
                           @click.stop.prevent="confirmDelTeachers"><i class="iconfont icon-delete"></i>批量删除
                </el-button>
            </div>
            <div class="search-input">
                <el-input size="mini" name="keyWords" v-model="searchListForm.keyWords" placeholder="职工号/姓名/职务/职称"
                          class="w300">
                    <el-button slot="append" icon="el-icon-search"
                               @click.stop.prevent="getTeacherList"></el-button>
                </el-input>
            </div>
        </div>
    </el-form>
    <div class="table-container">
        <el-table :data="teacherList" size="small" class="table" @selection-change="handleSelectionTeachers"
                  @sort-change="handleSortTeacher">
            <el-table-column
                    type="selection"
                    width="60">
            </el-table-column>
            <el-table-column prop="u.no" label="职工号" align="center" sortable="u.no">
                <template slot-scope="scope">
                    {{scope.row.user.no}}
                </template>
            </el-table-column>
            <el-table-column label="姓名" align="center">
                <template slot-scope="scope">
                    {{scope.row.user.name}}
                </template>
            </el-table-column>
            <el-table-column label="性别" align="center">
                <template slot-scope="scope">
                    {{scope.row.user.sex | selectedFilter(sexEntries)}}
                </template>
            </el-table-column>
            <el-table-column label="导师来源" align="center">
                <template slot-scope="scope">
                    {{scope.row.teachertype | selectedFilter(masterTypeEntries)}}
                </template>
            </el-table-column>
            <el-table-column label="当前指导" align="center">
                <template slot-scope="scope">
                    {{scope.row.curJoin}}
                </template>
            </el-table-column>
            <el-table-column label="服务意向" align="center">
                <template slot-scope="scope">
                    {{scope.row.serviceIntentionStr}}
                </template>
            </el-table-column>
            <el-table-column label="职务" align="center">
                <template slot-scope="scope">
                    {{scope.row.postTitle}}
                </template>
            </el-table-column>
            <el-table-column label="职称" align="center">
                <template slot-scope="scope">
                    {{scope.row.technicalTitle}}
                </template>
            </el-table-column>
            <el-table-column label="学历" align="center">
                <template slot-scope="scope">
                    {{scope.row.user.education | selectedFilter(enducationLevelEntires)}}
                </template>
            </el-table-column>
            <el-table-column label="操作" align="center">
                <template slot-scope="scope">
                    <div class="table-btns-action">
                        <el-button type="text" size="mini" @click.stop.prevent="goToEditTeacher(scope.row.id)">编辑
                        </el-button>
                        <el-button type="text" size="mini" @click.stop.prevent="confirmDelTeacher(scope.row.id)">删除
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


<script type="text/javascript">
    'use strict';

    new Vue({
        el: '#app',
        data: function () {
            var backTeacherExpansion = JSON.parse('${fns: toJson(backTeacherExpansion)}');
            var pageData =${fns: toJson(page)};
            var pageCount = pageData.count || 0;
            var teacherList = pageData.list || [];
            var sexes = JSON.parse('${fns:toJson(fns: getDictList('sex'))}');
            var masterTypes = JSON.parse('${fns:toJson(fns: getDictList('master_type'))}');
            var enducationLevels = JSON.parse('${fns:toJson(fns: getDictList('enducation_level'))}');
            var degreeTypes = JSON.parse('${fns: toJson(fns:getDictList('degree_type'))}');
            var masterHelps = JSON.parse('${fns:toJson(fns: getDictList('master_help'))}');
            var paramsHasUser = !!backTeacherExpansion.user;

            return {
                searchListForm: {
                    teachertype: backTeacherExpansion.teachertype || '',
                    'user.education': paramsHasUser ? backTeacherExpansion.user.education : '',
                    'user.degree': paramsHasUser ? backTeacherExpansion.user.degree : '',
                    'workUnitType': backTeacherExpansion.workUnitType,
                    'serviceIntentionIds': backTeacherExpansion.serviceIntentionIds || [],
                    'curJoinStr': backTeacherExpansion.curJoinStr || [],
                    'keyWords': backTeacherExpansion.keyWords,
                    'pageSize': backTeacherExpansion.pageSize || 10,
                    'pageNo': backTeacherExpansion.pageNo || 1,
                    'orderBy': backTeacherExpansion.orderBy,
                    'orderByType': backTeacherExpansion.orderByType
                },
                teacherList: teacherList,
                pageCount: pageCount,
                multipleSelectionTeachers: [],
                sexes: sexes,
                masterTypes: masterTypes,
                enducationLevels: enducationLevels,
                degreeTypes: degreeTypes,
                masterHelps: masterHelps,
                messageTip: '${message}',
                teacherListLoading: false
            }
        },
        computed: {
            sexEntries: {
                get: function () {
                    return this.getEntries(this.sexes);
                }
            },
            masterTypeEntries: {
                get: function () {
                    return this.getEntries(this.masterTypes);
                }
            },
            enducationLevelEntires: {
                get: function () {
                    return this.getEntries(this.enducationLevels);
                }
            }
        },
        methods: {
            handleSelectionTeachers: function (val) {
                this.multipleSelectionTeachers = val
            },
            handleSortTeacher: function (row) {
                var order = null;
                if (row.order) {
                    order = row.order.indexOf('asc') > -1 ? 'asc' : 'desc';
                }
                this.searchListForm.orderByType = order;
                this.searchListForm.orderBy = row.prop;
                this.searchListForm.pageNo = 1;
                this.getTeacherList();
            },

            searchTeacherList: function () {
                this.searchListForm.pageNo = 1;
                this.getTeacherList();
            },

            handlePSizeChange: function (value) {
                this.searchListForm.pageSize = value;
                this.getTeacherList();
            },
            handlePCPChange: function () {
                this.getTeacherList();
            },

            goToEditTeacher: function (id) {
                location.href = this.frontOrAdmin + '/sys/backTeacherExpansion/form?id=' + id;
            },

            goToAddTeacher: function () {
                location.href = this.frontOrAdmin + '/sys/backTeacherExpansion/form?operateType=1';
            },


            confirmDelTeachers: function () {
                var self = this;
                this.$confirm('此操作将删除选中的导师，是否继续', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.delBatchTeachers();
                }).catch(function () {

                })
            },
            delBatchTeachers: function () {
                var self = this;
                var ids = this.multipleSelectionTeachers.map(function (item) {
                    return item.id;
                });
                this.$axios.get('/sys/backTeacherExpansion/deleteBatch?ids=' + ids.join(',')).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    if (checkResponseCode) {
                        self.$message({
                            type: 'success',
                            message: data.msg || '删除导师信息成功'
                        });
                        self.getTeacherList();
                    }
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: error.response.data
                    })
                })
            },

            confirmDelTeacher: function (id) {
                var self = this;
                this.$confirm('此操作将删除这位导师，是否继续', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.delTeacher(id);
                }).catch(function () {
                })
            },

            delTeacher: function (id) {
                var self = this;
                this.$axios.post('/sys/backTeacherExpansion/deleteTeacher?id=' + id).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    if (checkResponseCode) {
                        self.$message({
                            type: 'success',
                            message: data.msg || '删除导师信息成功'
                        });
                        self.getTeacherList();
                    }
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: error.response.data
                    })
                })
            },
            getTeacherList: function () {
                var self = this;
                this.teacherListLoading = true;
                this.$axios({
                    method: 'GET',
                    url: '/sys/backTeacherExpansion/getTeacherList?'+Object.toURLSearchParams(this.searchListForm),
                }).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    var pageData;
                    if (checkResponseCode) {
                        data = data.data;
                        pageData = data.page;
                        self.teacherList = pageData.list || [];
                        self.pageCount = pageData.count;
                    }
                    self.teacherListLoading = false;
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: error.response.data
                    });
                    self.teacherListLoading = false;
                })
            }

        },
        beforeMount: function () {
            this.getTeacherList();
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