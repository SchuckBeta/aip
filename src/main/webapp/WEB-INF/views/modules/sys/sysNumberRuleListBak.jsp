<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>

    <style>
        .app-rule-item {
            width: 460px;
        }

        /*.app-rule-item:first-child {*/
        /*padding-top: 20px;*/
        /*}*/

        .app-rule-item .empty-color {
            line-height: 28px;
            font-size: 12px;
        }

        .el-button--mini .iconfont {
            font-size: 12px;
        }

        .app-rule-item .el-button + .el-button {
            margin-left: 6px;
        }

        .app-type-name {
            font-size: 12px;
            line-height: 68px;
            min-height: 68px;
        }

        .app-rule-item .app-rule-item-inner {
            height: 28px;
            font-size: 0;
            margin-bottom: 20px;
        }

        .app-rule-item .rule-label {
            display: inline-block;
            width: 130px;
            line-height: 28px;
            font-size: 12px;
            vertical-align: top;
        }

        .app-rule-item .rule-static {
            display: inline-block;
            font-size: 12px;
            line-height: 28px;
            vertical-align: top;
        }

        .app-rule-item .rule-static > span {
            margin-right: 6px;
        }
    </style>
</head>
<body>

<div id="app" class="container-fluid container-fluid_bg" v-show="pageLoad" style="display: none">
    <edit-bar></edit-bar>
    <div class="search-block_bar clearfix">
        <div class="search-input">
            <%--<el-cascader ref="cascader"--%>
            <%--:options="appTypeTree"--%>
            <%--size="mini"--%>
            <%--:clearable="true"--%>
            <%--:props="{--%>
            <%--label:'text',--%>
            <%--value: 'id',--%>
            <%--children: 'childList'--%>
            <%--}"--%>
            <%--v-model="selectedAppRuleIds"--%>
            <%--@change="handleChange">--%>
            <%--</el-cascader>--%>
            <el-button type="primary" size="mini" @click.stop.prevent="dialogVisible = true">新建编号规则</el-button>
        </div>
    </div>
    <div class="table-container">
        <table class="table table-font12 table-center table-new-bordered">
            <thead>
            <tr>
                <th width="180">规则应用</th>
                <th class="text-left" width="480">自定义规则组合</th>
                <th>示例</th>
                <th width="160">操作</th>
            </tr>
            </thead>
            <tr v-for="(appRule, index) in appList">
                <td>
                    <div class="cell">
                        <div class="app-type-name">
                            {{appRule.appTypeName}}
                        </div>
                    </div>
                </td>
                <td>
                    <div style="text-align: left;" class="cell">
                        <div v-show="!appRule.updateRule" class="app-rule-static">
                            <div v-for="(rule, idx) in appRule.sysNumberRuleDetailList" class="app-rule-item">
                                <app-rule-static-inner :app-rule="rule" :rule-type-entries="ruleTypeEntries"
                                                       label-width="80px"
                                                       :dates="dates"></app-rule-static-inner>
                            </div>
                        </div>
                        <template v-if="appRule.updateRule">
                            <el-form :inline="true"
                                     :model="appRuleEditForm"
                                     :disabled="appRuleIsSave"
                                     ref="appRuleEditForm">
                                <div class="app-rule-item" v-for="(rule, index2) in appRuleEditForm.appRules">
                                    <el-form-item size="mini" style="width: 173px;"
                                                  :key="rule.key || rule.id"
                                                  :prop="'appRules.' + index2 + '.ruleType'">
                                        <el-select v-model="rule.ruleType" placeholder="请选择活动区域" style="width: 115px;">
                                            <el-option label="-请选择-" value=""></el-option>
                                            <el-option v-for="ruleType in ruleTypes"
                                                       :disabled="appRuleRuleTypes(appRuleEditForm.appRules).indexOf(ruleType.id) > -1"
                                                       :label="ruleType.value"
                                                       :value="ruleType.id" :key="ruleType.id"></el-option>
                                        </el-select>
                                        <el-button type="text"
                                                   v-show="appRuleEditForm.appRules.length < ruleTypes.length"
                                                   @click.prevent="addRuleType(appRuleEditForm.appRules)"><i
                                                class="iconfont icon-tianjia"></i></el-button>
                                        <el-button type="text" v-show="appRuleEditForm.appRules.length > 1"
                                                   @click.prevent="removeRuleType(appRuleEditForm.appRules, index2)"><i
                                                class="iconfont icon-shanchu"></i></el-button>
                                    </el-form-item>
                                    <template v-if="rule.ruleType == 'FIXED'">
                                        <el-form-item size="mini" :prop="'appRules.' + index2 + '.text'"
                                                      :rules="appRuleFormRules['FIXED']">
                                            <el-input v-model="rule.text" placeholder="请输入值"></el-input>
                                        </el-form-item>
                                    </template>
                                    <template v-if="rule.ruleType == 'RANDOM'">
                                        <el-form-item size="mini" :prop="'appRules.' + index2 + '.numLength'"
                                                      :rules="appRuleFormRules['RANDOM']">
                                            <el-input v-model.number="rule.numLength" placeholder="位数"></el-input>
                                        </el-form-item>
                                    </template>
                                    <template v-if="rule.ruleType == 'LEVEL'">
                                        <el-form-item size="mini">
                                            <span v-show="rule.text">{{rule.text}}</span>
                                            <%--<span class="empty-color" v-show="!rule.text">在项目立项完成后获取项目级别生成该部分</span>--%>
                                        </el-form-item>
                                    </template>
                                    <template v-if="rule.ruleType == 'CUSTOM'">
                                        <el-form-item size="mini" :prop="'appRules.' + index2 + '.text'"
                                                      :rules="appRuleFormRules['CUSTOMTEXT']" style="width: 100px;">
                                            <el-input v-model.number="rule.text" placeholder="开始数"></el-input>
                                        </el-form-item>
                                        <el-form-item size="mini" :prop="'appRules.' + index2 + '.numLength'"
                                                      :rules="appRuleFormRules['CUSTOMNumLength']"
                                                      style="width: 100px;">
                                            <el-input v-model.number="rule.numLength" placeholder="位数"></el-input>
                                        </el-form-item>
                                    </template>
                                    <template v-if="rule.ruleType == 'DATE'">
                                        <el-form-item size="mini" :prop="'appRules.' + index2 + '.nDate'"
                                                      :rules="appRuleFormRules['DATE']">
                                            <el-checkbox-group v-model="rule.nDate">
                                                <el-checkbox-button :label="date.value" v-for="date in dates"
                                                                    :key="date.value">{{date.label}}
                                                </el-checkbox-button>
                                            </el-checkbox-group>
                                        </el-form-item>
                                    </template>
                                </div>
                            </el-form>
                        </template>
                    </div>
                </td>
                <td>
                    <div class="cell">
                        <p v-show="!appRule.updateRule">{{appRule.rule}}</p>
                        <%--<p v-show="appRule.updateRule">{{getUpdateRule()}}</p>--%>
                    </div>
                </td>
                <td>
                    <div class="cell">
                        <el-button type="text" size="mini" :disabled="appRule.updateRule || appRule.isSave"
                                   @click.stop.prevent="updateAppRule(appRule)">编辑
                        </el-button>
                        <el-button type="text" size="mini" :disabled="appRule.updateRule || appRule.isSave"
                                   @click.stop.prevent="removeAppRule(appRule.id, index)">删除
                        </el-button>
                        <el-button type="text" size="mini" :disabled="!appRule.updateRule || appRule.isSave"
                                   @click.stop.prevent="saveAppRule(appRule)">保存
                        </el-button>
                        <el-button type="text" size="mini" :disabled="!appRule.updateRule || appRule.isSave"
                                   @click.stop.prevent="cancelAppRule(appRule)">取消
                        </el-button>
                    </div>
                </td>
            </tr>
            <tr v-show="!appList.length">
                <td colspan="4"><span class="empty-color">没有数据</span></td>
            </tr>
        </table>
    </div>
    <el-dialog
            title="提示"
            :visible.sync="dialogVisible"
            width="50%"
            :before-close="handleClose">
        <div>
            <el-form :inline="true"
                     :model="appRulesForm"
                     label-width="100px"
                     size="mini"
                     auto-complete="off"
                     :disabled="appRuleIsSave"
                     ref="appRulesForm">
                <div class="app-rule-item" style="width: 100%">
                    <el-form-item label="关联项目：" required prop="appType" :rules="appRuleFormRules['appType']">
                        <el-cascader ref="cascader"
                                     :options="appTypeTree"
                                     size="mini"
                                     :clearable="true"
                                     :props="{
                                label:'text',
                                value: 'id',
                                children: 'childList'
                                }"
                                     @change="handleChangeAppType"
                                     v-model="appRulesForm.appType"
                        >
                        </el-cascader>
                    </el-form-item>
                </div>
                <div class="app-rule-item" style="width: 100%">
                    <el-form-item label="规则名称：" align="right" required>
                        <el-input v-model="appRulesForm.appTypeName"></el-input>
                    </el-form-item>
                </div>
                <div class="app-rule-item" style="width: 100%">
                    <el-form-item label="编号规则：">
                        <div class="app-rule-item" v-for="(rule, index2) in appRulesForm.sysNumberRuleDetailList"
                             style="width: 100%">
                            <el-form-item size="mini" style="width: 300px;" :label="index2 | ruleItemLabel"
                                          :key="rule.key || rule.id"
                                          required
                                          :prop="'sysNumberRuleDetailList.' + index2 + '.ruleType'">
                                <el-select v-model="rule.ruleType" placeholder="请选择" style="width: 115px;">
                                    <el-option label="-请选择-" value=""></el-option>
                                    <el-option v-for="ruleType in ruleTypes"
                                               :disabled="appRuleRuleTypes(appRulesForm.sysNumberRuleDetailList).indexOf(ruleType.id) > -1"
                                               :label="ruleType.value"
                                               :value="ruleType.id" :key="ruleType.id"></el-option>
                                </el-select>
                                <el-button type="text"
                                           v-show="appRulesForm.sysNumberRuleDetailList.length < ruleTypes.length"
                                           @click.prevent="addRuleType(appRulesForm.sysNumberRuleDetailList)"><i
                                        class="iconfont icon-tianjia"></i></el-button>
                                <el-button type="text" v-show="appRulesForm.sysNumberRuleDetailList.length > 1"
                                           @click.prevent="removeRuleType(appRulesForm.sysNumberRuleDetailList, index2)">
                                    <i
                                            class="iconfont icon-shanchu"></i></el-button>
                            </el-form-item>
                            <template v-if="rule.ruleType == 'FIXED'">
                                <el-form-item size="mini" :prop="'sysNumberRuleDetailList.' + index2 + '.text'"
                                              :rules="appRuleFormRules['FIXED']">
                                    <el-input v-model="rule.text" placeholder="请输入值"></el-input>
                                </el-form-item>
                            </template>
                            <template v-if="rule.ruleType == 'RANDOM'">
                                <el-form-item size="mini" :prop="'sysNumberRuleDetailList.' + index2 + '.numLength'"
                                              :rules="appRuleFormRules['RANDOM']">
                                    <el-input v-model.number="rule.numLength" placeholder="位数"></el-input>
                                </el-form-item>
                            </template>
                            <template v-if="rule.ruleType == 'LEVEL'">
                                <el-form-item size="mini">
                                    <span v-show="rule.text">{{rule.text}}</span>
                                    <%--<span class="empty-color" v-show="!rule.text">在项目立项完成后获取项目级别生成该部分</span>--%>
                                </el-form-item>
                            </template>
                            <template v-if="rule.ruleType == 'CUSTOM'">
                                <el-form-item size="mini" :prop="'sysNumberRuleDetailList.' + index2 + '.text'"
                                              :rules="appRuleFormRules['CUSTOMTEXT']" style="width: 100px;">
                                    <el-input v-model.number="rule.text" placeholder="开始数"></el-input>
                                </el-form-item>
                                <el-form-item size="mini" :prop="'sysNumberRuleDetailList.' + index2 + '.numLength'"
                                              :rules="appRuleFormRules['CUSTOMNumLength']"
                                              style="width: 100px;">
                                    <el-input v-model.number="rule.numLength" placeholder="位数"></el-input>
                                </el-form-item>
                            </template>
                            <template v-if="rule.ruleType == 'DATE'">
                                <el-form-item size="mini" :prop="'sysNumberRuleDetailList.' + index2 + '.nDate'"
                                              :rules="appRuleFormRules['DATE']">
                                    <el-checkbox-group v-model="rule.nDate">
                                        <el-checkbox-button :label="date.value" v-for="date in dates"
                                                            :key="date.value">{{date.label}}
                                        </el-checkbox-button>
                                    </el-checkbox-group>
                                </el-form-item>
                            </template>
                            <template v-if="rule.ruleType == 'YEAR'">
                                <el-form-item size="mini" :prop="'sysNumberRuleDetailList.' + index2 + '.text'"
                                              :rules="appRuleFormRules['YEAR']">
                                    <el-date-picker
                                            v-model="rule.text"
                                            type="year"
                                            value-format="yyyy"
                                            default-time="00:00:00"
                                            placeholder="选择项目年份">
                                    </el-date-picker>
                                </el-form-item>

                            </template>
                        </div>
                    </el-form-item>
                </div>
            </el-form>
        </div>
        <div slot="footer" class="dialog-footer">
            <el-button size="mini" @click="dialogVisible = false">取 消</el-button>
            <el-button size="mini" type="primary" @click="saveAppRule">确 定</el-button>
        </div>
    </el-dialog>
