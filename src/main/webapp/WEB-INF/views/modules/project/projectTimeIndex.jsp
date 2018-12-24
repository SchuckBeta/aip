<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <meta charset="utf-8">
    <title>${frontTitle}</title>
    <meta name="decorator" content="creative"/>
    <script type="text/javascript" src="/js/actYwDesign/vue-router.js"></script>
    <style>
        .project-time-index .time-line .right .weekly-content:after{
            right: 170px;
        }
        .project-time-index .time-line .left .weekly-content:after{
            left: 170px;
        }
        .project-time-index .time-line .time-item.active .time-inner{
            box-shadow: 0 2px 15px 0 rgba(233, 66, 47, 0.5);
        }
        .project-time-index .time-name-nav > li.active{
            box-shadow: 0 2px 15px 0 rgba(233, 66, 47, 0.5);
            border-width: 0;
        }
        .project-time-index .time-line-header{
            background-color: #f7f7f7;
            color: #909399;
        }
        .project-time-index .time-content,.project-time-index .nav-tabs{
            border-color: #f7f7f7;
        }
        .project-time-index .nav-tabs > li.router-link-active > a, .project-time-index .nav-tabs > li.router-link-active > a:focus, .project-time-index .nav-tabs > li.router-link-active > a:hover{
            border-color: #f7f7f7;
        }
        .project-time-index .time-name-nav > li{
            box-shadow: 0 2px 15px 0 #ddd;
            border-width: 0;
        }
        .project-time-index .time-line .weekly-list > li{
            background-color: #fff;
        }
        .project-time-index .time-line .time-inner{
            width: 150px;
            height: 90px;
        }
        .project-time-index .time-line .time-inner .time-inner-header{
            width: 150px;
        }
        .project-time-index .time-line .time-inner .time-inner-header .cell{
            height: 100px;
        }
        .project-time-index .time-line .time-inner .time-inner-header .cell.no-date{
            height: 90px;
        }
        .project-time-index .time-line .time-inner .time-inner-content{
            height: 90px;
            margin-left: 150px;
        }
        .project-time-index .time-line .time-inner .time-inner-content .cell{
            height: 90px;
        }
        .project-time-index .time-line .time-item{
            width: 150px;
            height: auto;
        }
        .project-time-index .time-line::before{
            width: 1px;
        }
        .project-time-index .time-line .time-line-box-arrow{
            border-right: 6px solid transparent;
            border-left: 6px solid transparent;
            border-top: 8px solid #ccc;
            margin-left: -3px;
        }
        .project-time-index .time-line .time-item.last .time-inner{
            top: 0;
        }
        .project-time-index .time-line-box.completed:before{
            width: 1px;
        }
        .project-time-index .time-line-box.completed .time-line-box-arrow{
            border-top: 8px solid #e9422d;
        }
        .project-time-index .time-line .right .weekly-list{
            margin-left: 102px;
        }
        .project-time-index .time-line .right .weekly-list{
            text-align: left;

        }
        .project-time-index .time-line .right .weekly-list > li{
            padding-left: 5px;
        }
        .project-time-index .time-line .left .weekly-list{
            text-align: right;
        }
        .project-time-index .time-line .left .weekly-list > li{
            padding-right: 5px;
        }
        .project-time-index .time-line .weekly-list > li{
            overflow: hidden;
        }
        .project-time-index .time-line .left .intro-date{
            width: 378px;
        }
        .project-time-index .time-line{
            width: 1064px;
        }
        .project-time-index .time-line .right .intro-weekly{
            float: none;
            position: absolute;
            left: 50%;
            top: 0;
        }
        .project-time-index .time-line .right .weekly-content,.project-time-index .time-line .left .weekly-content{
            width: 360px;
        }
        .project-time-index .time-line .right .weekly-content:after{
            right: auto;
            width: 100px;
            left: 0;
        }
        .project-time-index .time-line .right .intro-date{
            position: absolute;
            right: 50%;
            padding-right: 15px;
        }
        .project-time-index .time-line .left .intro-date{
            position: absolute;
            left: 50%;
            padding-left: 15px;
        }
        .project-time-index .time-line .left .intro-date{
            text-align: left;
        }
        .project-time-index .time-line .right .intro-date{
            text-align: right;
        }
        .project-time-index .time-line .left .intro-weekly{
            position: absolute;
            right: 50%;
            float: none;
            top: 0;
        }
        .project-time-index .time-line .left .weekly-content:after{
            width: 100px;
            right: 0;
            left: auto;
        }
        .project-time-index .time-line .left .weekly-list{
            padding-right: 104px;
        }
        .project-time-index .time-line .right .weekly-list > li{
            border-left: 1px dashed #ddd;
        }
        .project-time-index .time-line .left .weekly-list > li{
            border-right: 1px dashed #ddd;
        }
    </style>
