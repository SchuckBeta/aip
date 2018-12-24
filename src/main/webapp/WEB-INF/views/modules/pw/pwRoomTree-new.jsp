<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>
</head>
<body>
<div id="app" v-show="pageLoad" style="display: none" class="container-fluid">
    <edit-bar></edit-bar>
    <el-form ref="searchListForm" method="post" size="mini" :inline="true">
        <input name="pageNo" type="hidden" v-model.number="searchListForm.pageNo"/>
        <input name="pageSize" type="hidden" v-model.number="searchListForm.pageSize"/>
        <input name="pwSpace.id" type="hidden" v-model="searchListForm['pwSpace.id']">
        <div class="conditions">

            <e-condition label="基地" type="radio" :options="baseList" v-model="baseId" @change="handleChangeBase"
                         :default-props="{label: 'name', value: 'id'}"></e-condition>

            <e-condition label="楼栋">
                <e-radio class="e-checkbox-all" name="build" v-model="buildId" label="" @change="handleChangeBuild">不限</e-radio>
                <e-radio-group class="e-radio-spaces" v-model="buildId" @change="handleChangeBuild">
                    <e-radio v-for="build in buildList" name="buildId" :class="{'is-siblings': build.isSiblings}"
                             :label="build.id" :key="build.id">{{build.name}}
                    </e-radio>
                </e-radio-group>
            </e-condition>

            <%--<e-condition label="楼栋" type="radio" :options="buildList" v-model="buildId"--%>
            <%--:default-props="{label: 'name', value: 'id'}"></e-condition>--%>
            <e-condition label="楼层" type="radio" :options="floorList" v-model="floorId" @change="handleChangeFloor"
                         :default-props="{label: 'name', value: 'id'}"></e-condition>
        </div>
        <div class="search-block_bar clearfix">
            <div class="search-btns">
                <el-button type="primary" :disabled="!floorId" size="mini" @click.stop.prevent="createRoom"><i
                        class="iconfont icon-daochu"></i>创建房间
                </el-button>
            </div>
        </div>
    </el-form>
    <div class="table-container" v-loading="loading">
        <el-table size="mini" :data="roomList" class="table" @sort-change="handleSortChange">
            <el-table-column align="center" label="房间">
                <template slot-scope="scope">
                    <div>{{scope.row.name}}</div>
                    <el-tag size="mini" type="info">{{scope.row.type | selectedFilter(pwRoomTypeEntries)}}</el-tag>
                </template>
            </el-table-column>
            <el-table-column align="center" prop="num" label="容纳人数（人）">
                <template slot-scope="scope">
                    {{scope.row.num}}
                </template>
            </el-table-column>
            <el-table-column align="center" prop="isUsable" label="是否可预约">
                <template slot-scope="scope">
                    <el-tooltip :disabled="scope.row.isUsable == 1" content="预约和分配不能同时开启" placement="bottom">
                        <el-switch
                                size="mini"
                                :ref="scope.row.id + 'isUsable'"
                                :disabled="scope.row.isAssign == 1"
                                v-model="scope.row.isUsable"
                                @change="handleIsUsableChange(scope.row)"
                                active-text="是"
                                inactive-text="否"
                                active-value="1"
                                inactive-value="0">
                        </el-switch>
                    </el-tooltip>
                </template>
            </el-table-column>
            <el-table-column align="center" prop="isAssign" label="是否分配">
                <template slot-scope="scope">
                    <el-tooltip :disabled="scope.row.isAssign == 1" content="预约和分配不能同时开启" placement="bottom">
                        <el-switch
                                size="mini"
                                :ref="scope.row.id + 'isAssign'"
                                :disabled="scope.row.isUsable == 1"
                                v-model="scope.row.isAssign"
                                @change="handleIsAssignChange(scope.row)"
                                active-text="是"
                                inactive-text="否"
                                active-value="1"
                                inactive-value="0">
                        </el-switch>
                    </el-tooltip>
                </template>
            </el-table-column>
            <el-table-column label="地址">
                <template slot-scope="scope">
                    {{scope.row.pwSpace | filterPwRoomAddress(pwSpaceListEntries)}}
                </template>
            </el-table-column>
            <el-table-column align="center" prop="isAllowm" label="是否允许多团队入驻">
                <template slot-scope="scope">
                    {{scope.row.isAllowm | selectedFilter(isAllowmListEntries)}}
                </template>
            </el-table-column>
            <el-table-column align="center" label="操作">
                <template slot-scope="scope">
                    <a :href="frontOrAdmin+'/pw/pwRoom/formSetZC?id='+scope.row.id">分配</a>
                    <a :href="frontOrAdmin+'/pw/pwRoom/form?id='+scope.row.id">修改</a>
                    <el-button type="text" size="mini" @click.stop.prevent="handleDeleteRoom(scope.row)"
                               :disabled="scope.row.isAssign == 1 || scope.row.isUsable == 1">删除
                    </el-button>
                </template>
            </el-table-column>
        </el-table>
        <div class="text-right mgb-20">
            <el-pagination
                    size="small"
                    @size-change="handlePaginationSizeChange"
                    background
                    @current-change="handlePaginationPageChange"
                    :current-page.sync="searchListForm.pageNo"
                    :page-sizes="[5,10,20,50,100]"
                    :page-size="searchListForm.pageSize"
                    layout="prev, pager, next, sizes"
                    :total="total">
            </el-pagination>
        </div>
    </div>
