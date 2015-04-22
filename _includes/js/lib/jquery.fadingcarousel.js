(function($){
  $.fn.carousel = function(){
    return this.each(function(){
      var self = this
      self.index = 0
      self.slides = self.querySelectorAll('.carousel-slide')
      self.nav = self.querySelectorAll('.carousel-nav-item')
      self.next = function(){
        self.index = self.index < self.slides.length-1 ? self.index + 1 : 0
        self.go(self.index)
      }
      self.go = function(index) {
        $(self.slides[index]).addClass('active').siblings().removeClass('active')
        $(self.nav[index]).addClass('active').siblings().removeClass('active')
      }
      self.start = function(){
        self.timer = window.setInterval(function(){ self.next.call(self) }, 3000)
      }
      self.pause = function(){
        window.clearInterval(self.timer)
      }
      $(self).on('click', '.carousel-nav-item', function(event){
        event.preventDefault()
        self.pause()
        self.go($(this).prevAll().length)
      })
      self.start()
      self
    })
  }
}(jQuery));
