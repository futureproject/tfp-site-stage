$(document).pjax('.team .inline-nav-item', '#people', {
  fragment: '#people',
  timeout: 5000
}).on('pjax:click', function(event) {
  $(event.target).addClass('active').siblings().removeClass('active')
}).on('pjax:send', function(){
  $('#people').prepend("<div class='loading'></div>")
}).on('pjax:end', function(event) {
  $('.loading').remove()
})
