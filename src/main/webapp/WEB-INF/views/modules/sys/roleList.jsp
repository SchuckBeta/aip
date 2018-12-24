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

    <div class="conditions"></div>

    <div class="search-block_bar clearfix">
        <div class="search-btns">

            <shiro:hasPermission name="sys:role:edit">
                <el-button size="mini" type="primary" @click.stop.prevent="goRoleAdd">角色添加
                </el-button>
            </shiro:hasPermission>

        </div>
    </div>

    <div class="table-container" style="margin-bottom:40px;">
        <el-table size="mini" :data="pageList" class="table" v-loading="loading" style="margin-bottom: 0;"
                  :cell-style="filterRow">
            <el-table-column label="角色名称">
                <template slot-scope="scope">
                    {{scope.row.name}}
                </template>
            </el-table-column>
            <el-table-column label="角色业务类型" align="center">
                <template slot-scope="scope">
                    {{scope.row.bizType | selectedFilter(bizTypesEntries)}}
                </template>
            </el-table-column>
            <el-table-column label="归属机构" align="center">
                <template slot-scope="scope">
                    {{scope.row.office ? scope.row.office.name : ''}}
                </template>
            </el-table-column>
            <el-table-column label="角色范围" align="center">
                <template slot-scope="scope">
                    <span v-if="scope.row.roleGroup == '1'">前台</span>
                    <span v-else>后台</span>
                </template>
            </el-table-column>
            <el-table-column label="数据范围" align="center">
                <template slot-scope="scope">
                    {{scope.row.dataScope | selectedFilter(dataScopesEntries)}}
                </template>
            </el-table-column>
            <shiro:hasPermission name="sys:role:edit">
                <el-table-column label="操作" align="center">
                    <template slot-scope="scope">
                        <div class="table-btns-action">
                            <%--<el-button type="text" size="mini" @click.stop.prevent="goAllot(scope.row.id)">分配--%>
                            <%--</el-button>--%>
                            <el-button type="text" size="mini" @click.stop.prevent="goChange(scope.row.id)">修改
                            </el-button>
                            <el-button type="text" size="mini" @click.stop.prevent="singleDelete(scope.row.id)">删除
                            </el-button>
                        </div>
                    </template>
                </el-table-column>
            </shiro:hasPermission>
        </el-table>
    </div>


</div>

<script>

    'use strict';

    new Vue({
        el: '#app',
        data: function () {
            var bizTypes = JSON.parse('${fns:toJson(fns:getDictList('0000000153'))}');
            var dataScopes = JSON.parse('${fns:toJson(fns:getDictList('sys_data_scope'))}');
            return {
                pageList: [],
                bizTypes:bizTypes,
                dataScopes:dataScopes,
                loading: false,
                message:'${message}',
                admin:false
            }
        },
        computed:{
            bizTypesEntries:{
                get:function () {
                    return this.getEntries(this.bizTypes);
                }
            },
            dataScopesEntries:{
                get:function () {
                    return this.getEntries(this.dataScopes);
                }
            }
        },
        methods: {
            getDataList: function () {
                var self = this;
                this.loading = true;
                this.$axios({
                    method: 'GET',
                    url: '/sys/role/getRoleList'
                }).then(function (response) {
                    var data = response.data;
                    if(data.status == '1'){
                        self.pageList = data.data || [];
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

            checkUserIsAdmin:function () {
                var self = this;
                this.$axios({method:'GET',url:'/sys/user/checkUserIsAdmin'}).then(function (response) {
                    self.admin = response.data;
                })
            },

            filterRow:function (row) {
                if(!(this.admin || (row.row.id != '1' && row.row.id != '10'))){
                    return {
                        'display': 'none'
                    };
                }
            },

            goRoleAdd:function () {
                window.location.href = this.frontOrAdmin + '/sys/role/form';
            },

            goDetail:function (id) {
                window.location.href = 'form?id=' + id;
            },

            goAllot:function (id) {
                window.location.href = this.frontOrAdmin + '/sys/role/assign?id=' + id + '&secondName=分配';
            },

            goChange:function (id) {
                window.location.href = this.frontOrAdmin + '/sys/role/form?id=' + id + '&secondName=修改';
            },

            singleDelete: function (id) {
                var self = this;
                this.$confirm('确认要删除该角色吗?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.$axios({
                        method:'POST',
                        url:'sys/role/ajaxDelete',
                        data:{
                            id:id
                        }
                    }).then(function (response) {
                        var data = response.data;
                        if(data.status == '1'){
                            self.getDataList();
                        }
                        self.$message({
                            message:data.status == '1' ? '删除成功' : data.msg || '删除失败',
                            type:data.status == '1' ? 'success' : 'error'
                        });
                    }).catch(function () {
                        self.$message({
                            message: '请求失败！',
                            type: 'error'
                        })
                    })
                })
            }
        },
        created: function () {
            this.checkUserIsAdmin();
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