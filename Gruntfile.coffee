### Grunt tasks ###
path = require 'path'
each = require 'foreach'

build = (array,fn) ->
        app = []
        test = []
        each array, (e,i) ->
                app.push  path.join(__dirname, "#{e}.coffee") 
                test.push path.join(__dirname, "#{e}.coffee")

        if fn then fn(app)

        each array, (e, i) -> test.push path.join(__dirname, "#{e}.test.coffee")
        {app: app, test: test}
        
module.exports = (grunt) ->
        pkg = grunt.file.readJSON('package.json')
        libs = ['boot/libs','config/development_mode','config/db','config/app','boot/db','app/models/profile','app/models/bio','app/models/local','app/models/contato','app/models/user','app/models/wiki','app/models/post','app/models/session','boot/app', 'app/controllers/profile','app/controllers/bio','app/controllers/local','app/controllers/contato','app/controllers/wiki','app/controllers/post','boot/routes']
        
        server = ['boot/libs.server','boot/server']      
        app = build libs, (_app) ->
                _app.push path.join(__dirname, 'boot/exports.coffee')
        
        www = build server
        options =
                coffee:
                        compileJoined:
                                options:
                                        joinExt: '.coffee'
                                        bare: true
                                        join: true
                                files:
                                        'dist/build.js': app.app
                                        'dist/build_spec.js': app.test
                                        'bin/www': www.app
                                        'dist/www_spec.js': www.test
                usebanner:
                        www: 
                                options:
                                        position: 'top',
                                        banner: '#!~/.nvm/versions/node/v4.2.2/bin/node\n',
                                        linebreak: true
                                files:
                                        src: [ 'bin/www' ]
                        
        # build them to dist/build.js and dist/spec.js, and then add a little banner to bin/www
        grunt.initConfig options

        # load tasks
        grunt.loadNpmTasks 'grunt-contrib-coffee'
        grunt.loadNpmTasks 'grunt-banner'
        
        # register tasks
        grunt.registerTask 'default', ['coffee', 'usebanner']
