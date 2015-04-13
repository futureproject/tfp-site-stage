window.checkInstagram = () ->
  $content = $('#instagram_content').empty()
  instagram = $.getJSON 'https://api.instagram.com/v1/users/363848267/media/recent/?client_id=eb730dfe68f24c80a1d0294297939f7e&callback=?', (res) ->
    for image in res.data
      $content.append "<img src='#{image.images.standard_resolution.url}' />"

window.checkFacebook = () ->
  $content = $('#facebook_content').empty()
  $.getJSON 'https://graph.facebook.com/v2.0/tfpinspire/feed?access_token=132042490309344|d2b91ac7d0167419f3c68fdb1dea9e6b&callback=?', (res) ->
    for post in res.data
      if post.message?
        $content.append "<p>#{post.message}</p>"

window.updateContent = () ->
  checkInstagram()
  checkFacebook()

$ ->
  #updateContent()
  #setInterval(updateContent, 30000)

