$(document).on('click', 'a[rel=vimeo]', function(event) {
  event.preventDefault()
  $container = $(this).closest('.vimeo-container')
  iframe = document.createElement('iframe')
  iframe.src = this.href
  iframe.className = 'animated zoomIn'
  $container.html(iframe).addClass('video-loaded')
})
