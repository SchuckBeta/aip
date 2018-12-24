<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
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
        <edit-bar :second-name="menuForm.id ? '修改': '添加'"></edit-bar>
    </div>
    <el-form :model="menuForm" ref="menuForm" :rules="menuRules" size="mini" label-width="120px" auto-complete="off"
             :disabled="menuFormDisabled" style="width: 540px;">
        <el-form-item prop="tmpParentIds" label="上级菜单：">
            <input name="parent.id" style="display: none" :value="parentId">
            <el-cascader
                    placeholder="请输入名称"
                    change-on-select
                    :options="menuTree"
                    :props="cascaderProps"
                    style="width: 100%;"
                    v-model="menuForm.tmpParentIds"
                    filterable
            ></el-cascader>
        </el-form-item>
        <el-form-item prop="name" label="名称：">
            <el-input name="name" v-model="menuForm.name"></el-input>
        </el-form-item>
        <el-form-item prop="href" label="链接：">
            <el-col :span="11">
                <el-input name="href" v-model="menuForm.href"></el-input>
            </el-col>
            <el-col :span="13">
                <span class="el-form-item-expository">点击菜单跳转的页面</span>
            </el-col>
        </el-form-item>
        <el-form-item prop="target" label="链接：">
            <el-col :span="11">
                <el-input name="target" v-model="menuForm.target"></el-input>
            </el-col>
            <el-col :span="13">
                <span class="el-form-item-expository">链接地址打开的目标窗口</span>
            </el-col>
        </el-form-item>
        <el-form-item prop="sort" label="排序：">
            <el-input-number name="sort" :step="30" :min="0" v-model="menuForm.sort"></el-input-number>
        </el-form-item>
        <el-form-item prop="isShow" label="显示：">
            <el-switch name="isShow" v-model="menuForm.isShow" active-value="1" inactive-value="0"></el-switch>
        </el-form-item>
        <el-form-item prop="permission" label="权限标识：">
            <el-col :span="11">
                <el-input name="permission" v-model="menuForm.permission"></el-input>
            </el-col>
            <el-col :span="13">
                <span class="el-form-item-expository">@RequiresPermissions("权限标识")</span>
            </el-col>
        </el-form-item>
        <el-form-item prop="remarks" label="备注：">
            <el-input name="remarks" :rows="3" type="textarea" v-model="menuForm.remarks"></el-input>
        </el-form-item>
        <el-form-item prop="imgUrl" label="菜单图片：" class="common-upload-one-img">
            <div class="upload-box-border" style="width: 110px; height: 110px;">
                <el-upload
                        class="avatar-uploader"
                        action="/a/ftp/ueditorUpload/uploadTemp?folder=menu"
                        :show-file-list="false"
                        name="upfile"
                        :on-success="imgUrlSuccess"
                        :on-error="imgUrlError"
                        accept="image/jpeg,image/png">
                    <img v-if="menuForm.imgUrl" :src="menuForm.imgUrl | ftpHttpFilter(ftpHttp)">
                    <i v-if="!menuForm.imgUrl"
                       class="el-icon-plus avatar-uploader-icon"></i>
                </el-upload>
            </div>
            <div class="img-tip">
                仅支持上传jpg/png文件，建议大小：220*220（像素）
            </div>
        </el-form-item>

        <el-form-item>

            <el-button type="primary" @click.stop.prevent="saveMenu">保存</el-button>
            <el-button @click.stop.prevent="goToBack">返回</el-button>
        </el-form-item>
    </el-form>
</div>


