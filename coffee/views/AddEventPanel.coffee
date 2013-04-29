define ['backbone', 'jquery', 'underscore', 'kh-calendar', 'models/event', 'datetime-utils', 'jquery_mobile'], (Backbone, $, _, KHCalendar, Event, Datetime) ->

  class AddEventPanel extends Backbone.View

    id: 'add-event-panel'

    calendarTemplate: _.template """
    <label for="AddEventPanel-calendar-<%= id %>"><%= name %></label>
    <input type="radio" name="AddEventPanel-calendar" id="AddEventPanel-calendar-<%= id %>" value="<%= id %>">
    """
    elementTemplate: _.template """
    <label for="AddEventPanel-summary">Tittel</label>
    <input type="text" name="AddEventPanel-summary" id="AddEventPanel-summary" />
    <fieldset data-role="controlgroup">
    <legend>Select calendar</legend>
    <%= calendars %>
    </fieldset>
    <input type="button" value="Add event" />
    """

    render: (event) =>
      @el = document.getElementById @id
      @$el = $ @el
      @$el.text ""

      list = ""
      @options.calendars.forEach (calendar) =>
        list += @calendarTemplate
          id: calendar.get 'id'
          name: calendar.get 'summary'

      @$el.append @elementTemplate({calendars: list})

      $("input[type=button]", @$el).on 'click', =>
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
