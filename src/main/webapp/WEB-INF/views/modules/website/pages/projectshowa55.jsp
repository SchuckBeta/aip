<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/modules/cms/front/include/taglib.jsp"%>
<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8" />
	<meta name="decorator" content="site-decorator" />
	<!--公用重置样式文件-->
	<link rel="stylesheet" href="/common/common-css/common.css" />
	<!--公用重置样式文件-->
	<link rel="stylesheet" type="text/css"
		  href="/common/common-css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="/css/yxxms.css" />
	<link rel="stylesheet" type="text/css"
		  href="/other/icofont/iconfont.css" />
	<title>${frontTitle}</title>
	<style>
		a{
			color:#000;
			text-decoration: none;
		}
		a:hover{
			color:#000;
			text-decoration: none;
		}
		.classBox {
			position: relative;
		}

		.classBoxone {
			position: relative;
			text-align: center;
			width: 636px;
			height: 693px;
			margin: auto;
		}

		.classBoxone img:nth-child(1) {
			width: 100%;
			height: 100%;
		}

		.classBoxone img:nth-child(2) {
			position: absolute;
			left: -86px;
			top: 0;
		}

		.classBoxone img:nth-child(3) {
			position: absolute;
			right: -41px;
			top: 0;
		}

		.classBoxone img:nth-child(4) {
			position: absolute;
			bottom: 182px;
			left: -30px;
		}

		.classBoxone img:nth-child(5) {
			position: absolute;
			bottom: 85px;
			right: 10px;
		}

		.classBoxone img:nth-child(6) {
			position: absolute;
			top: 217px;
			left: 138px;
		}

		.classBox .content {
			width: 302px;
		}

		.classBox .content_one {
			position: absolute;
			top: 100px;
			left: -51px;
			overflow: hidden; /*自动隐藏文字*/
			display: none;
		}

		.classBox .content_one, .content_second, .content_three, .content_four,
		.content_five h4, p {
			overflow: hidden; /*自动隐藏文字*/
			text-overflow: ellipsis; /*文字隐藏后添加省略号*/
			white-space: nowrap; /*强制不换行*/
		}

		.classBox .content_second {
			position: absolute;
			top: 159px;
			right: -25px;
			display: none;
		}

		.classBox .content_three {
			position: absolute;
			left: 23px;
			bottom: 0;
			display: none;
		}

		.classBox .content_four {
			position: absolute;
			right: -54px;
			bottom: 0;
			display: none;
		}

		.classBox  .content_five {
			position: absolute;
			top: -49px;
			left: 50%;
			margin-left: -151px;
			display: none;
		}
	</style>
</head>

<body>
<div class="container" style="margin-top: 40px;">
	<!-- <div class="scinfo">
        <div class="scinfonavigation">
            <ul>
                <li><img src="/img/bc_home.png"></li>
                <li><a href="/f/">首页></a></li>
                <li><a href="/f/page-projectshow"> 优秀项目展示></a></li>
                <li>腕带识别系统</li>
            </ul>
        </div>
    </div> -->
	<div style="clear: both;"></div>
	<div class="system_info">
		<h3>可折叠太阳能板汽车（SE-CAR）</h3>
		<p>项目来源:创新创业项目 &nbsp;&nbsp;发布时间:2016-12-10</p>
		<div class="system">
			<img src="/img/pro-detail55.jpg" />
		</div>
		<div class="systemright">
			<p style="display: none">荣获奖项:优秀项目</p>
			<p>学院:机械院</p>
			<p>指导老师:张维刚 教授</p>
			<p style="display: none">浏览量:140 点赞数:20 评论:5</p>
			<button type="button">环保</button>
			<button type="button">太阳能</button>
		</div>
	</div>
	<div style="clear: both;"></div>

