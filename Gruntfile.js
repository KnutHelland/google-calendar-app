module.exports = function (grunt) {
  grunt.loadNpmTasks('grunt-contrib-coffee');             
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-requirejs');
  grunt.loadNpmTasks('grunt-contrib-clean');
  // grunt.loadNpmTasks('grunt-ftp-deploy');

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
        //      bare: true
        // }
      }
    },

    // 'ftp-deploy': {
    //   build: {
    //     auth: {
    //       host: 'ftp.knuthelland.com',
    //       port: 21,
    //       authKey: "deploy"
    //     },
    //     src: '.',
    //     dest: 'beta',
    //     exclusions: [
    //       './.gitignore',
    //       './.settings.template.php',
    //       './.DS_Store',
    //       './**/.DS_Store',
    //       './.git',
    //       './README.md',
    //       './Gruntfile.js',
    //       './package.json',
    //       './node_modules',
    //       './coffee',
    //       './less'
    //     ]
    //   }
    // },

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
            backbone: 'empty:',
            jquery_mobile: 'empty:'
          },
          optimize: 'none'
        }
      }
    },


    clean: {
      "default": ['js/*']
    }
  });

  grunt.registerTask('default', ['clean', 'coffee', 'less', 'requirejs']);
  grunt.registerTask('deploy', ['clean', 'coffee', 'less', 'requirejs', 'ftp-deploy']);
}
