### Get port from environment and store in Express ###
normalizePort = (val) ->
        port = parseInt(val, 10);
        if isNaN(port)
                return val
        if port >= 0
                return port
        return false
        
port = normalizePort(process.env.PORT || '3000')
app.set('port', port)


### Create HTTP server ###
server = http.createServer(app)

### Listen on provided port, on all network interfaces ###
server.on 'error', (error) ->
        if error.syscall isnt 'listen' then throw error
        bind = if typeof port is 'string' then 'Pipe ' + port else 'Port ' + port
        fn = (msg) ->
                console.error(bind + ' '+msg)
                process.exit(1)
        # handle specific listen errors with friendly messages
        if error.code is 'EACCES'
                fn 'requires elevated privileges'
        else if error.code is 'EADDRINUSE'
                fn 'is already in use'
        else
                throw error
                
server.on 'listening', ->
        addr = server.address()
        bind = if typeof addr is 'string' then 'pipe ' + addr else 'port ' + addr.port
        console.log chalk.cyan("==> Server ready")
        console.log chalk.cyan('Listening server in ' + bind)
        
server.listen(port)

