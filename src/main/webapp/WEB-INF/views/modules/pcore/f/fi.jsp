<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${frontTitle}</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="${ctxStatic}/fullpage/fullpage.min.css">
    <script src="${ctxStatic}/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="${ctxStatic}/fullpage/fullpage.min.js" type="text/javascript"></script>
    <style type="text/css">
    		#header, #footer{
				position:fixed;
				height: 50px;
				display:block;
				width: 100%;
				background: #333;
				z-index:9;
				text-align:center;
				color: #f2f2f2;
				padding: 20px 0 0 0;
			}

			#header{
				top:0px;
			}
			#footer{
				bottom:0px;
			}

			.section, .slide{
				background-repeat: no-repeat; background-size: cover;
				/* transform: translateY(-50%); */
				background-attachment: fixed;
				text-align: center;
				padding:auto;
			}

		   .section .intro{
			   color: #fff;
			   width: 1200px;
				margin:auto;
				padding:auto;
		   }
		   .intro h1, .intro p{
				text-align: left;
		   }
   		   .intro p{
   		   		text-indent: 2em;
		   }

			#menu li {
				display:inline-block;
				margin: 10px;
				color: #000;
				background:#fff;
				background: rgba(255,255,255, 0.5);
				-webkit-border-radius: 10px;
			            border-radius: 10px;
			}
			#menu li.active{
				background:#666;
				background: rgba(0,0,0, 0.5);
				color: #fff;
			}
			#menu li a{
				text-decoration:none;
				color: #000;
			}
			#menu li.active a:hover{
				color: #000;
			}
			#menu li:hover{
				background: rgba(255,255,255, 0.8);
			}
			#menu li a,
			#menu li.active a{
				padding: 9px 18px;
				display:block;
			}
			#menu li.active a{
				color: #fff;
			}
			#menu{
				position:fixed;
				top:0;
				left:0;
				height: 40px;
				z-index: 70;
				width: 100%;
				padding: 0;
				margin:0;
			}
			.fp-slidesNav.bottom{
					bottom: 25px;
			}

    </style>
</head>
<body>
<div id="header">
	<ul id="menu">
	    <li data-menuanchor="sec1"><a href="#sec1">First slide</a></li>
	    <li data-menuanchor="sec2"><a href="#sec2">Second slide</a></li>
	    <li data-menuanchor="sec3"><a href="#sec3">Third slide</a></li>
	    <li data-menuanchor="sec4"><a href="#sec4">First slide</a></li>
	    <li data-menuanchor="sec5"><a href="#sec5">Second slide</a></li>
	    <li data-menuanchor="sec6"><a href="#sec6">Third slide</a></li>
	</ul>
