/**
 * Created by Administrator on 2018/11/23.
 */


Vue.component('enter-form-group', {
    template: '<div class="enter-form-group"><slot></slot></div>',
    componentName: 'EnterFormGroup',
    props: {
        formNames: Array,
        isAdmin: Boolean,
        pwEnterId: String,
        disabled: Boolean
    },
    data: function () {
        return {
            formGroups: [],
            formErrorMessages: {
                'linkTeamForm': "入驻团队不合格或者不存在，请检查",
                'linkProjectForm': "入驻项目不存在，请检查",
                'enterpriseForm': "入驻企业不合格或者存在部分表单未填写，请检查",
                'pwSiteForm': "场地要求不合格，请检查",
                'LinkTeamFormAdmin': "入驻团队不合格或者不存在，请检查",
            }
        }
    },
    computed: {
        //通过父级找到refs component;
        appComponent: function () {
            var formNames = this.formNames;
            var $parent = this.$parent;
            if (formNames.length === 0) {
                return false;
            }
            while ($parent) {
                if (!$parent) {
                    break;
                }
                var $refs = $parent.$refs;
                if (this.hasFormGroup($refs)) {
                    return $parent;
                } else {
                    $parent = $parent.$parent;
                }
            }
            return false
        },


    },
    methods: {


        updateFormGroups: function () {
            var formNames = this.formNames;
            if (!this.isAdmin) {
                this.formGroups = this.$children.filter(function (item) {
                    return formNames.indexOf(item.$options.componentName) > -1;
                })
                return false;
            }
            if (this.appComponent) {
                this.formGroups = this.getFormGroups(this.appComponent.$refs);
            }
            // this.formGroups = this.getFormGroups();
            // console.log(this.formGroups)
        },
        hasFormGroup: function ($refs) {
            var formNames = this.formNames;
            for (var k in $refs) {
                if ($refs.hasOwnProperty(k)) {
                    var nk = k.replace(/^\w{1}/, function ($1) {
                        return $1.toUpperCase();
                    })
                    if (formNames.indexOf(nk) > -1) {
                        return true;
                    }
                }
            }
            return false;
        },

        getFormGroups: function ($refs) {
            var components = [];
            var formNames = this.formNames;
            for (var k in $refs) {
                if ($refs.hasOwnProperty(k)) {
                    var nk = k.replace(/^\w{1}/, function ($1) {
                        return $1.toUpperCase();
                    })
                    if (formNames.indexOf(nk) > -1) {
                        components.unshift($refs[k])
                    }

                }
            }
            return components;
        },

        getEnterFormData: function (component, componentName) {
            return component.$data[componentName];
        },

        getEnterFormValidatePromise: function () {
            var formGroups = this.formGroups;
            var self = this;
            var promises = [];
            for (var i = 0; i < formGroups.length; i++) {
                var item = formGroups[i];
                var componentName = item.$options.componentName;
                componentName = componentName.replace(/^[A-Z]+/, function ($1, $2) {
                    return $1.toLowerCase();
                });
                if (componentName === 'linkProjectForm') {
                    promises.push(self.promiseLinkProjectForm(item, componentName));
                } else {
                    promises.push(self.validateFormPromise(item, componentName));
                }
            }
            return Promise.all(promises)
        },

        promiseLinkProjectForm: function (item, componentName) {
            var self = this;
            item.$refs[componentName].resetFields();
            return new Promise(function (reslove, reject) {
                if (item.$data.projectList.length === 0) {
                    reject({
                        component: item,
                        formData: item.$data.projectList,
                        error: self.formErrorMessages[componentName]
                    });
                }
                var formGroupData = self.getFormGroupDataByName(item, componentName);
                reslove(formGroupData);
            })
        },

        validateFormPromise: function (item, componentName) {
            var formGroupData;
            var self = this;
            return new Promise(function (resolve, reject) {
                item.$refs[componentName].validate(function (valid) {
                    if (valid) {
                        formGroupData = self.getFormGroupDataByName(item, componentName);
                        resolve(formGroupData);
                    } else {
                        reject({
                            component: item,
                            formData: self.getEnterFormData(item, componentName),
                            error: self.formErrorMessages[componentName]
                        })
                    }
                })
            })
        },

        getFormGroupDataByName: function (item, componentName) {
            var formGroupData = {};
            switch (componentName) {
                case "linkProjectForm":
                    formGroupData['pwProjectList'] = item.projectList.map(function (item) {
                        var id = item.id.indexOf('temp') > -1 ? '' : item.id;
                        return {
                            // eid: eid,
                            id: id,
                            name: item.name,
                            remarks: item.remarks,
                            sysAttachmentList: item.attachMentEntity,
                        }
                    });
                    break;
                case "linkTeamForm":
                    formGroupData["teamId"] = this.getEnterFormData(item, componentName).teamId;
                    formGroupData['stus'] = item.teamData.studentList;
                    formGroupData['teas'] = item.teamData.teacherList;
                    break;
                case "enterpriseForm":
                    var pwCompany = JSON.parse(JSON.stringify(this.getEnterFormData(item, componentName)));
                    var pwCompanySysAttachmentList = pwCompany.sysAttachmentList;
                    pwCompany.sysAttachmentList = pwCompanySysAttachmentList.map(function (item) {
                        return {
                            "uid": item.response ? '' : item.uid,
                            "fileName": item.title,
                            "name": item.title,
                            "suffix": item.type,
                            "url": item.url,
                            "ftpUrl": item.ftpUrl,
                            "fielSize": item.fielSize,
                            "imgType": item.type,
                        }
                    });
                    formGroupData['pwCompany'] = pwCompany
                    break;
                default:
                    Object.assign(formGroupData, this.getEnterFormData(item, componentName));
            }
            return formGroupData;
        },

        getFormGroupData: function () {
            var formGroups = this.formGroups;
            var formGroupData = {};
            for (var i = 0; i < formGroups.length; i++) {
                var item = formGroups[i];
                var componentName = item.$options.componentName;
                componentName = componentName.replace(/^[A-Z]+/, function ($1, $2) {
                    return $1.toLowerCase();
                });
                if (componentName === 'linkProjectForm') {
                    formGroupData['pwProjectList'] = item.projectList.map(function (item) {
                        var id = item.id.indexOf('temp') > -1 ? '' : item.id;
                        return {
                            // eid: eid,
                            id: id,
                            name: item.name,
                            remarks: item.remarks,
                            sysAttachmentList: item.attachMentEntity,
                        }
                    });
                } else if (componentName === 'linkTeamForm') {
                    Object.assign(formGroupData, this.getEnterFormData(item, componentName));
                    formGroupData['stus'] = item.teamData.studentList;
                    formGroupData['teas'] = item.teamData.teacherList;
                } else {
                    var pwCompany = JSON.parse(JSON.stringify(this.getEnterFormData(item, componentName)));
                    var pwCompanySysAttachmentList = pwCompany.sysAttachmentList;
                    pwCompany.sysAttachmentList = pwCompanySysAttachmentList.map(function (item) {
                        return {
                            "uid": item.response ? '' : item.uid,
                            "fileName": item.title,
                            "name": item.title,
                            "suffix": item.type,
                            "url": item.url,
                            "ftpUrl": item.ftpUrl,
                            "fielSize": item.fielSize,
                            "imgType": item.type,
                        }
                    });
                    formGroupData['pwCompany'] = pwCompany
                }
            }
            return formGroupData;
        },

        saveEnterForm: function () {
            var self = this;
            return this.getEnterFormValidatePromise()
        }
    }
})

