$(document).ready(function() {
  //If we're in photo view mode
  if (window.location.hash) {
    /* Remove view/ (6 chars) from the hash to get actual ID */
    viewPhotoById(window.location.hash.substr(6));
  }
  //Otherwise show the regular home
  else {
  //Default the book image to a low opacity
    $('#book-images').fadeTo(0,0.2);
      
    //Fade in the thumbnails
    $.imagesToFade = $("#photo-thumbs img");
    $.imagesToFade.hide();
    $.fadeImagesInterval = setInterval("fadeImagesOnLoad()",500);
  }
});

// A simple representation of the photo
function Photo(filename, cssId, title) {
  this.filename = filename;
  this.cssId   = cssId;
  this.title    = title;
}

//Store a full list of images on this page for use elsewhere
function setupPhotoGallery(galleryPhotos) {
  $.galleryPhotos = galleryPhotos;
}

//Fades in all the photo thumbs after they're loaded
function fadeImagesOnLoad() {
  //Fade in loaded images
  $.imagesToFade.each(function(i,img) {
    if (img && img.complete) {
      $(img).fadeIn(Math.random() * 2000 + 600);
      $.imagesToFade.splice(i,1);
    }
  });
      
  //Cancel Interval when we're done
  if ($.imagesToFade.length == 0) {
    clearInterval($.fadeImagesInterval);
  }
}

/*Switch the app mode to the photo view mode(we use $.mode to store state)
  TODO: Make a new method of not hardcoding new positions so we can undo stuff
  for easily. */
function photoViewMode() {
  if (!($.mode == 'photoView')) {
    $('body').addClass('photo-view');
    $('#return-home').show();
    $.mode = 'photoView';

    $('#about').fadeTo(200,0);
    $('#about, #main-graphic img, #book-ad').animate(
      { margin: '-320px 0px 0px 72px'},500);
    $('#book-ad').fadeOut(500);
    $('#photo-thumbs').animate(
      { left: '40px', top: '175px'},500);
    $('#blog').fadeOut();
    $('#photo-thumbs h2').hide();
  }
}

//Switch the mode back to default. Reset the page from photoViewMode
function defaultMode() {
  if($.mode == 'photoView') {
    $('#photo-thumbs h2').show();
    $('#blog').fadeIn();
    $('body').removeClass('photo-view');
    $('#return-home').fadeOut(500);
        
    $('#full-photo-cont').fadeOut(500).remove();
    $('#photo-thumbs').animate(
      { left: '355px', top: '70px'});
    $('.photo-frame a').removeClass('selected').fadeTo(500,1);
    $('#book-ad').show();
    $('#book-images').fadeTo(200,0.2);
    $('#about, #main-graphic img, #book-ad').animate(
      { margin: '0px', opacity: 1}, 500);
  
    window.location.hash = '';
    $.mode = null;
  }
}

function viewPhotoById(id) {
  anchor = $('#' + id)[0];
  viewPhoto(anchor, anchor.href);
}

/*What happens when you click on a thumb. Switch to photoViewMode if we aren't
 already there then show the image, creating the dom elements needed to 
 display it if necessary */    
function viewPhoto(anchor,fullImgUrl) {
  photoViewMode();
  $.selectedAnchor = anchor;
        
  $('.photo-frame a').each(function(i,a) {
    var ja = $(a);
    // Unhighlight non-selected thumbs
    if ($.selectedAnchor !== a) {
      ja.fadeTo(20,0.7);
      ja.removeClass('selected');
    }
    // Highlight the selected thumb
    else {
      ja.addClass('selected');
      ja.fadeTo(100,1);
      
      // Display the full sized image
      var fullPhotoCont = $('#full-photo-cont');
      if (! fullPhotoCont[0]) {
        fullPhotoCont = $('body').append('<div id="full-photo-cont"></div>')
        var fullPhotoCont = $('#full-photo-cont');
      }
     
      // Figure out what the next and prev photos will be
      var prevPhoto = null;
      var nextPhoto = null;
      jQuery.each($.galleryPhotos,function(i,p) {
        if (p.cssId == a.id) {
          if (i > 0)
            prevPhoto = $.galleryPhotos[i - 1];
          if ((i + 1) < $.galleryPhotos.length)
            nextPhoto = $.galleryPhotos[i + 1];
        }
      });

      // Empty out the display area, and show the image and metadata
      fullPhotoCont.empty();
      img = $('<img src="' + fullImgUrl + '">');
      img.hide();
      var photoMeta = '';
      photoMeta += '<div id="photo-meta">';
      photoMeta += '<span id="full-photo-title" style="display:none">' + a.title +  '</span>';
      if (prevPhoto) {
        photoMeta += '<a id="prev-photo" href="view/' + prevPhoto.cssId + '" ';
        photoMeta += 'onclick="viewPhotoById(' + "'" + prevPhoto.cssId + "'); return false" + ';")>&laquo; Prev.</a>';
      }
      if (nextPhoto) {
        photoMeta += '<a id="next-photo" href="view/' + nextPhoto.cssId + '" ';
        photoMeta += 'onclick="viewPhotoById(' + "'" + nextPhoto.cssId + "'); return false" + ';")>Next &raquo;</a>';
      }
      photoMeta += '</div>';

      fullPhotoCont.append(photoMeta);
      fullPhotoCont.append(img);

      img.fadeIn(700);
      $('#full-photo-title').fadeIn(700);
         
      // Make this URL bookmarkable
      window.location.hash  = "view/" + a.id;
    }
  });
}
