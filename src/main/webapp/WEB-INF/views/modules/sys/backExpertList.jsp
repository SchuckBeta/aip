<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <meta charset="UTF-8">
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>
</head>
<body>

<div id="app" v-show="pageLoad" class="container-fluid" style="display: none">
    <edit-bar></edit-bar>
    <el-form :model="searchListForm" size="mini" autocomplete="off" ref="searchListForm">
        <input type="hidden" name="pageNo" :value="searchListForm.pageNo"/>
        <input type="hidden" name="pageSize" :value="searchListForm.pageSize"/>
        <input type="hidden" name="orderBy" :value="searchListForm.orderBy"/>
        <input type="hidden" name="orderByType" :value="searchListForm.orderByType"/>

        <div class="conditions">
            <e-condition label="所属学院" type="radio" v-model="searchListForm['office.id']" :default-props="defaultProps"
                         name="office.id" :options="collegeList" @change="getDataList">
            </e-condition>
            <e-condition label="导师来源" type="radio" v-model="searchListForm.teacherType"
                         name="teacherType" :options="originList" @change="getDataList">
            </e-condition>
            <%--<e-condition label="评审任务" type="radio" v-model="searchListForm.reviewTask"--%>
                         <%--name="reviewTask" :options="reviewTaskList" @change="getDataList">--%>
            <%--</e-condition>--%>
        </div>

        <div class="search-block_bar clearfix">
            <div class="search-btns">

                <%--<el-button size="mini" type="primary" :disabled="multipleSelectedId.length == 0" @click.stop.prevent="assignExpTask">分配专家任务--%>
                <%--</el-button>--%>
                <el-button size="mini" type="primary" :disabled="multipleSelectedId.length == 0" @click.stop.prevent="batchDelete"><i class="iconfont icon-delete"></i>批量删除
                </el-button>
                <%--<el-button size="mini" type="primary" @click.stop.prevent="add"><i class="el-icon-circle-plus"></i>添加--%>
                <%--</el-button>--%>

            </div>
            <div class="search-input">
                <input type="text" style="display: none">
                <el-input
                        placeholder="专家姓名/工号/职称"
                        size="mini"
                        name="queryStr"
                        v-model="searchListForm.queryStr"
                        keyup.enter.native="getDataList"
                        class="w300">
                    <el-button slot="append" icon="el-icon-search"
                               @click.stop.prevent="getDataList"></el-button>
                </el-input>
            </div>
        </div>
    </el-form>
    <div class="table-container" style="margin-bottom:40px;">
        <el-table size="mini" :data="pageList" class="table" v-loading="loading"
                  @sort-change="handleTableSortChange" @selection-change="handleSelectionChange">
            <el-table-column
                    type="selection"
                    width="55">
            </el-table-column>
            <el-table-column prop="no" label="专家信息" align="left" sortable="no">
                <template slot-scope="scope">
                    <p>
                        <el-tooltip :content="scope.row.no" popper-class="white" placement="right">
                            <span class="break-ellipsis">{{scope.row.no}}</span>
                        </el-tooltip>
                    </p>
                    <p>
                        <el-tooltip :content="scope.row.name" popper-class="white" placement="right">
                            <span class="break-ellipsis underline-pointer">{{scope.row.name}}</span>
                        </el-tooltip>
                    </p>
                </template>
            </el-table-column>
            <el-table-column label="专家来源" align="center">
                <template slot-scope="scope">
                    {{scope.row.teacherType | selectedFilter(teacherTypeEntries)}}
                </template>
            </el-table-column>
            <el-table-column prop="officeName" label="所属学院" align="center">
                <template slot-scope="scope">
                    {{scope.row.officeName}}
                </template>
            </el-table-column>
            <%--<el-table-column label="当前评审任务" align="center">--%>
                <%--<template slot-scope="scope">--%>
                    <%--{{scope.row.none}}--%>
                <%--</template>--%>
            <%--</el-table-column>--%>
            <el-table-column label="职称" align="center">
                <template slot-scope="scope">
                    {{scope.row.technicalTitle}}
                </template>
            </el-table-column>
            <el-table-column label="操作" align="center">
                <template slot-scope="scope">
                    <div class="table-btns-action">
                        <%--<el-button type="text" size="mini" @click.stop.prevent="edit(scope.row.id)">编辑--%>
                        <%--</el-button>--%>
                        <el-button type="text" size="mini" @click.stop.prevent="singleDelete(scope.row.id)">删除
                        </el-button>
                    </div>
                </template>
            </el-table-column>
        </el-table>
        <div class="text-right mgb-20" v-show="pageCount">
            <el-pagination
                    size="small"
                    @size-change="handlePaginationSizeChange"
                    background
                    @current-change="handlePaginationPageChange"
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
            var professionals = JSON.parse('${fns:getOfficeListJson()}') || [];
            var projectStyles = JSON.parse('${fns: toJson(fns: getDictList("project_style"))}') || [];
            var competitionTypes = JSON.parse('${fns: toJson(fns: getDictList("competition_type"))}') || [];
            var teacherTypes = JSON.parse('${fns: getDictListJson('master_type')}') || [];
            var reviewTaskList = [].concat(projectStyles, competitionTypes);
            return {
                professionals:professionals,
                pageList: [],
                pageCount: 0,
                searchListForm: {
                    pageNo: 1,
                    pageSize: 10,
                    orderBy: '',
                    orderByType: '',
                    'office.id':'',
                    teacherType:'',
                    reviewTask:'',
                    queryStr: ''
                },
                loading: false,
                message:'${message}',
                defaultProps:{
                    label:'name',
                    value:'id'
                },
                multipleSelection: [],
                multipleSelectedId: [],
                originList:teacherTypes,
                reviewTaskList:reviewTaskList
            }
        },
        computed:{
            collegeList:{
                get:function () {
                    return this.professionals.filter(function (item) {
                        return item.grade == '2';
                    })
                }
            },
            teacherTypeEntries: function () {
                return this.getEntries(this.originList)
            }
        },
        methods: {
            getDataList: function () {
                var self = this;
                this.loading = true;
                this.$axios({
                    method: 'GET',
                    url: '/sys/expert/getExpertList?' + Object.toURLSearchParams(this.searchListForm)
                }).then(function (response) {
                    var page = response.data.data;
                    if(response.data.status == '1'){
                        self.pageCount = page.count;
                        self.searchListForm.pageSize = page.pageSize;
                        self.pageList = page.list || [];
                    }
                    self.loading = false;
                }).catch(function () {
                    self.loading = false;
                    self.$message({
                        message: '请求失败！',
                        type: 'error'
                    })
                })
            },

            handleSelectionChange: function (value) {
                this.multipleSelection = value;
                this.multipleSelectedId = [];
                for (var i = 0; i < value.length; i++) {
                    this.multipleSelectedId.push(value[i].id);
                }
            },

            handleTableSortChange: function (row) {
                this.searchListForm.orderBy = row.prop;
                this.searchListForm.orderByType = row.order ? ( row.order.indexOf('asc') ? 'asc' : 'desc') : '';
                this.getDataList();
            },

            handlePaginationSizeChange: function (value) {
                this.searchListForm.pageSize = value;
                this.getDataList();
            },

            handlePaginationPageChange: function (value) {
                this.searchListForm.pageNo = value;
                this.getDataList();
            },

            assignExpTask:function () {

            },

            add:function () {
                location.href = this.frontOrAdmin + '/sys/expert/form';
            },

            batchDelete:function () {
                var self = this;
                this.$confirm('此操作将永久删除文件, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    var path = {method:'GET',url:'/sys/backTeacherExpansion/deleteBatchByUser',params:{ids:self.multipleSelectedId.join(',')}};
                    self.axiosRequest(path,true,'批量删除');
                })
            },

            edit:function (id) {
                location.href = this.frontOrAdmin + '/sys/expert/form?id=' + id;
            },

            singleDelete: function (id) {
                var self = this;
                this.$confirm('此操作将永久删除文件, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    var path = {method:'POST',url:'/sys/expert/delExpert',data:{id:id}};
                    self.axiosRequest(path,true,'删除');
                })
            },
            axiosRequest:function (path, showMsg, msg) {
                var self = this;
                this.loading = true;
                this.$axios(path).then(function (response) {
                    var data = response.data;
                    if (data.status == '1' || data.ret == '1') {
                        self.getDataList();
                        if (showMsg) {
                            self.$message({
                                message: data.msg || msg + '成功',
                                type: 'success'
                            });
                        }
                    } else {
                        self.$message({
                            message: data.msg || msg + '失败',
                            type: 'error'
                        });
                    }
                    self.loading = false;
                }).catch(function () {
                    self.loading = false;
                    self.$message({
                        message: '请求失败',
                        type: 'error'
                    })
                })
            }
        },
        created: function () {
            this.getDataList();
            if (this.message) {
                this.$message({
                    message: this.message,
                    type: this.message.indexOf('成功') > -1 ? 'success' : 'warning'
                });
                this.message = '';
            }
        }
    })

</script>
</body>
</html>