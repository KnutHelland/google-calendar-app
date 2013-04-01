define ['backbone', 'views/CalendarView', 'views/SelectCalendarsPanel'], (Backbone, CalendarView, SelectCalendarsPanel) ->
	
	class Router extends Backbone.Router
		routes:
			'index': 'index'
			'event/:id': 'event'
			'*path': 'index'

		initialize: ->
			@on 'route:index', ->
				view = new CalendarView()
				view.render()


			@on 'route:event', (id) ->
				console.log 'You requested the event ', id

	return new Router