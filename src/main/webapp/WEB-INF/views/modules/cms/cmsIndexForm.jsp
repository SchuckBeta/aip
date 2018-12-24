<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ page errorPage="/WEB-INF/views/error/formMiss.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <meta charset="UTF-8">
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>

<body>

<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60">
    <div class="mgb-20">
        <edit-bar></edit-bar>
    </div>
    <p class="text-right config-index-soft-tip mgb-20">温馨提示：可拖拽调整顺序</p>
    <div class="config-index-container" v-loading="loading">
        <div class="config-index-header">
            <span>标签名称</span>
            <span>副标签名称</span>
            <span>显示/隐藏</span>
            <span>操作</span>
        </div>
        <div class="config-index-body">
            <div class="index-categories">
                <draggable v-model="indexComponents" @start="drag=true" @end="endDrag()">
                    <div class="category-item" v-for="iComp in indexComponents" :key="iComp.id">
                        <span>{{iComp.modelname}}</span>
                        <span class="index-block-name">
                            <span>{{iComp.ename}}</span>
                            <a href="javascript:void(0)"  v-if="iComp.id != '10001'"></a>
                        </span>
                        <span><el-switch v-model="iComp.isShow" active-value="1" inactive-value="0" @change="saveIsShow(iComp)"></el-switch></span>
                        <span>
                            <el-button v-if="noBtns.indexOf(iComp.id) == -1" type="text" size="mini"  @click.stop.prevent="changeModelName(iComp)">编辑</el-button>
                        </span>
                    </div>
                </draggable>
            </div>
        </div>

    </div>



    <el-dialog title="修改名称" :visible.sync="dialogVisible"
               :before-close="handleClose" width="560px">
        <el-form size="mini" :model="modelNameForm" :rules="modelNameFormRules" ref="modelNameForm" label-width="140px">
            <el-form-item prop="modelname" label="标签名称：">
                <el-input v-model="modelNameForm.modelname" class="w300"></el-input>
            </el-form-item>
            <el-form-item prop="ename" label="副标签名称：">
                <el-input v-model="modelNameForm.ename" class="w300"></el-input>
            </el-form-item>

            <el-form-item prop="homeSCDT.modelname" label="双创动态名称：" v-if="modelNameForm.id == '10007'">
                <el-input v-model="modelNameForm.homeSCDT.modelname" class="w300"></el-input>
            </el-form-item>
            <el-form-item prop="homeSCTZ.modelname" label="双创通知名称：" v-if="modelNameForm.id == '10007'">
                <el-input v-model="modelNameForm.homeSCTZ.modelname" class="w300"></el-input>
            </el-form-item>
            <el-form-item prop="homeSSDT.modelname" label="省市动态名称：" v-if="modelNameForm.id == '10007'">
                <el-input v-model="modelNameForm.homeSSDT.modelname" class="w300"></el-input>
            </el-form-item>

        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button size="mini" @click.stop.prevent="handleClose">取 消</el-button>
            <el-button size="mini" type="primary" @click.stop.prevent="saveModelName('modelNameForm')">确 定</el-button>
        </div>
    </el-dialog>

</div>

