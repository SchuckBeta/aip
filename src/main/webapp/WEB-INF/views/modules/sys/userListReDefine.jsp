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

<div id="app" class="container-fluid mgb-60 user-share" v-show="pageLoad" style="display: none;">
    <edit-bar></edit-bar>

    <el-form :model="searchListForm" size="mini" autocomplete="off" ref="searchListForm">
        <input type="hidden" name="pageNo" :value="searchListForm.pageNo"/>
        <input type="hidden" name="pageSize" :value="searchListForm.pageSize"/>

        <div class="conditions">
            <e-condition label="学院" type="radio" :options="academyList" v-model="searchListForm['office.id']" name="'office.id"
                         :default-props="defaultProps" @change="getDataList"></e-condition>
            <e-condition label="用户角色" type="radio" :options="roleList" v-model="searchListForm.roleId" name="roleId"
                         :default-props="defaultProps" @change="getDataList"></e-condition>
        </div>

        <div class="search-block_bar clearfix">
            <div class="search-btns">
                <el-button type="primary" size="mini" @click.stop.prevent="createUser">
                    <i class="el-icon-circle-plus el-icon--left"></i>创建用户
                </el-button>
                <el-button type="primary" :disabled="multipleSelectedId.length == 0" size="mini"
                           @click.stop.prevent="batchDelete(multipleSelectedId)">
                    <i class="iconfont icon-delete"></i>批量删除
                </el-button>
            </div>
            <div class="search-input">
                <input type="text" style="display:none">
                <el-input @keyup.enter.native="getDataList"
                        name="queryStr"
                        placeholder="登录名/姓名/学号/手机号/工号/技术领域"
                        v-model="searchListForm.queryStr"
                        size="mini"
                        class="w300">
                    <el-button slot="append" icon="el-icon-search"
                               @click.stop.prevent="getDataList"></el-button>
                </el-input>
            </div>
        </div>

    </el-form>

    <div class="table-container">
        <el-table :data="pageList" ref="multipleTable" class="table" v-loading="loading" @selection-change="handleSelectionChange" size="mini">
            <el-table-column
                    type="selection" :selectable="selectable"
                    width="55">
            </el-table-column>
            <el-table-column width="320" label="用户信息">
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
            <el-table-column label="用户角色" align="center" min-width="100">
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
            <el-table-column label="学院/专业" align="center" min-width="90">
                <template slot-scope="scope">
                    <%--<p v-if="!scope.row.professional">-</p>--%>
                    <%--<p v-else>--%>
                        <%--<el-tooltip :content="getOneAcademy(scope.row.professional)" popper-class="white" placement="right">--%>
                            <%--<span class="break-ellipsis">{{getOneAcademy(scope.row.professional)}}</span>--%>
                        <%--</el-tooltip>--%>
                    <%--</p>--%>
                    <%--<p v-if="!scope.row.professional">-</p>--%>
                    <%--<p v-else>--%>
                        <%--<el-tooltip :content="scope.row.professional | collegeFilter(collegeEntries)" popper-class="white" placement="right">--%>
                            <%--<span class="break-ellipsis">{{scope.row.professional | getProfessionName(collegeEntries)}}</span>--%>
                        <%--</el-tooltip>--%>
                    <%--</p>--%>

                        <span class="break-ellipsis">{{scope.row.officeId | collegeFilter(collegeEntries)}}</span>
                       <template v-if="scope.row.officeId && scope.row.professional && scope.row.professional != scope.row.officeId">
                             <div>{{scope.row.professional | collegeFilter(collegeEntries)}}</div>
                        </template>
                </template>
            </el-table-column>
            <el-table-column label="技术领域" align="center" min-width="90">
                <template slot-scope="scope">
                    <el-tooltip :content="scope.row.domainlt" popper-class="white" placement="right">
                        <span class="break-ellipsis">{{scope.row.domainlt}}</span>
                    </el-tooltip>
                </template>
            </el-table-column>
            <shiro:hasPermission name="sys:user:edit">
                <el-table-column label="操作" align="center" min-width="150">
                    <template slot-scope="scope">
                        <div class="table-btns-action">
                            <el-button size="mini" type="text"
                                       @click.stop.prevent="resetPwd(scope.row.id)">重置密码
                            </el-button>
                            <el-button size="mini" type="text"
                                       @click.stop.prevent="amendUser(scope.row)">修改
                            </el-button>
                            <el-button size="mini" type="text"
                                       @click.stop.prevent="deleteData(scope.row.id)">删除
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

    <el-dialog :title="dialogAction + '用户'" top="5vh" :visible.sync="dialogCreateVisible" :before-close="handleClose" :close-on-click-modal="isClose"
               class="dialog-form-condition" width="60%">

        <el-form ref="createUserForm" :model="createUserForm" label-width="120px" :disabled="updating"
                 method="post" size="mini" class="demo-ruleForm" :rules="rules">
            <div class="gray-box">
                <p class="gray-box-title"><span>必填信息</span> <span v-if="createUserForm.id">创建时间：{{createUserForm.createDate}}</span></p>
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
                    <el-form-item label="用户角色" prop="roleIdList">
                        <el-checkbox-group v-model="roles" id="roleIdList" name="roleIdList" @change="checkRoles">
                            <el-checkbox v-for="role in roleList" :label="role.id" :key="role.id">{{role.name}}</el-checkbox>
                        </el-checkbox-group>
                    </el-form-item>
                    <el-form-item label="导师来源" prop="teacherType" v-if="teacherTypeShow">
                        <el-radio-group v-model="createUserForm.teacherType" id="teacherType" name="teacherType" style="margin-top:2px;">
                            <el-radio v-for="type in teacherTypes" :label="type.value" :key="type.id">{{type.label}}</el-radio>
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
                            <el-checkbox v-for="item in allDomains" :label="item.value" :key="item.id">{{item.label}}</el-checkbox>
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
            <shiro:hasPermission name="sys:user:edit">
                <el-button size="mini" type="primary" :disabled="updating" @click.stop.prevent="submitCreateUser('createUserForm')">保 存
                </el-button>
            </shiro:hasPermission>
        </div>

    </el-dialog>
