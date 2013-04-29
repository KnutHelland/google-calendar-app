define [], ->
	module =
		_getLocalStorage: ->
			return window.localStorage

    _storageName: (name) ->
      "collection_" + name

		saveCollection: (name, collection) ->
			window.localStorage.setItem @_storageName(name), collection.toJSON()

		loadCollection: (name, collection) ->
      storage = window.localStorage.getItem @_storageName(name)
      if storage
        return storage

      storage = nea 


