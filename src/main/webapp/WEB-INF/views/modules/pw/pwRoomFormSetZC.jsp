<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ page errorPage="/WEB-INF/views/error/formMiss.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <meta charset="UTF-8">
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>
    <%--<script type="text/javascript" src="${ctxStatic}/treeTransfer/treeTransfer.min.js"></script>--%>
<body>

<style>

</style>

<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60 room-asset-assign">
    <div class="mgb-20">
        <shiro:hasPermission name="pw:pwRoom:edit">
            <edit-bar second-name="资产分配"></edit-bar>
        </shiro:hasPermission>
        <shiro:lacksPermission name="pw:pwRoom:edit">
            <edit-bar second-name="查看"></edit-bar>
        </shiro:lacksPermission>
    </div>
    <e-panel class="assign-header">
        <span class="current-room">当前房间：{{pwRoom.pwSpace | filterPwRoomAddress(pwSpaceListEntries)}}<span
                v-if="pwRoom.alias">/{{pwRoom.alias}}</span></span>
        <el-button size="mini" type="primary" :disabled="multipleSelectedId.length == 0" @click.stop.prevent="batchCancelAssign(multipleSelectedId.join(','))">
            批量取消分配
        </el-button>
    </e-panel>

    <el-container class="mgt-20">
        <el-aside width="250px" :style="{height:asideHeight + 'px'}" ref="assetTree">
            <div class="aside-search">
                <input type="text" style="display: none">
                <el-input name="roomAsset" size="mini" v-model="filterTreeText" placeholder="搜索"
                          @keyup.enter.native="searchTree">
                    <el-button slot="append" icon="el-icon-search"
                               @click.stop.prevent="searchTree"></el-button>
                </el-input>
            </div>

            <el-tree
                    ref="tree"
                    :props="props"
                    :data="collegesTree"
                    show-checkbox
                    node-key="pId"
                    :default-expanded-keys="['1']"
                    :filter-node-method="filterTreeNode"
                    @check-change="handleCheckChange">
            </el-tree>

        </el-aside>
        <el-main>

            <div class="assign-main-box">

                <div class="assign-arrow-box">
                    <el-button :class="{active:checkAssetIds.length > 0}" :disabled="checkAssetIds.length == 0" icon="el-icon-jiantou"
                               @click.stop.prevent="assignAsset"></el-button>
                </div>

                <div class="table-container" v-loading="loading">
                    <el-table size="mini" :data="pageList" class="table" @selection-change="handleSelectionChange">
                        <el-table-column
                                type="selection"
                                width="55">
                        </el-table-column>
                        <el-table-column prop="pwCategory.name" align="center" label="资产类别">
                        </el-table-column>
                        <el-table-column prop="name" align="center" label="资产编号">
                        </el-table-column>
                        <el-table-column prop="specification" align="center" label="型号">
                        </el-table-column>
                        <el-table-column align="left" label="负责人">
                            <template slot-scope="scope">
                                <div>
                                    <el-tooltip :content="scope.row.respName" popper-class="white" placement="right">
                                        <span class="break-ellipsis">{{scope.row.respName}}</span>
                                    </el-tooltip>
                                </div>
                                <div>{{scope.row.respMobile}}</div>
                            </template>
                        </el-table-column>
                        <el-table-column align="center" label="操作">
                            <template slot-scope="scope">
                                <div class="table-btns-action">
                                    <el-button type="text" size="mini"
                                               @click.stop.prevent="batchCancelAssign(scope.row.id)">取消分配
                                    </el-button>
                                </div>
                            </template>
                        </el-table-column>
                    </el-table>
                    <div class="text-right mgb-20" v-if="pageCount">
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
            </div>

        </el-main>
    </el-container>
    </el-container>


</div>

