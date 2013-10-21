$(function(){
  var ajax = {
    request: function(obj, data){
      url = $(obj).attr("action");
      $.post(url, data)
    }
  }

  $("#search_area").hide();

  $("body").on("submit","form#new_anagram_dictionary", function(e){
    var file = new FormData($(this)[0]);

    ajax.request(this, file);
    e.preventDefault();
  });

  $("body").on("submit","form#search_anagrams_for", function(e){
    $.ajax({
      url: window.location.pathname,
      type: 'POST',
      data: text_field,
      cache: false,
      contentType: 'app/json',
      processData: false,
      success: function(data) {
        alert(data);
      }
    });

    e.preventDefault();
  });

});
