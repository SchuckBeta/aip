<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ page errorPage="/WEB-INF/views/error/formMiss.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <meta charset="UTF-8">
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>

<body>

<style>
    .e-checkbox-inline_block{
        width:140px;
    }
</style>

<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60">
    <edit-bar></edit-bar>
    <el-form :model="searchListForm" size="mini" autocomplete="off" ref="searchListForm">
        <input type="hidden" name="pageNo" :value="searchListForm.pageNo"/>
        <input type="hidden" name="pageSize" :value="searchListForm.pageSize"/>
        <input type="hidden" name="orderBy" :value="searchListForm.orderBy"/>
        <input type="hidden" name="orderByType" :value="searchListForm.orderByType"/>
        <input type="hidden" name="beginDate" :value="searchListForm.beginDate"/>
        <input type="hidden" name="endDate" :value="searchListForm.endDate"/>
        <input type="hidden" name="actywId" :value="searchListForm.actywId"/>
        <input type="hidden" name="gnodeId" :value="searchListForm.gnodeId"/>

        <div class="conditions" style="position: relative;">
            <e-condition type="checkbox" v-model="searchListForm['deuser.office.id']" label="学院"
                         :options="collegeList"
                         :default-props="{label: 'name', value: 'id'}" @change="searchCondition"
                         name="deuser.office.id"></e-condition>
            <e-condition type="checkbox" v-model="searchListForm.proCategory" label="大赛类别"
                         :options="proCategories"
                         name="proCategory" @change="searchCondition"></e-condition>
        </div>
        <div class="search-block_bar clearfix">
            <div class="search-btns">

                <shiro:hasPermission name="sys:user:import">
                <button-import v-if="isAdmin != null && isAdmin =='1'" :is-first-menu="isFirstMenu" :actyw-id="searchListForm.actywId" href="/impdata/promodelgcontestlist?"
                               :gnode-id="searchListForm.gnodeId"></button-import>
                </shiro:hasPermission>

                <button-export :spilt-prefs="spiltPrefs" :spilt-posts="spiltPosts" label="大赛"
                               :search-list-form="searchListForm"></button-export>

                <button-export-file :menu-name="menuName" label="大赛" :search-list-form="searchListForm" @export-file-start="exportFileStart"></button-export-file>
            </div>
            <div class="search-input">
                <el-date-picker
                        v-model="applyDate"
                        type="daterange"
                        size="mini"
                        align="right"
                        @change="searchCondition"
                        unlink-panels
                        range-separator="至"
                        start-placeholder="开始日期"
                        end-placeholder="结束日期"
                        value-format="yyyy-MM-dd"
                        style="width: 270px;">
                </el-date-picker>
                <el-input
                        placeholder="项目名称/编号/负责人/组成员/导师"
                        size="mini"
                        name="queryStr"
                        v-model="searchListForm.queryStr"
                        style="width: 300px;">
                    <el-button slot="append" icon="el-icon-search"
                               @click.stop.prevent="searchCondition"></el-button>
                </el-input>
            </div>
        </div>
    </el-form>

    <div class="table-container" style="margin-bottom:40px;">
        <el-table size="mini" :data="projectList" class="table" ref="multipleTable" v-loading="loading"
                  @sort-change="handleTableSortChange"
                  @selection-change="handleTableSelectionChange">
            <el-table-column
                    type="selection"
                    width="55">
            </el-table-column>
            <el-table-column label="项目信息" align="left" prop="competitionNumber" width="240" sortable="competitionNumber">
                <template slot-scope="scope">
                    <span>{{scope.row.competitionNumber || '-'}}</span>
                    <p class="over-flow-tooltip">
                        <el-tooltip class="item" effect="dark" popper-class="white" :content="scope.row.pName" placement="bottom">
                          <a :href="frontOrAdmin + '/promodel/proModel/viewForm?id=' + scope.row.id" class="black-a project-name-tooltip">{{scope.row.pName || '-'}}</a>
                        </el-tooltip>
                    </p>
                    <p>
                        <i class="iconfont icon-dibiao2"></i>
                        <el-tooltip class="item" effect="dark" popper-class="white" :content="scope.row.officeName" placement="bottom">
                            <span class="over-flow-tooltip project-office-tooltip">{{scope.row.officeName || '-'}}</span>
                        </el-tooltip>
                    </p>
                </template>
            </el-table-column>
            <el-table-column label="成员信息" align="left" :min-width="isScore != null && isScore == '1'?155:170">
                <template slot-scope="scope">
                    <p>负责人：{{scope.row.deuser.name || '-'}}</p>
                    <p class="over-flow-tooltip">成员：<el-tooltip class="item" popper-class="white" effect="dark" :content="scope.row.team.entName" placement="bottom"><span class="team-member-tooltip">{{scope.row.team.entName || '-'}}</span></el-tooltip></p>
                    <p class="over-flow-tooltip">导师：<el-tooltip class="item" popper-class="white" effect="dark" :content="scope.row.team.uName" placement="bottom"><span class="team-member-tooltip">{{scope.row.team.uName || '-'}}</span></el-tooltip></p>
                </template>
            </el-table-column>
            <el-table-column label="大赛类别" align="center" min-width="85">
                <template slot-scope="scope">
                    <p class="over-flow-tooltip"><el-tooltip class="item" popper-class="white" effect="dark" :content="scope.row.proCategory | selectedFilter(proCategoryEntries)" placement="bottom"><span class="team-member-tooltip">{{scope.row.proCategory | selectedFilter(proCategoryEntries)}}</span></el-tooltip></p>
                </template>
            </el-table-column>
            <el-table-column label="大赛组别" align="center" min-width="85">
                <template slot-scope="scope">
                    <p class="over-flow-tooltip"><el-tooltip class="item" popper-class="white" effect="dark" :content="scope.row.level | selectedFilter(gContestLevelEntries)" placement="bottom"><span class="team-member-tooltip">{{scope.row.level | selectedFilter(gContestLevelEntries)}}</span></el-tooltip></p>
                </template>
            </el-table-column>
            <el-table-column label="申报日期" align="center" prop="subTime" min-width="110" sortable="subTime">
                <template slot-scope="scope">
                    {{scope.row.subTime | formatDateFilter('YYYY-MM-DD')}}
                </template>
            </el-table-column>

            <el-table-column label="审核结果" align="center" prop="finalResult" min-width="110" sortable="finalResult">
                <template slot-scope="scope">
                    {{scope.row.finalResult || '-'}}
                </template>
            </el-table-column>
            <el-table-column label="审核状态" align="center" min-width="110">
                <template slot-scope="scope">
                    <a class="black-a" :href="frontOrAdmin +'/actyw/actYwGnode/designView?groupId='+scope.row.actYw.groupId+'&proInsId='+scope.row.procInsId"
                       target="_blank">
                        <span v-if="scope.row.state == '1'">项目已结项</span>
                        <span v-else>{{scope.row.auditMap ? '待' + scope.row.auditMap.taskName : ''}}</span>
                    </a>
                </template>
            </el-table-column>
            <el-table-column label="操作" align="center" min-width="60">
                <template slot-scope="scope">
                    <el-button v-if="scope.row.state == '1'" type="text" size="small" disabled>审核</el-button>
                    <div v-else style="display: inline-block">
                        <a v-if="scope.row.auditMap.status == 'todo'"
                           :href="frontOrAdmin+'/act/task/auditform?gnodeId='+scope.row.auditMap.gnodeId+'&proModelId='+scope.row.auditMap.proModelId+'&pathUrl=${actionUrl}&taskName='+scope.row.auditMap.taskName">审核</a>
                        <el-button v-else type="text" size="small" disabled>审核</el-button>
                    </div>
                </template>
            </el-table-column>
        </el-table>
        <div class="text-right mgb-20" v-show="pageCount">
            <el-pagination
                    size="small"
                    @size-change="handlePaginationSizeChange"
                    background
                    @current-change="handlePaginationPageChange"
                    :current-page.sync="searchListForm.pageNo"
                    :page-sizes="[5,10,20,50,100]"
                    :page-size="searchListForm.pageSize"
                    layout="total,prev, pager, next, sizes"
                    :total="pageCount">
            </el-pagination>
        </div>
    </div>

    <export-file-process v-if="isAdmin != null && isAdmin =='1'" ref="exportFileProcess" :visible.sync="EFPVisible" :menu-name="menuName" :gnode-id="searchListForm.gnodeId"></export-file-process>
