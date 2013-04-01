define ['backbone', 'models/Events'], (Backbone, Events) ->
	class Calendar extends Backbone.Model
		url: 'index.php?/calendars'

		events: null

		defaults:
			display: true

		initialize: ->
			@on 'add', ->
				@events = new Events [],
					calendarId: @get 'id'
					calendarColor: @get 'backgroundColor'
				@events.fetch()

				if @get 'summaryOverride'
					@set 'summary', @get('summaryOverride')
