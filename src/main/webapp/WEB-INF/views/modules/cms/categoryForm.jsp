<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>
</head>


<body>
<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60">
    <div class="mgb-20">
        <edit-bar :second-name="categoryForm.id ? '修改' : '添加'"></edit-bar>
    </div>
    <el-form :model="categoryForm" :rules="categoryRules" :disabled="categoryFormDisabled" ref="categoryForm" size="mini" label-width="120px"
             style="width: 520px;">
        <input type="hidden" name="id" :value="categoryForm.id">
        <el-form-item prop="parentId" label="上级栏目：">
            <input type="hidden" name="parent.id" :value="categoryForm.parentId">
            <el-cascader :options="menuTree" @change="handleChangeTopCategory" change-on-select
                         v-model="categoryForm.parentId"
                         :props="{label: 'name', children: 'children', value: 'id'}" class="w300"></el-cascader>
        </el-form-item>
        <el-form-item prop="module" label="栏目模型：">
            <input type="hidden" name="module" :value="categoryForm.module">
            <el-select v-model="categoryForm.module" placeholder="请选择">
                <el-option
                        v-for="item in cmsModuleList"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value">
                </el-option>
            </el-select>
        </el-form-item>
        <el-form-item prop="name" label="栏目名称：">
            <el-input name="name" v-model="categoryForm.name"></el-input>
        </el-form-item>
        <el-form-item label="访问路径：">
            <el-col :span="12">
                <el-form-item prop="href" label-width="0" style="margin-bottom: 0">
                    <el-input name="href" v-model="categoryForm.href"></el-input>
                </el-form-item>
            </el-col>
            <el-col :span="12">
                <span class="el-form-item-expository">超链接地址</span>
            </el-col>
        </el-form-item>
        <!-- <el-form-item prop="inMenu" label="显示：">
            <el-switch v-model="categoryForm.inMenu" name="inMenu" active-value="1" inactive-value="0"></el-switch>
        </el-form-item> -->
        <el-form-item prop="target" label="打开新窗口：">
            <el-checkbox v-model="categoryForm.target" name="target" true-label="1">是</el-checkbox>
        </el-form-item>
        <el-form-item prop="sort" label="排序：">
            <el-input-number v-model="categoryForm.sort" :min="1"></el-input-number>
        </el-form-item>
        <el-form-item prop="showModes" label="展现方式：">
            <el-radio-group v-model="categoryForm.showModes">
                <el-radio-button name="showModes" v-for="cmsShowMode in cmsShowModeList" :key="cmsShowMode.value" :label="cmsShowMode.value">{{cmsShowMode.label}}</el-radio-button>
            </el-radio-group>
        </el-form-item>
        <el-form-item prop="allowComment" label="评论：">
            <el-switch v-model="categoryForm.allowComment" name="allowComment" active-value="1" inactive-value="0"></el-switch>
        </el-form-item>
        <el-form-item prop="isAudit" label="审核：">
            <el-switch v-model="categoryForm.isAudit" name="isAudit" active-value="1" inactive-value="0"></el-switch>
        </el-form-item>
        <el-form-item prop="isContentStatic" label="内容静态化：">
            <el-checkbox v-model="categoryForm.isContentStatic" name="isContentStatic" true-label="1">开启</el-checkbox>
        </el-form-item>
        <el-form-item prop="description" label="描述：">
            <el-input type="textarea" v-model="categoryForm.description"  name="description" :rows="3" placeholder="最大200个字"></el-input>
        </el-form-item>
        <el-form-item>
            <el-button type="primary" @click.stop.prevent="submitCategoryForm">确定</el-button>
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
            var category = JSON.parse('${fns: toJson(category)}');
            var cmsModuleList = JSON.parse('${fns: toJson(fns: getDictList('cms_module'))}');
            var cmsShowModeList = JSON.parse('${fns: toJson(fns: getDictList('cms_show_modes'))}');
            return {
                categoryForm: {
                    id: category.id,
                    parentId: [],
                    module: category.module,
                    name: category.name,
                    href: category.href,
                    /* inMenu: category.inMenu, */
                    target: category.target,
                    sort: category.sort,
                    showModes: category.showModes,
                    allowComment: category.allowComment,
                    isAudit: category.isAudit,
                    isContentStatic: category.isContentStatic,
                    description: category.description
                },
                categoryRules: {
                    parentId: [{required: true, message: '请选择上级栏目', trigger: 'change'}],
                    module: [{required: true, message: '请选择栏目模型', trigger: 'change'}],
                    name: [
                        {required: true, message: '请输入栏目名称', trigger: 'blur'},
                        {max: 10, message: '请输入1-10位之间字符', trigger: 'blur'}
                    ],
                    showModes: [{required: true, message: '请选择展现方式', trigger: 'change'}],
                    description: [{max: 200, message: '请不要超过200个字符描述', trigger: 'blur'}]
                },
                categoryFormDisabled: false,
                menuList: [],
                menuTree: [],
                menuProps: {parentKey: 'pId', id: 'id'},
                cmsModuleList: cmsModuleList,
                cmsShowModeList: cmsShowModeList
            }
        },
        methods: {
            getCategories: function () {
                var self = this;
                this.$axios.get('/cms/category/treeData').then(function (response) {
                    var data = response.data;
                    var rootIds;
                    var menuList = data.filter(function (item) {
                        return item.parentIds.split(',').length < 5 && item.name !== '首页';
                    });
                    self.setMenuEntries(menuList);
                    rootIds = self.setMenuRootIds(menuList);
                    self.menuTree = self.getMenuTreeTree(rootIds, self.menuProps, menuList);
                })
            },
            handleChangeTopCategory: function () {

            },
            submitCategoryForm: function () {
                var self = this;
                this.$refs.categoryForm.validate(function (valid) {
                    if(valid){
                        self.postCategoryForm();
                    }
                })
            },

            postCategoryForm: function () {
                this.categoryFormDisabled = true;
            },

            goToBack: function () {
                window.history.go(-1);
            },
        },
        created: function () {
            this.getCategories()
        }
    })

</script>

</body>
</html>