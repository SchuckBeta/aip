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

<div id="app" v-show="pageLoad" class="container-fluid mgb-60 user-share" style="display: none">
    <edit-bar></edit-bar>
    <el-form :model="searchListForm" size="mini" autocomplete="off" ref="searchListForm">
        <input type="hidden" name="pageNo" :value="searchListForm.pageNo"/>
        <input type="hidden" name="pageSize" :value="searchListForm.pageSize"/>
        <input type="hidden" name="orderBy" :value="searchListForm.orderBy"/>
        <input type="hidden" name="orderByType" :value="searchListForm.orderByType"/>

        <div class="conditions">
            <e-condition label="所属学院" type="radio" v-model="searchListForm['office.id']" :default-props="defaultProps"
                         name="office.id" :options="collegeList" @change="getDataList">
            </e-condition>
            <%--<e-condition label="导师来源" type="radio" v-model="searchListForm.teacherType"--%>
            <%--name="teacherType" :options="originList" @change="getDataList">--%>
            <%--</e-condition>--%>
            <%--<e-condition label="评审任务" type="radio" v-model="searchListForm.reviewTask"--%>
            <%--name="reviewTask" :options="reviewTaskList" @change="getDataList">--%>
            <%--</e-condition>--%>
        </div>

        <div class="search-block_bar clearfix">
            <div class="search-btns">

                <%--<el-button size="mini" type="primary" :disabled="multipleSelectedId.length == 0" @click.stop.prevent="assignExpTask">分配专家任务--%>
                <%--</el-button>--%>
                <el-button size="mini" type="primary" @click.stop.prevent="createUser">
                    <i class="el-icon-circle-plus el-icon--left"></i>创建专家
                </el-button>
                <el-button size="mini" type="primary" :disabled="multipleSelectedId.length == 0"
                           @click.stop.prevent="batchDelete"><i class="iconfont icon-delete"></i>批量删除
                </el-button>
                <%--<el-button size="mini" type="primary" @click.stop.prevent="add"><i class="el-icon-circle-plus"></i>添加--%>
                <%--</el-button>--%>

            </div>
            <div class="search-input">
                <input type="text" style="display: none">
                <el-input
                        placeholder="专家姓名/工号"
                        size="mini"
                        name="queryStr"
                        v-model="searchListForm.queryStr"
                        @keyup.enter.native="getDataList"
                        class="w300">
                    <el-button slot="append" icon="el-icon-search"
                               @click.stop.prevent="getDataList"></el-button>
                </el-input>
            </div>
        </div>
    </el-form>
    <div class="table-container" style="margin-bottom:40px;">
        <el-table size="mini" :data="pageList" class="table" v-loading="loading"
                  @sort-change="handleTableSortChange" @selection-change="handleSelectionChange">
            <el-table-column
                    type="selection"
                    width="60">
            </el-table-column>
            <el-table-column prop="no" label="专家信息" align="left" width="320" sortable="no">
                <template slot-scope="scope">
                    <div class="user-element">
                        <div class="user-img">
                            <img :src="scope.row.photo | ftpHttpFilter(ftpHttp) | studentPicFilter" alt="">
                        </div>
                        <div class="user-detail">
                            <div class="user-name">
                                <img src="/images/user-name.png" alt="">
                                {{scope.row.name || '-'}}
                            </div>
                            <div class="user-tag">
                                <img src="/images/user-no.png" alt="">
                                {{scope.row.no || '-'}}
                            </div>
                            <div class="user-phone">
                                <img src="/images/user-phone.png" alt="">
                                {{scope.row.mobile || '-'}}
                            </div>
                        </div>
                    </div>
                </template>
            </el-table-column>
            <el-table-column label="专家角色" align="center" min-width="100">
                <template slot-scope="scope">
                    <el-tooltip :content="scope.row.roleNames" popper-class="white" placement="right">
                        <span class="break-ellipsis">{{scope.row.roleNames}}</span>
                    </el-tooltip>
                </template>
            </el-table-column>
            <el-table-column label="登录名" align="center" min-width="200">
                <template slot-scope="scope">
                    {{scope.row.loginName || '-'}}
                </template>
            </el-table-column>
            <%--<el-table-column label="专家来源" align="center">--%>
            <%--<template slot-scope="scope">--%>
            <%--{{scope.row.teacherType | selectedFilter(teacherTypeEntries)}}--%>
            <%--</template>--%>
            <%--</el-table-column>--%>
            <el-table-column prop="officeName" label="学院/专业" align="center" min-width="90">
                <template slot-scope="scope">
                    <el-tooltip :content="scope.row.officeId | collegeFilter(collegeEntries)" popper-class="white"
                                placement="right">
                        <span class="break-ellipsis">{{scope.row.officeId | collegeFilter(collegeEntries)}}</span>
                    </el-tooltip>
                    <br>
                    <el-tooltip :content="scope.row.professional | collegeFilter(collegeEntries)" popper-class="white"
                                placement="right"
                                v-if="scope.row.officeId && scope.row.professional && scope.row.professional != scope.row.officeId">
                        <span class="break-ellipsis">{{scope.row.professional | collegeFilter(collegeEntries)}}</span>
                    </el-tooltip>
                </template>
            </el-table-column>
            <el-table-column label="技术领域" align="center" min-width="90">
                <template slot-scope="scope">
                    <el-tooltip :content="scope.row.domainlt" popper-class="white" placement="right">
                        <span class="break-ellipsis">{{scope.row.domainlt}}</span>
                    </el-tooltip>
                </template>
            </el-table-column>
            <%--<el-table-column label="当前评审任务" align="center">--%>
            <%--<template slot-scope="scope">--%>
            <%--{{scope.row.none}}--%>
            <%--</template>--%>
            <%--</el-table-column>--%>
            <%--<el-table-column label="职称" align="center">--%>
            <%--<template slot-scope="scope">--%>
            <%--{{scope.row.technicalTitle}}--%>
            <%--</template>--%>
            <%--</el-table-column>--%>
            <%--<shiro:hasPermission name="sys:expert:edit">--%>
                <el-table-column label="操作" align="center" min-width="150">
                    <template slot-scope="scope">
                        <div class="table-btns-action">
                                <%--<el-button type="text" size="mini" @click.stop.prevent="edit(scope.row.id)">编辑--%>
                                <%--</el-button>--%>
                            <el-button size="mini" type="text"
                                       @click.stop.prevent="resetPwd(scope.row.id)">重置密码
                            </el-button>
                            <el-button size="mini" type="text"
                                       @click.stop.prevent="amendUser(scope.row)">修改
                            </el-button>
                            <el-button type="text" size="mini" @click.stop.prevent="singleDelete(scope.row.id)">删除
                            </el-button>
                        </div>
                    </template>
                </el-table-column>
            <%--</shiro:hasPermission>--%>
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

    <el-dialog :title="dialogAction + '专家'" top="5vh" :visible.sync="dialogCreateVisible" :before-close="handleClose"
               :close-on-click-modal="isClose"
               class="dialog-form-condition" width="60%">

        <el-form ref="createUserForm" :model="createUserForm" label-width="120px" :disabled="updating"
                 method="post" size="mini" class="demo-ruleForm" :rules="rules">
            <div class="gray-box">
                <p class="gray-box-title"><span>必填信息</span> <span v-if="createUserForm.id">创建时间：{{createUserForm.createDate}}</span>
                </p>
                <div class="gray-box-content">
                    <el-form-item label="登录名" prop="loginName" style="width:50%;">
                        <input id="oldLoginName" name="oldLoginName" type="hidden" value="${user.loginName}">
                        <el-input id="loginName" name="loginName" v-model="createUserForm.loginName"
                                  auto-complete="off"></el-input>
                    </el-form-item>
                    <el-form-item label="姓名" prop="name" style="width:50%;">
                        <el-input id="name" name="name" v-model="createUserForm.name"
                                  auto-complete="off"></el-input>
                    </el-form-item>
                    <el-form-item label="学号/工号" prop="no" style="width:50%;">
                        <el-input id="no" name="no"
                                  v-model="createUserForm.no" auto-complete="off"></el-input>
                    </el-form-item>
                    <el-form-item label="专家角色" prop="roleIdList">
                        <el-checkbox-group v-model="roles" id="roleIdList" name="roleIdList" @change="checkRoles">
                            <el-checkbox v-for="role in cpRoleList" :label="role.id" :key="role.id">{{role.name}}
                            </el-checkbox>
                        </el-checkbox-group>
                    </el-form-item>
                    <el-form-item label="导师来源" prop="teacherType" v-if="teacherTypeShow">
                        <el-radio-group v-model="createUserForm.teacherType" id="teacherType" name="teacherType"
                                        style="margin-top:2px;">
                            <el-radio v-for="type in teacherTypes" :label="type.value" :key="type.id">{{type.label}}
                            </el-radio>
                        </el-radio-group>
                    </el-form-item>
                    <el-form-item label="所属机构" prop="officeId">
                        <el-cascader name="officeId" :options="collegesTree" :clearable="true"
                                     style="width: 60%" filterable placeholder="请选择所属机构（可搜索）"
                                     :props="cascaderProps"
                                     change-on-select
                                     @change="handleOffice"
                                     v-model="cascaderList">
                        </el-cascader>
                    </el-form-item>
                </div>
            </div>
            <div class="gray-box">
                <p>选填信息</p>
                <div class="gray-box-content">
                    <el-form-item label="擅长技术领域" prop="domainIdList">
                        <el-checkbox-group v-model="createUserForm.domainIdList" id="domainIdList" name="domainIdList">
                            <el-checkbox v-for="item in allDomains" :label="item.value" :key="item.id">{{item.label}}
                            </el-checkbox>
                        </el-checkbox-group>
                    </el-form-item>
                    <el-form-item label="手机号" prop="mobile" style="width:50%;">
                        <el-input id="mobile" name="mobile"
                                  v-model="createUserForm.mobile" auto-complete="off"></el-input>
                    </el-form-item>
                    <el-form-item label="电子邮箱" prop="email" style="width:50%;">
                        <el-input id="email" name="email"
                                  v-model="createUserForm.email" auto-complete="off"></el-input>
                    </el-form-item>
                </div>
            </div>
        </el-form>


        <div slot="footer" class="dialog-footer" style="text-align: center">
            <el-button size="mini" @click.stop.prevent="handleClose">取 消</el-button>
            <%--<shiro:hasPermission name="sys:expert:edit">--%>
                <el-button size="mini" type="primary" :disabled="updating"
                           @click.stop.prevent="submitCreateUser('createUserForm')">保 存
                </el-button>
            <%--</shiro:hasPermission>--%>
        </div>

    </el-dialog>


