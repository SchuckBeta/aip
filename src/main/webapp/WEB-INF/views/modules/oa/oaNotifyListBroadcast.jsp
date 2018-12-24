<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>

</head>
<body>

<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60">
    <edit-bar></edit-bar>
    <el-form :model="searchListForm" ref="searchListForm" size="mini">
        <div class="conditions">
            <e-condition type="radio" v-model="searchListForm.type" label="类型" :options="oaNotifyTypes" @change="getOaNotifyList"></e-condition>
            <e-condition type="radio" v-model="searchListForm.status" label="状态"
                         :options="oaNotifyStatus" @change="getOaNotifyList"></e-condition>
        </div>
        <div class="search-block_bar clearfix">
            <div class="search-btns">
                <el-button type="primary" size="mini" @click.stop.prevent="goToAdd"><i
                        class="iconfont icon-tianjia"></i>添加
                </el-button>
            </div>
            <div class="search-input">
                <input type="text" style="display: none">
                <el-input
                        placeholder="标题"
                        size="mini"
                        name="title"
                        @keyup.enter.native="getOaNotifyList"
                        v-model="searchListForm.title"
                        class="w300">
                    <el-button slot="append" icon="el-icon-search" @click="getOaNotifyList"></el-button>
                </el-input>
            </div>
        </div>
    </el-form>
    <div class="table-container" v-loading="tableLoading">
        <el-table :data="oaNotifyList" size="small" class="table">
            <el-table-column label="标题">
                <template slot-scope="scope">
                    <el-tooltip :content="scope.row.title" popper-class="white" placement="right">
                        <span class="break-ellipsis">{{scope.row.title}}</span>
                    </el-tooltip>
                </template>
            </el-table-column>
            <el-table-column label="类型" align="center">
                <template slot-scope="scope">
                    <span v-if="scope.row.sendType == '2'">站内信</span>
                    <span v-else>
                        {{scope.row.type | selectedFilter(oaNotifyTypeEntries)}}
                    </span>
                </template>
            </el-table-column>
            <%--<el-table-column label="排序" align="center">--%>
            <%--<template slot-scope="scope">--%>
            <%--<el-switch size="mini"></el-switch>--%>
            <%--</template>--%>
            <%--</el-table-column>--%>
            <el-table-column label="状态" align="center">
                <template slot-scope="scope">
                    <%--{{scope.row.publishStatus | selectedFilter(publishStatusEntries)}}--%>
                    <el-switch v-model="scope.row.status" active-value="1" inactive-value="0" size="mini"
                               @change="handleChangeNotifyStatus(scope.row)"></el-switch>
                </template>
            </el-table-column>
            <el-table-column label="发送人" align="center">
                <template slot-scope="scope">
                    {{scope.row.createUser ? scope.row.createUser.name : '-'}}
                </template>
            </el-table-column>
            <el-table-column label="发布时间" align="center">
                <template slot-scope="scope">
                    {{scope.row.updateDate | formatDateFilter('YYYY-MM-DD')}}
                </template>
            </el-table-column>
            <el-table-column label="操作" align="center">
                <template slot-scope="scope">
                    <div class="table-btns-action">
                        <el-button type="text" size="mini" :disabled="scope.row.status == '1'" @click.stop.prevent="goToView(scope.row)">
                            修改
                        </el-button>
                        <el-button type="text" size="mini" @click.stop.prevent="confirmDelNotify(scope.row.id)">
                            删除
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
        data: function () {
            var oaNotifyStatus = JSON.parse('${fns: toJson(fns:getDictList('oa_notify_status'))}');
            var oaNotifyTypes = JSON.parse('${fns: toJson(fns: getDictList('oa_notify_type'))}');
            return {
                searchListForm: {
                    pageNo: 1,
                    pageSize: 10,
                    type: '',
                    title: '',
                    status: ''
                },
                oaNotifyList: [],
                pageCount: 0,
                oaNotifyStatus: oaNotifyStatus,
                oaNotifyTypes: oaNotifyTypes,
                tableLoading: true
            }
        },
        computed: {
            oaNotifyStatusEntries: function () {
                return this.getEntries(this.oaNotifyStatus)
            },
            oaNotifyTypeEntries: function () {
                return this.getEntries(this.oaNotifyTypes)
            },
        },
        methods: {

            handlePSizeChange: function (value) {
                this.searchListForm.pageSize = value;
                this.getOaNotifyList();
            },

            handlePCPChange: function () {
                this.getOaNotifyList();
            },

            goToView: function (row) {
                if(row.sendType === '2'){
                    return location.href = this.frontOrAdmin + '/oa/oaNotify/formBroadcast?id=' + row.id;
                }
                return location.href = this.frontOrAdmin + '/oa/oaNotify/allNoticeForm?id=' + row.id;
            },

            goToAdd:function () {
              return   location.href = this.frontOrAdmin + '/oa/oaNotify/allNoticeForm';
            },

            handleChangeNotifyStatus: function (row) {
                var self = this;
                this.$axios.get('/oa/oaNotify/updatePublish?' + Object.toURLSearchParams({
                            id: row.id,
                            status: row.status
                        })).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg, false);
                    if (!checkResponseCode) {
                        row.status = row.status == '1' ? '0' : '1'
                    }
                    self.$message({
                        type: data.status == '1' ? 'success' : 'error',
                        message: data.status == '1' ? '操作成功' : self.xhrErrorMsg
                    });
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: self.xhrErrorMsg
                    });
                    row.status = row.status == '1' ? '0' : '1'
                })
            },

            confirmDelNotify: function (id) {
                var self = this;
                this.$confirm('删除这条消息将不会再显示？是否继续', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.delNotify(id);
                }).catch(function () {

                })
            },

            delNotify: function (id) {
                var self = this;
                this.$axios.get('/oa/oaNotify/delOaNotify?' + Object.toURLSearchParams({id: id})).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg, false);
                    if (checkResponseCode) {
                        self.getOaNotifyList();
                    }
                    self.$message({
                        type: data.status == '1' ? 'success' : 'error',
                        message: data.status == '1' ? '操作成功' : self.xhrErrorMsg
                    });
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: self.xhrErrorMsg
                    });
                })
            },

            getOaNotifyList: function () {
                var self = this;
                this.tableLoading = true;
                this.$axios.get('/oa/oaNotify/getOaNotifyList?' + Object.toURLSearchParams(this.searchListForm)).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    if (checkResponseCode) {
                        var pageData = data.data;
                        if (pageData) {
                            self.oaNotifyList = pageData.list || [];
                            self.pageCount = pageData.count;
                            self.searchListForm.pageSize = pageData.pageSize;
                            self.searchListForm.pageNo = pageData.pageNo;
                        }
                    }
                    self.tableLoading = false;
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: self.xhrErrorMsg
                    });
                    self.tableLoading = false;
                })
            }
        },

        beforeMount: function () {
            this.getOaNotifyList();
        }
    })


</script>

</body>
</html>