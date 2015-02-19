$(function() {
  var $addCommentButton = $('.add-question-comment a');
  var $addCommentForm = $('#question-comment');

  $addCommentButton.on('click', function(e) {
    e.preventDefault();
    $addCommentForm.toggleClass('hidden');
  });
});
