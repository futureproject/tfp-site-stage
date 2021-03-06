$(document).on('click', '.grid .expandable', function(event) {
  event.preventDefault()
  $t = $(this)
  vimeo_id = this.getAttribute('data-vimeo-id')
  if (!!vimeo_id) {
    $markup = $("<iframe src='//player.vimeo.com/video/" + vimeo_id + "?autoplay=1'></iframe>")
  } else {
    $markup = $t.find('.expandable-content').html()
  }
  $('.grid-info-box').slideUp(function(){
    $(this).remove()
  })
  if ($t.hasClass('active')) {
    $t.removeClass('active')
    return
  }
  selector = $t.hasClass('grid-thirds') ? '.expandable:nth-of-type(3n)' : '.expandable:nth-of-type(4n)'
  $t.addClass('active').siblings().removeClass('active')
  if ($t.is(selector) || $t.nextAll('.expandable').length == 0) {
    $target = $t
  } else if ($t.nextAll(selector).length > 0) {
    $target = $t.nextAll(selector).first()
  } else {
    $target = $t.nextAll().last()
  }
  $info = $("<div class='grid-info-box active' />").append($markup)
  $target.after($info)
  $info.hide().slideDown()
})

