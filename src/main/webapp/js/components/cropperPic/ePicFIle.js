/**
 * Created by Administrator on 2018/6/19.
 */
;+function (Vue) {
    'use strict';

    var ePicFile = Vue.component('e-pic-file', {
        template: ' <div class="user-pic_file"> <el-button type="primary" :disabled="disabled" size="mini" @click.stop.prevent="$refs.userPic.click()">{{imgSrc ? \'修改图片\' : \'上传图片\'}} </el-button> <input type="file" ref="userPic" @change="handleChangePic($event)" accept="image/jpeg,image/png" style="position: absolute; clip: rect(0px, 0px, 0px, 0px);"> <input type="hidden" :name="name"> </div>',
        model: {
            prop: 'imgSrc',
            event: 'change'
        },
        props: {
            imgSrc: String,
            name: String,
            disabled: Boolean
        },
        methods: {
            handleChangePic: function (event) {
                var files = event.target.files;
                var file, fileReader;
                var self = this;
                if (files && files.length < 1) {
                    this.$refs.userPic.files = null;
                    this.$emit('get-file', null);
                    return false;
                }
                file = files[0];
                fileReader = new FileReader();
                fileReader.onload = function (e) {
                    self.$emit('change', e.target.result);
                    self.$emit('get-file', file);
                    event.target.files = null;
                    self.$refs.userPic.files = null;
                    self.$refs.userPic.setAttribute('type', 'text');
                    self.$refs.userPic.setAttribute('type', 'file');
                };
                fileReader.readAsDataURL(file);
            }
        },
        emptyFile: function () {
            this.$refs.userPic.files = null;
            this.$emit('get-file', null);
        }
    })
}(Vue)