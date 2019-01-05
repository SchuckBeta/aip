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
    <div class="mgb-20">
        <edit-bar></edit-bar>
    </div>
    <div class="clearfix">
        <div class="search-block_bar clearfix">
            <div class="search-btns">
                <shiro:hasPermission name="cmss:cmssMenu:edit">
                    <el-button type="primary" size="mini" :disabled="flattenMenuList.length < 1" @click.stop.prevent="saveSorts">保存排序
                    </el-button>
                </shiro:hasPermission>
                <el-button type="primary" size="mini" @click.stop.prevent="goAddMenu">添加菜单
                </el-button>
            </div>
        </div>
    </div>
    <div class="table-container">
        <el-table :data="flattenMenuList" v-loading="loading" size="mini" class="e-table-tree" :cell-style="eTableCellStyle">
            <el-table-column label="名称" prop="name" width="280px">
                <template slot-scope="scope">
                    <span class="e-table-tree-dot" v-if="index>0" v-for="(dot, index) in scope.row.dots.split('-').length"></span>
                    <i class="el-icon-caret-right" :class="elIconCaret(scope.row)" @click.stop.prevent="handleExpandCell(scope.row)"></i>
                    <span class="e-checkbox__label_dr_card">{{scope.row.name}}</span>
                </template>
            </el-table-column>

            <el-table-column label="排序" prop="sort" align="center" width="100px">
                <template slot-scope="scope">
                    <shiro:hasPermission name="cmss:cmssMenu:edit">
                        <el-input size="mini" v-model.number="scope.row.sort"></el-input>
                    </shiro:hasPermission>
                    <shiro:lacksPermission name="cmss:cmssMenu:edit">
                        {{scope.row.sort}}
                    </shiro:lacksPermission>
                </template>
            </el-table-column>

            <el-table-column label="显示" prop="isShow" align="center">
                <template slot-scope="scope">
                    <el-switch v-model="scope.row.isShow" :active-value="'1'" :inactive-value="'0'" @change="handleChangeIsShow(scope.row)"></el-switch>
                </template>
            </el-table-column>

            <el-table-column label="链接" prop="href" align="center">
                <template slot-scope="scope">
                    <el-tooltip :content="scope.row.href" popper-class="white" placement="right">
                        <span class="break-ellipsis">{{scope.row.href}}</span>
                    </el-tooltip>
                </template>
            </el-table-column>

            <el-table-column label="权限标识" prop="permission" align="center">
                <template slot-scope="scope">
                    <el-tooltip :content="scope.row.permission" popper-class="white" placement="right">
                        <span class="break-ellipsis">{{scope.row.permission}}</span>
                    </el-tooltip>
                </template>
            </el-table-column>

            <shiro:hasPermission name="cmss:cmssMenu:edit">
                <el-table-column label="操作" align="center">
                    <template slot-scope="scope">
                        <div class="table-btns-action">
                            <el-button size="mini" type="text" @click.stop.prevent="goChangeData(scope.row.id)">修改
                            </el-button>
                            <el-button size="mini" type="text" @click.stop.prevent="singleDelete(scope.row.id)">删除
                            </el-button>
                            <el-button size="mini" type="text" @click.stop.prevent="goAddChild(scope.row.id)">添加下级菜单
                            </el-button>
                        </div>
                    </template>
                </el-table-column>
            </shiro:hasPermission>
        </el-table>
    </div>
</div>