Vue.component('enterprise-form', {
    template: '<el-form :model="enterpriseForm" :disabled="isDisabled" ref="enterpriseForm" :rules="enterpriseRules" size="mini" label-width="110px"\n' +
    '                 autocomplete="off">\n' +
    '            <el-form-item prop="name" label="企业名称：">\n' +
    '                <el-input name="name" v-model="enterpriseForm.name"></el-input>\n' +
    '            </el-form-item>\n' +
    '            <el-form-item prop="no" label="工商注册号：">\n' +
    '                <el-input name="no" v-model="enterpriseForm.no"></el-input>\n' +
    '            </el-form-item>\n' +
    '            <el-form-item prop="regMoney" label="注册资金：">\n' +
    '                <el-input name="regMoney" v-model.number="enterpriseForm.regMoney" class="w300">\n' +
    '                    <template slot="prepend">￥</template>\n' +
    '                    <template slot="append">万元</template>\n' +
    '                </el-input>\n' +
    '            </el-form-item>\n' +
    '            <el-form-item prop="regMtypes" label="资金来源：">\n' +
    '                <el-checkbox-group v-model="enterpriseForm.regMtypes">\n' +
    '                    <el-checkbox v-for="item in regMtypes" :key="item.value" :label="item.value">{{item.label}}\n' +
    '                    </el-checkbox>\n' +
    '                </el-checkbox-group>\n' +
    '            </el-form-item>\n' +
    '            <el-form-item prop="address" label="注册地址：">\n' +
    '                <el-input name="address" v-model="enterpriseForm.address"></el-input>\n' +
    '            </el-form-item>\n' +
    '            <el-form-item prop="remarks" label="公司主营业务：">\n' +
    '                <el-input name="remarks" type="textarea" :rows="4" v-model="enterpriseForm.remarks"></el-input>\n' +
    '            </el-form-item>\n' +
    '            <el-form-item prop="sysAttachmentList" label="附件：">\n' +
    '                <e-upload-file v-model="enterpriseForm.sysAttachmentList"  @change="handleChangeFiles"\n' +
    '                               action="/ftp/ueditorUpload/uploadTemp?folder=project"\n' +
    '                               :upload-file-vars="{}" tip="上传企业营业执照等证明文件"></e-upload-file>\n' +
    '            </el-form-item>\n' +
    '        </el-form>',
    props: {},
    mixins: [Vue.pwApplyRules],
    componentName: 'EnterpriseForm',
    data: function () {
        var validateEnterpriseName = this.validateEnterpriseName;
        var validateRegMoney = this.validateRegMoney;
        return {
            enterpriseForm: {
                id: '',
                name: '',
                no: '',
                regMoney: '',
                regMtypes: [],
                address: '',
                remarks: '',
                sysAttachmentList: []
            },
            enterpriseRules: {
                name: [
                    {required: true, message: '请输入企业名称', trigger: 'blur'},
                    {min: 3, max: 100, message: '请输入3至100位间字符', trigger: 'blur'},
                    {validator: validateEnterpriseName, trigger: 'blur'}
                ],
                no: [
                    {required: true, message: '请输入工商注册号', trigger: 'blur'},
                    {min: 13, max: 18, message: '请输入13至18位间字符', trigger: 'blur'},
                    {validator: validateEnterpriseName, trigger: 'blur'}
                ],
                regMoney: [
                    {required: true, message: '请输入注册资金', trigger: 'blur'},
                    {validator: validateRegMoney, trigger: 'blur'}
                ],
                regMtypes: [
                    {required: true, message: '请选择资金来源', trigger: 'change'}
                ],
                address: [
                    {required: true, message: '请输入注册地址', trigger: 'blur'},
                    {min: 2, max: 150, message: '请输入2至150位字符', trigger: 'blur'},
                ],
                remarks: [
                    {required: true, message: '请输入公司主营业务', trigger: 'blur'},
                    {max: 300, message: '请输入不大于300位字符', trigger: 'blur'},
                ],
                sysAttachmentList: [
                    {required: true, message: '请上传附件', trigger: 'change'},
                ]
            },
            regMtypes: [],
            disabled: false,
        }
    },
    computed: {
        isDisabled: function () {
            return this.isGroup ? (this._enterFormGroup.disabled || this.disabled) : this.disabled
        },
        isGroup: function () {
            var $parent = this.$parent;
            while ($parent) {
                if ($parent.$options.componentName !== 'EnterFormGroup') {
                    $parent = $parent.$parent;
                } else {
                    this._enterFormGroup = $parent;
                    return true;
                }
            }
            return false;
        },
        pwEnterId: function () {
            return this._enterFormGroup.pwEnterId;
        }
    },
    methods: {
        getRegMtypes: function () {
            var self = this;
            this.$axios.get('/sys/dict/getDictList?type=pw_reg_mtype').then(function (response) {
                self.regMtypes = response.data || [];
            })
        },
        handleChangeFiles: function () {
            this.$refs.enterpriseForm.validateField('sysAttachmentList')
        },
        getPwEnterCompany: function () {
            var self = this;
            this.$axios.get('/pw/pwEnter/ajaxFindPwEnterCompany?pwEnterId=' + this.pwEnterId).then(function (response) {
                var data = response.data;
                if (data.status === 1) {
                    var pageData = data.data || {};
                    var pwCompany = pageData.pwCompany;
                    pwCompany.sysAttachmentList = pwCompany.fileInfo;
                    delete  pwCompany.fileInfo;
                    delete pwCompany.regMtype;
                    Object.assign(self.enterpriseForm, pwCompany);
                    return false;
                }
                self.$message.error(data.msg)
            }).catch(function (error) {
                self.$message.error(self.xhrErrorMsg)
            })
        }
    },
    created: function () {
        this.getRegMtypes();

    },
    mounted: function () {
        if (this._enterFormGroup) {
            this._enterFormGroup.updateFormGroups();
        }
        if (this.pwEnterId) {
            this.getPwEnterCompany();
        }
    },
    destroyed: function () {
        this._enterFormGroup.updateFormGroups();
    }
});

