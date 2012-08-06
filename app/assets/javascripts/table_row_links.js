$(function() {
  $("tr.clickable").click(function(event) {
    var link = $(this).find("a")
    if ( link )
      window.location = link.attr("href")
    event.stopPropagation()
  })
})