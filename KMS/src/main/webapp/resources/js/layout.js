/*
 * checkbox, radio ����
 */
function checkboxAndRadioSetting(){
	var types = ['radio', 'check'];

	for (var i=0, len=types.length; i < len; i++){
		$('.inp-'+ types[i] +' input[type='+ (types[i] == 'check' ? 'checkbox' : 'radio') +']').each( function(){
			var $this  = $( this );
			var $label = $this.next( 'label' );

			// ������ combo �߰�
			if ( $label.has('.box').length == 0 ){
				$label.prepend( '<span class="box"></span>' );
			}

			// disabled �ƴҰ�쿡�� ����
			if ( !$this.attr('disabled') ){
				$label.toggleClass('on', $this.is(":checked") ); // ���۽� üũ�Ǿ� ������ üũ

				$this.on( 'click', function(){
					var $this = $( this );
					var type  = $this.attr('type');
					var name  = $this.attr('name');

					// type="radio" �϶��� ���� radio off ǥ��
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
 * placeholder ����(textarea ����)
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

			// ��Ŀ����, �ʱ� ����� �Է� ������ ������ ���� ����� ǥ�õ� class ����
			$this.on('focus', function( e ){
				if ( $this.val() == initTxt ){
					$this.removeClass('placeholder');
					$this.val( '' );
				}
			});

			// ��Ŀ�� �ƿ���, �ƹ� �Է� ���� ������ �ʱ� ����� class�� ǥ��
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
 * ��õ ����Ʈ ��ǰ Tab - Sorting
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

	/* icon �ڵ� �Է� */
	$('.goods-list li').each(function() {
		var iconStay = $(this).find('.blockn').text();
		if (iconStay == 'ȣ��'){$(this).find('.blockn').addClass('block-pink');}
		if (iconStay == '����Ʈ'){$(this).find('.blockn').addClass('block-orange');}
		if (iconStay == '���'){$(this).find('.blockn').addClass('block-blue');}
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




	
	
	
	
	/* select script ������ ���� */
	if ($('select').length > 0){
		try {$("body select").msDropDown();}
		catch(e) {}
	}



	/* ��ǰ ����Ʈ ������ ������ ���� */
	$('.thumbmail a:nth-child(4n)').css('margin-right', 0);
	$('.travelList li:nth-child(4n)').css('margin-right', 0);
	$('.reserveListGo li:nth-child(2n)').css('margin-right', 0);
	

	
	/* ��ǰ �� Tab */
	$('.detailTab>li').click(function() {
		var dTabNum = $(this).index();
		$(this).parent('.detailTab').children('li').removeClass('on');
		$(this).addClass('on');

		$(this).parent('.detailTab').next('.detailTabConents').children('li').hide().removeClass('hide');
		$(this).parent('.detailTab').next('.detailTabConents').children('li:eq('+dTabNum+')').show();;

	});

	
	
	/* ��ǰ �� Ķ���� ��ư on */
	$('.calendar .possible button').click(function() {
		$('.calendar .possible button').removeClass('on');
		$(this).addClass('on');
	});




	/* ��ǰ�� �� ��ǰ�� ���� �ݱ� */
	$('.ellipsis').each(function() {	/* ��ǰ���� ���� ������ ���� ��� */
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




	/* ��ǰ�� - �����ϱ� ����Ʈ ����/�ݱ� */
	$('.reservateBtn').click(function() {
		
		if ($(this).parents('tr').next('.reservation').hasClass('hide')){
			$('.tableComm .reservation').addClass('hide');
			$(this).parents('tr').next('.reservation').removeClass('hide');
		} else {
			$(this).parents('tr').next('.reservation').addClass('hide');
		}
		offsetLoad();
	});




	/* ��ǰ�� - ��õ����� �� ���� ���� �ʰ��϶� ������ */
	$('.travelList li .tit').each(function() {
		if ($(this).height() > 40) {
			$(this).addClass('on');
		}
	});


	/* ��ǰ�� - �޷� 6��(������) �϶� */
//	var tableWeekNum = $('.tableCalendar tbody tr').size();
//	if (tableWeekNum == 6){
//		$('.tableCalendar').addClass('sixWeek');
//	}



	/* ���������� - ���� */
	$('.tooltip').mouseenter(function() { $(this).addClass('on'); });
	$('.tooltip').mouseout(function() {	$(this).removeClass('on'); });


	// faq
	$('.btn-toggle').click(function(){
		$(this).parent().parent().parent().toggleClass('on');
	});


/* ȸ������ - �α��� */
	
	if ($('#loginSlider').length > 0){
		var banlistNum2 = $('.loginSlider>li').size();

		/* �α��������� - ��� 1���϶� �Ѹ� ���� */
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
	



	/* ����� ����Ұ� ������ border�� */
	$('.loginMemberService li:last-child').css('border', 0);



/* �ؿܿ������� - ������ */
	
	$('#banC li:nth-child(4n), #banD li:nth-child(4n)').addClass('pr0');
	$('#banC li:gt(3), #banD li:gt(3)').addClass('pt20');

	$('.dd').next('.btn').css('margin-left', 1);
	$('.dd').next('.gab').css('margin-left', -2);


/* ȸ������ - ������� table border�� ���� */

	$('.docText table').attr('border', 0);
	$('.docText table th:last-child, .docText table td:last-child').css('border-right', 0);
	


/* �������� ���� (ī��/�������Ա�) */
	
	$( '#kind-pay' ).on( 'click', function() {
		$('.ticketBank').removeClass('hide');
		$('.ticketCard, .cardInfo').addClass('hide');
	});
	$( '#kind-credit' ).on( 'click', function() {
		$('.ticketCard, .cardInfo').removeClass('hide');
		$('.ticketBank').addClass('hide');
	});

	
/* �������� ���� (ī��/�������Ա�) - select box list ���̰� ���� �ذ� */	
	var inMoney = $('#select-inMoney').parents('.cnt').find('li').size();
	$('#select-inMoney').parents('.cnt').find('.ddChild').height(inMoney * 35);
	var inbank = $('#select-bank').parents('.cnt').find('li').size();
	$('#select-bank').parents('.cnt').find('.ddChild').height(inbank * 35);
	


// file ÷�� �� ���ϼӼ� icon �ڵ� ����
	if ($('.file').length > 0){
		$('.file a').each(function() {
			if ($(this).text().toLowerCase().lastIndexOf( '.doc' ) > -1 ){$(this).addClass('doc');}
			else if ($(this).text().toLowerCase().lastIndexOf( '.xls' ) > -1){$(this).addClass('xls');}
			else if ($(this).text().toLowerCase().lastIndexOf( '.png' ) > -1){$(this).addClass('png');}
			else if ($(this).text().toLowerCase().lastIndexOf( '.jpg' ) > -1){$(this).addClass('jpg');}
			else if ($(this).text().toLowerCase().lastIndexOf( '.gif' ) > -1){$(this).addClass('gif');}
			else if ($(this).text().toLowerCase().lastIndexOf( '.zip' ) > -1){$(this).addClass('zip');}
			else if ($(this).text().toLowerCase().lastIndexOf( '.pdf' ) > -1){$(this).addClass('pdf');}
			else if ($(this).text().toLowerCase().lastIndexOf( '.htm' ) > -1){$(this).addClass('html');}
			else if ($(this).text().toLowerCase().lastIndexOf( '.ppt' ) > -1){$(this).addClass('ppt');}
			else {$(this).addClass('etc');}
		});
	}


// input type="file" �����κ���
	if ($('.filebox').length > 0){
		var fileTarget = $('.filebox .upload-hidden');

		fileTarget.on('change', function(){  // ���� ����Ǹ�
		if(window.FileReader){  // modern browser
		  var filename = $(this)[0].files[0].name;
		} 
		else {  // old IE
		  var filename = $(this).val().split('/').pop().split('\\').pop();  // ���ϸ� ����
		}
		
		// ������ ���ϸ� ����
		$(this).siblings('.upload-name').val(filename);
	  });
	}


// Tab ������ ���� ���̰� %
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


});