# STARTING EXPRESS
app = express()
router = express.Router()
app.set 'views', path.join(__dirname, 'app/views')
app.set 'view engine', 'pug'

app.set 'favicon path', path.join(__dirname, 'app/assets/favicon.ico')
app.set 'js path', path.join(__dirname, 'app/assets/js')
app.set 'css path', path.join(__dirname, 'app/assets/css')
app.set 'img path', path.join(__dirname, 'app/assets/images')
app.set 'fonts path', path.join(__dirname, 'app/assets/fonts')
app.set 'public path', path.join(__dirname, 'app/public')

app.use(favicon(app.get('favicon path')))
        .use(logger('dev'))
        .use(compression())                             
        .use(bodyParser.json())                      
        .use(bodyParser.urlencoded({ extended: false }))
        .use(connectAssets(paths: [
	    app.get('css path')
	    app.get('js path')
	    app.get('img path')
	    app.get('public path')
	]))
	.use(express.static(app.get('public path')))
        .use session
                secret:'keyboard cat'
                maxAge: new Date(Date.now() + 3600000)
                store: new MongoStore({mongooseConnection:mongoose.connection})
                saveUninitialized: true
                resave: false
        
