<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ page errorPage="/WEB-INF/views/error/formMiss.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>

<body>


<div id="app" v-show="pageLoad" style="display: none" class="container-fluid mgb-60">
    <div class="mgb-20">
        <edit-bar></edit-bar>
    </div>

    <div class="search-block_bar clearfix">
        <div class="search-btns">
            <el-button size="mini" type="primary" @click.stop.prevent="reset">重置</el-button>
        </div>
    </div>

    <div class="table-container">
        <el-table :data="indexComponents" v-loading="loading" size="mini" class="table" ref="indexComponents" style="margin-bottom: 0">
            <el-table-column prop="sname"label="名称"></el-table-column>
            <el-table-column prop="enable" align="center" label="显示/隐藏">
                <template slot-scope="scope">
                    <el-switch v-model="scope.row.enable" @change="saveIsShow(scope.row)"></el-switch>
                </template>
            </el-table-column>
        </el-table>
    </div>

</div>

<script>

    'use strict';

    new Vue({
        el: '#app',
        data:  function () {
            return {
                indexComponents: [],
                loading:false
            }
        },
		methods:{
			reset:function(){
				var self = this;
                this.loading = true;
                this.$axios({
                    method: 'POST',
                    url: '/actyw/actYwGtheme/ajaxRest'
                }).then(function (response) {
                    var data = response.data;
                    if (data.status == '1') {
                        self.getDataList();
                    }
                    self.loading = false;
                }).catch(function (error) {
                    self.loading = false;
                    self.$message({
                        message: error.response.data,
                        type : 'error'
                    })
                });
			},
            getDataList:function () {
                var self = this;
                this.loading = true;
                this.$axios({
                    method: 'POST',
                    url: '/actyw/actYwGtheme/ajaxList'
                }).then(function (response) {
                    var data = response.data;
                    if (data.status == '1') {
                        self.indexComponents = data.data.list || [];
                    }
                    self.loading = false;
                }).catch(function (error) {
                    self.loading = false;
                    self.$message({
                        message: error.response.data,
                        type : 'error'
                    })
                });
            },
            saveIsShow:function (value) {
                var self = this;
                this.loading = true;
                this.$axios({
                    method:'POST',
                    url:'/actyw/actYwGtheme/ajaxUpdateEnable?id=' + value.id + '&enable=' + value.enable
                }).then(function (response) {
                    var data = response.data;
                    if(data.status == '1'){
                        self.getDataList();
                    }else{
                        self.$message({
                            message: '操作失败',
                            type: 'error'
                        });
                    }
                    self.loading = false;
                }).catch(function () {
                    self.loading = false;
                    self.$message({
                        message:'操作失败',
                        type:'error'
                    })
                });
            }
		},
        created:function () {
            this.getDataList();
        }
    })

</script>

</body>
</html>