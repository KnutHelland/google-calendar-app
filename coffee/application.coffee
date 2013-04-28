define ['jquery', 'kh-calendar'], ($, Calendar) ->
	
        class Application

		start: () ->
			cal = new Calendar()

			monthIterator = Calendar.ensureMonthstamp new Date().getTime()/1000
			for k in [0..7]
				$('body').append cal.createMonth(monthIterator).element
				monthIterator = Calendar.ensureMonthstamp monthIterator + 3600*24*32
	
				if monthIterator > Calendar.ensureMonthstamp new Date(2013, 5, 1).getTime()/1000
					break
	

			window.scrollTo 0, $('table').first().position().top

			cal.markCurrentDate();
			cal.markPassedDates();

			onclickDate = (datestamp) ->
				if dateEvents[datestamp]
					buffer = ''
					for title in dateEvents[datestamp]
						buffer += dateEvents[datestamp][title] + '\n'
			
		
					window.alert(buffer);
	


			dateEvents = {};


			$.ajax
				url: 'eventFeed.php'
				dataType: 'xml'
				success: (data) ->
					data = $ data

					$('event', data).each (i, event) ->
						datestamp = $(event).attr 'datestamp'

						bgColor = $	'backgroundColor', event
						if bgColor.length > 0
							# Set the color
							cal.colorDate datestamp, bgColor.text()
				
							# Save the title
							title = $ 'title', event
							if title.length > 0
								if title.text() != ""
									if !dateEvents[datestamp]
										dateEvents[datestamp] = Array()
							
									dateEvents[datestamp].push title.text()
			
						clss = $ 'class', event
						if clss.length > 0
							cal.classDate datestamp, clss.text()

		
					# Register onclick events.
					for datestamp in dateEvents
						cal.registerOnclick datestamp, onclickDate
