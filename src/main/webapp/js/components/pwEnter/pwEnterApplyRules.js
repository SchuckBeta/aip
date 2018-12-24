Vue.pwApplyRules = {
    data: function () {
        return {
            numberReg: /^\d+$/,
            specificSymbol: /[@#\$%\^&\*\s]+/g
        }
    },
    methods: {
        validateEnterpriseName: function (rule, value, callback) {
            if (value) {
                if (this.specificSymbol.test(value)) {
                    return callback(new Error("请不要输入特殊符号"))
                }
                var pwCompany = this.enterpriseForm;
                var params = {
                    id: this.pwEnterId,
                    pwCompany: {
                        id: pwCompany.id,
                        name: pwCompany.name,
                        no: pwCompany.no
                    }
                };
                return this.$axios.post('/pw/pwEnter/checkPwEnterCompany', params).then(function (response) {
                    if (response.data) {
                        return callback();
                    }
                    return callback(new Error("企业名称或者工商注册号已已经存在"));
                }).catch(function (error) {
                    return callback(new Error("请求失败"));
                })
            }
            return callback();
        },
        validateRegMoney: function (rule, value, callback) {
            if (value) {
                if (!this.numberReg.test(value)) {
                    return callback(new Error("请输入数字"))
                }
                if (value.toString().length > 7) {
                    return callback(new Error("请输入不超过7位数的金额"))
                }
            }
            return callback();
        },
    }
}