
'use strict';

Vue.component('table-team-member',{
    template:'\n' +
    '    <div>\n' +
    '        <div v-if="row.teamShow">\n' +
    '            <el-tooltip :content="row.teamName" popper-class="white" placement="right">\n' +
    '                <span class="break-ellipsis">{{row.teamName}}</span>\n' +
    '            </el-tooltip>\n' +
    '        </div>\n' +
    '        <div>\n' +
    '            <el-tooltip :content="row.applicantName" popper-class="white" placement="right">\n' +
    '                <span class="break-ellipsis">负责人：{{row.applicantName}}</span>\n' +
    '            </el-tooltip>\n' +
    '        </div>\n' +
    '        <div>\n' +
    '            <el-tooltip :content="row.snames" popper-class="white" placement="right">\n' +
    '                <span class="break-ellipsis">组成员：{{row.snames}}</span>\n' +
    '            </el-tooltip>\n' +
    '        </div>\n' +
    '        <div>\n' +
    '            <el-tooltip :content="row.tnames" :disabled="!row.tnames" popper-class="white" placement="right">\n' +
    '                <span class="break-ellipsis">指导老师：{{row.tnames || \'-\'}}</span>\n' +
    '            </el-tooltip>\n' +
    '        </div>\n' +
    '    </div>',
    props:{
        row:{
            type:Object
        }
    }
});