</head>
<body>
<input type="hidden" id="userType" value="${user.userType}">
<div id="appTime" class="project-time-index">
    <div class="container" style="width: 1270px;padding-top: 60px;">
        <el-breadcrumb separator-class="el-icon-arrow-right" class="mgb-20" size="mini">
            <el-breadcrumb-item><a href="${ctxFront}"><i class="iconfont icon-ai-home"></i>首页</a></el-breadcrumb-item>
            <el-breadcrumb-item><a href="${ctxFront}/page-innovation">双创项目</a></el-breadcrumb-item>
            <el-breadcrumb-item>我的项目</el-breadcrumb-item>
        </el-breadcrumb>
        <div class="nav-wrap">
            <div class="pull-right">
                <a class="btn btn-primary btn-sm" href="/f/project/projectDeclare/curProject">当前项目</a>
                <a class="btn btn-default btn-sm" href="/f/project/projectDeclare/list">项目列表</a>
            </div>
            <ul class="nav nav-tabs nav-tab-timeline">
                <router-link v-for="tab in tabList" tag="li"
                             :to="{path: tab.id, query: {type: tab.type, actYwId: tab.actywId}}" :key="tab.id">
                    <a>{{tab.label}}</a>
                </router-link>
            </ul>
        </div>
        <router-view></router-view>
    </div>
</div>
<script type="text/x-template" id="noneTimeLine">
    <div class="time-line-container">
        <div class="time-content">
            <div class="time-line-header clearfix">
                <%--{{$route}}--%>

            </div>
            <div>
                <p style="margin: 60px auto;" class="text-center">没有项目数据，请发布项目</p>
            </div>
        </div>
    </div>