</div>


<script>

    'use strict';


    new Vue({
        el: '#app',
        mixins: [Vue.collegesMixin],
        data: function () {
            var proCategories = JSON.parse('${fns:toJson(fns: getDictList('competition_net_type'))}');
            var gContestLevel = JSON.parse('${fns: toJson(fns:getDictList('gcontest_level'))}');
            var professionals = JSON.parse('${fns: getOfficeListJson()}') || [];
            var pageList = ${fns: toJson(page.list)};
            var isFirstMenu = '${fns:isFirstMenu(actywId,gnodeId)}';
            var spiltPrefs = JSON.parse('${fns:spiltPrefs()}');
            var spiltPosts = JSON.parse('${fns:spiltPosts()}');


            return {
                proCategories: proCategories,
                gContestLevel: gContestLevel,
                colleges: professionals,
                offices: [],
                applyDate: [],
                projectList: pageList,
                isFirstMenu: isFirstMenu === 'true',
                messageInfo: '${message}',
                menuName: '${menuName}',
                isScore:'${isScore}',
                isGate:'${isGate}',
                isAdmin:'${isAdmin}',
                spiltPrefs: spiltPrefs,
                spiltPosts: spiltPosts,
                batchCheckIsPass: [
                    {label: '通过', value: '${actYwStatus.status}'}
                ],
                searchListForm: {
                    pageNo: 1,
                    pageSize: 10,
                    orderBy: '',
                    orderByType: '',
                    actywId: '${actywId}',
                    gnodeId: '${gnodeId}',
                    queryStr: '',
                    beginDate: '',
                    endDate: '',
                    proCategory: [],
                    'deuser.office.id': []
                },
                pageCount: 0,
                projectListMultipleSelection: [],
                loading: false,
                multipleSelectedId: [],
                schoolAutoShow:'${autoShow}',
                EFPVisible: true
            }
        },
        computed: {

            officeList: {
                get: function () {
                    return this.getFlattenColleges();
                }
            },

            collegeList: {
                get: function () {
                    return this.officeList.filter(function (item) {
                        return item.grade === '2';
                    });
                }
            },


            actionUrl: {
                get: function () {
                    return location.pathname.replace(this.frontOrAdmin, '');
                }
            },

            listLen: {
                get: function () {
                    return this.projectListMultipleSelection.length;
                }
            },
            proCategoryEntries:{
                get:function(){
                    return this.getEntries(this.proCategories)
                }
            },
            gContestLevelEntries:{
                get:function(){
                    return this.getEntries(this.gContestLevel)
                }
            }
        },
        watch: {
            applyDate: function (value) {
                value = value || [];
                this.searchListForm.beginDate = value[0];
                this.searchListForm.endDate = value[1];
                this.searchCondition();
            }
        },
        methods: {
            exportFileStart: function () {
                this.EFPVisible = true;
                //主动去调用
                this.$refs.exportFileProcess.getExpInfo();
            },
            handleTableSortChange: function (row) {
                this.searchListForm.orderBy = row.prop;
                this.searchListForm.orderByType = row.order ? ( row.order.indexOf('asc') ? 'asc' : 'desc') : '';
                this.searchCondition();
            },
            handleTableSelectionChange: function (val) {
                this.projectListMultipleSelection = val;
                this.multipleSelectedId = [];
                for (var i = 0; i < val.length; i++) {
                    this.multipleSelectedId.push(val[i].id);
                }
            },

            handlePaginationSizeChange: function (value) {
                this.searchListForm.pageSize = value;
                this.searchCondition();
            },
            handlePaginationPageChange: function (value) {
                this.searchListForm.pageNo = value;
                this.searchCondition();
            },

            searchCondition: function () {
                var self = this;
                this.loading = true;
                var listXhr = this.$axios({
                    method: 'POST',
                    url: '/cms/ajax/listForm' + "?" + Object.toURLSearchParams(this.searchListForm)
                });
                listXhr.then(function (response) {
                    var page = response.data.page;
                    self.pageCount = page.count;
                    self.searchListForm.pageSize = page.pageSize;
                    self.projectList = page.list || [];
                    self.loading = false;
                }).catch(function () {
                    self.loading = false;
                });
            }

        },
        created: function () {
            if (this.messageInfo) {
                this.$alert(this.messageInfo, '提示', {
                    confirmButtonText: '确定',
                    type: this.messageInfo.indexOf('成功') > -1 ? 'success' : 'fail'
                });
                this.messageInfo = '';
            }

            this.pageCount = JSON.parse('${fns: toJson(page.count)}') || 0;
            window.parent.sideNavModule.changeUnreadTag(this.searchListForm.actywId);
            window.parent.sideNavModule.changeStaticUnreadTag("/a/promodel/proModel/getTaskAssignCountToDo?actYwId=" + this.searchListForm.actywId);

        }
    })


</script>

</body>
</html>