<script type="text/javascript">
    'use strict';
    new Vue({
        el: '#app',
        mixins: [Vue.menuTreeMixin],
        data: function () {

            return {
                pageList:[],
                menuList: [],
                flattenMenuList:[],
                loading:false,
                menuProps: {
                    parentKey: 'parentId',
                    id: 'id'
                },
                message:'${message}'
            }
        },
        computed: {

        },
        methods: {
            elIconCaret: function (row) {
                return {
                    'is-leaf': !row.children || !row.children.length,
                    'expand-icon': row.isExpand
                }
            },
            //控制行的样式
            eTableCellStyle: function (row) {
                return {
                    'display': row.row.isCollapsed ? 'none' : ''

                }
            },

            //控制行的展开收起
            handleExpandCell: function (row) {
                var children = row.children;
                if (!children) {
                    return;
                }
                row.isExpand = !row.isExpand;
                if (row.isExpand) {
                    this.expandCellTrue(children, row.isExpand);
                    return
                }
                this.expandCellFalse(children, row.isExpand);
            },

            expandCellTrue: function (list, b) {
                for (var i = 0; i < list.length; i++) {
                    var item = list[i];
                    item.isCollapsed = !b;
                    item.isExpand = false;
                }
            },

            expandCellFalse: function (list, b) {
                var childrenIds = this.getPwSpaceChildrenIds(list);
                for (var i = 0; i < this.flattenMenuList.length; i++) {
                    var item = this.flattenMenuList[i];
                    if (childrenIds.indexOf(item.id) > -1) {
                        item.isCollapsed = !b;
                        item.isExpand = false;
                    }
                }
            },

            //获取所有子的ID
            getPwSpaceChildrenIds: function (list) {
                var ids = [];

                function getIds(list) {
                    if (!list) return ids;
                    for (var i = 0; i < list.length; i++) {
                        ids.push(list[i].id);
                        getIds(list[i].children);
                    }
                }

                getIds(list);
                return ids;
            },

            getDataList:function () {
                var self = this;
                this.loading = true;
                this.$axios({
                    method: 'GET',
                    url: '/cmss/cmssMenu/getMenuList'
                }).then(function (response) {
                    var data = response.data;
                    if(data.status == '1'){
                        self.pageList = data.data || [];
                        self.setFlattenMenuList([].concat(self.pageList))
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

            goAddMenu:function () {
                window.location.href = this.frontOrAdmin + '/cmss/cmssMenu/form';
            },

            goChangeData:function (id) {
                window.location.href = this.frontOrAdmin + '/cmss/cmssMenu/form?id=' + id;
            },

            goAddChild:function (id) {
                window.location.href = this.frontOrAdmin + '/cmss/cmssMenu/form?parent.id=' + id;
            },

            singleDelete:function (id) {
                var self = this;
                this.$confirm('要删除该菜单及所有子菜单项吗？','提示',{
                    confirmButtonText:'确定',
                    cancelButtonText:'取消',
                    type:'warning'
                }).then(function () {
                    self.singleDeleteRequest(id);
                })
            },

            singleDeleteRequest:function (id) {
                var self = this;
                this.$axios({
                    method: 'POST',
                    url: '/cmss/cmssMenu/ajaxDeleteMenu',
                    data: {id: id}
                }).then(function (response) {
                    var data = response.data;
                    if (data.status == '1') {
                        self.getDataList();
                    }
                    self.$message({
                        message: data.status == '1' ? '删除成功' : data.msg || '删除失败',
                        type: data.status == '1' ? 'success' : 'error'
                    });
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: '请求失败'
                    });
                })
            },

            saveSorts:function () {
                var self = this;
                var obj = [];
                var flattenMenuList = this.flattenMenuList;
                for(var i = 0; i < flattenMenuList.length; i++){
                    var menuItem = flattenMenuList[i];
                    if(!(/^\+?[0-9][0-9]*$/.test(menuItem.sort))){
                        this.$message({
                            type: 'error',
                            message: '请输入排序数字'
                        });
                        return false;
                    }
                    obj.push({id:menuItem.id,sort:parseInt(menuItem.sort)});
                }
                this.loading = true;
                this.$axios({
                    method: 'POST',
                    url: '/cmss/cmssMenu/ajaxUpdateSort',
                    data:{
                        menuList:obj
                    }
                }).then(function (response) {
                    var data = response.data;
                    if(data.status == '1'){
                        self.getDataList();
                    }
                    self.$message({
                        message: data.status == '1' ? '保存成功' : data.msg || '保存失败',
                        type: data.status == '1' ? 'success' : 'error'
                    });
                    self.loading = false;
                }).catch(function () {
                    self.$message({
                        message: '请求失败',
                        type: 'error'
                    });
                    self.loading = false;
                });

            },

            handleChangeIsShow:function (row) {
                var self = this;
                this.$axios({
                    method: 'POST',
                    url: '/cmss/cmssMenu/ajaxChangeMenuIsShow',
                    data: {
                        id: row.id,
                        isShow: row.isShow
                    }
                }).then(function (response) {
                    var data = response.data;
                    if (data.status != '1') {
                        row.isShow = row.isShow == '1' ? '0' : '1';
                        self.$message({
                            message: '操作失败',
                            type: 'error'
                        });
                    }
                }).catch(function (error) {
                    row.isShow = row.isShow == '1' ? '0' : '1';
                    self.$message({
                        message: '请求失败',
                        type: 'error'
                    });
                })
            },

            setFlattenMenuList:function (list) {
                this.setMenuEntries(list);
                var rootIds = this.setMenuRootIds(list);
                this.menuTree = this.getMenuTreeTree(rootIds, this.menuProps, list);
                this.flattenMenuList = this.getFlattenMenuList(1);
            },

            getMenuTree: function () {
                var self = this;
                this.loading = true;
                this.$axios.get('/cmss/cmssMenu/getMenuTree').then(function (response) {
                    var data = response.data;
                    if(data.status === 1){
                        self.menuTree = data.data || [];
                        self.flattenMenuList  = self.handleFlattenTree(self.menuTree);
                    }
                    self.loading = false;
                }).catch(function () {
                    self.$message({
                        message: self.xhrErrorMsg,
                        type: 'error'
                    })
                    self.loading = false;
                })
            },

        },
        created: function () {
            this.getMenuTree();
            if (this.message) {
                this.$message({
                    message: this.message,
                    type: this.message.indexOf('完成') > -1 ? 'success' : 'warning'
                });
                this.message = '';
            }
        }
    })

</script>

</body>
</html>