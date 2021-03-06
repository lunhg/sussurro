# STARTING EXPRESS
app = express()
router = express.Router()

app.set 'views', path.join(__dirname, '..', 'app/views')
app.engine 'pug', (file_path, options, _callback) ->
        fs.readFile file_path, 'utf8', (err, content) ->
                if err then _callback(err)
                fn = pug.compile content, {filename: file_path, doctype:'html'}        
                _callback null, fn(filters: [jstransformer_marked])
        
app.set 'view engine', 'pug'
#app.set 'favicon path', path.join __dirname, '..', 'app/assets/favicon.ico'
app.set 'assets path', [
        path.join __dirname, '..', 'app/assets/fonts'
        path.join __dirname, '..', 'app/assets/doc'
        path.join __dirname, '..', 'app/assets/img'
        path.join __dirname, '..', 'app/assets/css'
        path.join __dirname, '..', 'app/assets/js'
        path.join __dirname, '..', 'app/assets/'
]
