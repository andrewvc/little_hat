$(document).ready(function() {
  // Cached selectors
  var fullPhotoCont = $('#full-photo-cont');
  var fullPhotoTitle = $('#full-photo-title');

  var mode = null;

  // Load the embedded photo data in the HTML
  var galleryPhotos = window.galleryPhotos;
  var galleryPhotosById = {};
  $.each(galleryPhotos, function(i,p) {
    galleryPhotosById[p.cssId] = p;
  });
  
  //If we're in photo view mode
  if (window.location.hash) {
    /* Remove view/ (6 chars) from the hash to get actual ID */
    viewPhoto(window.location.hash.substr(6));
  }
  //Otherwise show the regular home
  else {
    //Fade in the thumbnails
    var imagesToFade = $("#photo-thumbs img");
    imagesToFade.hide();
    fadeImagesOnLoad(imagesToFade);
  }

  // Bind to thumbnails click to dynamically show image
  $('a[rel=gal]').click(function(e) {
    e.preventDefault();
    viewPhoto(e.currentTarget.id);
  });

  // Bind the go home button
  $('#go-home').click(function(e){
    e.preventDefault();
    defaultMode();
  });

  //Fades in all the photo thumbs after they're loaded
  function fadeImagesOnLoad(imagesToFade) {
    //Fade in loaded images
    imagesToFade.each(function(i,img) {
      var img = $(img);
      img.load(function() {
        img.fadeIn(Math.random() * 2000 + 600);
      });
    });
  }

  function photoViewMode() {
    if (!(mode == 'photoView')) {
      $('body').addClass('photo-view');
      $('#return-home').show();
      mode = 'photoView';

      $('#about').fadeTo(200,0);
      $('#about, #main-graphic img').animate(
        { margin: '-320px 0px 0px 72px'},500);
      $('#photo-thumbs').animate(
        { left: '40px', top: '175px'},500);
      $('#blog').fadeOut();
      $('#photo-thumbs h2').hide();
    }
  }

  function defaultMode() {
    if(mode == 'photoView') {
      $('#photo-thumbs h2').show();
      $('#blog').fadeIn();
      $('body').removeClass('photo-view');
      $('#return-home').fadeOut(500);
          
      fullPhotoCont.fadeOut(500);
      $('#photo-thumbs').animate(
        { left: '365px', top: '70px'});
      $('.photo-frame a').removeClass('selected').fadeTo(500,1);
      $('#about, #main-graphic img').animate(
        { margin: '0px', opacity: 1}, 500);
    
      window.location.hash = '';
      mode = null;
    }
  }

  /* When you click on a thumb switch to photoViewMode if we aren't
   already there then show the image, creating the dom elements needed to 
   display it if necessary */    
  function viewPhoto(id) {
    photoViewMode();
    var anchor = $('#' + id)[0];
    var photo  = galleryPhotosById[id];
          
    $('.photo-frame a').each(function(i,a) {
      var ja = $(a);
      // Unhighlight non-selected thumbs
      if (anchor !== a) {
        ja.fadeTo(20,0.7);
        ja.removeClass('selected');
      }
      // Highlight the selected thumb
      else {
        ja.addClass('selected');
        ja.fadeTo(100,1);
        
        // Display the full sized image
        var nextPhotoA = $('#next-photo');
        var prevPhotoA = $('#prev-photo');
       
        // Figure out what the next and prev photos will be
        var prevPhoto = null;
        var nextPhoto = null;
        $.each(galleryPhotos,function(i,p) {
          if (p.cssId == a.id) {
            if (i > 0)
              prevPhoto = galleryPhotos[i - 1];
            if ((i + 1) < galleryPhotos.length)
              nextPhoto = galleryPhotos[i + 1];
          }
        });

        // Empty out the display area, and show the image and metadata
        if (prevPhoto) {
          prevPhotoA.unbind('click');
          prevPhotoA.click(function(e) {
            e.preventDefault();
            viewPhoto(prevPhoto.cssId);
          });
          prevPhotoA.show();
        } else {
          prevPhotoA.hide()
        }
        if (nextPhoto) {
          nextPhotoA.unbind('click');
          nextPhotoA.click(function(e) {
            e.preventDefault();
            viewPhoto(nextPhoto.cssId);
          });
          nextPhotoA.show();
        } else {
          nextPhotoA.hide()
        }
        
        fullPhotoTitle.text(anchor.title);
        fullPhotoCont.find('img').remove();
        fullPhotoTitle.hide();
        fullPhotoTitle.fadeIn(1200);

        var img = $('<img src="' + photo.fullUrl + '">');
        img.hide();
        img.hide();
        img.fadeIn(700);
        
        fullPhotoCont.append(img);
        fullPhotoCont.show();

        // Make this URL bookmarkable
        window.location.hash  = "view/" + a.id;
      }
    });
  }
});