</div>
<div id="fullpage">
	<div class="section" style="background-image:url('/images/zjl/f/fi_bg.jpg');">
		<div class="intro">
			<h1>中骏龙新能源</h1>
			<p>
				武汉中骏龙新能源科技有限公司是一家专为电动汽车厂家配套提供具有世界领先水平的新能源汽车动力电池（高电压大容量超薄型石墨烯电池）和氢燃料电池发电机的新能源高科技企业。企业专家团队是由我国长年从事军工高科技和石墨烯新材料研发的专家组成。公司注册资金为88889万元，发改委备案投资218亿元，公司注册地武汉阳逻经济开发区。
			</p>
		</div>
	</div>
	<div class="section" style="background-image:url('/images/zjl/f/fi_bg_1.jpg');">
		<div class="intro">
			<h1>产品“六大”特点</h1>
			<p>
				一是环保；二是免充电无限续航；三是生产过程无污染；四是安全；五是寿命长；六是成本大大降低。它的诞生将是新能源汽车行业一次颠覆性的革命。
			</p>
		</div>
	</div>
	<div class="section">
		<div class="slide" style="background-image:url('/images/zjl/f/fi_bg_2.jpg');">
			<div class="intro">
				<h1>大动力、零污染、高寿命、免充电、无限续航</h1>
				<p>
					目前该项技术国家知识产权局已批准颁发了四项专利（详见专利原件），它的问世从真正意义上实现了人们和社会期盼的大动力、零污染、高寿命、免充电、无限续航的目标。是汽车新能源发展的一个新的里程碑，同时必将向其它行业延伸，具有深远的划时代的意义
				</p>
			</div>
		</div>
		<div class="slide" style="background-image:url('/images/zjl/f/fi_bg_2_1.jpg');">
			<div class="intro">
				<h1>大动力</h1>
				<p>
					You will need to place your header and footer outside the plugin's wrapper.
					This way it won't move on scrolling. Take a look at the source code of this page.
				</p>
			</div>
		</div>
		<div class="slide" style="background-image:url('/images/zjl/f/fi_bg_2_2.jpg');">
			<div class="intro">
				<h1>零污染</h1>
				<p>
					You will need to place your header and footer outside the plugin's wrapper.
					This way it won't move on scrolling. Take a look at the source code of this page.
				</p>
			</div>
		</div>
		<div class="slide" style="background-image:url('/images/zjl/f/fi_bg_2_2.jpg');">
			<div class="intro">
				<h1>高寿命</h1>
				<p>
					You will need to place your header and footer outside the plugin's wrapper.
					This way it won't move on scrolling. Take a look at the source code of this page.
				</p>
			</div>
		</div>
		<div class="slide" style="background-image:url('/images/zjl/f/fi_bg_2_3.jpg');">
			<div class="intro">
				<h1>无限续航</h1>
				<p>
					You will need to place your header and footer outside the plugin's wrapper.
					This way it won't move on scrolling. Take a look at the source code of this page.
				</p>
			</div>
		</div>
		<div class="slide" style="background-image:url('/images/zjl/f/fi_bg_2_4.jpg');">
			<div class="intro">
				<h1>无限续航</h1>
				<p>
					You will need to place your header and footer outside the plugin's wrapper.
					This way it won't move on scrolling. Take a look at the source code of this page.
				</p>
			</div>
		</div>
	</div>
	<div class="section" style="background-image:url('/images/zjl/f/fi_bg_3.jpg');">
		<div class="intro">
			<h1>百亿规划</h1>
			<p>
				总体规划投资218亿元人民币，拟建60条生产线和华中最大的免充电无限续航新能源汽车销售基地。计划每条生产线年产值18亿元人民币，年生产总值为1080亿元人民币，纯利为33.52%，届时每年60条生产线可实现纯利326亿元人民币。
			</p>
		</div>
	</div>
	<div class="section" style="background-image:url('/images/zjl/f/fi_bg_4.jpg');">
		<div class="intro">
			<h1>团队和技术</h1>
			<p>
				专家团队和技术力量及管理团队已准备就绪，石墨烯原材料及生产流水线的意向合同已订，总之我们已在人力、物力、管理及技术等方已做好了一切准备，争取早日变为现实。
			</p>
		</div>
	</div>
	<div class="section" style="background-image:url('/images/zjl/f/fi_bg_5.jpg');">
		<div class="intro">
			<h1>团队和技术</h1>
			<p>
				专家团队和技术力量及管理团队已准备就绪，石墨烯原材料及生产流水线的意向合同已订，总之我们已在人力、物力、管理及技术等方已做好了一切准备，争取早日变为现实。
			</p>
		</div>
	</div>
	<div class="section" style="background-image:url('/images/zjl/f/fi_bg_6.jpg');">
		<div class="intro">
			<h1>团队和技术</h1>
			<p>
				专家团队和技术力量及管理团队已准备就绪，石墨烯原材料及生产流水线的意向合同已订，总之我们已在人力、物力、管理及技术等方已做好了一切准备，争取早日变为现实。
			</p>
		</div>
	</div>
		<div class="section" style="background-image:url('/images/zjl/f/fi_bg_7.jpg');">
		<div class="intro">
			<h1>团队和技术</h1>
			<p>
				专家团队和技术力量及管理团队已准备就绪，石墨烯原材料及生产流水线的意向合同已订，总之我们已在人力、物力、管理及技术等方已做好了一切准备，争取早日变为现实。
			</p>
		</div>
	</div>
</div>
<!-- <div id="footer">Footer</div> -->
<script type="text/javascript">
    var myFullpage = new fullpage('#fullpage', {
    	//自定义选择器
    	sectionSelector: '.section',
    	slideSelector: '.slide',
       	menu: '#menu',
    	lockAnchors: false,
    	anchors:['sec1', 'sec2', 'sec3', 'sec4', 'sec5', 'sec6'],
    	sectionsColor: ['#1bbc9b', '#4BBFC3', '#7BAABE', 'whitesmoke', '#ccddff', '#cc2dff'],
    	navigation: false,
    	navigationTooltips: ['图1', '图2', '图3', '图4', '图5', '图6'],
    	showActiveTooltip: true,
    	slidesNavigation: true,
    	//滚动
    	css3: true,
    	scrollingSpeed: 700,
    	autoScrolling: true,
    	fitToSection: true,
    	fitToSectionDelay: 1000,
    	scrollBar: true,
    	easingcss3: 'ease',
    	loopBottom: true,
    	loopTop: true,
    	loopHorizontal: true,
    	continuousVertical: false,
    	continuousHorizontal: false,
    	scrollHorizontally: false,
    	interlockedSlides: false,
    	dragAndMove: false,
    	offsetSections: false,
    	resetSliders: false,
    	fadingEffect: false,
    	/* normalScrollElements: '#element1, .element2', */
    	scrollOverflow: false,
    	scrollOverflowReset: false,
    	scrollOverflowOptions: null,
    	touchSensitivity: 15,
    	normalScrollElementTouchThreshold: 5,
    	bigSectionsDestination: null,

    	//可访问
    	keyboardScrolling: true,
    	animateAnchor: true,
    	recordHistory: true,

    	//设计
    	controlArrows: true,
    	verticalCentered: true,
    	paddingTop: '0px',
    	paddingBottom: '0px',
    	fixedElements: '#header, .footer',
    	responsiveWidth: 0,
    	responsiveHeight: 0,
    	responsiveSlides: false,
    	parallax: false,
    	parallaxOptions: {type: 'reveal', percentage: 62, property: 'translate'},

        lazyLoad: true,
    	lazyLoading: true,

    	//事件
    	onLeave: function(origin, destination, direction){},
    	afterLoad: function(origin, destination, direction){},
    	afterRender: function(){},
    	afterResize: function(width, height){},
    	afterResponsive: function(isResponsive){},
    	afterSlideLoad: function(section, origin, destination, direction){},
    	onSlideLeave: function(section, origin, destination, direction){}
    });
</script>
</body>
</html>