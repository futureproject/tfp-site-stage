window.tfp ||= {}
$ ->
  $(".videobox").each ->
    $t = $(this)
    $player = $t.find 'iframe'
    $caption = $t.find('.video_caption')
    $videos = $('a[target]')
    $videos.on('click', (e) ->
      $(this).addClass('is_active').siblings().removeClass('is_active')
      $player.attr('src', this.href)
      caption = this.getAttribute 'data-caption'
      if caption?
        $caption.text(caption)
      else
        $caption.html('&nbsp;')
    )
    $videos.first().click()

  if !Modernizr.touch && !!Modernizr.video.h264
    $("#homepage-feature").append '
      <video autoplay loop>
        <source src="http://s3.amazonaws.com/tfp-website-stage/homepage.mov" type="video/mp4">
      </video>
    '
  $('.very-large-video-toggle').on('click', (e) ->
    e.preventDefault()
    $t = $(this)
    vimeo_id = $t.attr('href').split('/').pop()
    $(document).trigger('slideshows:pause')
    $t.closest('.feature').html("
      <iframe src='//player.vimeo.com/video/#{vimeo_id}?autoplay=1' frameborder=0 webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
    ")
  )

