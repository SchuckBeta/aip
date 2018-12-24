/**
 * Created by Administrator on 2018/5/17.
 */
'use strict';

Vue.component('edit-bar', {
    template: '<div class="edit-bar edit-bar-tag clearfix"  :class="{\'edit-bar_new\': isTitle}"><div class="edit-bar-left"><div class="edit-bar-path-content" v-if="$slots.default"><slot></slot> </div><template v-if="!$slots.default"><span v-if="!secondName">{{title}}</span>' +
    '<div v-if="secondName"  class="edit-bar-path-content"> <el-breadcrumb separator-class="el-icon-arrow-right"><el-breadcrumb-item v-for="(bread, index) in breads" :key="index">{{bread}}</el-breadcrumb-item></el-breadcrumb></div><el-button v-if="secondName"  class="btn-eb-back" size="mini" @click.stop.prevent="historyGoBack">返回</el-button></template><i class="line weight-line"></i></div></div>',
    props: {
        label: String,
        isTitle: {
            type: Boolean,
            default: true
        },
        secondName: String,
        // isFirst: {
        //     type: Boolean,
        //     default: true
        // }
    },
    data: function () {
        return {
            title: '',
        }
    },
    methods: {
        getTitle: function () {
            var $osSideNav = $(window.parent.document.getElementById('oeSideNav'));
            var $currentSenMenu = $osSideNav.find('.submenu-title.active');
            var $currentTMenu = $osSideNav.find('.oe-menu-item.active');
            var tagText;
            var menuName;
            if ($currentTMenu.size() > 0) {
                tagText = $currentTMenu.find('.unread-tag').text() || '';
                menuName = $currentTMenu.text();
            } else {
                tagText = $currentSenMenu.find('.unread-tag').text() || '';
                menuName = $currentSenMenu.text();
            }
            menuName = menuName.replace(tagText, '');
            return menuName;
        },
        historyGoBack: function () {
            window.history.go(-1);
        }
    },
    computed: {
        breads: {
            get: function () {
                return [this.title, this.secondName]
            }
        }
    },
    mounted: function () {
        if (!this.$slots.default) {
            this.title = this.getTitle();
        }
    }
})
