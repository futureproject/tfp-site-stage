window.tfp ||= {}

class tfp.Map
  constructor: (element) ->
    return unless google?.maps? && element?
    @el = element
    @initialize()

  initialize: ->
    self = @
    @setMap()
    @listen()
    google.maps.event.addListenerOnce @google_map, 'idle', (e) ->
      $.event.trigger 'map:initialized', [self.google_map]
    #@addSchools()


  setMap: ->
    @google_map = new google.maps.Map @el, {
      zoom: 4
      center: new google.maps.LatLng(40.6743890, -98)
      mapTypeControlOptions:
        mapTypeIds: []
      mapTypeId: 'tfp'
      panControl: false
    }
    customMapType = new google.maps.StyledMapType([
      {
        stylers: [
          { hue: '#79d1eb' },
          { visibility: 'simplified' },
          { gamma: 0.5 },
          { weight: 0.5 }
        ]
      },
      {
        elementType: 'labels',
        stylers: [
          { visibility: 'off' }
        ]
      },
      {
        featureType: 'water',
        stylers: [
          { color: '#121e29' }
        ]
      }
    ])
    @google_map.mapTypes.set('tfp', customMapType)
    
  listen: ->
    @google_map.addListener 'zoom_changed', @onZoom
    $(document).on('cityEl:clicked', @onCityElClick)
  
  onZoom: (e) =>
    $.event.trigger 'map:zoom_changed', [@google_map.getZoom()]
  
  onCityElClick: (e, marker, zoom) =>
    zoom = zoom || 13
    zoom = parseFloat zoom
    @google_map.setZoom(zoom)
    @google_map.setCenter marker.getPosition()
      
class tfp.City
  constructor: (element) ->
    return unless google?.maps? && element?
    @el = element
    @initialize()
    @show()
    @listen()

  initialize: ->
    @lat = parseFloat(@el.getAttribute 'data-lat')
    @lng = parseFloat(@el.getAttribute 'data-lng')
    @title = @el.getAttribute('data-title')
    @group = @el.getAttribute('data-group')
    @zoom = @el.getAttribute('data-zoom')
    icon_url = switch
      when @group == 'current' then '/assets/map_cluster.png'
      when @group == 'next' then '/assets/map_triangle.png'
      else '/assets/map_square.png'
    @marker = new google.maps.Marker
      position: new google.maps.LatLng(@lat, @lng)
      title: @title
      labelContent: @title
      labelClass: 'map_label'
      icon:
        url: icon_url
        scaledSize: new google.maps.Size(24,24)

  listen: ->
    self = this
    $(document).on('map:initialized', (e, map) ->
      self.map = map
      self.show()
    ).on('map:zoom_changed', (e, zoomLevel) ->
      return unless self.group == 'current'
      if zoomLevel > 10
        self.hide()
      else
        self.show() unless self.showing
    ).on('cities:filter', (e, group) ->
      self.toggle() if self.group == group
    )
    @marker.addListener 'click', (e) =>
      @map.setZoom @map.getZoom() + 2
      @map.setCenter @marker.getPosition()
    
    $(@el).on('click', (e) =>
      e.preventDefault()
      e.stopPropagation()
      $.event.trigger 'cityEl:clicked', [@marker, @zoom])

  toggle: ->
    if @showing then @hide() else @show()
  show: =>
    @showing = true
    @marker.setMap @map

  hide: =>
    @showing = false
    @marker.setMap null
    

class tfp.School
  constructor: (element) ->
    return unless google?.maps? && element?
    @el = element
    @initialize()
    @listen()

  initialize: ->
    @lat = parseFloat(@el.getAttribute 'data-lat')
    @lng = parseFloat(@el.getAttribute 'data-lng')
    @title = @el.getAttribute('data-title')
    @overlay = @el
    @marker = new MarkerWithLabel
      position: new google.maps.LatLng(@lat, @lng)
      title: @title
      overlayElem: @overlay
      labelContent: @title
      labelClass: 'map_label'
      icon:
        url: '/assets/map_arrow.png'
        scaledSize: new google.maps.Size(24,28)

  listen: ->
    self = this
    $(document).on('map:initialized', (e, map) ->
      self.map = map
    ).on('map:zoom_changed', (e, zoomLevel) ->
      if zoomLevel > 10
        self.show() unless self.showing
      else
        self.hide()
    )
    @marker.addListener 'click', ->
      $.event.trigger('schoolClick', this.overlayElem)
  show: ->
    @showing = true
    @marker.setMap @map

  hide: ->
    @showing = false    
    @marker.setMap null

$ ->
  tfp.cities = []
  tfp.schools = []
  $('.map_city').each -> tfp.cities.push new tfp.City(this)
  $('#school_overlays').children().each -> tfp.schools.push new tfp.School(this)
  tfp.map = new tfp.Map(document.getElementById('map_canvas'))
