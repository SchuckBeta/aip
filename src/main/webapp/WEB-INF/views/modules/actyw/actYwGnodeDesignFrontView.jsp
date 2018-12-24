<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%--<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp" %>--%>
<!DOCTYPE html>
<html>
<head>
    <title>${frontTitle}</title>
    <meta charset="UTF-8">
    <meta name="decorator" content="creative"/>
    <script src="${ctxStatic}/snap/snap.svg-min.js"></script>
    <script src="/js/actyw/md/data.js"></script>

    <style>

        .container-fluid h3 {
            text-align: center;
            margin-top: 50px;
        }

        .flow-center {
            position: relative;
            overflow: hidden;
            margin: 40px auto;
        }

        .flow-content {
            position: absolute;
        }

    </style>
</head>
<body>




<div class="container container-ct">
    <ol class="breadcrumb" style="margin-top: 0">
        <li><a href="${ctxFront}"><i class="icon-home"></i>首页</a></li>
        <li class="active">流程跟踪</li>
    </ol>
    <%--<h3 class="text-center">${group.name}</h3>--%>

    <div class="flow-center">
        <div class="flow-content">
            <svg id="svg" version="1.1" width="100%" height="100%" xmlns="http://www.w3.org/2000/svg"
                 xmlns:xlink="http://www.w3.org/1999/xlink">
                <g id="g">
                    <%--${group.uiHtml}--%>
                </g>
            </svg>
        </div>
    </div>

</div>

