define ['backbone', 'models/calendar'], (Backbone, Calendar) ->
	class Calendars extends Backbone.Collection
		model: Calendar
		url: 'index.php?/calendars'
