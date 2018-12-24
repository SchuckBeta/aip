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
        <shiro:hasPermission name="pw:pwSpace:edit">
            <edit-bar :second-name="baseForm.id ? '基地修改': '基地添加'"></edit-bar>
        </shiro:hasPermission>
        <shiro:lacksPermission name="pw:pwSpace:edit">
            <edit-bar :second-name="基地查看"></edit-bar>
        </shiro:lacksPermission>
    </div>


    <el-form size="mini" :model="baseForm" :rules="baseFormRules" ref="baseForm" :disabled="formDisabled"
             label-width="120px" action="${ctx}/pw/pwSpace/save" method="POST">

        <input type="hidden" id="id" name="id" :value="baseForm.id">
        <input type="hidden" id="parent.id" name="parent.id" :value="baseForm.parentId">
        <input type="hidden" id="type" name="type" value="2">
        <input type="hidden" id="secondName" name="secondName" :value="secondName">

        <el-form-item label="所属学院：" v-if="school">
            {{school}}
        </el-form-item>

        <el-form-item label="所属校区：" v-if="campus">
            {{campus}}
        </el-form-item>

        <el-form-item prop="name" label="基地名称：">
            <el-input name="name" v-model="baseForm.name" class="w300"></el-input>
        </el-form-item>

        <el-form-item prop="area" label="占地面积：">
            <el-input name="area" type="number" v-model.number="baseForm.area" class="w300">
                <template slot="append">平方米</template>
            </el-input>
        </el-form-item>

        <el-form-item prop="imageUrl" label="基地背景图：" class="common-upload-one-img">
            <input name="imageUrl" type="hidden" v-model="baseForm.imageUrl">

            <div class="upload-box-border" style="width:135px;height:100px;">
                <el-upload
                        class="avatar-uploader"
                        action="/a/ftp/ueditorUpload/uploadTemp"
                        :show-file-list="false"
                        :on-success="fileSuccess"
                        :on-error="fileError"
                        name="upfile"
                        accept="image/jpg, image/jpeg, image/png">
                    <img v-for="item in fileBaseImg" :key="item.uid"
                         :src="item.ftpUrl | ftpHttpFilter(ftpHttp)">
                    <i v-if="fileBaseImg.length == 0"
                       class="el-icon-plus avatar-uploader-icon"></i>
                </el-upload>
                <div class="arrow-block-delete" v-if="fileBaseImg.length > 0">
                    <i class="el-icon-delete" @click.sotp.prevent="fileBaseImg = []"></i>
                </div>
            </div>
            <div class="img-tip">
                仅支持上传jpg/png文件，建议背景图片大小：270 × 200（像素）
            </div>

        </el-form-item>

        <el-form-item prop="remarks" label="备注：">
            <el-input type="textarea" name="remarks" :rows="5" v-model="baseForm.remarks" maxlength="200" style="width:500px;"></el-input>
        </el-form-item>


        <el-form-item>
            <shiro:hasPermission name="pw:pwSpace:edit">
                <el-button type="primary" :disabled="formDisabled"
                           @click.stop.prevent="saveForm('baseForm')">保存
                </el-button>
            </shiro:hasPermission>
            <el-button @click.stop.prevent="goToBack">返回</el-button>
        </el-form-item>

    </el-form>



</div>

<script>

    'use strict';

    new Vue({
        el: '#app',
        data: function () {
            var pwSpace = JSON.parse('${fns:toJson(pwSpace)}');

            var nameReg = /['"\s“”‘’]+/;
            var validateName = function (rule, value, callback) {
                if (nameReg.test(value)) {
                    callback(new Error('基地名称存在空格或者引号'))
                } else {
                    callback();
                }
            };
            var validateArea = function (rule, value, callback) {
                var len = value.toString().split('').length;
                if(value && len > 6){
                    callback(new Error('占地面积最大6位数'))
                }else{
                    callback();
                }
            };

            return {
                baseForm:{
                    id: pwSpace.id || '',
                    parentId:pwSpace.parentId || '',
                    name: pwSpace.name || '',
                    remarks: pwSpace.remarks || '',
                    area: pwSpace.area || '',
                    imageUrl:pwSpace.imageUrl || ''
                },
                school:'${school}',
                campus:'${campus}',
                secondName:'${secondName}',
                formDisabled:false,
                message:'${message}',
                fileBaseImg:[],
                baseFormRules:{
                    name: [
                        {required: true, message: '请输入基地名称', trigger: 'change'},
                        {min: 1, max: 20, message: '长度在 1 到 20 个字符', trigger: 'change'},
                        {validator: validateName, trigger: 'change'}
                    ],
                    area: [
                        {validator: validateArea, trigger: 'change'}
                    ]
                }
            }
        },
        watch:{
            fileBaseImg: function (value) {
                this.baseForm.imageUrl = value.map(function (item) {
                    return item.ftpUrl
                }).join(',');
            }
        },
        methods: {
            setFileBaseImg: function (value) {
                if (!value) {
                    return;
                }
                this.fileBaseImg.push({
                    ftpUrl: value
                });
            },
            fileError: function (err, file, fileList) {
                if (err.state == 'error') {
                    this.$message({
                        message: '上传失败',
                        type: 'error'
                    });
                }
            },

            fileSuccess: function (response, file, fileList) {
                var nfile = Object.assign(file, response);
                if (response.state === 'SUCCESS') {
                    this.fileBaseImg = fileList.slice(-1);
                } else {
                    this.$message({
                        message: '上传失败',
                        type: 'error'
                    });
                }
            },

            saveForm:function (formName) {
                var self = this;
                self.$refs[formName].validate(function (valid) {
                    if (valid) {
                        self.formDisabled = true;
                        self.$refs.baseForm.$el.submit();
                    }
                })
            },
            goToBack:function () {
                window.location.href = this.frontOrAdmin + '/pw/pwSpace/list';
            }
        },
        created: function () {
            this.setFileBaseImg(this.baseForm.imageUrl);
            if (this.message) {
                this.$message({
                    message: this.message,
                    type: this.message.indexOf('完成') > -1 ? 'success' : 'warning'
                });
                this.message = '';
            }
        }
    })

</script>

</body>
</html>