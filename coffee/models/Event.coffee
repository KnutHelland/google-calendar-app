define ['backbone'], (Backbone) ->
  class Event extends Backbone.Model
    url: 'index.php?/events'

    defaults:
      "kind": "calendar#event"
