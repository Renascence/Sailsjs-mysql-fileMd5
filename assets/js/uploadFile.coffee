$(document).ready ()->
  $('.banner').unslider({
    autoplay: true,
    infinite: true
    })
  $('#dropdownCtl').click () -> 
    $('#dropdownTarget').slideToggle(300)