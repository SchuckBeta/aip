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

            <e-condition label="学院" type="radio" v-model="searchListForm['office.id']" :default-props="defaultProps"
                         name="officeId" :options="collegeList" @change="getDataList">
            </e-condition>

        </div>

        <div class="list-type-tab">
            <div class="tab-cell active" @click.stop.prevent="goCurrent">
                <span>当前分配记录</span>
                <div class="arrow-right"></div>
            </div>
            <div class="tab-cell" @click.stop.prevent="goHistory">
                <span>历史分配记录</span>
                <div class="arrow-right"></div>
            </div>
        </div>

        <div class="search-block_bar clearfix mgt-20">
            <div class="search-input">
                <el-select size="mini" v-model="condition" placeholder="请选择查询条件"
                           @change="handleChangeCondition" style="width:135px;">
                    <el-option
                            v-for="item in conditions"
                            :key="item.id"
                            :label="item.label"
                            :value="item.value">
                    </el-option>
                </el-select>
                <el-date-picker :disabled="!condition"
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
                <el-input name="keys" size="mini" class="w300" v-model="searchListForm.keys"
                          placeholder="团队/企业/负责人/组成员/导师" @keyup.enter.native="getDataList">
                    <el-button slot="append" class="el-icon-search" @click.stop.prevent="getDataList"></el-button>
                </el-input>
            </div>
        </div>

    </el-form>

    <div class="table-container">
        <el-table :data="pageList" ref="pageList" class="table" size="mini" v-loading="loading"
                   @sort-change="handleTableSortChange">
            <el-table-column
              type="index"
              width="50">
            </el-table-column>
            <el-table-column label="团队/企业" align="left">
                <template slot-scope="scope">
                    <table-thing-info :row="getPwEnterInfo(scope.row)"></table-thing-info>
                </template>
            </el-table-column>
            <el-table-column label="团队成员" align="left">
                <template slot-scope="scope">
                    <table-team-member :row="getPwEnterTeamInfo(scope.row)"></table-team-member>
                </template>
            </el-table-column>
            <el-table-column label="分配场地" align="left">
                <template slot-scope="scope">
                    <div>{{scope.row.numtype | selectedFilter(numTypesEntries)}}：共{{scope.row.num}}<span v-if="scope.row.numtype == '1'">人</span><span v-else>个</span></div>
                    <div>占地面积：{{scope.row.area}}平方米</div>
                </template>
            </el-table-column>
            <el-table-column prop="startDate" label="有效期" align="center" sortable="startDate">
                <template slot-scope="scope">
                    {{scope.row.startDate | formatDateFilter('YYYY-MM-DD')}}至{{scope.row.endDate | formatDateFilter('YYYY-MM-DD')}}
                </template>
            </el-table-column>
            <el-table-column prop="querystatus" label="状态" align="center" sortable="querystatus">
                <template slot-scope="scope">
                    <span :class="{red:scope.row.querystatus == '4'}">{{scope.row.querystatus | selectedFilter(roomStatesEntries)}}</span>
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


<script>
    new Vue({
        el: '#app',
        data: function () {
            var professionals = JSON.parse('${fns:getOfficeListJson()}') || [];
            var rid = '${rid}';
            return {
                professionals: professionals,
                rid:rid,
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
                    }
                ],
                pageCount: 0,
                message: '${message}',
                condition:'',
                searchListForm: {
                    pageSize: 10,
                    pageNo: 1,
                    orderBy: '',
                    orderByType: '',
                    rid:rid || '',
                    queryType:'1',
                    'office.id': '',
                    entertimebegin: '',
                    entertimeend: '',
                    deadlinebegin: '',
                    deadlineend: '',
                    keys: ''
                },
                defaultProps: {
                    label: 'name',
                    value: 'id'
                },
                loading: false,
                applyDate: [],
                pwEnterTypes: [],
                numTypes: [],
                roomStates: [],

                pageList: []
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
            pwEnterTypeEntries: function () {
                return this.getEntries(this.pwEnterTypes)
            },
            numTypesEntries: function () {
                return this.getEntries(this.numTypes);
            },
            roomStatesEntries: function () {
                return this.getEntries(this.roomStates,{label:'statusname',value:'status'});
            },
            officeEntries: function () {
                return this.getEntries(this.professionals, {label: 'name', value: 'id'})
            }
        },
        methods: {
            getDataList: function () {
                var self = this;
                this.loading = true;
                this.$axios({
                    method: 'GET',
                    url: '/pw/pwRoom/roomAllotDetailList',
                    params:Object.toURLSearchParams(this.searchListForm)
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
            setDateSearch:function () {
                this.searchListForm.entertimebegin = '';
                this.searchListForm.entertimeend = '';
                this.searchListForm.deadlinebegin = '';
                this.searchListForm.deadlineend = '';
                if(this.condition == '1'){
                    this.searchListForm.entertimebegin = this.applyDate[0];
                    this.searchListForm.entertimeend = this.applyDate[1];
                }else if(this.condition == '2'){
                    this.searchListForm.deadlinebegin = this.applyDate[0];
                    this.searchListForm.deadlineend = this.applyDate[1];
                }
            },
            handleChangeCondition: function () {
                if(this.applyDate.length == 0){
                    return false;
                }
                this.setDateSearch();
                this.getDataList();
            },
            handleChangeDate: function (value) {
                this.applyDate = value || [];
                this.setDateSearch();
                this.getDataList();
            },


            getPwEnterInfo: function (row) {
                var type = row.type;
                var name = row.eteam ? row.eteam.team.name : '';
                var label = this.pwEnterTypeEntries[row.type];
                var applicant = row.applicant;
                if (type == '2') {
                    name = row.ecompany ? row.ecompany.pwCompany.name : '';
                }
                return {
                    label: label,
                    name: name,
                    officePro: applicant.officeName + (applicant.professional ? ('/' + this.officeEntries[applicant.professional]) : '')
                }
            },
            getPwEnterTeamInfo: function (row) {
                var eteam = row.eteam || {};
                var applicant = row.applicant;
                return {
                    applicantName: applicant.name,
                    snames: eteam.snames || '',
                    tnames: eteam.tnames || ''
                }
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
            goCurrent: function () {
                window.location.href = this.frontOrAdmin + '/pw/pwRoom/allotRoomDetailTab1?rid=' + this.rid;
            },
            goHistory: function () {
                window.location.href = this.frontOrAdmin + '/pw/pwRoom/allotRoomDetailTab2?rid=' + this.rid;
            },
            getPwEnterTypes: function () {
                var self = this;
                this.$axios.get('/pw/pwEnter/getPwEnterTypes').then(function (response) {
                    var data = response.data;
                    self.pwEnterTypes = data || [];
                })
            },
            getNumTypes:function () {
                var self = this;
                this.$axios.post('/pw/pwRoom/pwRoomType').then(function (response) {
                    var data = response.data;
                    self.numTypes = data.data || [];
                })
            },
            getRoomStates:function () {
                var self = this;
                this.$axios.get('/pw/pwRoom/roomUseType?num=3').then(function (response) {
                    var data = response.data;
                    self.roomStates = data.data || [];
                })
            }

        },
        created: function () {
            this.getPwEnterTypes();
            this.getRoomStates();
            this.getDataList();
            this.getNumTypes();
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