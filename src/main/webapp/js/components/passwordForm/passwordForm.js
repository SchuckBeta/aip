/**
 * Created by Administrator on 2018/6/21.
 */



'use strict';

Vue.component('password-form', {
    template: '<el-form :model="passwordForm" :disabled="isUpdateing"  autocomplete="off" ref="passwordForm" :rules="passwordFormRules" label-width="100px" size="mini"> ' +
    '<el-form-item label="旧密码：" prop="oldPassword"> <el-input type="password" name="oldPassword" v-model="passwordForm.oldPassword" auto-complete="off"></el-input> </el-form-item> ' +
    '<el-form-item label="新密码：" prop="newPassword"> <el-input type="password" name="newPassword" v-model="passwordForm.newPassword" auto-complete="off"></el-input> </el-form-item> ' +
    '<el-form-item label="确认新密码：" required prop="confirmNewPassword"> <el-input type="password" name="confirmNewPassword" v-model="passwordForm.confirmNewPassword" auto-complete="off"></el-input> </el-form-item>' +
    '<slot><template v-if="!$slots.default"><el-form-item :class="deCls"><el-button type="primary" @click.stop.prevent="validateForm">保存</el-button></el-form-item></template></slot></template> ' +
    '</el-form>',
    mixins: [Vue.verifyExpressionMixin],
    props: {
        id: {
            required: true,
            type: String
        },
        isAdmin: Boolean
    },
    data: function () {
        var commonRule = {min: 6, max: 20, message: '请输入6-20位字符数字、字母', trigger: 'blur'};
        var self = this;
        var equalToPassword = function (rule, value, callback) {
            if (!value) return callback(new Error('请确认新密码'));
            if (self.passwordForm.newPassword !== value) {
                return callback(new Error('两次输入的密码不同'));
            }
            callback();
        };
        return {
            passwordForm: {
                oldPassword: '',
                newPassword: '',
                confirmNewPassword: ''
            },
            isUpdateing: false,
            passwordFormRules: {
                oldPassword: [
                    {required: true, message: '请填入旧密码', trigger: 'blur'},
                    commonRule
                ],
                newPassword: [
                    {required: true, message: '请填入新密码', trigger: 'blur'},
                    commonRule
                ],
                confirmNewPassword: [
                    {validator: equalToPassword}
                ]
            }
        }
    },
    computed: {
      deCls: function () {
          return {
              'text-right': !this.isAdmin
          }
      }
    },
    methods: {
        validateForm: function () {
            var self = this;
            this.$refs.passwordForm.validate(function (valid) {
                if (valid) {
                    self.isUpdateing = true;
                    self.updatePassword()
                }
            })
        },


        updatePassword: function () {
            var self = this;


            this.$axios({
                method: 'GET',
                url: '/sys/user/ajaxUpdatePassWord/' + this.id,
                params: this.passwordForm
            }).then(function (response) {
                var data = response.data;
                var type = data.status ? 'success' : 'error';
                if (data.status) {
                    self.$refs.passwordForm.resetFields();
                }
                self.$msgbox({
                    message: data.msg,
                    title: '提示',
                    showClose: false,
                    closeOnClickModal: false,
                    type: type
                }).then(function () {
                    var url = '', user = {};
                    if (data.status) {
                        var referrer = document.referrer;
                        if(!self.isAdmin){
                            location.href = referrer;
                        }
                    }
                })
                self.isUpdateing = false;
            }).catch(function (error) {
                self.isUpdateing = false;
                self.$msgbox({
                    message: self.xhrErrorMsg,
                    title: '提示',
                    type: 'error'
                })
            })
        }
    }
})


