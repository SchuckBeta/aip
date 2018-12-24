<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>
</head>

<body>
<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60">
    <div class="mgb-20">
        <edit-bar :second-name="roleForm.id ? '修改': '添加'"></edit-bar>
    </div>
    <el-form :model="roleForm" ref="roleForm" :rules="roleRules" size="mini" label-width="120px" auto-complete="off"
             :disabled="roleFormDisabled" style="width: 540px;">
        <el-form-item prop="name" label="角色名称：">
            <el-input name="name" v-model="roleForm.name"></el-input>
        </el-form-item>
        <el-form-item prop="bizType" label="角色业务类型：">
            <el-select name="bizType" v-model="roleForm.bizType">
                <el-option v-for="item in bizTypes" :key="item.value" :label="item.label"
                           :value="item.value"></el-option>
            </el-select>
        </el-form-item>
        <el-form-item prop="enname" label="角色英文名称：">
            <el-col :span="11">
                <el-input name="enname" v-model="roleForm.enname"></el-input>
            </el-col>
            <el-col :span="13">
                <span class="el-form-item-expository">工作流用户组标识</span>
            </el-col>
        </el-form-item>
        <el-form-item prop="roleGroup" label="角色范围：">
            <el-col :span="11">
                <el-select name="roleGroup" v-model="roleForm.roleGroup">
                    <el-option v-for="item in roleGroups" :key="item.value" :label="item.label"
                               :value="item.value"></el-option>
                </el-select>
            </el-col>
            <el-col :span="13">
                <span class="el-form-item-expository">前台：可登录前台 后台：可登录后台</span>
            </el-col>
        </el-form-item>
        <el-form-item prop="sysData" label="是否系统数据：">
            <el-col :span="11">
                <el-popover
                        placement="right"
                        width="200"
                        trigger="hover">
                    <span class="el-form-item-expository">
                        “是”代表此数据只有超级管理员能进行修改，“否”则表示拥有角色修改人员的权限都能进行修改
                    </span>
                    <el-select slot="reference" name="sysData" v-model="roleForm.sysData">
                        <el-option v-for="item in yesNo" :key="item.value" :label="item.label"
                                   :value="item.value"></el-option>
                    </el-select>
                    <%--<el-switch slot="reference" name="sysData" v-model="roleForm.sysData" active-text="是" inactive-text="否"></el-switch>--%>
                </el-popover>
            </el-col>
        </el-form-item>
        <el-form-item prop="useable" label="是否可用：">
            <el-col :span="11">
                <el-popover
                        placement="right"
                        width="200"
                        trigger="hover">
                    <span class="el-form-item-expository">
                      “是”代表此数据可用，“否”则表示此数据不可用
                    </span>
                    <el-select slot="reference" name="useable" v-model="roleForm.useable">
                        <el-option v-for="item in yesNo" :key="item.value" :label="item.label"
                                   :value="item.value"></el-option>
                    </el-select>
                    <%--<el-switch slot="reference" name="useable" v-model="roleForm.useable" active-text="是" inactive-text="否"></el-switch>--%>
                </el-popover>
            </el-col>
        </el-form-item>
        <el-form-item v-if="isAdmin" prop="dataScope" label="数据范围：">
            <el-col :span="11">
                <el-popover
                        placement="right"
                        width="200"
                        trigger="hover">
                    <span class="el-form-item-expository">
                      特殊情况下，设置为“按明细设置”，可进行跨机构授权
                    </span>
                    <el-select slot="reference" name="dataScope" v-model="roleForm.dataScope">
                        <el-option v-for="item in dataScopes" :key="item.value" :label="item.label"
                                   :value="item.value"></el-option>
                    </el-select>
                </el-popover>
            </el-col>
        </el-form-item>
        <el-form-item prop="menuIds" label="角色授权：">
            <el-tree
                    :data="menuTree"
                    show-checkbox
                    node-key="id"
                    :check-strictly="true"
                    :default-expanded-keys="expandedKeys"
                    :default-checked-keys="roleForm.menuIds"
                    @check="menuCheck"
                    :props="defaultProps">
            </el-tree>
        </el-form-item>
        <el-form-item v-if="roleForm.dataScope == 9" prop="officeIds" label="跨机构授权：">
            <el-office :office-ids="roleForm.officeIds" @change-office-ids="changeOfficeIds"></el-office>
        </el-form-item>
        <el-form-item prop="remarks" label="备注：">
            <el-input name="remarks" :rows="3" type="textarea" v-model="roleForm.remarks"></el-input>
        </el-form-item>
        <el-form-item>
            <shiro:hasPermission name="sys:role:edit">
                <el-button v-if="isAdmin || (['1', '10'].indexOf(roleForm.id) == -1)" type="primary"
                           @click.stop.prevent="saveRole">保存
                </el-button>
            </shiro:hasPermission>
            <el-button @click.stop.prevent="goToBack">返回</el-button>
        </el-form-item>
    </el-form>
