# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId')
    $(this).hide();
    $('form#edit-answer-' + answer_id).show()

  $('.answers .votes_link a').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.answers .votes_score').html(response.score)
    if response.status == true
      $('.answers .votes_link a.vote_link_up').hide()
      $('.answers .votes_link a.vote_link_down').hide()
      $('.answers .votes_link a.vote_link_cancel').show()
    else
      $('.answers .votes_link a.vote_link_up').show()
      $('.answers .votes_link a.vote_link_down').show()
      $('.answers .votes_link a.vote_link_cancel').hide()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
