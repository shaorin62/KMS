/*
 * checkbox, radio 통합
 */
function checkboxAndRadioSetting(){
	var types = ['radio', 'check'];

	for (var i=0, len=types.length; i < len; i++){
		$('.inp-'+ types[i] +' input[type='+ (types[i] == 'check' ? 'checkbox' : 'radio') +']').each( function(){
			var $this  = $( this );
			var $label = $this.next( 'label' );

			// 디자인 combo 추가
			if ( $label.has('.box').length == 0 ){
				$label.prepend( '<span class="box"></span>' );
			}

			// disabled 아닐경우에만 동작
			if ( !$this.attr('disabled') ){
				$label.toggleClass('on', $this.is(":checked") ); // 시작시 체크되어 있으면 체크

				$this.on( 'click', function(){
					var $this = $( this );
					var type  = $this.attr('type');
					var name  = $this.attr('name');

					// type="radio" 일때는 관련 radio off 표현
					if ( type == 'radio' ){
						$('.inp-'+ type +' input[name=' + name + '] + label').removeClass('on');
					}

					$label.toggleClass('on', $this.is(":checked"));
				});
			}
		});
	}
};

/*
 * placeholder 통합(textarea 가능)
 */
function placeholderSetting(){
	var tmp = document.createElement('input');
	var isSupport = 'placeholder' in tmp;

	$('input[placeholder], textarea[placeholder]').each( function(){
		var $this = $( this );

		if ( !isSupport ){
			var initTxt = $this.attr('placeholder');

			if ( $this.val().length == 0 || $this.val() == initTxt ){
				$this.addClass('placeholder');
				$this.val( initTxt );
			}

			// 포커스시, 초기 내용과 입력 내용이 같으면 내용 지우고 표시된 class 제거
			$this.on('focus', function( e ){
				if ( $this.val() == initTxt ){
					$this.removeClass('placeholder');
					$this.val( '' );
				}
			});

			// 포커스 아웃시, 아무 입력 내용 없으면 초기 내용과 class로 표시
			$this.on('blur', function(){
				if ( $this.val().length == 0 || $this.val() == initTxt ){
					$this.addClass('placeholder');
					$this.val( initTxt );
				}
			});
		}
	});
}

/*
 * 추천 리조트 상품 Tab - Sorting
 */
function resortTab() {

	$('.btnTab ul li').click(function() {
		var thisNum = $(this).index();
		var thisPlaceBt = $(this).find('button').text();

		$('.btnTab ul li button').removeClass('on');
		$('.btnTab ul li:eq('+ thisNum +') button').addClass('on');

		if (thisNum == 0){
			$('.tabContents li').show();
		} 
		else {
			$('.tabContents li').hide();
			$('.tabContents li').each(function() {
				var thisPlace = $(this).find('.place').text();
				if (thisPlace == thisPlaceBt){$(this).show();}
			})
		}
	});	

	/* icon 자동 입력 */
	$('.goods-list li').each(function() {
		var iconStay = $(this).find('.blockn').text();
		if (iconStay == '호텔'){$(this).find('.blockn').addClass('block-pink');}
		if (iconStay == '리조트'){$(this).find('.blockn').addClass('block-orange');}
		if (iconStay == '펜션'){$(this).find('.blockn').addClass('block-blue');}
	});

	$('.searchTit').next('.bx02').css('padding-right', 5);


}




