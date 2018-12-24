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
<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60">
    <div class="mgb-20">
        <edit-bar second-name="添加"></edit-bar>
    </div>
    <el-form :model="actYwForm" ref="actYwForm" :rules="actYwRules" size="mini" label-width="120px" :disabled="disabled"
             style="max-width: 1100px;">
        <el-form-item label="关联流程：" prop="groupId">
            <el-select v-model="actYwForm.groupId" filterable placeholder="请选择" @change="handleChangeGroupId">
                <el-option v-for="item in actYwGroups" :key="item.id" :value="item.id" :label="item.name"></el-option>
            </el-select>
        </el-form-item>
        <el-form-item :label="proProjectTypeName+'类型：'" prop="proProjectType">
            <el-select v-model="actYwForm.proProjectType" filterable placeholder="请选择" @change="handleChangeProType">
                <el-option v-for="item in proGContestTypes" :key="item.value" :value="item.value"
                           :label="item.label"></el-option>
            </el-select>
            <el-button icon="el-icon-circle-plus-outline" @click.stop.prevent="addDictType">添加类型</el-button>
        </el-form-item>
        <el-form-item :label="proProjectTypeName+'类别：'" prop="proCategorys" @change="handleChangeProCategory">
            <el-select
                    v-model="actYwForm.proCategorys"
                    multiple
                    filterable
                    default-first-option
                    style="width: 500px;"
                    placeholder="请选择">
                <el-option
                        v-for="item in proCategories" :key="item.value" :value="item.value" :label="item.label">
                </el-option>
            </el-select>
            <el-button icon="el-icon-circle-plus-outline" @click.stop.prevent="addDictCategory">添加类别</el-button>
        </el-form-item>
        <el-form-item prop="year" label="项目年份：">
            <el-date-picker
                    v-model="actYwForm.year"
                    @change="handleChangeYear"
                    type="year"
                    value-format="yyyy"
                    placeholder="选择年份">
            </el-date-picker>
        </el-form-item>
        <el-form-item prop="daterange" label="项目时间：">
            <el-date-picker
                    v-model="actYwForm.daterange"
                    @change="handleChangeProDate"
                    type="daterange"
                    unlink-panels
                    range-separator="至"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期"
                    value-format="yyyy-MM-dd HH:mm:ss">
            </el-date-picker>
        </el-form-item>
        <el-form-item label="流程节点时间：">
            <el-table v-loading="timeLoading" :data="actYwForm.actYwGtimeList" size="small"
                      class="table table-act-yw-time"
                      style="width: 960px;" border>
                <el-table-column label="流程节点" width="160">
                    <template slot-scope="scope">
                        {{scope.row.gnode ? scope.row.gnode.name : ''}}
                    </template>
                </el-table-column>
                <el-table-column label="有效期" width="500">
                    <template slot-scope="scope">
                        <el-form-item :inline-message="true" :prop="'actYwGtimeList.'+ scope.$index + '.daterange'"
                                      :rules="{ required: true, message: '请选择有效期', trigger: 'change'}" label-width="0"
                                      style="margin-bottom: 0">
                            <el-tooltip class="item" effect="dark" popper-class="white"
                                        :content="scope.row.isApplyDate ? applyDateTip : nodeDateTip" placement="right">
                                <el-date-picker
                                        style="width: 350px;"
                                        v-model="scope.row.daterange"
                                        :type="scope.row.isApplyDate ? 'datetimerange' : 'daterange'"
                                        unlink-panels
                                        range-separator="至"
                                        start-placeholder="开始日期"
                                        end-placeholder="结束日期"
                                        :default-time="scope.row.isApplyDate ? defaultApplyDatetimerange : defaultDatetimerange"
                                        format="yyyy-MM-dd HH:mm:ss"
                                        value-format="yyyy-MM-dd HH:mm:ss">
                                </el-date-picker>
                            </el-tooltip>
                        </el-form-item>
                    </template>
                </el-table-column>
                <el-table-column label="导入导出模板">
                    <template slot-scope="scope">
                        <el-form-item v-if="!scope.row.isApplyDate" :inline-message="true"
                                      :prop="'actYwGtimeList.'+ scope.$index + '.excelTplPath'"
                                      label-width="0" style="margin-bottom: 0">
                            <el-select placeholder="请选择" v-model="scope.row.excelTplPath"
                                       clearable filterable
                                       :disabled="!scope.row.hasTpl">
                                <el-option v-for="expType in expTypes" :key="expType.tplpext + expType.tplname"
                                           :value="expType.tplpext + expType.tplname" :label="expType.name"></el-option>
                            </el-select>
                            <el-checkbox v-model="scope.row.hasTpl">是</el-checkbox>
                        </el-form-item>
                        <div v-else>-</div>
                    </template>
                </el-table-column>
            </el-table>
        </el-form-item>

        <el-form-item>
            <el-button type="primary" @click.stop.prevent="validateForm">保存</el-button>
            <el-button @click.stop.prevent="goToBack">返回</el-button>
        </el-form-item>
    </el-form>


    <el-dialog
            title="添加"
            :visible.sync="dialogVisibleDictForm"
            width="520px"
            :close-on-click-modal="false"
            :before-close="handleCloseDictForm">
        <el-form :model="dictForm" ref="dictForm" :rules="dictRules" size="mini" label-width="120px"
                 :disabled="dictDisabled" auto-complete="off" autocomplete="off">
            <el-form-item label="字典类型：">
                {{dialogFormItemLabel}}
            </el-form-item>
            <el-form-item prop="name" label="名称：">
                <el-input v-model="dictForm.name"></el-input>
            </el-form-item>
            <el-form-item prop="sort" label="排序编号：">
                <el-input-number v-model="dictForm.sort" :min="0" :max="100000"></el-input-number>
            </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
    <el-button size="mini" @click.stop.prevent="handleCloseDictForm">取 消</el-button>
    <el-button size="mini" type="primary" @click.stop.prevent="validateDictForm">确 定</el-button>
  </span>
    </el-dialog>
