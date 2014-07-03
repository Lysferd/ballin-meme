# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.field[data-form-id]').each ->
    element = $(@)
    $('#user_' + element.data('form-id')).on 'focus blur mouseover mouseout', (e) -> paintIt e, $(@), element

paintIt = (e, form_element, tip_element) ->
  e.preventDefault
  if e.type == "focus" or e.type == "mouseover"
    backgroundColor = "#655ccd"
  else if e.type == "blur" or e.type == "mouseout" and not form_element.is(":focus")
    backgroundColor = "#0F0A4A"
  tip_element.css 'backgroundColor', backgroundColor