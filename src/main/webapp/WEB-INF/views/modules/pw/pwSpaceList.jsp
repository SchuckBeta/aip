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
                <el-button type="primary" size="mini" @click.stop.prevent="goAddCampus">添加校区
                </el-button>
                <el-button type="primary" size="mini" @click.stop.prevent="goAddBase">添加基地
                </el-button>
                <el-button type="primary" size="mini" @click.stop.prevent="goAddBuilding">添加楼栋
                </el-button>
            </div>
        </div>
    </div>
    <div class="table-container">
        <el-table :data="flattenMenuList" v-loading="loading" size="mini" class="e-table-tree"
                  :cell-style="eTableCellStyle">
            <el-table-column label="基地结构" prop="name">
                <template slot-scope="scope">
                    <span class="e-table-tree-dot" v-if="index>0"
                          v-for="(dot, index) in scope.row.dots.split('-').length"></span>
                    <i class="el-icon-caret-right" :class="elIconCaret(scope.row)"
                       @click.stop.prevent="handleExpandCell(scope.row)"></i>
                    <a :href="'${ctx}/pw/pwSpace/details?id=' + scope.row.id" class="e-checkbox__label_dr_card underline-pointer">{{scope.row.name}}</a>
                </template>
            </el-table-column>

            <el-table-column label="场地类型" prop="type" align="center">
                <template slot-scope="scope">
                    {{scope.row.type | selectedFilter(pwSpaceTypesEntries)}}
                </template>
            </el-table-column>

            <el-table-column label="开放时间" prop="openWeek" align="left">
                <template slot-scope="scope">
                    <div class="open-time-cell" v-if="scope.row.type == '3'">
                        <div>
                            <div class="open-time-cell-label">开放日：</div>
                            <div class="open-time-cell-date">{{openWeeksStr(scope.row.openWeeks)}}</div>
                        </div>
                        <div>
                            <div class="open-time-cell-label">时间：</div>
                            <div class="open-time-cell-date">
                                <div>上午：{{scope.row.amOpenStartTime}}-{{scope.row.amOpenEndTime}}</div>
                                <div>下午：{{scope.row.pmOpenStartTime}}-{{scope.row.pmOpenEndTime}}</div>
                            </div>
                        </div>
                    </div>
                </template>
            </el-table-column>

            <shiro:hasPermission name="pw:pwSpace:edit">
                <el-table-column label="操作" align="center">
                    <template slot-scope="scope">
                        <div class="table-btns-action">

                            <a v-if="scope.row.type == '1'" :href="'${ctx}/pw/pwSpace/form?parent.id='+ scope.row.id + '&type=2&secondName=添加基地'">添加基地</a>
                            <a v-if="scope.row.type == '1'" :href="'${ctx}/pw/pwSpace/form?parent.id='+ scope.row.id + '&type=3&secondName=添加楼栋'">添加楼栋</a>

                            <a v-if="scope.row.type == '2'" :href="'${ctx}/pw/pwSpace/form?parent.id='+ scope.row.id + '&type=3&secondName=添加楼栋'">添加楼栋</a>

                            <a v-if="scope.row.type == '3'" :href="'${ctx}/pw/pwSpace/form?parent.id='+ scope.row.id + '&type=4&secondName=添加楼层'">添加楼层</a>

                            <a v-if="scope.row.type == '4'" :href="'${ctx}/pw/pwFloorDesigner/list?floorId='+ scope.row.id + '&secondName=设计'">设计</a>

                            <a v-if="scope.row.type != '0'" :href="'${ctx}/pw/pwSpace/form?id='+ scope.row.id + '&secondName=修改'">修改</a>
                            <a v-if="scope.row.type != '0'" href="javascript:void(0)" @click.stop.prevent="singleDelete(scope.row.id)">删除</a>
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
            var pageList = JSON.parse('${fns:toJson(list)}');
            var pwSpaceTypes = JSON.parse('${fns:toJson(fns:getDictList('pw_space_type'))}');
            return {
                pageList: pageList,
                pwSpaceTypes: pwSpaceTypes,
                flattenMenuList: [],
                menuList: [],
                loading: false,
                menuProps: {
                    parentKey: 'parentId',
                    id: 'id'
                },
                message: '${message}'
            }
        },
        computed: {
            pwSpaceTypesEntries: {
                get: function () {
                    return this.getEntries(this.pwSpaceTypes)
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

            singleDelete:function (id) {
                this.$confirm('确认删除吗？', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    window.location.href = '${ctx}/pw/pwSpace/delete?id=' + id;
                });
            },

            goAddCampus:function () {
                window.location.href = '${ctx}/pw/pwSpace/form?parent.id=c146d62ea1854e128549db6f999c7d47&type=1&secondName=添加校区';
            },

            goAddBase:function () {
                window.location.href = '${ctx}/pw/pwSpace/form?parent.id=c146d62ea1854e128549db6f999c7d47&type=2&secondName=添加基地';
            },

            goAddBuilding:function () {
                window.location.href = '${ctx}/pw/pwSpace/form?parent.id=c146d62ea1854e128549db6f999c7d47&type=3&secondName=添加楼栋';
            },

            openWeeksStr: function (arr) {
                if (arr) {
                    if (arr.length == 7) {
                        return '不限';
                    }
                    var r = '';

                    arr.forEach(function (item) {
                        switch (item) {
                            case '1':
                                r += '每周一、';
                                break;
                            case '2':
                                r += '每周二、';
                                break;
                            case '3':
                                r += '每周三、';
                                break;
                            case '4':
                                r += '每周四、';
                                break;
                            case '5':
                                r += '每周五、';
                                break;
                            case '6':
                                r += '每周六、';
                                break;
                            case '7':
                                r += '每周日、';
                                break;
                            default:
                                break;
                        }
                    });
                    if (r != '') {
                        return r.substring(0, r.length - 1);
                    }
                }
            },

            setFlattenMenuList: function (list) {
                this.setMenuEntries(list);
                var rootIds = this.setMenuRootIds(list);
                this.menuTree = this.getMenuTreeTree(rootIds, this.menuProps, list);
                this.flattenMenuList = this.getFlattenMenuList(4);
            }
        },
        created: function () {
            this.setFlattenMenuList([].concat(this.pageList));
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