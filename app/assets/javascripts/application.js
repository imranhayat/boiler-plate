// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require popper
//= require bootstrap
//= require_self

$(document).on('turbolinks:load',function(){
  "use strict";

  // Bootstrap Custom File Input
  bsCustomFileInput.init();
  
  // Add active state to sidbar nav links
  var path = window.location.href; // because the 'href' property of the DOM element is the absolute path
  $("a.nav-link").each(function() {
    if (this.href === path) {
      $(this).addClass("active");
      $(this).closest('.sidebar-collapse').addClass("show");
      $(this).closest('.sidebar-collapse').prev('.nav-link').addClass('active').removeClass("collapsed");
    }
  });

  $('[name="plan[interval]"]').on('change',function(){
    var t = $(this);
    var i_count = $('.i_count')
    if(t.val() == "year"){
      i_count.addClass("d-none");
    }
    else{
      i_count.removeClass("d-none");
    }
  })
})

function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function(e) {
      $('#imagePreview').prop('src', e.target.result);
      $('#imagePreview').hide();
      $('#imagePreview').fadeIn(650);
    }
    reader.readAsDataURL(input.files[0]);
  }
}
$(document).on('change','#imageUpload',function() {
  readURL(this);
});