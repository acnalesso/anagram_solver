$(function(){

  $("#search_area").hide();
  $('#word').attr('autocomplete','off');

  $.extend({
    ajaxPostRequest: function(url, formData, callBack){
      $.ajax({
        url: url,
        type: "POST",
        data: formData,
        async: false,
        success: callBack,
        contentType: false,
        cache: false,
        processData: false
      });
    },
    ajaxGetRequest: function(url, jsonData, callBack){
      $.ajax({
        url: url,
        type: "POST",
        data: JSON.stringify(jsonData),
        async: false,
        success: callBack,
        contentType: "application/json; charset=utf-8",
        traditional: true,
        cache: false,
        processData: false
      });
    }

  });

  $("body").on("submit","form#new_anagram", function(e){
    var formData = new FormData($(this)[0]);
    var url = $(this).attr("action");

    $.ajaxPostRequest(url, formData, function(data){
      $(".loaded_in").html(data + "ms");
      $("#search_area").fadeIn();
      $("#word").focus();
    });

    $("#results").html("");
    e.preventDefault();
  });


  $("body").on("submit","form#search", function(e){

    var url   = "/search";
    var word  = { word: $("#word").val() }
    $("#word").val("");

    $.ajaxGetRequest(url, word, function(d){
      var result =  "<div class='results'><span>"+d.started_at+"</span>"+
                    "<span>"+d.notice+"</span>"+
                    "<span>>"+d.anagrams+"</span></div>"
      $("#results").prepend(result);
    });
    e.preventDefault();
  });

});