<script>

    +function ($) {
        function Flow() {
            this.mdData = mdData;
            this.getUiJson();

            this.fcWidth = this.uiJson.width + 5;
            this.fcHeight = this.uiJson.height + 5;
            this.flowContent = $('.flow-content');
            this.svg = Snap("#svg");

            this.startNode = [110, 210];
            this.endNode = [130, 230];
//            this.stopNode = [230];
            this.sonFlow = [190];
            this.task = [150, 250];
            this.together = [140, 240];
            this.line = [120, 220];
            this.uiHtml = '${group.uiHtml}';
            this.uiHtml =  this.uiHtml || this.mdData.uiHtml;
            this.init();

            this.mdMaps = {
                '48bbbc0e03e34e7fab95a48c6a96f739': 'd110efe5d8f949e2a2498b85b26168f7', //开始
                '052302e95a1440e2adc139f334d63536': '5f78358f07d14b32a26ddc5526fcecb3', //立项审核
                'd1886b2dc47843e6883b51a48e434aef': 'fc673069d28d4ebb82942fbf184cd64e',  //中期检查
                '362e855044fe45ff8ca723edf206a4e7': '963f92f20e134c07b8ca8cbb5de3dbdf', //结项审核
                'e3ce3a8268864f188bd7eea702e7e9ea': '6daedef8ab3f4261939cf26242138611', //结束

                'a4b72357097e44aab8c1801d8b98cd42': 'f47b144b598d44818718bfd71d2f80b9', //立项审核 开始
                'e518e7105bfd4eecb891c6336c9c5544': 'f4d547b80b964178b44a744ed71a0dd3', //立项审核 立项审核
                'ddb12932a4a7413499ad9b2a019c3a6e': '669cca8c2fd94bebbd7f72047c2a6925', //立项审核 结束

                '543522cd55fb4e08a92cc0ee6ae5d91f': 'dc9d370f1ea04511876fc6a8a0de7340', //中期检查 结束
                'd3981e58393642d8a1665b59de76d09b': 'c370a19228b1444abfe86b57ef12e806', //中期检查 结束
                '2e984664478845fe886eb92f7f82f09c': 'f26c8d2fd7c641eba6bfc82bf519c236', //中期检查 结束
                '2eb05b2320e04526adcdbbdcbfe53203': '8e2f745202934ed19e90ee45a884d834', //中期检查 结束

                'd0a2f3f018024dd6bdf0eb002e3acdbb': '0dc199b8212449eda8f08395e5e87dfe', //结项审核 结束
                '81d727f337f74b5284ae52e951fc7ac7': 'cdeb65dffd44451e9f0e82454d8dc9b2', //结项审核 结束
                '99b68c2d465247f98515023072d372c5': '505abf11d29748f59986b5e2fdabbacc', //结项审核 结束
                '9eaf8fb48a944a7082d44daa606b71f2': '7ef7180fa3104bf8a867abdac010b36b' //结项审核 结束
            }

        }

        Flow.prototype.getUiJson = function () {
            try {
                this.uiJson = JSON.parse('${group.uiJson}');
            }catch (e){
                this.uiJson = this.mdData.uiJson;
            }
        }



        Flow.prototype.setUiHtml = function () {
            this.svg.select('g').append(new Snap.fragment(this.uiHtml))
        }

        //init里面放立即调用内容
        Flow.prototype.init = function () {
            this.setUiHtml();
            this.flowContent.css({
                width: this.fcWidth,
                height: this.fcHeight
            });
            this.ajaxData();
        }

        Flow.prototype.ajaxData = function () {
            var _this = this;
            var path = '${faUrl}'
            $.ajax({
                type: "GET",
                url: '/' + path + "/actyw/actYwGnode/queryStatusTree/${group.id}?proInsId=${proInsId}&grade=${grade}",
                success: function (data) {
                    var lists = data.datas;
                    if (lists) {
                        _this.setColor(lists);
                    }

                }
            });
        }


        Flow.prototype.setColor = function (arr) {
            var len = arr.length;
            var type;
            var attrValue;
            var color;
            var listNodeSvg;
            var rect;
            var rectBack;
            var rectTitle;
            var text;
            var peopleImg;

            //让整个svg居中
            var gBox = this.svg.select('g[id="g"]').getBBox();
            var gWidth = gBox.width;
            var gHeight = gBox.height;

            var gLeft = gBox.x;
            var gTop = gBox.y;

            $('.flow-center').css('width', gWidth + 5).css('height', gHeight + 5);
            $('.flow-content').css('width', gWidth + 5 + gLeft).css('height', gHeight + 5 + gTop).css('left', -gLeft + 1).css('top', -gTop + 2);

            for (var i = 0; i < len; i++) {
                var list = arr[i];
                if (list.rstatus == 1) {
                    //设置颜色根据状态的不同代码 如果不为1 是灰色 否则为红色
                    type = list.type;
                    color = this.svg.select('g[model-id="' + list.id + '"]');
                    color = color || this.svg.select('g[model-id="' +  this.mdMaps[list.id] + '"]');
                    attrValue = {fill: "#E7B5A7", stroke: "#f00"};
                    if (this.task.indexOf(parseInt(type)) > -1) {
                        rect = color.selectAll("rect");
                        peopleImg = color.select("image");
                        rectBack = rect[0];
                        rectTitle = rect[1];
                        rectBack.attr(attrValue);

                        //让亮色小方块的头部居中
                        var rectBackStroke = rectBack.attr('strokeWidth');
                        var reg = /\d+/;
                        var rectBackStrokeWid = rectBackStroke.match(reg)[0];
                        var x = rectTitle.getBBox().x;
                        x = parseInt(x + rectBackStrokeWid);
                        rectTitle.attr({
                            fill: "#E9442C",
                        });
                        color.select("text").attr({
                            fill: "white"
                        });
                        peopleImg && peopleImg.attr({
                            href: "/images/flow-user-red.png"
                        });
                        break;

                    }
                }
            }

            for(var j = 0; j < len; j++){
                var listNode = arr[j];
                if(listNode.groleNames == '学生'){
                    var typeNode = listNode.type;
                    listNodeSvg = this.svg.select('g[model-id="'+ listNode.id + '"]');
                    listNodeSvg = listNodeSvg || this.svg.select('g[model-id="' + this.mdMaps[listNode.id] + '"]');
                    if(this.task.indexOf(parseInt(typeNode)) > -1){
                        listNodeSvg.selectAll("text")[1].node.innerHTML = '操作角色：';
                    }
                }
            }

        }

        var flow = new Flow();


    }(jQuery);


</script>

</body>
</html>