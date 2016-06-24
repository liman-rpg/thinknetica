# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit_question').show();

  $('.question .votes_link a').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.question .votes_score').html(response.score)
    if response.status == true
      $('.question .votes_link a.vote_link_up').hide()
      $('.question .votes_link a.vote_link_down').hide()
      $('.question .votes_link a.vote_link_cancel').show()
    else
      $('.question .votes_link a.vote_link_up').show()
      $('.question .votes_link a.vote_link_down').show()
      $('.question .votes_link a.vote_link_cancel').hide()

  PrivatePub.subscribe "/questions", (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions-list').append(JST["templates/question"]({question: question}))

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
