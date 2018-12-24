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

<div id="app" v-show="pageLoad" class="container-fluid" style="display: none">
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

        <div class="conditions">
            <e-condition type="checkbox" v-model="searchListForm['deuser.office.id']" label="学院"
                         :options="collegeList"
                         :default-props="{label: 'name', value: 'id'}" @change="searchCondition"
                         name="deuser.office.id"></e-condition>
            <e-condition type="checkbox" v-model="searchListForm.proCategory" label="项目类别"
                         :options="proCategories"
                         name="proCategory" @change="searchCondition"></e-condition>
        </div>

        <div class="search-block_bar clearfix">
            <div class="search-btns">

                <button-import v-if="isAdmin != null && isAdmin =='1'" :is-first-menu="true" href="/impdata/promodellist?"
                               :actyw-id="searchListForm.actywId"
                               :gnode-id="searchListForm.gnodeId" :is-query-menu="true"></button-import>

                <button-export v-if="isAdmin != null && isAdmin =='1'" :spilt-prefs="spiltPrefs" label="项目"
                               :spilt-posts="spiltPosts"
                               :search-list-form="searchListForm"></button-export>

                <el-button v-if="isAdmin != null && isAdmin =='1'" size="mini" type="primary"
                           @click.stop.prevent="goToCertAssign"
                           :disabled="projectListMultipleSelection.length < 1"><i
                        class="iconfont icon-guanlizhengshu"></i>证书下发
                </el-button>


                <el-button v-if="isAdmin != null && isAdmin =='1'" size="mini" type="primary"
                           @click.stop.prevent="publishExPro(multipleSelectedId.join(','))"
                           :disabled="projectListMultipleSelection.length < 1"><i
                        class="iconfont icon-icon-project"></i>发布优秀项目
                </el-button>

                <el-button v-if="isAdmin != null && isAdmin =='1'" size="mini" type="primary"
                           @click.stop.prevent="deleteProject(multipleSelectedId.join(','))"
                           :disabled="projectListMultipleSelection.length < 1"><i class="iconfont icon-delete"></i>批量删除
                </el-button>


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
                            <a :href="frontOrAdmin + '/promodel/proModel/viewForm?id=' + scope.row.id"
                               class="black-a project-name-tooltip">{{scope.row.pName || '-'}}</a>
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
            <el-table-column label="成员信息" align="left" min-width="150">
                <template slot-scope="scope">
                    <p>负责人：{{scope.row.deuser.name || '-'}}</p>
                    <p class="over-flow-tooltip">成员：
                        <el-tooltip class="item" effect="dark" popper-class="white" :content="scope.row.team.entName" placement="bottom">
                            <span class="team-member-tooltip">{{scope.row.team.entName || '-'}}</span></el-tooltip>
                    </p>
                    <p class="over-flow-tooltip">导师：
                        <el-tooltip class="item" effect="dark" popper-class="white" :content="scope.row.team.uName" placement="bottom"><span
                                class="team-member-tooltip">{{scope.row.team.uName || '-'}}</span></el-tooltip>
                    </p>
                </template>
            </el-table-column>
            <el-table-column label="项目类别" align="center" min-width="100">
                <template slot-scope="scope">
                    {{scope.row.proCategory | selectedFilter(proCategoryEntries)}}
                </template>
            </el-table-column>
            <el-table-column label="申报日期" align="center" prop="subTime" min-width="110" sortable="subTime">
                <template slot-scope="scope">
                    {{scope.row.subTime | formatDateFilter('YYYY-MM-DD')}}
                </template>
            </el-table-column>
            <el-table-column label="证书" align="center" min-width="85">
                <template slot-scope="scope">
                    <p v-for="item in scope.row.scis" class="over-flow-tooltip">
                        <el-tooltip class="item" effect="dark" popper-class="white" :content="item.name" placement="bottom">
                            <span class="task-cert-preview"
                                  @click.stop.prevent="taskCertPreview(item.id)">{{item.name || '-'}}</span>
                        </el-tooltip>
                    </p>
                </template>
            </el-table-column>
            <el-table-column label="审核结果" align="center" prop="finalResult" min-width="110" sortable="finalResult">
                <template slot-scope="scope">
                    {{scope.row.finalResult || '-'}}
                </template>
            </el-table-column>
            <el-table-column label="审核状态" align="center" min-width="110">
                <template slot-scope="scope">
                    <template v-if="scope.row.state == '1'">
                        <a class="black-a"
                           :href="frontOrAdmin +'/actyw/actYwGnode/designView?groupId='+scope.row.actYw.groupId+'&proInsId='+scope.row.procInsId"
                           target="_blank">项目已结项</a>
                    </template>
                    <template v-else>
                        <a class="black-a"
                           :href="frontOrAdmin +'/actyw/actYwGnode/designView?groupId='+scope.row.actYw.groupId+'&proInsId='+scope.row.procInsId"
                           target="_blank">{{scope.row.auditMap ? '待' + scope.row.auditMap.taskName : ''}}</a>
                    </template>
                </template>
            </el-table-column>

            <el-table-column label="操作" align="center" min-width="120">
                <template slot-scope="scope">
                    <shiro:hasPermission name="promodel:promodel:modify">
                        <div class="table-btns-action">
                            <el-button type="text" size="mini" @click.stop.prevent="goToProcessTrack(scope.row)">进度跟踪
                            </el-button>
                            <el-button type="text" size="mini" style="margin-left: 0"
                                       @click.stop.prevent="goToChangeCharge(scope.row)">变更
                            </el-button>
                        </div>
                    </shiro:hasPermission>
                    <div class="table-btns-action">
                        <button-audit-record :row="scope.row"></button-audit-record>
                        <shiro:hasPermission name="promodel:promodel:modify">
                            <el-button type="text" size="mini" @click.stop.prevent="deleteProject(scope.row.id)">删除
                            </el-button>
                        </shiro:hasPermission>
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

    <el-dialog title="证书预览" :visible.sync="dialogCertVisible" width="60%">
        <el-carousel indicator-position="outside" ref="elCarousel" height="400px">
            <el-carousel-item v-for="item in previewCertImgSrc" :key="item.id">
                <div class="preview-cert-content">
                    <img :src="item.imgUrl" alt="证书" v-auto-img="bannerScale">
                </div>
            </el-carousel-item>
        </el-carousel>
    </el-dialog>

