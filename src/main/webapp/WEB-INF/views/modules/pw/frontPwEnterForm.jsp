<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ page errorPage="/WEB-INF/views/error/formMiss.jsp" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>${fns:getConfig('frontTitle')}</title>
    <meta name="decorator" content="creative"/>
    <script src="/js/components/pwEnter/pwEnterApplyRules.js?version=${fns: getVevison()}"></script>
    <script src="/js/components/pwEnter/pwEnterApplyForm.js?version=${fns: getVevison()}"></script>
</head>
<body>

<div id="app" v-show="pageLoad" class="container page-container pdt-60" style="display: none">
    <el-breadcrumb separator-class="el-icon-arrow-right">
        <el-breadcrumb-item><a href="${ctxFront}"><i class="iconfont icon-ai-home"></i>首页</a></el-breadcrumb-item>
        <el-breadcrumb-item>创业基地</el-breadcrumb-item>
        <el-breadcrumb-item>入驻申请</el-breadcrumb-item>
    </el-breadcrumb>
    <h3 class="pw-enter-apply-title">大学生创业孵化示范基地入驻申请</h3>
    <row-step-apply>
        <step-item is-complete>第一步（完善基本信息）</step-item>
        <step-item :is-complete="isSecondStep">第二步（输入申报信息）</step-item>
    </row-step-apply>
    <div class="pw-enter-container">
        <div class="pw-apply-topbar">
            <span class="apply-date">申报日期：</span>
        </div>
        <div class="pw-apply-titlebar-wrap">
            <div class="pw-apply-titlebar">
                <span class="title">{{formTitle}}</span>
            </div>
        </div>
        <div v-show="!isSecondStep" class="pw-apply-form-body">
            <div class="pwa-user-card-photo">
                <div class="card-photo common-upload-one-img">
                    <div class="upload-box-border site-cover-size">
                        <el-upload
                                :disabled="disabled"
                                class="avatar-uploader"
                                action="/f/ftp/ueditorUpload/uploadTemp"
                                :show-file-list="false"
                                :on-success="idPhotoSuccess"
                                :on-error="idPhotoError"
                                name="upfile"
                                accept="image/jpg, image/jpeg, image/png">
                            <img :src="pwApplyForm.declarePhoto | ftpHttpFilter(ftpHttp)">
                            <i v-if="!pwApplyForm.declarePhoto"
                               class="el-icon-plus avatar-uploader-icon"></i>
                        </el-upload>
                        <div class="arrow-block-delete" v-if="pwApplyForm.declarePhoto">
                            <i class="el-icon-delete" @click.sotp.prevent="pwApplyForm.declarePhoto = ''"></i>
                        </div>
                    </div>
                    <div class="img-tip">
                        请上传1寸登记照
                    </div>
                </div>
            </div>
            <div class="pwa-user-info-list">
                <el-row :gutter="15" label-width="120px">
                    <el-col :span="8">
                        <e-col-item align="right" label="姓名：">{{user.name}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item align="right" label="性别：">{{user.sex === '1' ? '男' : '女'}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item align="right" label="出生年月：">{{user.birthday | formatDateFilter('YYYY-MM')}}
                        </e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item align="right" label="证件类型：">{{user.idType | selectedFilter(idTypeEntries)}}
                        </e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item align="right" label="证件号码：">{{user.idNumber}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item align="right" label="学号：">{{user.no}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item align="right" label="学院：">{{user.officeName}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item align="right" label="专业：">{{user.professional |
                            selectedFilter(professionalEntries)}}
                        </e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item align="right" label="电子邮箱：">{{user.email}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item align="right" label="手机号：">{{user.mobile}}</e-col-item>
                    </el-col>
                    <el-col :span="8">
                        <e-col-item align="right" label="户籍所在地：">{{user.residence}}</e-col-item>
                    </el-col>
                    <el-col :span="24">
                        <e-col-item align="right" label="创业人简介：" class="white-space-pre-static">{{user.introduction}}
                        </e-col-item>
                    </el-col>
                </el-row>

                <el-form :model="pwApplyForm" ref="pwApplyForm" :disabled="disabled" :rules="pwApplyOneRules"
                         size="mini" label-width="120px">
                    <el-form-item prop="type" label="入驻类型：">
                        <el-radio-group v-model="pwApplyForm.type">
                            <el-radio v-for="item in pwEnterTypes" :key="item.value" :label="item.value">
                                {{item.label}}
                            </el-radio>
                        </el-radio-group>
                    </el-form-item>
                    <el-form-item label-width="0" class="text-center">
                        <el-button type="primary" :disabled="!pwApplyForm.type || disabled"
                                   @click.stop.prevent="goToStep">下一步
                        </el-button>
                    </el-form-item>
                </el-form>
            </div>

        </div>
        <template v-if="isRender">
            <enter-form-group ref="enterFormGroup" v-show="isSecondStep" :pw-enter-id="pwApplyForm.id"
                              :form-names="formNames">
                <template v-if="hasEnterpriseForm">
                    <div class="enter-form-group-titlebar">
                        <span class="title">企业信息 <i class="el-icon-d-arrow-right"></i></span>
                    </div>
                    <enterprise-form ref="enterpriseForm"></enterprise-form>
                </template>
                <div class="enter-form-group-titlebar">
                    <span class="title">团队信息 <i class="el-icon-d-arrow-right"></i></span>
                </div>
                <link-team-form ref="linkTeamForm"></link-team-form>
                <div class="enter-form-group-titlebar">
                    <span class="title">项目信息 <i class="el-icon-d-arrow-right"></i></span>
                </div>
                <link-project-form is-admin ref="linkProjectForm"></link-project-form>
                <el-dialog
                        title="入驻场地要求"
                        :visible.sync="dialogVisibleBase"
                        width="520px"
                        :close-on-click-modal="false"
                        :before-close="handleCloseBase">
                    <pw-site-form ref="pwSiteForm"></pw-site-form>
                    <span slot="footer" class="dialog-footer">
                            <el-button type="primary" size="mini" :disabled="disabled" @click.stop.prevent="validateBaseForm">确 定</el-button>
                     </span>
                </el-dialog>
                <div class="text-center enter-form-group-btns">
                    <el-button size="mini" :disabled="disabled"  @click.stop.prevent="goToFirstStep">上一步</el-button>
                    <el-button size="mini" :disabled="disabled" type="primary" @click.stop.prevent="saveForm">保存</el-button>
                    <el-button type="primary" :disabled="disabled" size="mini" @click.stop.prevent="submitForm">提交</el-button></div>
            </enter-form-group>
        </template>
    </div>

</div>


<script type="text/javascript">

    'use strict';

    new Vue({
        el: '#app',
        data: function () {
            var pwEnter = JSON.parse(JSON.stringify(${fns: toJson(pwEnter)})) || {};
            var user = pwEnter.applicant || {};
            return {
                pwApplyForm: {
                    id: pwEnter.id,
                    type: pwEnter.type,
                    isTemp: pwEnter.isTemp || '1',
                    declarePhoto: pwEnter.declarePhoto,
                    parentId: pwEnter.parentId,
                    declareId: user.id,
                    isShow: pwEnter.isShow || '1',
                    applicant: {
                        id: user.id
                    },
                    appType: pwEnter.appType || '1',

                },
                pwApplyOneRules: {
                    type: [{required: true, message: '请选择入驻类型', trigger: 'change'}]
                },
                pwEnterTypes: [],
                postParams: {},
                user: user,
                idTypes: [],
                professionals: [],
                disabled: false,
                isSecondStep: false,
                isRender: false,
                dialogVisibleBase: false,

            }
        },
        computed: {
            idTypeEntries: function () {
                return this.getEntries(this.idTypes)
            },
            professionalEntries: function () {
                return this.getEntries(this.professionals, {value: 'id', label: 'name'})
            },
            formTitle: function () {
                return this.isSecondStep ? '填写入驻信息' : '创业人基本信息'
            },
            formNames: function () {
                var formNames = ['LinkTeamForm', 'LinkProjectForm'];
                if(this.hasEnterpriseForm){
                    formNames.push('EnterpriseForm')
                }
                return formNames;
            },
            hasEnterpriseForm: function () {
                return this.pwApplyForm.type === '2'
            }
        },
        methods: {

            handleCloseBase: function () {
                this.dialogVisibleBase = false;
            },

            validateBaseForm: function () {
                var self = this;
                this.$refs.pwSiteForm.$refs.pwSiteForm.validate(function (valid) {
                    if(valid){
                        Object.assign(self.postParams, self.$refs.pwSiteForm.$data.pwSiteForm)
                        self.submitPwApplyForm(self.postParams);
                    }
                })
            },



            goToStep: function () {
                this.isRender = true;
                this.isSecondStep = true;
            },

            getPwEnterTypes: function () {
                var self = this;
                this.$axios.get('/pw/pwEnter/getPwEnterTypes').then(function (response) {
                    var data = response.data;
                    self.pwEnterTypes = data || [];
                })
            },

            idPhotoSuccess: function (response, file) {
                if (response.state === 'SUCCESS') {
                    this.pwApplyForm.declarePhoto = response.ftpUrl;
                    return
                }
                this.$message.error("登记照上传失败，请重新上传")
            },

            idPhotoError: function (error) {
                this.$message.error(this.xhrErrorMsg)
            },

            getIdTypes: function () {
                var self = this;
                this.$axios.get('/sys/dict/getDictList?type=id_type').then(function (response) {
                    self.idTypes = response.data || [];
                })
            },

            getProfessionals: function () {
                var self = this;
                this.$axios.get('/sys/office/getOrganizationList').then(function (response) {
                    var data = response.data || [];
                    self.professionals = data.filter(function (item) {
                        return item.grade === '3';
                    })
                })
            },

            goToFirstStep: function () {
                this.isSecondStep = false;
            },

            saveForm: function () {
                this.pwApplyForm.isTemp = '1';
                this.enterFormGroupPromise();
            },

            enterFormGroupPromise: function () {
                var self = this;
                this.$refs.enterFormGroup.saveEnterForm().then(function (data) {
                    var pwApplyForm = JSON.parse(JSON.stringify(self.pwApplyForm));
                    var postParams = Object.assign(pwApplyForm, data);
                    postParams.team = {id: pwApplyForm.teamId};
                    self.postParams = postParams;
                    self.submitPwApplyForm(postParams);
                }).catch(function (error) {
                    self.$alert('请检查表单是否合格，在进行保存', '提示', {
                        type: 'warning'
                    })
//                    console.log('error', error)
                })
            },

            submitForm: function () {
                var self = this;
                this.pwApplyForm.isTemp = '0';

                this.$refs.enterFormGroup.saveEnterForm().then(function (data) {
                    var pwApplyForm = JSON.parse(JSON.stringify(self.pwApplyForm));
                    var postParams = Object.assign(pwApplyForm, data);
                    postParams.team = {id: pwApplyForm.teamId};
                    self.postParams = postParams;
                    self.dialogVisibleBase = true;
                }).catch(function (error) {
//                    console.log('error', error)
                    self.$alert('请检查表单是否合格，在进行提交', '提示', {
                        type: 'warning'
                    })
                })
            },

            submitPwApplyForm: function (params) {
                var self = this;
                this.disabled = true;
                var isTemp =  this.pwApplyForm.isTemp;
                this.disabled = true;
                this.$axios.post('/pw/pwEnter/ajaxPwEnterApplySave', params).then(function (response) {
                    var data = response.data;
                    if (data.status === 1) {
                        self.pwApplyForm.id = data.data.id;
                        self.dialogVisibleBase = false;
                        self.$msgbox({
                            type: 'success',
                            title: '提示',
                            closeOnClickModal: false,
                            closeOnPressEscape: false,
                            confirmButtonText: '确定',
                            showClose: false,
                            message: '入驻申报'+(isTemp == '0' ? '提交' : '保存')+'成功'
                        }).then(function () {
                            if(isTemp == '0'){
                                location.href = '/f/pw/pwEnterRel/list';
                            }
                        }).catch(function () {
                        });
                    }else {
                        self.$alert(data.msg, "提示", {
                            type: 'warning'
                        });
                    }
                    self.disabled = false;
                }).catch(function (error) {
                    self.$message.error(self.xhrErrorMsg);
                    self.disabled = false;
                })
            }
        },
        created: function () {
            this.getIdTypes();
            this.getPwEnterTypes();
            this.getProfessionals();
        }
    })

</script>
</body>
</html>