</div>
<div class="introduction">
	<div class="introduction_info container">
		<h4>
			项目介绍<img src="/img/footerline.png">
		</h4>
		<div class="xmone" style="width: 100%">
			<ul>
				<li>项目简介</li>
				<li><img src="/img/pro-detail55.jpg"></li>
				<li style="width: auto;height: auto;">随着太阳能在各方面的广泛利用，太阳能汽车的开发与发展越来越受到大家的重视。SE-car项目的提出就是通用中国和PACE联合提出解决这些问题的一个方案。我们团队与另外多所高校合作旨在共同完成这一目标。
					SE-car是一种用于城市间小型太阳能助力车，它解决了与公共交通和私人交通。对速度没有过高要求，规定速度为30km/h。动力主要由可折叠式的太阳能电池板提供，连阴天的时候也由电网供电（给随车蓄电池充电）。
					整个项目的重点在于太阳能电池板折叠机构在车身上的实现形式。如何在添加太阳能电池板折叠机构后保证车身的安全性及轻量化成为结构设计上的难点。</li>
			</ul>
		</div>

		<div class="xmtwo" style="display: none">
			<ul>
				<li>我们的客户</li>
				<li><img src="/img/yxxmteach.jpg"></li>
				<li>本产品是一款利用红外装置识别手指运动的智能硬件，在手势控制领域有着诸多应用。
					项目应用IPV6作为手势数据传输协议，将研发的手</li>
			</ul>
		</div>

		<div class="xmthree" style="display: none">
			<ul>
				<li>我们的发展方向</li>
				<li><img src="/img/yxxmteach.jpg"></li>
				<li>本产品是一款利用红外装置识别手指运动的智能硬件，在手势控制领域有着诸多应用。
					项目应用IPV6作为手势数据传输协议，将研发的手</li>
			</ul>
		</div>
	</div>
</div>
<div class="product container">
	<h4>
		产品展示<img src="/img/footerline.png">
	</h4>
	<div class="productdisplay" style="text-align: center">
		<img src="/img/pro-detail-big5501.jpg" style="width: auto;max-width: 75%;height: auto;margin: 15px auto">
		<img src="/img/pro-detail-big5502.jpg" style="width: auto;max-width: 75%;height: auto;margin: 15px auto">
		<img src="/img/pro-detail-big5503.jpg" style="width: auto;max-width: 75%;height: auto;margin: 15px auto">
		<img src="/img/pro-detail-big5504.jpg" style="width: auto;max-width: 75%; height: auto;margin: 15px auto">
	</div>
	<div style="clear: both;"></div>
	<div class="productdisplayone" style="display: none">
		<div id="one">
			<img src="/img/yxsj03.jpg" style="width: 100%; height: inherit;">
		</div>
		<div id="two">
			<img src="/img/yxsj01.jpg" style="width: 100%; height: inherit;">
		</div>
	</div>