<script type="text/javascript">

    'use strict';

    new Vue({
        el: '#app',
        mixins: [Vue.menuTreeMixin],
        data: function () {
            var self = this;
            var menu = JSON.parse(JSON.stringify(${fns: toJson(menu)}));


            return {
                imageUrl: '',
                menuList: [],
                menuForm: {
                    id: menu.id,
                    parent: {
                        id: menu.parentId
                    },
                    parentId: menu.parentId,
                    tmpParentIds: [],
                    name: menu.name,
                    href: menu.href,
                    target: menu.target || '_self',
                    sort: menu.sort,
                    isShow: menu.isShow,
                    permission: menu.permission,
                    remarks: menu.remarks,
                    imgUrl: menu.imgUrl
                },

                cascaderProps: {
                    label: 'name',
                    value: 'id',
                    children: 'children'
                },
                menuProps: {
                    id: 'id',
                    parentKey: 'pId'
                },
                menuFormDisabled: false
            }
        },
        computed: {
            'parentId': function () {
                var tmpParentIds = this.menuForm.tmpParentIds;
                if (tmpParentIds.length > 0) {
                    return tmpParentIds[tmpParentIds - 1]
                }
            },
            menuRules: function () {
                var tmpParentIds = this.menuForm.tmpParentIds;
                var validateName = function (rules, value, callback) {
                    if (value) {
                        if (/[@#\$%\^&\*\s]+/g.test(value)) {
                            return callback(new Error("请不要输入特殊符号"));
                        }
                        return callback();
                    }
                    return  callback();
                }
                return {
                    name: [
                        {required: true, message: '请输入菜单名称', trigger: 'blur'},
                        {max: 24, message: '请输入大不于24个字字符', trigger: 'blur'},
                        {validator: validateName, trigger: 'blur'},
                    ],
                    href: [
                        {max: 2000, message: '请输入大不于2000个字字符', trigger: 'blur'},
                    ],
                    target: [
                        {max: 12, message: '请输入大不于12个字字符', trigger: 'blur'},
                    ],
                    permission: [
                        {max: 100, message: '请输入大不于100个字字符', trigger: 'blur'},
                    ],
                    remarks: [
                        {max: 200, message: '请输入大不于200个字字符', trigger: 'blur'},
                    ],
                    imgUrl: [
                        {required: tmpParentIds.length == '1', message: '请上传菜单图片', trigger: 'change'},
                    ],
                    tmpParentIds: [
                        {required: true, message: '请选择上级菜单', trigger: 'change'},
                    ]
                }
            },
        },
        methods: {
            saveMenu: function () {
                var self = this;
                this.$refs.menuForm.validate(function (valid) {
                    if (valid) {
                        self.postMenu();
                    }
                })
            },

            goToBack: function () {
                location.href = this.frontOrAdmin + '/sys/menu/'
            },

            imgUrlSuccess: function (response) {
                if(response.state === 'SUCCESS'){
                    this.menuForm.imgUrl = response.ftpUrl;
                    return false;
                }
                this.$message({
                    type: 'error',
                    message: '上传失败'
                })
            },

            imgUrlError: function (error) {
                this.$message({
                    type: 'error',
                    message: this.xhrErrorMsg
                })
            },

            postMenu: function () {
                var self = this;
                self.menuFormDisabled = true;
                var menuForm = this.dealMenuFormParam();
                this.$axios.post('/sys/menu/saveMenu', menuForm).then(function (response) {
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
                    self.menuFormDisabled = false;
                }).catch(function (error) {
                    self.$message({
                        type: 'error',
                        message: self.xhrErrorMsg
                    })
                    self.menuFormDisabled = false;
                })
            },

            getMenuList: function () {
                var self = this;
                this.$axios.get('/sys/menu/treeData').then(function (response) {
                    var menuList = response.data || [];
                    menuList = [].concat(menuList);
                    self.setMenuEntries(menuList);
                    self.menuTree = self.getMenuTreeTree(['1'], self.menuProps, menuList);
                    self.getTmpParentIds();

                }).catch(function () {

                })
            },

            getMenuTree: function () {
              this.$axios.get('/sys/menu/getMenuTree').then(function (response) {
                  console.log(response.data)
              })
            },

            dealMenuFormParam: function () {
                var menuForm = JSON.parse(JSON.stringify(this.menuForm));
                var parentId = menuForm.tmpParentIds[menuForm.tmpParentIds.length - 1];
                menuForm.parent.id = parentId;
                menuForm.parentId = parentId;
                menuForm.parent.name = this.menuEntries[parentId].name;
                delete  menuForm.tmpParentIds;
                return menuForm;
            },

            getTmpParentIds: function () {
                if (this.menuForm.id || this.menuForm.parent.id) {
                    var parentIds = [];
                    var menuEntries = this.menuEntries;
                    var parentId = this.menuForm.parent.id;
                    if (this.menuForm.id) {
                        parentId = menuEntries[this.menuForm.id].pId;
                    }
                    while (parentId) {
                        if (parentId == '0') {
                            break;
                        }
                        parentIds.unshift(parentId);
                        parentId = menuEntries[parentId].pId;
                    }
                    this.menuForm.tmpParentIds = parentIds;
                }
            }
        },
        created: function () {
            this.getMenuList();
            this.getMenuTree();
        }
    })

</script>
</body>
</html>