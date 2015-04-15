$(document).pjax('.people .inline-nav-item', '#people', {
  fragment: '#people'
}).on('pjax:click', function(event) {
  $(event.target).addClass('active').siblings().removeClass('active')
}).on('pjax:send', function(){
  $('#people').prepend("<div class='loading'></div>")
}).on('pjax:end', function(event) {
  $('.loading').remove()
})