</div>


<script>

    'use strict';

    new Vue({
        el: '#app',
        data: function () {
            var pwSpaceId = '${pwRoom.pwSpace.id}';
            var isAllowmList = JSON.parse('${fns: toJson(fns:getDictList('yes_no'))}');
            var pwRoomTypes = JSON.parse('${fns: toJson(fns: getDictList('pw_room_type'))}')
            return {
                searchListForm: {
                    pageNo: 1,
                    pageSize: 10,
                    orderBy: '',
                    orderByType: '',
                    'pwSpace.id': pwSpaceId
                },
                total: 0,
                isAllowmList: isAllowmList,
                pwRoomTypes: pwRoomTypes,
                baseId: '',
                buildId: '',
                floorId: '',
                roomList: [],
                spaceList: [],
                loading: true
            }
        },


        computed: {
            pwRoomTypeEntries: function () {
                return this.getEntries(this.pwRoomTypes)
            },
            pwSpaceListEntries: function () {
                var entries = {};
                this.spaceList.forEach(function (item) {
                    entries[item.id] = item;
                });
                return entries;
            },

            isAllowmListEntries: function () {
                return this.getEntries(this.isAllowmList)
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

            createRoom: function () {
                return location.href = this.frontOrAdmin + '/pw/pwRoom/form?pwSpace.id=' + this.searchListForm['pwSpace.id']
            },

            handleIsUsableChange: function (row) {
                var ref = this.$refs[row.id + 'isUsable'];
                var self = this;
                this.$nextTick(function () {
                    var value = ref.value;
                    this.$axios({
                        method: 'GET',
                        url: '/pw/pwRoom/ajaxIsUsable',
                        params: {
                            id: row.id,
                            isUsable: value
                        }
                    }).then(function (response) {
                        var data = response.data;
                        if (!data.status) {
                            ref.$emit('input', value == '1' ? '0' : '1');
                        }
                        self.show$message(data);
                    }).catch(function (error) {
                        self.show$message(error.response.data);
                    })
                });
            },

            handleIsAssignChange: function (row) {
                var ref = this.$refs[row.id + 'isAssign'];
                var self = this;
                this.$nextTick(function () {
                    var value = ref.value;
                    this.$axios({
                        method: 'GET',
                        url: '/pw/pwRoom/ajaxIsAssign',
                        params: {
                            id: row.id,
                            isAssign: value
                        }
                    }).then(function (response) {
                        var data = response.data;
                        if (!data.status) {
                            ref.$emit('input', value == '1' ? '0' : '1');
                        }
                        self.show$message(data);
                    }).catch(function (error) {
                        self.show$message(error.response.data);
                    })
                });
            },

            handlePaginationSizeChange: function (pageSize) {
                this.searchListForm.pageSize = pageSize;
                this.getRoomList();
            },
            handlePaginationPageChange: function (curPage) {
                this.searchListForm.pageNo = curPage;
                this.getRoomList();
            },

            handleSortChange: function (row) {
                this.searchListForm.orderBy = row.prop;
                this.searchListForm.orderByType = row.order;
                this.getRoomList();
            },

            handleChangeBuild: function () {
                var buildId = this.buildId;
                if(!buildId){
//                    this.baseId = '';
                    this.floorId = '';
                    this.searchListForm['pwSpace.id'] = this.baseId;
                    this.getRoomList();
                    return false;
                }
                var build = this.buildList.filter(function (item) {
                    return item.id === buildId;
                });
                this.baseId = build[0].pId;
                this.floorId = '';
                this.searchListForm['pwSpace.id'] = buildId;
                this.getRoomList();
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
                this.getRoomList();
            },

            handleChangeFloor: function () {
                this.searchListForm['pwSpace.id'] = this.floorId;
                this.getRoomList();
            },

            handleDeleteRoom: function (row) {
                var self = this;
                this.$confirm('是否删除'+row.name+'房间？', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.$axios.get('/pw/pwRoom/deleteRoom?id=' + row.id).then(function (response) {
                        var data = response.data;
                        if (data.status) {
                            self.getRoomList();
                        }
                        self.show$message(data);
                    }).catch(function (error) {
                        self.show$message(error.response.data);
                    })
                })

            },

            getRoomList: function () {
                var self = this;
                this.$axios({
                    method: 'GET',
                    url: '/pw/pwRoom/getRoomList',
                    params: this.searchListForm
                }).then(function (response) {
                    var data = response.data;
                    if (data.status) {
                        data = data.datas;
                        self.setRoomList(data)
                    } else {
                        self.emptyRoomList();
                    }
                    self.loading = false;
                }).catch(function (error) {
                    self.emptyRoomList();
                    self.loading = false;
                })
            },

            setRoomList: function (data) {
                this.roomList = data.page.list;
                this.searchListForm.pageNo = data.page.pageNo;
                this.searchListForm.pageSize = data.page.pageSize;
                this.total = data.page.count;
            },

            emptyRoomList: function () {
                this.searchListForm.pageNo = 1;
                this.total = 0;
                this.roomList = []
            },

            getSpaceList: function () {
                var self = this;
                return this.$axios.get('/pw/pwSpace/treeData').then(function (response) {
                    self.spaceList = response.data;
                })
            }
        },
        beforeMount: function () {
            this.getSpaceList();
            this.getRoomList();
        },
        created: function () {

        }
    })

</script>

</body>
</html>