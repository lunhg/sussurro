sussurro = new App()
                        
App::configure = (readyState) ->
        @app.set 'views', path.join(__dirname, '..', 'app/views/')
        @app.engine 'pug', (file_path, options, _callback) ->
                fs.readFile file_path, 'utf8', (err, content) ->
                        if err then _callback(err)
                        fn = require('pug').compile content, {filename: file_path, doctype:'html'}
                        
                        _callback null, fn({filters: [ marked ]})
                        
        @app.set 'view engine', 'pug'
        @app.set 'img path', path.join __dirname, '..', 'app/assets/img'
        @app.set 'css path', path.join __dirname, '..', 'app/assets/css'
        @app.set 'js path',  path.join __dirname, '..', 'app/assets/js'
        @app.set 'favicon path',  path.join __dirname, '..', 'app/assets/favicon.ico'        
        @app.use (req, res, next) ->
                res.on 'finish', ->
                        color = if @statusCode isnt '200' then chalk.red else chalk.green
                        msg = color(@statusCode) + ' ' + req.originalUrl;
                        encoding = @._headers && @._headers['content-encoding']
                        if encoding
                                msg += chalk.gray(' (' + encoding + ')')
                                console.log(msg)
                        next()
        @app.use(favicon(@app.get('favicon path')))
        #@app.use(logger('dev'))
        @app.use(compression())                            
        @app.use(bodyParser.json())
        @app.use(bodyParser.urlencoded({ extended: false }))
        @app.use(connectAssets(paths: [
                @app.get('img path')
                @app.get('css path')
                @app.get('js path')
        ]))
        Session.findOne {}, (err, _session) =>
                @app.use session({
                        secret: _session.pass
                        maxAge: new Date(Date.now() + 3600000)
                        store: new MongoStore({mongooseConnection:mongoose.connection})
                        saveUninitialized: true
                        resave: false
                })
                
console.log chalk.yellow("==> App boot helpers loaded")
