/**
 * Created by Administrator on 2018/6/14.
 */



'use strict';
Vue.verifyExpressionBackMixin = {
    data: function () {
        return {
            identityReg: /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/,
            emailReg: /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/,
            mobileReg: /^((13[0-9])|(14[5,7,9])|(15[^4])|(18[0-9])|(17[0,1,3,5,6,7,8]))\d{8}$$/,
            qqReg: /^[1-9][0-9]{4,14}$/,
            userNoReg: /^[a-zA-Z0-9]+$/,
            loginNameReg: /['"\s]+/,
            userNameReg: /['"\s“”‘’]+/
        }
    },
    methods: {
        validateMobile: function (rule, value, callback) {
            if (value) {
                if (!this.mobileReg.test(value)) {
                    return callback(new Error('请输入有效手机号'));
                } else {
                    return callback()
                }
            }
            return callback()
        },
        validateUserName: function (rule, value, callback) {
            if(value) {
                if (this.userNameReg.test(value)) {
                    return callback(new Error('姓名存在空格或者引号'))
                }
            }
            return callback()
        },
        validateLoginName: function (rule, value, callback) {
            var self = this;
            if (value) {
                if (this.loginNameReg.test(value)) {
                    return callback(new Error('登录名存在空格或者引号'))
                }
                return this.$axios.post('/sys/backTeacherExpansion/checkLoginName', { loginName: value, id:  self.teacherForm.userid}).then(function (response) {
                    var data = response.data;
                    if (!data) {
                        return callback(new Error('登录名已存在'))
                    }
                    return callback();
                }).catch(function (error) {
                    return callback(new Error('请求失败'))
                })
            }
            return callback()
        },
        validateMobileXhr: function (rule, value, callback) {
            if (value) {
                return this.$axios.get('/sys/user/checkMobile?mobile=' + value+'&id=').then(function (response) {
                    var data = response.data;
                    if (!data) {
                        return callback(new Error('手机号已经存在'))
                    }
                    return callback();
                }).catch(function (error) {
                    return callback(new Error('请求失败'))
                })
            }
            return callback()
        },

        validateTeacherFormMobileXhr: function (rule, value, callback) {
            if (value) {
                return this.$axios.get('/sys/user/checkMobile?mobile=' + value+'&id='+this.teacherForm.userid).then(function (response) {
                    var data = response.data;
                    if (!data) {
                        return callback(new Error('手机号已经存在'))
                    }
                    return callback();
                }).catch(function (error) {
                    return callback(new Error('请求失败'))
                })
            }
            return callback()
        },

        validateEmail: function (rule, value, callback) {
            if (value) {
                if (!this.emailReg.test(value)) {
                    return callback(new Error('请输入有效邮箱地址'));
                } else {
                    return callback()
                }
            }
            return callback()
        },



        validateIdentity: function (rule, value, callback) {
            if (value) {
                if (!this.identityReg.test(value)) {
                    return callback(new Error('请输入有效的有效的身份证号码'));
                } else {
                    return callback()
                }
            }
            return callback()
        },

        validateQQ: function (rule, value, callback) {
            if (value) {
                if (!this.qqReg.test(value)) {
                    return callback(new Error('请输入有效QQ号'));
                } else {
                    return callback()
                }
            }
            return callback()
        },
        validateUserNo: function (rule, value, callback) {
            if (value) {
                if (!this.userNoReg.test(value)) {
                    return callback(new Error('请输入英文或者数字'));
                }
              return  this.$axios.get('/sys/user/checkNo?no=' + value+'&id=').then(function (response) {
                    //后台代码返回有误，开卡表单有用到
                    if (response.data) {
                        return callback()
                    }else {
                        return callback(new Error('学号已存在'))
                    }

                })
            }
            return callback()
        },
        //导师风采
        validateTeacherFormUserNo: function (rule, value, callback) {
            if (value) {
                if (!this.userNoReg.test(value)) {
                    return callback(new Error('请输入英文或者数字'));
                }
                return  this.$axios.get('/sys/user/checkNo?no=' + value+'&userid='+this.teacherForm.userid).then(function (response) {
                    if (response.data) {
                        return callback()
                    }else {
                        return callback(new Error('职工号已存在'))
                    }

                })
            }
            return callback()
        }
    }
};


