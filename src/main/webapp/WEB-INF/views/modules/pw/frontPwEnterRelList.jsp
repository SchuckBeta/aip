<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ page errorPage="/WEB-INF/views/error/formMiss.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>${fns:getConfig('frontTitle')}</title>
    <meta name="decorator" content="creative"/>
    <script src="/js/components/pwEnter/pwEnterList.js?version=${fns: getVevison()}"></script>
</head>
<body>
<div id="app" v-show="pageLoad" class="container page-container pdt-60" style="display: none">
    <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item><a href="${ctxFront}"><i class="iconfont icon-ai-home"></i>首页</a></el-breadcrumb-item>
        <el-breadcrumb-item>创业基地</el-breadcrumb-item>
        <el-breadcrumb-item>入驻查询</el-breadcrumb-item>
    </el-breadcrumb>
    <div class="mgb-20 text-right">
        <el-button type="primary" size="mini" @click.stop.prevent="goToPwEnterForm">新建入驻申请</el-button>
    </div>
    <pw-enter-column v-for="item in pwEnterList" :key="item.id">
        <div class="pec-header-bar" slot="header">
            <a class="go-to-detail" :href="'/f/pw/pwEnterRel/view?id='+item.id">查看详情</a>
            <span class="apply-user">申请人：{{item.applicant.name}}</span>
            <span>所属学院：{{item.applicant.officeName}}</span>
        </div>
        <div class="pw-enter-table-column">
            <el-table :data="item.data" size="mini" class="pw-enter-table">
                <el-table-column label="申请日期" align="center">
                    <template slot-scope="scope">
                        {{scope.row.createDate | formatDateFilter('YYYY-MM-DD')}}
                    </template>
                </el-table-column>
                <el-table-column label="入驻信息" align="center">
                    <template slot-scope="scope">
                        <el-tooltip :content="scope.row.name" popper-class="white" placement="right">
                            <span class="break-ellipsis">{{scope.row.label}}：{{scope.row.name}}</span>
                        </el-tooltip>
                    </template>
                </el-table-column>
                <el-table-column label=" 入驻房间" align="center">
                    <template slot-scope="scope">
                        {{scope.row.createDate}}
                    </template>
                </el-table-column>
                <el-table-column label=" 入驻期限" align="center">
                    <template slot-scope="scope">
                        {{scope.row.createDate}}
                    </template>
                </el-table-column>
                <el-table-column label=" 退孵日期" align="center">
                    <template slot-scope="scope">
                        {{scope.row.exitDate | formatDateFilter('YYYY-MM-DD')}}
                    </template>
                </el-table-column>
                <el-table-column label=" 续期次数" align="center">
                    <template slot-scope="scope">
                        {{scope.row.termNum}}
                    </template>
                </el-table-column>
                <el-table-column label=" 操作" align="left" width="102">
                    <template slot-scope="scope">
                        <div>
                            <el-button type="text" size="mini">成果提交</el-button>
                        </div>
                        <div>
                            <el-button type="text" size="mini">申请续期</el-button>
                        </div>
                        <div>
                            <el-button type="text" size="mini">申请退孵</el-button>
                        </div>
                        <div>
                            <el-button type="text" size="mini">申请团队变更</el-button>
                        </div>
                        <div>
                            <el-button type="text" size="mini">申请入驻项目</el-button>
                        </div>
                        <div>
                            <el-button type="text" size="mini">申请入驻企业</el-button>
                        </div>
                    </template>
                </el-table-column>
            </el-table>
        </div>
        <pw-record-line slot="footer" class="pec-footer"></pw-record-line>
    </pw-enter-column>
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

<script type="text/javascript">

    'use strict';

    new Vue({
        el: '#app',
        data: function () {
            return {
                searchListForm: {
                    pageNo: 1,
                    pageSize: 10
                },
                pageCount: 0,
                pwEnterList: [],
                pwEnterTypes: []
            }
        },
        computed: {
            pwEnterTypeEntries: function () {
                return this.getEntries(this.pwEnterTypes)
            },
        },
        methods: {

            goToPwEnterForm: function () {
              location.href = this.frontOrAdmin + '/pw/pwEnter/form';
            },

            getPwEnterTypes: function () {
                var self = this;
                this.$axios.get('/pw/pwEnter/getPwEnterTypes').then(function (response) {
                    var data = response.data;
                    self.pwEnterTypes = data || [];
                }).catch(function () {

                })
            },
            getPwEnterList: function () {
                var self = this;
                this.loading = true;
                this.$axios.get('/pw/pwEnter/ajaxList?'+ Object.toURLSearchParams(this.searchListForm)).then(function (response) {
                    var data = response.data;
                    if(data.status === 1){
                        var pageData = data.data || {};
                        var pwEnterList = pageData.list || [];
                        pwEnterList = pwEnterList.map(function (item) {
                            var label = self.pwEnterTypeEntries[item.type];
                            var name = item.eteam.team.name;
                            if(item.type === '2'){
                                name = item.ecompany.pwCompany.name;
                            }
                            item['data'] = [{
                                createDate: item.createDate,
                                startDate: item.startDate,
                                endDate: item.endDate,
                                exitDate: item.exitDate,
                                termNum: item.termNum,
                                rooms: item.erooms || [],
                                team: item.eteam || {},
                                name: name,
                                label: label
                            }]
                            return item;
                        });
                        self.pwEnterList = pwEnterList;
                        self.searchListForm.pageNo = pageData.pageNo || 1;
                        self.searchListForm.pageSize = pageData.pageSize || 10;
                        self.pageCount = pageData.count;
                    }else {
                        self.$message.error(data.msg)
                    }
                    self.loading = true;
                }).catch(function (error) {
                    self.$message.error(self.xhrErrorMsg);
                    self.loading = true;
                })
            },
            handlePSizeChange: function (value) {
                this.searchListForm.pageSize = value;
                this.getPwEnterList();
            },

            handlePCPChange: function () {
                this.getPwEnterList();
            }
        },
        created: function () {
            this.getPwEnterTypes();
            this.getPwEnterList();
        }
    })

</script>
</body>
</html>
