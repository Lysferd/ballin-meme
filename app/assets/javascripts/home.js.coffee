# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#$(window).unload -> $.ajax(url: "home/login")
$(window).load ->
  $.ajax(url: 'rtsp').done (html) -> $('#video_grid').append html
