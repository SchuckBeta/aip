+function ($, Vue) {
    var selectMultipleStatus = Vue.component('select-multiple-status', {
        template: '<div class="select-multiple" :class="{selectedMultiple: selectedList.length > 0}">' +
        '<div class="smu-header" :class="{smuUnDelete: !hasUnList}">' +
        '<ul class="selected-list">' +
        '<li v-for="(item, index) in selectedList">' +
        '<div class="selected-item"><span>{{item.state}}</span><span>{{item.alias || aliasDefault}}</span></div>' +
        '<a v-show="hasUnList" class="unselected" href="javascript:void(0);" @click="unSelectItem(item, index)">&times;</a></li></ul>' +
        '<input v-if="hasUnList" type="text" name="selectName" readonly v-model="selectName" ref="selectInput" :placeholder="placeholder" @focus="inputFocus" :disabled="disabled" @blur="dropShow=false"><slot name="selectId"></slot> </div>' +
        '<div v-if="hasUnList" v-show="dropShow" class="smu-dropdown" tabindex="0" @blur="dropShow = false" ref="smuDropDown" @mousedown="dropMousedown">' +
        '<ul class="smu-list smu-list-status"><li v-for="(item, index) in dropList"><a href="javascript: void(0);" @click="selectItem(item, index, $event)"><span>{{item.state}}</span><span>{{item.alias || aliasDefault }}</span></a></li>' +
        '<li class="smu-list-less" v-if="dropList.length < 1"><a href="javascript: void(0);">{{lessList}}</a></li> </ul></div></div>',
        props: {
            list: {
                type: Array,
                default: function () {
                    return []
                }
            },
            selectedList: {
                type: Array,
                default: function () {
                    return []
                }
            },
            hasUnList: {
                type: Boolean,
                default: true
            },
            placeholder: {
                type: String,
                default: '请选择角色'
            },
            lessList: {
                type: String,
                default: '没有更多数据了'
            },
            listLength: {
                type: Number,
                default: 10
            },
            isMany: {
                type: Boolean,
                default: true
            },
            disabled: {
                type: Boolean,
                default: false
            }
        },
        data: function () {
            return {
                dropList: [],
                selectName: '',
                dropShow: false,
                timer: null,
                unselectedList: [],
                aliasDefault: '-'
            }
        },
        watch: {
            selectName: function (value) {
                var reg;
                this.getUnselectedList();
                if (!value) {
                    this.dropList = this.unselectedList;
                    return
                }
                this.dropShow = true;
                reg = new RegExp(value, 'i');
                this.dropList = this.unselectedList.filter(function (t) {
                    return reg.test(t.name)
                })
            },
            selectedList: function (value) {
            }
        },
        methods: {
            inputFocus: function () {
                this.getUnselectedList();
                this.dropShow = true;
            },
            getUnselectedList: function () {
                var list = this.list.slice(0);
                var selectedList = this.selectedList;
                selectedList.forEach(function (t) {
                    list.forEach(function (t2, i) {
                        if (t.id === t2.id) {
                            list.splice(i, 1)
                        }
                    })
                });
                if (list.length > this.listLength) {
                    list.length = this.listLength
                }
                this.unselectedList = list;
                this.dropList = this.unselectedList;
            },


            selectItem: function (item, index, $event) {
                var selectedList;
                if (!this.isMany) {
                    this.selectedList.shift();
                }
                this.selectedList.push(item);
                this.getUnselectedList();
                this.selectName = '';
                //点击后开启
                // this.$refs['selectInput'].focus();
                //点击后关闭
                this.$refs['selectInput'].blur();
                selectedList = this.selectedList;
                this.$emit('select', {
                    selectedList: selectedList
                })
            },
            dropMousedown: function ($event) {
                $event.preventDefault();
                $(this.$refs['selectInput']).focus();
            },
            unSelectItem: function (item, index) {
                var rItem = this.selectedList.splice(index, 1);
                var selectedList;
                this.getUnselectedList();
                selectedList = this.selectedList;
                this.$emit('select', {
                    selectedList: selectedList,
                    rItem: rItem
                })
            }
        },
        beforeMount: function () {

        },
        mounted: function () {
        }
    })

}(jQuery, Vue);