</div>


<script>
    +function (Vue) {

        var app = new Vue({
            el: '#app',
            mixins: [Vue.collegesMixin,Vue.userManageMixin],
            data: function () {
                var colleges = JSON.parse('${fns: toJson(fns: getOfficeList())}') || [];
                var roleList = JSON.parse('${fns:toJson(roleList)}');
                var teacherTypes = JSON.parse('${fns: getDictListJson('master_type')}') || [];
                var rolesJs = ${fns:toJson(rolesjs)};
                var allDomains = ${fns:toJson(allDomains)};

                return {
                    pageList: [],
                    pageCount: 0,
                    searchListForm: {
                        pageNo: 1,
                        pageSize: 10,
                        queryStr: '',
                        'office.id':'',
                        roleId:''
                    },
                    colleges: colleges,
                    roleList: roleList,
                    teacherTypes:teacherTypes,
                    rolesJs:rolesJs,
                    allDomains:allDomains,
                    isClose:false,
                    defaultProps: {
                        label: 'name',
                        value: 'id'
                    },
                    cascaderProps:{
                        label:'name',
                        value:'id',
                        childern:'children'
                    },
                    loading:false,
                    message: '${message}',
                    dialogAction:'',
                    dialogCreateVisible: false,
                    stuTea:false,
                    createUserForm: {
                        id:'',
                        createDate:'',
                        loginName: '',
                        name: '',
                        no: '',
                        mobile: '',
                        email: '',
                        teacherType:'',
                        professional: '',
                        officeId: '',
                        roleIdList: '',
                        domainIdList:[]
                    },
                    multipleSelection: [],
                    multipleSelectedId: [],
                    cascaderList:[],
                    roles:[],
                    updating: false
                }
            },
            computed: {
                academyList: {
                    get: function () {
                        return this.colleges.filter(function (item) {
                            return item.parentId == '1'
                        })
                    }
                },
                teacherTypeShow:{
                    get:function () {
                        if(this.stuTea){
                            if(this.createUserForm.teacherType == ''){
                                this.createUserForm.teacherType = '1';
                            }
                            return true;
                        }else{
                            this.createUserForm.teacherType = '';
                            return false;
                        }
                    }
                }
            },
            watch:{
                roles:function (value) {
                    this.createUserForm.roleIdList = value.join(',');
                }
            },
            methods: {
                checkRoles:function (value) {
                    var self = this;
                    var hasStu = false;
                    var hasTea = false;
                    var types = [];
                    value.forEach(function (v) {
                        types.push(self.rolesJs[v]);
                    });
                    hasStu = types.indexOf('1') > -1;
                    hasTea = types.indexOf('2') > -1;
                    if(hasStu && hasTea){
                        value.splice(value.length-1,1);
                        self.$message({
                            message:'不能同时选择学生和导师角色',
                            type:'warning'
                        });
                        return false;
                    }

                    this.stuTea = !hasStu && hasTea;
                },

                handleOffice: function (value) {
                    if(value.length > 2){
                        this.createUserForm.professional = value[value.length - 1];
                        this.createUserForm.officeId = value[value.length - 2];
                    }else if(value.length <= 2 && value.length > 0){
                        this.createUserForm.officeId = value[value.length - 1];
                        this.createUserForm.professional = '';
                    }else{
                        this.createUserForm.professional = '';
                        this.createUserForm.officeId = ''
                    }
                },
                getDataList: function () {
                    var self = this;
                    this.loading = true;
                    this.$axios({
                        method: 'GET',
                        url: '/sys/user/getUserList?' + Object.toURLSearchParams(this.searchListForm)
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
                handlePaginationSizeChange: function (value) {
                    this.searchListForm.pageSize = value;
                    this.getDataList();
                },

                handlePaginationPageChange: function (value) {
                    this.searchListForm.pageNo = value;
                    this.getDataList();
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
                            id:row.id,
                            createDate:row.createDate,
                            loginName: row.loginName,
                            name: row.name,
                            no: row.no,
                            mobile: row.mobile,
                            email: row.email,
                            teacherType:row.teacherType,
                            officeId: row.officeId,
                            professional: row.professional,
                            roleIdList: row.roleNames,
                            domainIdList:row.domainIdList || []
                        };
                        if(row.professional == '1'){
                            this.createUserForm.officeId = '1';
                            this.createUserForm.professional = '';
                        }
                        this.cascaderList = self.getOfficeIds(row.professional || row.officeId);
                        this.roles = self.getRoleId(row.roleNames);
                        this.roles.forEach(function (v) {
                            types.push(self.rolesJs[v])
                        });
                        if(types.indexOf('2') > -1){
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
                saveAjax:function () {
                    var self = this;
                    this.loading = true;
                    this.updating = true;
                    var createUserForm = JSON.parse(JSON.stringify(self.createUserForm));
                    createUserForm.domainIdList = createUserForm.domainIdList.join(',')
                    this.$axios({
                        method:'GET',
                        url:'/sys/user/ajaxSaveUser',
                        params: createUserForm
                    }).then(function (response) {
                        var data = response.data;
                        if(data.status == '1'){
                            self.getDataList();
                            self.handleClose();
                        }
                        self.loading = false;
                        self.updating = false;
                        self.$message({
                            message:data.status == '1' ? data.msg || '保存成功' : data.msg || '保存失败',
                            type:data.status == '1' ? 'success' : 'error'
                        })
                    }).catch(function () {
                        self.loading = false;
                        self.$message({
                            message:'请求失败',
                            type:'error'
                        })
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
                getRoleId:function (roleNames) {
                    var arr = roleNames.split(',');
                    var lists = this.roleList;
                    var ids = [];
                    arr.forEach(function (value) {
                        lists.forEach(function (item) {
                            if(item.name == value){
                                ids.push(item.id);
                            }
                        })
                    });
                    return ids;
                },
                getOneAcademy: function (id) {
                    var academyId;
                    var academyName;
                    for (var i = 0; i < this.colleges.length; i++) {
                        if (this.colleges[i].id == id) {
                            academyId = this.colleges[i].parentId;
                            for (var j = 0; j < this.colleges.length; j++) {
                                if (this.colleges[j].id == academyId) {
                                    academyName = this.colleges[j].name;
                                }
                            }
                        }
                    }
                    return academyName;
                },
                getOfficeIds: function (id) {
                    if(!id) return [];
                    var office = this.collegeEntries[id];
                    var officeIds = [];
                    while (office){
                        officeIds.unshift(id);
                        office = this.collegeEntries[office.parentId];
                        if(office){
                            id = office.id;
                        }
                    }
                    return officeIds;
                },
                resetPwd:function (id) {
                    var self = this;
                    this.$confirm('确认要重置密码吗？', '提示', {
                        confirmButtonText: '确定',
                        cancelButtonText: '取消',
                        type: 'warning'
                    }).then(function () {
                        self.$axios({
                            method:'POST',
                            url:'/sys/user/resetPassword',
                            data:{
                                id:id
                            }
                        }).then(function (response) {
                            var data = response.data;
                            self.$message({
                                message:data.status == '1' ? '重置密码成功！密码已重置为：123456' : '重置密码失败',
                                type:data.status == '1' ? 'success' : 'error'
                            })
                        }).catch(function () {
                            self.$message({
                                message:'请求失败',
                                type:'error'
                            })
                        })
                    })
                },
                deleteData: function (id) {
                    var self = this;
                    this.$confirm('确认删除吗？', '提示', {
                        confirmButtonText: '确定',
                        cancelButtonText: '取消',
                        type: 'warning'
                    }).then(function () {
                        self.$axios({
                            method:'POST',
                            url:'/sys/user/delUser',
                            data:{
                                id:id
                            }
                        }).then(function (response) {
                            var data = response.data;
                            if(data.status == '1'){
                                self.getDataList();
                            }
                            self.$message({
                                message:data.status == '1' ? '删除成功' : data.msg || '删除失败',
                                type:data.status == '1' ? 'success' : 'error'
                            });
                        }).catch(function () {
                            self.$message({
                                message:'请求失败',
                                type:'error'
                            })
                        })
                    })

                },
                batchDelete:function (ids) {
                    var self = this;
                    this.$confirm('确认删除吗？', '提示', {
                        confirmButtonText: '确定',
                        cancelButtonText: '取消',
                        type: 'warning'
                    }).then(function () {
                        self.$axios({
                            method:'POST',
                            url:'/sys/user/ajaxDelUser',
                            data:{
                                ids:ids
                            }
                        }).then(function (response) {
                            var data = response.data;
                            if(data.status == '1'){
                                self.getDataList();
                            }
                            self.$message({
                                message:data.status == '1' ? '删除成功' : data.msg || '删除失败',
                                type:data.status == '1' ? 'success' : 'error'
                            });
                        }).catch(function () {
                            self.$message({
                                message:'请求失败',
                                type:'error'
                            })
                        })
                    })
                },
                handleSelectionChange: function (val) {
                    this.multipleSelectedId = [];
                    for (var i = 0; i < val.length; i++) {
                        this.multipleSelectedId.push(val[i].id);
                    }
                },
                selectable: function (row) {
                    return row.admin == false;
                }
            },
            created: function () {
                this.getDataList();
                if (this.message) {
                    this.$message({
                        type: 'warning',
                        message: this.message
                    });
                    this.message = '';
                }
            }
        })

    }(Vue)
</script>


</body>

</html>