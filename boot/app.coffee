app.use(logger('dev'))
app.use(connect_assets(paths: app.get('assets path'), bundle:true))
app.use(compression())                             
app.use(body_parser.json())                      
app.use(body_parser.urlencoded(extended:false))
#app.use(favicon(app.get('favicon path')))

server = http.createServer app
server.listen process.env.PORT, ->
        addr = server.address()
        console.log chalk.cyan "Sussurro server ready on port #{process.env.PORT}"
        
