define [ \
'backbone', \
'jquery', \
'models/Events', \
'kh-calendar', \
'datetime-utils', \
'models/Calendars', \
'google-colors'], ( \
Backbone, \
$, \
EventsCollection, \
KHCalendar, \
dt, \
CalendarsCollection, \
gColors) ->

	class CalendarView extends Backbone.View
		id: 'calendar-view'

		howMany: 5

		khCalendar: undefined

		loadedCalendars: []

		initialize: ->
			@calendars = new CalendarsCollection()

			@listenTo @calendars, 'add', (calendar) ->
				@listenTo calendar.events, 'sync', @eventsLoaded

			@calendars.fetch()


		eventsLoaded: (events) ->
			if events.calendarId in @loadedCalendars
				# Todo remove all elements
				""

			events.forEach (event) =>
				@addEventToCalendar event


		addEventToCalendar: (event) ->
			# Color
			colorId = event.get 'colorId'
			if not colorId
				color = event.get 'calendarColor'
			else
				color = gColors[colorId]

			# Start time
			start = event.get 'start'
			if start.dateTime
				start = start.dateTime
			else
				start = start.date

			# Add to calendar
			start = dt.datetimeToTimestamp start
			@khCalendar.colorDate start, color
			@khCalendar.registerOnclick start, =>
				window.alert event.get('summary')

		render: ->
			@el = document.getElementById @id
			@$el = $ @el
			@$el.html ''

			@khCalendar = khCalendar = new KHCalendar()
			thisMonth = KHCalendar.ensureMonthstamp()

			for i in [0..@howMany]
				month = khCalendar.createMonth thisMonth 
				@$el.append month
				thisMonth = KHCalendar.ensureMonthstamp thisMonth+3600*24*33


