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
<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60">
    <edit-bar></edit-bar>
    <el-form :model="searchListForm" ref="searchListForm" size="mini">
        <div class="conditions">
            <e-condition type="radio" v-model="searchListForm.isPreRelease" label="预发布"
                         :options="yesNoes" @change="getActYwList"></e-condition>
            <e-condition type="radio" v-model="searchListForm.isDeploy" label="发布状态"
                         :options="yesNoes" @change="getActYwList"></e-condition>
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
                        size="mini"
                        name="inputValue"
                        v-model="inputValue"
                        @keyup.enter.native="getActYwList"
                        style="width: 400px;"
                >
                    <el-select v-model="selectName" slot="prepend" placeholder="请选择" style="width: 100px">
                        <el-option label="项目名称" value="proProject.projectName"></el-option>
                        <el-option label="流程名称" value="group.name"></el-option>
                    </el-select>
                    <el-button slot="append" icon="el-icon-search" @click.stop.prevent="getActYwList"></el-button>
                </el-input>
            </div>
        </div>
    </el-form>
    <div class="table-container">
        <el-table :data="actYwList" size="small" class="table" border :span-method="objectSpanMethod" style="margin-left: -1px;margin-right: -1px">
            <el-table-column label="项目名称">
                <template slot-scope="scope">
                    {{scope.row.proProject.projectName}}
                </template>
            </el-table-column>
            <el-table-column label="工作流程" align="center">
                <template slot-scope="scope">
                    <a :href="frontOrAdmin + '/actyw/actYwGroup/form?id='+scope.row.group.id">
                        {{scope.row.group.name}}
                    </a>
                </template>
            </el-table-column>
            <el-table-column label="编号规则" align="center">
                <template slot-scope="scope">
                    <a :href="frontOrAdmin + '/sys/sysNumberRule'">
                        {{scope.row.numberRuleName}}
                    </a>
                </template>
            </el-table-column>
            <el-table-column label="编号规则示例" align="center">
                <template slot-scope="scope">
                    {{scope.row.numberRuleText}}
                </template>
            </el-table-column>
            <el-table-column label="发布类型" align="center">
                <template slot-scope="scope">
                    <template v-if="scope.row.isDeploy">
                        {{scope.row.isPreRelease ? '预发布' : '正式发布'}}
                    </template>
                </template>
            </el-table-column>
            <el-table-column label="发布状态" align="center">
                <template slot-scope="scope">
                    {{scope.row.isDeploy | selectedFilter(publishEntries)}}
                </template>
            </el-table-column>
            <el-table-column label="年份" align="center">
                <template slot-scope="scope">
                    {{scope.row.year}}
                </template>
            </el-table-column>
            <el-table-column label="项目有效期" align="center" width="180">
                <template slot-scope="scope">
                    <template v-if="!!scope.row.startDate">
                        {{scope.row.startDate | formatDateFilter('YYYY-MM-DD')}}至{{scope.row.endDate |
                        formatDateFilter('YYYY-MM-DD')}}
                    </template>
                </template>
            </el-table-column>
            <el-table-column label="修改时间" align="center">
                <template slot-scope="scope">
                    <a :href="frontOrAdmin + '/actyw/actYw/formGtime?id='+scope.row.id+'&yearId='+scope.row.yearId">修改时间</a>
                </template>
            </el-table-column>
            <el-table-column label="操作" align="center">
                <template slot-scope="scope">
                    <div class="table-btns-action">
                        <el-button type="text" size="mini" v-if="ywIds.indexOf(scope.row.id) == -1" @click.stop.prevent="handleEditProp(scope.row)">修改属性</el-button>
                        <template v-if="scope.row.isDeploy">
                            <el-button v-if="scope.row.isPreRelease" type="text" size="mini"
                                       @click.stop.prevent="confirmReleaseActYw(scope.row)">正式发布
                            </el-button>
                            <el-button type="text" size="mini" v-if="ywIds.indexOf(scope.row.id) == -1" @click.stop.prevent="confirmUnReleaseActYw(scope.row)">取消发布</el-button>
                        </template>
                        <template v-else>
                            <el-button type="text" size="mini" @click.stop.prevent="confirmAjaxDeployActYw(scope.row)">预发布</el-button>
                            <el-button type="text" size="mini" @click.stop.prevent="confirmDelActYw(scope.row)">删除</el-button>
                        </template>
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