Vue.component('link-project-form', {
    template: '<div class="pw-apply-project">\n' +
    '            <el-form :model="linkProjectForm" ref="linkProjectForm" :rules="linkProjectRules" size="mini" :disabled="isDisabled"\n' +
    '                     label-width="110px" autocomplete="off">\n' +
    '                <el-row>\n' +
    '                    <el-col :span="12">\n' +
    '                        <el-form-item prop="id" label="关联项目：">\n' +
    '                            <el-select v-model="linkProjectForm.id" :disabled="!!editId" name="id" filterable @change="handleChangeLinkProject">\n' +
    '                                <el-option value="-1" label="无"></el-option>\n' +
    '                                <el-option v-for="item in tempProjectMineIds" :key="item.id" :label="item.name" :disabled="projectListNames.indexOf(item.name) > -1"\n' +
    '                                           :value="item.id"></el-option>\n' +
    '                            </el-select>\n' +
    '                        </el-form-item>\n' +
    '                    </el-col>\n' +
    '                    <el-col :span="12">\n' +
    '                        <el-form-item prop="name" label="项目名称：">\n' +
    '                            <el-input name="name" v-model="linkProjectForm.name"></el-input>\n' +
    '                        </el-form-item>\n' +
    '                    </el-col>\n' +
    '                </el-row>\n' +
    '                <el-form-item prop="remarks" label="项目简介：">\n' +
    '                    <el-input name="remarks"  type="textarea" :rows="4" v-model="linkProjectForm.remarks"></el-input>\n' +
    '                </el-form-item>\n' +
    '                <el-form-item prop="attachMentEntity" label="附件：">\n' +
    '                    <e-upload-file v-model="linkProjectForm.attachMentEntity"  @change="changeLinkProjectFile"\n' +
    '                                   action="/ftp/ueditorUpload/uploadTemp?folder=project"\n' +
    '                                   :upload-file-vars="{}"></e-upload-file>\n' +
    '                </el-form-item>\n' +
    '            </el-form>\n' +
    '            <div class="action-bar">\n' +
    '                <el-button class="btn-add" type="primary" :disabled="isDisabled" size="mini" @click.stop.prevent="addProjectToList"><i class="el-icon-circle-plus el-icon--left"></i>添加项目到列表\n' +
    '                </el-button>\n' +
    '                <span class="pro-table-label">项目列表：</span>\n' +
    '            </div>\n' +
    '            <div class="table-container"><el-table :data="projectList" border size="mini" class="table">\n' +
    '                <el-table-column prop="name" label="项目名称" width="300">\n' +
    '                    <template slot-scope="scope">\n' +
    '                        <el-tooltip class="item" effect="dark" :content="scope.row.name" popper-class="white"\n' +
    '                                    placement="right">\n' +
    '                            <span>{{scope.row.name | textEllipsis(20)}}</span>\n' +
    '                        </el-tooltip>\n' +
    '                    </template>\n' +
    '                </el-table-column>\n' +
    '                <el-table-column label="项目简介">\n' +
    '                    <template slot-scope="scope">\n' +
    '                        {{scope.row.remarks | textEllipsis(80)}}\n' +
    '                    </template>\n' +
    '                </el-table-column>\n' +
    '                <el-table-column label="附件" align="left">\n' +
    '                    <template slot-scope="scope"> <e-file-item v-for="item in scope.row.attachMentEntity" :key="item.uid" :file="item" size="mini" :show="false"></e-file-item></template>\n' +
    '                </el-table-column>\n' +
    '                <el-table-column label="操作" align="center" width="128">\n' +
    '                    <template slot-scope="scope"><el-button  v-if="isAdmin" :disabled="isDisabled || (scope.row.status && scope.row.status !== \'0\')" icon="el-icon-edit" size="mini" @click.stop.prevent="editProject(scope.row, scope.$index)"></el-button>\n' +
    '                        <el-button :disabled="isDisabled  || (scope.row.status && scope.row.status !== \'0\')" icon="el-icon-delete" size="mini"\n' +
    '                                   @click.stop.prevent="projectList.splice(scope.row.index, 1)"></el-button>\n' +
    '                    </template>\n' +
    '                </el-table-column>\n' +
    '            </el-table></div>\n' +
    '        </div>',
    mixins: [Vue.pwApplyRules],
    componentName: 'LinkProjectForm',
    props: {
        isAdmin: Boolean,
        status: String
    },
    data: function () {
        var self = this;
        var validateNames = function (rule, value, callback) {
            if (value) {
                if (self.specificSymbol.test(value)) {
                    return callback(new Error("请不要输入特殊符号"))
                } else if (self.projectListNames.indexOf(value) > -1 && self.projectListIds.indexOf(self.linkProjectForm.id) === -1) {
                    return callback(new Error("项目名称已经存在"))
                }
                return callback();
            }
            return callback();
        };
        return {
            linkProjectForm: {
                id: '-1',
                // eid: '-1',
                name: '',
                remarks: '',
                attachMentEntity: []
            },
            linkProjectRules: {
                name: [
                    {required: true, message: '请输入项目名称', trigger: 'blur'},
                    {max: 128, message: '请输入不大于128位间字符', trigger: 'blur'},
                    {validator: validateNames, trigger: 'blur'}
                ],
                remarks: [
                    {required: true, message: '请输入公司主营业务', trigger: 'blur'},
                    {max: 200, message: '请输入不大于200位字符', trigger: 'blur'},
                ],
                attachMentEntity: [
                    {required: true, message: '请上传附件', trigger: 'change'},
                ]
            },
            projectList: [],
            linkProjectPropDisabled: false,
            linkProjectDisabled: false,
            projectMines: [],
            editId: '',
            editIndex: -1
        }
    },
    computed: {
        tempProjectMineIds: function () {
            var projectMines = JSON.parse(JSON.stringify(this.projectMines));
            if (this.editId) {
                projectMines.push(this.projectList[this.editIndex]);
            }
            return projectMines;
        },

        projectMineIds: function () {
            return this.projectMines.map(function (item) {
                return item.id
            })
        },

        projectListNames: function () {
            return this.projectList.map(function (item) {
                return item.name
            })
        },

        projectListIds: function () {
            return this.projectList.map(function (item) {
                return item.id
            })
        },

        isDisabled: function () {
            return this.isGroup ? (this._enterFormGroup.disabled || this.linkProjectDisabled) : this.disabled
        },
        isGroup: function () {
            var $parent = this.$parent;
            while ($parent) {
                if ($parent.$options.componentName !== 'EnterFormGroup') {
                    $parent = $parent.$parent;
                } else {
                    this._enterFormGroup = $parent;
                    return true;
                }
            }
            return false;
        },
        pwEnterId: function () {
            return this._enterFormGroup.pwEnterId;
        },
    },
    methods: {
        getProject: function (value) {
            var self = this;
            var projectMine = this.getProjectMine(value);
            Object.assign(self.linkProjectForm, projectMine);
        },

        getProjectMine: function (value) {
            for (var i = 0; i < this.projectMines.length; i++) {
                var item = this.projectMines[i];
                if (item.id === value) {
                    return JSON.parse(JSON.stringify(item));
                }
            }
            return false;
        },

        getProjectList: function () {
            var self = this;
            this.$axios.get('/pw/pwEnter/ajaxFindPwEnterProjects?pwEnterId=' + this.pwEnterId).then(function (response) {
                var data = response.data;
                if (data.status === 1) {
                    var pageData = data.data || {};
                    var pwProjectList = pageData.pwProjectList || [];
                    var status = self.status;
                    self.projectList = pwProjectList.map(function (item) {
                        return {
                            id: item.id,
                            // eid: item.id,
                            status: status,
                            name: item.name,
                            remarks: item.remarks,
                            attachMentEntity: item.fileInfo || []
                        }
                    });
                    return false;
                }
                self.$message.error(data.msg)
            }).catch(function (error) {
                self.$message.error(self.xhrErrorMsg)
            })
        },

        getProjectMines: function () {
            var self = this;
            this.$axios.get('/pw/pwEnter/ajaxGetProjects').then(function (response) {
                var data = response.data;
                if (data.status === 1) {
                    var projectMines = data.data || [];
                    projectMines = projectMines.map(function (item) {
                        var attachMentEntity = item.fileInfo || [];
                        attachMentEntity = attachMentEntity.map(function (item) {
                            item.remotePath = '';
                            return item;
                        });
                        return {
                            id: item.id,
                            // eid: item.id,
                            name: item.pName,
                            remarks: item.introduction,
                            attachMentEntity: attachMentEntity
                        }
                    })
                    self.projectMines = projectMines;
                }
            })
        },

        handleChangeLinkProject: function (value) {
            this.linkProjectPropDisabled = value !== '-1';
            if (this.linkProjectPropDisabled) {
                this.getProject(value);
                this.$refs.linkProjectForm.clearValidate();
            } else {
                this.$refs.linkProjectForm.resetFields();
            }

        },

        addProjectToList: function () {
            var self = this;
            this.$refs.linkProjectForm.validate(function (valid) {
                if (valid) {
                    if (self.editId) {
                        self.projectList.splice(self.editIndex, 1, JSON.parse(JSON.stringify(self.linkProjectForm)));
                        self.$refs.linkProjectForm.resetFields();
                        self.editId = '';
                        self.editIndex = -1;
                    } else {
                        self.postProject();
                    }
                }
            })
        },


        postProject: function () {
            this.linkProjectDisabled = true;
            var linkProjectForm = JSON.parse(JSON.stringify(this.linkProjectForm));
            var attachMentEntity = linkProjectForm.attachMentEntity;
            linkProjectForm.attachMentEntity = attachMentEntity.map(function (item) {
                return {
                    fileName: item.name,
                    name: item.name,
                    suffix: item.type,
                    "uid": item.response ? '' : item.uid,
                    url: item.url,
                    ftpUrl: item.ftpUrl,
                    fielSize: item.size,
                    // fielTitle: item.name,
                    // fielType: item.type,
                    // fielFtpUrl: item.ftpUrl,
                    imgType: item.type,
                    // fileTypeEnum: '13',
                    // fileStepEnum: '1301',
                    // gnodeId: ''
                }
            })
            // linkProjectForm.eid = (this.projectList.length + 1) + 'temp';
            linkProjectForm.id = (this.projectList.length + 1) + 'temp';
            this.projectList.push(linkProjectForm);
            this.linkProjectDisabled = false;
            this.linkProjectPropDisabled = false;
            this.$refs.linkProjectForm.resetFields();
        },

        changeLinkProjectFile: function () {
            this.$refs.linkProjectForm.validateField('attachMentEntity');
        },

        editProject: function (row, $index) {
            this.editId = row.id;
            this.editIndex = $index;
            Object.assign(this.linkProjectForm, row);
        }
    },
    created: function () {

    },
    mounted: function () {
        if (this._enterFormGroup) {
            this._enterFormGroup.updateFormGroups();
        }
        this.getProjectMines();
        if (this.pwEnterId) {
            this.getProjectList();
        }
    }
})


