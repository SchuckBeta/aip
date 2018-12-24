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
<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60">
    <div class="mgb-20">
        <edit-bar :second-name="officeForm.id ? '修改': '添加'"></edit-bar>
    </div>
    <el-form :model="officeForm" ref="officeForm" :rules="officeRules" :disabled="officeFormDisabled"
             :action="frontOrAdmin + '/sys/office/save'" method="post" size="mini" label-width="120px"
             style="width: 400px;">
        <input type="hidden" name="id" :value="officeForm.id">
        <el-form-item v-if="officeForm.id != '1'" prop="officeIds" label="上级机构：">
            <input type="hidden" name="parent.id" :value="officeForm.parentId">
            <el-cascader
                    style="width: 100%"
                    ref="cascader"
                    filterable
                    :options="collegesTree"
                    change-on-select
                    v-model="officeForm.officeIds"
                    :props="{
                    label: 'name',
                    value: 'id',
                    children: 'children'
                }"
            >
            </el-cascader>
        </el-form-item>
        <el-form-item prop="name" label="机构名称：">
            <el-input name="name" v-model="officeForm.name"></el-input>
        </el-form-item>
        <el-form-item prop="code" label="机构编码：">
            <el-input name="code" v-model="officeForm.code"></el-input>
        </el-form-item>
        <template v-if="officeForm.id == '1'">
            <el-form-item prop="cityIds" label="所属区域：">
                <input type="hidden" name="cityCode" :value="officeForm.cityCode">
                <el-cascader
                        style="width: 100%"
                        ref="cascaderCity"
                        filterable
                        :options="cityTree"
                        change-on-select
                        v-model="officeForm.cityIds"
                        @change="handleChangeCityIds"
                        :props="{
                    label: 'name',
                    value: 'id',
                    children: 'children'
                }"
                >
                </el-cascader>
            </el-form-item>
            <el-form-item prop="schoolCode" label="高校代码：">
                <el-input name="schoolCode" v-model="officeForm.schoolCode"></el-input>
            </el-form-item>
        </template>
        <el-form-item>
            <el-button type="primary" @click.stop.prevent="validateOfficeForm">保存</el-button>
            <el-button @click.stop.prevent="goToBack">返回</el-button>
        </el-form-item>
    </el-form>
</div>

