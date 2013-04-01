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


require ['router', 'backbone', 'jquery', 'jquery_mobile', 'models/calendars'], (Router, Backbone, $, mobile, Calendars) ->
 	router = Router
 	Backbone.history.start()

