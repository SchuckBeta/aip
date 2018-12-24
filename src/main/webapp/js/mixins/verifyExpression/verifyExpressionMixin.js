/**
 * Created by Administrator on 2018/6/14.
 */


;+function (Vue) {
    'use strict';
    Vue.verifyExpressionMixin = {
        data: function () {
            return {
                identityReg: /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/,
                emailReg: /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/,
                mobileReg: /^((13[0-9])|(14[5,7,9])|(15[^4])|(18[0-9])|(17[0,1,3,5,6,7,8]))\d{8}$$/,
                qqReg: /^[1-9][0-9]{4,14}$/,
                userNoReg: /^[a-zA-Z0-9]+$/,
                loginNameReg: /['"\s]+/,
                userNameReg: /['"\s“”‘’]+/,
                specificSymbol: /[@#\$%\^&\*\s]+/g
            }
        },
        methods: {
            validateUserName: function (rule, value, callback) {
                if (value) {
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
                    return this.$axios.post('/sys/user/checkLoginName?loginName=' + value + '&userid=' + self.userBaseForm.userId).then(function (response) {
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

            validateLoginNameTeacher: function (rule, value, callback) {
                var self = this;
                if (value) {
                    if (this.loginNameReg.test(value)) {
                        return callback(new Error('登录名存在空格或者引号'))
                    }
                    return this.$axios.post('/sys/user/checkLoginName?loginName=' + value + '&userid=' + self.teacherForm.userid).then(function (response) {
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

            validateMobileXhr: function (rule, value, callback) {
                if (value) {
                    return this.$axios.post('/sys/user/checkMobileExist?mobile=' + value).then(function (response) {
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
            //后台修改手机号验证
            validateMobileBackXhr: function (rule, value, callback) {
                if (value) {
                    return this.$axios.post('/sys/user/checkMobile?mobile=' + value + "&id=" + this.userBaseForm.userId).then(function (response) {
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

            validateVerityCodeXhr: function (rule, value, callback) {
                if (value) {
                    return this.$axios.post('/mobile/checkMobileValidateCode?yzm=' + value).then(function (response) {
                        var data = response.data;
                        if (!data) {
                            return callback(new Error('验证码错误'))
                        }
                        return callback();
                    }).catch(function (error) {
                        return callback(new Error('请求失败'))
                    })
                }
                return callback()
            },

            validateEmailYZMXhr: function (rule, value, callback) {
                if (value) {
                    return this.$axios.get('/sys/frontStudentExpansion/checkEmailVerityCode?code=' + value).then(function (response) {
                        var data = response.data;
                        if (!data) {
                            return callback(new Error('验证码错误'))
                        }
                        return callback();
                    }).catch(function (error) {
                        return callback(new Error('请求失败'))
                    })
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
                var self = this;
                if (value) {
                    if (!this.userNoReg.test(value)) {
                        return callback(new Error('请输入英文或者数字'));
                    } else {
                        return this.$axios.post('/sys/user/checkUserNoUnique', {
                            id: (this.userBaseForm ? this.userBaseForm.userId : this.teacherForm.userid),
                            no: value
                        }).then(function (response) {
                            var data = response.data;
                            if (data) {
                                return callback();
                            }
                            return callback((self.userBaseForm ? '学号' : '职工号')+ '已经存在')
                        })
                    }
                }
                return callback()
            }
        }
    };


    Vue.verifyRegMixin = {
        data: function () {
            var self = this;
            var mobileReg = /^((13[0-9])|(14[5,7,9])|(15[^4])|(18[0-9])|(17[0,1,3,5,6,7,8]))\d{8}$$/;
            var yanzhengma = /^([a-zA-Z0-9]+)$/;
            var passwordReg = /^[0-9A-Za-z]{6,20}$/;

            var validateLoginNameXhr = function (rule, value, callback) {
                self.$axios({
                    method: 'POST',
                    url: '/register/checkLoginNameUnique?loginName=' + value
                }).then(function (response) {
                    var data = response.data;
                    if (!data) {
                        callback(new Error('登录名已被用'));
                    }
                    callback();
                }).catch(function () {
                    callback(new Error('请求失败'))
                })
            };
            var validateMobile = function (rule, value, callback) {
                if (self.selectedRegType == 'mobile') {
                    if (value) {
                        if (!mobileReg.test(value)) {
                            callback(new Error('请输入有效手机号'));
                        } else {
                            self.$axios({
                                method: 'POST',
                                url: '/register/validatePhone?mobile=' + value
                            }).then(function (response) {
                                var data = response.data;
                                if (!data) {
                                    callback(new Error('该手机号已被注册'));
                                }
                                callback();
                            }).catch(function () {
                                callback(new Error('请求失败'))
                            })
                        }
                    } else {
                        callback(new Error('手机号必填'));
                    }
                } else {
                    callback();
                }
            };
            var validateYanzhengma = function (rule, value, callback) {
                if (self.selectedRegType == 'mobile') {
                    if (value) {
                        if (!yanzhengma.test(value)) {
                            callback(new Error('验证码必须为数字或字母组成'));
                        } else {
                            self.$axios({
                                method: 'POST',
                                url: '/register/validateYZM?yzma=' + value
                            }).then(function (response) {
                                var data = response.data;
                                if (!data) {
                                    callback(new Error('验证码错误'));
                                }
                                callback();
                            }).catch(function () {
                                callback(new Error('请求失败'))
                            })
                        }
                    } else {
                        callback(new Error('验证码必填'));
                    }
                } else {
                    callback();
                }
            };
            var validateNo = function (rule, value, callback) {
                if (self.selectedRegType == 'no') {
                    if (value) {
                        self.$axios({
                            method: 'POST',
                            url: '/register/checkNoUnique?no=' + value
                        }).then(function (response) {
                            var data = response.data;
                            if (!data) {
                                callback(new Error('学号/工号已被注册'));
                            }
                            callback();
                        }).catch(function () {
                            callback(new Error('请求失败'))
                        })
                    } else {
                        callback(new Error('学号/工号必填'));
                    }
                } else {
                    callback();
                }
            };
            var validateValidateCode = function (rule, value, callback) {
                if (self.selectedRegType == 'no') {
                    if (value) {
                        self.$axios({
                            method: 'POST',
                            url: '/register/checkCode?regType=' + self.selectedRegType + '&code=' + value
                        }).then(function (response) {
                            var data = response.data;
                            if (!data) {
                                callback(new Error('验证码错误'));
                            }
                            callback();
                        }).catch(function () {
                            callback(new Error('请求失败'))
                        })
                    } else {
                        callback(new Error('验证码必填'));
                    }
                } else {
                    callback();
                }
            };
            var validatePasswordReg = function (rule, value, callback) {
                if (value) {
                    if (!passwordReg.test(value)) {
                        callback(new Error('密码必须由6~20位数字或字母组成'));
                    } else {
                        callback();
                    }
                }
                callback();
            };
            var validateConfirmPassword = function (rule, value, callback) {
                var pwd;
                if (self.userType == '1') {
                    pwd = self.studentForm.password;
                } else if (self.userType == '2') {
                    pwd = self.teacherForm.password;
                }
                if (value) {
                    if (value != pwd) {
                        callback(new Error('两次密码输入不一致'));
                    } else {
                        callback();
                    }
                }
                callback();
            };
            return {
                rules: {
                    loginName: [
                        {required: true, message: '登录名必填', trigger: 'blur'},
                        {validator: validateLoginNameXhr, trigger: 'blur'}
                    ],
                    name: [
                        {required: true, message: '真实姓名必填', trigger: 'blur'},
                        {min: 2, message: '真实姓名至少两个字符', trigger: 'blur'}
                    ],
                    mobile: [
                        {validator: validateMobile, trigger: 'blur'}
                    ],
                    yanzhengma: [
                        {validator: validateYanzhengma, trigger: 'blur'}
                    ],
                    no: [
                        {validator: validateNo, trigger: 'blur'}
                    ],
                    validateCode: [
                        {validator: validateValidateCode, trigger: 'blur'}
                    ],
                    password: [
                        {required: true, message: '密码必填', trigger: 'blur'},
                        {validator: validatePasswordReg, trigger: 'blur'}
                    ],
                    confirmPassword: [
                        {required: true, message: '确认密码必填', trigger: 'blur'},
                        {validator: validateConfirmPassword, trigger: 'blur'}
                    ]
                }
            }
        },
        methods: {}
    };

    Vue.frontLoginMixin = {
        data: function () {
            var self = this;
            var mobileReg = /^((13[0-9])|(14[5,7,9])|(15[^4])|(18[0-9])|(17[0,1,3,5,6,7,8]))\d{8}$$/;

            var validateUsername = function (rule, value, callback) {
                if (self.loginType == '1') {
                    if (value) {
                        if (!mobileReg.test(value)) {
                            callback(new Error('请输入有效手机号'));
                        } else {
                            self.$axios({
                                method: 'POST',
                                url: '/sys/user/isExistMobile?mobile=' + self.messageForm.username
                            }).then(function (response) {
                                var data = response.data;
                                if (!data) {
                                    callback(new Error('该手机号码未注册'))
                                }
                                callback();
                            }).catch(function () {
                                callback(new Error('请求失败'))
                            })
                        }
                    } else {
                        callback(new Error('手机号必填'));
                    }
                } else {
                    if (value) {
                        callback();
                    } else {
                        callback(new Error('登录名或学号必填'));
                    }
                }
            };

            var validatePassword = function (rule, value, callback) {
                if (self.loginType == '1') {
                    if (value) {
                        callback();
                    } else {
                        callback(new Error('验证码必填'));
                    }
                } else {
                    if (value) {
                        callback();
                    } else {
                        callback(new Error('密码必填'));
                    }
                }
            };

            var validateValidateCode = function (rule, value, callback) {
                if (self.loginType == '2' && self.isValidateCodeLogin == 'true') {
                    if (value) {
                        callback();
                    } else {
                        callback(new Error('验证码必填'));
                    }
                } else {
                    callback();
                }
            };

            return {
                rules: {
                    username: [
                        {validator: validateUsername, trigger: 'blur'}
                    ],
                    password: [
                        {validator: validatePassword, trigger: 'blur'}
                    ],
                    validateCode: [
                        {validator: validateValidateCode, trigger: 'blur'}
                    ]
                }
            }
        }
    };

    Vue.seekPwdMixin = {
        data: function () {
            var self = this;
            var mobileReg = /^((13[0-9])|(14[5,7,9])|(15[^4])|(18[0-9])|(17[0,1,3,5,6,7,8]))\d{8}$$/;
            var passwordReg = /^[0-9A-Za-z]{6,20}$/;

            var validatePhone = function (rule, value, callback) {
                if (value) {
                    if (!mobileReg.test(value)) {
                        callback(new Error('请输入有效手机号'));
                    } else {
                        callback();
                    }
                } else {
                    callback(new Error('手机号必填'));
                }
            };

            var validatePassword = function (rule, value, callback) {
                if (value) {
                    if (!passwordReg.test(value)) {
                        callback(new Error('密码必须由6~20位数字或字母组成'));
                    } else {
                        callback();
                    }
                } else {
                    callback(new Error('密码必填'));
                }
            };
            var validateConfirmPassword = function (rule, value, callback) {
                if (value) {
                    if (value != self.seekPwdThirdForm.password) {
                        callback(new Error('两次密码输入不一致'));
                    } else {
                        callback();
                    }
                } else {
                    callback(new Error('确认密码必填'));
                }
            };

            return {
                rules: {
                    phonemailxuehao: [
                        {validator: validatePhone, trigger: 'blur'}
                    ],
                    yanzhengma: [
                        {required: true, message: '验证码必填', trigger: 'blur'}
                    ],
                    validateCodePhone: [
                        {required: true, message: '短信验证码必填', trigger: 'blur'}
                    ],
                    password: [
                        {validator: validatePassword, trigger: 'blur'}
                    ],
                    confirmPassword: [
                        {validator: validateConfirmPassword, trigger: 'blur'}
                    ]
                }
            }
        }
    };

    Vue.leaveMsgMixin = {
        data: function () {
            var mobileReg = /^((13[0-9])|(14[5,7,9])|(15[^4])|(18[0-9])|(17[0,1,3,5,6,7,8]))\d{8}$$/;
            var emailReg = /^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$/;
            var qqReg = /^[1-9][0-9]{4,14}$/;


            var validatePhone = function (rule, value, callback) {
                if (value) {
                    if (!mobileReg.test(value)) {
                        callback(new Error('请输入有效的手机号'));
                    } else {
                        callback();
                    }
                } else {
                    callback();
                }
            };

            var validateEmail = function (rule, value, callback) {
                if (value) {
                    if (!emailReg.test(value)) {
                        callback(new Error('请输入有效的邮箱'));
                    } else {
                        callback();
                    }
                } else {
                    callback();
                }
            };
            var validateQQ = function (rule, value, callback) {
                if (value) {
                    if (!qqReg.test(value)) {
                        callback(new Error('请输入有效的QQ'));
                    } else {
                        callback();
                    }
                } else {
                    callback();
                }
            };
            return {
                leaveMsgFormRules: {
                    // name: [
                    //     {required: true, message: '请输入名称', trigger: 'blur'}
                    // ],
                    phone: [
                        // {required: true, message: '请输入手机号', trigger: 'blur'},
                        {validator: validatePhone, trigger: 'blur'}
                    ],
                    email: [
                        // {required: false, message: '请输入邮箱', trigger: 'blur'},
                        {validator: validateEmail, trigger: 'blur'}
                    ],
                    qq: [
                        // {required: false, message: '请输入QQ', trigger: 'blur'},
                        {validator: validateQQ, trigger: 'blur'}
                    ],
                    files: [
                        {required: false, message: '请上传图片', trigger: 'blur'}
                    ],
                    type: [
                        {required: true, message: '请选留言类型', trigger: 'blur'}
                    ],
                    content: [
                        {required: true, message: '请输入内容', trigger: 'blur'}
                    ]
                }
            }
        }
    };

    Vue.userManageMixin = {
        data: function () {
            var self = this;
            var nameReg = /['"\s“”‘’]+/;
            var userNoReg = /^[a-zA-Z0-9]+$/;
            var mobileReg = /^((13[0-9])|(14[5,7,9])|(15[^4])|(18[0-9])|(17[0,1,3,5,6,7,8]))\d{8}$$/;
            var validateLoginName = function (rule, value, callback) {
                if (nameReg.test(value)) {
                    callback(new Error('登录名存在空格或者引号'))
                } else {
                    self.$axios.post('/sys/user/checkLoginName?loginName=' + value + '&userid=' + self.createUserForm.id).then(function (response) {
                        var data = response.data;
                        if (!data) {
                            callback(new Error('登录名已存在'))
                        }
                        callback();
                    }).catch(function () {
                        callback(new Error('请求失败'))
                    });
                }
            };
            var validateName = function (rule, value, callback) {
                if (nameReg.test(value)) {
                    callback(new Error('姓名存在空格或者引号'))
                } else {
                    callback();
                }
            };
            var validateNo = function (rule, value, callback) {
                if (value) {
                    if (!userNoReg.test(value)) {
                        callback(new Error('请输入英文或者数字'));
                    } else {
                        self.$axios.post('/sys/user/checkNo?no=' + value + '&userid=' + self.createUserForm.id).then(function (response) {
                            var data = response.data;
                            if (!data) {
                                callback(new Error('该工号/学号已存在'))
                            }
                            callback();
                        }).catch(function () {
                            callback(new Error('请求失败'))
                        });
                    }
                } else {
                    callback();
                }
            };
            var validateMobile = function (rule, value, callback) {
                if (value) {
                    if (!mobileReg.test(value)) {
                        callback(new Error('请输入有效的手机号'));
                    } else {
                        self.$axios.post('/sys/user/checkMobile?mobile=' + value + '&id=' + self.createUserForm.id).then(function (response) {
                            var data = response.data;
                            if (!data) {
                                callback(new Error('手机号已存在'))
                            }
                            callback();
                        }).catch(function () {
                            callback(new Error('请求失败'))
                        });
                    }
                } else {
                    callback();
                }
            };
            var validateEmail = function (rule, value, callback) {
                var emailReg = /^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$/;
                if (value) {
                    if (!emailReg.test(value)) {
                        callback(new Error('请输入有效的邮箱'));
                    } else {
                        callback();
                    }
                } else {
                    callback();
                }
            };

            return {
                rules: {
                    loginName: [
                        {required: true, message: '请输入登录名', trigger: 'blur'},
                        {min: 1, max: 15, message: '长度在 1 到 15 个字符', trigger: 'blur'},
                        {validator: validateLoginName, trigger: 'blur'}
                    ],
                    roleIdList: [
                        {required: true, message: '请选择用户角色', trigger: 'blur'}
                    ],
                    professional: [
                        {required: true, message: '请选择所属机构', trigger: 'blur'}
                    ],
                    name: [
                        {required: true, message: '请输入姓名', trigger: 'blur'},
                        {min: 1, max: 15, message: '长度在 1 到 15 个字符', trigger: 'blur'},
                        {validator: validateName, trigger: 'blur'}
                    ],
                    no: [
                        {required: true, message: '请输入学号/工号', trigger: 'blur'},
                        {min: 2, max: 24, message: '长度在 2 到 24 个字符', trigger: 'blur'},
                        {validator: validateNo, trigger: 'blur'}
                    ],
                    mobile: [
                        {validator: validateMobile, trigger: 'blur'}
                    ],
                    email: [
                        {validator: validateEmail, trigger: 'blur'}
                    ]
                }
            }
        }
    };


    Vue.roomFormMixin = {
        data: function () {
            var self = this;
            var nameReg = /['"\s“”‘’]+/;
            var mobileReg = /^((13[0-9])|(14[5,7,9])|(15[^4])|(18[0-9])|(17[0,1,3,5,6,7,8]))\d{8}$$/;
            var reg = /^[1-9][0-9]*$/;
            var validatePlace = function (rule, value, callback) {
                if (self.spaceListEntries[value].type != '4') {
                    callback(new Error('请选择楼层'))
                } else {
                    callback();
                }
            };
            var validateName = function (rule, value, callback) {
                if (nameReg.test(value)) {
                    callback(new Error('房间名称存在空格或者引号'))
                } else if(value != self.currentName){
                    self.$axios.get('/pw/pwRoom/ajaxVerifyName?sid=' + self.roomForm.pwSpace.id + '&name=' + value).then(function (response) {
                        var data = response.data;
                        if (data.status == '0') {
                            callback(new Error('同楼层房间名已存在'))
                        }
                        callback();
                    }).catch(function () {
                        callback(new Error('请求失败'))
                    });
                }else{
                    callback();
                }
            };

            var validatePerson = function (rule, value, callback) {
                if (nameReg.test(value)) {
                    callback(new Error('负责人存在空格或者引号'))
                } else {
                    callback();
                }
            };
            var validateMobile = function (rule, value, callback) {
                if (value) {
                    if (!mobileReg.test(value)) {
                        callback(new Error('请输入有效的联系电话'));
                    } else {
                        callback();
                    }
                }
            };
            var validateArea = function (rule, value, callback) {
                var arr,frontLen,lastLen;
                value = value.toString();
                arr = value.split('.');
                frontLen = arr[0].length;
                if(arr.length >= 2){
                    lastLen = arr[1].length;
                }
                if (value && frontLen > 6 && !lastLen) {
                    callback(new Error('占地面积小数点前最大6位数'));
                } else if(value && frontLen <= 6 && lastLen > 4) {
                    callback(new Error('占地面积小数点后最大4位数'));
                }else{
                    callback();
                }
            };
            var validateNum = function (rule, value, callback) {
                var len = value.toString().split('').length;
                if (!reg.test(value)) {
                    callback(new Error('请输入正整数'));
                }else if((len > 6)){
                    callback(new Error('房间容量最大6位数'))
                } else if(self.roomForm.numtype == ''){
                    callback(new Error('请选择容量类型'))
                }else{
                    callback();
                }
            };
            return {
                roomFormRules: {
                    pwSpace:{
                        id:[
                            {required: true, message: '请选择场地', trigger: 'change'},
                            {validator: validatePlace, trigger: 'change'}
                        ]
                    },
                    name: [
                        {required: true, message: '请输入房间名称', trigger: 'change'},
                        {min: 1, max: 20, message: '长度在 1 到 20 个字符', trigger: 'change'},
                        {validator: validateName, trigger: 'blur'}
                    ],
                    mobile: [
                        {required: true, message: '请输入联系电话', trigger: 'change'},
                        {validator: validateMobile, trigger: 'blur'}
                    ],
                    person: [
                        {required: true, message: '请输入负责人', trigger: 'change'},
                        {min: 1, max: 100, message: '长度在 1 到 15 个字符', trigger: 'change'},
                        {validator: validatePerson, trigger: 'change'}
                    ],
                    type: [
                        {required: true, message: '请选择房间类型', trigger: 'change'}
                    ],
                    num: [
                        {required: true, message: '请输入房间容量', trigger: 'change'},
                        {validator: validateNum, trigger: 'change'}
                    ],
                    color: [
                        {required: true, message: '请选择预约房间色值', trigger: 'change'}
                    ],
                    area: [
                        {validator: validateArea, trigger: 'change'}
                    ]
                }
            }
        }
    };


}(Vue)