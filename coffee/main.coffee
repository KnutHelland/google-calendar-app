requirejs.config
	baseUrl: 'js'
	shim:
		'jquery':
			exports: 'JQuery'
		'underscore':
			exports: '_'
		'backbone':
			deps: ['underscore', 'jquery']
			exports: 'Backbone'
	
	paths:
		jquery: '../lib/jquery'
		underscore: '../lib/underscore'
		backbone: '../lib/backbone'

require ['router', 'backbone', 'jquery', 'models/calendars'], (Router, Backbone, $, Calendars) ->
 	router = Router

 	Backbone.history.start()