</div>

<script type="text/javascript">

    'use strict';

    Vue.component('el-office', {
        template: '<el-tree :data="collegesTree" @check="officeCheck"  show-checkbox node-key="id" :check-strictly="true" :default-expanded-keys="expandedKeys" :default-checked-keys="localOfficeIds" :props="defaultProps"></el-tree>',
        props: {
            officeIds: Array
        },
        mixins: [Vue.collegesMixin],
        data: function () {
            return {
                colleges: [],
                defaultProps: {
                    children: 'children',
                    label: 'name'
                },
                collegesProps: {
                    id: 'id',
                    parentKey: 'parentId'
                },
                expandedKeys: [],
                localOfficeIds: []
            }
        },
        methods: {
            getOfficeList: function () {
                var self = this;
                this.$axios.get('/sys/office/getOfficeList').then(function (response) {
                    var data = response.data;
                    if (data.status) {
                        data = data.data;
                        if (data) {
                            self.colleges = data || [];
                            self.setCollegeEntries([].concat(self.colleges));
                            self.collegesTree = self.getCollegesTree(['1'], self.collegesProps);
                            var grades = self.colleges.filter(function (item) {
                                return item.parentId === '1';
                            })
                            self.expandedKeys = ['1'].concat(grades)
                        }
                    }
                })
            },
            officeCheck: function (data, checkedData) {
                this.localOfficeIds = checkedData.checkedKeys;
                this.$emit('change-office-ids', this.localOfficeIds)
            },
        },
        beforeMount: function () {
            this.localOfficeIds = this.officeIds;
            this.getOfficeList();
        }

    })


    new Vue({
        el: '#app',
        mixins: [Vue.menuTreeMixin],
        data: function () {
            var bizTypes = JSON.parse('${fns: toJson(fns:getDictList('0000000153'))}');
            var yesNo = JSON.parse('${fns: toJson(fns:getDictList('yes_no'))}');
            var roleForm = JSON.parse(JSON.stringify(${fns: toJson(role)}));
            var dataScopes = JSON.parse('${fns: toJson(fns:getDictList('sys_data_scope'))}');
            var menuList = JSON.parse(JSON.stringify(${fns: toJson(menuList)})) || [];
            var menuIds = roleForm.menuIds.split(',') || [];
            var officeIds = roleForm.officeIds.split(',') || [];
            var self = this;
            var validateName = function (rules, value, callback) {
                if (value) {
                    if (/[@#\$%\^&\*\s]+/g.test(value)) {
                        return callback(new Error("请不要输入特殊符号"));
                    }
                    return self.$axios.get('/sys/role/checkRoleName?' + Object.toURLSearchParams({
                                id: roleForm.id,
                                name: value
                            })).then(function (response) {
                        if (response.data) {
                            return callback();
                        }
                        return callback(new Error("名称已经存在"))
                    })
                }
                return callback();
            }

            var validateEnName = function (rules, value, callback) {
                if (value) {
                    if (/[@#\$%\^&\*\s]+/g.test(value)) {
                        return callback(new Error("请不要输入特殊符号"));
                    }
                    return self.$axios.get('/sys/role/checkRoleEnName?' + Object.toURLSearchParams({
                                id: roleForm.id,
                                enname: value
                            })).then(function (response) {
                        if (response.data) {
                            return callback();
                        }
                        return callback(new Error("名称已经存在"))
                    })
                }
                return callback();
            };

            return {
                roleForm: {
                    id: roleForm.id,
                    name: roleForm.name,
                    oldName: roleForm.name,
                    bizType: roleForm.bizType,
                    enname: roleForm.enname,
                    oldEnname: roleForm.oldEnname,
                    roleGroup: roleForm.roleGroup,
                    sysData: roleForm.sysData || '0',
                    useable: roleForm.useable || '0',
                    dataScope: roleForm.dataScope,
                    menuIds: menuIds,
                    officeIds: officeIds,
                    remarks: roleForm.remarks
                },
                roleRules: {
                    name: [{required: true, message: '请输入角色名称', trigger: 'blur'},
                        {max: 24, message: '请输入不大于24个字符', trigger: 'blur'},
                        {validator: validateName, trigger: 'blur'}],
                    bizType: [{required: true, message: '请选择角色业务类型', trigger: 'change'}],
                    enname: [{required: true, message: '请输入角色名称', trigger: 'blur'},
                        {max: 50, message: '请输入不大于50个字符', trigger: 'blur'},
                        {validator: validateEnName, trigger: 'blur'}]
                },
                roleFormDisabled: false,
                isAdmin: ${admin},
                bizTypes: bizTypes,
                roleGroups: [{label: '前台', value: '1'}, {label: '后台', value: '2'}],
                yesNo: yesNo,
                dataScopes: dataScopes,
                menuList: menuList,
                defaultProps: {
                    children: 'children',
                    label: 'name'
                },
                menuProps: {
                    id: 'id',
                    parentKey: 'parentId'
                },
                expandedKeys: []
            }
        },
        methods: {
            saveRole: function () {
                var self = this;
                this.$refs.roleForm.validate(function (valid) {
                    if (valid) {
                        self.postRole();
                    }
                })
            },
            postRole: function () {
                var self = this;
                this.roleFormDisabled = true;
                this.$axios.post('/sys/role/saveRole', this.getRoleParams()).then(function (response) {
                    var data = response.data;
                    if (data.status == 1) {
                        self.$msgbox({
                            message: "保存成功",
                            title: '提示',
                            confirmButtonText: '确定',
                            showClose: false,
                            closeOnClickModal: false,
                            type: 'success'
                        }).then(function () {
                            self.goToBack();
                        }).catch(function () {

                        })
                    } else {
                        self.$message({
                            type: 'error',
                            message: data.msg
                        })
                    }
                    self.roleFormDisabled = false;
                }).catch(function () {
                    self.$message({
                        type: 'error',
                        message: self.xhrErrorMsg
                    })
                    self.roleFormDisabled = false;
                })
            },
            getRoleParams: function () {
                var roleForm = JSON.parse(JSON.stringify(this.roleForm));
                roleForm.menuIds = roleForm.menuIds.join(',');
                roleForm.officeIds = roleForm.officeIds.join(',');
                return roleForm;
            },

            menuCheck: function (data, checkedData) {
                this.roleForm.menuIds = checkedData.checkedKeys;
            },

            changeOfficeIds: function (data) {
                this.roleForm.officeIds = data;
            },

            goToBack: function () {
                location.href = this.frontOrAdmin + '/sys/role'
            }
        },
        created: function () {
            var menuRootIds = this.menuRootIds;
            var menuSecondIds = this.menuList.filter(function (item) {
                return menuRootIds.indexOf(item.parentId) > -1;
            })
            this.expandedKeys = [].concat(menuRootIds, menuSecondIds)
        }
    })

</script>

</body>
</html>