</div>

<script>

    'use strict';


    Vue.directive('auto-img',{
        componentUpdated: function (element, binding) {
            var ratio = binding.value;
            element.onload =  function () {
                var imgScale = element.naturalWidth/element.naturalHeight;
                element.style.width = imgScale > ratio ? '100%' : 'auto';
                element.style.height =imgScale >= ratio ? 'auto' : '100%'
            }
        },
        unbind: function (element) {
            element.onload = null;
        }
    })


    new Vue({
        el: '#app',
        mixins: [Vue.collegesMixin],
        data: function () {
            var proCategories = JSON.parse('${fns: toJson(fns:getDictList("project_type"))}');
            var projectDegrees = JSON.parse('${fns: toJson(fns:getDictList(levelDict))}');
            var professionals = JSON.parse('${fns: getOfficeListJson()}') || [];
            var spiltPrefs = JSON.parse('${fns:spiltPrefs()}');
            var spiltPosts = JSON.parse('${fns:spiltPosts()}');
            var pageList = ${fns: toJson(page.list)};
            var pageCount = JSON.parse('${fns: toJson(page.count)}') || 0;
            return {
                proCategories: proCategories,
                adviceLevel: projectDegrees,
                colleges: professionals,
                spiltPrefs: spiltPrefs,
                spiltPosts: spiltPosts,
                projectList: pageList,
                projectListMultipleSelection: [],
                pageCount: pageCount,
                searchListForm: {
                    pageNo: 1,
                    pageSize: 10,
                    orderBy: '',
                    orderByType: '',
                    actywId: '${actywId}',
                    gnodeId: '${gnodeId}',
                    beginDate: '',
                    endDate: '',
                    queryStr: '',
                    proCategory: [],
                    'deuser.office.id': []
                },
                loading: false,
                applyDate: [],
                multipleSelectedId: [],
                isAdmin: '${isAdmin}',
                dialogCertVisible:false,
                previewCertImgSrc:[],
                bannerScale: 1
            }
        },
        computed: {

            officeList: {
                get: function () {
                    return this.getFlattenColleges();
                }
            },

            projectLevelEntries: {
                get: function () {
                    return this.getEntries(this.adviceLevel)
                }
            },

            collegeList: {
                get: function () {
                    return this.officeList.filter(function (item) {
                        return item.grade === '2';
                    });
                }
            },
            listLen: {
                get: function () {
                    return this.projectListMultipleSelection.length;
                }
            },
            proCategoryEntries: {
                get: function () {
                    return this.getEntries(this.proCategories)
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
                this.getQueryMenuList();
            },

            goToProcessTrack: function (row) {
                location.href = this.frontOrAdmin + '/promodel/proModel/process?id=' + row.id
            },

            goToChangeCharge: function (row) {
                location.href = this.frontOrAdmin + '/promodel/proModel/projectEdit?id=' + row.id + '&secondName=变更'
            },

            goToCertAssign: function () {
                location.href = this.frontOrAdmin + '/certMake/list?actywId=' + this.searchListForm.actywId;
            },

            taskCertPreview:function(id){
                var self = this;
                this.previewCertImgSrc = [];
                this.$axios({
                    method:'POST',
                    url:'/cert/getCertIns?certinsid=' + id
                }).then(function(response){
                    self.previewCertImgSrc = response.data;
                    self.certImgCenter();
                    self.dialogCertVisible = true;
                }).catch(function(){

                })

            },

            certImgCenter:function(){
                var self = this;
                var bannerWidth = 0;
                var bannerHeight = 400;
                self.$nextTick(function () {
                    bannerWidth = self.$refs.elCarousel.$el.offsetWidth;
                    self.bannerScale = bannerWidth / bannerHeight;
                });
            },


            publishExPro: function (ids) {
                var self = this;
                this.$confirm('确定发布所选项目到门户网站？', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.$axios({
                        method: 'POST',
                        url: '/cms/cmsArticle/excellent/projectPublish?ids=' + ids
                    }).then(function (response) {
                        var data = response.data;
                        self.$message({
                            message: data.status == '1' ? '发布成功！' : '该项目已发布！',
                            type: data.status == '1' ? 'success' : 'warning'
                        })
                    }).catch(function () {
                        self.$message({
                            message: '请求失败！',
                            type: 'error'
                        })
                    })
                })
            },

            deleteProject: function (ids) {
                var self = this;
                this.$confirm('此操作将永久删除文件, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.$axios({
                        method: 'POST',
                        url: '/promodel/proModel/ajaxPromodelDelete?ids=' + ids
                    }).then(function (response) {
                        var data = response.data;
                        if (data.ret == '1') {
                            self.searchCondition();
                            self.$message({
                                message: '删除成功',
                                type: 'success'
                            });
                        }
                    }).catch(function () {
                        self.$message({
                            message: '请求失败！',
                            type: 'error'
                        })
                    })
                })
            },

            getQueryMenuList: function () {
                var self = this;
                this.loading = true;
                this.$axios({
                    method: 'GET',
                    url: '/cms/ajax/ajaxQueryMenuList?' + Object.toURLSearchParams(this.searchListForm)
                }).then(function (response) {
                    var page = response.data.page;
                    self.pageCount = page.count;
                    self.searchListForm.pageSize = page.pageSize;
                    self.projectList = page.list || [];
                    self.loading = false;
                }).catch(function (error) {
                    self.loading = false;
                })
            }

        },
        created: function () {

        }
    })

</script>
</body>
</html>