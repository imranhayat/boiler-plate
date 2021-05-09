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
//= require bootstrap-sprockets
//= require_self

$(document).on('turbolinks:load',function(){
  "use strict";

  if(window.matchMedia("(max-width: 991.98px)").matches){
    $('.devise-bg').remove();
  }

  // Bootstrap Custom File Input
  bsCustomFileInput.init();
  
  // Add active class to Header links
  var path = window.location.href; // because the 'href' property of the DOM element is the absolute path
  $("a.nav-link").each(function() {
    if (this.href === path) {
      $(this).addClass("active");
      $(this).closest('.sidebar-collapse').addClass("show");
      $(this).closest('.sidebar-collapse').prev('.nav-link').addClass('active').removeClass("collapsed");
    }
  });

  $('[type="password"]').closest('.form-group').addClass('password_show');
  $('.password_show').append('<i class="fas fa-eye"></i>');
})

// Password Show/Hide
$(document).on('click','.password_show .fas', function(){
  var password_field =  $(this).closest('.password_show').find('input');
  if($(this).hasClass('fa-eye')){
    password_field.attr('type','text');
    $(this).removeClass('fa-eye').addClass('fa-eye-slash');
  }
  else{
    password_field.attr('type','password');
    $(this).removeClass('fa-eye-slash').addClass('fa-eye');
  }
});