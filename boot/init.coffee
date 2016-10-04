### STARTING EXPRESS ###
app = express()
app.set 'views', path.join(__dirname, 'app/views')
app.set 'view engine', 'pug'

### uncomment after placing your favicon in /public ###
### app.use(favicon(path.join(__dirname, 'public', 'favicon.ico'))) ###
app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: false })
app.use cookieParser()
app.use sass({
        src: path.join(__dirname, '/app/assets')
        dest: path.join(__dirname, '/public')
        indentedSyntax: true
        sourceMap: true
        debug:true
        outputStyle: 'compressed'
})

app.use express.static path.join(__dirname, 'public')

app.use session
        secret:'keyboard cat'
        maxAge: new Date(Date.now() + 3600000)
        store: new MongoStore({mongooseConnection:mongoose.connection})
        saveUninitialized: true
        resave: false
        