</div>

<script>

    'use strict';

    new Vue({
        el: '#app',
        mixins: [Vue.collegesMixin, Vue.userManageMixin],
        data: function () {
            var colleges = JSON.parse(JSON.stringify(${fns:getOfficeListJson()})) || [];
            var projectStyles = JSON.parse(JSON.stringify(${fns: toJson(fns: getDictList("project_style"))})) || [];
            var competitionTypes = JSON.parse(JSON.stringify(${fns: toJson(fns: getDictList("competition_type"))})) || [];
            var teacherTypes = JSON.parse(JSON.stringify(${fns: getDictListJson('master_type')})) || [];
            var allDomains = JSON.parse(JSON.stringify(${fns: toJson(fns: getDictList("technology_field"))})) || [];
            var reviewTaskList = [].concat(projectStyles, competitionTypes);

            return {
                colleges: colleges,
                pageList: [],
                pageCount: 0,
                searchListForm: {
                    pageNo: 1,
                    pageSize: 10,
                    orderBy: '',
                    orderByType: '',
                    'office.id': '',
//                    teacherType:'',
                    reviewTask: '',
                    queryStr: ''
                },
                loading: false,
                message: '${message}',
                defaultProps: {
                    label: 'name',
                    value: 'id'
                },
                multipleSelection: [],
                multipleSelectedId: [],
                originList: teacherTypes,
                reviewTaskList: reviewTaskList,


                roleList: [],
                allDomains: allDomains,
                isClose: false,
                cascaderProps: {
                    label: 'name',
                    value: 'id',
                    childern: 'children'
                },
                dialogAction: '',
                dialogCreateVisible: false,
                stuTea: false,
                createUserForm: {
                    id: '',
                    createDate: '',
                    loginName: '',
                    name: '',
                    no: '',
                    mobile: '',
                    email: '',
                    teacherType: '',
                    professional: '',
                    officeId: '',
                    roleIdList: '',
                    domainIdList: []
                },
                cascaderList: [],
                roles: [],
                updating: false,
                hideRoleNames: ['ecee0da215d04186bdeea0373bf8eeea', 'ef8b7924557747e2ac71fe5b52771c08']

            }
        },
        computed: {
            collegeList: {
                get: function () {
                    return this.colleges.filter(function (item) {
                        return item.grade == '2';
                    })
                }
            },
            teacherTypeEntries: function () {
                return this.getEntries(this.originList)
            },
            cpRoleList: function () {
                var names = this.hideRoleNames;
                return this.roleList.filter(function (item) {
                    return names.indexOf(item.id) > -1
                })
            },
            rolesJs: function () {
                var obj = {};
                this.roleList.forEach(function (item) {
                    if (!obj[item.id]) {
                        obj[item.id] = item.bizType;
                    }
                });
                return obj;
            },
            teacherTypeShow: {
                get: function () {
                    if (this.stuTea) {
                        if (this.createUserForm.teacherType == '') {
                            this.createUserForm.teacherType = '1';
                        }
                        return true;
                    } else {
                        this.createUserForm.teacherType = '';
                        return false;
                    }
                }
            }
        },
        watch: {
            roles: function (value) {
                this.createUserForm.roleIdList = value.join(',');
            }
        },
        methods: {
            getRoleList: function () {
                var self = this;
                this.$axios({
                    method: 'GET',
                    url: '/sys/role/getRoleList'
                }).then(function (response) {
                    var data = response.data;
                    if (data.status == '1') {
                        self.roleList = data.data || [];
                    }
                }).catch(function () {

                })
            },
            checkRoles: function (value) {
                var self = this;
                var hasStu = false;
                var hasTea = false;
                var types = [];
                value.forEach(function (v) {
                    types.push(self.rolesJs[v]);
                });
                hasStu = types.indexOf('1') > -1;
                hasTea = types.indexOf('2') > -1;
                if (hasStu && hasTea) {
                    value.splice(value.length - 1, 1);
                    self.$message({
                        message: '不能同时选择学生和导师角色',
                        type: 'warning'
                    });
                    return false;
                }

                this.stuTea = !hasStu && hasTea;
            },

            handleOffice: function (value) {
                if (value.length > 2) {
                    this.createUserForm.professional = value[value.length - 1];
                    this.createUserForm.officeId = value[value.length - 2];
                } else if (value.length <= 2 && value.length > 0) {
                    this.createUserForm.officeId = value[value.length - 1];
                    this.createUserForm.professional = '';
                } else {
                    this.createUserForm.professional = '';
                    this.createUserForm.officeId = ''
                }
            },
            getDataList: function () {
                var self = this;
                this.loading = true;
                this.$axios({
                    method: 'GET',
                    url: '/sys/expert/getExpertList?' + Object.toURLSearchParams(this.searchListForm)
                }).then(function (response) {
                    var page = response.data.data;
                    if (response.data.status == '1') {
                        self.pageCount = page.count;
                        self.searchListForm.pageSize = page.pageSize;
                        self.pageList = page.list || [];
                    }
                    self.loading = false;
                }).catch(function () {
                    self.loading = false;
                    self.$message({
                        message: '请求失败！',
                        type: 'error'
                    })
                })
            },
            createUser: function () {
                this.dialogAction = '创建';
                this.dialogCreateVisible = true;
            },
            amendUser: function (row) {
                var self = this;
                this.dialogAction = '修改';
                this.dialogCreateVisible = true;
                var types = [];
                this.$nextTick(function () {
                    this.createUserForm = {
                        id: row.id,
                        createDate: row.createDate,
                        loginName: row.loginName,
                        name: row.name,
                        no: row.no,
                        mobile: row.mobile,
                        email: row.email,
                        teacherType: row.teacherType,
                        officeId: row.officeId,
                        professional: row.professional,
                        roleIdList: row.roleNames,
                        domainIdList: row.domainIdList || []
                    };
                    if (row.professional == '1') {
                        this.createUserForm.officeId = '1';
                        this.createUserForm.professional = '';
                    }
                    this.cascaderList = self.getOfficeIds(row.professional || row.officeId);
                    this.roles = self.getRoleId(row.roleNames);
                    this.roles.forEach(function (v) {
                        types.push(self.rolesJs[v])
                    });
                    if (types.indexOf('2') > -1) {
                        this.stuTea = true;
                    }
                });
            },
            submitCreateUser: function (formName) {
                var self = this;
                self.$refs[formName].validate(function (valid) {
                    if (valid) {
                        self.saveAjax();
                    }
                })
            },
            saveAjax: function () {
                var self = this;
                this.loading = true;
                this.updating = true;
                var createUserForm = JSON.parse(JSON.stringify(self.createUserForm));
                createUserForm.domainIdList = createUserForm.domainIdList.join(',');
                this.$axios({
                    method: 'GET',
                    url: '/sys/user/ajaxSaveUser',
                    params: createUserForm
                }).then(function (response) {
                    var data = response.data;
                    if (data.status == '1') {
                        self.getDataList();
                        self.handleClose();
                    }
                    self.loading = false;
                    self.updating = false;
                    self.$message({
                        message: data.status == '1' ? data.msg || '保存成功' : data.msg || '保存失败',
                        type: data.status == '1' ? 'success' : 'error'
                    })
                }).catch(function () {
                    self.loading = false;
                    self.$message({
                        message: '请求失败',
                        type: 'error'
                    });
                    self.updating = false;
                })
            },
            handleClose: function () {
                this.dialogCreateVisible = false;
                this.$refs.createUserForm.resetFields();
                this.createUserForm.id = '';
                this.createUserForm.createDate = '';
                this.cascaderList = [];
                this.roles = [];
                this.stuTea = false;
            },
            getRoleId: function (roleNames) {
                var arr = roleNames.split(',');
                var lists = this.roleList;
                var ids = [];
                arr.forEach(function (value) {
                    lists.forEach(function (item) {
                        if (item.name == value) {
                            ids.push(item.id);
                        }
                    })
                });
                return ids;
            },
            getOfficeIds: function (id) {
                if (!id) return [];
                var office = this.collegeEntries[id];
                var officeIds = [];
                while (office) {
                    officeIds.unshift(id);
                    office = this.collegeEntries[office.parentId];
                    if (office) {
                        id = office.id;
                    }
                }
                return officeIds;
            },
            resetPwd: function (id) {
                var self = this;
                this.$confirm('确认要重置密码吗？', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    self.$axios({
                        method: 'POST',
                        url: '/sys/user/resetPassword',
                        data: {
                            id: id
                        }
                    }).then(function (response) {
                        var data = response.data;
                        self.$message({
                            message: data.status == '1' ? '重置密码成功！密码已重置为：123456' : '重置密码失败',
                            type: data.status == '1' ? 'success' : 'error'
                        })
                    }).catch(function () {
                        self.$message({
                            message: '请求失败',
                            type: 'error'
                        })
                    })
                })
            },

            handleSelectionChange: function (value) {
                this.multipleSelection = value;
                this.multipleSelectedId = [];
                for (var i = 0; i < value.length; i++) {
                    this.multipleSelectedId.push(value[i].id);
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

            assignExpTask: function () {

            },

            add: function () {
                location.href = this.frontOrAdmin + '/sys/expert/form';
            },

            batchDelete: function () {
                var self = this;
                this.$confirm('此操作将永久删除文件, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    var path = {
                        method: 'GET',
                        url: '/sys/backTeacherExpansion/deleteBatchByUser',
                        params: {ids: self.multipleSelectedId.join(',')}
                    };
                    self.axiosRequest(path, true, '批量删除');
                })
            },

            edit: function (id) {
                location.href = this.frontOrAdmin + '/sys/expert/form?id=' + id;
            },

            singleDelete: function (id) {
                var self = this;
                this.$confirm('此操作将永久删除文件, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(function () {
                    var path = {method: 'POST', url: '/sys/expert/delExpert', data: {id: id}};
                    self.axiosRequest(path, true, '删除');
                })
            },
            axiosRequest: function (path, showMsg, msg) {
                var self = this;
                this.loading = true;
                this.$axios(path).then(function (response) {
                    var data = response.data;
                    if (data.status == '1' || data.ret == '1') {
                        self.getDataList();
                        if (showMsg) {
                            self.$message({
                                message: data.msg || msg + '成功',
                                type: 'success'
                            });
                        }
                    } else {
                        self.$message({
                            message: data.msg || msg + '失败',
                            type: 'error'
                        });
                    }
                    self.loading = false;
                }).catch(function () {
                    self.loading = false;
                    self.$message({
                        message: '请求失败',
                        type: 'error'
                    })
                })
            }
        },
        created: function () {
            this.getRoleList();
            this.getDataList();
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