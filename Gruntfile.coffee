### Grunt tasks ###
path = require 'path'
each = require 'foreach'
require_from_package = require 'require-from-package'
check_node = require 'check_node'
        
module.exports = (grunt) ->
        pkg = grunt.file.readJSON('package.json')
        options = pkg.options;
        options.pkg = name: pkg.name, version: pkg.version
        
        # load task
        grunt.loadNpmTasks 'grunt-contrib-coffee'
        grunt.loadNpmTasks 'grunt-banner'
        grunt.loadNpmTasks 'grunt-shell'
        
        grunt.registerTask 'build:init', 'An async configure task', ->
                done = @async()
                check_node (err, node_path) ->
                        if err then done(err)
                        grunt.config('pkg.node_version', node_path)
                        done()

        grunt.registerTask 'build:libs', 'An async library maker task', ->
                done = @async()
                require_from_package({
                        ext: 'coffee'
                        path: process.cwd()
                        destination: "boot"
                        pkg: pkg
                        core: ['fs', 'path', 'http']
                        validate: (name) ->
                                regexp = new RegExp("(grunt.*|check_node|require_from_package|syncprompt)")
                                !name.match(regexp)
                }, done)

        grunt.registerTask 'build:docs', 'Build documentation with docco', ->
                c = ""
                # Document all
                for k,v of options.coffee.files
                        for file in v
                                orig = "#{path.join(__dirname)}/#{file}"
                                dest = "#{path.join(__dirname)}/app/assets/doc/#{file}"
                                
                                console.log "origin: #{orig}"
                                console.log "dest: #{dest}"
                                c += ("docco #{orig} -o #{dest} ; ")
        
                grunt.config('shell', {'docco': c})
                
                
        grunt.initConfig options
        
        # register tasks
        #grunt.registerTask 'default', ['build:init', 'build:libs', 'coffee', 'usebanner']
