var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

window.tfp = (window.tfp || {});

tfp.PhotoMover = (function() {
  function PhotoMover() {
    this.end = __bind(this.end, this);
    this.move = __bind(this.move, this);
    this.start = __bind(this.start, this);
  }

  PhotoMover.prototype.start = function(e) {
    var el;
    e.preventDefault();
    el = e.currentTarget;
    this.setTransitionDuration(el, '0');
    this.setTransitionProperty(el, '');
    $(el).on('mousemove.mover', this.move).on('mouseout.mover', this.end).on('mouseup.mover', this.end);
    $(el).on('touchmove.mover', this.move).on('touchend.mover', this.end);
    this.startPos = {
      x: e.screenX || e.originalEvent.pageX,
      y: e.screenY || e.originalEvent.pageY
    };
    return this.xOffset = this.yOffset = 0;
  };

  PhotoMover.prototype.move = function(e) {
    var el, transform;
    e.preventDefault();
    el = e.currentTarget;
    this.currentPos = {
      x: e.screenX || e.originalEvent.pageX,
      y: e.screenY || e.originalEvent.pageY
    };
    this.xOffset = this.currentPos.x - this.startPos.x;
    this.yOffset = this.currentPos.y - this.startPos.y;
    transform = "translate3d(" + this.xOffset + "px, " + this.yOffset + "px, 0)";
    return this.setTransform(el, transform);
  };

  PhotoMover.prototype.end = function(e) {
    var distance, el;
    this.xOffset || (this.xOffset = 0);
    this.yOffset || (this.yOffset = 0);
    el = e.currentTarget;
    distance = Math.sqrt(this.xOffset * this.xOffset + this.yOffset * this.yOffset);
    if (distance > 200) {
      this.next(el);
      this.setTransitionProperty(el, 'transform');
      this.setTransitionDuration(el, '.5s');
      this.setTransform(el, '');
    } else if (distance === 0) {
      this.nextOnClick(el);
    } else {
      this.setTransitionProperty(el, 'transform');
      this.setTransitionDuration(el, '.5s');
      this.setTransform(el, '');
    }
    $(el).off('mousemove.mover').off('mouseout.mover').off('mouseup.mover');
    return $(el).off('touchmove.mover').off('touchend.mover');
  };

  PhotoMover.prototype.next = function(img) {
    $(img).siblings().each(function() {
      var z;
      z = parseInt(this.style.zIndex);
      z += 1;
      return this.style.zIndex = z.toString();
    });
    return img.style.zIndex = '0';
  };

  PhotoMover.prototype.nextOnClick = function(el) {
    var x, y;
    x = [400, -400, 425, -425, 500, -500];
    y = [200, -200, 300, -300, 250, -250];
    x = x[Math.floor(Math.random() * 6)];
    y = y[Math.floor(Math.random() * 6)];
    this.setTransitionProperty(el, 'transform');
    this.setTransitionDuration(el, '.2s');
    this.setTransform(el, "translate3d(" + x + "px, " + y + "px, 0)");
    return setTimeout((function(_this) {
      return function() {
        var transform;
        transform = '';
        _this.setTransform(el, transform);
        return _this.next(el);
      };
    })(this), 200);
  };

  PhotoMover.prototype.setTransitionProperty = function(el, property) {
    el.style['transition-property'] = property;
    el.style['-webkit-transition-property'] = "-webkit-" + property;
    el.style.MozTransitionProperty = "-moz-" + property;
    el.style['-ms-transition-property'] = "-ms-" + property;
    return el.style['-o-transition-property'] = "-o-" + property;
  };

  PhotoMover.prototype.setTransitionDuration = function(el, duration) {
    el.style['transition-duration'] = duration;
    el.style['-webkit-transition-duration'] = duration;
    el.style.MozTransitionDuration = duration;
    el.style['-ms-transition-duration'] = duration;
    return el.style['-o-transition-duration'] = duration;
  };

  PhotoMover.prototype.setTransform = function(el, transform) {
    el.style['transform'] = transform;
    el.style['-webkit-transform'] = transform;
    el.style.MozTransform = transform;
    el.style['-ms-transform'] = transform;
    return el.style['-o-transform'] = transform;
  };

  return PhotoMover;

})();

$(function() {
  var initSlides, mover;
  mover = new tfp.PhotoMover;
  $(document).on('mousedown', '.photo-stack-photos img', mover.start);
  $(document).on('touchstart', '.photo-stack-photos img', mover.start);
  $(document).on('click', '.flip-front', function(e) {
    var vid;
    e.preventDefault();
    vid = $(this).closest('.flip-card').addClass('flipped').find('video').get(0);
    vid.src = vid.getAttribute('src');
    vid.load();
    return vid.play();
  });
  $(document).on('click', '.cities-nav a', function(event) {
    var container, self, url;
    self = this;
    $('.cities-nav li').each(function() {
      if (this.innerHTML === self.parentNode.innerHTML) {
        return this.classList.add('active');
      } else {
        return this.classList.remove('active');
      }
    });
    url = self.getAttribute('data-pjax');
    container = $(self.getAttribute('data-pjax-container'));
    event.preventDefault();
    return container.load(url, function(e) {
      return initSlides();
    });
  });
  initSlides = function() {
    return $('.swipe').each(function() {
      var s;
      s = Swipe(this);
      return $(this).on('click', 'nav', function(e) {
        $('video').each(function() {
          this.pause();
          if (this.currentTime > 0) {
            return this.currentTime = 0;
          }
        });
        $('.flip-card').removeClass('flipped');
        return s.next();
      });
    });
  };
  $('.cities-nav a').first().trigger('click');
  document.addEventListener('play', function(e) {
    return document.querySelector('body').classList.add('video-playing');
  }, true);
  document.addEventListener('pause', function(e) {
    return document.querySelector('body').classList.remove('video-playing');
  }, true);
  return document.addEventListener('ended', function(e) {
    return document.querySelector('body').classList.remove('video-playing');
  }, true);
});

