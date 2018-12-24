

Vue.component('pw-enter-column', {
    template: '<div class="pw-enter-column">\n' +
    '        <div class="pec-header"><slot name="header"></slot></div>\n' +
    '        <div class="pec-body"><slot></slot>\n' +
    '\n' +
    '        </div>\n' +
    '        <slot name="footer"></slot>\n' +
    '    </div>'
})

Vue.component('pw-record-line', {
    template: '<div class="pec-footer"  v-show="pwRecordLine.length > 0"><div v-if="pwRecordLine.length > 0" class="pw-enter-record-list">\n' +
    '            <span class="per-label">入驻历史记录：</span>\n' +
    '            <div v-for="list in pwDoubleList" class="per-list-content">\n' +
    '                <div v-for="item in list" class="per-item">\n' +
    '                    <div class="tag">\n' +
    '                        <el-popover\n' +
    '                                placement="right"\n' +
    '                                title="建设及意见："\n' +
    '                                width="200"\n' +
    '                                trigger="hover"\n' +
    '                                :content="item.bgremarks" :disabled="!item.bgremarks">\n' +
    '                            <span slot="reference" class="base-tag" :class="baseTagClassName(item.status)">{{item.status === \'1\' ? \'审核通过\' : \'审核未通过\'}}</span>\n' +
    '                        </el-popover>\n' +
    '                    </div>\n' +
    '                    <h5 class="title"><a :href="frontOrAdmin + \'/pw/pwEnter/view?id=\'+item.eid">{{item.typeString}}</a></h5>\n' +
    '                    <p class="date">{{item.createDate | formatDateFilter(\'YYYY-MM-DD\')}}</p>\n' +
    '                </div>\n' +
    '            </div>\n' +
    '        </div></div>',
    props: {
        params: Object
    },
    data: function () {
        return {
            pwRecordLine: []
        }
    },
    computed: {
        pwDoubleList: function () {
            var step = 5;
            var result = [];
            for (var x = 0; x < Math.ceil(this.pwRecordLine.length / step); x++) {
                var start = x * 5;
                var end = start + 5;
                result.push(this.pwRecordLine.slice(start, end));
            }
            return result;
        }
    },

    methods: {
        getPwRecordLine: function () {
            var self = this;
            this.$axios.post('/pw/pwApplyRecord/ajaxFindAuditList', this.params).then(function (response) {
                var data = response.data;
                if(data.status === 1){
                    self.pwRecordLine = data.data || [];
                }
            }).catch(function (error) {

            })
        },

        baseTagClassName: function (audited) {
            return {
                'base-tag-success': audited === '1',
                'base-tag-error': audited === '2'
            }
        }
    },
    created: function () {
        this.getPwRecordLine();
    }
})