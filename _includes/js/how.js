$.fn.closeScrollingSlide = function(){
  return this.each(function(){
    $t = $(this)
    $t.removeClass('active')
  })
}
$.fn.openScrollingSlide = function(){
  return this.each(function(){
    $('body').removeClass('bg-step-1 bg-step-2 bg-step-3').addClass('scrolling-slideshow bg-step-' + this.getAttribute('data-step'))
    $t = $(this)
    $t.addClass('active')
    $t.siblings('.scrolling-slide').closeScrollingSlide()
  })
}
if (!Modernizr.touch) {
  $('.scrolling-slide').waypoint({
    handler: function(direction) {
      $target = direction == 'down' ? $(this.element) : $(this.element).prev()
      $target.openScrollingSlide()
    },
    offset: '50%'
  })
  $('#scrolling-instructions').each(function(){
    self = $(this)
    $(window).one('scroll', function(event) {
      self.addClass('animated fadeOutUp')
    })
  })
}