<script>

    'use strict';

    new Vue({
        el: '#app',
        mixins: [Vue.collegesMixin],
        data: function () {
            var officeForm = JSON.parse('${fns: toJson(office)}');
            var colleges = [];
            var self = this;
            var cityIds = [];
            if(officeForm.id != '1'){
                colleges = JSON.parse('${fns: toJson(fns: getOfficeList())}') || [];
            }
            if(officeForm.area && officeForm.area.parentIds){
                cityIds = officeForm.area.parentIds.replace(/\,$/, '');
                cityIds = cityIds.split(',');
                if(cityIds.indexOf('0')>-1){
                    cityIds = cityIds.slice(1);
                }
                cityIds.push(officeForm.area.id)
            }
            var validateOfficeName = function (rule, value, callback) {
                if (value) {
                    if (/[@#\$%\^&\*\s]+/g.test(value)) {
                        return callback(new Error('请不要输入特殊符号'))
                    } else if (value.length > 64) {
                        return callback(new Error('请输入不大于64位字符'))
                    } else {
                        return self.$axios.get('/sys/office/checkOfficeName?'+ Object.toURLSearchParams({
                            name: value,
                            id: self.officeForm.id,
                            'parent.id': self.officeForm.parentId
                        })).then(function (response) {
                            if (!response.data) return callback(new Error('机构名称已存在'));
                            return callback()
                        }).catch(function (error) {
                            return callback(new Error(self.xhrErrorMsg));
                        })
                    }
                }
                return callback();
            };

            var validateOfficeCode = function (rule, value, callback) {
                if (value) {
                    if (!(/^[A-Za-z0-9]+$/.test(value))) {
                        return callback(new Error('请输入字母或者数字'))
                    } else if (value.length > 64) {
                        return callback(new Error('请输入不大于64位字符'))
                    }
                    return callback();
                }
                return callback();
            }

            return {
                officeForm: {
                    id: officeForm.id,
                    officeIds: [],
                    cityIds:cityIds,
                    parentId: officeForm.parentId,
                    name: officeForm.name,
                    code: officeForm.code,
                    cityCode: officeForm.cityCode,
                    schoolCode: officeForm.schoolCode
                },
                colleges: colleges,
                collegesTree: [],
                cities: [],
                officeRules: {
                    officeIds: [{required: true, message: '请选择上级栏目', trigger: 'change'}],
                    name: [
                        {required: true, message: '请输入机构名称', trigger: 'blur'},
                        {validator: validateOfficeName, trigger: 'blur'}
                    ],
                    cityIds: [{required: true, message: '请选择所属区域', trigger: 'change'}],
                    code: [{validator: validateOfficeCode, trigger: 'blur'}],
                    schoolCode: [{validator: validateOfficeCode, trigger: 'blur'}],
                },
                officeFormDisabled: false,
                cityEntries: [],
                cityTree: []
            }
        },
        watch: {
            'officeForm.officeIds': function (value) {
                this.officeForm.parentId = value ? value[value.length - 1] : '';
            }
        },
        methods: {
            goToBack: function () {
                location.href = this.frontOrAdmin + '/sys/office'
            },

            getOfficeIds: function () {
                var id = '', parentId = '';
                var officeIds = [];
                if (!this.officeForm.parentId) {
                    return officeIds;
                }
                id = this.officeForm.parentId;
                parentId = id;
                while (parentId) {
                    var parentOffice = this.collegeEntries[parentId];
                    if (!parentOffice) {
                        break;
                    }
                    officeIds.unshift(parentId);
                    parentId = parentOffice.parentId;
                }
                return officeIds;
            },

            getCityIds: function () {
                var cityIds = [];
                var parentId = this.officeForm.cityCode;
                while (parentId) {
                    var parentCity = this.cityEntries[parentId];
                    if (!parentCity) {
                        break;
                    }
                    cityIds.unshift(parentId);
                    parentId = parentCity.pId;
                }
                return cityIds;
            },

            validateOfficeForm: function () {
                var self = this;
                this.$refs.officeForm.validate(function (valid) {
                    if (valid) {
                        self.$refs.officeForm.$el.submit();
                        self.officeFormDisabled = true;
                    }
                })
            },
            handleChangeCityIds: function () {
                var cityIds = this.officeForm.cityIds;
                this.officeForm.cityCode = cityIds&& cityIds.length > 0 ? cityIds[cityIds.length - 1] : '';
            },

            getCities: function () {
                var self = this;
                this.$axios.get('/sys/area/listpage').then(function (response) {
                    var data = response.data;
                    if(data.status === 1){
                        self.cityTree = data.data || [];
                    }
                }).catch(function (error) {

                })
            },

            getCityEntries: function (cities) {
                var cityEntries = {};
                 cities.forEach(function (item) {
                    cityEntries[item.id] = item;
                });
                return cityEntries;
            },

            getCityRootIds: function (cities, props) {
                var parentKey = props["parentKey"];
                var rootIds = [];
                for (var i = 0; i < cities.length; i++) {
                    var parentId = cities[i].id;
                    while (parentId) {
                        var college = this.cityEntries[this.cityEntries[parentId][parentKey]]
                        if (!college) {
                            if (rootIds.indexOf(parentId) === -1) {
                                rootIds.push(parentId);
                            }
                            break;
                        }
                        parentId = this.cityEntries[parentId][parentKey];
                    }
                }
                return rootIds;
            },

            getCityTree: function (rootIds, props) {
                var cityArr = [];
                var self = this;
                var cities = this.cities;
                this.getCityTreeByRootId(rootIds, props, cities);
                rootIds.forEach(function (item) {
                    cityArr.push(self.cityEntries[item])
                });
                cityArr.forEach(function (item) {
                    Vue.set(item, 'dots', '1')
                });
                return cityArr;
            },

            getCityTreeByRootId: function (tRootIds, props, list) {
                var self = this;
                var parentKey = props["parentKey"];
                var id = props['id'];
                var rootIds = [];
                if (tRootIds.length < 1) {
                    return false;
                }
                tRootIds.forEach(function (item) {
                    if (!self.cityEntries[item].children) {
                        self.cityEntries[item].children = []
                    }
                    list.forEach(function (item2) {
                        if (item2[parentKey] === item) {
                            self.cityEntries[item].children.push(item2);
                            rootIds.push(item2[id]);
                        }
                    })
                    if (self.cityEntries[item].children.length < 1) {
                        delete self.cityEntries[item].children
                    }
                })
                this.getCityTreeByRootId(rootIds, props, list)
            }


        },
        created: function () {
            this.officeForm.officeIds = this.getOfficeIds();
            if(this.officeForm.id == '1'){
                this.getCities();
            }
        }
    })

</script>
</body>
</html>