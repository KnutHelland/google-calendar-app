define ["jquery"], ($) ->  
  
  # 
  # A library for creating simple and interactive calendars in
  # a HTML-page.
  #
  # This library requires JQuery.
  # 
  # Author: Knut Helland <knutoh@gmail.com
  #
  
  
  #
  # The Calendar uses UNIX timestamps in seconds from 1970.
  # `monthstamp` and `datestamp` is a timestamp of the first
  # second in that month or day. The monthstamp of a month is also
  # the datestamp of the first day in the month.
  # Ensure a valid datestamp or monthstamp by calling
  #     monthstamp = Calendar.ensureMonthstamp monthstamp
  #     datestamp = Calendar.ensureDatestamp datestamp
  #
  # Example calendar:
  #     `cal = new Calendar()`
  #     `$("#destination").add cal.createMonth`
  #
  class Calendar
  
    #
    # Create a new calendar.
    #
    # Gives the calendar a unique Calendar ID so we can separate
    # it's elements from other calendar instances.
    constructor: ->
      @num = Calendar.addCalendar()
      @months = {}
      @chrome = /chrome/.test(navigator.userAgent.toLowerCase())
  
    #
    # Generates IDs for new calendars.
    #
    @addCalendar: ->
      if not @counter
        @counter = 1
      return @counter++
  
    #
    # Creates a new month and returns the JQuery element containing
    # the month.
    #
    createMonth: (monthstamp = Calendar.ensureMonthstamp()) ->
      monthstamp = Calendar.ensureMonthstamp monthstamp
      month = @months[monthstamp] = new Month monthstamp, @num
      return month.get()
  
    #
    # Sets a border on the current day.
    #
    markCurrentDate: ->
      datestamp = Calendar.ensureDatestamp()
      todayElement = $ "#date_#{datestamp}_#{@num}"
      todayElement.css "border", "2px solid black"
      return null
  
    #
    # Get the background canvas for a date.
    #
    getDateCanvas: (datestamp) ->
      datestamp = Calendar.ensureDatestamp datestamp
      dateElement = $ "#date_#{datestamp}_#{@num}"
      dateCanvas = $ "#canvas_date_#{datestamp}_#{@num}"
  
      if dateElement.length is 0
        return null
  
      if dateCanvas.length is 0
        dateElement.prepend """
          <canvas id="canvas_date_#{datestamp}_#{@num}"
              style="position: absolute; z-index: -1"
              height="#{dateElement.height()}px"
              width="#{dateElement.width()}px">
          </canvas>"""
      
      canvas = document.getElementById "canvas_date_#{datestamp}_#{@num}"

      # Need to reposition the canvas if chrome
      if @chrome
        c = $ canvas
        c.css
          left: c.parent().position().left
  
      return canvas

    onclickListenersByDate: []

    abortOnclick: false

    #
    # Registers a callback to happen onclick on a date.
    #
    # registerOnclick: (datestamp, callback) ->
    #   datestamp = Calendar.ensureDatestamp datestamp

    #   internalCallback = (evt) =>
    #     if not @abortOnclick
    #       callback evt.data
    #     @abortOnclick = false
  
    #   if not @onclickListenersByDate[datestamp]
    #     @onclickListenersByDate[datestamp] = []

    #   @onclickListenersByDate[datestamp].push internalCallback
    #   $("#date_#{datestamp}_#{@num}").on "tap", datestamp, internalCallback

    registerOnclick: (callback) ->
      context = $(".calendar_#{@num}")
      $("td", context).on "tap", (evt) =>
        if not @abortOnclick
          datestamp = $(evt.currentTarget).attr("data-datestamp")
          if datestamp > 0
            callback datestamp
        @abortOnclick = false


    # Register a taphold event. First argument is datetime of the day
    registerTapholdListener: (callback) ->
      context = $(".calendar_#{@num}")
      $("td", context).on "taphold", (evt) =>
        @abortOnclick = true
        datestamp = $(evt.currentTarget).attr("data-datestamp")
        if datestamp > 0
          callback datestamp

    clear: (datestamp) ->
      datestamp = Calendar.ensureDatestamp datestamp
      date = $("#date_#{datestamp}_#{@num}")
      canvas = $("#canvas_date_#{datestamp}_#{@num}").remove()
      
      if @coloredDates[datestamp]
        @coloredDates[datestamp] = []

  
    #
    # Marks the passed dates.
    #
    markPassedDates: -> 
      currentDate = Calendar.ensureDatestamp()
      currentMonth = Calendar.ensureMonthstamp()
  
      for month in @months
        if month <= currentMonth
          dateIterator = Calendar.ensureDatestamp month
  
          for i in [0..32]
            if dateIterator >= currentDate
              break
  
            $("#date_#{dateIterator}_#{@num}").addClass "passed"
            dateIterator = Calendar.ensureDatestamp dateIterator+3600*25
  
      return null
  
    coloredDates: {}

    #
    # Adds a color to a date.
    #
    colorDate: (datestamp, color) ->
      datestamp = Calendar.ensureDatestamp datestamp
  
      if not @coloredDates[datestamp]?
        @coloredDates[datestamp] = new Array()
  
      colors = @coloredDates[datestamp]
      colors.push color
      colors.sort()
  
      canvas = @getDateCanvas datestamp
      if not canvas
        return null
  
      ctx = canvas.getContext "2d"
      canvas = $ canvas
  
      if colors.length isnt 2
        i = -1
        while ++i <= colors.length
          ctx.fillStyle = colors[i]
          ctx.fillRect 0, (canvas.height()/colors.length)*i, canvas.width(), (canvas.height()/colors.length)
  
      else
        ctx.fillStyle = colors[0]
        ctx.beginPath()
        ctx.moveTo 0, 0
        ctx.lineTo canvas.width(), 0
        ctx.lineTo 0, canvas.height()
        ctx.closePath()
        ctx.fill()
  
        ctx.fillStyle = colors[1]
        ctx.beginPath()
        ctx.moveTo 0, canvas.height()
        ctx.lineTo canvas.width(), 0
        ctx.lineTo canvas.width(), canvas.height()
        ctx.closePath()
        ctx.fill()
  
      if $("#date_#{datestamp}_#{@num}").hasClass "passed"
        ctx.fillStyle = "rgba(255, 255, 255, 0.6)"
        ctx.fillRect 0, 0, canvas.width(), canvas.height()
  
      return undefined
  
    #
    # Add a class to a date
    #
    classDate: (datestamp, clss) ->
      datestamp = Calendar.ensureDatestamp datestamp
      $("#date_#{datestamp}_#{@num}").addClass clss
  
    #
    # Ensures the given monthstamp to be a valid unix monthstamp
    # Or if no monthstamp is given, or string 'now' is given, it
    # returns the monthstamp of the current month.
    #
    @ensureMonthstamp: (monthstamp = 'now') ->
      if monthstamp is 'now'
        date = new Date()
      else
        date = new Date(monthstamp*1000)
  
      date.setMilliseconds 0
      date.setSeconds 0
      date.setMinutes 0
      date.setHours 0
      date.setDate 1
      return date.getTime()/1000
  
    #
    # Ensure the given datestamp to be a balid datestamp, not just
    # a timestamp inside the date. Returns today's datestamp
    # if no datestamp provided.
    #
    @ensureDatestamp: (datestamp = 'now') ->
      if datestamp is 'now'
        date = new Date()
      else
        date = new Date(datestamp*1000)
  
      date.setMilliseconds 0
      date.setSeconds 0
      date.setMinutes 0
      date.setHours 0
      return date.getTime()/1000
  
    #
    # Returns the week number of a date
    # source: http://stackoverflow.com/questions/6117814/get-week-of-year-in-javascript-like-in-php
    #
    @getWeekNumber = (d) ->
      d = new Date(d)
      d.setHours 0, 0, 0
      d.setDate d.getDate()+4-(d.getDay()||7)
      yearStart = new Date(d.getFullYear(), 0, 1)
      weekNo = Math.ceil (((d-yearStart)/86400000)+1)/7
  
  
  class Month
    
    constructor: (monthstamp, num) ->
      @monthstamp = monthstamp = Calendar.ensureMonthstamp monthstamp
      @month = new Date(this.monthstamp*1000)
      @num = num
  
      # Build the month
      @id = "month_#{@monthstamp}_#{@num}"
      @element = $ """
        <table id="#{id}" class="calendar calendar_#{@num} month_#{monthstamp}"</table>"""
  
      # Build headers
      @element.append($ """
        <tr><th class="monthname" colspan="8">#{@getTitle()}</th></tr>""")
      headerRow = $ "<tr><th></th></tr>"
      for i in [0..6]
        headerRow.append """<th class="dayname">#{Month.shortWeekdays[i]}</th>"""
      @element.append headerRow
  
      # Build weeks
      startDay = @month.getDay()-1
      if startDay < 0 then startDay = 6
      dayIterator = new Date((@monthstamp - 3600*24*startDay)*1000)
      onNextMonth = false
  
      for i in [0..5]
        week = $ """<tr><td class="weeknumber">#{Calendar.getWeekNumber dayIterator}</td></tr>"""
  
        for j in [0..6]
          datestamp = dayIterator.getTime()/1000
          outsider = false
          clss = ""
  
          if dayIterator.getTime()/1000 < @monthstamp or onNextMonth
            clss = "outsider"
            outsider = true
  
          if j == 6
            clss += " red"
  
          id = ""
          if not outsider
            id = """ id="date_#{datestamp}_#{@num}" """
            clss += " date_#{datestamp}"
          if clss isnt ""
            clss = """ class="#{clss}" """
  
          week.append($ """
            <td#{clss}#{id} data-datestamp="#{datestamp}"><p>#{dayIterator.getDate()}</p></td>""")
          dayIterator = new Date((Calendar.ensureDatestamp datestamp + 3600*25) * 1000)
  
          if dayIterator.getDate() is 1 and i > 0
            onNextMonth = true
  
        @element.append week
      return undefined
  
    #
    # A list of weekdays labels.
    #
    @shortWeekdays: ["ma", "ti", "on", "to", "fr", "lø", "sø"]
  
    #
    # Returns the JQuery element with the month.
    #
    get: ->
      @element
  
    getTitle: ->
      names = [
            "Januar", "Februar", "Mars",
            "April", "Mai", "Juni",
            "Juli", "August", "September",
            "Oktober", "November", "Desember"
          ]
         
      return names[@month.getMonth()] + " " + @month.getFullYear()

  return Calendar