</div>


<script type="text/javascript">

    'use strict';

    new Vue({
        el: '#app',
        data: function () {
            var actYw = JSON.parse(JSON.stringify(${fns: toJson(actYw)})) || {};
            var actYwGroups = JSON.parse(JSON.stringify(${fns: toJson(actYwGroups)})) || [];
            var dictPtypeJson = JSON.parse(JSON.stringify(${fns:toJson(dictPtype)})) || {};
            var dictPctypeJson = JSON.parse(JSON.stringify(${fns: toJson(dictPctype)})) || {};
            var proProject = actYw.proProject || {};
            var menu = proProject.menu || {};
            var category = proProject.category || {};
            return {
                actYwForm: {
                    id: '',
                    isPreRelease: actYw.isPreRelease,
                    'proProject.id': proProject.id,
                    'proProject.menu.id': menu.id,
                    'proProject.category.id': category.id,
                    'proProject.projectName': proProject.name,
                    'actYw.groupId': actYw.groupId,
                    groupId: actYw.groupId,
                    isUpdateYw: false,
                    startDate: '',
                    endDate: '',
                    'proProject.type': proProject.type,
                    'proProjectType': proProject.type,
                    proCategorys: proProject.proCategorys || [],
                    year: proProject.year,
                    'proProject.nodeState': '1',
                    'proProject.imgUrl': '/images/upload.png',
                    'group.flowType': '${actYw.group.flowType}',
                    showTime: '1',
                    daterange: [],
                    actYwGtimeList: [{
                        beginDate: '',
                        endDate: '',
                        gnode: {
                            name: '申报'
                        },
                        daterange: [],
                        isApplyDate: true
                    }],
                },
                disabled: false,
                defaultDatetimerange: ['00:00:00', '23:59:59'],
                defaultApplyDatetimerange: ['00:00:00', '17:00:00'],
                applyDateTip: '建议结束时间选择工作日的工作时间9:00-17:00',
                nodeDateTip: '请选择的时间在上一个节点日期之后',
                actYwGroups: actYwGroups,
                flowType: '${actYw.group.flowType}',
                proGContestTypes: [],
                proCategories: [],
                expTypes: [],
                timeLoading: false,


                cateTypeLabel: '',
                dictPtypeJson: dictPtypeJson,
                dictPctypeJson: dictPctypeJson,
                dialogVisibleDictForm: false,
                dictDisabled: false,
                dictForm: {
                    typeid: '',
                    name: '',
                    sort: ''
                },
                dictRules: {
                    name: [
                        {required: true, message: '请输入字典名称', trigger: 'blur'},
                        {max: 24, message: '请输入1-24位间字符', trigger: 'blur'}
                    ]
                }
            }
        },
        computed: {
            proProjectTypeName: function () {
                return this.flowType === '1' ? '大赛' : '项目'
            },
            dialogFormItemLabel: function () {
                return this.proProjectTypeName + this.cateTypeLabel;
            },


            actYwRules: function () {
                return {
                    groupId: [
                        {required: true, message: '请选择关联流程', trigger: 'change'}
                    ],
                    proProjectType: [
                        {required: true, message: ('请选择' + this.proProjectTypeName + '类型'), trigger: 'change'}
                    ],
                    proCategorys: [
                        {required: true, message: ('请选择' + this.proProjectTypeName + '类别'), trigger: 'change'}
                    ],
                    year: [
                        {required: true, message: '请选择项目年份', trigger: 'change'}
                    ],
                    daterange: [
                        {required: true, message: '请选择项目时间', trigger: 'change'}
                    ]
                }
            }
        },
        methods: {

            handleChangeProDate: function (value) {
                if (value && value.length > 0) {
                    this.actYwForm['proProject.startDate'] = moment(value[0]).format('YYYY-MM-DD HH:mm:ss');
                    this.actYwForm['proProject.endDate'] = moment(value[1]).format('YYYY-MM-DD HH:mm:ss');
                    this.actYwForm.startYearDate = this.actYwForm['proProject.startDate'];
                    this.actYwForm.endYearDate = this.actYwForm['proProject.endDate'];
                } else {
                    this.actYwForm['proProject.startDate'] = '';
                    this.actYwForm['proProject.endDate'] = '';
                    this.actYwForm.startYearDate = '';
                    this.actYwForm.endYearDate = '';
                }
            },
            handleChangeYear: function (value) {
                this.actYwForm['proProject.year'] = value;
            },

            handleChangeProCategory: function (value) {

            },

            goToBack: function () {
                history.go(-1);
            },

            validateForm: function () {
                var self = this;
                this.$refs.actYwForm.validate(function (valid) {
                    if (valid) {
                        var timesIsValid = self.timesIsValid();
                        if (timesIsValid.status === 'error') {
                            self.$alert(timesIsValid.message, '提示', {
                                type: timesIsValid.status
                            });
                            return false;
                        }
                        self.submitActYwForm();
                    }
                })
            },

            //获取所有时间数据
            getAllDateTimes: function () {
                var startDate = this.actYwForm.startDate;
                var endDate = this.actYwForm.endDate;
                var actYwGtimeList = this.actYwForm.actYwGtimeList;
                var dateTimes = [];
                actYwGtimeList.forEach(function (item) {
                    var daterange = item.daterange;
                    var startTime = daterange[0];
                    var endTime = daterange[1];
                    dateTimes.push({
                        name: item.gnode ? item.gnode.name : '',
                        time: moment(startTime).valueOf()
                    });
                    dateTimes.push({
                        name: item.gnode ? item.gnode.name : '',
                        time: moment(endTime).valueOf()
                    });
                });
                dateTimes.unshift({
                    name: '项目开始',
                    time: moment(startDate).valueOf()
                });
                dateTimes.push({
                    name: '项目结束',
                    time: moment(endDate).valueOf()
                });
                return dateTimes;
            },
            //判断时间是否合格
            timesIsValid: function () {
                var dateTimes = this.getAllDateTimes();
                for (var i = 0; i < dateTimes.length - 1; i++) {
                    var item = dateTimes[i];
                    var item2 = dateTimes[i + 1];
                    if (item.time > item2.time) {
                        return {
                            status: 'error',
                            message: item.name + '时间大于' + item2.name + '时间'
                        };
                    }
                }
                return {
                    status: true
                };
            },

            handleChangeProType: function (value) {
                var proGContestTypes = this.proGContestTypes;
                for (var i = 0; i < proGContestTypes.length; i++) {
                    if (proGContestTypes[i].value === value) {
                        this.actYwForm['proProject.projectName'] = proGContestTypes[i].label;
                        break;
                    }
                }
                this.actYwForm['proProject.type'] = value
            },

            submitActYwForm: function () {
                var self = this;
                var params = this.getActYwParams();
                this.disabled = true;
                this.$axios.get('/actyw/actYw/ajaxUserDefinedSave?' + params).then(function (response) {
                    var data = response.data;
                    if (data.status) {
                        self.$msgbox({
                            type: 'success',
                            title: '提示',
                            closeOnClickModal: false,
                            closeOnPressEscape: false,
                            confirmButtonText: '设置编号规则',
                            showCancelButton: true,
                            cancelButtonText: '返回',
                            showClose: false,
                            message: '保存成功'
                        }).then(function () {
                            location.href = '${ctx}/sys/sysNumberRule';
                        }).catch(function () {
                            history.go(-1);
                        });
                    } else {
                        self.$message.error(self.xhrErrorMsg);
                    }
                    self.disabled = false;
                }).catch(function (error) {
                    self.$message.error(self.xhrErrorMsg);
                    self.disabled = false;
                })
            },
            //获取提交参数
            getActYwParams: function () {
                var params = {};
                var paramsStr = [];
                var urlStrParams;
                var actYwForm = this.actYwForm;
                var actYwGtimeList = actYwForm.actYwGtimeList;
                var proCategorys = actYwForm.proCategorys;
                var actYwFormCopy = JSON.parse(JSON.stringify(this.actYwForm));

                proCategorys = proCategorys.map(function (item) {
                    return ['proProject.proCategorys=' + item]
                });
                delete actYwFormCopy.proCategorys;
                delete actYwFormCopy.actYwGtimeList;
//                params.startYearDate = actYwForm.startDate;
//                params.endYearDate = actYwForm.endDate;
                actYwGtimeList.forEach(function (item, index) {
                    if (item.isApplyDate) {
                        params.nodeStartDate = item.daterange[0];
                        params.nodeEndDate = item.daterange[1];
                    } else {
                        params['beginDate' + (index - 1)] = item.daterange[0];
                        params['endDate' + (index - 1)] = item.daterange[1];
                        params['hasTpl' + (index - 1)] = item.hasTpl ? '1' : '0';
                        params['excelTplClazz' + (index - 1)] = item.excelTplClazz;
                        params['excelTplPath' + (index - 1)] = item.excelTplPath;
                        paramsStr.push(("nodeId=" + item.gnodeId));
//                        params['nodeId'+(index - 1)] = item.gnodeId;
//                        params["nodeIds"].push(item.gnodeId)
                    }
                });
                urlStrParams = Object.toURLSearchParams(params);
                urlStrParams += ('&' + Object.toURLSearchParams(actYwFormCopy) + '&' + paramsStr.join('&') + '&' + proCategorys.join('&'));

                return urlStrParams;
            },

            addDictType: function () {
                this.dialogVisibleDictForm = true;
                this.dictForm.typeid = this.dictPtypeJson.id;
                this.cateTypeLabel = '类型';
            },
            addDictCategory: function () {
                this.dialogVisibleDictForm = true;
                this.dictForm.typeid = this.dictPctypeJson.id;
                this.cateTypeLabel = '类别';
            },

            handleCloseDictForm: function () {
                this.$refs.dictForm.resetFields();
                this.dialogVisibleDictForm = false;
            },

            validateDictForm: function () {
                var self = this;
                this.$refs.dictForm.validate(function (valid) {
                    if (valid) {
                        self.submitDictForm();
                    }
                })
            },

            submitDictForm: function () {
                var self = this;
                this.dictDisabled = true;
                this.$axios.get('/sys/dict/addDict?' + Object.toURLSearchParams(this.dictForm)).then(function (response) {
                    var data = response.data;
                    if (data.ret === '1') {
                        self.getProGContestTypes();
                        self.$message.success('添加成功');
                        self.handleCloseDictForm();
                    } else {
                        self.$message.error(data.msg)
                    }
                    self.dictDisabled = false;
                }).catch(function (error) {
                    self.dictDisabled = false;
                    self.$message.error(self.xhrErrorMsg)
                })
            },

            handleChangeGroupId: function (value) {
                this.getNodeTimes(value)
            },

            getNodeTimes: function (groupId) {
                var self = this;
                this.timeLoading = true;
                this.$axios.get('/actyw/actYw/changeModel?id=' + groupId).then(function (response) {
                    var data = response.data || [];
                    self.pushActYwGtimeList(data);
                    self.timeLoading = false;
                }).catch(function (error) {
                    self.timeLoading = false;
                    self.$message.error(self.xhrErrorMsg)
                })
            },

            pushActYwGtimeList: function (data) {
                var list = data.map(function (item) {
                    return {
                        id: item.id,
                        beginDate: '',
                        endDate: '',
                        gnode: {
                            name: item.name
                        },
                        daterange: [],
                        hasTpl: false,
                        gnodeId: item.id,
                        excelTplPath: ''
                    }
                });
                var actYwGtimeList = this.actYwForm.actYwGtimeList;
                actYwGtimeList.splice(1, actYwGtimeList.length - 1);
                this.actYwForm.actYwGtimeList = actYwGtimeList.concat(list)
            },

            getProCategories: function () {
                var self = this;
                this.$axios.get('/sys/dict/getDictList?type=' + this.dictPctypeJson.value).then(function (response) {
                    self.proCategories = response.data || [];
                })
            },

            getCompetitionTypes: function () {
                var self = this;
                this.$axios.get('/sys/dict/getDictList?type=competition_type').then(function (response) {
                    self.proGContestTypes = response.data || [];
                })
            },

            getProjectTypes: function () {
                var self = this;
                this.$axios.get('/sys/dict/getDictList?type=project_style').then(function (response) {
                    self.proGContestTypes = response.data || [];
                })
            },

            getExpTypes: function () {
                var self = this;
                this.$axios.get('/impdata/ajaxExpTypes?isAll=true').then(function (response) {
                    var data = response.data;
                    if (data.status) {
                        data = JSON.parse(data.datas);
                        self.expTypes = data;
                    }
                }).catch(function (error) {

                })
            },

            getProGContestTypes: function () {
                if (this.flowType === '1') {
                    this.getCompetitionTypes();
                } else if (this.flowType === '13') {
                    this.getProjectTypes();
                }
            }
        },

        created: function () {
            this.getProGContestTypes();
            this.getProCategories();
            this.getExpTypes();
        }
    })

</script>


</body>
</html>