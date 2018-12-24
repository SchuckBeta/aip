<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>
<!DOCTYPE html>
<html>

<head>
    <title>${frontTitle}</title>
    <meta charset="UTF-8">
    <meta name="decorator" content="creative"/>
</head>

<body>
<div id="app" v-show="pageLoad" style="display: none" class="container page-container pdt-60">
    <el-breadcrumb class="mgb-20" separator-class="el-icon-arrow-right">
        <el-breadcrumb-item><a href="/f"><i class="iconfont icon-ai-home"></i>首页</a></el-breadcrumb-item>
        <el-breadcrumb-item><a href="/f/page-SCtognzhi">{{bcrumbsName}}</a></el-breadcrumb-item>
        <el-breadcrumb-item>详情</el-breadcrumb-item>
    </el-breadcrumb>
    <div class="base-content-container">
        <h3 class="bc-title">
            ${oaNotify.title}
        </h3>
        <div class="bc-sources">
            <span>发布时间：<fmt:formatDate value="${oaNotify.updateDate}" pattern="yyyy.MM.dd"/></span>
            <span>来源：${oaNotify.source}</span>
            <span>浏览量：${oaNotify.views}</span>
        </div>

        <div class="bc-content">
            <!--正文-->
            ${oaNotify.content}
        </div>
        <div  class="recommend-block">
            <h4 class="recommend-title"><span>相关推荐</span></h4>
            <ul class="recommend-list">
                <li class="recommend-item" v-for="item in moreList">
                    <a :href="frontOrAdmin+'/oa/oaNotify/viewDynamic?id='+item.id">{{item.title}}</a>
                    <span class="date">{{item.update_date | formatDateFilter('YYYY-MM-DD')}}</span>
                </li>
            </ul>
            <p v-if="moreList.length < 1" class="empty-color empty">暂无推荐</p>
        </div>
    </div>
</div>

<script type="text/javascript">


    'use strict';

    new Vue({
        el: '#app',
        data: function () {
            var oaNotify = JSON.parse(JSON.stringify(${fns: toJson(oaNotify)}));
            var moreList = JSON.parse(JSON.stringify(${fns: toJson(more)}));
            return {
                oaNotify: oaNotify,
                moreList: moreList || [],
                bcrumbsName: ''
            }
        },
        methods: {
            getBcrumbsName: function () {
                var self = this;
                this.$axios.get('/cms/index/getBcrumbsName?code=homeNotice').then(function (response) {
                    var data = response.data;
                    self.bcrumbsName = data.data.modelname
                })
            }
        },
        created: function () {
            this.getBcrumbsName();
        }
    })

</script>

</body>

</html>