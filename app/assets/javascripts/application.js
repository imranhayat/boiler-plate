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
//= require jquery3
//= require sweetalert
//= require turbolinks
//= require toastr_rails
//= require_tree .

toastr.options = Object.assign({}, toastr.options, {
  "progressBar": true
});

$(document).on('click','.icon-dashboard-mobile', function(){
  $('.dashboard-row').toggleClass('d-none');
});
$(document).on('click','.submenu-link .menu', function(){
  $(this).closest('.submenu-link').find('.sub-menu').slideToggle(300);
  $(this).closest('.submenu-link').toggleClass('open');
});
$(document).on("turbolinks:load", function() {
  $('.submenu-link .sub-menu').hide();
  $('.sub-menu a.active').closest('.submenu-link').addClass('open');
  $('.submenu-link.open .sub-menu').show();
  $('#color-button').bcPicker();
  $(document).on('click','#color-button .bcPicker-color',function(){
    var color = $(this).css('background-color');
      $('.primary-middle-hex').val($.fn.bcPicker.toHex(color));
  })
  $('select').addClass('form-control');
  var table = $('.table-users table').DataTable({
    
    "buttons": ['copy', 'csv', 'excel', 'pdf', 'print']
  });
  table.buttons().container().prependTo('.table-users .col-md-8:eq(0)');
  document.addEventListener("turbolinks:before-cache", function() {
    if (table !== null) {
      table.destroy();
      table = null;
    }
  });
  $('.alert').delay(2000).fadeOut();

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        $('#imagePreview').css('background-image', 'url(' + e.target.result + ')');
        $('#imagePreview').hide();
        $('#imagePreview').fadeIn(650);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }
  $("#imageUpload").change(function() {
    readURL(this);
  });
});
