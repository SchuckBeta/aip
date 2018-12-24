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


<div id="app" v-show="pageLoad" style="display: none;" class="container page-container pdt-60">
    <el-breadcrumb class="mgb-20" separator-class="el-icon-arrow-right">
        <el-breadcrumb-item><a href="#"><i class="iconfont icon-ai-home"></i>首页</a></el-breadcrumb-item>
        <el-breadcrumb-item><a href="#"></a>优秀项目展示</el-breadcrumb-item>
        <el-breadcrumb-item>项目详情</el-breadcrumb-item>
    </el-breadcrumb>


    <div class="excellent-comment-box">
        <p style="font-size: 16px;">发表评论</p>

        <el-input type="textarea" v-if="isLogin" size="mini" :rows="5" placeholder="最多500字" maxlength="500"
                  class="textarea-font-family" v-model="commentText"></el-input>
        <p class="text-right" v-if="isLogin" style="margin:12px 0">
            <el-button size="mini" @click.stop.prevent="commentText = ''">重置</el-button>
            <el-button type="primary" size="mini" :disabled="!commentText" @click.stop.prevent="publishComment">发表评论
            </el-button>
        </p>

        <div class="un-login-text-area un-login-comment" v-else>
            <span>我来说两句，请先</span><a href="#">登录</a>
        </div>


        <el-tabs v-model="activeCommentName" @tab-click="handleClick">
            <el-tab-pane label="全部评论" name="first">
                <div class="excellent-comment" v-for="item in commentList" v-if="commentList.length > 0">
                    <div class="excellent-comment-head">
                        <img :src="item.user.photo | ftpHttpFilter(ftpHttp) | studentPicFilter" alt="">
                        <a href="#" target="_blank" class="excellent-comment-name">{{item.user.name}}</a>
                        <span class="excellent-comment-date">{{item.createDate}}</span>
                    </div>
                    <div class="excellent-comment-content">
                        {{item.content}}
                    </div>
                    <div class="excellent-comment-meta">
                        <a href="javascript:void(0)"
                           :class="{'excellent-comment-like':true,'clicked-like': item.ctLikeIds ? item.ctLikeIds.indexOf(userId) > -1 : false}"
                           @click.stop.prevent="giveLike(item)">
                            <i class="iconfont icon-dianzan1"></i>
                            <span>({{item.likes}})</span>
                        </a>
                    </div>
                    <div class="excellent-comment-reply-item" v-if="item.reply">
                        <img src="/images/test/admin.jpg" alt="">
                        <span>{{item.reUser && item.reUser.name ? item.reUser.name : ''}}回复：</span>
                        <span>{{item.reply ? item.reply : ''}}</span>
                        <div class="reply-meta">
                            <span>{{item.reDate | formatDateFilter('YYYY-MM-DD HH:mm:ss')}}</span>
                        </div>
                    </div>
                </div>

                <div v-if="commentList.length == 0" class="no-content">
                    暂无评论，快去评论吧！
                </div>

            </el-tab-pane>
            <el-tab-pane label="我的评论" name="second">
                <div class="excellent-comment" v-for="item in commentList" v-if="commentList.length > 0">
                    <div class="excellent-comment-head">
                        <img :src="item.user.photo | ftpHttpFilter(ftpHttp) | studentPicFilter" alt="">
                        <a href="#" target="_blank" class="excellent-comment-name">{{item.user.name}}</a>
                        <span class="excellent-comment-date">{{item.createDate}}</span>
                    </div>
                    <div class="excellent-comment-content">
                        {{item.content}}
                    </div>
                    <div class="excellent-comment-meta">
                        <a href="javascript:void(0)"
                           :class="{'excellent-comment-like':true,'clicked-like': item.ctLikeIds ? item.ctLikeIds.indexOf(userId) > -1 : false}"
                           @click.stop.prevent="giveLike(item)">
                            <i class="iconfont icon-dianzan1"></i>
                            <span>({{item.likes}})</span>
                        </a>
                    </div>
                    <div class="excellent-comment-reply-item" v-if="item.reply">
                        <img src="/images/test/admin.jpg" alt="">
                        <span>{{item.reUser && item.reUser.name ? item.reUser.name : ''}}回复：</span>
                        <span>{{item.reply ? item.reply : ''}}</span>
                        <div class="reply-meta">
                            <span>{{item.reDate | formatDateFilter('YYYY-MM-DD HH:mm:ss')}}</span>
                        </div>
                    </div>
                </div>
                <div v-if="commentList.length == 0" class="no-content">
                    暂无评论，快去评论吧！
                </div>
            </el-tab-pane>
        </el-tabs>

        <div class="text-right mgb-20" v-if="pageCount" style="margin-top:20px;">
            <el-pagination
                    size="small"
                    @size-change="handlePaginationSizeChange"
                    background
                    @current-change="handlePaginationPageChange"
                    :current-page.sync="searchListForm.pageNo"
                    :page-sizes="[5,10,20,50,100]"
                    :page-size="searchListForm.pageSize"
                    layout="total, prev, pager, next, sizes"
                    :total="pageCount">
            </el-pagination>
        </div>
    </div>


