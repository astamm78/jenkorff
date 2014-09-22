var scroll = function() {
  target = "#content-top"
  $target = $(target);

  $('html, body').stop().animate({
      'scrollTop': $target.offset().top
  }, 900, 'swing', function () {});
}