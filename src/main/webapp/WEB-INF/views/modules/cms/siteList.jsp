<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ page errorPage="/WEB-INF/views/error/formMiss.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <meta charset="UTF-8">
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>

<body>

<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60">
    <div class="mgb-20">
        <edit-bar></edit-bar>
    </div>

    <el-form :model="searchListForm" ref="searchListForm" method="post">
        <div class="search-block_bar clearfix">
            <div class="search-btns">
                <el-button type="primary" size="mini" @click.stop.prevent="openWebSiteFormDialog"><i
                        class="iconfont icon-tianjia"></i>添加
                </el-button>
            </div>
        </div>
    </el-form>
    <div class="table-container">
        <el-table :data="webSiteList" v-loading="loading" size="mini" class="table" @sort-change="handleTableSortChange">
            <el-table-column prop="name"  label="站点名称">
                <template slot-scope="scope">
                    {{scope.row.name}}
                    <strong v-show="scope.row.isCurrentsite == '1'" class="red">当前站点</strong>
                </template>
            </el-table-column>
            <el-table-column align="center" label="描述" prop="description">
            </el-table-column>
            <el-table-column align="center" label="操作">
                <template slot-scope="scope">
                    <el-button size="mini" type="text"
                               @click.stop.prevent="handleChangeWebSite(scope.row)">修改
                    </el-button>
                    <el-button size="mini" type="text" :disabled="scope.row.isCurrentsite == '1'"
                               @click.stop.prevent="deleteLineData(scope.row.id)">删除
                    </el-button>
                    <el-button size="mini" :disabled="scope.row.isCurrentsite == '1'" type="text"
                               @click="handleChangeRunningWebSite(scope.row)">切换
                    </el-button>
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
                    layout="total, prev, pager, next, sizes"
                    :total="pageCount">
            </el-pagination>
        </div>
    </div>
    <el-dialog :title="webSiteFormAction + '站点'" :visible.sync="webSiteFormVisible" :close-on-click-modal="isClose"
               :before-close="handleCloseWebSiteForm" width="560px">
        <el-form size="mini" :model="webSiteForm" :rules="webSiteFormRules" ref="webSiteForm"
                 label-width="100px">
            <el-form-item prop="name" label="站点名称：">
                <el-input v-model="webSiteForm.name" class="w300"></el-input>
            </el-form-item>
            <el-form-item prop="description" label="描述：">
                <el-input type="textarea" :rows="3" v-model="webSiteForm.description" style="width:380px;"></el-input>
            </el-form-item>

            <el-form-item prop="copyright" label="版权信息：">
                <el-input type="textarea" :rows="3" v-model="webSiteForm.copyright" style="width:380px;"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button size="mini" @click="handleCloseWebSiteForm">取 消</el-button>
            <el-button size="mini" type="primary" @click.stop.prevent="saveWebSite('webSiteForm')">确 定</el-button>
        </div>
    </el-dialog>

</div>

<script>

    'use strict';

    new Vue({
        el: '#app',
        data: function () {

            return {
                searchListForm: {
                    pageNo: 1,
                    pageSize: 10,
                    orderBy: '',
                    orderByType: ''
                },
                pageCount: 0,
                webSiteList: [],
                webSiteForm: {},
                webSiteFormRules: {
                    name: [
                        {required: true, message: '请输入站点名称', trigger: 'blur'},
                        {max: 50, message: '请输入不大于50字的名称', trigger: 'blur'}
                    ],
                    copyright: [
                        {max: 100, message: '请输入小于100字的版权信息', trigger: 'blur'}
                    ]
                },
                webSiteFormVisible: false,
                webSiteFormAction: '',
                isAddWebSite: false,
                isRunningWebSite:false,
                loading: false,
                isClose:false
            }
        },

        methods: {
            getDataList: function () {
                var self = this;
                this.loading = true;
                this.$axios({
                    method: 'GET',
                    url: '/cms/site/siteList?' + Object.toURLSearchParams(this.searchListForm)
                }).then(function (response) {
                    var data = response.data;
                    if (data.ret == '1') {
                        self.pageCount = data.page.count;
                        self.searchListForm.pageSize = data.page.pageSize;
                        self.webSiteList = data.page.list || [];
                    }
                    self.loading = false;
                }).catch(function (error) {
                    self.loading = false;
                    self.$message({
                        message: error.data,
                        type : 'error'
                    })
                });
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
            handleCloseWebSiteForm: function () {
                this.webSiteFormVisible = false;
                this.$refs.webSiteForm.resetFields();
            },

            handleChangeRunningWebSite: function (row) {
                var self = this;
                this.isRunningWebSite = true;
                this.isAddWebSite = false;
                this.webSiteForm = {};
                this.$nextTick(function () {
                    this.webSiteForm = Object.assign({}, row);
                });
                this.$confirm('更换成' + row.name + '? 是否继续', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    if(!self.webSiteForm.isCurrentsite || self.webSiteForm.isCurrentsite == '0'){
                        self.webSiteForm.isCurrentsite = '1'
                    }
                    self.postWebSite();
                }).catch(function () {

                })
            },

            openWebSiteFormDialog: function () {
                this.webSiteFormVisible = true;
                this.webSiteFormAction = '添加';
                this.isAddWebSite = true;
                this.isRunningWebSite = false;
                this.webSiteForm = {
                    name: '',
                    description: '',
                    copyright: ''
                };
            },

            handleChangeWebSite: function (row) {
                this.webSiteFormVisible = true;
                this.webSiteFormAction = '修改';
                this.isAddWebSite = false;
                this.isRunningWebSite = false;
                this.webSiteForm = {};
                this.$nextTick(function () {
                    this.webSiteForm = Object.assign({}, row);
                });
            },

            saveWebSite: function (formName) {
                var self = this;
                this.$refs[formName].validate(function (valid) {
                    if (valid) {
                        self.postWebSite();
                    }
                });

            },

            postWebSite: function () {
                this.loading = true;
                var url = this.isAddWebSite ? '/cms/site/siteSave' : (this.isRunningWebSite ?  '/cms/site/siteChange' : '/cms/site/siteEdit');
                var self = this;
                var axiosConfig ={
                    method: 'POST',
                    url: url,
                    params: this.webSiteForm
                };
                this.$axios(axiosConfig).then(function (response) {
                    var data = response.data;
                    if (data.ret == '1') {
                        self.getDataList();
                        self.webSiteFormVisible = false;
                        self.$refs.webSiteForm.resetFields();
                    }
                    self.loading = false;
                    self.$message({
                        message: data.msg || '操作成功',
                        type: data.ret == '1' ? 'success' : 'error'
                    });
                }).catch(function () {
                    self.loading = false;
                });
            },

            deleteLineData: function (id) {
                var self = this;
                this.$confirm('确认删除吗？', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.loading = true;
                    self.$axios({
                        method: 'POST',
                        url: '/cms/site/siteDel?id=' + id
                    }).then(function (response) {
                        var data = response.data;
                        if (data.ret == '1') {
                            self.getDataList();
                        }
                        self.loading = false;
                        self.$message({
                            message: data.msg || '删除成功',
                            type: data.ret == '1' ? 'success' : 'error'
                        });
                    }).catch(function (error) {
                        self.loading = false;
                        self.$message({
                            message: error.response.data || '删除失败',
                            type : 'error'
                        })
                    });
                }).catch(function () {

                })
            }
        },
        created: function () {
            this.getDataList();
        }
    })

</script>

</body>
</html>