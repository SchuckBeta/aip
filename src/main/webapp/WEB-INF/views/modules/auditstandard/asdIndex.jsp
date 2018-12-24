<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${asdVo.name}</title>
    <%@include file="/WEB-INF/views/include/backcyjd.jsp" %>
    <script src="${ctxStatic}/vue/vue.min.js"></script>
    <style>
        .flow-example {
            margin-bottom: 30px;
        }

        .flow-example .flow-col {
            padding-top: 30px;
            width: 110px;
            margin-right: 0;
        }

        .flow-example .flow-arrow {
            padding-top: 50px;
            width: 80px;
        }

        * {
            box-sizing: content-box;
        }

        .container-big-match {
            background: #fff url('/images/bigMatchIconbg.jpg') no-repeat center;
        }

        .container-big-match .wrap {
            position: relative;
            width: 100%;
            margin: 0 auto;
            max-width: 800px;
        }

        .container-big-match .circles-bg {
            padding-top: 50%;
            background: url('/images/circles.png') no-repeat center/cover;
        }

        .container-big-match .projects {
            position: absolute;
            left: 0;
            top: 0;
            z-index: 1000;
        }

        .container-big-match .project-intro {
            position: absolute;
            padding-top: 40px;

        }

        .container-big-match .project-pic {
            position: absolute;
            left: 50%;
            bottom: 70px;
            margin-left: -35px;
            width: 70px;
            height: 70px;
            background: url('/images/bigMatchIcon.png') no-repeat;
        }

        .container-big-match .circle {
            width: 101px;
            height: 101px;
            padding: 8px;
            border-radius: 50%;
        }

        .container-big-match .circle-inner {
            padding-top: 40px;
            height: 61px;
            border-radius: 50%;
        }

        .container-big-match .circle-pink {
            background-color: rgba(254, 211, 219, 0.43);
        }

        .container-big-match .circle-pink .circle-inner {
            background-color: #fc98ab;
        }

        .container-big-match .circle-purple {
            background-color: rgba(213, 165, 251, 0.54);
        }

        .container-big-match .circle-purple .circle-inner {
            background-color: #d5a5fb;
        }

        .container-big-match .circle-blue {
            background-color: rgba(134, 189, 245, 0.54);
        }

        .container-big-match .circle-blue .circle-inner {
            background-color: #288aee;
        }

        .container-big-match .circle-yellow {
            background-color: rgba(249, 216, 190, 0.54);
        }

        .container-big-match .circle-yellow .circle-inner {
            background-color: #f3b786;
        }

        .container-big-match .circle-inner p {
            margin-bottom: 0;
            color: #fff;
            font-weight: bold;
            text-align: center;
        }

        .container-big-match .circle-inner .circle-label {
            position: relative;
            font-size: 16px;
        }

        .container-big-match .circle-inner .number {
            position: relative;
            font-size: 20px;
        }

        .project-declaration {
            left: 121px;
            top: 137px;
        }

        .project-creative {
            top: 121px;
            left: 318px;
        }

        .project-creating {
            top: 40px;
            left: 531px;
        }

        .project-teacher {
            top: 228px;
            left: 500px;
        }

        .container-big-match .project-pic-declaration {
            background-position: -10px -263px;
        }

        .container-big-match .project-pic-declaration:hover {
            background-position: -93px -263px;
        }

        .container-big-match .project-pic-creative {
            background-position: -6px -84px;
        }

        .container-big-match .project-pic-creative:hover {
            background-position: -89px -84px;
        }

        .container-big-match .project-pic-creating {
            background-position: -10px -164px;
        }

        .container-big-match .project-pic-creating:hover {
            background-position: -93px -164px;
        }

        .container-big-match .project-pic-teacher {
            background-position: 2px 0;
        }

        .container-big-match .project-pic-teacher:hover {
            background-position: -81px 0;
        }

        .flow-container-audit .noPadding {
            padding-left: 0;
        }

        .flow-container-audit .noImg:after {
            content: "";
            width: 35px;
            height: 12px;
            background: none;
            position: absolute;
            left: -35px;
            top: 50%;
            margin-top: -25px;
        }

        #flowContainer {
            display: inline-block;
            vertical-align: top;
        }

        .flow-content {
            text-align: center;
            width: 100%;
            overflow-x: auto;
            overflow-y: hidden;
            box-sizing: border-box;
        }


    </style>
