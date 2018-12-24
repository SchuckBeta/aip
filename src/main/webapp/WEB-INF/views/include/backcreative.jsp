<%@ page  pageEncoding="UTF-8" %>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10"/>
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Cache-Control" content="no-store">

<link rel="stylesheet" type="text/css" href="/css/cyjd/common.css?v=1021121111181111">
<link rel="stylesheet" href="${ctxStatic}/element@2.3.8/index.css">
<link rel="stylesheet" type="text/css" href="${ctxStatic}/cropper/cropper.min.css">

<%--<link rel="stylesheet" href="/css/cyjd/creatives.css?v=1234">--%>

<%--<link rel="stylesheet" href="/css/cyjd/index.bundle.css">--%>
<%--<link rel="stylesheet" href="/css/cyjd/main.bundle.css">--%>
<link rel="stylesheet" href="/css/common/common.bundle.css?version=${fns: getVevison()}">
<link rel="stylesheet" href="/css/cyjd/backCreative.bundle.css?version=${fns: getVevison()}">

<script>
    $frontOrAdmin = "${frontOrAdmin_2ed8fe6ddd034cffa47a41e42a694948}";
</script>

<script src="${ctxStatic}/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
<script type="text/javascript" src="${ctxStatic}/cropper/cropper.min.js"></script>
<script src="${ctxStatic}/axios/axios.js"></script>
<%--<script src="https://cdn.bootcss.com/babel-polyfill/6.23.0/polyfill.min.js"></script>--%>
<script src="${ctxStatic}/vue/vue.js"></script>
<script src="/js/globalUtils/bluebird.min.js"></script> <!--兼容promise对象-->
<script src="${ctxStatic}/element@2.3.8/index.js"></script>
<script src="${ctxStatic}/vueDraggable/Sortable.min.js"></script>
<script src="${ctxStatic}/vueDraggable/vuedraggable.min.js"></script>
<script src="${ctxStatic}/moment/moment.min.js"></script>
<script src="/js/cityData/citydataNew.js?version=${fns: getVevison()}"></script>
<script src="/js/globalUtils/globalUtils.js"></script>
<script src="/js/filters/filters.js?version=${fns: getVevison()}"></script>
<script src="/js/mixins/verifyExpression/verifyExpressionMixin.js"></script>
<%--<script src="${ctxStatic}/vue/vue.min.js"></script>--%>

