<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${frontTitle}</title>
    <meta name="decorator" content="creative"/>

</head>
<body>

<div id="app" v-show="pageLoad" style="display: none;" class="page-container pdb-60 team-build">
    <el-breadcrumb class="mgb-20" separator-class="el-icon-arrow-right">
        <el-breadcrumb-item><a href="#"><i class="iconfont icon-ai-home"></i>首页</a></el-breadcrumb-item>
        <el-breadcrumb-item>留言</el-breadcrumb-item>
    </el-breadcrumb>


    <div class="front-leave-msg">
        <p class="leave-msg-title">我要留言</p>

        <el-form :model="leaveMsgForm" ref="leaveMsgForm" :rules="leaveMsgFormRules" size="mini"
                 label-width="100px">

            <el-row :gutter="20">
                <el-col :span="12">
                    <el-form-item prop="name" label="名称：">
                        <el-input v-model="leaveMsgForm.name" class="w300"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="12">
                    <el-form-item prop="phone" label="电话：">
                        <el-input v-model="leaveMsgForm.phone" class="w300"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-row :gutter="20">
                <el-col :span="12">
                    <el-form-item prop="email" label="邮箱：">
                        <el-input v-model="leaveMsgForm.email" class="w300"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="12">
                    <el-form-item prop="qq" label="QQ：">
                        <el-input v-model="leaveMsgForm.qq" class="w300"></el-input>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-form-item prop="msgImg" label="上传截图：" class="site-config-msg">
                <input type="hidden" v-model="leaveMsgForm.msgImg">
                <el-upload
                        class="avatar-uploader"
                        action="/a/ftp/ueditorUpload/uploadTemp"
                        :show-file-list="false"
                        :on-success="fileMsgSuccess"
                        :on-error="fileLogoError"
                        name="upfile"
                        accept="image/jpeg">
                    <!--<img v-for="item in msgImages" :key="item.uid" :src="item.ftpUrl | ftpHttpFilter(ftpHttp)"-->
                    <!--class="avatar">-->
                    <i v-if="msgImages.length == 0" class="el-icon-plus avatar-uploader-icon"></i>
                    <div class="el-upload__tip" slot="tip">只能上传jpg/png文件，建议图片大小：200*100（像素）</div>
                </el-upload>
            </el-form-item>
            <el-form-item prop="type" label="留言分类：">
                <el-select v-model="leaveMsgForm.type" placeholder="请选留言类型" @change="handleChangeMsgType">
                    <el-option v-for="item in msgTypes" :key="item.value" :label="item.label"
                               :value="item.value"></el-option>
                </el-select>
            </el-form-item>

            <el-form-item prop="content" label="留言内容：">
                <el-input type="textarea" :rows="4" v-model="leaveMsgForm.content"></el-input>
            </el-form-item>

            <el-form-item>
                <el-button type="primary" :disabled="submitIsDisable"
                           @click.stop.prevent="saveForm('leaveMsgForm')">提交
                </el-button>
            </el-form-item>

        </el-form>


        <el-tabs v-model="activeCommentName">
            <el-tab-pane label="我的留言" name="first">

                <div class="excellent-comment">
                    <div class="excellent-comment-head">
                        <img src="/images/cxf.jpg" alt="">
                        <a href="#" target="_blank" class="excellent-comment-name">程小凤</a>
                        <span class="excellent-comment-date">2018-08-15 10:14:28</span>
                    </div>
                    <div class="excellent-comment-content">
                        发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激发动机盖考虑到发生激
                    </div>
                    <div class="excellent-comment-reply-item">
                        <img src="/images/cxf.jpg" alt="">
                        <span>王清腾 回复：</span>
                        <span>减肥的考虑过积分都看过了减肥的考虑过积分都看过了减肥的考虑过积分都看过了减肥的考虑过积分都看过了减肥的考虑过积分都看过了
                    减肥的考虑过积分都看过了减肥的考虑过积分都看过了减肥的考虑过积分都看过了减肥的考虑过积分都看过了减肥的考虑过积分都看过了</span>
                        <div class="reply-meta">
                            <span>2018-08-15 10:35:45</span>
                        </div>
                    </div>
                    <div class="excellent-comment-reply-item">
                        <img src="/images/cxf.jpg" alt="">
                        <span>王清腾 回复：</span>
                        <span>减肥的考虑过积分都看过了减肥的考虑过积分都看过了减肥的考虑过积分都看过了减肥的考虑过积分都看过了减肥的考虑过积分都看过了
                    减肥的考虑过积分都看过了减肥的考虑过积分都看过了减肥的考虑过积分都看过了减肥的考虑过积分都看过了减肥的考虑过积分都看过了</span>
                        <div class="reply-meta">
                            <span>2018-08-15 10:35:45</span>
                        </div>
                    </div>

                </div>


            </el-tab-pane>
        </el-tabs>


    </div>


</div>

<script>
    +function (Vue) {

        new Vue({
            el: '#app',
            data: function () {

                return {
                    leaveMsgForm: {
                        name: '',
                        phone: '',
                        email: '',
                        qq: '',
                        msgImg: '',
                        type: '',
                        content: ''
                    },
                    leaveMsgFormRules: {},
                    msgImages: [],
                    msgTypes: [{label: '咨询', value: '0'}, {label: '问题反馈', value: '1'}],
                    submitIsDisable: false,
                    activeCommentName: 'first'
                }
            },
            methods: {
                fileMsgSuccess: function () {

                },
                fileLogoError: function () {

                },
                handleChangeMsgType: function () {

                },
                saveForm: function (formName) {
                    var self = this;
                    $.ajax({
                        type : "POST",
                        url : "/f/cms/cmsGuestbook/ajaxSave",
                        dataType : "json",
                        data:{
                            "id":"111"
                        },
                        /*data : {
                            type:"0",
                            content:"留言内容",
                            name:"姓名",
                            email:"316937855@qq.com",
                            phone:"13797533697",
                            qq:"12313131",
                            auditstatus:"0",
                            isRecommend:"0",
                            reUser:{
                                id:""
                            },
                            reDate:"2018-01-01 01:01:01",
                            reContent:"回复内容"
                        },*/
                        contentType : "application/json;charset=utf-8",
                        success:function(msg) {
                            console.info("-----" + msg);
                        },
                        complete:function(msg) {
                            console.info(msg);
                        }
                    });

                    /*this.$axios({
                        method:'POST',
                        url:'/cms/cmsGuestbook/ajaxSave',
                        data: self.leaveMsgForm
                    }).then(function (response) {
                        var data = response.data;
                        if(data.status == '1'){
                            console.log(data);
                        }
                        self.$message({
                            message: data.status == '1' ? '保存成功' : '保存失败',
                            type: data.status == '1' ? 'success' : 'error'
                        })
                    }).catch(function () {
                        self.$message({
                            message:'请求失败',
                            type:'error'
                        })
                    })*/
                }
            },
            created: function () {

            }
        });

    }(Vue)
</script>


</body>
</html>