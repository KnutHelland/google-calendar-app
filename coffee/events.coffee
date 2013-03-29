define ['backbone', 'event'], (Backbone, Event) ->
	class Events extends Backbone.Collection

		model: Event