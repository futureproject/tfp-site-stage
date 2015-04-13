window.tfp ||= {}
$ ->

# animate scrolling for same-page anchor links
  $(document).on('click', '*[data-toggle]', (e) ->
    e.preventDefault()
    $(this.getAttribute('data-toggle')).slideToggle()
  ).on('click.scrolling', 'a', (e) ->
    try
      href = this.href
      hash = this.getAttribute('href')
      target = document.querySelector(hash)
      if hash.indexOf('#') == -1
        true
      else if target?
        e.preventDefault()
        position = $(target).offset().top
        $('html, body').animate
          scrollTop: position
        , () ->
          location.hash = hash
    catch error
      true
  )

# hack step 2 of the dream director application page
  $('#offline_emphasis_trigger').on('click', (e) ->
    $('#offline_emphasis').append('.')
  )

# spice up the hopsie donation form
  $('#hopsie_donation_form').on('click', 'input[type=checkbox]', (e) ->
    $form = $(this).closest('form')
    $form.find('input[type=checkbox]').not(this).each ->
      this.checked = false
    $form.find('input[name=recurring]').val(this.checked)
  )

