$(function(){
  $("#show-tags").click(function(){
    $(".tags").slideToggle();

    var text = $(this).text()
    $(this).text(
      text == "Show Tags ↓" ? "Hide Tags ↑" : "Show Tags ↓"
    );
  });
});
