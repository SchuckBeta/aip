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
        <edit-bar second-name="校区查看"></edit-bar>
    </div>

    <el-row :gutter="20" label-width="120px">
        <el-col :span="20" v-if="school">
            <e-col-item label="所属学院：">{{school}}</e-col-item>
        </el-col>
        <el-col :span="20">
            <e-col-item label="校区名称：">{{pwSpace.name}}</e-col-item>
        </el-col>
        <el-col :span="20">
            <e-col-item label="备注：">{{pwSpace.remarks}}</e-col-item>
        </el-col>
        <el-col :span="20">
            <e-col-item>
                <el-button size="mini" @click.stop.prevent="goToBack">返回</el-button>
            </e-col-item>
        </el-col>
    </el-row>

</div>

<script>

    'use strict';

    new Vue({
        el: '#app',
        data: function () {
            var pwSpace = JSON.parse('${fns:toJson(pwSpace)}');
            return {
                pwSpace: pwSpace,
                school:'${school}',
                message: '${message}'
            }
        },
        methods: {
            goToBack: function () {
                window.location.href = this.frontOrAdmin + '/pw/pwSpace/list';
            }
        },
        created: function () {
            if (this.message) {
                this.$message({
                    message: this.message,
                    type: this.message.indexOf('成功') > -1 ? 'success' : 'warning'
                });
                this.message = '';
            }
        }
    })

</script>

</body>
</html>