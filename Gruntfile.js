module.exports = function (grunt) {

	grunt.loadNpmTasks('grunt-contrib-coffee');		
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-less');
	grunt.loadNpmTasks('grunt-contrib-requirejs');
	grunt.loadNpmTasks('grunt-contrib-clean');	

	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),

		watch: {

			files: ['Gruntfile.js', 'coffee/*', 'coffee/**'],
			tasks: ['clean', 'coffee', 'less', 'requirejs']
		},

		/* Compile files from ./coffee to ./js */
		coffee: {
			compile: {
				expand: true,
				cwd: 'coffee',
				src: ['./*/*.coffee', '**.coffee'],
				dest: 'js',
				ext: '.js'
				// options: {
				// 	bare: true
				// }
			}
		},

		less: {
			compile: {
				options: {
					paths: ['less']
				},
				cwd: './',
				src: ['less/*.less'],
				dest: 'css/style.css',
				ext: '.css',
			}
		},

		/* Minimize all javascript */
		requirejs: {
			compile: {
				options: {
					baseUrl: 'js',
					out: 'dist/webapp.js',
					mainConfigFile: 'js/main.js',
					name: 'main',
					paths: {
						jquery: 'empty:',
						underscore: 'empty:',
						backbone: 'empty:'
					}/*,
					optimize: 'none'*/
				}
			}
		},


		clean: {
			"default": ['js/*']
		}
	});


	grunt.registerTask('default', ['clean', 'coffee', 'less', 'requirejs']);
}