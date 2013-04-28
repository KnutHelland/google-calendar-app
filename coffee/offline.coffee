define [], ->
	module =
		_getLocalStorage: ->
			return window.localStorage

		saveCollection: (name, collection) ->
			window.localStorage.setItem name, collection.toJSON()

		loadCollection: (name, collection) ->
			return null


