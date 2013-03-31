define ['backbone', 'models/Color'], (Backbone, Color) ->
	class Colors extends Backbone.Collection
		model: Color
		url: 'index.php?/colors/'
