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
        <edit-bar second-name="楼栋查看"></edit-bar>
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
        <el-col :span="20">
            <e-col-item label="楼栋名称：">{{pwSpace.name}}</e-col-item>
        </el-col>
        <el-col :span="20">
            <e-col-item label="负责人：">{{pwSpace.person}}</e-col-item>
        </el-col>
        <el-col :span="20">
            <e-col-item label="联系方式：">{{pwSpace.phone}}</e-col-item>
        </el-col>
        <el-col :span="20">
            <e-col-item label="开放时间：">
                <div class="open-time-cell">
                    <div>
                        <div class="open-time-cell-label">开放日：</div>
                        {{openWeeksStr(pwSpace.openWeeks)}}
                    </div>
                    <div>
                        <div class="open-time-cell-label">时间：</div>
                        <div class="open-time-cell-date">
                            <div>上午：{{pwSpace.amOpenStartTime}}-{{pwSpace.amOpenEndTime}}</div>
                            <div>下午：{{pwSpace.pmOpenStartTime}}-{{pwSpace.pmOpenEndTime}}</div>
                        </div>
                    </div>
                </div>
            </e-col-item>
        </el-col>
        <el-col :span="20">
            <e-col-item label="楼层：">{{pwSpace.floorNum}}</e-col-item>
        </el-col>
        <el-col :span="20">
            <e-col-item label="占地面积：">{{pwSpace.area}}平方米</e-col-item>
        </el-col>
        <el-col :span="20">
            <e-col-item label="建筑图片：">
                <img :src="src" alt="" style="width:270px;">
            </e-col-item>
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
                message: '${message}',
                src:''
            }
        },
        methods: {
            openWeeksStr: function (arr) {
                if (arr) {
                    if (arr.length == 7) {
                        return '不限';
                    }
                    var r = '';

                    arr.forEach(function (item) {
                        switch (item) {
                            case '1':
                                r += '每周一、';
                                break;
                            case '2':
                                r += '每周二、';
                                break;
                            case '3':
                                r += '每周三、';
                                break;
                            case '4':
                                r += '每周四、';
                                break;
                            case '5':
                                r += '每周五、';
                                break;
                            case '6':
                                r += '每周六、';
                                break;
                            case '7':
                                r += '每周日、';
                                break;
                            default:
                                break;
                        }
                    });
                    if (r != '') {
                        return r.substring(0, r.length - 1);
                    }
                }
            },
            goToBack: function () {
                window.location.href = this.frontOrAdmin + '/pw/pwSpace/list';
            }
        },
        created: function () {
            this.src = this.addFtpHttp(this.pwSpace.imageUrl);
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