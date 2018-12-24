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
                    }
                };
                return this.$axios.post('/pw/pwEnter/checkPwEnterCompanyName', params).then(function (response) {
                    if (response.data) {
                        return callback();
                    }
                    return callback(new Error("企业名称已经存在"));
                }).catch(function (error) {
                    return callback(new Error("请求失败"));
                })
            }
            return callback();
        },
        validateEnterpriseNo: function (rule, value, callback) {
            if (value) {
                if (this.specificSymbol.test(value)) {
                    return callback(new Error("请不要输入特殊符号"))
                }
                var pwCompany = this.enterpriseForm;
                var params = {
                    id: this.pwEnterId,
                    pwCompany: {
                        id: pwCompany.id,
                        no: pwCompany.no
                    }
                };
                return this.$axios.post('/pw/pwEnter/checkPwEnterCompanyNo', params).then(function (response) {
                    if (response.data) {
                        return callback();
                    }
                    return callback(new Error("工商注册号已经存在"));
                }).catch(function (error) {
                    return callback(new Error("请求失败"));
                })
            }
            return callback();
        },
        validateRegMoney: function (rule, value, callback) {
            if (value) {
                if (/^[0-9]{1,}(\.{0,1}(?=\d+))\d{0,1}$/.test(value)) {
                    return callback();
                }
                return callback(new Error("请输入小数点后只有一位数的注册资金"))
            }

        },
    }
}