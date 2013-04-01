define ['backbone', 'jquery', 'underscore', 'jquery_mobile'], (Backbone, $, _) ->

	# Reqired options:
	#   calendars (of type models/Calendars)
	class SelectCalendarsPanel extends Backbone.View

		id: 'select-calendars-panel'

		elementTemplate: _.template """
		<input type="checkbox" name="ShowCalendarPanel-checkbox-<%= id %>" id="ShowCalendarPanel-checkbox-<%= id %>" data-mini="true" checked="" />
		<label for="ShowCalendarPanel-checkbox-<%= id %>"><%= name %></label>
		"""

		initialize: ->
			requiredOptions = ['calendars']

			for option in requiredOptions
				if not @options[option]
					throw "SelectCalendarsView requires the option #{option} to be set."

			@render()
			@options.calendars.on 'add', @addCalendar
			@listenTo @options.calendars, 'change:display', @_calendarToggled

		elementId: (calendarId) ->
			return calendarId.replace '@', '_'

		# Event listener when calendar.display is toggled in model
		_calendarToggled: (calendar, displayValue) =>
			id = @elementId calendar.get('id')
			item = $ '#ShowCalendarPanel-'+id
			item.attr "checked", displayValue.toString()

		# Event listener when calendar is checked/unchecked in dom
		_toggleCalendar: (calendar) ->
			calendar.set 'display', (not calendar.get 'display')

		# Add a calendar to the list
		addCalendar: (calendar) =>
			id = @elementId(calendar.get('id'))
			item = $ @elementTemplate({
				name: calendar.get 'summary'
				id: id
			})

			list = $('#ShowCalendarPanel-list')
			list.append item
			list.trigger "create"
			list.trigger "refresh"
			
			item.on 'click', (event) =>
				if event.originalEvent # Dont catch jquery event
					return

				@_toggleCalendar(calendar)

		render: (event) =>
			@el = document.getElementById @id
			@$el = $ @el

			@$el.text ""

			list = $ """
			<div data-role="controlgroup" id="ShowCalendarPanel-list"></div>
			"""

			@$el.append list
			@$el.trigger "create"




		