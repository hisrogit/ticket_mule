// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  //layouts/application.html.erb-------------------------
  if ($("#jumpbox") != null){
    $("#jumpbox").submit(doTicketJump);
  }

  //tickets/index.html.erb-------------------------------
  if ($("#ticket-filter") != null){
    $("#ticket-filter").hide();
  }

  //tickets/show.html.erb--------------------------------
  if ($("#add-comment") != null){  
    $("#add-comment").hide();
  }
  if ($("#add-attachment") != null){
    $("#add-attachment").hide();  
  }
  if ($("#attachments-toggle") != null){
    $("#attachments-toggle").click(function() {
      $("#attachment-list").slideToggle();
    });
  }
  if ($("#comments-toggle") != null){
    $("#comments-toggle").click(function() {
      $("#comment-list").slideToggle();
    });
  }

  //dashboard/index.html.erb-----------------------------
  if ($("#timeline-toggle") != null){
    $("#timeline-toggle").click(function() {
      $("#timeline-wrapper").slideToggle();
    });
  }
  if ($("#active-tickets") != null){
    $("#active-tickets").click(function() {
      $("#active-listing").slideToggle();
    });
  }
  
  if ($("#closed-tickets") != null){
    $("#closed-tickets").click(function() {
      $("#closed-listing").slideToggle();
    });
  }

  //users/show.html.erb----------------------------------
  if ($("#alerts-toggle") != null){
    $("#alerts-toggle").click(function() {
      $("#alert-list").slideToggle();
    });
  }
  
  if ($("#assigned-to-toggle") != null){
    $("#assigned-to-toggle").click(function() {
      $("#assigned-to-listing").slideToggle();
    });
  }

  //admin/index.html.erb---------------------------------
  if ($("#group-enabled-toggle") != null){
    $("#group-enabled-toggle").click(function() {
      $("#group-enabled-list").slideToggle();
    });
  }
  if ($("#group-disabled-toggle") != null){
    $("#group-disabled-toggle").click(function() {
      $("#group-disabled-list").slideToggle();
    });
  }
  if($("#status-enabled-toggle") != null){
    $("#status-enabled-toggle").click(function() {
      $("#status-enabled-list").slideToggle();
    });
  }
  if($("#status-disabled-toggle") != null) {
    $("#status-disabled-toggle").click(function() {
      $("#status-disabled-list").slideToggle();
    });
  }
  if ($("#priority-enabled-toggle") != null){
    $("#priority-enabled-toggle").click(function() {
      $("#priority-enabled-list").slideToggle();
    });
  }
  if ($("#priority-disabled-toggle") != null){
    $("#priority-disabled-toggle").click(function() {
      $("#priority-disabled-list").slideToggle();
    });
  }

  // site-wide submit buttons...disable on form submit
  if ($('form') != null){
    $('form').submit(function(){
      $('input[type=submit]', this).attr('disabled', 'disabled');
    });
  }
  
  // site-wide toggle headers
  if ($(".toggle") != null){
    $(".toggle").toggle(function() {
      $(this).addClass("closed");
      }, function () {
      $(this).removeClass("closed");
    });
  }
    
  // site-wide flash message animation
  hideFlash();
});

//ticket jump form
function doTicketJump() {
    var ticket_id = document.getElementById("jump_id").value;
    var app_root = document.getElementById("app_root").value;
    if ((ticket_id != "") && (ticket_id.length > 0)) {
        location.href = app_root+"/tickets/"+ticket_id;
    }
    return false;
}

//hide flash messages with jQuery fadeOut
function hideFlash() {
  var flash_div = $(".flash");
  if (flash_div != null){
    setTimeout(function() { flash_div.fadeOut(2500, function() { flash_div.html(""); flash_div.hide(); })}, 3500);
  }
}

//get today's date
function getToday() {
    var d = new Date();
    return d.getFullYear().toString() + "-" + (d.getMonth()+1).toString() + "-" + d.getDate().toString()
}
