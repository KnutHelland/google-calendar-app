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
		'gapi':
			exports: 'gapi'
	
	paths:
		jquery: '../lib/jquery'
		jquery_mobile: '../lib/jquery_mobile'
		underscore: '../lib/underscore'
		backbone: '../lib/backbone'
		gapi: 'https://apis.google.com/js/client.js'


require ['router', 'backbone', 'jquery', 'models/calendars'], (Router, Backbone, $, Calendars) ->
 	router = Router
 	Backbone.history.start()

