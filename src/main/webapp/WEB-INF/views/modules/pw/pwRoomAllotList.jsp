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


<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60 room-search">
    <edit-bar></edit-bar>
    <el-form :model="searchListForm" ref="searchListForm" size="mini">
        <div class="conditions room-search-conditions">

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

            <e-condition label="房间类型" type="radio" v-model="searchListForm.roomType"
                         name="roomType" :options="roomTypes" @change="getDataList">
            </e-condition>

            <e-condition label="房间状态" type="radio" v-model="searchListForm.roomState"
                         name="roomState" :options="roomStates" @change="getDataList">
            </e-condition>

        </div>

        <div class="search-block_bar clearfix mgt-20">
            <div class="search-input">
                <el-select size="mini" v-model="searchListForm.condition" placeholder="请选择条件"
                           @change="handleChangeCondition" style="width:135px;">
                    <el-option
                            v-for="item in conditions"
                            :key="item.id"
                            :label="item.label"
                            :value="item.value">
                    </el-option>
                </el-select>

                <el-input name="numMin" size="mini" style="width:70px;" v-model="searchListForm.numMin"
                          :disabled="!searchListForm.condition" @change="getDataList"
                          @keyup.enter.native="getDataList">
                </el-input>
                <span style="color:#dcdfe6;">-</span>
                <el-input name="numMax" size="mini" style="width:70px;" v-model="searchListForm.numMax"
                          :disabled="!searchListForm.numMin" @change="getDataList"
                          @keyup.enter.native="getDataList">
                </el-input>

                <input type="text" style="display:none">

                <el-input name="queryStr" size="mini" class="w300" v-model="searchListForm.queryStr"
                          placeholder="房间名称/所属场地" @keyup.enter.native="getDataList">
                    <el-button slot="append" class="el-icon-search" @click.stop.prevent="getDataList"></el-button>
                </el-input>

                <span class="count-label">共</span><span>60间</span>
                <span class="count-label">已分配</span><span>30间</span>
                <span class="count-label">未分配</span><span>20间</span>

            </div>
        </div>

    </el-form>

    <div class="table-container">
        <el-table :data="pageList" ref="pageList" class="table" size="mini" v-loading="loading"
                  @sort-change="handleTableSortChange">
            <el-table-column label="房间信息" align="left" min-width="100" sortable="roomType">
                <template slot-scope="scope">
                    <div>
                        <el-tooltip :content="scope.row.place" popper-class="white" placement="right">
                            <span class="break-ellipsis">{{scope.row.roomName}}</span>
                        </el-tooltip>
                    </div>
                    <div>{{scope.row.roomType | selectedFilter(roomTypesEntries)}} {{scope.row.roomAttribute |
                        selectedFilter(roomAttributesEntries)}}
                    </div>
                </template>
            </el-table-column>
            <el-table-column label="房间容量" align="left" min-width="110">
                <template slot-scope="scope">
                    <div>{{scope.row.capacityLabel |
                        selectedFilter(capacityLabelsEntries)}}：共{{scope.row.capacityTotal}}位
                    </div>
                    <div>占地面积：共{{scope.row.area}}平方米</div>
                </template>
            </el-table-column>
            <el-table-column prop="roomState" label="当前房间状态" align="center" sortable="roomState" min-width="90">
                <template slot-scope="scope">
                    {{scope.row.roomState | selectedFilter(roomStatesEntries)}}
                    <%--<div>已预约</div>--%>
                    <%--<div>（使用中）</div>--%>
                </template>
            </el-table-column>
            <el-table-column prop="isShare" label="多团队共用" align="center" sortable="isShare" min-width="80">
                <template slot-scope="scope">
                    <span>{{scope.row.isShare | selectedFilter(yesOrNoEntries)}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="enterNum" label="当前入驻团队数量" align="center" sortable="enterNum" min-width="100">
            </el-table-column>
            <el-table-column label="所属场地" align="center" min-width="100">
                <template slot-scope="scope">
                    {{scope.row.place}}</span>
                </template>
            </el-table-column>
            <el-table-column label="操作" align="center" min-width="80">
                <template slot-scope="scope">
                    <div class="table-btns-action">
                        <a href="#">查看预约详情</a>
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


<script>
    new Vue({
        el: '#app',
        data: function () {
            var yesOrNo = JSON.parse('${fns:toJson(fns:getDictList('yes_no'))}');
            return {
                yesOrNo: yesOrNo,
                roomTypes: [
                    {
                        id: '111',
                        label: '实验区',
                        value: '1'
                    },
                    {
                        id: '222',
                        label: '创业区',
                        value: '2'
                    }
                ],
                roomAttributes: [
                    {
                        id: '111',
                        label: '定期租用',
                        value: '1'
                    },
                    {
                        id: '222',
                        label: '临时预约',
                        value: '2'
                    },
                    {
                        id: '333',
                        label: '其他',
                        value: '3'
                    }
                ],
                roomStates: [
                    {
                        id: '111',
                        label: '已分配(满员)(10间)',
                        value: '1'
                    },
                    {
                        id: '222',
                        label: '已分配(未满)(20间)',
                        value: '2'
                    },
                    {
                        id: '333',
                        label: '未分配(20间)',
                        value: '3'
                    }
                ],
                conditions: [
                    {
                        id: '111',
                        label: '工位数范围',
                        value: '1'
                    },
                    {
                        id: '222',
                        label: '容纳人数范围',
                        value: '2'
                    },
                    {
                        id: '333',
                        label: '占地面积',
                        value: '3'
                    }
                ],
                capacityLabels: [
                    {
                        id: '111',
                        label: '工位数',
                        value: '1'
                    },
                    {
                        id: '222',
                        label: '容纳人数',
                        value: '2'
                    }
                ],
                pageCount: 0,
                message: '${message}',
                searchListForm: {
                    pageSize: 10,
                    pageNo: 1,
                    orderBy: '',
                    orderByType: '',
                    'pwSpace.id': '',
                    roomType: '',
                    roomState: '',
                    condition: '',
                    numMin: '',
                    numMax: '',
                    queryStr: ''
                },
                loading: false,

                baseId: '',
                buildId: '',
                floorId: '',
                spaceList: [],

                pageList: [
                    {
                        id: '111',
                        roomName: '实验室001',
                        roomType: '1',
                        roomAttribute: '2',
                        capacityLabel: '2',
                        capacityTotal: '50',
                        capacityRemain: '30',
                        area: '500',
                        areaRemain: '20',
                        isShare: '1',
                        roomState: '1',
                        enterNum:'1',
                        place: '创业基地/南栋/1层'
                    },
                    {
                        id: '222',
                        roomName: '会议室001',
                        roomType: '2',
                        roomAttribute: '2',
                        capacityLabel: '1',
                        capacityTotal: '60',
                        capacityRemain: '2',
                        area: '350',
                        areaRemain: '50',
                        roomState: '2',
                        isShare: '0',
                        enterNum:'3',
                        place: '创业基地/南栋/2层'
                    },
                    {
                        id: '333',
                        roomName: '接待室1',
                        roomType: '1',
                        roomAttribute: '2',
                        capacityLabel: '2',
                        capacityTotal: '10',
                        capacityRemain: '2',
                        area: '100',
                        areaRemain: '30',
                        roomState: '2',
                        isShare: '1',
                        enterNum:'4',
                        place: '创业基地/南栋/3层'
                    }
                ]
            }
        },
        computed: {
            roomTypesEntries: function () {
                return this.getEntries(this.roomTypes);
            },
            roomAttributesEntries: function () {
                return this.getEntries(this.roomAttributes);
            },
            roomStatesEntries: function () {
                return this.getEntries(this.roomStates);
            },
            capacityLabelsEntries: function () {
                return this.getEntries(this.capacityLabels);
            },
            yesOrNoEntries: function () {
                return this.getEntries(this.yesOrNo);
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
                var self = this;

                if(this.searchListForm.numMin){
                    var flagMin = this.getReg(this.searchListForm.numMin);
                    if(!flagMin){
                        return false;
                    }
                }
                if(this.searchListForm.numMax){
                    var flagMax = this.getReg(this.searchListForm.numMax);
                    if(!flagMax){
                        return false;
                    }
                    if(this.searchListForm.numMax < this.searchListForm.numMin){
                        this.$message({
                            message: '最大值不能小于' + self.searchListForm.numMin + '，请修改后，再次查询！',
                            type: 'warning'
                        });
                        return false;
                    }
                }

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
            getReg:function (value) {
                var reg = /^[1-9][0-9]*$/;
                if (!reg.test(value)) {
                    this.$message({
                        message: '范围必须为正整数，请修改后，再次查询！',
                        type: 'warning'
                    });
                    return false;
                }
                return true;
            },
            handleChangeCondition: function () {
                if (this.searchListForm.numMin || this.searchListForm.numMax) {
                    this.getDataList();
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


            handleChangeBuild: function () {
                var buildId = this.buildId;
                if (!buildId) {
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