</div>

<script>
    +function (Vue) {
        'use strict';

        new Vue({
            el: '#app',
            data: function () {

                return {
                    commentText: '',
                    activeCommentName: 'first',
                    isClickedLike: false,   //判断是否点赞
                    likeNum: 0,
                    isLogin: true,          //判断是否登录
                    commentList: [],
                    searchListForm: {
                        pageNo: 1,
                        pageSize: 10
                    },
                    pageCount: 0,
                    articleId: '10001',        //文章id  没入口  要获取一下
                    categoryId:'10031',        //栏目id    根据文章id  要找一下栏目id
                    userId:'${fns:getUser().id}'
                }
            },
            methods: {
                getDataList: function () {

                    var self = this;
                    this.$axios({
                        method: 'POST',
                        url: (self.activeCommentName == 'first' ? '/cms/cmsConmment/ajaxList?' : '/cms/cmsConmment/ajaxListByCuser?') + Object.toURLSearchParams(self.searchListForm) + '&cnt.id=' + self.articleId + '&auditstatus=1'
                    }).then(function (response) {
                        var data = response.data;
                        if (data.status == '1') {
                            if(self.activeCommentName == 'first'){
                                self.pageCount = data.data.count;
                            }
                            self.searchListForm.pageSize = data.data.pageSize;
                            self.searchListForm.pageNo = data.data.pageNo;
                            self.commentList = data.data.list || [];
                        }
                    });

                },
                publishComment: function () {
                    var self = this;
                    this.$axios({
                        method: 'POST',
                        url: '/cms/cmsConmment/ajaxSave',
                        data: {
                            category:{
                                id:self.categoryId
                            },
                            cnt: {
                                id: self.articleId
                            },
                            content: self.commentText
                        }
                    }).then(function (response) {
                        var data = response.data;
                        if (data.status == '1') {
                            self.commentText = '';
                            self.getDataList();
                        }
                        self.$message({
                            message: data.status == '1' ? '发表成功' : '发表失败',
                            type: data.status == '1' ? 'success' : 'error'
                        })
                    }).catch(function () {
                        self.$message({
                            message: '请求失败',
                            type: 'error'
                        })
                    })
                },
                handlePaginationSizeChange: function (value) {
                    this.searchListForm.pageSize = value;
                    this.getDataList();
                },

                handlePaginationPageChange: function (value) {
                    this.searchListForm.pageNo = value;
                    this.getDataList();
                },
                handleClick: function () {
                    this.searchListForm.pageNo = 1;
                    this.searchListForm.pageSize = 10;
                    this.getDataList();
                },
                giveLike: function (data) {
                	if(!data.ctLikeIds){
                		data.ctLikeIds = [];
                	}
                    if(!this.isLogin){
                        this.$message({
                            message:'请先登录！',
                            type:'warning'
                        });
                        return false;
                    }
                    // 点赞某条评论 的用户Ids 判断  ids 中 是否存在当前用户的Id
                    if (data.ctLikeIds.indexOf(this.userId) > -1) {
//                        this.isClickedLike = false;
                        this.likeNum = -1;
                    } else {
//                        this.isClickedLike = true;
                        this.likeNum = 1;
                    }
                    var self = this;
                    this.$axios({
                        method: 'POST',
                        url: '/cms/cmsConmment/ajaxUpdateLikes',
                        data: {
                            id: data.id,
                            likes: self.likeNum
                        }
                    }).then(function (response) {
                        var data = response.data;
                        if (data.status == '1') {
                            self.getDataList();
                        }
                    }).catch(function () {
                        self.$message({
                            message: '请求失败',
                            type: 'error'
                        })
                    })

                }
            },
            created: function () {
                this.getDataList();
            }
        });

    }(Vue)
</script>


</body>
</html>