/**
 * Created by Administrator on 2018/7/20.
 */



'use strict';

Vue.component('e-panel', {
    template: '<div class="panel"><div class="panel-header panel-header-title" v-if="label"><span>{{label}}</span></div><div class="panel-body"><slot></slot></div></div> ',
    props: {
        label: String
    }
})