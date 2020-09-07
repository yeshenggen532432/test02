(function ($) {
  var defaults = {
    dire: 12,
    w: 250,
    _x: 0,
    _y: 0,
    borderColor: '#FFBB76',
    bgColor: '#FFFCEF',
    color: '#FF0000',
    padding: [5, 10],
    arrWidth: 10,
    useHover: true,
    zIndex: 100000
  };
  $.fn.tips = function (opt) {
    var tip, opts = $.extend({}, defaults, opt);
    if (this[0]) {
      opts.tag = this;
      if (opts.useHover) {
        opts.tag.hover(function () {
          tip = new Tip(opts);
          tip.show();
        }, function () {
          tip.close();
        });
      } else {
        tip = new Tip(opts);
        tip.show();
      }
      return this;
    }
  };
  function Tip(opts) {
    this.dire = opts.dire;
    this.width = opts.w;
    this.zIndex = opts.zIndex;
    this.borderColor = opts.borderColor;
    this.bgColor = opts.bgColor;
    this.color = opts.color;
    this.padding = opts.padding;
    this.arrWidth = opts.arrWidth;
    this.offsetX = opts._x;
    this.offsetY = opts._y;
    this.tag = opts.tag;
    this.msg = opts.msg;
    this.wrap = $('<div class="tip-wrap"></div>');
    this.innerArr = $('<div class="tip-arr-a"></div>');
    this.outerArr = $('<div class="tip-arr-b"></div>');
    this.init();
  };
  Tip.prototype = {
    init: function () {
      var msg = this.tag.data('tipMsg');
      if (!this.msg) {
        this.msg = msg;
      }
      this.createTemp();
    },
    createTemp: function () {
      var t = this;
      t.createWrap();
      t.setPosition();
    },
    createWrap: function () {
      var t = this;
      t.wrap.html(t.msg);
      var wrapCSS = {
        width: t.width,
        border: '1px solid ' + t.borderColor,
        'border-radius': '5px',
        background: t.bgColor,
        color: t.color,
        padding: t.getPadding()
      };
      t.outerArr.css(t.getArrStyle(t.dire, t.arrWidth, t.borderColor));
      t.innerArr.css(t.getArrStyle(t.dire, t.arrWidth, t.bgColor));
      t.wrap.prepend(t.innerArr).prepend(t.outerArr).css(wrapCSS);
      $('body').append(t.wrap);
    },
    setPosition: function () {
      var t = this;
      var posObj = t.getPos(t.dire, t.getPosition(t.tag), t.getPosition(t.wrap), t.arrWidth), pos = posObj.pos, innerPos = posObj.innerPos, outerPos = posObj.outerPos;
      t.wrap.css({top: pos.y, left: pos.x});
      t.innerArr.css({top: innerPos.y, left: innerPos.x});
      t.outerArr.css({top: outerPos.y, left: outerPos.x});
    },
    getPadding: function () {
      var t = this, pad = '0px', padArr = t.padding, len = padArr.length;
      switch (len) {
        case 1:
          pad = padArr[0] + 'px';
          break;
        case 2:
          pad = padArr[0] + 'px ' + padArr[1] + 'px';
          break;
        case 3:
          pad = padArr[0] + 'px ' + padArr[1] + 'px ' + padArr[2] + 'px';
          break;
        case 4:
          pad = padArr[0] + 'px ' + padArr[1] + 'px ' + padArr[2] + 'px ' + padArr[3] + 'px';
          break;
      }
      return pad;
    },
    getPosition: function (tag) {
      return {t: tag.offset().top, l: tag.offset().left, h: tag.outerHeight(), w: tag.outerWidth()};
    },
    getArrStyle: function (dir, width, color) {
      var style;
      switch (dir) {
        case 11:
        case 12:
        case 1:
          style = {
            'border-bottom-style': 'solid',
            'border-width': '0px ' + width + 'px ' + width + 'px',
            'border-bottom-color': color
          };
          break;
        case 2:
        case 3:
        case 4:
          style = {
            'border-left-style': 'solid',
            'border-width': width + 'px 0px ' + width + 'px ' + width + 'px',
            'border-left-color': color
          };
          break;
        case 5:
        case 6:
        case 7:
          style = {
            'border-top-style': 'solid',
            'border-width': width + 'px ' + width + 'px 0px',
            'border-top-color': color
          };
          break;
        case 8:
        case 9:
        case 10:
          style = {
            'border-right-style': 'solid',
            'border-width': width + 'px ' + width + 'px ' + width + 'px 0px',
            'border-right-color': color
          };
          break;
      }
      return style || {};
    },
    getPos: function (d, tagPos, pos, arrWidth) {
      var _pos, _innerPos, _outerPos, l = tagPos.l, t = tagPos.t, w = tagPos.w, h = tagPos.h, ww = pos.w, hh = pos.h;
      switch (d) {
        case 0:
        case 1:
          _pos = {x: l + w / 2 + arrWidth + 20 + 1 - ww, y: t + h + arrWidth};
          _outerPos = {x: ww - 2 - 20 - arrWidth * 2, y: -arrWidth};
          _innerPos = {x: ww - 2 - 20 - arrWidth * 2, y: -arrWidth + 1};
          break;
        case 2:
          _pos = {x: l - ww - arrWidth, y: t + h / 2 - arrWidth - 20 - 1};
          _outerPos = {x: ww - 2, y: 20};
          _innerPos = {x: ww - 2 - 1, y: 20};
          break;
        case 3:
          _pos = {x: l - ww - arrWidth, y: t + h / 2 - hh / 2};
          _outerPos = {x: ww - 2, y: (hh - 2) / 2 - arrWidth};
          _innerPos = {x: ww - 2 - 1, y: (hh - 2) / 2 - arrWidth};
          break;
        case 4:
          _pos = {x: l - ww - arrWidth, y: t + h / 2 + arrWidth + 20 + 1 - hh};
          _outerPos = {x: ww - 2, y: hh - 2 - 20 - arrWidth * 2};
          _innerPos = {x: ww - 2 - 1, y: hh - 2 - 20 - arrWidth * 2};
          break;
        case 5:
          _pos = {x: l + w / 2 + arrWidth + 20 + 1 - ww, y: t - arrWidth - hh};
          _outerPos = {x: ww - 2 - 20 - arrWidth * 2, y: hh - 2};
          _innerPos = {x: ww - 2 - 20 - arrWidth * 2, y: hh - 2 - 1};
          break;
        case 6:
          _pos = {x: l + w / 2 - ww / 2, y: t - arrWidth - hh};
          _outerPos = {x: (ww - 2) / 2 - arrWidth, y: hh - 2};
          _innerPos = {x: (ww - 2) / 2 - arrWidth, y: hh - 2 - 1};
          break;
        case 7:
          _pos = {x: l + w / 2 - 20 - arrWidth, y: t - arrWidth - hh};
          _outerPos = {x: 20, y: hh - 2};
          _innerPos = {x: 20, y: hh - 2 - 1};
          break;
        case 8:
          _pos = {x: l + w + arrWidth, y: t + h / 2 + arrWidth + 20 + 1 - hh};
          _outerPos = {x: -arrWidth, y: hh - 2 - 20 - arrWidth * 2};
          _innerPos = {x: -arrWidth + 1, y: hh - 2 - 20 - arrWidth * 2};
          break;
        case 9:
          _pos = {x: l + w + arrWidth, y: t + h / 2 - hh / 2};
          _outerPos = {x: -arrWidth, y: (hh - 2) / 2 - arrWidth};
          _innerPos = {x: -arrWidth + 1, y: (hh - 2) / 2 - arrWidth};
          break;
        case 10:
          _pos = {x: l + w + arrWidth, y: t + h / 2 - arrWidth - 20 - 1};
          _outerPos = {x: -arrWidth, y: 20};
          _innerPos = {x: -arrWidth + 1, y: 20};
          break;
        case 11:
          _pos = {x: l + w / 2 - 20 - arrWidth, y: t + h + arrWidth};
          _outerPos = {x: 20, y: -arrWidth};
          _innerPos = {x: 20, y: -arrWidth + 1};
          break;
        case 12:
          _pos = {x: l + w / 2 - ww / 2, y: t + h + arrWidth};
          _outerPos = {x: (ww - 2) / 2 - arrWidth, y: -arrWidth};
          _innerPos = {x: (ww - 2) / 2 - arrWidth, y: -arrWidth + 1};
          break;
        default:
          _pos = {x: 0, y: 0};
      }
      return {
        pos: _pos,
        innerPos: _innerPos,
        outerPos: _outerPos
      };
    },
    show: function () {
      this.wrap.show();
    },
    close: function () {
      this.wrap.remove();
    }
  };
})(jQuery);