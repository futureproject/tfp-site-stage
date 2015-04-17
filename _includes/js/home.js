$(document).on('click', '.student-video', function(event) {
  event.preventDefault()
  event.stopPropagation()
  $t = $(this)
  $('#fbs-video-ajax-target').load($t.find('a').attr('href'))
  $t.addClass('active').siblings().removeClass('active')
})
$('.student-video').first().trigger('click')
