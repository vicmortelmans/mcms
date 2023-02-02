$(window).load(function() {
  $('.pictureportrait').each(function(idx,img) {
    if ($(img).width() > $(img).height()) {
      $(img).removeClass('pictureportrait');
      $(img).addClass('picturelandscape');
    }  
  });
});

