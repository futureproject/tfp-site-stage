$(document).on('click', '.student-video', function(event) {
  event.preventDefault()
  event.stopPropagation()
  $t = $(this)
  $('#fbs-video-ajax-target').load($t.find('a').attr('href'))
  $t.addClass('active').siblings().removeClass('active')
})
$('.student-video').first().trigger('click')

$('#press-quotes').carousel()
/*
$('#press-quotes').slick({
  slidesToShow: 1,
  slidesToScroll: 1,
  arrows: false,
  autoplay: true,
}).on('afterChange', function(e, slick) {
  console.log(slick)
  $($('#press-quotes-nav').children().get(slick.currentSlide)).addClass('active').siblings().removeClass('active')
})
*/