<script>

    'use strict';
    new Vue({
        el: '#app',
        mixins: [Vue.collegesMixin],
        data: function () {
            var pwRoom = JSON.parse('${fns:toJson(pwRoom)}');
            return {
                pwRoom: pwRoom,
                filterTreeText: '',
                filterTreePIds: [],
                props: {
                    label: 'name',
                    children: 'children'
                },
                colleges: [],
                collegesProps: {
                    parentKey: 'pId',
                    id: 'id'
                },
                checkAssetIds: [],

                searchListForm: {
                    pageNo: 1,
                    pageSize: 10,
                    'pwRoom.id': pwRoom.id || ''
                },
                pageCount: 9,
                pageList: [],
                loading: false,
                multipleSelectedId: [],
                spaceList: [],
                asideHeight: 0,
                message:'${message}'
            }
        },
        watch: {},
        computed: {
            pwSpaceListEntries: function () {
                var entries = {};
                this.spaceList.forEach(function (item) {
                    entries[item.id] = item;
                });
                return entries;
            }
        },
        methods: {
            getAssetTree: function () {
                var self = this;
                this.$axios.get('/pw/pwCategory/treeData?isParent=true').then(function (response) {
                    var dataParent = response.data;
                    var tree = [];
                    if (dataParent.length > 0) {
                        self.$axios.get('/pw/pwFassets/treeDataAll').then(function (response) {
                            var dataChild = response.data;
                            dataParent.forEach(function (t) {
                                if (t.pId == 1) {
                                    t.open = true;
                                }
                                tree.push(t);
                                if (dataChild.status) {

                                    dataChild.datas.forEach(function (tFs) {

                                        if (t.id == tFs.pwCategory.id) {
                                            var curNode = {
                                                id: tFs.id,
                                                isParent: false,
                                                name: tFs.name,
                                                pId: t.id,
                                                open: false
                                            };
                                            tree.push(curNode);
                                        }
                                    });
                                }
                            });
                            self.colleges = tree;
                            self.setCollegeEntries(self.colleges);
                            var rootIds = self.setCollegeRooIds(self.colleges);
                            self.collegesTree = self.getCollegesTree(rootIds, self.collegesProps);
                        })
                    }
                })
            },
            searchTree: function () {
                this.$refs.tree.filter(this.filterTreeText);
            },
            filterTreeNode: function (value, data) {
                if (!value) return true;
                return data.name.indexOf(value) !== -1;
            },
            handleCheckChange: function () {
                var checkNodes = this.$refs.tree.getCheckedNodes();
                var ids = [];
                checkNodes.forEach(function (item) {
                    if (!item.isParent) {
                        ids.push(item.id)
                    }
                });
                this.checkAssetIds = ids;
            },
            assignAsset: function () {
                var self = this;
                this.$axios.get('/pw/pwFassets/ajaxSetPL?pwRoom.id=' + self.pwRoom.id + '&id=' + self.checkAssetIds.join(',')).then(function (response) {
                    var data = response.data;
                    if (data.status == '1') {
                        self.getAssetTree();
                        self.getDataList();
                    }
                    self.$message({
                        message: data.status == '1' ? '分配成功' : data.msg || '分配失败',
                        type: data.status == '1' ? 'success' : 'error'
                    });
                }).catch(function () {
                    self.$message({
                        type: 'error',
                        message: '请求失败'
                    });
                })
            },
            batchCancelAssign: function (ids) {
                var self = this;
                this.$axios({
                    method: 'POST',
                    url: '/pw/pwFassets/cancelFassets',
                    params: {
                        ids: ids
                    }
                }).then(function (response) {
                    var data = response.data;
                    if (data.status == '1') {
                        self.getAssetTree();
                        self.getDataList();
                    }
                    self.$message({
                        message: data.status == '1' ? '取消分配成功' : data.msg || '取消分配失败',
                        type: data.status == '1' ? 'success' : 'error'
                    });
                }).catch(function () {
                    self.$message({
                        type: 'error',
                        message: '请求失败'
                    });
                })
            },

            getDataList: function () {
                var self = this;
                this.loading = true;
                this.$axios({
                    method: 'GET',
                    url: '/pw/pwFassets/listYfp?' + Object.toURLSearchParams(this.searchListForm)
                }).then(function (response) {
                    var data = response.data;
                    if (data.status == '1') {
                        self.pageCount = data.data.count;
                        self.searchListForm.pageSize = data.data.pageSize;
                        self.pageList = data.data.list || [];
                    }
                    self.loading = false;
                }).catch(function () {
                    self.loading = false;
                    self.$message({
                        message: '请求失败',
                        type: 'error'
                    })
                });
            },
            getSpaceList: function () {
                var self = this;
                return this.$axios.get('/pw/pwSpace/treeData').then(function (response) {
                    self.spaceList = response.data;
                })
            },
            handleSelectionChange: function (val) {
                this.multipleSelectedId = [];
                for (var i = 0; i < val.length; i++) {
                    this.multipleSelectedId.push(val[i].id);
                }
            },
            handlePaginationSizeChange: function (pageSize) {
                this.searchListForm.pageSize = pageSize;
                this.getDataList();
            },
            handlePaginationPageChange: function (curPage) {
                this.searchListForm.pageNo = curPage;
                this.getDataList();
            }
        },
        created: function () {
            this.getSpaceList();
            this.getAssetTree();
            this.getDataList();
            this.$nextTick(function () {
                this.asideHeight = document.documentElement.clientHeight - this.$refs.assetTree.$el.offsetTop - 40;
            });
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