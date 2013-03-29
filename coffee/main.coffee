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
	
#	paths:
#		jquery: 'lib/jquery'
#		underscore: 'lib/underscore'
#		backbone: 'lib/backbone'

require ['application', 'jquery'], (App, $) ->
 	app = new App
 	app.start()