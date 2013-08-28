$(function() {
  $("tr.clickable").click(function(event) {
		if (event.target && event.target.nodeName === 'A')
			return
    var link = $(this).find("a")
    if ( link )
      window.location = link.attr("href")
    event.stopPropagation()
  })
})