</div>
<div class="team container">
	<h4>
		团队风采<img src="/img/footerline.png">
	</h4>

	<!--团队风采-->
	<div class="classBox" style="text-align: center">
		<img style="width: 75%;height: auto" src="/img/teampic2.jpg">
		<div class="classBoxone" style="display: none">
			<%--<img src="/img/yxxmzs.jpg"> <img src="/img/yxperson01.png"--%>
			<%--class="IMG"> <img src="/img/yxperson02.png" class="IMG">--%>
			<%--<img src="/img/yxperson03.png" class="IMG"> <img--%>
			<%--src="/img/yxperson04.png" class="IMG"> <img--%>
			<%--src="/img/yxperson07.png" class="IMG">--%>

		</div>
		<div class="content_one content">
			<h4>
				组成员：<span>KKK</span>
			</h4>
			<p>
				<span>计算机学院</span>&nbsp;<span>物联网工程专业</span>
			</p>
			<p>
				年龄：<span>21</span>
			</p>
			<p>
				学院：<span>计算机学院</span>
			</p>
			<p>
				学历：<span>在校/15级/本科</span>
			</p>
			<p>
				技术领域：<span>数据处理、科学计算</span>
			</p>
			<p>
				荣获奖项：<span>荣获2015年校级"互联网+"大赛二等奖</span>
			</p>
		</div>
		<div class="content_second content">
			<h4>
				组成员：<span>CCC</span>
			</h4>
			<p>
				<span>计算机学院</span>&nbsp;<span>物联网工程专业</span>
			</p>
			<p>
				年龄：<span>21</span>
			</p>
			<p>
				学院：<span>计算机学院</span>
			</p>
			<p>
				学历：<span>在校/15级/本科</span>
			</p>
			<p>
				技术领域：<span>数据处理、科学计算</span>
			</p>
			<p>
				荣获奖项：<span>荣获2015年校级"互联网+"大赛二等奖</span>
			</p>
		</div>
		<div class="content_three content">
			<h4>
				组成员：<span>XXX</span>
			</h4>
			<p>
				<span>计算机学院</span>&nbsp;<span>物联网工程专业</span>
			</p>
			<p>
				年龄：<span>21</span>
			</p>
			<p>
				学院：<span>计算机学院</span>
			</p>
			<p>
				学历：<span>在校/15级/本科</span>
			</p>
			<p>
				技术领域：<span>数据处理、科学计算</span>
			</p>
			<p>
				荣获奖项：<span>荣获2015年校级"互联网+"大赛二等奖</span>
			</p>
		</div>
		<div class="content_four content">
			<h4>
				组成员：<span>BBB</span>
			</h4>
			<p>
				<span>计算机学院</span>&nbsp;<span>物联网工程专业</span>
			</p>
			<p>
				年龄：<span>21</span>
			</p>
			<p>
				学院：<span>计算机学院</span>
			</p>
			<p>
				学历：<span>在校/15级/本科</span>
			</p>
			<p>
				技术领域：<span>数据处理、科学计算</span>
			</p>
			<p>
				荣获奖项：<span>荣获2015年校级"互联网+"大赛二等奖</span>
			</p>
		</div>
		<div class="content_five content">
			<h4>
				组成员：<span>CCC</span>
			</h4>
			<p>
				<span>计算机学院</span>&nbsp;<span>物联网工程专业</span>
			</p>
			<p>
				年龄：<span>21</span>
			</p>
			<p>
				学院：<span>计算机学院</span>
			</p>
			<p>
				学历：<span>在校/15级/本科</span>
			</p>
			<p>
				技术领域：<span>数据处理、科学计算</span>
			</p>
			<p>
				荣获奖项：<span>荣获2015年校级"互联网+"大赛二等奖</span>
			</p>
		</div>
	</div>
	<div class="container">
		<div class="comment">
			<span>发表评论</span>

			<div class="style_info"></div>
			<div style="float: right; margin-top: -30px;">
				<i class="iconfont">&#xe649;</i>(30)&nbsp;&nbsp; <i
					class="iconfont">&#xe622;</i>(5)
			</div>
			<div style="clear: both;"></div>
			<textarea id="discuss" style="resize: none"></textarea>
			<input type="button" value="发表评论" id="publish" />
			<ul class="review">
				<li id="all">全部评论(30)</li>
				<li id="my">我的评论(1)</li>
			</ul>
		</div>
		<div style="clear: both;"></div>
		<div class="commentcontent">
			<div class="commentimg">
				<img src="/img/ceo.png">
			</div>
			<div class="commentright">
				<p>
					<strong class="name_info">彭宇 </strong><span>&nbsp;1小时</span>
				</p>
				<p>适合从来没有接触过计算机科学成果的人们，学会计算机会议编写程序科研</p>
				<p>
					<i class="iconfont">&#xe622;</i>(30)&nbsp;&nbsp; 回复(0)</a>
				</p>
			</div>
		</div>

		<div class="commentcontent">
			<div class="commentimg">
				<img src="/img/ceo.png">
			</div>
			<div class="commentright">
				<p>
					<strong class="name_info">彭宇 </strong> <span>&nbsp;1小时</span>
				</p>
				<p>适合从来没有接触过计算机科学成果的人们，学会计算机会议编写程序科研</p>
				<p>
					<i class="iconfont">&#xe622;</i>(30) 回复(0)</a>
				</p>
			</div>
		</div>

		<div class="commentcontent">
			<div class="commentimg">
				<img src="/img/ceo.png">
			</div>
			<div class="commentright">
				<p>
					<strong class="name_info">彭宇 </strong> <span>&nbsp;1小时</span>
				</p>
				<p>适合从来没有接触过计算机科学成果的人们，学会计算机会议编写程序科研</p>
				<p>
					<i class="iconfont">&#xe622;</i>(30) &nbsp;&nbsp;回复(0)</a>
				</p>
			</div>
		</div>

		<div class="packup">
			<a href="javascript:void(0)">收起/展示所有评论</a>
		</div>

		<div class="commentcontent commentcontent_info">
			<div class="commentimg">
				<img src="/img/ceo.png">
			</div>
			<div class="commentright">
				<p>
					<strong class="name_info">彭宇 </strong> <span>&nbsp;1小时</span>
				</p>
				<p>适合从来没有接触过计算机科学成果的人们，学会计算机会议编写程序科研</p>
				<p>
					<i class="iconfont">&#xe622;</i>(30) &nbsp;&nbsp;回复(0)</a>
				</p>
			</div>
		</div>

		<div class="commentcontent commentcontent_info">
			<div class="commentimg">
				<img src="/img/ceo.png">
			</div>
			<div class="commentright">
				<p>
					<strong class="name_info">彭宇 </strong> <span>&nbsp;1小时</span>
				</p>
				<p>适合从来没有接触过计算机科学成果的人们，学会计算机会议编写程序科研</p>
				<p>
					<i class="iconfont">&#xe622;</i>(30)&nbsp;&nbsp; 回复(0)</a>
				</p>
			</div>
		</div>

		<div class="commenttwo">
			<div class="commentimg">
				<img src="/img/ceo.png">
			</div>
			<div class="commentright">
				<p>
					<strong class="name_info">彭宇 </strong> <span>&nbsp;1小时</span>
				</p>
				<p>适合从来没有接触过计算机科学成果的人们，学会计算机会议编写程序科研</p>
				<p>
					<i class="iconfont">&#xe622;</i>(30) &nbsp;&nbsp;回复(0)</a>
				</p>
			</div>
		</div>

		<div class="commenttwo">
			<div class="commentimg">
				<img src="/img/ceo.png">
			</div>
			<div class="commentright">
				<p>
					<strong class="name_info">彭宇 </strong> <span>&nbsp;1小时</span>
				</p>
				<p>适合从来没有接触过计算机科学成果的人们，学会计算机会议编写程序科研</p>
				<p>
					<i class="iconfont">&#xe622;</i>(30) &nbsp;&nbsp;回复(0)</a>
				</p>
			</div>
		</div>

		<div class="commenttwo">
			<div class="commentimg">
				<img src="/img/ceo.png">
			</div>
			<div class="commentright">
				<p>
					<strong class="name_info">彭宇 </strong> <span>&nbsp;1小时</span>
				</p>
				<p>适合从来没有接触过计算机科学成果的人们，学会计算机会议编写程序科研</p>
				<p>
					<i class="iconfont">&#xe622;</i>(30) &nbsp;&nbsp;回复(0)</a>
				</p>
			</div>
		</div>

		<div class="packupone">
			<a href="javascript:void(0)">收起/展示所有评论</a>
		</div>

		<div class="commenttwo commentcontent_info">
			<div class="commentimg">
				<img src="/img/ceo.png">
			</div>
			<div class="commentright">
				<p>
					<strong class="name_info">彭宇 </strong><span>&nbsp;1小时</span>
				</p>
				<p>适合从来没有接触过计算机科学成果的人们，学会计算机会议编写程序科研</p>
				<p>
					<i class="iconfont">&#xe622;</i>(30) &nbsp;&nbsp;回复(0)</a>
				</p>
			</div>
		</div>

		<div class="commenttwo commentcontent_info">
			<div class="commentimg">
				<img src="/img/ceo.png">
			</div>
			<div class="commentright">
				<p>
					<strong class="name_info">彭宇 </strong><span>&nbsp;1小时</span>
				</p>
				<p>适合从来没有接触过计算机科学成果的人们，学会计算机会议编写程序科研</p>
				<p>
					<i class="iconfont">&#xe622;</i>(30) &nbsp;&nbsp;回复(0)</a>
				</p>
			</div>
		</div>
	</div>
</div>
<script src="/common/common-js/clamp.js" type="text/javascript"
		charset="utf-8"></script>
<script type="text/javascript" src="/common/common-js/jquery.min.js"></script>
<script>
	$(function() {
		$("#main").click(function() {
			$(".tab_info").show();
			$(".tab_infoone").hide();
		})
		$("#add").click(function() {
			$(".tab_infoone").show();
			$(".tab_info").hide();
		})
		$(".packup a").click(function() {
			$(".packup").hide();
			$(".commentcontent_info").show();
		})
		$(".packupone a").click(function() {
			$(".packupone").hide();
			$(".commentcontent_info").show();
		})
		$("#all").click(function() {
			$(".commentcontent").show();
			$(".commenttwo").hide();
		})

		var flag = true;
		$('.classBoxone .IMG').on(
				'click',
				function() {
					if (flag) {
						$('.classBox .content').eq($(this).index() - 1)
								.fadeIn(500);
						flag = false;
					} else {
						$('.classBox .content').eq($(this).index() - 1)
								.fadeOut(500);
						flag = true;
					}
					;
				})
	})
</script>
</body>

</html>