module.exports = function (grunt) {

	grunt.loadNpmTasks('grunt-contrib-coffee');		
	grunt.loadNpmTasks('grunt-contrib-watch');
	// grunt.loadNpmTasks('grunt-contrib-concat');
	grunt.loadNpmTasks('grunt-contrib-requirejs');
	grunt.loadNpmTasks('grunt-contrib-clean');	

	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),

		watch: {

			files: ['Gruntfile.js', 'coffee/*'],
			tasks: ['clean', 'coffee']
		},

		/* Compile files from ./coffee to ./js */
		coffee: {
			compile: {
				expand: true,
				cwd: 'coffee',
				src: ['**/*.coffee'],
				dest: 'js/',
				ext: '.js'
			}
		},

		/* Minimize all javascript */
		/*requirejs: {
			compile: {
				baseUrl: 'js/',
				optimize: 'none',
				out: 'dist/webapp.js',
				name: 'global'
			}
		},*/


		clean: {
			"default": ['js']
		}
	});


	grunt.registerTask('default', ['clean', 'coffee' /*, 'requirejs' */]);
}