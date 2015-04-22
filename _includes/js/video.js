$(document).on('click', 'a[rel=vimeo]', function(event) {
  event.preventDefault()
  $container = $(this).closest('.vimeo-container')
  iframe = document.createElement('iframe')
  iframe.src = this.href
  $container.html(iframe)
})
