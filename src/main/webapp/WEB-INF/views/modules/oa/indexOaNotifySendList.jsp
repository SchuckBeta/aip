<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>${frontTitle}</title>
    <meta charset="UTF-8">
    <meta name="decorator" content="creative"/>

</head>
<body>
<div id="app" v-show="pageLoad" style="display: none" class="container page-container pdt-60">
    <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item><a href="/f"><i class="iconfont icon-ai-home"></i>首页</a></el-breadcrumb-item>
        <el-breadcrumb-item>消息</el-breadcrumb-item>
    </el-breadcrumb>
    <el-form :model="searchListForm" ref="searchListForm" size="mini" class="notify-form">
        <div class="search-block_bar clearfix">
            <div class="search-btns">
                <input type="text" style="display: none" :value="searchListForm.title">
                <el-input
                        placeholder="标题/接收人"
                        size="mini"
                        name="title"
                        v-model="searchListForm.title"
                        @keyup.enter.native="getNotifySendList"
                        style="width: 300px;">
                    <el-button slot="append" icon="el-icon-search"
                               @click.stop.prevent="getNotifySendList"></el-button>
                </el-input>
                <el-button type="primary" size="mini" :disabled="!selectionNotifyList.length"
                           @click.stop.prevent="confirmDelBatch">批量删除
                </el-button>
            </div>
        </div>
    </el-form>
    <div class="notify-tab-nav">
        <div class="notify-tab-btn">
            <a :href="frontOrAdmin+'/oa/oaNotify/indexMyNoticeList'">接收消息</a>
        </div>
        <div class="notify-tab-btn active">
            <a href="javascript:void(0);">发送消息</a>
        </div>
    </div>
    <div v-loading="tableLoading" class="table-container">
        <el-table :data="notifySendList" size="small" class="table notify-list-table" @selection-change="handleSCNotifyList"
                  @sort-change="handleSortCNotifyList">
            <el-table-column
                    type="selection"
                    width="60">
            </el-table-column>
            <el-table-column label="标题" align="center">
                <template slot-scope="scope">
                    <a href="javascript:void(0);" @click.stop.prevent="showNotifyDetail(scope.row)">
                        <i v-if="scope.row.readFlag == '1'" class="iconfont icon-read"></i>
                        <i v-else class="iconfont icon-noread"></i>
                        {{scope.row.title | textEllipsis(20)}}</a>
                </template>
            </el-table-column>
            <el-table-column sortable="type" prop="type" align="center" label="消息类型">
                <template slot-scope="scope">
                    {{scope.row.type | selectedFilter(notifyTypeEntries)}}
                </template>
            </el-table-column>
            <el-table-column label="接收人" align="center">
                <template slot-scope="scope">
                    {{scope.row.receiveUser.name}}
                </template>
            </el-table-column>
            <el-table-column sortable="effectiveDate" align="center" prop="effectiveDate" label="发布时间">
                <template slot-scope="scope">
                    {{scope.row.effectiveDate | formatDateFilter('YYYY-MM-DD')}}
                </template>
            </el-table-column>
            <el-table-column label="操作" align="center">
                <template slot-scope="scope">
                    <div class="table-btns-action">
                        <el-button size="mini" type="text" @click.stop.prevent="confirmDelNotify(scope.row)">删除
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
    <el-dialog
            title="接收消息"
            :visible.sync="dialogVisibleNotifyDetail"
            :close-on-click-modal="false"
            :show-close="false"
            width="520px"
            :before-close="handleCloseNotifyDetail">
        <div class="notify-dialog-detail">
            <p class="title">{{notifyDetail.title}}</p>
            <div class="publishDate">{{notifyDetail.publishDate}}</div>
            <template v-if="notifyDetailHasAccept">
                <div class="ndd-content" v-html="notifyDetail.content"></div>
            </template>
            <template v-else>
                <div class="ndd-content">
                    <a :href="notifyHref" target="_blank">{{notifyDetail.content}}</a>
                </div>
            </template>
        </div>
        <span slot="footer" class="dialog-footer">
    <%--<el-button size="mini" @click="dialogVisibleNotifyDetail = false">取 消</el-button>--%>
    <el-button size="mini" type="primary" @click="dialogVisibleNotifyDetail = false">确 定</el-button>
  </span>
    </el-dialog>
</div>

