# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  init_question = $('.comments-question')
  id = init_question.data('id')
  PrivatePub.subscribe "/comments", (data, channel) ->
    data = $.parseJSON(data['comment'])
    if data.commentable_type != 'Answer'
      comment = '<li>' + data.body + '</li>'
      path = '.question_' + id
      console.log(path)
      init_question.find(path).append(comment)
      $('textarea#comment_body').val('');
    else
      comment = '<li>' + data.body + '</li>'
      path = '.answer_' + data.commentable_id
      console.log(path)
      $('.answers').find(path).append(comment)
      $('textarea#comment_body').val('');

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
