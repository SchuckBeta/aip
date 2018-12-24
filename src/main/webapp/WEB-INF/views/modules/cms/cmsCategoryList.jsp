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
                <el-button type="primary" size="mini" :disabled="flattenMenuList.length < 1"
                           @click.stop.prevent="postCmsCategorySorts"><i
                        class="iconfont icon-baocun"></i>保存排序
                </el-button>
                <el-button type="primary" size="mini" @click.stop.prevent="goToMenuForm"><i
                        class="iconfont icon-tianjia"></i>添加
                </el-button>
            </div>
        </div>
    </div>
    <div class="table-container">
        <el-table v-loading="dataLoading" :data="flattenMenuList" size="mini" :cell-style="eTableCellStyle"
                  class="e-table-tree">
            <el-table-column label="名称">
                <template slot-scope="scope">
                            <span class="e-table-tree-dot" v-if="index>0"
                                  v-for="(dot, index) in scope.row.dots.split('-').length"></span>
                    <i :class="elIconCaret(scope.row)" class="el-icon-caret-right"
                       @click.stop.prevent="handleExpandCell(scope.row)"></i>
                    <span class="e-checkbox__label_dr_card">{{scope.row.name}}</span>
                </template>
            </el-table-column>

            <el-table-column label="排序" align="center" width="100px">
                <template slot-scope="scope">
                    <el-input size="mini" v-model.number="scope.row.sort"></el-input>
                </template>
            </el-table-column>

            <el-table-column label="显示" align="center">
                <template slot-scope="scope">
                    <el-switch v-model="scope.row.isShow" :active-value="1" :inactive-value="0" @change="handleChangeColumnShow(scope.row)"
                              ></el-switch>
                </template>
            </el-table-column>

            <el-table-column label="展现方式" align="center">
                <template slot-scope="scope">
                    {{scope.row.showModes | selectedFilter(cmsShowModeEntries)}}
                </template>
            </el-table-column>

            <el-table-column label="栏目模型" align="center">
                <template slot-scope="scope">
                    {{scope.row.module | selectedFilter(cmsModuleEntries)}}
                </template>
            </el-table-column>

            <el-table-column label="操作" align="center">
                <template slot-scope="scope">
                    <div class="table-btns-action">
                        <%--<el-button size="mini" type="text" @click.stop.prevent="goTohref(scope.row)">访问--%>
                        <%--</el-button>--%>
                        <el-button size="mini" type="text"
                                   @click.stop.prevent="goToEditForm(scope.row.id)">修改
                        </el-button>
                        <el-button :disabled="scope.row.isSys == 1" size="mini" type="text"
                                   @click.stop.prevent="confirmColumn(scope.row.id)">删除
                        </el-button>
                        <el-button size="mini" type="text" @click.stop.prevent="goToAddChildren(scope.row)" :disabled="scope.row.dots.split('-').length >= 3">
                            添加下级栏目
                        </el-button>
                    </div>
                </template>
            </el-table-column>
        </el-table>
    </div>
</div>


