define ['backbone'], (Backbone) ->
  class Event extends Backbone.Model
    url: 'index.php?/event'

    defaults:
      "kind": "calendar#event"
