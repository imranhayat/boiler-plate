/**
 * Basic Color Picker
 * Copyright (c) 2018 Alex Bobkov <lilalex85@gmail.com>
 * Licensed under MIT
 * @author Alexandr Bobkov
 * @version 0.2.1
 */

$(document).ready(function() {
  $('body').on('click', '.bcPicker-picker', function() {
      $.fn.bcPicker.toggleColorPalette($(this))
  });
  $('.bcPicker-palette').on('click', '.bcPicker-color', function() {
      $.fn.bcPicker.pickColor($(this))
  })
});
(function($) {
  var templates = {
      palette: $('<div class="bcPicker-palette"></div>'),
      picker: $(''),
      color: $('<div class="bcPicker-color"></div>')
  };
  $.fn.bcPicker = function(options) {
      return this.each(function() {
          var elem = $(this),
              colorSet = $.extend({}, $.fn.bcPicker.defaults, options),
              defaultColor = $.fn.bcPicker.toHex((elem.val().length > 0) ? elem.val() : colorSet.defaultColor),
              picker = templates.picker.clone(),
              palette = templates.palette.clone(),
              color;
          elem.css('position', 'relative');
          elem.append(picker);
          picker.css('background-color', 'rgba(0,0,0,0)');
          elem.prepend(palette);
          $.each(colorSet.colors, function(i) {
              color = templates.color.clone();
              color.css('background-color', $.fn.bcPicker.toHex(colorSet.colors[i]));
              palette.append(color)
          })
      })
  }
  $.extend(!0, $.fn.bcPicker, {
      toggleColorPalette: function(elem) {
          elem.next().toggle('fast')
      },
      pickColor: function(elem) {
          var pickedColor = elem.css('background-color');
          elem.parent().parent().find('.bcPicker-picker').css('background-color', '#000');
          elem.parent().toggle('fast')
      },
      toHex: function(color) {
          if (color.match(/[0-9A-F]{6}|[0-9A-F]{3}$/i)) {
              return (color.charAt(0) === "#") ? color : ("#" + color)
          } else if (color.match(/^rgb\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$/)) {
              var c = ([parseInt(RegExp.$1, 10), parseInt(RegExp.$2, 10), parseInt(RegExp.$3, 10)]),
                  pad = function(str) {
                      if (str.length < 2) {
                          for (var i = 0, len = 2 - str.length; i < len; i++) {
                              str = '0' + str
                          }
                      }
                      return str
                  };
              if (c.length === 3) {
                  var r = pad(c[0].toString(16)),
                      g = pad(c[1].toString(16)),
                      b = pad(c[2].toString(16));
                  return '#' + r + g + b
              }
          } else {
              return !1
          }
      }
  });
  $.fn.bcPicker.defaults = {
      defaultColor: "",
      colors: ['000000', '8e2c02', '2d2d01', '022d01', '002d5b', '000575', '2c2d8e', '2d2d2d', '750002', 'ff5b04', '757503', '047503', '007575', '000bff', '5b5b8e', '757575', 'ff0004', 'ff8e05', '8fc505', '2d8e5b', '2dc5c5', '2c5cff', '750375', '8e8e8e', 'ff06ff', 'ffc506', 'ffff07', '09ff05', '00ffff', '00c5ff', '8e2c5b', 'ff8ec5', 'ffc58e', 'ffff8e', 'c5ffc5', 'c5ffff', '8ec5ff', 'c58eff', 'ffffff', 'e9f1f9', 'f1f3f6', 'edf3ff', 'e8f6fb', 'e6f9fb', 'f0f6f6', 'eff4f2', 'ecf5e8', 'ebf6ee', 'f5f4e4', 'f7eff7', 'f4f0f6', 'f5f3f5', 'f5f1ee', 'f8edee', 'fcefee', 'ffeeef', 'fff1f5', 'fdf1e7', 'faf0e9', ],
      addColors: [],
  }
})(jQuery)