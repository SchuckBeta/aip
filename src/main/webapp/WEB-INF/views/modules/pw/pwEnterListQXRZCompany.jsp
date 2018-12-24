<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ page errorPage="/WEB-INF/views/error/formMiss.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>

<body>


<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60 renewal-back-manage">
    <edit-bar></edit-bar>
    <el-form :model="searchListForm" ref="searchListForm" size="mini">
        <div class="conditions">

            <e-condition label="基地" type="radio" :options="baseList" v-model="baseId" @change="handleChangeBase"
                         :default-props="{label: 'name', value: 'id'}"></e-condition>

            <e-condition label="楼栋">
                <e-radio class="e-checkbox-all" name="build" v-model="buildId" label="" @change="handleChangeBuild">不限
                </e-radio>
                <e-radio-group class="e-radio-spaces" v-model="buildId" @change="handleChangeBuild">
                    <e-radio v-for="build in buildList" name="buildId" :class="{'is-siblings': build.isSiblings}"
                             :label="build.id" :key="build.id">{{build.name}}
                    </e-radio>
                </e-radio-group>
            </e-condition>

            <e-condition label="楼层" type="radio" :options="floorList" v-model="floorId" @change="handleChangeFloor"
                         :default-props="{label: 'name', value: 'id'}"></e-condition>


            <e-condition label="学院" type="radio" v-model="searchListForm.localCollege" :default-props="defaultProps"
                         name="localCollege" :options="collegeList" @change="getDataList">
            </e-condition>
            <e-condition label="入驻状态" type="radio" v-model="searchListForm.enterState"
                         name="enterState" :options="enterStates" @change="getDataList">
            </e-condition>
        </div>

        <div class="list-type-tab">
            <div class="tab-cell" @click.stop.prevent="goCompany">
                <span>企业退孵</span>
                <div class="arrow-right"></div>
            </div>
            <div class="tab-cell" @click.stop.prevent="goTeam">
                <span>团队退孵</span>
                <div class="arrow-right"></div>
            </div>
            <div class="tab-cell active" @click.stop.prevent="goApply">
                <span>审核退孵申请</span>
                <div class="arrow-right"></div>
                <div class="bubble-num"><span>5</span></div>
            </div>
        </div>

        <div class="search-block_bar clearfix mgt-20">
            <div class="search-input">
                <el-select size="mini" v-model="searchListForm.condition" placeholder="请选择查询条件"
                           @change="handleChangeCondition" style="width:135px;">
                    <el-option
                            v-for="item in conditions"
                            :key="item.id"
                            :label="item.label"
                            :value="item.value">
                    </el-option>
                </el-select>
                <el-date-picker :disabled="!searchListForm.condition"
                                v-model="applyDate"
                                type="daterange"
                                size="mini"
                                align="right"
                                @change="handleChangeDate"
                                unlink-panels
                                range-separator="至"
                                start-placeholder="开始日期"
                                end-placeholder="结束日期"
                                value-format="yyyy-MM-dd"
                                style="width: 270px;">
                </el-date-picker>
                <input type="text" style="display:none">
                <el-input name="queryStr" size="mini" class="w300" v-model="searchListForm.queryStr"
                          placeholder="企业/团队名称/负责人/组成员/导师" @keyup.enter.native="getDataList">
                    <el-button slot="append" class="el-icon-search" @click.stop.prevent="getDataList"></el-button>
                </el-input>
            </div>
        </div>

    </el-form>

    <div class="table-container">
        <el-table :data="pageList" ref="pageList" class="table" size="mini" v-loading="loading"
                  @sort-change="handleTableSortChange">
            <el-table-column label="企业/团队名称" align="left" min-width="140">
                <template slot-scope="scope">
                    <%--链接到详情--%>
                    <div>企业/团队：{{scope.row.teamName}}</div>
                    <div>{{scope.row.academy}}/{{scope.row.major}}</div>
                </template>
            </el-table-column>
            <el-table-column label="团队成员" align="left" min-width="140">
                <template slot-scope="scope">
                    <div>负责人：{{scope.row.duty}}</div>
                    <div>组成员：{{scope.row.member}}</div>
                    <div>导师：{{scope.row.teacher}}</div>
                </template>
            </el-table-column>
            <el-table-column prop="validEnd" label="入驻有效期" align="center" sortable="validEnd" min-width="140">
                <template slot-scope="scope">
                    <span>{{scope.row.validStart}} 至 {{scope.row.validEnd}}</span>
                </template>
            </el-table-column>
            <el-table-column label="所属场地" align="center" min-width="110">
                <template slot-scope="scope">
                    <span>创业基地/南栋/1层 实验室001</span>
                </template>
            </el-table-column>
            <el-table-column prop="enterState" label="入驻状态" align="center" sortable="enterState" min-width="100">
                <template slot-scope="scope">
                    <span :class="{red:scope.row.enterState == '4'}">{{scope.row.enterState | selectedFilter(enterStatesEntries)}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="checkState" label="状态" align="center" min-width="80">
                <template slot-scope="scope">
                    <span v-if="scope.row.checkState == '0'">待审核</span>
                </template>
            </el-table-column>

            <shiro:hasPermission name="pw:pwEnter:edit">
                <el-table-column label="操作" align="center" min-width="70">
                    <template slot-scope="scope">
                        <div class="table-btns-action">
                            <el-button size="mini" type="text" @click.stop.prevent="checkApply(scope.row.id)">审核
                            </el-button>
                        </div>
                    </template>
                </el-table-column>
            </shiro:hasPermission>

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

    <el-dialog title="审核退孵" :visible.sync="dialogVisible" :close-on-click-modal="isClose"
               :before-close="handleCloseDialog" width="500px">
        <el-form size="mini" :model="dialogForm" :rules="dialogFormRules" ref="dialogForm" :disabled="formDisabled"
                 label-width="120px">
            <el-form-item prop="resultType" label="审核：">
                <el-select size="mini" v-model="dialogForm.resultType" placeholder="请选择" style="width: 170px;">
                    <el-option
                            v-for="item in resultTypes"
                            :key="item.id"
                            :label="item.label"
                            :value="item.value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item prop="suggest" label="建议及意见：">
                <el-input type="textarea" :rows="3" v-model="dialogForm.suggest" maxlength="200"
                          style="width:300px;"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button size="mini" @click="handleCloseDialog">取消</el-button>
            <el-button size="mini" type="primary" @click.stop.prevent="saveDialog('dialogForm')">确定</el-button>
        </div>
    </el-dialog>


</div>


<script>
    new Vue({
        el: '#app',
        data: function () {
            var professionals = JSON.parse('${fns:getOfficeListJson()}') || [];
            return {
                professionals: professionals,
                enterStates: [
                    {
                        id: '111',
                        label: '入驻成功',
                        value: '1'
                    },
                    {
                        id: '222',
                        label: '即将到期',
                        value: '2'
                    },
                    {
                        id: '333',
                        label: '已续期',
                        value: '3'
                    },
                    {
                        id: '444',
                        label: '已到期',
                        value: '4'
                    },
                    {
                        id: '444',
                        label: '已退孵',
                        value: '4'
                    }
                ],
                conditions: [
                    {
                        id: '111',
                        label: '入驻日期',
                        value: '1'
                    },
                    {
                        id: '222',
                        label: '到期日期',
                        value: '2'
                    },
                    {
                        id: '333',
                        label: '续期日期',
                        value: '3'
                    }
                ],
                pageCount: 0,
                message: '${message}',
                searchListForm: {
                    pageSize: 10,
                    pageNo: 1,
                    orderBy: '',
                    orderByType: '',
                    'pwSpace.id':'',
                    localCollege: '',
                    enterState: '',
                    condition: '',
                    startDate: '',
                    endDate: '',
                    queryStr: ''
                },
                defaultProps: {
                    label: 'name',
                    value: 'id'
                },
                loading: false,
                applyDate: [],
                dialogForm: {
                    id: '',
                    resultType: '',
                    suggest: ''
                },
                resultTypes: [
                    {
                        id: '222',
                        label: '通过',
                        value: '1'
                    },
                    {
                        id: '111',
                        label: '不通过',
                        value: '0'
                    }
                ],
                dialogVisible: false,
                isClose: false,
                formDisabled: false,

                baseId: '',
                buildId: '',
                floorId: '',
                spaceList: [],

                pageList: [
                    {
                        id: '111',
                        teamName: '快递师傅团队',
                        academy: '新闻传播学院',
                        major: '播音主持专业',
                        duty: '王俊杰',
                        member: '吴磊、张金芳、魏宇凡',
                        teacher: '大姐夫，华东师，地方',
                        validStart: '2018.03.01',
                        validEnd: '2019.03.01',
                        checkState: '0',
                        enterState: '4'
                    },
                    {
                        id: '222',
                        teamName: '快递师傅团队',
                        academy: '新闻传播学院',
                        major: '播音主持专业',
                        duty: '王俊杰',
                        member: '吴磊、张金芳、魏宇凡',
                        teacher: '大姐夫，华东师，地方',
                        validStart: '2018.03.01',
                        validEnd: '2019.03.01',
                        checkState: '0',
                        enterState: '2'
                    },
                    {
                        id: '333',
                        teamName: '快递师傅团队',
                        academy: '新闻传播学院',
                        major: '播音主持专业',
                        duty: '王俊杰',
                        member: '吴磊、张金芳、魏宇凡',
                        teacher: '大姐夫，华东师，地方',
                        validStart: '2018.03.01',
                        validEnd: '2019.03.01',
                        checkState: '0',
                        enterState: '4'
                    }
                ]
            }
        },
        computed: {
            collegeList: {
                get: function () {
                    return this.professionals.filter(function (item) {
                        return item.grade == '2';
                    })
                }
            },
            enterStatesEntries: function () {
                return this.getEntries(this.enterStates);
            },
            dialogFormRules: {
                get: function () {
                    return {
                        resultType: [
                            {required: true, message: '请选择审核结果', trigger: 'blur'}
                        ],
                        suggest: [
                            {required: this.dialogForm.resultType == '0', message: '请提出建议及意见', trigger: 'blur'}
                        ]
                    }
                }
            },
            baseList: {
                get: function () {
                    return this.spaceList.filter(function (item) {
                        return item.type === '2'
                    })
                }
            },

            buildList: {
                get: function () {
                    var buildList = [];
                    this.spaceList.forEach(function (item) {
                        if (item.type === '3') {
                            Vue.set(item, 'isSiblings', true);
                            buildList.push(item);
                        }
                    });
                    return buildList;
                }
            },

            floorList: function () {
                var self = this;
                if (!this.buildId) return [];
                return this.spaceList.filter(function (item) {
                    return item.pId === self.buildId;
                })
            }
        },
        methods: {
            getDataList: function () {
//                var self = this;
//                this.loading = true;
//                this.$axios({
//                    method: 'POST',
//                    url: '/pw/ajaxListXQRZ?' + Object.toURLSearchParams(this.searchListForm)
//                }).then(function (response) {
//                    var data = response.data;
//                    if (data.status == '1') {
//                        self.pageCount = data.data.count;
//                        self.searchListForm.pageSize = data.data.pageSize;
//                        self.pageList = data.data.list || [];
//                    }
//                    self.loading = false;
//                }).catch(function () {
//                    self.loading = false;
//                    self.$message({
//                        message: '请求失败',
//                        type: 'error'
//                    })
//                });
            },
            handleChangeCondition: function () {
                if (this.searchListForm.endDate) {
                    this.getDataList();
                }
            },
            handleChangeDate: function (value) {
                value = value || [];
                this.searchListForm.startDate = value[0];
                this.searchListForm.endDate = value[1];
                this.getDataList();
            },
            handleCloseDialog: function () {
                this.dialogVisible = false;
                this.$refs.dialogForm.resetFields();
                this.dialogForm.id = '';
            },
            checkApply: function (id) {
                this.dialogForm.id = id;
                this.dialogVisible = true;
            },
            saveDialog: function (formName) {
                var self = this;
                this.$refs[formName].validate(function (valid) {
                    if (valid) {
                        self.saveAjax();
                    }
                })
            },
            saveAjax: function () {
                console.log(this.dialogForm);
                this.dialogVisible = true;
//                this.handleCloseDialog();

//                this.loading = true;
//                this.formDisabled = true;
//                var self = this;
//                this.$axios({
//                    method: 'POST',
//                    url: '',
//                    data: this.dialogForm
//                }).then(function (response) {
//                    var data = response.data;
//                    if (data.ret == '1') {
//                        self.getDataList();
//                        self.handleCloseDialog();
//                    }
//                    self.loading = false;
//                    self.formDisabled = false;
//                    self.$message({
//                        message: data.status == '1' ? '审核成功' : '审核失败',
//                        type: data.status == '1' ? 'success' : 'error'
//                    });
//                }).catch(function () {
//                    self.loading = false;
//                    self.formDisabled = false;
//                    self.$message({
//                        message: '请求失败',
//                        type: 'error'
//                    });
//                });
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
            goCompany: function () {

            },
            goTeam: function () {

            },
            goApply: function () {

            },
            handleChangeBuild: function () {
                var buildId = this.buildId;
                if(!buildId){
//                    this.baseId = '';
                    this.floorId = '';
                    this.searchListForm['pwSpace.id'] = this.baseId;
                    this.getDataList();
                    return false;
                }
                var build = this.buildList.filter(function (item) {
                    return item.id === buildId;
                });
                this.baseId = build[0].pId;
                this.floorId = '';
                this.searchListForm['pwSpace.id'] = buildId;
                this.getDataList();
            },

            handleChangeBase: function () {
                var buildList = this.buildList;
                var value = this.baseId;
                buildList.forEach(function (item) {
                    Vue.set(item, 'isSiblings', !value ? true : item.pId === value);
                });
                this.buildId = '';
                this.floorId = '';
                this.searchListForm['pwSpace.id'] = value;
                this.getDataList();
            },

            handleChangeFloor: function () {
                this.searchListForm['pwSpace.id'] = this.floorId;
                this.getDataList();
            },
            getSpaceList: function () {
                var self = this;
                return this.$axios.get('/pw/pwSpace/treeData').then(function (response) {
                    self.spaceList = response.data;
                })
            }
        },
        created: function () {
            this.getSpaceList();
//            this.getDataList();
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