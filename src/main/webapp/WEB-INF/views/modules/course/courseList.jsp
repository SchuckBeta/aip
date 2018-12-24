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
    <el-form :model="searchListForm" ref="searchListForm" size="mini" :action="frontOrAdmin+'/course/list'"
             method="POST">
        <input name="pageNo" type="hidden" :value="searchListForm.pageNo"/>
        <input name="pageSize" type="hidden" :value="searchListForm.pageSize"/>
        <div class="conditions">
            <e-condition type="radio" v-model="searchListForm.categoryId" label="课程分类" :options="categories"
                         name="categoryId" @change="getCourseList"></e-condition>
            <e-condition type="radio" v-model="searchListForm.type" label="类型分类" :options="courseTypes"
                         name="type" @change="getCourseList"></e-condition>
            <e-condition type="radio" v-model="searchListForm.status" label="状态分类" :options="courseStatusList"
                         name="status" @change="getCourseList"></e-condition>
        </div>
        <div class="search-block_bar clearfix">
            <div class="search-btns">
                <el-button type="primary" size="mini" @click.stop.prevent="goToAddCourse"><i
                        class="iconfont icon-tianjia"></i>添加</el-button>
            </div>
            <div class="search-input">
                <el-form-item  class="w300" style="margin-bottom: 0">
                    <el-input v-model="searchListForm.name" placeholder="请输入名称或者授课老师" @change="getCourseList">
                        <el-button slot="append" icon="el-icon-search"></el-button>
                    </el-input>
                </el-form-item>
            </div>
        </div>

    </el-form>
    <div class="table-container" v-loading="tableLoading">
        <el-table :data="courseList" size="mini" class="table" style="width: 100%">
            <el-table-column  label="课程名称">
                <template slot-scope="scope">
                    <el-tooltip class="item" effect="dark" popper-class="white" :content="scope.row.name" placement="bottom">
                        <span class="over-flow-tooltip">
                            {{scope.row.name | textEllipsis}}
                        </span>
                    </el-tooltip>
                </template>
            </el-table-column>
            <el-table-column prop="name" label="授课老师" align="center">
                <template slot-scope="scope">
                    {{scope.row.teacherNames}}
                </template>
            </el-table-column>
            <el-table-column prop="categoryNames" label="专业课程分类" align="center"></el-table-column>
            <el-table-column prop="name" label="专业课程分类" align="center">
                <template slot-scope="scope">
                    {{scope.row.type | selectedFilter(courseTypeEntries)}}
                </template>
            </el-table-column>
            <el-table-column prop="name" label="状态分类" align="center">
                <template slot-scope="scope">
                    {{scope.row.status | selectedFilter(courseStatusEntries)}}
                </template>
            </el-table-column>
            <el-table-column label="操作" align="center">
                <template slot-scope="scope">
                    <div class="table-btns-action">
                        <el-button type="text" size="mini" @click.stop.prevent="goToEditCourse(scope.row.id)">修改</el-button>
                        <el-button type="text" size="mini" @click.stop.prevent="confirmCourse(scope.row.id)">删除</el-button>
                    </div>
                </template>
            </el-table-column>
        </el-table>
        <div class="text-right mgb-20">
            <el-pagination
                    size="small"
                    @size-change="handlePSChange"
                    background
                    @current-change="handlePaginationSizeChange"
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
            var pageData = JSON.parse(JSON.stringify(${fns: toJson(page)})) || {};
            var courseForm = JSON.parse(JSON.stringify(${fns: toJson(course)})) || {};
            var categories = JSON.parse('${fns: toJson(fns: getDictList('0000000086'))}');
            var courseTypes = JSON.parse('${fns: toJson(fns: getDictList('0000000078'))}');
            var courseStatusList = JSON.parse('${fns: toJson(fns: getDictList('0000000082'))}');
            return {
                searchListForm: {
                    pageSize: pageData.pageSize || 10,
                    pageNo: pageData.pageNo || 1,
                    categoryId: courseForm.categoryId || '',
                    type: courseForm.type || '',
                    status: courseForm.status || '',
                    publishFlag: courseForm.publishFlag || '',
                    name: courseForm.name
                },
                courseList: pageData.list,
                pageCount: pageData.count || 0,
                categories: categories,
                courseTypes: courseTypes,
                courseStatusList: courseStatusList,
                tableLoading: false,
                messageTip: '${message}',
            }
        },
        computed: {
            courseTypeEntries: {
                get: function () {
                    return this.getEntries(this.courseTypes)
                }
            },
            courseStatusEntries: {
                get: function () {
                    return this.getEntries(this.courseStatusList)
                }
            }
        },
        methods: {
            goToAddCourse: function () {
                location.href = this.frontOrAdmin + '/course/form';
            },
            goToEditCourse: function (id) {
                location.href = this.frontOrAdmin + '/course/form?id='+id;
            },

            getCourseList: function () {
              var self = this;
                this.tableLoading = true;
                this.$axios({
                    method: 'GET',
                    url: '/course/getCourseList',
                    params: this.searchListForm
                }).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    var pageData;
                    if (checkResponseCode) {
                        pageData = data.data;
                        self.courseList = pageData.list || [];
                        self.pageCount = pageData.count;
                        self.searchListForm.pageNo = pageData.pageNo;
                        self.searchListForm.pageSize = pageData.pageSize;
                    }
                    self.tableLoading = false;
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: error.response.data
                    });
                    self.tableLoading = false;
                })
            },

            confirmCourse: function (id) {
                var self = this;
                this.$confirm('此操作将删除该课程，是否继续？', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.delCourse(id);
                }).catch(function () {
                })
            },

            delCourse: function (id) {
                var self = this;
                this.$axios({
                    method: 'POST',
                    url: '/course/delCourse',
                    params: {
                        id: id
                    }
                }).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    if (checkResponseCode) {
                        self.$message({
                            type: 'success',
                            message: data.msg || '删除课程成功'
                        });
                        self.getCourseList();
                    }
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: error.response.data
                    });
                })
            },

            handlePSChange: function (val) {
                this.searchListForm.pageSize = val;
                this.getCourseList();
            },

            handlePaginationSizeChange: function () {
                this.getCourseList();
            }
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