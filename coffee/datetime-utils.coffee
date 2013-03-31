define [], ->
	utils = 
		datetimeToTimestamp: (datetime) ->
			date = new Date(datetime)
			return date.getTime()/1000
			

		timestampToDateString: (timestamp) ->
			date = new Date timestamp*1000

			string = ''
			string += date.getUTCFullYear()
			string += '-' + date.getUTCMonth()
			string += '-' + date.getUTCDate()


		timestampToDatetimeString: (timestamp) ->
			date = new Date timestamp*1000

			string = ''
			string += date.getUTCFullYear()
			string += '-' + date.getUTCMonth()
			string += '-' + date.getUTCDate()
			string += 'T' + date.getUTCHours()
			string += ':' + date.getUTCMinutes()
			string += 'z'


