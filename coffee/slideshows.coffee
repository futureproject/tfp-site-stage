window.tfp ||= {}
$ ->
  $('.swipe').each () ->
    $t = $(this)
    s = Swipe this,
      auto: $t.attr('data-auto')
      callback: (pos) ->
        $bullets = $t.find '.swipe_bullet'
        $bullets.each -> this.classList.remove 'is_active'
        try
          $bullets.get(pos).classList.add 'is_active'
        catch error
          return
    $footer = $t.find('footer')
    $bullets = $('<ul class="swipe_bullets" />').appendTo $footer
    i = 0
    while i < s.getNumSlides()
      $bullet = $("<li class='swipe_bullet' />").attr('data-slide', i).on('click', (e) ->
        s.slide this.getAttribute('data-slide')
      ).appendTo($bullets)
      $bullet.addClass('is_active') if i == 0
      i += 1
    $footer.append $bullets
    if $t.attr('data-oneclick')?
      $t.on 'click', (e) ->
        s.next()
    $(document).on('slideshows:pause', -> s.stop())