<script type="text/javascript">

    'use strict';


    new Vue({
        el: '#app',
        mixins: [Vue.menuTreeMixin],
        data: function () {
            <%--var menuList = JSON.parse('${fns: toJson(list)}');--%>
            var cmsShowModeList = JSON.parse('${fns: toJson(fns: getDictList('cms_show_modes'))}');
            var cmsModuleList = JSON.parse('${fns: toJson(fns: getDictList('0000000274'))}');
//			menuList = menuList.filter(function (item) {
//				return item.parentId !== '1' && item.name !== '首页'
//			});


            return {
                menuList: [],
                cmsModuleList: cmsModuleList,
                cmsShowModeList: cmsShowModeList,
                flattenMenuList: [],
                dataLoading: false
            }
        },
        computed: {
            cmsModuleEntries: {
                get: function () {
                    return this.getEntries(this.cmsModuleList)
                }
            },
            cmsShowModeEntries: {
                get: function () {
                    return this.getEntries(this.cmsShowModeList)
                }
            }
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

            goToMenuForm: function () {
                location.href = this.frontOrAdmin + '/cms/category/form'
            },

            goToEditForm: function (id) {
                location.href = this.frontOrAdmin + '/cms/category/form?id=' + id;
            },

            goToAddChildren: function (row) {
                location.href = this.frontOrAdmin + '/cms/category/form?parentId=' + row.id;
            },

            goTohref: function (row) {
                location.href = this.frontOrAdmin + row.href;
            },

            handleChangeColumnShow: function (row) {
                var self = this;
                this.$axios({
                    method: 'POST',
                    url: '/cms/category/updateShow',
                    params: {
                        id: row.id,
                        isShow: row.isShow
                    }
                }).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    if (!checkResponseCode) {
                        row.isShow = row.isShow == 1 ? 0 : 1;
                    }
                    self.$message({
                        type: data.code == 1000 ? 'success' : 'error',
                        message:data.code == 1000 ? '操作成功' : '操作失败'
                    });

                }).catch(function (error) {
                    row.isShow = row.isShow == 1 ? 0 : 1;
                    self.$message({
                        message: error.response.data,
                        type: 'error'
                    });
                })
            },

            getCmsCategoryList: function () {
                var self = this;
                this.dataLoading = true;
                this.$axios.get('/cms/category/cmsCategoryList').then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    if (checkResponseCode) {
                        data = data.data;
                        if (data) {
                            self.menuList = data.list || [];
                            self.setFlattenMenuList([].concat(self.menuList))
                        }
                    }
                    self.dataLoading = false;
                }).catch(function (error) {
                    self.$message({
                        message: error.response.data,
                        type: 'error'
                    });
                    self.dataLoading = false;
                })
            },

            postCmsCategorySorts: function () {
                var self = this;
                var ids = [], sorts = [];
                var flattenMenuList = this.flattenMenuList;

                for(var i = 0; i < flattenMenuList.length; i++){
                    var menuItem = flattenMenuList[i];
                    if(!(/^\+?[1-9][0-9]*$/.test(menuItem.sort))){
                        this.$message({
                            type: 'error',
                            message: '请输入排序数字'
                        });
                        return false;
                    }
                    ids.push(menuItem.id);
                    sorts.push(menuItem.sort);
                }


//                this.flattenMenuList.forEach(function (item) {
//                    ids.push(item.id);
//                    sorts.push(item.sort);
//                });

                this.dataLoading = true;
                this.$axios({
                    method: 'POST',
                    url: '/cms/category/ajaxUpdateSort?ids='+ ids.join(',')+'&sorts='+sorts.join(',')
                }).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    self.$message({
                        type: data.code == 1000 ? 'success' : 'error',
                        message:data.code == 1000 ? '操作成功' : '操作失败'
                    });
                    self.dataLoading = false;
                }).catch(function (error) {
                    self.$message({
                        message: error.response.data,
                        type: 'error'
                    });
                    self.dataLoading = false;
                })
            },

            confirmColumn: function (id) {
                var self = this;
                this.$confirm('此操作将会删除这个栏目和它的子栏目，是否继续？', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.deleteCmsCategory(id);
                }).catch(function () {

                })
            },

            deleteCmsCategory: function (id) {
                var self = this;
                this.$axios({
                    method: 'POST',
                    url: '/cms/category/deleteCmsCategory',
                    params: {id: id}
                }).then(function (response) {
                    var data = response.data;
                    var checkResponseCode = self.checkResponseCode(data.code, data.msg);
                    if (checkResponseCode) {
                        self.$message({
                            type: 'success',
                            message: '操作成功'
                        });
                        self.getCmsCategoryList();
                    }
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: error.response.data
                    });
                })
            },


            setFlattenMenuList: function (menuList) {
                this.setMenuEntries(menuList);
                var rootIds = this.setMenuRootIds(menuList);
                this.menuTree = this.getMenuTreeTree(rootIds, this.menuProps, menuList);
                this.flattenMenuList = this.getFlattenMenuList(0);
            }
        },
        beforeMount: function () {
            this.getCmsCategoryList();
        },
        created: function () {

        }
    })

</script>

</body>
</html>