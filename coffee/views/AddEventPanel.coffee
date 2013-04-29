define ['backbone', 'jquery', 'underscore', 'models/event', 'datetime-utils', 'jquery_mobile'], (Backbone, $, _, Event, Datetime) ->

  class AddEventPanel extends Backbone.View

    id: 'add-event-panel'

    elementTemplate: _.template """
    <label for="AddEventPanel-summary">Tittel</label>
    <input type="text" name="AddEventPanel-summary" />
    <input type="button" value="Add event" />
    """

    render: (event) =>
      @el = document.getElementById @id
      @$el = $ @el
      @$el.text ""

      @$el.append @elementTemplate
      $("input[type=button]", @$el).on 'click', =>
        event = new Event()
        event.set "start", 
          date: Datetime.timestampToDateString(@options['datetime'])
        event.set "summary", $("""input[name="AddEventPanel-summary"]""", @$el).value()
        @$el.panel "close"

      @$el.panel "open"
      @$el.trigger "create"
