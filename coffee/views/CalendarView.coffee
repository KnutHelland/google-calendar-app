define [ \
'backbone', \
'jquery', \
'underscore', \
'models/Events', \
'kh-calendar', \
'datetime-utils', \
'models/Calendars', \
'google-colors', \
'views/SelectCalendarsPanel'], ( \
Backbone, \
$, \
_, \
EventsCollection, \
KHCalendar, \
dt, \
CalendarsCollection, \
gColors, \
SelectCalendarsPanel) ->

	class CalendarView extends Backbone.View
		id: 'calendar-view'

		# How many to be displayed
		howMany: 3

		khCalendar: undefined

		loadedCalendars: []

		eventsByDatestamp: {}


		initialize: ->
			@calendars = new CalendarsCollection()

			@listenTo @calendars, 'add', (calendar) ->
				@listenTo calendar.events, 'sync', =>
					@refreshCalendar calendar

			@listenTo @calendars, 'change:display', @_changedCalendarDisplay

			panel = new SelectCalendarsPanel
				calendars: @calendars
			panel.render()

			@calendars.fetch()

		#
		refreshCalendar: (calendar) ->
			@hideCalendar calendar
			if calendar.get 'display'
				calendar.events.forEach (event) =>
					@addEventToCalendar event

		# Removes events from the calendar view
		hideCalendar: (calendar) ->
			calendar.events.forEach (event) =>
				@removeEventFromCalendar event


		_changedCalendarDisplay: (calendar) =>
			@refreshCalendar calendar


		changedActiveCalendars: =>
			for events, datestamp in @eventsByDatestamp
				console.log events, datestamp

			@eventsByDatestamp = {}

			for calendarId in @appStateResource.get('activeCalendars').split(",")
				calendar = @calendars.get(calendarId)
				calendar.events.forEach (event) =>
					@addEventToCalendar event


		getStartDatestamp: (event) ->
			start = event.get 'start'
			if start.dateTime
				start = start.dateTime
			else
				start = start.date

			KHCalendar.ensureDatestamp dt.datetimeToTimestamp(start)


		addEventToCalendar: (event) ->
			start = @getStartDatestamp event

			if not @eventsByDatestamp[start]
				@eventsByDatestamp[start] = []

			@eventsByDatestamp[start].push event
			@renderDate start


		getEventColor: (event) ->
			color = ""
			colorId = event.get 'colorId'
			if not colorId
				color = event.get 'calendarColor'
			else
				color = gColors[colorId]

			return color

		# Removes an event from the calendar view
		removeEventFromCalendar: (event) ->
			start = @getStartDatestamp event

			if @eventsByDatestamp[start] and @eventsByDatestamp[start].length > 0
				newEvents = []
				for e in @eventsByDatestamp[start]
					if event isnt e
						newEvents.push e

				@eventsByDatestamp[start] = newEvents

			@renderDate start


		# Need to be called after @eventsByDatestamp is changed
		renderDate: (datestamp) ->
			@khCalendar.clear datestamp
			summary = ""

			if not @eventsByDatestamp[datestamp]
				@eventsByDatestamp[datestamp] = []

			for event in @eventsByDatestamp[datestamp]

				color = @getEventColor event
				@khCalendar.colorDate datestamp, color
				summary += event.get "summary"
				summary += "\n"

			@khCalendar.registerOnclick datestamp, =>
				window.alert summary





		render: ->
			@el = document.getElementById @id
			@$el = $ @el
			@$el.html ''

			@khCalendar = khCalendar = new KHCalendar()
			thisMonth = KHCalendar.ensureMonthstamp()

			for i in [1..@howMany]
				month = khCalendar.createMonth thisMonth 
				@$el.append month
				thisMonth = KHCalendar.ensureMonthstamp thisMonth+3600*24*33

			femtejuni = 1370383200
			@khCalendar.colorDate femtejuni, "ff0000"
			@khCalendar.clear femtejuni


