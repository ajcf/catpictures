$(function() {

	var categories = $("#category_select").data('options')

	$("#category_select").autocomplete({
		autoFocus: true,
		source: categories,
		select: function(event, ui){
			updateCatPhoto(ui.item.value);
		}
	});

});

var updateCatPhoto = function (category) {
	console.log(category)
	$.get("/category/" + category,
			function (url) {
				var status = $("#cat_photo").attr("src", url);
			}
		)
}