<script type="text/javascript">
    'use strict';

    new Vue({
        el: '#app',
        data: function () {
            return {
                searchListForm: {
                    pageNo: 1,
                    pageSize: 10,
                    title: '',
                    orderBy: '',
                    orderByType: ''
                },
                pageCount: 100,
                notifySendList: [],
                notifyTypes: [],
                selectionNotifyList: [],
                tableLoading: true,
                dialogVisibleNotifyDetail: false,
                selectedRow: {},
                notifyDetail: {}
            }
        },
        computed: {
            notifyTypeEntries: function () {
                return this.getEntries(this.notifyTypes)
            },
            notifyDetailHasAccept: function () {
                return ['6','7','10','11'].indexOf(this.notifyDetail.type) == -1;
            },
            notifyHref: function () {
                var params = {
                    from: 'notify',
                    id: this.notifyDetail.sId,
                    notifyId: this.selectedRow.id
                }
                return this.frontOrAdmin + '/team/findByTeamId?'+ Object.toURLSearchParams(params);
            }
        },
        methods: {

            handleSCNotifyList: function (value) {
                this.selectionNotifyList = value;
            },

            handleSortCNotifyList: function (row) {
                this.searchListForm.orderBy = row.prop;
                this.searchListForm.orderByType = row.order ? ( row.order.indexOf('asc') ? 'asc' : 'desc') : '';
                this.getNotifySendList();
            },

            handlePSizeChange: function (value) {
                this.searchListForm.pageSize = value;
                this.getNotifySendList();
            },

            handlePCPChange: function (value) {
                this.searchListForm.pageNo = value;
                this.getNoticeList();
            },

            showNotifyDetail: function (row) {
                this.selectedRow = row;
                this.getNotifyView(row);
                this.dialogVisibleNotifyDetail = true;
            },

            handleCloseNotifyDetail: function () {
                this.getNotifySendList();
            },

            getNotifyView: function (row) {
                var id = row.id;
                var self = this;
                this.$axios.get('/oa/oaNotify/view?oaNotifyId=' + id).then(function (response) {
                    var data = response.data;
                    if (data) {
                        self.notifyDetail = data;
                    }else {
                        self.$message({
                            type: 'error',
                            message: self.xhrErrorMsg
                        });
                    }
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: self.xhrErrorMsg
                    });
                })
            },

            confirmDelBatch: function () {
                var self = this;
                this.$confirm("确认删除选择的消息吗？", '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.delNotifyBatch()
                }).catch(function () {

                });
            },
            delNotifyBatch: function () {
                var self = this;
                var ids = this.selectionNotifyList.map(function (item) {
                    return item.id;
                });
                this.$axios.get('/oa/oaNotify/delNotifySendBatch?ids=' + ids.join(',')).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    if (checkResponseCode) {
                        self.getNotifySendList();
                        self.$message({
                            type: 'success',
                            message: '删除成功'
                        });
                    }
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: self.xhrErrorMsg
                    });
                })
            },

            confirmDelNotify: function (row) {
//                var self = this;
//                if ((row.operateFlag == 0 || !row.operateFlag) && (row.type == 5 || row.type == 6)) {
//                    this.$confirm("确认删除该邀请？", '提示', {
//                        confirmButtonText: '确定',
//                        cancelButtonText: '取消',
//                        type: 'warning'
//                    }).then(function () {
//                        self.delNotify(row)
//                    }).catch(function () {
//
//                    });
//                    return;
//                }
                this.delSendNotify(row);
            },


            delSendNotify: function (row) {
                var id = row.id;
                var self = this;
                this.$axios.get('/oa/oaNotify/delSendNotify?id=' + id).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    if (checkResponseCode) {
                        self.getNotifySendList();
                        self.$message({
                            type: 'success',
                            message: '删除成功'
                        });
                    }
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: self.xhrErrorMsg
                    });
                })
            },



            getDictListNotifyTypes: function () {
                var self = this;
                this.$axios.get('/sys/dict/getDictList?type=oa_notify_msg_type').then(function (response) {
                    var data = response.data;
                    self.notifyTypes = data || [];
                }).catch(function (error) {

                })
            },

            getNotifySendList: function () {
                var self = this;
                this.tableLoading = true;
                this.$axios.get('/oa/oaNotify/getNotifySendList?' + Object.toURLSearchParams(this.searchListForm)).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    if (checkResponseCode) {
                        var pageData = data.data;
                        if (pageData) {
                            self.notifySendList = pageData.list || [];
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
                    self.notifySendList = [];
                    self.tableLoading = false;
                })
            }
        },
        beforeMount: function () {
            this.getNotifySendList();
        },
        created: function () {
            this.getDictListNotifyTypes();
        }
    })
</script>
</body>
</html>