</div>

<script type="text/javascript">
    +function (Vue) {


        var appRuleStaticInner = Vue.component('app-rule-static-inner', {
            props: {
                appRule: Object,
                ruleTypeEntries: Object,
                dates: Array,
                labelWidth: String
            },
            data: function () {
                return {}
            },
            methods: {

                getDatesLabel: function (text) {
                    if (!text) {
                        return;
                    }
                    var nText = [];
                    for (var i = 0; i < this.dates.length; i++) {
                        var value = this.dates[i].value;
                        if (text.indexOf(value) > -1) {
                            nText.push(this.dates[i].label)
                        }
                    }
                    return nText.join('-');
                },

                renderLabel: function (createElement) {
                    var ruleType = this.appRule.ruleType;
                    var ruleLabel = this.ruleTypeEntries[ruleType];
                    return createElement('label', {
                        'class': {
                            'rule-label': true
                        },
                        'style': {
                            width: this.labelWidth
                        }
                    }, ruleLabel + '：')
                },
                renderStatic: function (createElement) {
                    return createElement('div', {
                        'class': {
                            'rule-static': true
                        }
                    }, [this.renderStaticInner(createElement)])
                },
                renderStaticInner: function (createElement) {
                    var text;
                    var ruleType = this.appRule.ruleType;
                    switch (ruleType) {
                        case 'FIXED':
                            text = this.appRule.text;
                            break;
                        case 'DATE':
                            text = this.getDatesLabel(this.appRule.text);
                            break;
                        case 'RANDOM':
                            text = ('位数：' + this.appRule.numLength);
                            break;
                        case 'CUSTOM':
                            text = ('开始数：' + this.appRule.text + '，位数：' + this.appRule.numLength);
                            break;
                        case 'LEVEL':
//                            text = '在项目立项完成后获取项目级别生成该部分';
                            break;
                    }
                    return createElement('p', {}, text)
                }
            },
            render: function (createElement) {
                var renderStatic = this.renderStatic(createElement);
                return createElement('div', {
                    'class': {
                        'app-rule-item-inner': true
                    }
                }, [this.renderLabel(createElement), renderStatic])
            }

        });


        var app = new Vue({
            el: '#app',
            data: function () {
                var appList = '${fns: toJson(page.list)}';
                appList = JSON.parse(appList);
                var self = this;
                var validateFixedText = function (rule, value, callback) {
                    if (value === '') {
                        callback(new Error('请输入值'));
                    } else {
                        if (!(/^[a-zA-Z0-9]+$/.test(value))) {
                            callback(new Error('请输入英文或者字母'));
                        } else {
                            callback();
                        }
                    }
                };
                var validateRANDOMNum = function (rule, value, callback) {
                    if (value === '') {
                        callback(new Error('请输入数字'));
                    } else {
                        if (!(value >= 0 && value <= 12 && /^[0-9]+$/.test(value))) {
                            callback(new Error('请输入0-12之间的整位数'));
                        } else {
                            callback();
                        }
                    }
                };

                var validateCUSTOMNum = function (rule, value, callback) {
                    var fullField = rule.fullField;
                    fullField = fullField.split('.');
                    var text = (self.appRulesForm[fullField[0]])[fullField[1]].text;
                    if (value === '') {
                        callback(new Error('请输入位数'));
                    } else {
                        var len = text.toString().length;
                        if (!(value >= len && value <= len + 12 && /^[0-9]+$/.test(value))) {
                            callback(new Error('请输入' + len + '-' + (len + 12) + '之间的整位数'));
                        } else {
                            callback();
                        }
                    }
                };

                var validateCUSTOMTEXT = function (rule, value, callback) {
                    if (value === '') {
                        callback(new Error('请输入开始数'));
                    } else {
                        if (!(value >= 0 && /^[0-9]+$/.test(value))) {
                            callback(new Error('请输入正整数'));
                        } else {
                            callback();
                        }
                    }
                };

                var validateAppType = function (rule, value, callback) {
                    var treeEntries = self.treeEntries();
                    if (!value || !value.length) return callback(new Error('请关联项目'));
                    return self.$axios.post('/sys/sysNumberRule/checkAppTypeUnique?appType=' + treeEntries[value[1]].id).then(function (response) {
                        var data = response.data;
                        if (data.code != 0) {
                            callback(new Error(data.msg));
                        } else {
                            callback();
                        }
                    })
                }

                return {
                    appList: appList,
                    appListFb: [],
                    appTypeTree: [],
                    selectedAppRuleIds: [],
                    ruleTypes: [],
                    appRuleEditForm: {
                        appRules: []
                    },

                    appRulesForm: {
                        id: '',
                        appType: [],
                        appTypeName: '',
                        sysNumberRuleDetailList: [{
                            ruleType: 'FIXED',
                            nDate: [],
                            numLength: 0,
                            text: '',
                            key: Date.now()
                        }]
                    },

                    appRuleIsSave: false,
                    dates: [{label: '年', value: 'yyyy'}, {label: '月', value: 'MM'}, {
                        label: '日',
                        value: 'dd'
                    }, {label: '时', value: 'HH'}, {label: '分', value: 'mm'}, {label: '秒', value: 'ss'}],

                    appRuleFormRules: {
                        'appType': [{
                            validator: validateAppType,
                            trigger: 'change'
                        }],
                        'FIXED': [{validator: validateFixedText, trigger: 'blur'}, {
                            min: 1,
                            max: 12,
                            message: '长度在 1 到 12 个字符',
                            trigger: 'blur'
                        }],
                        'RANDOM': [{validator: validateRANDOMNum, trigger: 'blur'}],
                        'DATE': [{required: true, message: '请选择日期', trigger: 'change'}],
                        "CUSTOMTEXT": [{validator: validateCUSTOMTEXT, trigger: 'blur'}],
                        'CUSTOMNumLength': [{validator: validateCUSTOMNum, trigger: 'blur'}],
                        'YEAR': [{required: true, trigger: 'change'}]
                    },
                    dialogVisible: false
                }
            },
            computed: {
                updateList: {
                    get: function () {
                        var appList = this.appList;
                        var updateList = [];
                        appList.forEach(function (item) {
                            updateList.push()
                        })
                    }
                },
                ruleTypeEntries: {
                    get: function () {
                        var ruleTypes = this.ruleTypes;
                        var entries = {};
                        for (var i = 0; i < ruleTypes.length; i++) {
                            entries[ruleTypes[i].id] = ruleTypes[i].value;
                        }
                        return entries;
                    }
                }

            },
            filters: {
                ruleItemLabel: function (index) {
                    var str = '第X部分';
                    ++index;
                    switch (index.toString()) {
                        case '1':
                            return str.replace('X', '一');
                        case '2':
                            return str.replace('X', '二');
                        case '3':
                            return str.replace('X', '三');
                        case '4':
                            return str.replace('X', '四');
                        case '5':
                            return str.replace('X', '五');
                        case '6':
                            return str.replace('X', '六');
                    }
                }
            },
            methods: {

                handleClose: function () {

                },

                appRuleRuleTypes: function (appRules) {
                    var rTs = [];
                    for (var i = 0; i < appRules.length; i++) {
                        rTs.push(appRules[i].ruleType)
                    }
                    return rTs
                },

                removeRuleType: function (appRules, ruleTypeIndex) {
                    appRules.splice(ruleTypeIndex, 1)
                },

                addRuleType: function (appRules) {
                    appRules.push({
                        ruleType: '',
                        nDate: [],
                        numLength: 0,
                        text: '',
                        key: Date.now()
                    })
                },

                getAppTypeTree: function () {
                    var self = this;
                    this.$axios.get('/sys/sysNumberRule/getAppTypeTree').then(function (response) {
                        var data = response.data;
                        self.appTypeTree = data.data;
                    }).catch(function (error) {

                    });
                },

                treeFlatten: function (data) {
                    function flatten(data) {
                        return data.reduce(function (cur, next) {
                            return cur.concat(next, flatten((next.childList || [])), [])
                        }, [])
                    }

                    return flatten(data);
                },

                treeEntries: function () {
                    var nAppTypeTree = this.treeFlatten(this.appTypeTree);
                    var i = 0, entries = {};
                    while (i < nAppTypeTree.length) {
                        entries[nAppTypeTree[i].id] = nAppTypeTree[i];
                        i++;
                    }
                    return entries
                },


                addAppRuleDefaultData: function (selectedAppRuleIds, treeEntries) {
                    return {
                        id: '',
                        appType: selectedAppRuleIds[1],
                        appTypeName: (treeEntries[selectedAppRuleIds[0]].text) + '/' + (treeEntries[selectedAppRuleIds[1]].text),
                        sysNumberRuleDetailList: [{
                            ruleType: 'FIXED',
                            nDate: [],
                            numLength: 0,
                            text: '',
                            key: Date.now()
                        }]
                    }
                },

                //创建一条规则
                addAppRule: function () {
                    var selectedAppRuleIds = this.selectedAppRuleIds;
                    var treeEntries = this.treeEntries();
                    var self = this;
                    this.$axios.post('/sys/sysNumberRule/checkAppTypeUnique?appType=' + treeEntries[selectedAppRuleIds[1]].id).then(function (response) {
                        var data = response.data;
                        if (data.code === 0) {
                            self.appList.unshift(self.addAppRuleDefaultData(selectedAppRuleIds, treeEntries))
                        } else {
                            self.$message.error(data.msg)
                        }
                    }).catch(function (error) {
                        self.$message.error(error.response.data)
                    });
                },
                //获取规则
                getRuleTypes: function () {
                    var self = this;
                    return this.$axios.get('/sys/sysNumberRule/getRuleTypes').then(function (response) {
                        var data = response.data;
                        if (data) {
                            self.ruleTypes = data.data;
                        }
                    }).catch(function (error) {

                    })
                },


                saveValidate: function (appRule) {
                    var postData = JSON.stringify(this.getPostAppRulesForm(appRule));
                    var self = this;
                    this.appRuleIsSave = true;
                    Vue.set(appRule, 'isSave', true);
                    this.$axios({
                        method: 'POST',
                        url: '/sys/sysNumberRule/save',
                        data: postData,
                        headers: {
                            'Content-Type': 'application/json;charset=utf-8'
                        }
                    }).then(function (response) {
                        var data = response.data;
                        if (data.code === 0) {
                            self.appList.unshift(data.data);
                        }
                        self.showMessage(data);
                        self.appRuleIsSave = false;

                    }).catch(function (error) {
                        self.$message.error(error.response.data);
                        self.appRuleIsSave = false;
                    })
                },

                //保存
                saveAppRule: function () {
                    var self = this;
                    this.$refs.appRulesForm.validate(function (vaild) {
                        if (vaild) {
                            self.saveValidate(self.appRulesForm)
                        }
                    });
                },

                //旧版表单
                getPostAppRuleData: function (appRule) {
                    var appRules = this.appRuleEditForm.appRules;
                    var levelSort = -1;
                    var posText = '';
                    var nAppRules = JSON.parse(JSON.stringify(appRules));
                    for (var i = 0; i < nAppRules.length; i++) {
                        if (!nAppRules[i].ruleType) {
                            nAppRules.splice(i, 1);
                            continue;
                        }
                        nAppRules[i].sort = (i + 1);
                        if (nAppRules[i].ruleType === 'DATE') {
                            nAppRules[i].text = nAppRules[i].nDate.join('');
                            posText += nAppRules[i].text;
                        }
                        if (nAppRules[i].ruleType === 'LEVEL') {
                            levelSort = nAppRules[i].sort;
                            posText += '{LEVEL}'
                        }
                        if (nAppRules[i].ruleType === 'FIXED') {
                            posText += nAppRules[i].text;
                        }
                        if (nAppRules[i].ruleType === 'RANDOM' || nAppRules[i].ruleType === 'CUSTOM') {
                            Array.apply(null, {length: parseInt(nAppRules[i].numLength)}).forEach(function (item) {
                                posText += 'A'
                            })
                        }
                    }


                    return {
                        id: appRule.id,
                        appType: appRule.appType,
                        appTypeName: appRule.appTypeName,
                        increNum: 1,
                        levelIndex: posText.indexOf('{LEVEL}'),
                        sysNumberRuleDetailList: nAppRules
                    }
                },

                //新版表单
                getPostAppRulesForm: function (appRule) {
                    var appRules = this.appRulesForm.sysNumberRuleDetailList;
                    var levelSort = -1;
                    var posText = '';
                    var nAppRules = JSON.parse(JSON.stringify(appRules));
                    var treeEntries = this.treeEntries();
                    for (var i = 0; i < nAppRules.length; i++) {
                        if (!nAppRules[i].ruleType) {
                            nAppRules.splice(i, 1);
                            continue;
                        }
                        nAppRules[i].sort = (i + 1);
                        if (nAppRules[i].ruleType === 'DATE') {
                            nAppRules[i].text = nAppRules[i].nDate.join('');
                            posText += nAppRules[i].text;
                        }
                        if (nAppRules[i].ruleType === 'LEVEL') {
                            levelSort = nAppRules[i].sort;
                            posText += '{LEVEL}'
                        }
                        if (nAppRules[i].ruleType === 'FIXED' || nAppRules[i].ruleType === 'YEAR') {
                            posText += nAppRules[i].text;
                        }
                        if (nAppRules[i].ruleType === 'RANDOM' || nAppRules[i].ruleType === 'CUSTOM') {
                            Array.apply(null, {length: parseInt(nAppRules[i].numLength)}).forEach(function (item) {
                                posText += 'A'
                            })
                        }
                    }

                    var appType;
                    var appTypeName;

                    if (appRule.appType.length > 0) {
                        appType = appRule.appType[1];
                        appTypeName = (treeEntries[appRule.appType[1]].text) + '/' + (treeEntries[appRule.appType[1]].text);
                    }

                    return {
                        id: appRule.id,
                        appType: appType,
                        appTypeName: appTypeName,
                        increNum: 1,
                        levelIndex: posText.indexOf('{LEVEL}'),
                        sysNumberRuleDetailList: nAppRules
                    }
                },


                updateAppRule: function (appRule) {
                    if (appRule.updateRule) {
                        return false;
                    }
                    var list = JSON.parse(JSON.stringify((appRule.sysNumberRuleDetailList))) || [];
                    var appList = this.appList;
                    list = list.sort(function (item1, item2) {
                        return item2.sort - item1.sort < 0
                    });
                    this.appRuleEditForm.appRules = list;
                    var appRules = this.appRuleEditForm.appRules;
                    for (var i = 0; i < appRules.length; i++) {
                        var item = appRules[i];
                        if (item.ruleType === 'DATE') {
                            if (!item.nDate) {
                                Vue.set(item, 'nDate', []);
                                var n = 0;
                                var len = item.text ? item.text.length : 0;
                                while (n < len) {
                                    if (item.text[n] === 'y') {
                                        n += 4;
                                        item.nDate.push(item.text.substring(n - 4, n))
                                    } else {
                                        n += 2;
                                        item.nDate.push(item.text.substring(n - 2, n))
                                    }
                                }
                            }
                            break;
                        }
                    }
                    appList.forEach(function (item) {
                        Vue.set(item, 'updateRule', false);
                    });
                    Vue.set(appRule, 'updateRule', true);
                },

                cancelAppRule: function (appRule) {
                    Vue.set(appRule, 'updateRule', false);
                },


                showMessage: function (data) {
                    this.$message({
                        type: data.code === 0 ? 'success' : 'error',
                        message: data.msg
                    });
                },

                //删除
                removeAppRule: function (id, index) {
                    var self = this;
                    return this.$axios.post('/sys/sysNumberRule/delete', {id: id}).then(function (response) {
                        var data = response.data;
                        if (data.code == '0') {
                            self.appList.splice(index, 1)
                        }
                        self.showMessage(data);
                    }).catch(function (error) {
                        self.$message.error(error.response.data)
                    })
                },

                getUpdateRule: function () {
                    var appRules = this.appRuleEditForm.appRules;
                    var text = '';

                    for (var i = 0; i < appRules.length; i++) {
                        if (appRules[i].ruleType === 'DATE') {
                            if (appRules[i].nDate.length > 0) {
                                text += '{DATE-' + appRules[i].nDate.join('') + '}';
                            }
                        } else if (appRules[i].ruleType === 'FIXED') {
                            if (appRules[i].text) {
                                text += appRules[i].text;
                            }
                        } else if (appRules[i].ruleType === 'RANDOM') {
                            if (appRules[i].numLength) {
                                text += '{' + appRules[i].ruleType + '-' + appRules[i].numLength + '}';
                            }
                        } else {
                            if (appRules[i].text) {
                                text += '{' + appRules[i].ruleType + '-' + appRules[i].text + '}';
                            }
                        }
                    }
                    return text;
                },

                createdAppListFb: function () {
                    return this.appListFb = [].concat(this.appList);
                },

                //获取name
                handleChangeAppType: function (value) {

                    if (!value || !value.length) {
                        return;
                    }
                    var treeEntries = this.treeEntries();
                    this.appRulesForm.appTypeName = (treeEntries[value[1]].text) + '/' + (treeEntries[value[1]].text)

                }
            },
            created: function () {
                this.getAppTypeTree();
                this.getRuleTypes();
                this.createdAppListFb();
            }
        })
    }(Vue)
</script>
</body>
</html>