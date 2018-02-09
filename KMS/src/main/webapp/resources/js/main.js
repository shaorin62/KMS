$(document).ready(function() {
	var SLIDE_SPEED       = 8000;
	var ANIMATE_IMG_SPEED = 20000;


	var ANIMATE_IMG_INIT_STYLE = {
		top  : "-5%",
		left : "-5%",
		width: "110%"
	};
	var ANIMATE_IMG_STYLE = {
		top  : "0%",
		left : "0%",
		width: "100%"
	};


	function beforeSlideComponentAnimate( newIndex, oldIndex ){
		$('.bxslider>li:eq('+oldIndex+')>span.tx1').css({ opacity: 0 })
		$('.bxslider>li:eq('+oldIndex+')>span.tx2').css({ opacity: 0 })
		$('.bxslider>li:eq('+newIndex+')>span.tx1').css({ opacity: 0 })
		$('.bxslider>li:eq('+newIndex+')>span.tx2').css({ opacity: 0 })
	}

	function afterSlideComponentAnimate( newIndex, oldIndex ){
		// background image animation
		$('.bxslider>li:eq('+oldIndex+')>span.bg>img').removeClass('animate');	
		$('.bxslider>li:eq('+newIndex+')>span.bg>img').addClass('animate');
		// $('.bxslider>li:eq('+newIndex+')>span.bg>img')
		// 	.stop()
		// 	.css(ANIMATE_IMG_INIT_STYLE)
		// 	.animate(ANIMATE_IMG_STYLE, ANIMATE_IMG_SPEED);
		// $('.bxslider>li>span.bg>img').stop().delay(500).css("width", 100+"%");

	}

	if ($('.bxslider').length > 0){
			$('.bxslider').bxSlider({
				auto: true,
				mode: 'fade',
				pause: SLIDE_SPEED,
				speed: 700,
				autoControls: true,
				autoControlsCombine: true,
				onSliderLoad: function(currentIndex){
					afterSlideComponentAnimate(currentIndex);
				},
				onSlideBefore: function($slideElement, oldIndex, newIndex){
					beforeSlideComponentAnimate(newIndex, oldIndex);
				},
				onSlideAfter: function($slideElement, oldIndex, newIndex){
					afterSlideComponentAnimate(newIndex, oldIndex);
					// $('.bxslider>li:eq('+newIndex+')>span.bg>img').stop().animate({width: "120%"},7000);
					// $('.bxslider>li>span.bg>img').stop().animate({width: "120%"},7000);
				}
			});
		}

	// bxslider Play/Stop btn 배너 갯수에 따른 right 위치값 조절
	var banlistNum = $('.bxslider>li').size();

	$('.mid .bx-wrapper .bx-controls.bx-has-controls-auto.bx-has-pager .bx-controls-auto').css("left", (48 - (banlistNum * 1.3)+"%"));



	/* main checkin, checkout calendar 화면 높이에 따른 위치값 조절 */
	$('.main-calendar').hide().removeClass('hide');

	$('.mainSearchWrap li').mousedown(function() {
		$('.main-calendar').hide();
		$('.checkSelBox').removeClass('on');
	});

	$('.checkSelBox').click(function() {
		var thisViewHeight = $(window).height();
		var thisViewScrollTop = $(window).scrollTop();
		var thisSum = thisViewHeight + thisViewScrollTop;

		if (thisSum < 935){
			$('.main-calendar').addClass('up');
		}
		$('.checkSelBox').removeClass('on');
		$('.main-calendar').hide();
		$(this).addClass('on').next('.main-calendar').fadeIn(300);
		setTimeout(function() {
			$(document).one('click', function(){
			$('.main-calendar').hide();
			$('.checkSelBox').removeClass('on');
		});
		}, 500);
		
	});

	/* 오른쪽 margin 값 삭제 */
	$('.thisMonthBest .bestList li:last-child').css('margin-right', 0);


	/* 추천 FOCUS mid Bar */
	
	var mainMidMenu1 = '';
	var mainMidMenu2 = '';
	var mainMidMenu3 = '';
	var mainMidMenu4 = '';
	var mainMidMenu5 = '';
	var mainMidMenu6 = '';


	function offsetMainLoad() {
		mainMidMenu1 = $('#mainMidMenu1').offset().top;
		mainMidMenu2 = $('#mainMidMenu2').offset().top;
		mainMidMenu3 = $('#mainMidMenu3').offset().top;
		mainMidMenu4 = $('#mainMidMenu4').offset().top;
		mainMidMenu5 = $('#mainMidMenu5').offset().top;
		mainMidMenu6 = $('#mainMidMenu6').offset().top;
	}

	
	window.onload = function scrollBar() {

		offsetMainLoad();
		
		$( window ).scroll( function() {
			var mqMenuSize = $('.main-quick-menu-bar li').size();
			for (var mm = 0; mm < mqMenuSize ; mm++){
				var mm2 = mm +1;
				if ($(document).scrollTop() > (eval('mainMidMenu'+mm2)) - 96){
					$('.main-quick-menu-bar li').removeClass('on');
					$('.main-quick-menu-bar li:eq('+mm+')').addClass('on');
					if (mm2 == 1){
						$('.mainQmenuWrap').addClass('on');
					}
				}
			}
			if ($(document).scrollTop() <= mainMidMenu1 - 96 | $(document).scrollTop() >= mainMidMenu6 - 96){
				$('.mainQmenuWrap').removeClass('on');
			}

		});



		
		$('.main-quick-menu-bar li').each(function() {
			$(this).find('a').click(function() {
				var ml = ($(this).parent().index()) + 1;
				$('body, html').stop().animate({scrollTop: eval('mainMidMenu'+ml) - 95}, 'slow'); 
				return false;
			});
		});

	}




	/* 임직원 특별 제휴 할인서비스 */

	$('.slider4').bxSlider({
		slideWidth: 164,
		minSlides: 4,
		maxSlides: 4,
		moveSlides: 1,
		slideMargin: 10,
		pager: false
	});

	


	/* skydcrab */
	/* skydcrab - 좌우롤링 */
	$('.skyscrab >ul>li>a>.pic').append('<img src="/resources/images/main_sky_bg.png" alt="" class="skyscrab_bg">');
	

	var skyListSize = $('.skyscrab >ul>li').size();
	var	skyListSizeNum = parseInt(skyListSize / 3) * 3 +1 ;

	var skyThisNum = 1;
	$('.skyscrab >ul>li').hide();
	$('.skyscrab >ul>li:eq('+ (skyThisNum-1) +')').show();
	$('.skyscrab >ul>li:eq('+ (skyThisNum) +')').show();
	$('.skyscrab >ul>li:eq('+ (skyThisNum+1) +')').show();


	function rollThis() {
		skyThisNum = skyThisNum +3;
		if (skyThisNum > skyListSizeNum){skyThisNum = 1;}
		
		$('.skyscrab >ul>li').hide();
		$('.skyscrab >ul>li:eq('+ (skyThisNum-1) +')').fadeIn(200);
		$('.skyscrab >ul>li:eq('+ (skyThisNum) +')').fadeIn(200);
		$('.skyscrab >ul>li:eq('+ (skyThisNum+1) +')').fadeIn(200);
		
//		$('.revSec02').text(skyThisNum);
	}

	function rollThis2() {
		skyThisNum = skyThisNum -3;		
		if (skyThisNum < 0){
			skyThisNum = skyListSizeNum;
		}
		
//		$('.revSec02').text(skyThisNum);

		$('.skyscrab >ul>li').hide();
		$('.skyscrab >ul>li:eq('+ (skyThisNum-1) +')').fadeIn(200);
		$('.skyscrab >ul>li:eq('+ (skyThisNum) +')').fadeIn(200);
		$('.skyscrab >ul>li:eq('+ (skyThisNum+1) +')').fadeIn(200);
	}
	
	$('.leftbtn').click(rollThis2);
	$('.rightbtn').click(rollThis);

	/* skydcrab - 스크롤 고정 */
	var skyscrabTop = ($('#skyscrab').offset().top) - 23;

	$( window ).scroll( function() {
		if ($(document).scrollTop() >= skyscrabTop){
			$('#skyscrab').addClass('fixed');
		} else {
			$('#skyscrab').removeClass('fixed');
		}
	});
	$('#skyscrabTopBtn a').click(function() {
		$('body, html').stop().animate({scrollTop: 0}, 'fast'); 
		return false;
	});


	/* skydcrab - 펼치기/닫기 */
	var skySwitch = false;
	$('.delbtn, .stxHide').hide().removeClass('hide');
	$('.skybtn').click(function() {
		
		if (skySwitch == false){
			$('#skyscrab').animate({width: '271'}, 500).addClass('on');
			$('.skyscrab ul li a>p').hide();
			$('.delbtn, .skyscrab ul li a>p').fadeIn(700);
			skySwitch = true;
		} else {
			$('#skyscrab').animate({width: '90'}, 250).removeClass('on');
			$('.delbtn, .stxHide').fadeOut(100);
			skySwitch = false;
		}
	});


});