</script>
<script type="text/x-template" id="projectTimeLine">
    <div class="time-line-container">
        <div ref="timeSideBar" class="time-sidebar">
            <ul class="time-name-nav">
                <li :class="{active: $route.query.projectId === sTab.id}" v-for="sTab in secondTabs">
                    <%--<div>--%>
                    <router-link :title="sTab.name" style="word-break: break-all"
                                 :to="{path: $route.query.id, query: {type: $route.query.type, actYwId: $route.query.actYwId, projectId: sTab.id}}"
                                 :key="sTab.projectId">
                        <span>{{sTab.name}}</span>
                    </router-link>
                        <div v-if="sTab.result" class="tab-result-tag">
                            {{sTab.result}}
                        </div>
                    <%--</div>--%>
                </li>
            </ul>
        </div>
        <div class="time-content" :style="{minHeight: minHeight}">
            <h4 style="display: none" class="time-line-title">{{proname}}</h4>
            <div class="time-line-header clearfix">
                <%--{{$route}}--%>
                <%--<div class="pull-right">--%>
                    <%--<a class="btn btn-primary btn-sm" href="/f/project/projectDeclare/curProject">当前项目</a>--%>
                    <%--<a class="btn btn-default btn-sm" href="/f/project/projectDeclare/list">项目列表</a>--%>
                <%--</div>--%>
                <div class="project-info">
                    <span>项目年度：{{year}}</span><span>项目申报时间：{{apply_time}}</span><span>项目编号：{{number}}</span><span>项目负责人：{{leader}}</span>
                </div>
            </div>
            <div v-show="isLoaded" style="display: none">
                <div v-if="hasCorrectTime" class="time-actions text-center">
                    <a v-if="userType == 1 && $route.query.projectId" :href="weeklyLink"
                       class="btn btn-sm btn-primary">新建周报</a>
                    <a v-if="userType == 1 && $route.query.projectId" href="/f/proproject/downTemplate?type=mid"
                       class="btn btn-sm btn-default">大学生创新创业项目中期检查表<i style="margin-left: 4px;"><img
                            src="/img/btn-hover-downfile.png"></i></a>
                    <a v-if="userType == 1 && $route.query.projectId" href="/f/proproject/downTemplate?type=close"
                       class="btn btn-sm btn-default">大学生创新创业项目结项报告<i style="margin-left: 4px;"><img
                            src="/img/btn-hover-downfile.png"></i></a>
                    <a v-if="userType == 1 && $route.query.projectId" href="/f/proproject/downTemplate?type=modify"
                       class="btn btn-sm btn-default">大学生创新创业项目调整申请表<i style="margin-left: 4px;"><img
                            src="/img/btn-hover-downfile.png"></i></a>
                    <a v-if="userType == 1 && $route.query.projectId" href="/f/proproject/downTemplate?type=spec"
                       class="btn btn-sm btn-default">大学生创新创业项目免鉴定申请表<i style="margin-left: 4px;"><img
                            src="/img/btn-hover-downfile.png"></i></a>
                </div>
                <div class="time-line" v-if="hasCorrectTime">
                    <div class="time-line-box" v-for="(item, index) in groupData" :class="{completed: item.current}">
                        <template v-if="item.type=== 'milestone'">
                            <div class="time-item"
                                 :class="{active: item.current, hasContent: !!item.btn_option || item.approvalTime, last: (index === groupData.length - 1)}">
                                <%--<div class="time-item-bg"></div>--%>
                                <div class="time-inner clearfix">
                                    <div class="time-inner-header">
                                        <div class="cell" :class="{'no-date': !item.start_date}">
                                            <span v-if="item.start_date">{{item.start_date | year}}.{{item.start_date | month}}.{{item.start_date | day}}至{{item.start_date | year}}.{{item.end_date | month}}.{{item.end_date | day}}<br></span>
                                            <span>{{item.title}}</span>
                                        </div>
                                    </div>
                                    <div v-if="!!item.btn_option || item.approvalTime" class="time-inner-content">
                                        <div class="cell">
                                            <template v-if="!!item.btn_option">
                                                <a class="btn btn-milestone"
                                                   :href="item.btn_option.url">{{item.btn_option.name}}</a>
                                            </template>
                                            <template v-if="item.approvalTime">
                                                <span class="approval">{{item.approvalTime}}<br>{{item.approvalDesc}}</span>
                                            </template>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <template v-if="item.children" v-for="(item2, index2) in item.children">
                                <div class="time-item-intro clearfix"
                                     :style="{'height': item2.files && item2.files.length*30 + 'px'}"
                                     :class="{left: index2%2 == 1, right: index2%2 === 0, weekly: !item2.type}">
                                    <div v-if="!item2.type" class="intro-weekly">
                                        <div class="weekly-content">
                                            <ul v-if="item2.files" class="weekly-list weekly-list-more"
                                                :style="{'margin-top': -(15*item2.files.length)+'px'}">
                                                <li v-for="file in item2.files">
                                                    <a :title="file.name"
                                                       :href="file.url">{{file.name}}
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div v-if="item2.type === 'date'" class="intro-inner">
                                        <div class="intro-header">
                                            <span class="arrow"></span>
                                            <p class="title">{{item2.desc}}</p></div>
                                        <div class="intro-content">{{item2.intro}}</div>
                                    </div>
                                    <div class="intro-date">{{item2.start_date || item2.create_date | format}}</div>
                                    <div class="intro-dot">
                                        <span></span>
                                    </div>
                                </div>
                            </template>
                            <span v-show="index > 0" class="time-line-box-arrow"></span>
                        </template>
                    </div>
                </div>
            </div>
            <p v-show="!hasCorrectTime && isLoaded" class="text-center no-time-line">没有申报项目</p>
            <div class="loading-data" v-show="!isLoaded && hasProjectId">
                数据加载中...
            </div>
        </div>
        <div class="loading-data" v-show="!secondTabs.length && !isLoaded">
            没有项目
        </div>
        <%--<div class="loading-data" v-show="!isLoaded && hasProjectId">--%>
        <%--数据加载中...--%>
        <%--</div>--%>
    </div>