<script type="text/javascript">

    'use strict';

    new Vue({
        el: '#app',
        data: function () {
            var yesNoes = JSON.parse('${fns: toJson(fns:getDictList('yes_no'))}');
            var publishes = JSON.parse('${fns: toJson(fns: getDictList('true_false'))}');
            return {
                searchListForm: {
                    pageNo: 1,
                    pageSize: 10,
                    isPreRelease: '',
                    isDeploy: '',
                    'group.flowType': '${actYw.group.flowType}'
                },
                pageCount: 0,
                yesNoes: yesNoes,
                publishes: publishes,
                selectName: 'proProject.projectName',
                inputValue: '',
                actYwList: [],
                tableLoading: true,
                actYw: {
                    group: {}
                },
                rowspanArr: [0, 1, 2, 3, 4, 5, 9],
                ywgId: '',
                ywpId: ''
            }
        },
        computed: {
            publishEntries: function () {
                return this.getEntries(this.publishes)
            },
            ywIds: function () {
                return [this.ywgId, this.ywpId]
            }
        },
        watch: {
            selectName: function (value) {
                this.searchListForm[value] = this.inputValue;
            }
        },
        methods: {

            goToAdd: function () {
                location.href = this.frontOrAdmin + '/actyw/actYw/form?group.flowType=' + this.actYw.group.flowType
            },

            getActYwList: function () {
                var self = this;
                this.searchListForm['group.name'] = '';
                this.searchListForm['proProject.projectName'] = '';
                this.searchListForm[this.selectName] = this.inputValue;
                this.tableLoading = true;
                this.$axios.get('/actyw/actYw/getActYwList?' + Object.toURLSearchParams(this.searchListForm)).then(function (response) {
                    var data = response.data;
                    var pageData = {};
                    if (data.status == '1') {
                        pageData = data.data;
                    }
                    self.actYwList = self.changeActYwList(pageData.list);
                    self.pageCount = pageData.count || 0;
                    self.searchListForm.pageSize = pageData.pageSize || 1;
                    self.searchListForm.pageNo = pageData.pageNo || 10;
                    self.tableLoading = false;
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: self.xhrErrorMsg
                    })
                    self.tableLoading = false;
                })
            },

            changeActYwList: function (list) {
                var nList = [];
                var self = this;
                list = list || [];
                list.forEach(function (item, index) {
                    if (item.years && item.years.length > 1) {
                        var yearLen = item.years.length;
                        var nItem = list.slice(index, index + 1)[0];
                        nItem = JSON.parse(JSON.stringify(nItem));
                        nItem.rowspan = yearLen;
                        nList.push(self.extendYears(nItem, item.years[0]));
                        item.rowspan = 0;
                        for (var i = 1; i < yearLen; i++) {
                            nList.push(self.extendYears(item, item.years[i]))
                        }
                    } else {
                        nList.push(self.extendYears(item, item.years[0]));
                    }
                })
                return nList;
            },

            extendYears: function (item, year) {
                var nItem = JSON.parse(JSON.stringify(item))
                nItem.endDate = year.endDate;
                nItem.startDate = year.startDate;
                nItem.year = year.year;
                nItem.yearId = year.id;
                return nItem;

            },

            getActYw: function () {
                var self = this;
                this.$axios.get('/actyw/actYw/getActYw?group.flowType=' + this.searchListForm['group.flowType']).then(function (response) {
                    var data = response.data;
                    self.actYw = data.data.actYw;
                    self.ywgId = data.data.ywgId;
                    self.ywpId = data.data.ywpId;
                }).catch(function (error) {

                })
            },

            objectSpanMethod: function (spanObj) {
                var row = spanObj.row;
                var column = spanObj.column;
                var rowIndex = spanObj.rowIndex;
                var columnIndex = spanObj.columnIndex;
                if (row.rowspan != undefined) {
                    if (this.rowspanArr.indexOf(columnIndex) > -1) {
                        if (row.rowspan > 0) {
                            return {
                                rowspan: row.rowspan,
                                colspan: 1
                            }
                        } else {
                            return {
                                rowspan: 0,
                                colspan: 0
                            }
                        }

                    }
                }
            },


            handlePSizeChange: function (value) {
                this.searchListForm.pageSize = value;
                this.getActYwList();
            },

            handlePCPChange: function () {
                this.getActYwList();
            },

            handleEditProp: function (row) {
                location.href = this.frontOrAdmin + '/actyw/actYw/formProp?id=' + row.id
            },

            confirmReleaseActYw: function (row) {
                var self = this;
                this.$confirm('确认要正式发布' + row.proProject.projectName + '吗？', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.releaseActYw(row)
                }).catch(function () {

                })
            },

            releaseActYw: function (row) {
                var self = this;

                this.$axios.post('/actyw/actYw/ajaxPreReleaseJson', {
                    id: row.id,
                    isPreRelease: false
                }).then(function (response) {
                    var data = response.data;
                    if (data.status == 1) {
                        self.getActYwList();
                    }
                    self.$message({
                        type: data.status == '1' ? 'success' : 'error',
                        message: data.status == '1' ? '正式发布成功' : data.msg
                    })
                })
            },

            confirmUnReleaseActYw: function (row) {
                var self = this;
                this.$confirm('确认要取消发布' + row.proProject.projectName + '吗？', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.unReleaseActYw(row)
                }).catch(function () {

                })
            },

            unReleaseActYw: function (row) {
                var self = this;
                this.$axios.post('/actyw/actYw/ajaxDeployJson', {
                    id: row.id,
                    isDeploy: false
                }).then(function (response) {
                    var data = response.data;
                    if (data.status == 1) {
                        self.getActYwList();
                    }
                    self.$message({
                        type: data.status == '1' ? 'success' : 'error',
                        message: data.status == '1' ? '取消发布成功' : data.msg
                    })
                })
            },

            confirmAjaxDeployActYw: function (row) {
                var self = this;
                this.$confirm('确认要预发布' + row.proProject.projectName + '吗？', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.ajaxDeployActYw(row)
                }).catch(function () {

                })
            },

            ajaxDeployActYw: function (row) {
                var self = this;
                this.$axios.post('/actyw/actYw/ajaxDeployJson', {
                    id: row.id,
                    isDeploy: true,
                    isPreRelease: true,
                    isUpdateYw: true
                }).then(function (response) {
                    var data = response.data;
                    if (data.status == 1) {
                        self.getActYwList();
                    }
                    self.$message({
                        type: data.status == '1' ? 'success' : 'error',
                        message: data.status == '1' ? '预发布成功' : data.msg
                    })
                })
            },

            confirmDelActYw: function (row) {
                var self = this;
                this.$confirm('确认要删除' + row.proProject.projectName + '吗？', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.delActYw(row)
                }).catch(function () {

                })
            },

            delActYw: function (row) {
                var self = this;
                this.$axios.post('/actyw/actYw/delActYw', row).then(function (response) {
                    var data = response.data;
                    if (data.status == 1) {
                        self.getActYwList();
                    }
                    self.$message({
                        type: data.status == '1' ? 'success' : 'error',
                        message: data.status == '1' ? '删除成功' : data.msg
                    })
                })
            },

        },
        created: function () {
            this.getActYwList();
            this.getActYw();
        }

    })

</script>

</body>
</html>