$(document).ready(function() {

checkboxAndRadioSetting();
placeholderSetting();
resortTab();



// skipNavi
$( '#skipNavi a' ).on( {
	'focusin' : function( ) {
		$( this ).css( 'top','0' );
	},
	'focusout' : function( ) {
		$( this ).css( 'top','-9999px' );
	},
	'mousedown' : function( e ) {
		var link = $( this ).attr( 'href' ),
			$link = $( link );

		if ( $link.is( 'a' ) ) {
			$link.focus( );
		} else {
			$( link ).find( 'a' ).first( ).focus( );
		}

		return false;
	},
	'click' : function( e ) {
		var link = $( this ).attr( 'href' ),
			$link = $( link );

		if ( $link.is( 'a' ) ) {
			$link.focus( );
		} else {
			$( link ).find( 'a' ).first( ).focus( );
		}
		return false;
	}
});




	
	
	
	
	/* select script 페이지 지정 */
	if ($('select').length > 0){
		try {$("body select").msDropDown();}
		catch(e) {}
	}



	/* 상품 리스트 오른쪽 마진값 삭제 */
	$('.thumbmail a:nth-child(4n)').css('margin-right', 0);
	$('.travelList li:nth-child(4n)').css('margin-right', 0);
	$('.reserveListGo li:nth-child(2n)').css('margin-right', 0);
	

	
	/* 상품 상세 Tab */
	$('.detailTab>li').click(function() {
		var dTabNum = $(this).index();
		$(this).parent('.detailTab').children('li').removeClass('on');
		$(this).addClass('on');

		$(this).parent('.detailTab').next('.detailTabConents').children('li').hide().removeClass('hide');
		$(this).parent('.detailTab').next('.detailTabConents').children('li:eq('+dTabNum+')').show();;

	});

	
	
	/* 상품 상세 캘린더 버튼 on */
	$('.calendar .possible button').click(function() {
		$('.calendar .possible button').removeClass('on');
		$(this).addClass('on');
	});




	/* 상품상세 고객 상품평 열기 닫기 */
	$('.ellipsis').each(function() {	/* 상품평이 두줄 넘을때 열기 기능 */
		$(this).removeClass('on');
		$(this).next('.more2').addClass('hide');

		if ($(this).height() > 44) {
			$(this).addClass('on');
			$(this).next('.more2').removeClass('hide');
		} else {
			$(this).prevAll('.tit').find('strong').unwrap();
		}
	});
		
	$('.custReview li button').click(function() {
		$(this).parents('.fl').find('.ellipsis').toggleClass('on');
		$(this).parents('.fl').find('.more2').toggleClass('hide');
	});




	/* 상품상세 - 예약하기 리스트 열기/닫기 */
	$('.reservateBtn').click(function() {
		
		if ($(this).parents('tr').next('.reservation').hasClass('hide')){
			$('.tableComm .reservation').addClass('hide');
			$(this).parents('tr').next('.reservation').removeClass('hide');
		} else {
			$(this).parents('tr').next('.reservation').addClass('hide');
		}
		offsetLoad();
	});




	/* 상품상세 - 추천여행기 각 제목 두줄 초과일때 말줄임 */
	$('.travelList li .tit').each(function() {
		if ($(this).height() > 40) {
			$(this).addClass('on');
		}
	});




	/* 마이페이지 - 툴팁 */
	$('.tooltip').mouseenter(function() { $(this).addClass('on'); });
	$('.tooltip').mouseout(function() {	$(this).removeClass('on'); });


	// faq
	$('.btn-toggle').click(function(){
		$(this).parent().parent().parent().toggleClass('on');
	});


/* 회원가입 - 로그인 */
	
	if ($('#loginSlider').length > 0){
		var banlistNum2 = $('.loginSlider>li').size();

		/* 로그인페이지 - 배너 1개일때 롤링 제거 */
		if (banlistNum2 > 1){
			$('#loginSlider').bxSlider({
			  mode: 'fade',
			  auto: true,
			  autoControls: true,
			  autoControlsCombine: true,
			  pause: 4000
			});
		} else {
			$('#loginSlider').bxSlider({
				auto: false,
				controls: false,
				autoControls: false,
				autoControlsCombine: false,
				
				Pager: false
			});
		}
		

		$('.memberLoginBox > .fr > .bx-wrapper > .bx-controls > .bx-controls-auto').css("right", (7 + (banlistNum2 * 17)+"px"));
		
		

	}
	



// file 첨부 시 파일속성 icon 자동 삽입
	if ($('.file').length > 0){
		$('.file a').each(function() {
			if ($(this).text().lastIndexOf( '.doc' ) > -1 ){$(this).addClass('doc');}
			else if ($(this).text().lastIndexOf( '.xls' ) > -1){$(this).addClass('xls');}
			else if ($(this).text().lastIndexOf( '.png' ) > -1){$(this).addClass('png');}
			else if ($(this).text().lastIndexOf( '.jpg' ) > -1){$(this).addClass('jpg');}
			else if ($(this).text().lastIndexOf( '.gif' ) > -1){$(this).addClass('gif');}
			else if ($(this).text().lastIndexOf( '.zip' ) > -1){$(this).addClass('zip');}
			else if ($(this).text().lastIndexOf( '.pdf' ) > -1){$(this).addClass('pdf');}
			else if ($(this).text().lastIndexOf( '.htm' ) > -1){$(this).addClass('html');}
			else if ($(this).text().lastIndexOf( '.ppt' ) > -1){$(this).addClass('ppt');}
			else {$(this).addClass('etc');}
		});
	}


// input type="file" 디자인변경
	if ($('.filebox').length > 0){
		var fileTarget = $('.filebox .upload-hidden');

		fileTarget.on('change', function(){  // 값이 변경되면
		if(window.FileReader){  // modern browser
		  var filename = $(this)[0].files[0].name;
		} 
		else {  // old IE
		  var filename = $(this).val().split('/').pop().split('\\').pop();  // 파일명만 추출
		}
		
		// 추출한 파일명 삽입
		$(this).siblings('.upload-name').val(filename);
	  });
	}


// Tab 갯수에 따른 넓이값 %
	if ($('.detailTab').length > 0){
		var detailTabSize = '';
		var detailTabWidth = '';
		$('.detailTab').each(function() {
			detailTabSize = $(this).children('li').size();
			detailTabWidth = 100 / detailTabSize;
			$(this).children('li').width(detailTabWidth+'%');
		});
	}

// login height mid
	var midHeight = '';
	var sHeight = $(window).height();
	var loginWrapHeight = $('.loginWrap').height();
	midHeight = (sHeight - loginWrapHeight) / 2;
	$('.loginWrap').css('padding-top', midHeight);

    $(window).resize(function(){
		var midHeight2 = '';
		var sHeight2 = $(window).height();
		var loginWrapHeight2 = $('.loginWrap').height();
		midHeight2 = (sHeight2 - loginWrapHeight2) / 2;
		$('.loginWrap').css('padding-top', midHeight2);
    });

	
// admin header 2depth
	$('.mainLnb .dropdown').each(function() {
		var thisWidth = $(this).width();
		var thisChildWidth = $(this).find('.dropdown-content').width();

		var thisWidthHalf = thisWidth /2;
		var thisChildWidthHarf = thisChildWidth /2;
		$(this).find('.dropdown-content').css('left', thisWidthHalf).css('margin-left', -thisChildWidthHarf);

		
	});



// admin 사용이력 조회 | 상세
	$('#btnAdmPlus').click(function() {
		$('.layerp').hide();
		$('.layerp1').show();
	});
	$('#btnAdmMinus').click(function() {
		$('.layerp').hide();
		$('.layerp2').show();
	});
	/* 2016-12-12 추가 */
	$('.closeBtn').click(function() {
		$('.layerp').hide();
	});
	/* 2016-12-12 추가 // */




});