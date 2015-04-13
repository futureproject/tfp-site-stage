$(document).on('click', '.job-listing', function(event) {
  event.preventDefault()
  $t = $(this)
  $('.grid-info-box').addClass('hiding').slideUp()
  if ($t.hasClass('active')) {
    $t.removeClass('active')
    return
  }
  $markup = $t.find('.job-details').html()
  selector = '.job-listing:nth-of-type(4n)'
  $t.addClass('active').siblings().removeClass('active')
  if ($t.is(selector)) {
    $target = $t
  } else {
    $target = $t.nextAll(selector).first() || $t.nextAll().last()
  }
  $info = $("<div class='grid-info-box active' />").append($markup)
  $target.after($info)
  $info.hide().slideDown()
})

