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
//= require bootstrap
//= require popper
//= require_tree .

$(document).on('turbolinks:load',function(){
  "use strict";

  // Add active state to sidbar nav links
  var path = window.location.href; // because the 'href' property of the DOM element is the absolute path
  $("a.nav-link").each(function() {
    if (this.href === path) {
      $(this).addClass("active");
      $(this).closest('.collapse').addClass("show");
      $(this).closest('.collapse').prev().removeClass("collapsed");
    }
  });

  // Toggle the side navigation
  $('#sidebarToggle').on("click", function(e) {
    e.preventDefault();
    $("body").toggleClass("sidenav-toggled");
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

$(document).on('turbolinks:load',function(){
  var table = $('.datatable table').DataTable({
    language: {
      search: "_INPUT_",
      searchPlaceholder: "Search"
    },
    dom:
		"<'row align-items-center mb-2'<'col-12 col-xl-3 text-center text-xl-left mb-2 mb-xl-0'l><'col-12 col-xl-9 text-center text-xl-right'f>>" +
		"<'row'<'col-sm-12'tr>>" +
		"<'row align-items-center mt-2'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
    responsive: true,
      buttons: {
        buttons: [ 'copy', 'csv', 'excel', 'pdf', 'print' ],
        dom: {
          button: {
               className: 'btn btn-outline-primary'
          }
        }
      }
  });

  table.buttons().container()
      .prependTo( '.dataTables_wrapper .col-xl-9:eq(0)' );

  $('.no-datatable table').DataTable({
    dom:
    "<'row'<'col-12'><'col-12'>>" +
    "<'row'<'col-12'tr>>" +
    "<'row'<'col-12'><'col-12'>>",
    responsive: true,
    bSort: false
  });
});

pdfMake.fonts = {
  // download default Roboto font from cdnjs.com
  Roboto: {
    normal: 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.66/fonts/Roboto/Roboto-Regular.ttf',
    bold: 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.66/fonts/Roboto/Roboto-Medium.ttf',
    italics: 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.66/fonts/Roboto/Roboto-Italic.ttf',
    bolditalics: 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.66/fonts/Roboto/Roboto-MediumItalic.ttf'
  },
}