Vue.component('link-team-form', {
    template: '<div class="link-team-form"><el-form :model="linkTeamForm" ref="linkTeamForm" :rules="linkTeamRules" size="mini" label-width="110px" :disabled="isDisabled">' +
    '<template v-if="!isAdmin"><el-form-item  prop="teamId" label="选择团队：">' +
    '<el-select v-model="linkTeamForm.teamId" clearable>' +
    '<el-option v-for="item in teamList" :key="item.id" :value="item.id" :label="item.name"></el-option>' +
    '</el-select><template v-if="teamList.length === 0" style="display: none"><span class="el-form-item-expository">暂无团队，请去<a href="/f/team/indexMyTeamList">创建团队</a>吧</span></template></el-form-item></template>' +
    '<template v-else><el-form-item label="团队名称：">{{linkTeamForm.name}}</el-form-item><el-form-item label="团队介绍：">{{linkTeamForm.summary}}</el-form-item></template></el-form>' +
    '<update-member :is-admin="isAdmin" :declare-id="declareId" v-if="(teamList.length > 0 && linkTeamForm.teamId) || isAdmin" :disabled="isDisabled" :team-id="linkTeamForm.teamId" :saved-team-url="savedTeamUrl" @change="handleChangeTeam"></update-member></div>',
    props: {
        isAdmin: Boolean
    },
    data: function () {
        var self = this;
        var validateTeam = function (rules, value, callback) {
            if (value) {
                var teamId = self.linkTeamForm.teamId;
                return self.$axios.post('/pw/pwEnter/checkPwEnterTeam', {
                    id: self.pwEnterId,
                    team: {
                        id: teamId
                    }
                }).then(function (response) {
                    var data = response.data;
                    if (data) {
                        return callback()
                    }
                    return callback(new Error("当前团队已提交入驻申请，请重新选择"))
                }).catch(function (error) {
                    return callback(new Error("请求失败"));
                })
            }
            return callback();
        }
        return {
            linkTeamForm: {
                teamId: '',
                name: '',
                summary: '',
                sponsor: ''
            },
            linkTeamRules: {
                teamId: [
                    {required: true, message: '请选择团队', trigger: 'change'},
                    {validator: validateTeam, trigger: 'change'}
                ]
            },
            teamList: [],
            teamData: {}
        }
    },
    componentName: 'LinkTeamForm',
    computed: {
        savedTeamUrl: function () {
            if(this.pwEnterId){
                return '/pw/pwEnter/ajaxFindPwEnterTeam?pwEnterId='+ this.pwEnterId;
            }
            return false;
        },
        isDisabled: function () {
            return this.isGroup ? (this._enterFormGroup.disabled || this.linkProjectDisabled) : this.disabled
        },
        isGroup: function () {
            var $parent = this.$parent;
            while ($parent) {
                if ($parent.$options.componentName !== 'EnterFormGroup') {
                    $parent = $parent.$parent;
                } else {
                    this._enterFormGroup = $parent;
                    return true;
                }
            }
            return false;
        },
        pwEnterId: function () {
            return this._enterFormGroup.pwEnterId;
        },
        declareId: function () {
            if (this.linkTeamForm.sponsor) {
                return this.linkTeamForm.sponsor;
            }
            if (!this.linkTeamForm.teamId) {
                return '';
            }
            for (var i = 0; i < this.teamList.length; i++) {
                var team = this.teamList[i];
                if (team.id === this.linkTeamForm.teamId) {
                    return team.sponsor;
                }
            }
            return '';
        }
    },
    methods: {
        getTeamList: function () {
            var self = this;
            this.$axios.get('/pw/pwEnter/ajaxGetTeams').then(function (response) {
                var data = response.data;
                self.teamList = data.data || []
            })
        },


        getPwEnterTeam: function () {
            var self = this;
            this.$axios.get('/pw/pwEnter/ajaxFindPwEnterTeam?pwEnterId=' + this.pwEnterId).then(function (response) {
                var data = response.data;
                if (data.status === 1) {
                    var team = data.data.team;
                    self.linkTeamForm.teamId = team.id;
                    self.linkTeamForm.name = team.name;
                    self.linkTeamForm.summary = team.summary;
                    self.linkTeamForm.sponsor = team.sponsor;
                    return false;
                }
                self.$message.error(data.msg)
            }).catch(function (error) {
                self.$message.error(self.xhrErrorMsg);
            })
        },

        handleChangeTeam: function (data) {
            this.teamData = data;
        }
    },
    mounted: function () {
        if (this._enterFormGroup) {
            this._enterFormGroup.updateFormGroups();
        }
        if (this.pwEnterId) {
            this.getPwEnterTeam();
        }
        if (!this.isAdmin) {
            this.getTeamList();
        }
    }

})


