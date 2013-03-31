define ['backbone', 'models/Event'], (Backbone, Event) ->
	class Events extends Backbone.Collection
		constructor: (models, options) ->
			if options.calendarId
				@calendarId = options.calendarId
			if options.calendarColor
				@calendarColor = options.calendarColor

			@on 'add', (event) ->
				event.set 'calendarColor', @calendarColor

			super models, options



		url: ->
			calendar = @calendarId || 'all'
			'index.php?/calendar/'+calendar+'/events'

		model: Event