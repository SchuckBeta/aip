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
    <div class="mgb-20">
        <edit-bar></edit-bar>
    </div>
    <div class="clearfix">
        <div class="search-block_bar clearfix">
            <div class="search-btns">
                <el-button type="primary" size="mini" @click.stop.prevent="openWebSiteFormDialog"><i
                        class="iconfont icon-baocun"></i>保存排序
                </el-button>
                <el-button type="primary" size="mini" @click.stop.prevent="goToMenuForm"><i
                        class="iconfont icon-tianjia"></i>添加
                </el-button>
            </div>
        </div>
    </div>
    <div class="table-container">
        <el-table :data="flattenMenuList" size="mini" :cell-style="eTableCellStyle"
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

            <!-- <el-table-column label="显示" align="center">
                <template slot-scope="scope">
                    <el-switch v-model="scope.row.inMenu" active-value="1" inactive-value="0"
                               active-text="显示" inactive-text="隐藏"></el-switch>
                </template>
            </el-table-column> -->

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
                    <el-button size="mini" type="text">访问
                    </el-button>
                    <el-button size="mini" type="text" :disabled="scope.row.parentId == 1" @click.stop.prevent="goToEditForm(scope.row.id)">修改</el-button>
                    <el-button size="mini" type="text" :disabled="scope.row.parentId == 1">删除
                    </el-button>
                    <el-button size="mini" type="text" :disabled="scope.row.parentIds.split(',').length >= 5">添加下级栏目</el-button>
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
            var menuList = JSON.parse('${fns: toJson(list)}');
            var cmsShowModeList = JSON.parse('${fns: toJson(fns: getDictList('cms_show_modes'))}');
            var cmsModuleList = JSON.parse('${fns: toJson(fns: getDictList('cms_module'))}');

            menuList = menuList.filter(function (item) {
                return item.parentId !== '1' && item.name !== '首页'
            });


            return {
                menuList: menuList,
                cmsModuleList: cmsModuleList,
                cmsShowModeList: cmsShowModeList
            }
        },
        computed: {
            flattenMenuList: {
                get: function () {
                    return this.getFlattenMenuList()
                }
            },
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
                location.href = this.frontOrAdmin + '/cms/category/form?id='+id;
            }
        }
    })

</script>

</body>
</html>