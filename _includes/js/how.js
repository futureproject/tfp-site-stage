$('.scrolling-slide').waypoint({
  handler: function(direction) {
    $target = direction == 'down' ? $(this.element) : $(this.element).prev()
    $('body').removeClass('slide-step-1 slide-step-2 slide-step-3').addClass('scrolling-slideshow slide-step-' + $target.attr('data-step'))
    $target.addClass('active').siblings().removeClass('active')
  },
  offset: '50%'
})
