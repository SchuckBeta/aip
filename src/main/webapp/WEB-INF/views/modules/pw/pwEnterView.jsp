<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${backgroundTitle}</title>
    <%@include file="/WEB-INF/views/include/backcreative.jsp" %>
    <script type="text/javascript" src="/js/components/pwEnter/pwEnterMixin.js?version=${fns: getVevison()}"></script>
    <script type="text/javascript" src="/js/components/pwEnter/pwEnterView.js?version=${fns: getVevison()}"></script>

</head>
<body>
<div id="app" v-show="pageLoad" class="container-fluid mgb-60" style="display: none">
    <div class="mgb-20">
        <edit-bar second-name="审核"></edit-bar>
    </div>
    <div class="panel panel-pw-enter mgb-20">
        <div class="panel-body" style="min-width: 1086px;">
            <applicant-info :pw-enter-id="pwEnterId"></applicant-info>
            <div class="pro-category-placeholder"></div>
        </div>
    </div>
    <div class="pro-contest-content panel-padding-space">
        <el-tabs class="pro-contest-tabs" v-model="tabActiveName">
            <el-tab-pane v-if="type == '2'" label="企业信息" name="firstPwEnterTab">
                <tab-pane-content>
                    <pw-enter-company :pw-enter-id="pwEnterId"></pw-enter-company>
                </tab-pane-content>
            </el-tab-pane>
            <el-tab-pane label="团队信息" name="secondPwEnterTab">
                <tab-pane-content>
                    <pw-enter-team :pw-enter-id="pwEnterId"></pw-enter-team>
                </tab-pane-content>
            </el-tab-pane>
        </el-tabs>
    </div>
</div>

<script type="text/javascript">
    'use strict';

    new Vue({
        el: '#app',
        data: function () {
            var pwEnterId = '${pwEnterId}';
            var type = '${type}';
            return {
                pwEnterId: pwEnterId,
                type: type,
                tabActiveName: type === '2' ? 'firstPwEnterTab' : 'secondPwEnterTab'
            }
        }
    })
</script>
</body>
</html>