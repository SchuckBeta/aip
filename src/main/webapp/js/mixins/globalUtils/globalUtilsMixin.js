/**
 * Created by Administrator on 2018/6/14.
 */

'use strict';

Vue.mixin({
    data: function () {
        return {
            responseCodes: {
                '1001': 'Token失效',
                '1002': '参数有误',
                '1003': '内部错误'
            }
        }
    },
    methods: {
        getEntries: function (data, defaultProps) {
            var i = 0, entries = {};
            defaultProps = defaultProps || {value: 'value', label: 'label'};
            if (!data || data.length < 1) {
                return null;
            }
            while (i < data.length) {
                entries[data[i][defaultProps.value]] = data[i][defaultProps.label];
                i++
            }
            return entries;
        },

        checkUserLogin: function (data) {
            try {
                var isChecked = data.indexOf("id=\"imFrontLoginPage\"") > -1;
                if (isChecked) {
                    this.$confirm('未登录或登录超时。请重新登录，谢谢', '提示', {
                        confirmButtonText: '确定',
                        cancelButtonText: '取消',
                        type: 'warning'
                    }).then(function () {
                        location.reload();
                    })
                }
            } catch (e) {
                isChecked = false;
            }

            return isChecked;
        },


        addFtpHttp: function (url) {
            if (!url) {
                return ''
            }
            return this.ftpHttp + url.replace('/tool', '');
        },

        getUserIsCompleted: function () {
            return this.$axios.get('/cms/ajaxCheckUser')
        },


        checkResponseCode: function (code, msg, showMessage) {
            var self = this;
            if(typeof showMessage === 'undefined'){
                showMessage = true;
            }
            if (code in this.responseCodes && showMessage) {
                this.$alert(msg || this.responseCodes[code], '提示', {
                    confirmButtonText: '确定',
                    type: 'error',
                    showClose: code !== '1001'
                }).then(function () {
                    if (code === '1001') {
                        location.href = self.frontOrAdmin;
                    }
                });
                return false;
            } else {
                if (code == 1000) {
                    return true;
                }
            }
            return true;
        },

        isResponseSuccess: function (code) {
            return code == 1000
        },

        setSearchListFormPagination: function () {

        }
    }
})