</head>
<body>
<div class="container-fluid" style="padding-top: 30px;">
    <%--<div class="edit-bar clearfix">--%>
    <%--<div class="edit-bar-left">--%>
    <%--<span>${asdVo.name}信息统计</span>--%>
    <%--<i class="line weight-line"></i>--%>
    <%--</div>--%>
    <%--</div>--%>
    <div class="container-fluid container-big-match">
        <div class="wrap">
            <div class="circles-bg"></div>
            <div class="projects">
                <c:if test="${asdVo.type=='1'}">
                    <div class="project-intro project-declaration">
                        <div class="project-pic project-pic-declaration"></div>
                        <div class="circle circle-pink">
                            <div class="circle-inner">
                                <p class="circle-label">申报学生</p>
                                <p class="number">${asdVo.applyNum}人</p>
                            </div>
                        </div>
                    </div>

                    <div class="project-intro project-creative">
                        <div class="project-pic project-pic-creative"></div>
                        <div class="circle circle-purple">
                            <div class="circle-inner">
                                <p class="circle-label">创新训练项目</p>
                                <p class="number">${asdVo.innovateNum}个</p>
                            </div>
                        </div>
                    </div>
                    <div class="project-intro project-creating" style="top: 15px;left: 240px;">
                        <div class="project-pic project-pic-creating"></div>
                        <div class="circle circle-blue">
                            <div class="circle-inner">
                                <p class="circle-label">创业训练项目</p>
                                <p class="number">${asdVo.innovateBusNum}个</p>
                            </div>
                        </div>
                    </div>
                    <div class="project-intro project-creating">
                        <div class="project-pic project-pic-creating"></div>
                        <div class="circle circle-blue">
                            <div class="circle-inner">
                                <p class="circle-label">创业项目</p>
                                <p class="number">${asdVo.businessNum}个</p>
                            </div>
                        </div>
                    </div>
                    <div class="project-intro project-teacher">
                        <div class="project-pic project-pic-teacher"></div>
                        <div class="circle circle-yellow">
                            <div class="circle-inner">
                                <p class="circle-label">项目导师</p>
                                <p class="number">${asdVo.teacherNum}人</p>
                            </div>
                        </div>
                    </div>
                </c:if>
                <c:if test="${asdVo.type=='2'}">
                    <div class="project-intro project-declaration">
                        <div class="project-pic project-pic-declaration"></div>
                        <div class="circle circle-pink">
                            <div class="circle-inner">
                                <p class="circle-label">参赛总人数</p>
                                <p class="number">${asdVo.innovateNum}人</p>
                            </div>
                        </div>
                    </div>
                    <div class="project-intro project-creative">
                        <div class="project-pic project-pic-creative"></div>
                        <div class="circle circle-purple">
                            <div class="circle-inner">
                                <p class="circle-label">参赛项目数</p>
                                <p class="number">${asdVo.applyNum}个</p>
                            </div>
                        </div>
                    </div>
                    <div class="project-intro project-teacher">
                        <div class="project-pic project-pic-teacher"></div>
                        <div class="circle circle-yellow">
                            <div class="circle-inner">
                                <p class="circle-label">指导老师数</p>
                                <p class="number">${asdVo.teacherNum}人</p>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <div class="edit-bar clearfix" style="display: none">
        <div class="edit-bar-left">
            <span>${asdVo.name}审核流程及标准</span>
            <i class="line weight-line"></i>
        </div>
    </div>

    <div class="flow-content" style="display: none">
        <div id="flowContainer" class="flow-container flow-container-audit">
            <div class="node-list" v-show="show" style="display: none">
                <div class="node-level-item">
                    <div class="ni-box">
                        <div class="ni-icon-b">
                            <img class="ni-icon" v-ftp-http="gstree.gnode">
                        </div>
                        <p class="name">
                            <span>{{gstree.gnode && gstree.gnode.name}}</span>
                        </p>
                    </div>
                    <flow-node :node-list="gstree.nexts"></flow-node>
                </div>
            </div>
        </div>
    </div>
</div>


<script type="text/x-template" id="flowNodeTemplate">
    <div class="node-list" v-show="nodeList.length > 0" :class="{noPadding: nodeClass}">
        <div class="node-level-item" :class="{noImg: nodeClass}" v-for="node in nodeList">
            <template v-if="!(node.gnode.type == 120 || node.gnode.type == 220)">
                <div class="ni-box">
                    <div class="ni-icon-b">
                        <img class="ni-icon" v-ftp-http="node.gnode">
                    </div>
                    <p class="name">
                        <span>{{node.gnode && node.gnode.name}}</span>
                    </p>
                </div>
            </template>
            <flow-node :node-list="node.nexts"
                       :node-class="(node.gnode.type == 120 || node.gnode.type == 220)"></flow-node>
        </div>
    </div>
</script>


<script type="text/javascript">


    ;
    +function ($, Vue) {


        Vue.directive('ftp-http', {
            // 当被绑定的元素插入到 DOM 中时……
            inserted: function (el, binding, vnode) {
                var node = binding.value;
                if (node) {
                    var iconUrl = node.iconUrl;
                    if (iconUrl) {
                        el.src = ftpHttp + iconUrl.replace('/tool', '')
                    } else if (node.type == 110 || node.type == 110) {
                        el.src = '/images/actYwNode/gnode-start.png';     //设置开始节点默认图片
                    } else if (node.type == 130 || node.type == 230) {
                        el.src = '/images/actYwNode/gnode-end.png';   //设置结束节点默认图片
                    } else if (node.type == 140 || node.type == 240) {
                        el.src = '/images/actYwNode/wangping.png'
                    } else {
                        el.src = '/images/actYwNode/flow-check.png';
                    }
                }else{
                    el.src = '';
                }
            }
        })


        Vue.component('flow-node', {
            template: '#flowNodeTemplate',
            props: {
                nodeList: {
                    type: Array,
                    default: function () {
                        return [];
                    }
                },
                nodeClass: {
                    type: Boolean,
                    default: false
                }
            },

            beforeMount: function () {
            }
        })

        var flowContainer = new Vue({
            el: '#flowContainer',
            data: function () {
                return {
                    show: false,
                    gstree: JSON.parse('${fns:toJson(asdVo.gstree)}')
                }
            },

            mounted: function () {
                this.show = true;
            }
        })

    }(jQuery, Vue)


    $(document).on('click', '.flow-intro>a', function (e) {
        e.preventDefault();
        var id = $(this).attr('data-id');
        var name = $(this).attr('title');
        if (id) {
            top.$.jBox.open('iframe:' + '${ctx}/auditstandard/auditStandard/view?id=' + id, name, 800, $(top.document).height() - 300, {
                buttons: {"关闭": true},
                loaded: function (h) {
                    $(".jbox-content", top.document).css("overflow-y", "hidden");
                }
            });
        }
    })


</script>
</body>
</html>