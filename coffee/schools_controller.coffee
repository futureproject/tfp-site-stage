window.tfp ||= {}
class tfp.SchoolsController
  constructor: ->
    @$el = $("<div class='map_overlay' />").hide().appendTo('body')
    @listen()

  listen: ->
    $(document).on('schoolClick', @onMapClick)

  show: (overlay) ->
    @$school = $(overlay)
    @$el.html(@$school.clone())
    @$el.fadeIn()
    @$el.one('click', '.close_button', @hide)
    @$el.one('click', '.next_button', @next)

  hide: =>
    @$el.fadeOut()

  next: =>
    overlay = @$school.next() || @$school.siblings().get(0)
    overlay = @$school.siblings().get(0) if overlay.length == 0
    @show overlay

  onMapClick: (e, overlay) =>
    @show(overlay)

  start: () ->
    if @$el.is(':visible')
      true
    else if tfp.schools?[0]
      @show tfp.schools[0].overlay
    else
      true

$ ->
  tfp.schoolsController = new tfp.SchoolsController()
  $(document).on('click', '.browse_schools', (e) ->
    e.stopPropagation()
    tfp.schoolsController.start()
  ).on('click', '.map_filter', (e) ->
    $.event.trigger 'cities:filter', [this.getAttribute('data-group')]
    $(this).toggleClass('is_disabled')
  )