Vue.component('pw-site-form', {
    template: '<el-form :model="pwSiteForm" ref="pwSiteForm" :disabled="isDisabled" :rules="pwSiteRules" size="mini" autocomplete="off" label-width="120px">\n' +
    '            <el-form-item prop="expectWorkNum" label="是否需要工位：">\n' +
    '                <el-col :span="15">\n' +
    '                    <el-input type="number" :disabled="!hasExpectWorkNum" v-model.number="pwSiteForm.expectWorkNum">\n' +
    '                        <template slot="append">位</template>\n' +
    '                    </el-input>\n' +
    '                </el-col>\n' +
    '                <el-col :span="2">\n' +
    '                    <div style="min-height: 1px"></div>\n' +
    '                </el-col>\n' +
    '                <el-col :span="7">\n' +
    '                    <el-checkbox v-model="hasExpectWorkNum" @change="handleChangeHasExpectWorkNum">是</el-checkbox>\n' +
    '                </el-col>\n' +
    '            </el-form-item>\n' +
    '            <el-form-item prop="expectTerm" label="预计孵化期：">\n' +
    '                <el-input type="number" v-model.number="pwSiteForm.expectTerm" style="width: 224px;">\n' +
    '                    <template slot="append">年</template>\n' +
    '                </el-input>\n' +
    '            </el-form-item>\n' +
    '            <el-form-item prop="expectRemark" label="备注：">\n' +
    '                <el-input :rows="3" type="textarea" v-model="pwSiteForm.expectRemark"></el-input>\n' +
    '            </el-form-item>\n' +
    '        </el-form>',
    componentName: 'PwSiteForm',
    props: {
        isAdmin: Boolean
    },
    computed: {
        isDisabled: function () {
            return this.isGroup ? (this._enterFormGroup.disabled || this.linkProjectDisabled) : this.disabled
        },
        isGroup: function () {
            var $parent = this.$parent;
            while ($parent) {
                if ($parent.$options.componentName !== 'EnterFormGroup') {
                    $parent = $parent.$parent;
                } else {
                    this._enterFormGroup = $parent;
                    return true;
                }
            }
            return false;
        },
        pwEnterId: function () {
            return this._enterFormGroup.pwEnterId;
        }
    },
    data: function () {
        var self = this;
        var validateExpectWorkNum = function (rules, value, callback) {
            if (value > -1 && value <= 20000 && !(/\./.test(value))) {
                return callback();
            }
            return callback(new Error("请输入不大于20000的正整数"))
        };
        var validateExpectTerm = function (rules, value, callback) {
            if (value > -1 && value <= 10) {
                return callback();
            }
            return callback(new Error("请输入不大于10的数值"))
        }
        return {
            pwSiteForm: {
                expectWorkNum: 0,
                expectTerm: 0,
                expectRemark: ''
            },
            pwSiteRules: {
                expectWorkNum: [
                    {required: true, message: '请输入需要工位数', trigger: 'blur'},
                    {validator: validateExpectWorkNum, trigger: 'blur'}
                ],
                expectTerm: [
                    {required: true, message: '请输入预计孵化期年数', trigger: 'blur'},
                    {validator: validateExpectTerm, trigger: 'blur'}
                ],
                expectRemark: [
                    {max: 125, message: '请输入不大于125个字符', trigger: 'blur'}
                ]
            },
            hasExpectWorkNum: true
        }
    },
    methods: {
        handleChangeHasExpectWorkNum: function (value) {
            if (!value) {
                this.pwSiteForm.expectWorkNum = 0;
            }
        },
        getPwEnterSpace: function () {
            var self = this;
            this.$axios.get('/pw/pwEnter/ajaxFindPwEnterPwSpace?pwEnterId=' + this.pwEnterId).then(function (response) {
                var data = response.data;
                if (data.status === 1) {
                    var pwEnter = data.data || {};
                    self.pwSiteForm = {
                        expectWorkNum: pwEnter.expectWorkNum,
                        expectTerm: pwEnter.expectTerm,
                        expectRemark: pwEnter.expectRemark
                    }
                }
            }).catch(function () {
                self.$message.error(self.xhrErrorMsg);
            })
        }
    },
    mounted: function () {
        if (this.pwEnterId) {
            this.getPwEnterSpace();
        }
        if (this._enterFormGroup && this.isAdmin) {
            this._enterFormGroup.updateFormGroups();
        }
    }
})