</script>
<script>



    function canSumitClose(projectId, url) {
        $.ajax({
            type: "GET",
            url: "canSumitClose",
            data: "projectId=" + projectId,
            dataType: "text",
            success: function (data) {
                if (data == "false") {
                	dialogCyjd.createDialog(0, "未创建学分配比，请先完成该信息", {
                        dialogClass: 'dialog-cyjd-container none-close',
                        buttons: [{
                            text: "创建学分配比",
                            'class': 'btn btn-sm btn-primary',
                            click: function () {
                            	$(this).dialog('close')
                            	top.location = "scoreConfig?projectId=" + projectId;
                            }
                        },{
                            text: '取消',
                            'class': 'btn btn-sm btn-primary',
                            click: function () {
                                $(this).dialog('close');
                            }
                        }]
                    });
                } else {
                    top.location = url + "?projectId=" + projectId;
                }
            }
        });
    }
    var $userType = $('#userType');
    var userType = $userType.val();

    $('#appTime').css('minHeight', function () {
        return $(window).height() - 408;
    });


    function compareObj(time, dTime) {
        return function (obj1, obj2) {
            var date1 = obj1[time] || obj1[dTime];
            var date2 = obj2[time] || obj2[dTime];
            var time1 = new Date(date1).getTime();
            var time2 = new Date(date2).getTime();
            if (time1 < time2) {
                return -1;
            } else if (time1 > time2) {
                return 1;
            } else {
                return 0;
            }
        }
    }

    function compareObj2(time, dTime) {
        return function (obj1, obj2) {
            var date1 = obj1[0][time] || obj1[0][dTime];
            var date2 = obj2[0][time] || obj2[0][dTime];


            var time1 = new Date(date1).getTime();
            var time2 = new Date(date2).getTime();
            if (time1 < time2) {
                return -1;
            } else if (time1 > time2) {
                return 1;
            } else {
                return 0;
            }
        }
    }

    var NoneTimeLine = Vue.component('none-time-line', {
        template: '#noneTimeLine',
        data: function () {
            return {}
        },
        beforeMount: function () {
            console.log('1')
        }
    })

    var TimeLine = Vue.component('time-line', {
        template: '#projectTimeLine',
        data: function () {
            return {
                timeList: [],
                proname: '',
                pid: '',
                number: '',
                apply_time: '',
                year:'',
                leader: '',
                hasCorrectTime: false,
                milestones: [],
                dates: [],
                secondTabs: [],
                groupData: [],
                hasProjectId: false,
                isLoaded: false,
                userType: userType,
                minHeight: '',
            }
        },
        computed: {
            projectId: function () {
                return this.$route.params.id;
            },
            weeklyLink: function () {
                var type = this.$route.query.type;
                var linkPart = type == 1 ? '/f/project/weekly/createWeekly?projectId=' : '/f/project/weekly/createWeeklyPlus?projectId=';
                return linkPart += this.pid
            }
        },
        filters: {
            format: function (time) {
                if (!time) {
                    return '';
                }
                var timeStr = time.toString();
                return timeStr.substring(0, 4) + '-' + timeStr.substring(5, 7) + '-' + timeStr.substring(8);
            },
            year: function (time) {
                if (!time) {
                    return '';
                }
                var timeStr = time.toString();
                return timeStr.substring(0, 4);
            },
            month: function (time) {
                if (!time) {
                    return '';
                }
                var timeStr = time.toString();
                return timeStr.substring(5, 7);
            },
            day: function (time) {
                if (!time) {
                    return '';
                }
                var timeStr = time.toString();
                return timeStr.substring(8);
            },
            fileExt: function (ext) {
                var extname;
                switch (ext) {
                    case "xls":
                    case "xlsx":
                        extname = "excel";
                        break;
                    case "doc":
                    case "docx":
                        extname = "word";
                        break;
                    case "ppt":
                    case "pptx":
                        extname = "ppt";
                        break;
                        // 我不太确定这个文件格式
//                    case "project":
                    case "jpg":
                    case "jpeg":
                    case "gif":
                    case "png":
                    case "bmp":
                        extname = "image";
                        break;
                    case "rar":
                    case "zip":
                    case "txt":
                    case "project":
                        // just break
                        break;
                    default:
                        extname = "unknow";
                }
                return "/img/filetype/" + extname + ".png"
            }
        },
        watch: {
            // 如果路由有变化，会再次执行该方法
            '$route': 'getTimeList'
        },
        methods: {
            resetBaseData: function () {
                this.timeList = [];
                this.proname = '';
                this.pid = '';
                this.number = '';
                this.apply_time = '';
                this.year='';
                this.leader = '';
                this.hasCorrectTime = false;
                this.milestones = [];
                this.dates = [];
                this.groupData = [];
                this.isLoaded = false;
                this.hasProjectId = false;
            },

            getSecondTabs: function () {
                var postData = {
                    pptype: this.$route.query.type,
                    actywId: this.$route.query.actYwId
                };
                var self = this;
                var xhr = $.post('${ctxFront}/project/projectDeclare/getTimeIndexSecondTabs', postData);
                xhr.success(function (data) {
                    if (data.length > 0) {
                        self.secondTabs = data;
                        self.$nextTick(function () {
                            this.minHeight = $(this.$refs.timeSideBar).height() + 'px';
                        })
                        self.$router.push({
                            path: '/' + self.$route.params.id,
                            query: {
                                type: self.$route.query.type,
                                actYwId: self.$route.query.actYwId,
                                projectId: data[0].id
                            }
                        })
                    } else {
                        self.secondTabs = [];
                        self.getNoProjectId();
                        self.minHeight = '';
                    }
                })
            },

            refreshSt: function () {
                var postData = {
                    pptype: this.$route.query.type,
                    actywId: this.$route.query.actYwId
                };
                var self = this;
                var xhr = $.post('/f/project/projectDeclare/getTimeIndexSecondTabs', postData);
                xhr.success(function (data) {
                    if (data) {
                        self.secondTabs = data;
                    }
                })
            },

            getNoProjectId: function () {
                this.resetBaseData();
                var postData = {
                    pptype: this.$route.query.type,
                    actywId: this.$route.query.actYwId,
                    ppid: this.projectId
                };

                var xhr = $.post('/f/project/projectDeclare/getTimeIndexData', postData);
                var self = this;
                var everyTime = false;
                var files;
                var filesDate = [];
                var typeDates = [];
                var sortFilesDates = [];
                this.hasProjectId = true;
                xhr.success(function (data) {
                    if (data && data.pid) {
                        self.timeList = data.contents;
                        self.leader = data.leader;
                        self.number = data.number;
                        self.pid = data.pid;
                        self.apply_time = data.apply_time;
                        self.year=data.year;
                        self.proname = data.proname;
                        self.hasCorrectTime = true;
                        everyTime = self.timeList.every(function (item) {
                            return item.start_date && item.end_date
                        });

                        self.milestones = self.timeList.filter(function (item) {
                            return item.type === 'milestone'
                        });
                        self.dates = self.timeList.filter(function (item) {
                            return item.type === 'date'
                        });
                        files = data.files || [];
                        typeDates = self.timeList.filter(function (item) {
                                    return item.type === 'date'
                                }) || [];
                        filesDate = files.concat(typeDates);



                        sortFilesDates = filesDate.sort(compareObj('start_date', 'create_date'));


                        self.getTimestamp(self.milestones).forEach(function (t, index) {
                            var startTimes = t.startTime;
                            var endTimes = t.endTime;
                            self.milestones[index].children = [];
                            sortFilesDates.forEach(function (t2, i) {
                                var times = new Date(t2.start_date || t2.create_date).getTime();
                                if (times >= startTimes && times <= endTimes) {
                                    self.milestones[index].children.push(t2);
                                }
                            })
                        });


                }});
                self.isLoaded = true;
                xhr.error(function (err) {
                    self.isLoaded = true;
                })
            },

            getTimestamp: function (milestones) {
                var i = 1;
                var timesTamp = [];

                if(milestones.length <= 1){
                    return timesTamp;
                }
                while (i < milestones.length){
                    var startTime = new Date(milestones[i-1].start_date).getTime();
                    var endTime = new Date(milestones[i].start_date).getTime();
                    timesTamp.push({
                        startTime: startTime,
                        endTime: endTime,
                    })
                    i++;
                }
                return timesTamp;
            },

            getTimeList: function () {
                if (!this.$route.query.projectId) {
                    this.resetBaseData();
                    this.getSecondTabs();
                    return
                }
                if (this.secondTabs.length < 1) {
                    this.refreshSt()
                }

                var postData = {
                    pptype: this.$route.query.type,
                    actywId: this.$route.query.actYwId,
                    ppid: this.projectId,
                    projectId: this.$route.query.projectId
                };

                var xhr = $.post('/f/project/projectDeclare/getTimeIndexData', postData);
                var self = this;
                var everyTime = false;
                var files;
                var filesDate = [];
                var typeDates = [];
                var sortFilesDates = [];
                this.hasProjectId = true;
                xhr.success(function (data) {
                    if (data && data.pid) {
                        self.timeList = data.contents;
                        self.leader = data.leader;
                        self.number = data.number;
                        self.pid = data.pid;
                        self.apply_time = data.apply_time;
                        self.year=data.year;
                        self.proname = data.proname;
                        self.hasCorrectTime = true;
                        everyTime = self.timeList.every(function (item) {
                            return item.start_date && item.end_date
                        });

                        self.milestones = self.timeList.filter(function (item) {
                            return item.type === 'milestone'
                        });
                        self.dates = self.timeList.filter(function (item) {
                            return item.type === 'date'
                        });
                        files = data.files || [];
                        typeDates = self.timeList.filter(function (item) {
                                    return item.type === 'date'
                                }) || [];
                        filesDate = files.concat(typeDates);


                        sortFilesDates = filesDate.sort(compareObj('start_date', 'create_date'));



                        self.getTimestamp(self.milestones).forEach(function (t, index) {
                            var startTimes = t.startTime;
                            var endTimes = t.endTime;
                            self.milestones[index].children = [];
                            sortFilesDates.forEach(function (t2, i) {
                                var times = new Date(t2.start_date || t2.create_date).getTime();
                                if (times >= startTimes && times <= endTimes) {
                                    self.milestones[index].children.push(t2);
                                }
                            })
                        });
//                        combinationArr = combinationArr.concat(milestones);
//                        combinationArr = combinationArr.sort(compareObj2('start_date', 'create_date'));
                        self.groupData = self.milestones;
//                        self.$nextTick(function () {
//                            var $completed = $('.time-line-box.completed');
//                            $completed.eq(-1).addClass('gray');
//                        });
                    }else {
                        self.hasCorrectTime = false;
                    }

                    self.isLoaded = true;
                });

                xhr.error(function (err) {
                    self.isLoaded = true;
                })

            }
        },
        beforeMount: function () {
            this.getTimeList()
        },
        mounted: function () {
        }
    });

    var fTabList = '${pp}', firstId, firstActYwId, type, redirect, router;
    fTabList = JSON.parse((fTabList) || '[]');
    if (fTabList.length) {
        firstId = fTabList[0].id;
        firstActYwId = fTabList[0].actywId;
        type = fTabList[0].type;
        redirect = '/' + firstId;
        router = new VueRouter({
            routes: [
                {
                    path: '',
                    redirect: redirect
                }, //默认指向第一个
                // 动态路径参数 以冒号开头
                {path: '/:id', name: 'timeLine', component: TimeLine}
            ]
        })
    } else {
        router = new VueRouter({
            routes: [
                {
                    path: '/noneTimeLine',
                    component: NoneTimeLine,
                }
            ]
        });
    }


    var app = new Vue({
        router: router,
        data: function () {
            return {
                tabList: fTabList,
                collapsedText: '展开',
                collapsed: false
            }
        },
        computed: {
            isCollapse: function () {
                return this.tabList.length < 12;
            }
        },
        methods: {
            collapse: function () {
                this.collapsed = !this.collapsed;
                this.collapsedText = this.collapsed ? '收起' : '展开'
            }
        },
        beforeMount: function () {
            if (!this.$route.query.type) {
                if (this.$route.params.id) {
                    this.$router.push({
                        path: '/' + (this.$route.params.id || ''),
                        query: {
                            type: type,
                            actYwId: firstActYwId
                        }
                    })
                } else {
                    this.$router.push({
                        path: '/noneTimeLine',
                    })
                    console.log(this.$route)
                }
            }

        }
    });

    app.$mount('#appTime');

</script>
</body>
</html>