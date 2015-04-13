window.tfp ||= {}
tfp.personBios = []

class tfp.PersonBio
  constructor: (args) ->
    @el = args.el
    @$el = $(args.el)
    @collection = args.collection
    @$box = $("<div class='bio_box' />").hide()
    @$section = @$el.closest('section')
    @listen()

  listen: -> @$el.on('click', @toggle)

  toggle: => if @$box.is ':visible' then @hide() else @show()

  hide: ->
    @$el.removeClass('is_active').siblings().css('margin-top','')
    @$section.css('margin-bottom','')
    @$box.fadeOut 'slow', =>
      @$box.remove()

  hideOthers: ->
    bio.hide() for bio in tfp.personBios

  show: ->
    @hideOthers()
    @setBoxContent()
    @insertBox()
    @$el.addClass('is_active')
    @$box.fadeIn 'fast'
    if Math.abs( $('body').scrollTop() - @$el.offset().top) > 100
      $('html, body').animate
        scrollTop: @$el.offset().top

  setBoxContent: ->
    @$box.html "<div class='bio_box_content'>" + @$el.find('.bio').html() + "</div>"

  insertBox: ->
    @$el.closest('article').append(@$box)
    @$box.css(
      position: 'absolute'
      top: @$el.offset().top + 2 + @$el.height() + 'px'
      left: 0
      right: 0
    )
    $el = @$el
    $box = @$box
    @$section.css('margin-bottom', @$box.height() + 'px')
    @$el.nextAll().each () ->
      $t = $(this)
      return unless $t.offset().top > $el.offset().top
      $t.css('margin-top', $box.height() + 20 + 'px')

$ ->
  $('.person:not([data-hide-bio])').each ->
    tfp.personBios.push new tfp.PersonBio(
      el: this
      collection: tfp.personBios
    )

  $('article.who .filterable').find('.person').each ->
    this.style.display = 'none' unless this.classList.contains 'ny'

  $(window).on 'load', (e) ->
    $('article.who .filterable').isotope
      filter: '.ny'
      layout: 'fitRows'

  $('.filters li').on('click', (e) ->
    bio.hide() for bio in tfp.personBios
    filter = this.getAttribute('data-filter')
    $(this).addClass('is_active').siblings().removeClass('is_active')
    $('.filterable').isotope(
      filter: filter
      layoutMode: 'fitRows'
    ).isotope('bindResize')
  )