<script>

    'use strict';

    new Vue({
        el: '#app',
        data:  function () {
            return {
                indexComponents: [],
                notifyInfo:[],
                drag: false,
                loading:false,
                dialogVisible:false,
                modelNameForm:{
                    id:'',
                    modelname:'',
                    ename:'',
                    homeSCDT:{id:'10008',modelname:''},   //双创动态
                    homeSCTZ:{id:'10009',modelname:''},   //双创通知
                    homeSSDT:{id:'10010',modelname:''}    //省市动态
                },
                modelNameFormRules:{
                    id:'',
                    modelname:[
                        {required: true, message: '请输入标签名称', trigger: 'blur'}
                    ],
                    ename:[
                        {required: true, message: '请输入副标签名称', trigger: 'blur'}
                    ],
                    'homeSCDT.modelname':[
                        {required: true, message: '请输入双创动态名称', trigger: 'blur'}
                    ],
                    'homeSCTZ.modelname':[
                        {required: true, message: '请输入双创通知名称', trigger: 'blur'}
                    ],
                    'homeSSDT.modelname':[
                        {required: true, message: '请输入省市动态名称', trigger: 'blur'}
                    ]
                },
                noBtns: ['10001','10002']
            }
        },
		methods:{
            getDataList:function () {
                var self = this;
                this.loading = true;
                this.$axios({
                    method: 'POST',
                    url: '/cms/cmsIndex/cmsIndexList'
                }).then(function (response) {
                    var data = response.data;
                    if (data.status == '1') {
                        self.indexComponents = data.data.cmsIndexList || [];
                        self.notifyInfo = data.data.hiddenCmsIndexList || [];
                    }
                    self.loading = false;
                }).catch(function () {
                    self.loading = false;
                    self.$message({
                        message: '请求失败',
                        type : 'error'
                    })
                });
            },
            handleClose:function () {
                this.dialogVisible = false;
                this.$refs.modelNameForm.resetFields();
            },
            changeModelName:function (row) {
                var self = this;
                this.dialogVisible = true;
                this.modelNameForm.id = row.id;
                this.modelNameForm.modelname = row.modelname || '';
                this.modelNameForm.ename = row.ename;

                if(row.id == '10007'){
                    this.notifyInfo.forEach(function (item) {
                        if(item.modelename){
                            self.modelNameForm[item.modelename].modelname = item.modelname;
                        }

                    })
                }
            },
            saveModelName:function (formName) {
                var self = this;
                var modelNameAssignForm = Object.assign({}, this.modelNameForm);
                if(modelNameAssignForm.id != '10007'){
                    delete modelNameAssignForm.homeSCDT;
                    delete modelNameAssignForm.homeSCTZ;
                    delete modelNameAssignForm.homeSSDT;
                }
                this.$refs[formName].validate(function (valid) {
                    if(valid){
                        var url = '/cms/cmsIndex/cmsIndexSave';
                        var data = modelNameAssignForm;
                        self.axiosRequest(url,true,data);
                        self.dialogVisible = false;
                    }
                });

            },
            axiosRequest:function (url,showMsg,obj) {
                var self = this,path;
                this.loading = true;
                if (obj) {
                    path = {
                        method: 'POST',
                        url: url,
                        data: obj
                    }
                }else{
                    path = {
                        method: 'POST',
                        url: url
                    }
                }
                this.$axios(path).then(function (response) {
                    var data = response.data;
                    if(data.status == '1'){
                        self.getDataList();
                        if(showMsg){
                            self.$refs.modelNameForm.resetFields();
                            self.$message({
                                message: '操作成功',
                                type: 'success'
                            });
                        }
                    }else{
                        self.$message({
                            message: '操作失败',
                            type: 'error'
                        });
                    }
                    self.drag = false;
                    self.loading = false;
                }).catch(function () {
                    self.drag = false;
                    self.loading = false;
                    self.$message({
                        message:'请求失败',
                        type:'error'
                    })
                })
            },
            endDrag:function () {
                var indexList = this.indexComponents;
                var ids = [];
                var sorts = [];
                for(var i = 0; i < indexList.length; i++){
                    if(indexList[i].sort){
                        ids.push(indexList[i].id);
                        sorts.push((i+1).toString());
                    }
                }
                var url = '/cms/cmsIndex/cmsIndexSaveSort?ids=' + ids.join(',') + '&sorts=' + sorts.join(',');
                this.axiosRequest(url,false);
			},
            saveIsShow:function (value) {
                var url = '/cms/cmsIndex/cmsIndexSave';
                var data = {
                    id: value.id,
                    isShow: value.isShow
                };
                this.axiosRequest(url,false,data);
            }
		},
        created:function () {
            this.getDataList();
        }
    })

</script>

</body>
</html>