window.tfp ||= {}
class tfp.PhotoMover

  start: (e) =>
    e.preventDefault()
    el = e.currentTarget
    @setTransitionDuration(el, '0')
    @setTransitionProperty(el, '')
    $(el).on('mousemove.mover', @move).on('mouseout.mover', @end)
      .on('mouseup.mover', @end)
    $(el).on('touchmove.mover', @move).on('touchend.mover', @end)
    @startPos =
      x: e.screenX || e.originalEvent.pageX
      y: e.screenY || e.originalEvent.pageY
    @xOffset = @yOffset = 0

  move: (e) =>
    e.preventDefault()
    el = e.currentTarget
    @currentPos =
      x: e.screenX || e.originalEvent.pageX
      y: e.screenY || e.originalEvent.pageY
    @xOffset = @currentPos.x - @startPos.x
    @yOffset = @currentPos.y - @startPos.y
    transform = "translate3d(#{@xOffset}px, #{@yOffset}px, 0)"
    @setTransform(el, transform)

  end: (e) =>
    @xOffset ||= 0
    @yOffset ||= 0
    el = e.currentTarget
    distance = Math.sqrt(@xOffset*@xOffset + @yOffset*@yOffset)
    if distance > 200
      @next(el)
      @setTransitionProperty(el, 'transform')
      @setTransitionDuration(el, '.5s')
      @setTransform(el, '')
    else if distance == 0
      @nextOnClick(el)
    else
      @setTransitionProperty(el, 'transform')
      @setTransitionDuration(el, '.5s')
      @setTransform(el, '')
    $(el).off('mousemove.mover').off('mouseout.mover').off('mouseup.mover')
    $(el).off('touchmove.mover').off('touchend.mover')


  next: (img) ->
    $(img).siblings().each ->
      z = parseInt(this.style.zIndex)
      z += 1
      this.style.zIndex = z.toString()
    img.style.zIndex = '0'

  nextOnClick: (el) ->
    x = [400, -400, 425, -425, 500, -500]
    y = [200, -200, 300, -300, 250, -250]
    x = x[Math.floor(Math.random()*6)]
    y = y[Math.floor(Math.random()*6)]

    @setTransitionProperty(el, 'transform')
    @setTransitionDuration(el, '.2s')
    @setTransform(el, "translate3d(#{x}px, #{y}px, 0)")

    setTimeout () =>
      transform = ''
      @setTransform(el, transform)
      @next(el)
    , 200

  setTransitionProperty: (el, property) ->
    el.style['transition-property'] = property
    el.style['-webkit-transition-property'] = "-webkit-#{property}"
    el.style.MozTransitionProperty = "-moz-#{property}"
    el.style['-ms-transition-property'] = "-ms-#{property}"
    el.style['-o-transition-property'] = "-o-#{property}"

  setTransitionDuration: (el, duration) ->
    el.style['transition-duration'] = duration
    el.style['-webkit-transition-duration'] = duration
    el.style.MozTransitionDuration  = duration
    el.style['-ms-transition-duration'] = duration
    el.style['-o-transition-duration'] = duration

  setTransform: (el, transform) ->
    el.style['transform'] = transform
    el.style['-webkit-transform'] = transform
    el.style.MozTransform = transform
    el.style['-ms-transform'] = transform
    el.style['-o-transform'] = transform

$ ->
  mover = new tfp.PhotoMover
  $(document).on('mousedown', '.photo-stack-photos img', mover.start)
  $(document).on('touchstart', '.photo-stack-photos img', mover.start)

# card flips
  $(document).on('click', '.flip-front', (e) ->
    e.preventDefault()
    vid = $(this).closest('.flip-card').addClass('flipped').
      find('video').get(0)
    # reset the source - otherwise videos loaded via AJAX don't play in Chrome
    vid.src = vid.getAttribute('src')
    vid.load()
    vid.play()
  )

  # engage the nav!
  $(document).on('click', '.cities-nav a', (event) ->
    self = this
    $('.cities-nav li').each ->
      if this.innerHTML == self.parentNode.innerHTML
        this.classList.add('is-active')
      else
        this.classList.remove('is-active')
    url = self.getAttribute('data-pjax')
    container = $(self.getAttribute('data-pjax-container'))
    event.preventDefault()
    container.load url, (e) ->
      initSlides()
  )
# slides
  initSlides = () ->
    $('.swipe').each () ->
      s = Swipe this
      $(this).on('click', 'nav', (e) ->
        $('video').each () ->
          this.pause()
          this.currentTime = 0 if this.currentTime > 0
        $('.flip-card').removeClass('flipped')
        s.next()
      )
  $('.cities-nav a').first().trigger('click')

# and now, a guest!
  document.addEventListener 'play', (e) ->
    document.querySelector('body').classList.add('video-playing')
  , true
  document.addEventListener 'pause', (e) ->
    document.querySelector('body').classList.remove('video-playing')
  , true
  document.addEventListener 'ended', (e) ->
    document.querySelector('body').classList.remove('video-playing')
  , true
