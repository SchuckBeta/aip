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
			}

			.section img{
				left: 130%;
				position:relative;
		     	transition: all 600ms ease;
			}
			.section p{
				opacity: 0;
		     transition: all 600ms ease;
			}
			.section .intro{
				left: -130%;
				position:relative;
		     transition: all 600ms ease;
			}

		   .section .intro{
		     left: -130%;
		     position:relative;
		     transition: all 600ms ease;
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

	<!-- <select id="demosMenu">
	  <option selected>Choose Demo</option>
	  <option id="jquery-adapter">jQuery adapter</option>
	  <option id="active-slide">Active section and slide</option>
	  <option id="auto-height">Auto height</option>
	  <option id="autoplay-video-and-audio">Autoplay Video and Audio</option>
	  <option id="backgrounds">Background images</option>
	  <option id="backgrounds-fixed">Fixed fullscreen backgrounds</option>
	</select> -->
</div>
<div id="fullpage">
	<div class="section" style="background-image:url('/images/zjl/f/fi_bg.jpg');">
		<div class="intro">
			<h1>Fixed elements</h1>
			<p>Create your own headers and footers</p>
		</div>
	</div>
	<div class="section" style="background-image:url('/images/zjl/f/fi_bg_1.jpg');">
		<div class="intro">
			<h1>Enjoy it</h1>
		</div>
	</div>
	<div class="section" style="background-image:url('/images/zjl/f/fi_bg_2.jpg');">
		<div class="slide" style="background-image:url('/images/zjl/f/fi_bg_2_1.jpg');">
			<div class="intro">
				<h1>How to do it</h1>
				<p>
					You will need to place your header and footer outside the plugin's wrapper.
					This way it won't move on scrolling. Take a look at the source code of this page.
				</p>
			</div>
		</div>

		<div class="slide" style="background-image:url('/images/zjl/f/fi_bg_2_2.jpg');">
			<h1>Slide 2</h1>
			<img src="imgs/iphone-blue.png" alt="iphone" id="iphone-two" />
		</div>

		<div class="slide" style="background-image:url('/images/zjl/f/fi_bg_2_3.jpg');">
			<h1>Slide 2</h1>
			<img src="imgs/iphone-blue.png" alt="iphone" id="iphone-two" />
		</div>
	</div>
	<div class="section" style="background-image:url('/images/zjl/f/fi_bg_3.jpg');">
		<div class="intro">
			<h1>Enjoy it</h1>
		</div>
	</div>
	<div class="section" style="background-image:url('/images/zjl/f/fi_bg_4.jpg');">
		<div class="intro">
			<h1>Enjoy it</h1>
		</div>
	</div>
	<div class="section" style="background-image:url('/images/zjl/f/fi_bg_5.jpg');">
		<div class="intro">
			<h1>Enjoy it</h1>
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