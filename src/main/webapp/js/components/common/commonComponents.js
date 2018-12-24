/**
 * Created by Administrator on 2018/11/19.
 */


'use strict';

Vue.component('row-step-apply', {
    template: '<div class="row-step-cyjd" :style="{width: stepWidth}"><div class="step-indicator"><slot></slot></div></div>',
    data: function () {
        return {
            steps: []
        }
    },
    componentName: 'RowStepApply',
    computed: {
      stepWidth: function () {
          return this.steps.length * (240+33) + 'px'
      }
    },
    methods: {
        updateItems: function () {
            this.steps = this.$children.filter(function (child) {
                return child.$options.name === 'StepItem'
            })
        }
    }
});

Vue.component('step-item', {
    template: '<a class="step" :class="cls"><slot></slot></a>',
    props: {
        isComplete: Boolean
    },
    name: 'StepItem',
    componentName: 'StepItem',
    computed: {
        cls: function () {
            return {
                completed: this.isComplete
            }
        },
        rowStepApply: function () {
            var $parent = this.$parent;
            while ($parent) {
                if ($parent.$options.componentName !== 'RowStepApply') {
                    $parent = $parent.$parent;
                } else {
                    return $parent;
                }
            }
            return false;
        }
    },
    created: function () {
        if(this.rowStepApply){
            this.rowStepApply.updateItems();
        }
    }
})


Vue.component('tab-pane-content', {
    template: '<div class="tab-pane-content"><slot v-if="(tabPane && tabPane.active) || firstShow"></slot></div>',
    data: function () {
        return {
            firstShow: false
        }
    },
    componentName: 'TabPaneContent',
    name: 'TabPaneContent',
    computed: {
        tabPane: function () {
            var $parent = this.$parent;
            while ($parent) {
                if ($parent.$options.componentName !== 'ElTabPane') {
                    $parent = $parent.$parent;
                } else {
                    if(!this.firstShow){
                        this.firstShow = $parent.active;
                    }
                    return $parent;
                }
            }
            return false;
        }
    }
})