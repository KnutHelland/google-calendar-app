define ['backbone'], (Backbone) ->

	# Reqired options:
	#   calendars (of type models/Calendars)
	class SelectCalendarsView extends Backbone.View

		initialize: ->

			requiredOptions = ['calendars']

			for option in requiredOptions
				if not @options[option]
					throw "SelectCalendarsView requires the option #{option} to be set."


		