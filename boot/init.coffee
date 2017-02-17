# STARTING EXPRESS
class App
        constructor: ->
                @express = express()
                @express.set 'views', path.join(__dirname, 'app/views')
                @express.set 'view engine', 'pug'

                @express.set 'favicon path', path.join(__dirname, 'app/assets/favicon.ico')
                @express.set 'js path', path.join(__dirname, 'app/assets/js')
                @express.set 'css path', path.join(__dirname, 'app/assets/css')
                @express.set 'img path', path.join(__dirname, 'app/assets/images')
                @express.set 'fonts path', path.join(__dirname, 'app/assets/fonts')
                @express.set 'public path', path.join(__dirname, 'app/public')

                @express.use(favicon(@express.get('favicon path')))
                        .use(logger('dev'))
                        .use(compression())                             
                        .use(bodyParser.json())                      
                        .use(bodyParser.urlencoded({ extended: false }))
                        .use(connectAssets(paths: [
                	    @express.get('css path')
                	    @express.get('js path')
                	    @express.get('img path')
                	    @express.get('public path')
                	]))
                	.use(express.static(@express.get('public path')))
                        .use session({
                                secret:'keyboard cat'
                                maxAge: new Date(Date.now() + 3600000)
                                store: new MongoStore({mongooseConnection:mongoose.connection})
                                saveUninitialized: true
                                resave: false
                        })

