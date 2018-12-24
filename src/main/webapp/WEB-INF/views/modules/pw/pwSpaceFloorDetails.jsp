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
        <edit-bar second-name="楼层查看"></edit-bar>
    </div>

    <el-row :gutter="20" label-width="120px">
        <el-col :span="20" v-if="school">
            <e-col-item label="所属学院：">{{school}}</e-col-item>
        </el-col>
        <el-col :span="20" v-if="campus">
            <e-col-item label="所属校区：">{{campus}}</e-col-item>
        </el-col>
        <el-col :span="20" v-if="base">
            <e-col-item label="所属基地：">{{base}}</e-col-item>
        </el-col>
        <el-col :span="20" v-if="building">
            <e-col-item label="所属楼栋：">{{building}}</e-col-item>
        </el-col>
        <el-col :span="20">
            <e-col-item label="楼层名称：">{{pwSpace.name}}</e-col-item>
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
                campus:'${campus}',
                base:'${base}',
                building:'${building}',
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