<%--<script src="${ctxStatic}/axios/axios.min.js"></script>--%>
<script src="/js/components/passwordForm/passwordForm.js?version=${fns: getVevison()}"></script><!---修改密码-->
<script src="/js/mixins/colleges/collegesMixin.js"></script>
<script src="/js/mixins/menuTree/menuTreeMixin.js"></script>
<script src="/js/mixins/globalUtils/globalUtilsMixin.js"></script>
<script src="/js/directives/globalDirectives.js"></script>
<script src="/js/mixins/verifyExpression/verifyExpressionBackMixin.js"></script>
<script src="/js/mixins/verifyExpression/verifyExpressionMixin.js"></script>
<script src="/js/mixins/drPwSpaceList/drPwSpaceList.js"></script>
<script src="/js/mixins/menuTree/menuTreeMixin.js"></script>
<script src="/js/components/echart/echart-directive.js"></script>
<script src="/js/components/editBar/editBar.js"></script>
<script src="/js/components/checkbox/checkboxGroup.js"></script>
<script src="/js/components/checkbox/checkbox.js"></script>
<script src="/js/components/radio/radioGroup.js"></script>
<script src="/js/components/radio/radio.js"></script>
<script src="/js/components/stuTea/stuTea.js"></script>
<script src="/js/components/eColItem/eColItem.js"></script>
<script src="/js/components/eFileItem/eFileItem.js"></script>
<script src="/js/components/proProgress/proProgress.js"></script>
<script src="/js/components/condition/e-condition.js?v=1"></script>
<script src="/js/components/cropperPic/ePicFIle.js"></script>
<script src="/js/components/cropperPic/cropperPic.js"></script> <!--图片裁剪-->
<script src="/js/components/controlRuleBlock/controlRuleBlock.js"></script>
<script src="/js/components/echart/echartBar.js"></script>
<script src="/js/components/echart/echartPie.js"></script>
<script src="/js/components/echart/echartLine.js"></script>
<script src="/js/components/echart/echartBase.js"></script>
<script src="/js/components/echart/echartProApprovalType.js"></script>
<script src="/js/components/buttonImport/buttonImport.js"></script>
<script src="/js/components/buttonImport/buttonExport.js"></script>
<script src="/js/components/buttonImport/buttonExportFile.js"></script>
<script src="/js/components/buttonImport/buttonAdviceLevel.js"></script>
<script src="/js/components/buttonImport/buttonBatchCheck.js"></script>
<script src="/js/components/buttonImport/buttonAuditRecord.js"></script>
<script src="/js/components/buttonImport/exportFileProcess.js"></script>
<script src="/js/components/buttonImport/projectInfoList.js"></script>
<script src="/js/components/buttonImport/exportExPro.js"></script>
<script src="/js/components/eSetText/eSetText.js"></script>
<script src="/js/components/eSetName/eSetName.js"></script>
<script src="/js/components/eSetWordText/eSetWordText.js"></script>
<script src="/js/components/proContestDetail/proContestDetail.js?version=${fns: getVevison()}"></script>
<script src="/js/components/panel/e-panel.js?version=${fns: getVevison()}"></script>
<script src="/js/components/auditForm/auditForm.js?version=${fns: getVevison()}"></script>
<script src="/js/components/auditForm/scoreForm.js?version=${fns: getVevison()}"></script>
<script src="/js/components/uploadFile/uploadFile.component.js?version=${fns: getVevison()}"></script>
<script src="/js/components/uploadFile/uploadFile.pw.component.js?version=${fns: getVevison()}"></script>
<script src="/js/components/common/commonComponents.js?version=${fns: getVevison()}"></script>
<script src="/js/components/tableColBlock/tableTeamMember.js?version=${fns: getVevison()}"></script>
<script src="/js/components/tableColBlock/tableThingInfo.js?version=${fns: getVevison()}"></script>
<script type="text/javascript" src="/js/components/pwEnter/pwEnterMixin.js?version=${fns: getVevison()}"></script>
<script type="text/javascript" src="/js/components/updateMember/updateMember.js?version=${fns: getVevison()}"></script>
<script type="text/javascript" src="/js/components/pwEnter/pwEnterApplyRules.js?version=${fns: getVevison()}"></script>
<script type="text/javascript" src="/js/components/pwEnter/pwEnterApplyForm.js?version=${fns: getVevison()}"></script>
<script type="text/javascript" src="/js/components/pwEnter/pwEnterList.js?version=${fns: getVevison()}"></script>
<script type="text/javascript" src="/js/components/pwEnter/pwEnterView.js?version=${fns: getVevison()}"></script>
<script>
    +function (window) {

        'use strict';

        var token = (function () {
            var arr, reg = new RegExp("(^| )" + 'token' + "=([^;]*)(;|$)");
            return (arr = document.cookie.match(reg)) ? unescape(arr[2]) : null;
        })();



        Vue.mixin({
            data: function () {
                return {
                    pageLoad: false,
                    formSubmitMessage: '${message}',
                    frontOrAdmin: "${frontOrAdmin_2ed8fe6ddd034cffa47a41e42a694948}",
                    ftpHttp: '${fns:ftpHttpUrl()}',
                    xhrErrorMsg: '请求失败'
                }
            },
            methods: {
                show$message: function (data, message) {
                    var type = (parseInt(data.ret) || data.status) ? 'success' : 'error';
                    var msg = data.msg || message;
                    if (!msg) {
                        return false;
                    }
                    this.$message({
                        type: type,
                        center: true,
                        message: msg
                    })
                }
            },
            created: function () {
                this.pageLoad = true;
            }
        });




        window.paginationMixin = {
            data: function () {
                return {
                    searchFormName: 'searchListForm'
                }
            },
            mounted: function () {
                var self = this;
                $("#ps").val($("#pageSize").val());
                window.page = function (n, s) {
                    $("#pageNo").val(n);
                    $("#pageSize").val(s);
                    self.$refs[self.searchFormName].$el.submit();
                }
            }
        };



        window.ctx = '${ctx}';
        //全局配置axios；
        axios.defaults.baseURL = '${ctx}';
        axios.defaults.timeout = '6000';
        axios.interceptors.request.use(function (config) {
            if(config.url.indexOf('?') == -1){
                config.url += '?';
            }else {
                config.url += '&';
            }
            config.url += 't=' + Date.parse(new Date())/1000;
            return config
        },function(error){
            try {
                return Promise.reject(error)
            }catch (e){

            }
        })
//            console.log(Promise)
        axios.interceptors.response.use(function (response) {
            // Do something with response data
            var data = response;
            try {
                data.data = JSON.parse(data.data);
            }catch (e){

            }
            return data;
        }, function (error) {
            // Do something with response error
            try {
                return Promise.reject(error);
            }catch (e){

            }
        });
        axios.defaults.headers = {
            'token': token
        };
        Vue.prototype.$axios = axios;


        //封装object assign
        if (typeof Object.assign != 'function') {
            (function () {
                Object.assign = function (target) {
                    'use strict';
                    if (target === undefined || target === null) {
                        throw new TypeError('Cannot convert undefined or null to object');
                    }

                    var output = Object(target);
                    for (var index = 1; index < arguments.length; index++) {
                        var source = arguments[index];
                        if (source !== undefined && source !== null) {
                            for (var nextKey in source) {
                                if (source.hasOwnProperty(nextKey)) {
                                    output[nextKey] = source[nextKey];
                                }
                            }
                        }
                    }
                    return output;
                };
            })();
        }

        Object.toURLSearchParams = function (data) {
            'use strict';
            if (data === undefined || data === null) {
                throw new TypeError('Cannot convert undefined or null to object');
            }
            if(typeof URLSearchParams === 'function'){
                var params = new URLSearchParams();
                for(var k in data){
                    if(data.hasOwnProperty(k)){
                        if(data[k]){
                            params.append(k, data[k]);
                        }
                    }
                }
                return params;
            }
            var str = [];
            var strObj = {};
            for(var k2 in data){
                if(data.hasOwnProperty(k2)){
                    if({}.toString.call(data[k2]) === '[object Array]'){
                        var vStr = data[k2].join(',');
                        if(vStr){
                            strObj[k2] = (k2 + '='+ encodeURI(vStr))
                        }
                    }else {
                        if(data[k2] != undefined){
                            strObj[k2] = (k2 + '='+encodeURI(data[k2]))
                        }
                    }

                    strObj[k2] && str.push(strObj[k2])
                }
            }
            return str.join('&')
        }

    }(window)
</script>


