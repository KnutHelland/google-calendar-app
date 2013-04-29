define ['backbone', 'jquery', 'underscore', 'kh-calendar', 'models/event', 'datetime-utils', 'jquery_mobile'], (Backbone, $, _, KHCalendar, Event, Datetime) ->

  class AddEventPanel extends Backbone.View

    id: 'add-event-panel'

    calendarTemplate: _.template """
    <label for="AddEventPanel-calendar-<%= id %>"><%= name %></label>
    <input type="radio" name="AddEventPanel-calendar" id="AddEventPanel-calendar-<%= id %>" value="<%= id %>">
    """

    eventTemplate: _.template """
  	<input type="button" class="duplicateEvent" data-event-id="<%= id %>" value="<%= name %>" data-mini="true" />
    """

    elementTemplate: _.template """
    <% if (events && events.length > 0) { %>
      <h3>Copy event</h3>
      <%= events %>
    <% } %>
    <h3>Add event</h3>
    <label for="AddEventPanel-summary">Tittel</label>
    <input type="text" name="AddEventPanel-summary" id="AddEventPanel-summary" />
    <fieldset data-role="controlgroup">
    <legend>Select calendar</legend>
    <%= calendars %>
    </fieldset>
    <input type="button" id="AddEventPanel-submit" value="Add event" />
    """

    render: (event) =>
      @el = document.getElementById @id
      @$el = $ @el
      @$el.text ""

      events = ""
      for event in @options['events']
        events += @eventTemplate
          id: event.get "id"
          name: event.get "summary"
          
      list = ""
      @options.calendars.forEach (calendar) =>
        list += @calendarTemplate
          id: calendar.get 'id'
          name: calendar.get 'summary'

      @$el.append @elementTemplate(
        calendars: list
        events: events
        date: Datetime.timestampToDatetimeString parseInt(@options.datestamp))

      $(".duplicateEvent", @$el).on 'click', (evt) =>
        @options.calendarView.copyEvent $(evt.currentTarget).attr("data-event-id")
        @$el.panel "close"

      $("AddEventPanel-submit", @$el).on 'click', =>
        event = new Event()

        event.set "start", 
          date: Datetime.timestampToDateString parseInt(@options['datestamp'])
        event.set "end",
          date: Datetime.timestampToDateString (KHCalendar.ensureDatestamp(3600*26 + parseInt(@options['datestamp'])))
        event.set "calendarId", $("input[name='AddEventPanel-calendar']", @$el).val()
        event.set "summary", $("#AddEventPanel-summary", @$el).val()
        event.save()
        @$el.panel "close"

      @$el.panel "open"
      @$el.trigger "create"
