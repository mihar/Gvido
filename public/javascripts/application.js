// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function remove_fields(link) {
  if ( confirm(I18n.t("crud.are_you_sure")) )
  {
    $(link).parent().parent().find(".hidden input").val("1");
    $(link).parent().parent().animate({opacity: 'hide'}, 'slow');
  }
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  console.log(regexp)
  $(link).parent().parent().parent().before(content.replace(regexp, new_id));
}